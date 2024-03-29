
var categories = {everything = true, potion = false, ingredient = false, gear = false, supply = false}
var selected_gear_categories = {}

var enchantscript = load("res://files/scripts/enchantments.gd").new()
var enchant_colors: Dictionary = enchantscript.enchant_colors


func _ready():	
	for i in ['costume','weapon','armor','accessory','underwear']:
		var item_node = "gearpanel/" + i
		get_node(item_node).connect("pressed", self, 'gearinfo', [i])
		get_node(item_node).connect("mouse_entered", self, 'geartooltip', [i])
		get_node(item_node + '/TextureFrame').connect("mouse_entered", self, 'geartooltip', [i])
		get_node(item_node + '/TextureFrame').connect("mouse_exited", globals, 'itemtooltiphide')
		get_node(item_node + "/unequip").connect("pressed", self, 'unequip', [i])
		get_node(item_node + "/filter_by_slot").connect("pressed", self, 'filter_gear', [i])
		get_node(item_node + "/unequip_2x").connect("pressed", self, 'unequip', [i])
		get_node(item_node + "/filter_by_slot_2x").connect("pressed", self, 'filter_gear', [i])
	
	for i in get_tree().get_nodes_in_group("invcategory"):
		i.connect("pressed",self,'selectcategory',[i])
	setup_auto_management()


func selectcategory(button):
	if button.get_name() == 'everything':
		for i in get_tree().get_nodes_in_group('invcategory'):
			i.set_pressed(i == button)
	else:
		categories.everything = false
		get_node("everything").set_pressed(false)
	for i in categories:
		categories[i] = get_node(i).is_pressed()
	selected_gear_categories.clear()
	categoryitems()


func categoryitems():
	for i in get_node("ScrollContainer/GridContainer/").get_children():
		i.visible = item_should_be_visible(i)


func item_should_be_visible(button) -> bool:
	if not button.has_meta('category'):
		return false   # original button which we duplicate
	var item = button.get_meta('item')
	if filter != '' and item.name.findn(filter) < 0 and item.description.findn(filter) < 0:
		return false   # item does not match search string
	if categories.everything:
		return true    # show everything
	
	var item_category = button.get_meta('category')
	if not categories.get(item_category, false):
		return false   # category not selected or not in categories list, like 'quest'
	
	if item_category == 'gear': # additional filter by gear type
		var itemarray = button.get_meta("itemarray")
		if itemarray.size() == 0:
			return false
		var gear_type = itemarray[0].type
		return selected_gear_categories.empty() or selected_gear_categories.has(gear_type) 
	
	return true


func filter_gear(gear_type):
	for i in categories:
		categories[i] = false
		get_node(i).set_pressed(false)
	
	categories.gear = true	
	selected_gear_categories = {gear_type: true}
	categoryitems()


func create_item_button(i: Dictionary, amount: int, category: String, move_callback: String) -> Node:	
	var button = get_node("ScrollContainer/GridContainer/Button").duplicate()
	button.visible = true

	button.set_meta('item', i)
	button.set_meta("number", amount)
	button.set_meta("category", category)

	button.get_node('number').set_text(str(amount))
	button.get_node("Label").set_text(i.name)

	button.connect("mouse_entered", globals, 'itemtooltip', [i])
	button.connect("mouse_exited", globals, 'itemtooltiphide')
	button.get_node("move").connect("pressed", self, 'move_item', [button, move_callback])
	button.get_node("use").connect("pressed",self,'use',[button])

	itemgrid.add_child(button)	
	return button


func fill_items_list_non_gear(stackable_items: Array, stackable_amount: Dictionary, move_callback: String) -> void:
	var stackable_array = []
	
	for i in stackable_items:
		var item_amount = stackable_amount.get(i.code, i.amount)
		if item_amount < 1 || i.type in ['gear','dummy']:
			continue
		stackable_array.append(i)
	
	stackable_array.sort_custom(globals.items,'sortitems')
	
	for i in stackable_array:
		var item_amount = stackable_amount.get(i.code, i.amount)
		var button = create_item_button(i, item_amount, i.type, move_callback)

		button.get_node("use").visible = i.type == 'potion' || i.code == 'bandage'
			
		if i.icon != null:
			button.get_node("icon").set_texture(i.icon)
	

func fill_items_list_gear(gear_owner, move_callback: String) -> void:
	var gear_array = []
	var gear_unique_dict = {}
	
	for i in globals.state.unstackables.values():
		if (i.owner != null && str(i.owner) != 'backpack') && globals.state.findslave(i.owner) == null && str(i.owner) != globals.player.id:
			i.owner = null
		if i.owner != gear_owner:
			continue
		
		var gear_unique_id = "%s%s%s" % [i.code, i.name, i.effects]
		if gear_unique_dict.has(gear_unique_id):
			gear_unique_dict[gear_unique_id].append(i)
		else:
			gear_array.append([i])
			gear_unique_dict[gear_unique_id] = gear_array.back()
	
	gear_array.sort_custom(self, 'sortgear')
	
	for i in gear_array:
		var button = create_item_button(i[0], i.size(), 'gear', move_callback)
		
		button.set_meta("itemarray", i)
		button.get_node("use").set_tooltip("Equip")
		button.get_node("rename").visible = true
		button.get_node("rename").connect("pressed",self,"renameitem",[i[0]])

		if i[0].enchant in enchant_colors:
			button.get_node("Label").set('custom_colors/font_color', enchant_colors[i[0].enchant])
		if i[0].icon != null:
			button.get_node("icon").set_texture(globals.loadimage(i[0].icon))


