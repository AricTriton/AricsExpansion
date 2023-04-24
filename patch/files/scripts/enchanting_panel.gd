extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var header_text = $enchanting_text

onready var items_container: Node = $items_scroll/container
onready var items_original_button: TextureButton = $items_scroll/container/original_button
onready var enchantment_container: Node = $enchants_scroll/enchants_list
onready var enchantment_original_node: CanvasItem = $enchants_scroll/enchants_list/enchant_line

onready var resources_container: Node = $resources
onready var resources_original_node: Node = $resources/resource1

const MAX_SHOWN_ENCHANTMENTS = 2
var MAX_CUSTOM_ENCHANT_LEVEL = 2

const ITEM_DEFAULT_SPARKS_MULTIPLIER = 2
const ITEM_NO_BLOOD_SPARKS_MULTIPLIER = 1.5
const ITEM_DEFAULT_INGREDIENT_MULTIPLIER = 0.5
const ITEM_NO_BLOOD_INGREDIENT_MULTIPLIER = 4
const ITEM_HAS_CUSTOM_ENCHANTMENTS_MULTUPLIER = 1.5
const ITEM_TIER_MULTIPLIERS = [3, 5, 8]

const SLAVE_HEALTH_LEVEL_BREAKS = [0.66, 0.33, 0.01]
const LOYAL_SLAVE_HEALTH_LEVEL_BREAKS = [0.5, 0.25, 0.01]
const SLAVE_AWAY_TIMES = [1, 3, 7]

class ItemButtonData:
	var items_list: Array
	var item_button: TextureButton

	func _init(items_list: Array, item_button: TextureButton):
		self.items_list = items_list
		self.item_button = item_button


var is_enchanting: bool = false
var cleaned_item
var selected_slave
var selected_enchant
var selected_item

var enchantment_buttons: Array

var enchantscript = load("res://files/scripts/enchantments.gd").new()
var enchant_dict: Dictionary = enchantscript.enchantmentdict
var enchantments_by_effect: Dictionary = enchantscript.enchantments_by_effect
var enchantment_creation_ingredients: Dictionary = enchantscript.enchantment_creation_ingredients
var enchant_bbcode_colors: Dictionary = enchantscript.enchant_bbcode_colors
var enchantment_names: Dictionary = {}


func _ready() -> void:
	init_enchantment_buttons()


func init_enchantment_buttons() -> void:
	for enchant in enchant_dict:
		if enchantments_by_effect[enchant][0] != enchant:
			continue

		if !globals.state.enchantment_sparks.has(enchant):
			globals.state.enchantment_sparks[enchant] = 0

		var enchant_node: CanvasItem = enchantment_original_node.duplicate()
		enchant_node.visible = true
		enchant_node.set_meta("enchantment_id", enchant)

		var button: Button = enchant_node.get_node("button")
		enchantment_names[enchant] = enchant_dict[enchant].name.replace("&v ", "").replace("&100v% ", "%")
		button.text = enchantment_names[enchant]
		button.set_meta("enchantment_id", enchant)
		button.connect("toggled", self, "on_enchantment_toggled", [enchant])

		enchantment_container.add_child(enchant_node)


func fix_enchant_id(effect):
	var enchant_id = effect.get("enchant_id")
	if typeof(enchant_id) == TYPE_DICTIONARY:
		for enchantment_id in enchant_dict:
			var candidate = enchant_dict[enchantment_id]
			if candidate.name == enchant_id.name && candidate.id == enchant_id.id:
				effect.enchant_id = enchantment_id
				return
		print_debug("")


func _on_enchanting_pressed() -> void:
	for item in globals.state.unstackables.values():
		for effect in item.effects:
			fix_enchant_id(effect)
	var main = get_tree().get_current_scene()
	main.background_set("enchanting")
	yield(main, "animfinished")
	main.hide_everything()
	self.visible = true
	MAX_CUSTOM_ENCHANT_LEVEL = globals.expansionsettings.enchanting_max_level

	set_enchanting_mode(false)
	selected_enchant = null
	selected_item = null
	refresh_buttons()


func refresh_buttons() -> void:
	recreate_item_buttons()
	update_visibility()


