extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var items_container: Node = $items_scroll/container
onready var items_original_button: TextureButton = $items_scroll/container/original_button

onready var enchantment_combobox: OptionButton = $ench_filter_combobox

onready var resources_container: Node = $resources
onready var resources_original_node: Node = $resources/resource1

onready var enchantment_dust_icon = load("res://files/aric_expansion_images/items/enchantment_dust.png")

const MAX_SHOWN_ENCHANTMENTS = 2
var MAX_CUSTOM_ENCHANT_LEVEL = 2

const ITEM_DEFAULT_SPARKS_MULTIPLIER = 2
const ITEM_NO_BLOOD_SPARKS_MULTIPLIER = 2
const ITEM_DEFAULT_INGREDIENT_MULTIPLIER = 0.5
const ITEM_NO_BLOOD_INGREDIENT_MULTIPLIER = 4
const ITEM_HAS_CUSTOM_ENCHANTMENTS_MULTUPLIER = 1.5
const ITEM_TIER_MULTIPLIERS = [3, 5, 7]

const EXTRACT_GRIND_DUST_DIVISOR = 5
const BOOST_DUST_COST_MULTIPLIER = 4

const SLAVE_HEALTH_LEVEL_BREAKS = [0.66, 0.33, 0.01]
const LOYAL_SLAVE_HEALTH_LEVEL_BREAKS = [0.5, 0.25, 0.01]
const SLAVE_AWAY_TIMES = [1, 3, 7]

class ItemButtonData:
	var items_list: Array
	var item_button: TextureButton

	func _init(items_list: Array, item_button: TextureButton):
		self.items_list = items_list
		self.item_button = item_button


var selected_slave
var selected_items = [null, null]

var enchantscript = load("res://files/scripts/enchantments.gd").new()
var enchant_dict: Dictionary = enchantscript.enchantmentdict
var enchantments_by_effect: Dictionary = enchantscript.enchantments_by_effect
var enchantment_creation_ingredients: Dictionary = enchantscript.enchantment_creation_ingredients
var enchant_bbcode_colors: Dictionary = enchantscript.enchant_bbcode_colors
var enchantment_names: Dictionary = {}

const AllModes = ["grind", "extract", "boost", "infuse"]

var current_mode = AllModes[0]

const ModeExplainText = {
	grind = "Select one enchanted item or enchantment, and grind it to get enchantment dust",
	extract = "Select one enchanted item and extract enchantments from it",
	boost = "Select one extracted enchantment and improve its potency",
	infuse = "Select one extracted enchantment and one item, and add enchantment to item",
}

const ModeActionText = {
	grind = "Grind item",
	extract = "Extract enchant",
	boost = "Boost enchant",
	infuse = "Infuse item",
}

const SelectItemCategory = {
	grind = ["enchanted"],
	extract = ["enchanted_item"],
	boost = ["enchantment"],
	infuse = ["applicable_enchantment", "enchantable_item"]
}


func _ready() -> void:
	init_modes()
	init_enchantment_combobox()
	init_item_panels()


func init_modes() -> void:
	var modes_box = $middle_column/modes_container
	var modes_button = $middle_column/modes_container/mode_button
	for mode in AllModes:
		var mode_button = modes_button.duplicate()
		mode_button.name = mode
		mode_button.visible = true
		mode_button.text = mode.capitalize()
		mode_button.connect("pressed", self, "on_mode_change_pressed", [mode])
		modes_box.add_child(mode_button)


func init_enchantment_combobox() -> void:
	enchantment_combobox.add_item("All items")
	enchantment_combobox.add_item("Not enchanted")
	enchantment_combobox.set_item_metadata(0, null)
	enchantment_combobox.set_item_metadata(1, "not_enchanted")
	for enchant in enchant_dict:
		if enchantments_by_effect[enchant][0] != enchant:
			continue
		
		enchantment_names[enchant] = enchant_dict[enchant].name.replace("&v ", "").replace("&100v% ", "%")
		enchantment_combobox.add_item(enchantment_names[enchant])
		enchantment_combobox.set_item_metadata(enchantment_combobox.get_item_count() - 1, enchant)