func fill_items_list_common(stackable_items: Array, stackable_amount: Dictionary, gear_owner, move_callback: String) -> void:
	fill_items_list_non_gear(stackable_items, stackable_amount, move_callback)
	fill_items_list_gear(gear_owner, move_callback)


func itemsinventory():
	fill_items_list_common(globals.itemdict.values(), {}, null, 'movetobackpack')


func itemsbackpack():
	var stackable_items = []
	for item_code in globals.state.backpack.stackables:
		stackable_items.append(globals.itemdict[item_code])
	
	fill_items_list_common(stackable_items, globals.state.backpack.stackables, 'backpack', 'movefrombackpack')


func move_item(button, direction) -> void:
	var to_backpack = direction == 'movetobackpack'
	var move_all = Input.is_key_pressed(KEY_SHIFT)
	var item = button.get_meta('item')
	var new_item_count = 0
	if item.has('owner') == false:
		new_item_count = move_stackable(item, to_backpack, move_all)
	else:
		new_item_count = move_unstackable(button.get_meta('itemarray'), to_backpack, move_all)

	button.get_node('number').set_text(str(new_item_count))
	if new_item_count == 0:
		button.visible = false
		button.queue_free()
	calculateweight()


func move_stackable(item: Dictionary, to_backpack: bool, move_all: bool) -> int:
	var backpack_stackables = globals.state.backpack.stackables

	var moved_to_backpack = 1 if to_backpack else -1
	if move_all && to_backpack:
		moved_to_backpack = item.amount
	elif move_all && !to_backpack:
		moved_to_backpack = -backpack_stackables[item.code]
	
	item.amount -= moved_to_backpack
	backpack_stackables[item.code] = backpack_stackables.get(item.code, 0) + moved_to_backpack
	if backpack_stackables[item.code] == 0:
		backpack_stackables.erase(item.code)
	
	if to_backpack:
		return item.amount
	else:
		return backpack_stackables.get(item.code, 0)


func move_unstackable(itemarray: Array, to_backpack: bool, move_all: bool) -> int:
	var new_owner = 'backpack' if to_backpack else null
	var items_to_remove = itemarray if move_all else [itemarray.pop_back()] 
	for item in items_to_remove:
		item.owner = new_owner
	items_to_remove.clear()
	return itemarray.size()


func slavelist():
	for i in get_node("slavelist/GridContainer").get_children():
		if i.get_name() != 'Button':
			i.visible = false
			i.queue_free()
	$slavelist/GridContainer.rect_size = $slavelist/GridContainer.rect_min_size
	
	if globals.state.inventory_settings.get("party_members_first", true):
		var party = [globals.player]
		var nonparty = []
		for i in globals.slaves:
			if i.id in globals.state.playergroup:
				party.append(i)
			else:
				nonparty.append(i)
		create_persons_buttons(party)
		var separator: HSeparator = HSeparator.new()
		separator.add_constant_override("separation", 20)
		$slavelist/GridContainer.add_child(separator)
		create_persons_buttons(nonparty)
	else:
		create_persons_buttons([globals.player] + globals.slaves)


func create_persons_buttons(persons_array: Array):
	for i in persons_array:
		if i.away.duration != 0:
			continue
		var button = $slavelist/GridContainer/Button.duplicate()
		$slavelist/GridContainer.add_child(button)
		button.visible = true
		
		var text = i.name_long() + " [color=yellow]" + i.race + "[/color]"
		if i == globals.player:
			text += " [color=aqua]Master[/color]"
		else:
			text += " " + i.origins.capitalize()
		button.get_node("name").set_bbcode(text)
		button.get_node("hpbar").set_value(float((i.stats.health_cur)/float(i.stats.health_max))*100)
		button.get_node("enbar").set_value(float((i.stats.energy_cur)/float(i.stats.energy_max))*100)
		if i.imageportait != null:
			button.get_node("portrait").set_texture(globals.loadimage(i.imageportait))
		for k in ['sstr','sagi','smaf','send']:
			button.get_node(k).set_text(str(i[k])+ "/" +str(min(i.stats[globals.maxstatdict[k]], i.originvalue[i.origins])))
		button.connect("pressed",self,'selectslave',[button])
		button.pressed = i==selectedslave
		button.set_meta('person', i)