func get_item_unique_id(item) -> String:
	return "%s%s%s" % [item.code, item.name, item.effects]


var cache_of_item_buttons = {}
func recreate_item_buttons() -> void:
	cache_of_item_buttons = {}
	for node in items_container.get_children():
		if node != items_original_button:
			node.visible = false
			node.queue_free()

	var gear_array = []
	var gear_unique_dict = {}
	for item in globals.state.unstackables.values():
		if item.owner != null && str(item.owner) != "backpack":
			continue # item is worn by somebody

		var gear_unique_id = get_item_unique_id(item)
		if gear_unique_dict.has(gear_unique_id):
			gear_unique_dict[gear_unique_id].append(item)
		else:
			gear_array.append([item])
			gear_unique_dict[gear_unique_id] = gear_array.back()

	gear_array.sort_custom(self, "sortItemCopiesArray")

	for item_copies in gear_array:
		create_item_button(item_copies)


func create_item_button(item_copies: Array) -> void:
	var button: TextureButton = items_original_button.duplicate()
	var item_data = ItemButtonData.new(item_copies, button)
	var item = item_copies[0]
	button.set_meta("item_data", item_data)
	button.visible = true

	button.get_node("amount").text = str(item_copies.size())
	button.get_node("item_text").bbcode_text = get_item_text(item)
	if item_copies[0].icon != null:
		button.get_node("icon").texture = globals.loadimage(item.icon)

	button.connect("mouse_entered", globals, "itemtooltip", [item])
	button.connect("mouse_exited", globals, "itemtooltiphide")
	button.connect("toggled", self, "on_item_toggled", [item_data])

	items_container.add_child(button)
	cache_of_item_buttons[get_item_unique_id(item)] = button


func get_item_text(item) -> String:
	var item_name: String = item.name
	if item.enchant == "basic":
		item_name = "[color=green]%s[/color]" % item_name
	elif item.enchant == "unique":
		item_name = "[color=#cc8400]%s[/color]" % item_name

	var text: String = item_name

	var enchants_count: int = 0
	for effect in item.effects:
		if get_effect_enchantment_type(effect, item) != null:
			enchants_count += 1
			if enchants_count <= MAX_SHOWN_ENCHANTMENTS:
				text += "\n" + effect.descript

	if enchants_count > MAX_SHOWN_ENCHANTMENTS:
		text += " + %s more" % (enchants_count - 2)

	return text


func get_effect_enchantment_type(effect: Dictionary, item: Dictionary, deduplicate: bool = false):
	if typeof(effect) != TYPE_DICTIONARY:
		return null;

	if effect.has("enchant_id"):
		return effect["enchant_id"]

	if effect.has("descript") && "[color=green]" in effect.descript: # let's find matching enchantments
		for enchantment_id in enchant_dict:
			var enchantment_info = enchant_dict[enchantment_id]
			if enchantment_info.id == effect.id && item.type in enchantment_info.itemtypes:
				if deduplicate:
					return enchantments_by_effect[enchantment_id][0]
				return enchantment_id

	return null


const gearTypesOrdered: Array = ["weapon","armor","costume","underwear","accessory"]
func sortItemCopiesArray(first_array: Array, second_array: Array) -> bool:
	var first = first_array[0]
	var second = second_array[0]

	var category_compare = gearTypesOrdered.find(first.type) - gearTypesOrdered.find(second.type)
	if category_compare != 0:
		return category_compare < 0

	if first.name != second.name:
		return first.name < second.name

	if first.effects.size() != second.effects.size():
		return first.effects.size() < second.effects.size()

	for index in first.effects.size():
		if first.effects[index].descript != second.effects[index].descript:
			return first.effects[index].descript < second.effects[index].descript
	return false


func on_mode_change_pressed() -> void:
	set_enchanting_mode(!is_enchanting)


