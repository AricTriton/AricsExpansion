
func show():
	var newbutton
	var group
	var text = ''
	get_parent().checkplayergroup()
	get_parent()._on_mansion_pressed()
	if OS.get_name() != 'HTML5' && globals.rules.fadinganimation == true:
		yield(get_parent(), 'animfinished')
	self.visible = true
	for i in get_node("grouppanel/ScrollContainer/VBoxContainer").get_children():
		if i != get_node("grouppanel/ScrollContainer/VBoxContainer/Button"):
			i.visible = false
			i.queue_free()
	for person in globals.slaves:
		if person.away.at == 'hidden':
			continue
		newbutton = get_node("grouppanel/ScrollContainer/VBoxContainer/Button").duplicate()
		get_node("grouppanel/ScrollContainer/VBoxContainer").add_child(newbutton)
		newbutton.visible = true
		newbutton.set_text(person.name_long() + ' ' + person.race)
		if globals.state.playergroup.has(str(person.id)):
			newbutton.set_pressed(true)
		###---Added by Expansion---### Join Consent
#		elif globals.state.playergroup.size() >= 3 || person.energy <= 10 || person.stress >= 80 || person.loyal + person.obed < 80 || person.sleep == 'jail' || person.away.duration != 0 || person.consentexp.party == false && person.unique == null || person.movement == 'none':
#			newbutton.set_disabled(true)
		elif globals.state.playergroup.size() >= 3:
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
		###---End Expansion---###
		newbutton.connect("pressed",self,'addtogroup',[person, newbutton])
	if globals.state.playergroup.size() <= 0:
		text = 'You have no assigned followers'
	else:
		text = 'You will be accompanied by:\n'
	for i in globals.state.playergroup:
		group = globals.state.findslave(i)
		text = text + group.name_long() + ', ' + group.race +', Level: ' +  str(group.level) + ', Health: '+str(round(group.health)) + ", Energy: "+ str(round(group.energy))+  '\n'
	get_node("grouppanel/grouplabel").set_bbcode(text)
	#updateitemsinventory()
	#updateitemsbackpack()
	#calculateweight()