###---Added by Expansion---### Minor Tweaks by Dabros Integration
func _input(event):
	## CHANGED NEW - 26/5/19 - for allowing prev/next keys for slave selection
	if event.is_action_pressed("ui_up") && get_node("slavelist/GridContainer").is_visible_in_tree():
		my_gotoslave_prev()
	if event.is_action_pressed("ui_down") && get_node("slavelist/GridContainer").is_visible_in_tree():
		my_gotoslave_next()
	## END OF CHANGED

func my_gotoslave_prev():
	## CHANGED NEW - 26/5/19 - for allowing prev/next keys for slave selection
	var prevslave
	for i in $slavelist/GridContainer.get_children():
		if i.has_meta('person') && i.get_meta('person') == selectedslave:
			if prevslave && prevslave.has_meta('person'):
				selectslave(prevslave)
			return
		prevslave = i
	## END OF CHANGED

func my_gotoslave_next():
	## CHANGED NEW - 26/5/19 - for allowing prev/next keys for slave selection
	var found = false
	for i in $slavelist/GridContainer.get_children():
		if found && i.has_meta('person'):
			selectslave(i)
			return
		elif i.has_meta('person') && i.get_meta('person') == selectedslave:
			found = true
	## END OF CHANGED
###---End Expansion---###

func slavegear(person):
	var text = ''
	text += person.name_short() + "\nHealth: " + str(person.health) + "/" + str(person.stats.health_max) + '\nEnergy: ' + str(round(person.energy)) + '/' + str(person.stats.energy_max) + '\n'
	###---Added by Expansion---### Minor Tweaks by Dabros Integration
	## CHANGED - 25/5/19 - expanded slave summary in gear/equip screen
	## NOTE - 27/5/19 - since max varies a lot (uncivilised, rebellious, ect), decided no color for obed now, maybe after i look into this more
	text += "Obedience: " + str(round(person.obed)) + "/" + str(person.stats.obed_max)+"\n"

	if person.lust >= person.stats.lust_max:
		text += "[color=yellow]"
	text += "Lust: " + str(round(person.lust)) + "/" + str(person.stats.lust_max)+"\n"
	if person.lust >= person.stats.lust_max:
		text += "[/color]"

	if person.stress >= person.stats.stress_max:
		text += "[color=yellow]"
	text += "Stress: " + str(round(person.stress)) + "/" + str(person.stats.stress_max)+"\n"
	if person.stress >= person.stats.stress_max:
		text += "[/color]"

	if person.fear >= (100+person.wit/2):
		text += "[color=yellow]"
	text += "Fear: " + str(person.fear) + "/" + str(100+person.wit/2)+"\n" ## NOTE - 'max' taken from globals.gd->person.fear_set()
	if person.fear >= (100+person.wit/2):
		text += "[/color]"

	## text += "Luxury: " + str(person.lust) + "/" + str(person.stats.lust_max)+"\n"
	if(person.lactation):
		text += "[color=yellow]Lactating as a " + str(person.sex) +"[/color]\n"
		## + "\n" + getdescription("titssize") + gettitsextra() + getdescription("asssize") + lowergenitals()
	## END OF CHANGED
	###---End Expansion---###
	for i in person.gear:
		if person.gear[i] == null:
			continue
		if globals.state.unstackables.has(person.gear[i]) == false:
			person.gear[i] = null
			continue
		var tempitem = globals.state.unstackables[person.gear[i]]
		for k in tempitem.effects:
			text += k.descript + "\n"
	get_node("gearpanel/RichTextLabel").set_bbcode(text)
	get_node("gearpanel").visible = true
	var sex
	var race
	sex = person.sex.replace('futanari','female').replace('dickgirl','female')
	race = person.race
	###---Added by Expansion---### Races Expanded
	if person.findRace(['Dark Elf', 'Tribal Elf']):
		race = 'Elf'
	###---Expansion End---###
	if globals.loadimage(person.imagefull) != null:
		$gearpanel/charframe.texture = globals.loadimage(person.imagefull)
	elif nakedspritesdict.has(person.unique):
		$gearpanel/charframe.texture = globals.spritedict[nakedspritesdict[person.unique].clothcons]
	else:
		get_node("gearpanel/charframe").set_texture(globals.loadimage(globals.races[race.replace("Halfkin", "Beastkin")].shade[sex]))
	
	for i in ['weapon','costume','underwear','armor','accessory']:
		if person.gear[i] == null:
			get_node("gearpanel/"+i+"/unequip").visible = false
			get_node("gearpanel/"+i+"/unequip_2x").visible = false
			get_node("gearpanel/"+i).set_normal_texture(sil[i])
		else:
			get_node("gearpanel/"+i+"/unequip").visible = true
			get_node("gearpanel/"+i+"/unequip_2x").visible = true
			###---Added by Expansion---### Ankmairdor's BugFix V4d
			get_node("gearpanel/"+i).set_normal_texture(globals.loadimage(globals.state.unstackables[person.gear[i]].icon))
			###---Expansion End---###