func init_item_panels():
	for panel_array in selected_item_panels.values():
		for item_index in panel_array.size():
			var panel = panel_array[item_index]
			panel.get_node("reset_button").connect("pressed", self, "reset_item", [item_index])
			panel.connect("mouse_entered", self, "display_item_panel_tooltip", [panel])
			panel.connect("mouse_exited", globals, "itemtooltiphide")
	var result_panel = $middle_column/result_item
	result_panel.connect("mouse_entered", self, "display_item_panel_tooltip", [result_panel])
	result_panel.connect("mouse_exited", globals, "itemtooltiphide")


func display_item_panel_tooltip(panel: Node) -> void:
	if panel.has_meta("tooltip_data"):
		globals.itemtooltip(panel.get_meta("tooltip_data"))


func on_selected_ench_changed(index: int) -> void:
	if index == -1:
		enchantment_combobox.select(0)
		return

	update_everything()


func on_selected_ench_reset() -> void:
	enchantment_combobox.select(0)


func fix_enchant_id(effect):
	var enchant_id = effect.get("enchant_id")
	if typeof(enchant_id) == TYPE_DICTIONARY:
		for enchantment_id in enchant_dict:
			var candidate = enchant_dict[enchantment_id]
			if candidate.name == enchant_id.name && candidate.id == enchant_id.id:
				effect.enchant_id = enchantment_id
				return


func _on_enchanting_pressed() -> void:
	for item in globals.state.unstackables.values():
		for effect in item.effects:
			fix_enchant_id(effect)
	var main = get_tree().get_current_scene()
	main.background_set("enchanting")
	yield(main, "animfinished")
	main.hide_everything()
	enchantment_combobox.select(0)
	self.visible = true
	MAX_CUSTOM_ENCHANT_LEVEL = globals.expansionsettings.enchanting_max_level

	on_mode_change_pressed(AllModes[0])
	reset_selected_item(0)
	refresh_buttons()


func refresh_buttons() -> void:
	recreate_item_buttons()
	update_everything()


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
	button.connect("pressed", self, "on_item_pressed", [item_data])

	items_container.add_child(button)
	cache_of_item_buttons[get_item_unique_id(item)] = button


func get_bbcode_colored_item_name(item) -> String:
	var item_name: String = item.name
	if item.enchant != null && item.enchant != '':
		item_name = "[color=%s]%s[/color]" % [enchant_bbcode_colors[item.enchant], item_name]
	return item_name


func get_item_text(item) -> String:
	var text: String = get_bbcode_colored_item_name(item)

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
		return null

	if !effect.has("enchant_id"):
		var enchant_id = guess_effect_enchantment_type(effect, item)
		if enchant_id == null:
			return null
		effect.enchant_id = enchant_id
	
	if deduplicate:
		return enchantments_by_effect[effect.enchant_id][0]
	return effect.enchant_id


func guess_effect_enchantment_type(effect: Dictionary, item: Dictionary):
	if effect.has("descript") && "[color=green]" in effect.descript: # let's find matching enchantments
		for enchantment_id in enchant_dict:
			var enchantment_info = enchant_dict[enchantment_id]
			if enchantment_info.id == effect.id && item.type in enchantment_info.itemtypes:
				return enchantment_id

	return null


const gearTypesOrdered: Array = ["weapon","armor","costume","underwear","accessory", "enchantment"]
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


func reset_selected_item(index: int) -> void:
	pass # TODO


func get_selecting_item_index() -> int:
	if SelectItemCategory[current_mode].size() == 1:
		return 0
	for index in selected_items.size() - 1:
		if selected_items[index] == null:
			return index
	return selected_items.size() - 1


func on_mode_change_pressed(new_mode: String) -> void:
	update_mode_buttons(new_mode)
	if new_mode == current_mode:
		return	
	current_mode = new_mode
	update_everything()


func update_mode_buttons(new_mode: String) -> void:
	$middle_column/mode_text.text = ModeExplainText[new_mode]
	for mode_button in $middle_column/modes_container.get_children():
		mode_button.pressed = mode_button.name == new_mode
	$do_action.text = ModeActionText[new_mode]


