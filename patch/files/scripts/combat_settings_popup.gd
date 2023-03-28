extends Popup

# Meta variable names
const META_CONTAINER_NAME = "container_name"
const META_INDEX = "container_index"
const META_HINT_TEXT = "hint_text"

# META_CONTAINER_NAME values 
const ALL_SKILLS_NAME = "all_skills"
const ACTIVE_SKILLS_NAME = "active_skills"
const AUTO_SKILLS_NAME = "auto_skills"


var trash_texture = load("res://files/aric_expansion_images/skill_icons/TrashCan.png")
var add_skill_texture = load("res://files/aric_expansion_images/skill_icons/AddSkill.png")

# Label for currently selected persons name
var person_label: Label

# Container with all_skills buttons
var all_skills_container: GridContainer

# Buttons for skills in all_skills
var all_skills_buttons: Array

# Container with active_skills buttons
var active_skills_container: GridContainer

# Buttons for skills in active_skills
var active_skills_buttons: Array

# Buttons (currently 1) for add and delete actions in active_skills
var active_skills_add_buttons: Array

# Container with auto_skills buttons
var auto_skills_container: GridContainer

# Buttons for skills in auto_skills
var auto_skills_buttons: Array

# Buttons (currently 1) for add and delete actions in auto_skills
var auto_skills_add_buttons: Array

# All skills person knows
var all_skills = []

# Skills that person will have in fight
var active_skills = []

# Skills that person will use for auto-attack
var auto_skills = []

# Current person whose skills are being changed
var current_person

# Skills present on opening edit, to use for discarding
var old_all_skills
var old_active_skills
var old_auto_skills


# Ensure container has at least visible_count visible buttons and invisible_count invisible buttons
# Return [array of visible buttons, array of invisible buttons]
func ensure_buttons(container: GridContainer, visible_count: int, invisible_count: int, container_name: String) -> Array:
	var original_button = container.get_node("original_button")
	var total_count = invisible_count + visible_count
	var buttons = []

	for button in container.get_children():
		if button == original_button:
			continue		
		button.visible = buttons.size() < visible_count
		if buttons.size() < total_count:
			buttons.append(button)
	
	while buttons.size() < total_count:
		var button = create_new_button(container, original_button, container_name, buttons.size())
		button.visible = buttons.size() < visible_count
		buttons.append(button)
	
	var visible_buttons = []
	if visible_count > 0:
		visible_buttons = buttons.slice(0, visible_count - 1)
	var invisible_buttons = []
	if invisible_count > 0:
		invisible_buttons = buttons.slice(visible_count, total_count - 1)
	
	return [visible_buttons, invisible_buttons]


func set_skill_textures(buttons: Array, abilities: Array) -> void:
	for index in buttons.size():
		var button = buttons[index]
		var ability = abilities[index]
		button.texture_normal = ability.iconnorm
		var hint_text = '[center]%s[/center]\n\n%s' % [ability.name, ability.description]
		button.set_meta(META_HINT_TEXT, hint_text)


func show_ability_tooltip(button: TextureButton) -> void:
	if button.has_meta(META_HINT_TEXT):
		var tooltip = button.get_meta(META_HINT_TEXT)
		globals.showtooltip(tooltip)


func hide_tooltip() -> void:
	globals.hidetooltip()


func create_new_button(container: GridContainer, original_button: TextureButton,
					   container_name: String, index: int) -> TextureButton:
	var new_button = original_button.duplicate()
	container.add_child(new_button)
	new_button.set_drag_forwarding(self)
	new_button.set_meta(META_CONTAINER_NAME, container_name)
	new_button.set_meta(META_INDEX, index)
	new_button.connect("mouse_entered",self,'show_ability_tooltip',[new_button])
	new_button.connect("mouse_exited",self,'hide_tooltip')
	return new_button


static func load_skills_from_names(ability_list: Array) -> Array:
	var result = []
	for skill_id in ability_list:
		result.append(globals.abilities.abilitydict[skill_id])
	return result


static func check_all_skills_learned(all_skills: Array, checked_skills: Array) -> void:
	var index = 0
	while index < checked_skills.size():
		if all_skills.has(checked_skills[index]):
			index += 1
		else:
			checked_skills.remove(index)


func enforce_ability_constraints() -> void:
	check_all_skills_learned(all_skills, active_skills)
	check_all_skills_learned(all_skills, auto_skills)

	for index in range(auto_skills.size() - 1, -1, -1):
		if auto_skills[index].targetgroup != "enemy":
			auto_skills.remove(index)
	
	var attack_skill = globals.abilities.abilitydict["attack"]
	if not auto_skills.has(attack_skill):
		auto_skills.append(attack_skill)


# Ensure each ability list has all current abilities with proper icons, and add buttons also have proper icons
func recalc_buttons() -> void:
	enforce_ability_constraints()
	
	current_person.ability = get_ability_names_array(all_skills)
	current_person.abilityactive = get_ability_names_array(active_skills)
	current_person.ability_autoattack = get_ability_names_array(auto_skills)

	all_skills_buttons = ensure_buttons(all_skills_container, all_skills.size(), 0, ALL_SKILLS_NAME)[0]
	var active_skills_buttons_pair = ensure_buttons(active_skills_container, active_skills.size(), 1, ACTIVE_SKILLS_NAME)
	var auto_skills_buttons_pair = ensure_buttons(auto_skills_container, auto_skills.size(), 1, AUTO_SKILLS_NAME)

	active_skills_buttons = active_skills_buttons_pair[0]
	auto_skills_buttons = auto_skills_buttons_pair[0]

	active_skills_add_buttons = active_skills_buttons_pair[1]
	auto_skills_add_buttons = auto_skills_buttons_pair[1]

	set_skill_textures(all_skills_buttons, all_skills)
	set_skill_textures(active_skills_buttons, active_skills)
	set_skill_textures(auto_skills_buttons, auto_skills)