func set_enchanting_mode(is_enchanting_now: bool) -> void:
	is_enchanting = is_enchanting_now

	if is_enchanting:
		$mode_select.text = "Enchant items"
		$do_action.text = "Enchant item"
		$resources_label.text = "Required Resources:"
		$select_slave.text = "Select slave"
		$use_essences.text = "Use essences"
	else:
		$mode_select.text = "Dismantle items"
		$do_action.text = "Dismantle item"
		$resources_label.text = "Obtained Resources:"
		$select_slave.text = "Clean item"
		$use_essences.text = "Get essences"

	if selected_item != null:
		unpress_button(selected_item.item_button)
		selected_item = null
	cleaned_item = null
	update_visibility()


var is_unpressing: bool = false
func unpress_button(button: BaseButton) -> void:
	is_unpressing = true
	button.pressed = false
	is_unpressing = false


func on_enchantment_toggled(button_pressed: bool, enchant_code: String) -> void:
	if is_unpressing:
		return
	if button_pressed:
		selected_enchant = enchant_code
	else:
		selected_enchant = null

	selected_slave = null
	if selected_item != null && !should_item_be_visible(selected_item, selected_enchant):
		unpress_button(selected_item.item_button)
		selected_item = null

	for node in enchantment_container.get_children():
		if node == enchantment_original_node || node.get_meta("enchantment_id") != enchant_code:
			unpress_button(node.get_node("button"))
	update_visibility()


func on_item_toggled(button_pressed: bool, item_data: ItemButtonData) -> void:
	if is_unpressing:
		return
	if button_pressed:
		selected_item = item_data
	else:
		selected_item = null
	for button in items_container.get_children():
		if button == items_original_button || button != item_data.item_button:
			unpress_button(button)
	update_visibility()


func update_visibility() -> void:
	if selected_item != null && selected_item.items_list.empty():
		selected_item = null
	if selected_item == null:
		selected_slave = null
	if !is_enchanting && cleaned_item != null && cleaned_item != selected_item:
		deselect_slave()
		return

	for node in enchantment_container.get_children():
		if node == enchantment_original_node:
			continue
		var enchantment_id = node.get_meta("enchantment_id")
		node.visible = selected_item == null || can_enchant_be_applied(enchantment_id, selected_item)
		node.get_node("count").text = str(globals.state.enchantment_sparks[enchantment_id])

	for button in items_container.get_children():
		if button == items_original_button:
			continue
		button.visible = should_item_be_visible(button.get_meta("item_data"), selected_enchant)

	update_action()


func should_item_be_visible(item_data: ItemButtonData, enchantment_id) -> bool:
	if item_data.items_list.empty():
		return false

	item_data.item_button.get_node("amount").text = str(item_data.items_list.size())

	var item: Dictionary = item_data.items_list[0]
	if is_enchanting:
		var applicable = can_enchant_be_applied(enchantment_id, item_data)
		var can_be_enchanted = item.enchant in ['', 'custom', 'custom_blood']
		return applicable && can_be_enchanted
	else:
		if enchantment_id == null || !(item.enchant in ['basic', 'custom', 'custom_blood']):
			return false
		for effect in item.effects:
			if get_effect_enchantment_type(effect, item, true) == enchantment_id:
				return true
	return false


func update_action() -> void:
	if selected_enchant == null || selected_item == null:
		$flavor_text.bbcode_text = get_flavor_text()
		$select_slave.disabled = true
		$use_essences.disabled = true
		$do_action.disabled = true
		show_price(null)
		return

	if is_enchanting:
		update_enchant()
	else:
		update_disassemble()
	$flavor_text.bbcode_text = get_flavor_text()


func get_flavor_text() -> String:
	if selected_item && !can_enchant_current_item_further():
		return "This %s cannot be further enchanted with sparks" % selected_item.items_list[0].name
	if selected_slave != null:
		return get_slave_flavor_text()
	if selected_item != null && cleaned_item == selected_item:
		return "This will remove all enchantments from item. However, you won't get any sparks from it"
	if selected_enchant != null:
		return enchantment_creation_ingredients[selected_enchant].flavor_text
	return ""