func set_result_item_data(item, icon = null, amount = null):
	$middle_column/result_item/icon.visible = true
	$middle_column/result_item.set_meta("tooltip_data", null)
	if item != null:
		$middle_column/result_item/icon.texture = globals.loadimage(item.icon)
		$middle_column/result_item.set_meta("tooltip_data", item)
	elif icon != null:
		$middle_column/result_item/icon.texture = icon
	else:
		$middle_column/result_item/icon.visible = false
	if amount != null:
		$middle_column/result_item/amount.text = str(amount)
	else:
		$middle_column/result_item/amount.text = ""


func reset_item(index: int) -> void:
	selected_items[index] = null
	update_everything()


func on_item_pressed(item_data: ItemButtonData) -> void:
	selected_items[get_selecting_item_index()] = item_data
	update_everything()


func update_everything() -> void:
	check_selected_items()
	update_dust_label()
	update_items_list()
	update_selected_items()
	update_action()


func check_selected_items() -> void:
	for index in selected_items.size():
		var item_button = selected_items[index]
		selected_items[index] = null

		if item_button == null:
			continue
		if index >= SelectItemCategory[current_mode].size():
			continue
		if item_button.items_list.size() == 0:
			continue
		var type_filter = SelectItemCategory[current_mode][index]
		var ench_filter = enchantment_combobox.get_selected_metadata()
		if !should_item_in_list_be_visible(item_button, type_filter, ench_filter):
			continue
		selected_items[index] = item_button


func update_dust_label() -> void:
	$dust_label.text = "You have %s enchantment dust" % globals.state.enchantment_dust


func update_items_list() -> void:
	var type_filter = SelectItemCategory[current_mode][get_selecting_item_index()]
	var ench_filter = enchantment_combobox.get_selected_metadata()

	for button in items_container.get_children():
		if button == items_original_button:
			continue
		var button_data = button.get_meta("item_data")
		button.visible = should_item_in_list_be_visible(button_data, type_filter, ench_filter)
		update_item_button(button_data)


func update_item_button(item_data: ItemButtonData) -> void:
	item_data.item_button.get_node("amount").text = str(item_data.items_list.size())



func should_item_in_list_be_visible(item_data: ItemButtonData, type_filter: String, ench_filter) -> bool:
	if item_data.items_list.empty():
		return false
	return should_item_be_visible(item_data.items_list[0], type_filter, ench_filter)


func should_item_be_visible(item: Dictionary, type_filter: String, ench_filter) -> bool:
	if "enchantment" in type_filter:
		if item.type != "enchantment":
			return false
	if "item" in type_filter:
		if item.type == "enchantment":
			return false
	if "enchanted" in type_filter:
		if !item.enchant in ['basic', 'custom', 'custom_blood']:
			return false
	
	if "enchantable" in type_filter:
		if !item.enchant in ['', 'basic', 'custom', 'custom_blood']:
			return false
		if selected_items[0] != null:
			var ench_orb = selected_items[0].items_list.back()
			ench_filter = self.get_effect_enchantment_type(ench_orb.effects[0], ench_orb)
	
	if ench_filter != null:
		if "enchantable" in type_filter:
			if !can_enchant_be_applied(ench_filter, item):
				return false
		else:
			var has_enchant = false
			for effect in item.effects:
				if get_effect_enchantment_type(effect, item, true) == ench_filter:
					has_enchant = true
			if !has_enchant:
				return false

	return true


onready var selected_item_panels = {
	1: [$middle_column/single_item],
	2: [$middle_column/pair_item1, $middle_column/pair_item2]
}


func update_selected_items() -> void:
	var total_item_count = SelectItemCategory[current_mode].size()
	$middle_column/pair_item1.visible = total_item_count == 2
	$middle_column/pair_item2.visible = total_item_count == 2
	$middle_column/single_item.visible = total_item_count == 1

	for index in total_item_count:
		display_selected_item(selected_items[index], selected_item_panels[total_item_count][index])


func display_selected_item(item_button: ItemButtonData, panel: Node) -> void:
	var icon_node: TextureRect = panel.get_node("icon")
	var reset_button: Button = panel.get_node("reset_button")

	icon_node.visible = item_button != null
	reset_button.visible = item_button != null
	if item_button == null:
		panel.set_meta("tooltip_data", null)
		return
	
	var item = item_button.items_list[0]
	icon_node.texture = globals.loadimage(item.icon)
	panel.set_meta("tooltip_data", item)