func minoruseffect():
	var buttons = []
	var text = ''
	currentpotion = 'minoruspot'
	if selectedslave == globals.player:
		text = (selectedslave.dictionary('Choose where would you like to apply Minorus Potion on yourself?'))
	else:
		text = (selectedslave.dictionary('Choose where would you like to apply Minorus Potion on $name?'))
	###---Added by Expansion---### Sizes Expanded
	if !selectedslave.asssize in ['masculine','flat']:
		buttons.append(['Butt','applybutt'])
	if !selectedslave.titssize in ['masculine','flat']:
		buttons.append(['Breasts','applytits'])
	if !selectedslave.penis in ['none','micro']:
		buttons.append(['Penis','applypenis'])
	if !selectedslave.balls in ['none','micro']:
		buttons.append(['Testicles','applytestic'])
	
	if !selectedslave.lips in ['masculine','thin']:
		buttons.append(['Lips','applylips'])
	if !selectedslave.vagina in ['none','impenetrable']:
		buttons.append(['Vagina','applyvagina'])
	if !selectedslave.asshole in ['none','impenetrable']:
		buttons.append(['Asshole','applyasshole'])
	###---End Expansion---###
	globals.main.dialogue(true, self, text, buttons)

func majoruseffect():
	var buttons = []
	var text = ''
	currentpotion = 'majoruspot'
	if selectedslave == globals.player:
		text = (selectedslave.dictionary('Choose where would you like to apply Majorus Potion on yourself?'))
	else:
		text = (selectedslave.dictionary('Choose where would you like to apply Majorus Potion on $name?'))
	###---Added by Expansion---### Sizes Expanded
	if selectedslave.asssize != 'huge':
		buttons.append(['Butt','applybutt'])
	if selectedslave.titssize != 'immobilizing':
		buttons.append(['Breasts','applytits'])
	if !selectedslave.penis in ['none','massive']:
		buttons.append(['Penis','applypenis'])
	if !selectedslave.balls in ['none','massive']:
		buttons.append(['Testicles','applytestic'])

	if selectedslave.lips != 'facepussy':
		buttons.append(['Lips','applylips'])
	if !selectedslave.vagina in ['none','gaping']:
		buttons.append(['Vagina','applyvagina'])
	if selectedslave.asshole != 'gaping':
		buttons.append(['Asshole','applyasshole'])
	###---End Expansion---###
	globals.main.dialogue(true, self, text, buttons)

###---Added by Expansion---### Sizes Expanded
func applylips():
	var text = ''
	globals.main.close_dialogue()
	var success = false
	var potionname = ""
	var sizedesc = ""
	if currentpotion == 'minoruspot':
		potionname = "Minorus Potion"
		if selectedslave.lips in ['masculine','thin']:
			success = false
			sizedesc = "small"
		else:
			success = true
			sizedesc = "smaller"
			selectedslave.lips = globals.lipssizearray[globals.lipssizearray.find(selectedslave.lips)-1]
	elif currentpotion == 'majoruspot':
		potionname = "Majorus Potion"
		if globals.lipssizearray.back() == selectedslave.lips:
			success = false
			sizedesc = "big"
		else:
			success = true
			sizedesc = "bigger"
			if selectedslave.lips == 'masculine':
				selectedslave.lips = globals.lipssizearray[globals.lipssizearray.find(selectedslave.lips)+2]
			else:
				selectedslave.lips = globals.lipssizearray[globals.lipssizearray.find(selectedslave.lips)+1]
	#Text
	if selectedslave == globals.player:
		text = selectedslave.dictionary("You apply the [color=aqua]" + str(potionname) + "[/color] to your [color=aqua]lips[/color]. ")
	else:
		text = selectedslave.dictionary("You apply the [color=aqua]" + str(potionname) + "[/color] to $name's [color=aqua]lips[/color]. ")
	if success == true:
		text += selectedslave.dictionary("A little while later, you notice that they have grown [color=green]" + str(sizedesc) + "[/color]. ")
	else:
		text += selectedslave.dictionary("You don't see any changes and think they may be as [color=red]" + str(sizedesc) + "[/color] as it can get. ")
	if state == 'inventory':
		globals.itemdict[currentpotion].amount -= 1
	elif state == 'backpack':
		globals.state.backpack.stackables[currentpotion] -= 1
	selectedslave.toxicity += 30
	globals.main.popup(text)
	updateitems()