func calculate_item_tier(item: Dictionary) -> int:
	if item.type == 'weapon':
		for effect in item.effects:
			if effect.effect == "damage":
				var damage = effect.effectvalue
				if damage >= 8:
					return 2
				elif damage >= 5:
					return 1
				else:
					return 0
		return 0
	elif item.type == 'armor':
		var tier = 0
		for effect in item.effects:
			if effect.effect == "protection":
				var protection = effect.effectvalue
				if protection >= 50:
					tier = 2
				elif protection >= 35:
					tier = 1
				else:
					tier = 0
			if get_effect_enchantment_type(effect, item) != null:
				continue
			elif effect.get("id", "") in ["armorstr", "armoragi", "armormaf", "armorend"]:
				tier += effect.effectvalue
			elif !effect.effect in ["protection", "armor"]:
				tier += 1
		return int(min(tier, 2))
	else:
		return 1


var _item_tier_cache = {}
func calculate_item_multiplier(item: Dictionary) -> int:
	if !item.code in _item_tier_cache:
		_item_tier_cache[item.code] = calculate_item_tier(item)
	return ITEM_TIER_MULTIPLIERS[_item_tier_cache[item.code]]


func calculate_blood_cost(item: Dictionary) -> int:
	return calculate_item_multiplier(item) * 25


class ResourcesPrice:
	var enchantment_sparks: Dictionary = {}
	var blood_hp_points: int = 0
	var ingredients: Dictionary = {}


func normalize_effect_value(effect_value) -> float:
	if effect_value < 1:
		return effect_value * 20
	return effect_value


func calculate_item_disassemble_gain(item: Dictionary) -> ResourcesPrice:
	var item_multiplier = calculate_item_multiplier(item)
	var gain = ResourcesPrice.new()
	if cleaned_item != null:
		return gain
	for effect in item.effects:
		var enchant_id = get_effect_enchantment_type(effect, item, true)
		if enchant_id == null:
			continue
		var enchant_sparks_gain = int(normalize_effect_value(effect.effectvalue) * item_multiplier)
		gain.enchantment_sparks[enchant_id] = gain.enchantment_sparks.get(enchant_id, 0) + enchant_sparks_gain
	return gain


func calculate_item_enchantment_cost(item: Dictionary) -> ResourcesPrice:
	var enchant_data = enchant_dict[selected_enchant]
	var item_multiplier = calculate_item_multiplier(item)
	var cost = ResourcesPrice.new()

	var sparks_coefficient = ITEM_DEFAULT_SPARKS_MULTIPLIER
	var ingr_coefficient = ITEM_DEFAULT_INGREDIENT_MULTIPLIER
	if selected_slave != null:
		cost.blood_hp_points = calculate_blood_cost(item)
	else:
		cost.ingredients["basicsolutioning"] = 1
		ingr_coefficient *= ITEM_NO_BLOOD_INGREDIENT_MULTIPLIER
		sparks_coefficient *= ITEM_NO_BLOOD_SPARKS_MULTIPLIER
	if get_custom_enchants_count() > 0:
		sparks_coefficient *= ITEM_HAS_CUSTOM_ENCHANTMENTS_MULTUPLIER

	var max_effect = max(enchant_data.get("maxeffect", 0), enchant_data.get("effectvalue", 0))
	var sparks_cost = int(normalize_effect_value(max_effect) * item_multiplier * sparks_coefficient)
	cost.enchantment_sparks[selected_enchant] = sparks_cost

	var ingredients = enchantment_creation_ingredients[selected_enchant].essence_types
	for ingredient in ingredients:
		cost.ingredients[ingredient] = int(ingredients[ingredient] * item_multiplier * ingr_coefficient)

	return cost


var current_price: ResourcesPrice = ResourcesPrice.new()


func update_disassemble() -> void:
	var item = selected_item.items_list[0]
	var item_gain = calculate_item_disassemble_gain(item)
	current_price = item_gain
	show_price(item_gain)
	$do_action.disabled = false
	$select_slave.disabled = false
	$use_essences.disabled = false


func update_enchant() -> void:
	var item = selected_item.items_list[0]
	var item_cost = calculate_item_enchantment_cost(item)
	current_price = item_cost
	show_price(item_cost)
	var blood_enabled = globals.expansionsettings.enchanting_bloody
	var can_enchant_further = can_enchant_current_item_further()
	$do_action.disabled = !can_enchant_further || !check_enough_resources(item_cost)
	$select_slave.disabled = !can_enchant_further
	$use_essences.disabled = !can_enchant_further