func update_action() -> void:
	var all_items_set = true
	for index in SelectItemCategory[current_mode].size():
		if selected_items[index] == null:
			all_items_set = false

	if !all_items_set:
		$resources_label.text = ""
		$flavor_text.bbcode_text = ""
		$slave_select_buttons_container.visible = false
		$do_action.disabled = true
		selected_slave = null
		set_result_item_data(null)
		show_price(null)
		return
	
	match current_mode:
		"grind": update_grind()
		"extract": update_extract()
		"boost": update_boost()
		"infuse": update_infuse()
		_: assert(false)


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
	var enchantment_dust_cost: int = 0
	var blood_hp_points: int = 0
	var ingredients: Dictionary = {}
	var result_item = null
	var enchantment_dust_gain: int = 0


func calculate_potency(effect: Dictionary, enchant_id: String) -> float:
	var max_power = enchant_dict[enchant_id].maxeffect
	return effect.effectvalue / max_power


func calculate_item_grind_gain(item: Dictionary) -> ResourcesPrice:
	var item_multiplier = calculate_item_multiplier(item)
	var gain = ResourcesPrice.new()
	
	for effect in item.effects:
		var enchant_id = get_effect_enchantment_type(effect, item, true)
		if enchant_id == null:
			continue
		var rarity_coeff = 0.7 if enchant_id in ["enchdmg", "enchspeed"] else 1.0
		var orb_coeff = 0.5 if item.code == 'enchantment_orb' else 1.0
		gain.enchantment_dust_gain += round(item_multiplier * calculate_potency(effect, enchant_id) * rarity_coeff * orb_coeff * 10)
	return gain


func calculate_enchantment_boost_cost(ench: Dictionary) -> ResourcesPrice:
	var new_ench = ench.duplicate(true)
	var effect = new_ench.effects[0]
	var old_effect = ench.effects[0]

	var enchant_id = get_effect_enchantment_type(effect, new_ench, false)
	new_ench.effects[0].effectvalue = max(effect.effectvalue, enchant_dict[enchant_id].maxeffect)
	enchantscript.generate_enchantment_effect_descript(new_ench, effect, enchant_id)

	var item_multiplier = ITEM_TIER_MULTIPLIERS[1]
	var cost = ResourcesPrice.new()
	var inv_potency = 1 - calculate_potency(old_effect, enchant_id)
	cost.enchantment_dust_cost = round(item_multiplier * inv_potency * 10 * BOOST_DUST_COST_MULTIPLIER)
	cost.result_item = new_ench
	return cost


func create_extracted_enchantment_item(item: Dictionary):
	for effect in item.effects:
		var enchant_id = get_effect_enchantment_type(effect, item, false)
		if enchant_id == null:
			continue
		
		var enchanted_item = globals.items.createunstackable('enchantment_orb')
		enchanted_item.enchant = item.enchant
		var effect_copy = effect.duplicate()
		effect_copy.enchant_custom_level = 1
		effect_copy.effectvalue = min(effect_copy.effectvalue, enchant_dict[enchant_id].maxeffect)
		enchantscript.generate_enchantment_effect_descript(item, effect_copy, enchant_id)
		enchanted_item.effects.append(effect_copy)
		return enchanted_item
	return null


func create_item_with_added_enchantment_effect(item: Dictionary, ench_orb: Dictionary):
	var added_effect = ench_orb.effects[0]
	var enchant_id = get_effect_enchantment_type(added_effect, ench_orb)
	var enchanted_item = item.duplicate(true)

	if !can_enchant_be_applied(enchant_id, enchanted_item):
		return null

	if item.enchant == 'custom_blood' || ench_orb.enchant == 'custom_blood':
		enchanted_item.enchant = 'custom_blood'
	else:
		enchanted_item.enchant = 'custom'

	var effects_to_add = [added_effect.duplicate()]
	enchantscript.generate_enchantment_effect_descript(enchanted_item, effects_to_add[0], enchant_id)
	
	for effect in enchanted_item.effects:
		if get_effect_enchantment_type(effect, enchanted_item) == enchant_id:
			effect.effectvalue += added_effect.effectvalue
			effect.enchant_custom_level = effect.get("enchant_custom_level", 1) + added_effect.enchant_custom_level
			enchantscript.generate_enchantment_effect_descript(enchanted_item, effect, enchant_id)
			effects_to_add = []
			break
	
	enchanted_item.effects += effects_to_add
	return enchanted_item