func applyvagina():
	var text = ''
	globals.main.close_dialogue()
	var success = false
	var potionname = ""
	var sizedesc = ""
	if currentpotion == 'minoruspot':
		potionname = "Minorus Potion"
		if selectedslave.vagina in ['none','impenetrable']:
			success = false
			sizedesc = "small"
		else:
			success = true
			sizedesc = "smaller"
			selectedslave.vagina = globals.vagsizearray[globals.vagsizearray.find(selectedslave.vagina)-1]
	elif currentpotion == 'majoruspot':
		potionname = "Majorus Potion"
		if globals.vagsizearray.find(selectedslave.vagina) == globals.vagsizearray.size():
			success = false
			sizedesc = "big"
		else:
			success = true
			sizedesc = "bigger"
			selectedslave.vagina = globals.vagsizearray[globals.vagsizearray.find(selectedslave.vagina)+1]
	#Text
	if selectedslave == globals.player:
		text = selectedslave.dictionary("You apply the [color=aqua]" + str(potionname) + "[/color] to your [color=aqua]"+str(globals.expansion.namePussy())+ "[/color]. ")
	else:
		text = selectedslave.dictionary("You apply the [color=aqua]" + str(potionname) + "[/color] to $name's [color=aqua]"+str(globals.expansion.namePussy())+ "[/color]. ")
	if success == true:
		text += selectedslave.dictionary("A little while later, you notice that it has grown [color=green]" + str(sizedesc) + "[/color]. ")
	else:
		text += selectedslave.dictionary("You don't see any changes and think it may be as [color=red]" + str(sizedesc) + "[/color] as it can get. ")
	if state == 'inventory':
		globals.itemdict[currentpotion].amount -= 1
	elif state == 'backpack':
		globals.state.backpack.stackables[currentpotion] -= 1
	selectedslave.toxicity += 30
	globals.main.popup(text)
	updateitems()

func applyasshole():
	var text = ''
	globals.main.close_dialogue()
	var success = false
	var potionname = ""
	var sizedesc = ""
	if currentpotion == 'minoruspot':
		potionname = "Minorus Potion"
		if selectedslave.asshole in ['none','impenetrable']:
			success = false
			sizedesc = "small"
		else:
			success = true
			sizedesc = "smaller"
			selectedslave.asshole = globals.assholesizearray[globals.assholesizearray.find(selectedslave.asshole)-1]
	elif currentpotion == 'majoruspot':
		potionname = "Majorus Potion"
		if globals.assholesizearray.back() == selectedslave.asshole:
			success = false
			sizedesc = "big"
		else:
			success = true
			sizedesc = "bigger"
			selectedslave.asshole = globals.assholesizearray[globals.assholesizearray.find(selectedslave.asshole)+1]
	#Text
	if selectedslave == globals.player:
		text = selectedslave.dictionary("You apply the [color=aqua]" + str(potionname) + "[/color] to your [color=aqua]"+str(globals.expansion.nameAsshole())+ "[/color]. ")
	else:
		text = selectedslave.dictionary("You apply the [color=aqua]" + str(potionname) + "[/color] to $name's [color=aqua]"+str(globals.expansion.nameAsshole())+ "[/color]. ")
	if success == true:
		text += selectedslave.dictionary("A little while later, you notice that it has grown [color=green]" + str(sizedesc) + "[/color]. ")
	else:
		text += selectedslave.dictionary("You don't see any changes and think it may be as [color=red]" + str(sizedesc) + "[/color] as it can get. ")
	if state == 'inventory':
		globals.itemdict[currentpotion].amount -= 1
	elif state == 'backpack':
		globals.state.backpack.stackables[currentpotion] -= 1
	selectedslave.toxicity += 30
	globals.main.popup(text)
	updateitems()
###---End Expansion---###

func applybutt():
	var text = ''
	globals.main.close_dialogue()
	###---Added by Expansion---### Sizes Expanded
	var success = false
	var potionname = ""
	var sizedesc = ""
	if currentpotion == 'minoruspot':
		potionname = "Minorus Potion"
		if selectedslave.asssize in ['masculine','flat']:
			success = false
			sizedesc = "small"
		else:
			success = true
			sizedesc = "smaller"
			selectedslave.asssize = globals.asssizearray[globals.asssizearray.find(selectedslave.asssize)-1]
	elif currentpotion == 'majoruspot':
		potionname = "Majorus Potion"
		if globals.asssizearray.back() == selectedslave.asssize:
			success = false
			sizedesc = "big"
		else:
			success = true
			sizedesc = "bigger"
			if selectedslave.asssize == 'masculine':
				selectedslave.asssize = globals.asssizearray[globals.asssizearray.find(selectedslave.asssize)+2]
			else:
				selectedslave.asssize = globals.asssizearray[globals.asssizearray.find(selectedslave.asssize)+1]
	#Text
	if selectedslave == globals.player:
		text = selectedslave.dictionary("You apply the [color=aqua]" + str(potionname) + "[/color] to your [color=aqua]"+str(globals.expansion.nameAss())+ "[/color]. ")
	else:
		text = selectedslave.dictionary("You apply the [color=aqua]" + str(potionname) + "[/color] to $name's [color=aqua]"+str(globals.expansion.nameAss())+ "[/color]. ")
	if success == true:
		text += selectedslave.dictionary("A little while later, you notice that it has grown [color=green]" + str(sizedesc) + "[/color]. ")
	else:
		text += selectedslave.dictionary("You don't see any changes and think it may be as [color=red]" + str(sizedesc) + "[/color] as it can get. ")
	###---End Expansion---###
	if state == 'inventory':
		globals.itemdict[currentpotion].amount -= 1
	elif state == 'backpack':
		globals.state.backpack.stackables[currentpotion] -= 1
	selectedslave.toxicity += 30
	globals.main.popup(text)
	updateitems()