func move_data(from_container: String, from_index: int, to_container: String, to_index: int) -> void:
	var container_skills = {ALL_SKILLS_NAME: all_skills, ACTIVE_SKILLS_NAME: active_skills, AUTO_SKILLS_NAME: auto_skills}

	if from_container == to_container:
		move_ability(container_skills[from_container], from_index, to_index)
	elif from_container == ALL_SKILLS_NAME:
		add_new_ability(from_index, container_skills[to_container], to_index)
	
	recalc_buttons()


func add_new_ability(from_index: int, to_ability_array: Array, to_index: int) -> void:
	var added_ability = all_skills[from_index]
	if to_ability_array.has(added_ability):
		from_index = to_ability_array.find(added_ability)
		if to_index > from_index:
			to_index -= 1
		move_ability(to_ability_array, from_index, to_index)
	elif to_index < to_ability_array.size():
		to_ability_array.insert(to_index, added_ability)
	else:
		to_ability_array.push_back(added_ability)


func move_ability(ability_array: Array, from_index: int, to_index: int) -> void:
	if from_index == to_index:
		return
	var moved_ability = ability_array[from_index]
	ability_array.remove(from_index)
	if to_index <= ability_array.size():
		ability_array.insert(to_index, moved_ability)	


func on_move_from(from_container: String, from_index: int) -> void:
	if from_container == ALL_SKILLS_NAME:
		active_skills_add_buttons[0].texture_normal = add_skill_texture
		active_skills_add_buttons[0].visible = true
		auto_skills_add_buttons[0].texture_normal = add_skill_texture
		auto_skills_add_buttons[0].visible = true

	if from_container == ACTIVE_SKILLS_NAME and from_index <= active_skills.size():
		active_skills_add_buttons[0].texture_normal = trash_texture
		active_skills_add_buttons[0].visible = true

	if from_container == AUTO_SKILLS_NAME and from_index <= auto_skills.size():
		auto_skills_add_buttons[0].texture_normal = trash_texture
		auto_skills_add_buttons[0].visible = true


func control_has_meta(control: Control) -> bool:
	return control.has_meta(META_CONTAINER_NAME) and control.has_meta(META_INDEX)


func can_drop_data_fw(position, data, from_control) -> bool:
	if typeof(data) != TYPE_DICTIONARY or not data.has_all([META_CONTAINER_NAME, META_INDEX]):
		return false
	if !control_has_meta(from_control):
		return false
	var from_container = data[META_CONTAINER_NAME]
	var to_container = from_control.get_meta(META_CONTAINER_NAME)
	return from_container == ALL_SKILLS_NAME or from_container == to_container


func drop_data_fw(position, data, from_control) -> void:
	if not can_drop_data_fw(position, data, from_control):
		return
	move_data(data[META_CONTAINER_NAME], data[META_INDEX],
			  from_control.get_meta(META_CONTAINER_NAME), from_control.get_meta(META_INDEX))


func get_drag_data_fw(position, from_control : TextureButton):
	if not control_has_meta(from_control):
		return null
	var container_name = from_control.get_meta(META_CONTAINER_NAME)
	var index = from_control.get_meta(META_INDEX)
	
	var preview_object = from_control.duplicate()
	preview_object.connect("tree_exiting", self, "hide_add_buttons")
	set_drag_preview(preview_object)
	on_move_from(container_name, index)
	hide_tooltip()
	return {META_CONTAINER_NAME: container_name, META_INDEX: index}


func hide_add_buttons() -> void:
	for button in active_skills_add_buttons:
		button.visible = false
	for button in auto_skills_add_buttons:
		button.visible = false


func get_ability_names_array(abilities_array: Array) -> Array:
	var names_array = []
	for ability in abilities_array:
		names_array.append(ability.code)
	return names_array


func set_person(person) -> void:
	current_person = person
	
	person_label.text = "Skill settings for " + person.name_long() + " " + person.race

	old_all_skills = person.ability
	old_active_skills = person.abilityactive
	old_auto_skills = person.ability_autoattack
	
	all_skills = load_skills_from_names(person.ability)
	active_skills = load_skills_from_names(person.abilityactive)
	auto_skills = load_skills_from_names(person.ability_autoattack)
	
	recalc_buttons()


func _on_save_button_pressed() -> void:
	hide()


func _on_reset_button_pressed() -> void:
	active_skills = all_skills
	auto_skills = []
	recalc_buttons()


func _on_discard_button_pressed() -> void:
	current_person.ability = old_all_skills
	current_person.abilityactive = old_active_skills
	current_person.ability_autoattack = old_auto_skills
	hide()


func _ready() -> void:
	person_label = get_node("panel/person_label")
	all_skills_container = get_node("panel/all_skills/scroll/container")
	active_skills_container = get_node("panel/active_skills/scroll/container")
	auto_skills_container = get_node("panel/auto_skills/scroll/container")