func calculate_item_enchantment_cost(item: Dictionary, ench_orb: Dictionary) -> ResourcesPrice:
	var enchant_effect = ench_orb.effects[0]
	var selected_enchant = get_effect_enchantment_type(enchant_effect, ench_orb)
	var item_multiplier = calculate_item_multiplier(item)
	var cost = ResourcesPrice.new()

	cost.result_item = create_item_with_added_enchantment_effect(item, ench_orb)

	var sparks_coefficient = ITEM_DEFAULT_SPARKS_MULTIPLIER
	var ingr_coefficient = ITEM_DEFAULT_INGREDIENT_MULTIPLIER
	if selected_slave != null:
		cost.blood_hp_points = calculate_blood_cost(item)
	else:
		cost.ingredients["basicsolutioning"] = 1
		ingr_coefficient *= ITEM_NO_BLOOD_INGREDIENT_MULTIPLIER
		sparks_coefficient *= ITEM_NO_BLOOD_SPARKS_MULTIPLIER

	if get_custom_enchants_count(item) > 0:
		sparks_coefficient *= ITEM_HAS_CUSTOM_ENCHANTMENTS_MULTUPLIER

	var sparks_cost = int(item_multiplier * sparks_coefficient * 10)
	cost.enchantment_dust_cost = sparks_cost

	var ingredients = enchantment_creation_ingredients[selected_enchant].essence_types
	for ingredient in ingredients:
		cost.ingredients[ingredient] = int(round(ingredients[ingredient] * item_multiplier * ingr_coefficient))

	return cost


var current_price: ResourcesPrice = ResourcesPrice.new()


func update_grind() -> void:
	var item = selected_items[0].items_list.back()
	current_price = calculate_item_grind_gain(item)
	show_price(current_price)
	$resources_label.text = "Obtained resources:"
	$flavor_text.bbcode_text = "You are going to grind this %s into enchantment dust. This will give you %s units of dust."\
							   % [get_bbcode_colored_item_name(item), current_price.enchantment_dust_gain]
	$do_action.disabled = !check_enough_resources(current_price)
	$slave_select_buttons_container.visible = false


func update_extract() -> void:
	var item = selected_items[0].items_list.back()
	var price = calculate_item_grind_gain(item)
	price.result_item = create_extracted_enchantment_item(item)
	price.enchantment_dust_gain = round(price.enchantment_dust_gain / EXTRACT_GRIND_DUST_DIVISOR)

	$slave_select_buttons_container.visible = false
	$do_action.disabled = price.result_item == null
	if price.result_item == null:
		$flavor_text.bbcode_text = "Cannot extract any enchantment from this %s." % get_bbcode_colored_item_name(item)
		return

	current_price = price
	$resources_label.text = "Obtained resources:"
	$flavor_text.bbcode_text = "You can extract `%s` enchantment from this %s."\
	% [current_price.result_item.effects[0].descript, get_bbcode_colored_item_name(item)]
	if current_price.enchantment_dust_gain > 0:
		$flavor_text.bbcode_text += " This will also give you %s units of dust." % current_price.enchantment_dust_gain
	show_price(current_price)


func update_boost() -> void:
	var ench = selected_items[0].items_list.back()
	var price = calculate_enchantment_boost_cost(ench)
	
	if ench.effects[0].effectvalue == price.result_item.effects[0].effectvalue:
		$do_action.disabled = true
		$flavor_text.bbcode_text = "Enchantment %s is already boosted to maximum possible effect."\
									% ench.effects[0].descript
		return

	$do_action.disabled = !check_enough_resources(price)
	$resources_label.text = "Required resources:"
	$flavor_text.bbcode_text = "You can boost this enchantment from %s to %s for %s enchantment dust."\
							   % [ench.effects[0].descript, price.result_item.effects[0].descript, price.enchantment_dust_cost]
	
	current_price = price
	show_price(current_price)