func applytits():
	var text = ''
	globals.main.close_dialogue()
	###---Added by Expansion---### Sizes Expanded
	var success = false
	var potionname = ""
	var sizedesc = ""
	if currentpotion == 'minoruspot':
		potionname = "Minorus Potion"
		if selectedslave.titssize in ['masculine','flat']:
			success = false
			sizedesc = "small"
		else:
			success = true
			sizedesc = "smaller"
			selectedslave.titssize = globals.titssizearray[globals.titssizearray.find(selectedslave.titssize)-1]
	elif currentpotion == 'majoruspot':
		potionname = "Majorus Potion"
		if globals.titssizearray.back() == selectedslave.titssize:
			success = false
			sizedesc = "big"
		else:
			success = true
			sizedesc = "bigger"
			if selectedslave.titssize == 'masculine':
				selectedslave.titssize = globals.titssizearray[globals.titssizearray.find(selectedslave.titssize)+2]
			else:
				selectedslave.titssize = globals.titssizearray[globals.titssizearray.find(selectedslave.titssize)+1]
	selectedslave.checksex()
	#Text
	if selectedslave == globals.player:
		text = selectedslave.dictionary("You apply the [color=aqua]" + str(potionname) + "[/color] to your [color=aqua]"+str(globals.expansion.nameTits())+ "[/color]. ")
	else:
		text = selectedslave.dictionary("You apply the [color=aqua]" + str(potionname) + "[/color] to $name's [color=aqua]"+str(globals.expansion.nameTits())+ "[/color]. ")
	if success == true:
		text += selectedslave.dictionary("A little while later, you notice that it has grown [color=green]" + str(sizedesc) + "[/color]. ")
	else:
		text += selectedslave.dictionary("You don't see any changes and think it may be as [color=red]" + str(sizedesc) + "[/color] as it can get. ")
	###---End Expansion---###
	if state == 'inventory':
		globals.itemdict[currentpotion].amount -= 1
	elif state == 'backpack':
		globals.state.backpack.stackables[currentpotion] -= 1
	selectedslave.toxicity += 30
	updateitems()
	globals.main.popup(text)

func applypenis():
	var text = ''
	globals.main.close_dialogue()
	###---Added by Expansion---### Sizes Expanded
	var success = false
	var potionname = ""
	var sizedesc = ""
	if currentpotion == 'minoruspot':
		potionname = "Minorus Potion"
		if selectedslave.penis in ['none','micro']:
			success = false
			sizedesc = "small"
		else:
			selectedslave.penis = globals.penissizearray[globals.penissizearray.find(selectedslave.penis)-1]
			success = true
			sizedesc = "smaller"
	elif currentpotion == 'majoruspot':
		potionname = "Majorus Potion"
		if globals.penissizearray.back() == selectedslave.penis:
			success = false
			sizedesc = "big"
		else:
			selectedslave.penis = globals.penissizearray[globals.penissizearray.find(selectedslave.penis)+1]
			success = true
			sizedesc = "bigger"
	#Text
	if selectedslave == globals.player:
		text = selectedslave.dictionary("You apply the [color=aqua]" + str(potionname) + "[/color] to your [color=aqua]"+str(globals.expansion.namePenis())+ "[/color]. ")
	else:
		text = selectedslave.dictionary("You apply the [color=aqua]" + str(potionname) + "[/color] to $name's [color=aqua]"+str(globals.expansion.namePenis())+ "[/color]. ")
	if success == true:
		text += selectedslave.dictionary("A little while later, you notice that it has grown [color=green]" + str(sizedesc) + "[/color]. ")
	else:
		text += selectedslave.dictionary("You don't see any changes and think it may be as [color=red]" + str(sizedesc) + "[/color] as it can get. ")
	###---End Expansion---###
	if state == 'inventory':
		globals.itemdict[currentpotion].amount -= 1
	elif state == 'backpack':
		globals.state.backpack.stackables[currentpotion] -= 1
	selectedslave.toxicity += 30
	updateitems()
	globals.main.popup(text)

func applytestic():
	var text = ''
	globals.main.close_dialogue()
	###---Added by Expansion---### Sizes Expanded
	var success = false
	var potionname = ""
	var sizedesc = ""
	if currentpotion == 'minoruspot':
		potionname = "Minorus Potion"
		if selectedslave.balls in ['none','micro']:
			success = false
			sizedesc = "small"
		else:
			selectedslave.balls = globals.penissizearray[globals.penissizearray.find(selectedslave.balls)-1]
			success = true
			sizedesc = "smaller"
	elif currentpotion == 'majoruspot':
		potionname = "Majorus Potion"
		if globals.penissizearray.back() == selectedslave.balls:
			success = false
			sizedesc = "big"
		else:
			selectedslave.balls = globals.penissizearray[globals.penissizearray.find(selectedslave.balls)+1]
			success = true
			sizedesc = "bigger"
	#Text
	if selectedslave == globals.player:
		text = selectedslave.dictionary("You apply the [color=aqua]" + str(potionname) + "[/color] to your [color=aqua]"+str(globals.expansion.nameBalls())+ "[/color]. ")
	else:
		text = selectedslave.dictionary("You apply the [color=aqua]" + str(potionname) + "[/color] to $name's [color=aqua]"+str(globals.expansion.nameBalls())+ "[/color]. ")
	if success == true:
		text += selectedslave.dictionary("A little while later, you notice that it has grown [color=green]" + str(sizedesc) + "[/color]. ")
	else:
		text += selectedslave.dictionary("You don't see any changes and think it may be as [color=red]" + str(sizedesc) + "[/color] as it can get. ")
	###---End Expansion---###
	if state == 'inventory':
		globals.itemdict[currentpotion].amount -= 1
	elif state == 'backpack':
		globals.state.backpack.stackables[currentpotion] -= 1
	selectedslave.toxicity += 30
	updateitems()
	globals.main.popup(text)