func get_custom_enchants_count() -> int:
	var custom_enchants_count = 0
	for effect in selected_item.items_list[0].effects:
		custom_enchants_count += effect.get("enchant_custom_level", 0)
	return custom_enchants_count


func can_enchant_current_item_further() -> bool:
	return get_custom_enchants_count() + 1 <= MAX_CUSTOM_ENCHANT_LEVEL


func setup_next_resource_node(name_text: String, number_text: String, red_number: bool) -> void:
	var node = resources_original_node.duplicate()
	resources_container.add_child(node)
	node.visible = true
	node.get_node("name").text = name_text
	node.get_node("totalnumber").text = number_text
	if red_number:
		node.get_node("totalnumber").set('custom_colors/font_color', Color(1,0.29,0.29))


func show_price(price: ResourcesPrice) -> void:
	for node in resources_container.get_children():
		if node != resources_original_node:
			node.visible = false
			node.queue_free()

	if price == null:
		return

	var number_format = "{0}/{1}" if is_enchanting else "{0}"

	for enchantment_id in price.enchantment_sparks:
		var name = enchantment_names[enchantment_id] + " sparks"
		var owned_sparks = globals.state.enchantment_sparks[enchantment_id]
		var number = number_format.format([price.enchantment_sparks[enchantment_id], owned_sparks])
		var not_enough_resource = is_enchanting && owned_sparks < price.enchantment_sparks[enchantment_id]
		setup_next_resource_node(name, number, not_enough_resource)

	if selected_slave != null:
		var name = "Blood"
		var number = number_format.format([price.blood_hp_points, selected_slave.health])
		setup_next_resource_node(name, number, false)

	for ingredient in price.ingredients:
		var name = globals.itemdict[ingredient].name
		var owned_ingredient = globals.state.getCountStackableItem(ingredient)
		var number = number_format.format([price.ingredients[ingredient], owned_ingredient])
		var not_enough_resource = is_enchanting && owned_ingredient < price.ingredients[ingredient]
		setup_next_resource_node(name, number, not_enough_resource)


func do_action() -> void:
	if is_enchanting:
		do_enchant()
	else:
		do_disenchant()
	update_visibility()


func do_enchant() -> void:
	if !can_enchant_current_item_further() || !consume_resources(current_price):
		return

	var enchanted_item = selected_item.items_list.pop_back()
	if enchanted_item.enchant == '':
		enchanted_item.enchant = 'custom'
	if enchanted_item.enchant == 'custom' && selected_slave && selected_slave.health <= 0:
		enchanted_item.enchant = 'custom_blood'

	var enchant_info = enchant_dict[selected_enchant]
	var changed_enchant = {id = enchant_info.id, type = enchant_info.type, effect = enchant_info.effect, effectvalue = 0,
					descript = "", enchant_id = selected_enchant, enchant_custom_level = 0}
	var added_effect = [changed_enchant]

	for effect in enchanted_item.effects:
		if effect.get("enchant_id") == selected_enchant && effect.has("enchant_custom_level"):
			changed_enchant = effect
			added_effect = []

	changed_enchant.enchant_custom_level += 1
	changed_enchant.effectvalue += max(enchant_info.get("effectvalue", 0), enchant_info.get("maxeffect", 0))
	enchanted_item.effects += added_effect

	var enchant_description = enchant_info.name.replace('&100v', str(changed_enchant.effectvalue*100)).replace('&v', str(changed_enchant.effectvalue))
	changed_enchant.descript = '[color=%s]%s[/color]' % [enchant_bbcode_colors[enchanted_item.enchant], enchant_description]

	selected_slave = null

	recreate_item_buttons()
	cache_of_item_buttons[get_item_unique_id(enchanted_item)].set_pressed(true)



func check_enough_resources(price: ResourcesPrice) -> bool:
	var enough = true
	for enchantment_id in price.enchantment_sparks:
		var owned_sparks = globals.state.enchantment_sparks[enchantment_id]
		var required_sparks = price.enchantment_sparks[enchantment_id]
		enough = enough && owned_sparks >= required_sparks

	for ingredient in price.ingredients:
		var owned_ingredient = globals.state.getCountStackableItem(ingredient)
		var required_ingredient = price.ingredients[ingredient]
		enough = enough && owned_ingredient >= required_ingredient

	return enough