func update_infuse() -> void:
	var ench = selected_items[0].items_list.back()
	var item = selected_items[1].items_list.back().duplicate(true)
	var price = calculate_item_enchantment_cost(item, ench)

	$do_action.disabled = true
	$resources_label.text = "Required resources:"
	show_price(null)
	var enchant_fill_data = [get_bbcode_colored_item_name(item), ench.effects[0].descript]
	if price.result_item == null:
		$flavor_text.bbcode_text = "Cannot enchant %s with %s." % enchant_fill_data
	elif get_custom_enchants_count(price.result_item) > MAX_CUSTOM_ENCHANT_LEVEL:
		$flavor_text.bbcode_text = "You cannot enchant %s with %s.\n" % enchant_fill_data \
								+ " Resulting item will have more than %s enchantments, and you cannot fit them all on one item" % MAX_CUSTOM_ENCHANT_LEVEL
	else:
		$slave_select_buttons_container.visible = true
		$do_action.disabled = !check_enough_resources(price)
		$flavor_text.bbcode_text = get_infuse_flavor_text(price, enchant_fill_data)
		current_price = price
		show_price(price)


func get_infuse_flavor_text(price: ResourcesPrice, enchant_fill_data: Array):
	if selected_items[0] == null:
		return ""
	if selected_slave != null:
		return get_slave_flavor_text(price, enchant_fill_data)
	else:
		var ench_orb = selected_items[0].items_list.back()
		var enchant_id = get_effect_enchantment_type(ench_orb.effects[0], ench_orb)
		return enchantment_creation_ingredients[enchant_id].flavor_text


func get_custom_enchants_count(item: Dictionary) -> int:
	var custom_enchants_count = 0
	for effect in item.effects:
		custom_enchants_count += effect.get("enchant_custom_level", 0)
	return custom_enchants_count


func setup_next_resource_node(name_text: String, number_text: String, red_number: bool) -> void:
	var node = resources_original_node.duplicate()
	resources_container.add_child(node)
	node.visible = true
	node.get_node("name").text = name_text
	node.get_node("totalnumber").text = number_text
	if red_number:
		node.get_node("totalnumber").set('custom_colors/font_color', Color(1,0.29,0.29))


func show_current_price() -> void:
	show_price(current_price)


func show_price(price: ResourcesPrice) -> void:
	for node in resources_container.get_children():
		if node != resources_original_node:
			node.visible = false
			node.queue_free()

	if price == null:
		return

	var cost_format = "{0}/{1}"
	var gain_format = "+{0}"

	if price.enchantment_dust_cost > 0:
		var name = "Enchantment dust"
		var owned_dust = globals.state.enchantment_dust
		var number = cost_format.format([price.enchantment_dust_cost, owned_dust]) 
		var not_enough_resource = owned_dust < price.enchantment_dust_cost
		setup_next_resource_node(name, number, not_enough_resource)

	if selected_slave != null:
		var name = "Blood"
		var number = cost_format.format([price.blood_hp_points, selected_slave.health])
		setup_next_resource_node(name, number, false)

	for ingredient in price.ingredients:
		var name = globals.itemdict[ingredient].name
		var owned_ingredient = globals.state.getCountStackableItem(ingredient)
		var number = cost_format.format([price.ingredients[ingredient], owned_ingredient])
		var not_enough_resource = owned_ingredient < price.ingredients[ingredient]
		setup_next_resource_node(name, number, not_enough_resource)

	if price.result_item != null:
		set_result_item_data(price.result_item)
	elif price.enchantment_dust_gain > 0:
		set_result_item_data(null, enchantment_dust_icon, price.enchantment_dust_gain)

	if price.enchantment_dust_gain > 0:
		var name = "Enchantment dust"
		var number = gain_format.format([price.enchantment_dust_gain])
		setup_next_resource_node(name, number, false)


func do_action() -> void:
	match current_mode:
		"grind":
			do_grind()
		"extract":
			do_extract()
		"boost":
			do_boost()
		"infuse":
			do_infuse()
		_: assert(false)
	refresh_buttons()