func amnesiapoteffect():
	var text = 'After chugging down the Amnesia Potion, $name looks lightheaded and confused. "W-what was that? I feel like I have forgotten something..." $He is lost, unable to recall the memories of the time before $his confinement as your servant. '
	if selectedslave.effects.has('captured'):
		selectedslave.add_effect(globals.effectdict.captured, true)
		text = text + 'Memories from before $his confinement no longer influence $him to resist you. '
	if selectedslave.loyal < 50 && selectedslave.memory != 'clear':
		text = text + "$He grows closer to you, having no one else $he can rely on. "
		selectedslave.loyal += rand_range(15,25) - selectedslave.conf/10
	###---Added by Expansion---### Vice Removal
	if selectedslave.mind.vice != "none":
		if selectedslave.mind.vice_known == true:
			text += selectedslave.dictionary("\n$His mental regression seems to have removed $his [color=aqua]"+ str(selectedslave.mind.vice.capitalize()) +" Vice[/color] as well. ")
		selectedslave.mind.vice = "none"
		selectedslave.mind.vice_removed = true
		selectedslave.mind.vice_known = true
	###---End Expansion---###
	text += "\n\nYou can choose new name for $name."
	currentpotion = 'amnesiapot'
	selectedslave.memory = 'clear'
	selectedslave.toxicity += 25
	if state == 'inventory':
		globals.itemdict[currentpotion].amount -= 1
	elif state == 'backpack':
		globals.state.backpack.stackables[currentpotion] -= 1
	updateitems()
	$amnesia.visible = true
	$amnesia/name.text = selectedslave.name
	$amnesia/surname.text = selectedslave.surname
	$amnesia/RichTextLabel.bbcode_text = selectedslave.dictionary(text)


func _on_LineEdit_text_changed(new_text):
	filter = new_text
	categoryitems()


const AUTO_MANAGEMENT_ITEMS = ['rope', 'bandage', 'teleportseal', 'torch', 'lockpick', 'supply']
const AUTO_MANAGEMENT_ITEM_NAMES = {rope = 'Ropes', bandage = 'Bandages', teleportseal = 'Teleport seals', torch = 'Torches', lockpick = 'Lockpicks', supply = 'Supplies'}
var spinboxes_for_resupply_items = {}
const AUTO_MANAGEMENT_UNLOAD_CATEGORIES = {supply = false, potion = true, ingredient = true, gear = true, other = true}
var checkboxes_for_unload_categories = {}
const AUTO_MANAGEMENT_SETTINGS_NAMES = {execute_return = false, execute_return_wild = false, unload_backpack = false, restock_backpack = false, buy_items = false, warn_not_enough_items = false}
var checkboxes_for_setting_names = {}

func setup_auto_management():
	$auto_management_popup.theme = theme
	for item in AUTO_MANAGEMENT_ITEMS:
		var item_input: Node = $auto_management_popup/load_items/item_button.duplicate()
		item_input.name = "select_" + item
		item_input.visible = true
		item_input.get_node("item_container/name").text = AUTO_MANAGEMENT_ITEM_NAMES[item]
		item_input.get_node("item_container/icon").texture = globals.loadimage(globals.itemdict[item].icon)
		spinboxes_for_resupply_items[item] = item_input.get_node("item_container/edit")
		$auto_management_popup/load_items.add_child(item_input)
	
	for category in AUTO_MANAGEMENT_UNLOAD_CATEGORIES:
		checkboxes_for_unload_categories[category] = get_node("auto_management_popup/unload_items/%s/checkbox" % category)
	
	for setting_name in AUTO_MANAGEMENT_SETTINGS_NAMES:
		checkboxes_for_setting_names[setting_name] = get_node("auto_management_popup/%s" % setting_name)
		checkboxes_for_setting_names[setting_name].connect("pressed", self, "update_disabled_edits")

	$auto_management_popup/cancel.connect("pressed", $auto_management_popup, "hide")


func show_auto_management():
	update_auto_management()
	update_disabled_edits()
	$auto_management_popup.popup()