func consume_resources(price: ResourcesPrice) -> bool:
	if !check_enough_resources(price):
		return false

	for enchantment_id in price.enchantment_sparks:
		var required_sparks = price.enchantment_sparks[enchantment_id]
		globals.state.enchantment_sparks[enchantment_id] -= required_sparks

	for ingredient in price.ingredients:
		var required_ingredient = price.ingredients[ingredient]
		globals.state.removeStackableItem(ingredient, required_ingredient)

	if selected_slave != null:
		var break_level = get_slave_health_break()
		if break_level != -1:
			selected_slave.away.duration = SLAVE_AWAY_TIMES[break_level]
			selected_slave.away.at = "blood_donor"
		selected_slave.health -= price.blood_hp_points
	return true


func deselect_slave() -> void:
	if is_enchanting:
		slave_selected(null)
	else:
		cleaned_item = null
		$do_action.text = "Dismantle item"
		update_visibility()


func select_slave() -> void:
	if is_enchanting:
		globals.main.selectslavelist(true, "slave_selected", self, funcref(self, "slave_can_donate_blood"))
	else:
		cleaned_item = selected_item
		$do_action.text = "Disenchant item"
		update_visibility()


func slave_can_donate_blood(person) -> bool:
	for donor_race in enchantment_creation_ingredients[selected_enchant].donor_races:
		if donor_race in person.race:
			return true
	return false


func slave_selected(person) -> void:
	selected_slave = person
	update_visibility()


func get_slave_flavor_text() -> String:
	var text = "You need a lot of blood to enchant %s with %s, and $name will provide it.\n $He "
	text = text % [selected_item.items_list[0].name, enchantment_names[selected_enchant]]
	text = selected_slave.dictionary(text)

	var break_level = get_slave_health_break()
	match break_level:
		-1: text += "will likely die from blood loss"
		0:  text += "will need a day of rest to recover - %s days" % SLAVE_AWAY_TIMES[break_level]
		1:  text += "will need some time to recover - %s days" % SLAVE_AWAY_TIMES[break_level]
		2:  text += "will need a lot of time to recover - %s days" % SLAVE_AWAY_TIMES[break_level]
	return text


func get_slave_health_break() -> int: # -1 means death, 0-2 means away for SLAVE_AWAY_TIMES[result]
	var slave_health_after_enchant = selected_slave.health - current_price.blood_hp_points
	var slave_health_percentage = slave_health_after_enchant / selected_slave.stats.health_max
	var health_breaks = SLAVE_HEALTH_LEVEL_BREAKS
	if selected_slave.obed >= 80 && selected_slave.loyal >= 25:
		health_breaks = LOYAL_SLAVE_HEALTH_LEVEL_BREAKS

	for index in health_breaks.size():
		if slave_health_percentage >= health_breaks[index]:
			return index
	return -1


func do_disenchant() -> void:
	var removed_item = selected_item.items_list.pop_back()
	if cleaned_item != null:
		for effect in removed_item.effects.duplicate():
			if get_effect_enchantment_type(effect, removed_item) != null:
				removed_item.effects.erase(effect)
		removed_item.enchant = ""

		recreate_item_buttons()
		cache_of_item_buttons[get_item_unique_id(removed_item)].set_pressed(true)
	else:
		globals.state.unstackables.erase(removed_item.id)
		for enchantment_id in current_price.enchantment_sparks:
			globals.state.enchantment_sparks[enchantment_id] += current_price.enchantment_sparks[enchantment_id]


func can_enchant_be_applied(enchantment_id, item) -> bool:
	if enchantment_id == null:
		return false
	if item == null || item.items_list.empty():
		return false

	for equivalent_enchantment in enchantments_by_effect[enchantment_id]:
		var enchantment_info = enchant_dict[equivalent_enchantment]
		var item_subtype = item.items_list[0].type
		if item_subtype in enchantment_info.itemtypes:
			return true
	return false