func check_enough_resources(price: ResourcesPrice) -> bool:
	var enough = true

	var owned_dust = globals.state.enchantment_dust
	var required_dust = price.enchantment_dust_cost
	enough = enough && owned_dust >= required_dust

	for ingredient in price.ingredients:
		var owned_ingredient = globals.state.getCountStackableItem(ingredient)
		var required_ingredient = price.ingredients[ingredient]
		enough = enough && owned_ingredient >= required_ingredient

	return enough


func consume_resources(price: ResourcesPrice) -> bool:
	if !check_enough_resources(price):
		return false

	globals.state.enchantment_dust -= current_price.enchantment_dust_cost

	for ingredient in price.ingredients:
		var required_ingredient = price.ingredients[ingredient]
		globals.state.removeStackableItem(ingredient, required_ingredient)

	if current_mode == AllModes[3] && selected_slave != null:
		var break_level = get_slave_health_break(price)
		if break_level != -1:
			selected_slave.away.duration = SLAVE_AWAY_TIMES[break_level]
			selected_slave.away.at = "blood_donor"
		else:
			current_price.result_item.enchant = 'custom_blood'
		selected_slave.health -= price.blood_hp_points
		rebuild_slave_list()

	for item_button in selected_items:
		if item_button != null:
			var removed_item = item_button.items_list.pop_back()	
			globals.state.unstackables.erase(removed_item.id)

	globals.state.enchantment_dust += current_price.enchantment_dust_gain
	if current_price.result_item != null:
		globals.state.unstackables[current_price.result_item.id] = current_price.result_item
	return true


func deselect_slave() -> void:
	slave_selected(null)


func select_slave() -> void:
	globals.main.selectslavelist(true, "slave_selected", self, funcref(self, "slave_can_donate_blood"))


func slave_can_donate_blood(person) -> bool:
	var ench = selected_items[0].items_list.back()
	var selected_enchant_id = get_effect_enchantment_type(ench.effects[0], ench)
	for donor_race in enchantment_creation_ingredients[selected_enchant_id].donor_races:
		if donor_race in person.race:
			return true
	return false


func slave_selected(person) -> void:
	selected_slave = person
	update_everything()


func get_slave_flavor_text(price: ResourcesPrice, enchant_fill_data: Array) -> String:
	var text = "You need a lot of blood to enchant %s with %s, and $name will provide it.\n $He "
	text = selected_slave.dictionary(text % enchant_fill_data)

	var break_level = get_slave_health_break(price)
	match break_level:
		-1: text += "will likely die from blood loss"
		0:  text += "will need a day of rest to recover - %s days" % SLAVE_AWAY_TIMES[break_level]
		1:  text += "will need some time to recover - %s days" % SLAVE_AWAY_TIMES[break_level]
		2:  text += "will need a lot of time to recover - %s days" % SLAVE_AWAY_TIMES[break_level]
	return text


func get_slave_health_break(price: ResourcesPrice) -> int: # -1 means death, 0-2 means away for SLAVE_AWAY_TIMES[result]
	var slave_health_after_enchant = selected_slave.health - price.blood_hp_points
	var slave_health_percentage = slave_health_after_enchant / selected_slave.stats.health_max
	var health_breaks = SLAVE_HEALTH_LEVEL_BREAKS
	if selected_slave.obed >= 80 && selected_slave.loyal >= 25:
		health_breaks = LOYAL_SLAVE_HEALTH_LEVEL_BREAKS

	for index in health_breaks.size():
		if slave_health_percentage >= health_breaks[index]:
			return index
	return -1


func can_enchant_be_applied(enchantment_id, item) -> bool:
	if enchantment_id == null:
		return false
	if item == null:
		return false

	for equivalent_enchantment in enchantments_by_effect[enchantment_id]:
		var enchantment_info = enchant_dict[equivalent_enchantment]
		var item_subtype = item.type
		if item_subtype in enchantment_info.itemtypes:
			return true
	return false


func apply_current_cost():
	if !consume_resources(current_price):
		globals.main.popup("AricsExpansion failed to do this action! Please report it to AricsExpansion devs!")


func do_grind():
	apply_current_cost()


func do_extract():
	apply_current_cost()


func do_boost():
	apply_current_cost()


func do_infuse():
	apply_current_cost()

func rebuild_slave_list():
	get_tree().get_current_scene().rebuild_slave_list()