func update_disabled_edits():
	var restock_enabled = $auto_management_popup/restock_backpack.pressed
	for spinbox in spinboxes_for_resupply_items.values():
		spinbox.editable = restock_enabled

	var unload_enabled = $auto_management_popup/unload_backpack.pressed
	for checkbox in checkboxes_for_unload_categories.values():
		checkbox.disabled = !unload_enabled


func update_auto_management():
	var settings = globals.state.inventory_settings.get("auto_management", {})
	for setting_name in AUTO_MANAGEMENT_SETTINGS_NAMES:
		checkboxes_for_setting_names[setting_name].pressed = settings.get(setting_name, AUTO_MANAGEMENT_SETTINGS_NAMES[setting_name])
	
	var restock_amount = settings.get("restock_amount", {})
	for item in restock_amount:
		spinboxes_for_resupply_items[item].get_line_edit().text = str(restock_amount[item])
	
	var unload_categories = settings.get("unload_categories", AUTO_MANAGEMENT_UNLOAD_CATEGORIES)
	for category in unload_categories:
		checkboxes_for_unload_categories[category].pressed = unload_categories[category]


func save_auto_management():
	var settings = {
		restock_amount = {},
		unload_categories = {}
	}
	
	for item in AUTO_MANAGEMENT_ITEM_NAMES:
		var value = spinboxes_for_resupply_items[item].get_line_edit().text
		settings.restock_amount[item] = int(value)
	
	var unload_categories = {}
	for category in AUTO_MANAGEMENT_UNLOAD_CATEGORIES:
		settings.unload_categories[category] = checkboxes_for_unload_categories[category].pressed
	
	for setting_name in AUTO_MANAGEMENT_SETTINGS_NAMES:
		settings[setting_name] = checkboxes_for_setting_names[setting_name].pressed
		
	globals.state.inventory_settings.auto_management = settings
	$auto_management_popup.hide()


func manual_run_auto_inventory_management():
	var warnings = run_auto_inventory_management()
	updateitems()
	calculateweight()
	if !warnings.empty():
		get_parent().popup(warnings)


func run_auto_inventory_management() -> String:
	var settings = globals.state.inventory_settings.get("auto_management", {})

	if settings.get("unload_backpack", false):
		unload_backpack(settings.get("unload_categories", AUTO_MANAGEMENT_UNLOAD_CATEGORIES))
	
	if !settings.get("restock_backpack", false):
		return ""

	var buy = settings.get("buy_items", false)
	var warn = settings.get("warn_not_enough_items", false)
	var restock_amount = settings.get("restock_amount", {})
	return restock_backpack(restock_amount, buy, warn)


func is_item_category_selected(item_name: String, unload_categories: Dictionary) -> bool:
	var item_type = globals.itemdict[item_name].type
	if item_type in AUTO_MANAGEMENT_UNLOAD_CATEGORIES:
		return unload_categories[item_type]
	else:
		return unload_categories.other


func unload_backpack(unload_categories: Dictionary):
	if unload_categories.gear:
		for item in globals.state.unstackables.values():
			if item.owner == 'backpack':
				item.owner = null

	var backpack_stackables : Dictionary = globals.state.backpack.stackables
	for item in backpack_stackables.keys(): # we iterate over keys array, because it won't change when we erase values
		if is_item_category_selected(item, unload_categories):
			globals.itemdict[item].amount += backpack_stackables[item]
			backpack_stackables.erase(item)


func restock_backpack(restock_amount: Dictionary, buy_items: bool, warn_items: bool) -> String:
	var warnings = PoolStringArray()
	var backpack_items = globals.state.backpack.stackables
	
	for item in restock_amount:
		var need_item = restock_amount[item] - backpack_items.get(item, 0)
		if need_item <= 0:
			continue
		var has_item = globals.itemdict[item].amount
		var item_name = globals.itemdict[item].name

		if has_item < need_item && buy_items:
			var items_to_buy = need_item - has_item
			var price = items_to_buy * globals.itemdict[item].cost
			if price <= globals.resources.gold:
				if warn_items:
					warnings.append("Bought additional %s of `%s` for %s gold" % [items_to_buy, item_name, price])
				globals.resources.gold -= price
				globals.itemdict[item].amount += items_to_buy

		has_item = globals.itemdict[item].amount
		if has_item < need_item && warn_items:
			warnings.append("Failed to add all %s `%s` to backpack: you only have %s" % [need_item, item_name, has_item])
		
		var items_to_move = min(has_item, need_item)
		if items_to_move > 0:
			backpack_items[item] = backpack_items.get(item, 0) + items_to_move
			globals.itemdict[item].amount -= items_to_move

	return warnings.join("\n")


func show_extra_settings():
	$extra_settings_popup.popup()
	$extra_settings_popup/party_members_first.pressed = globals.state.inventory_settings.get("party_members_first", true)


func hide_extra_settings():
	$extra_settings_popup.hide()


func change_party_slaves_first():
	globals.state.inventory_settings.party_members_first = $extra_settings_popup/party_members_first.pressed
	slavelist()

