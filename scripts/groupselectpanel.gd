extends Panel

# Store pair of [person, button] for each slave not away, to choose for party 
var group_select_persons_buttons: Array = []

# Store MAX_PARTY_SIZE buttons for changing combat prefs of party members
var combat_settings_buttons: Array = []

# Store MAX_PARTY_SIZE persons in combat party, their combat prefs can be changed
var combat_settings_persons: Array = []

const MAX_PARTY_SIZE = 4


func show() -> void:
	get_parent().checkplayergroup()
	get_parent()._on_mansion_pressed()
	if OS.get_name() != 'HTML5' && globals.rules.fadinganimation == true:
		yield(get_parent(), 'animfinished')
	self.visible = true
	recreate_group_selection()
	recreate_combat_settings()


func recreate_group_selection() -> void:	
	var scroll_node = get_node("grouppanel/slave_list_scroll/vbox")
	group_select_persons_buttons = update_list(scroll_node, globals.slaves)
	for person_button in group_select_persons_buttons:
		var newbutton = person_button[1]
		newbutton.connect("pressed", self, 'addtogroup', person_button)

	update_group_selection()


func update_group_selection() -> void:
	update_group_selection_buttons()
	update_group_tooltip()


# Deletes old and creates new buttons for each person in array persons, returns array of pairs [person, button]
static func update_list(vbox_container: Node, persons: Array) -> Array:
	var original_button = vbox_container.get_node("original_button")

	# Remove all buttons not equal to original_button from vbox_container 
	for button in vbox_container.get_children():
		if button != original_button:
			button.visible = false
			button.queue_free()
	# Create new buttons for each slave and player, then call "self.new_button_callback" on each
	var added_buttons = []
	for person in persons:
		if person.away.at == 'hidden':
			continue
		var newbutton = create_new_button(original_button, vbox_container)
		added_buttons.append([person, newbutton])
	return added_buttons


# Create new button and return it
static func create_new_button(original_button: Node, vbox_container: Node) -> Node:
	var newbutton = original_button.duplicate()
	vbox_container.add_child(newbutton)
	newbutton.visible = true
	return newbutton


# Update name, tooltip and state for adding to group buttons
func update_group_selection_buttons() -> void:
	for person_button in group_select_persons_buttons:
		var person = person_button[0]
		var newbutton = person_button[1]
		newbutton.set_text(person.name_long() + ' ' + person.race)
		if globals.state.playergroup.has(str(person.id)):
			newbutton.set_disabled(false)
			newbutton.set_pressed(true)
		###---Added by Expansion---### Join Consent
		elif globals.state.playergroup.size() + 1 >= MAX_PARTY_SIZE:
			newbutton.set_disabled(true)
			newbutton.set_tooltip(person.dictionary('You have too many people in your party for $name to join.'))
		elif person.energy <= 10:
			newbutton.set_disabled(true)
			newbutton.set_tooltip(person.dictionary('$name is too tired to travel.'))
		elif person.stress >= 80:
			newbutton.set_disabled(true)
			newbutton.set_tooltip(person.dictionary('$name is too stressed out to handle a potentially dangerous journey.'))
		elif person.sleep == 'jail':
			newbutton.set_disabled(true)
			newbutton.set_tooltip(person.dictionary('It would be hard for $name to come with you from inside the jail.'))
		elif person.away.duration != 0:
			newbutton.set_disabled(true)
			newbutton.set_tooltip(person.dictionary('$name is currently away from the mansion.'))
		elif person.consentexp.party == false && (person.unique == null || globals.expansionsettings.uniqueslavesautopartyconsent == false):
			newbutton.set_disabled(true)
			newbutton.set_tooltip(person.dictionary('$name has never agreed to accompany you (Consent: Talk>Consent>Travel With).'))
		elif person.movement == 'none':
			newbutton.set_disabled(true)
			newbutton.set_tooltip(person.dictionary('$name cannot move right now, much less travel.'))
		else:
			newbutton.set_disabled(false)
			newbutton.set_pressed(false)
		###---End Expansion---###
	update_group_tooltip()


#Update label with group list
func update_group_tooltip() -> void:
	var text = ''
	if globals.state.playergroup.size() <= 0:
		text = 'You have no assigned followers'
	else:
		text = 'You will be accompanied by:\n'
	for i in globals.state.playergroup:
		var person = globals.state.findslave(i)
		text = text + '%s, %s, Level: %s, Health: %s, Energy: %s\n' % [person.name_long(), person.race, person.level, round(person.health), round(person.energy)]
	get_node("grouppanel/grouplabel").set_bbcode(text)


func addtogroup(person, button) -> void:
	if button.is_pressed() == true:
		globals.state.playergroup.append(person.id)
	else:
		globals.state.playergroup.remove(globals.state.playergroup.find(person.id))
	update_group_selection()
	update_combat_settings_buttons()


func update_combat_settings_buttons() -> void:
	combat_settings_persons = [globals.player]
	for slave_id in globals.state.playergroup:
		combat_settings_persons.append(globals.state.findslave(slave_id))
	
	for index in MAX_PARTY_SIZE:
		var button = combat_settings_buttons[index]
		if index >= combat_settings_persons.size():
			button.visible = false
			continue
		var person = combat_settings_persons[index]
		button.set_text(person.name_long() + ' ' + person.race)
		button.visible = true


func recreate_combat_settings() -> void:
	var vbox_container = get_node("grouppanel/combat_settings_scroll/vbox")

	var max_party_array = []
	max_party_array.resize(MAX_PARTY_SIZE)
	max_party_array.fill(globals.player)
	var combat_settings_persons_buttons = update_list(vbox_container, max_party_array)

	combat_settings_buttons = []
	for index in MAX_PARTY_SIZE:
		var newbutton = combat_settings_persons_buttons[index][1]
		newbutton.connect("pressed", self, 'show_combat_settings_for_index', [index])
		combat_settings_buttons.append(newbutton)
	
	update_combat_settings_buttons()


func show_combat_settings_for_index(index: int) -> void:
	var person = combat_settings_persons[index]
	var node = get_node("grouppanel/combat_settings_popup")
	node.set_person(person)
	node.popup()


func _on_closegroup_pressed() -> void:
	self.visible = false
	get_parent()._on_mansion_pressed()
