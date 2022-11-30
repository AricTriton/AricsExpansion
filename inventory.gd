
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
			get_node("gearpanel/"+i).set_normal_texture(sil[i])
		else:
			get_node("gearpanel/"+i+"/unequip").visible = true
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