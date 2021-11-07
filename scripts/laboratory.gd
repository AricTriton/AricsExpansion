
func _on_labselect_pressed():
	if get_node("labmodpanel/labselect").get_text() == 'Select Subject':
		###---Added by Expansion---### Hybrid Support ###---End Expansion---###
		get_tree().get_current_scene().selectslavelist(true,'_on_labstart_pressed',self,"person.work != 'labassist' && person.race.find('Slime') < 0",true)
		###---End Expansion---###
	else:
		labperson = null
		_on_labstart_pressed()
		get_node("labmodpanel/labselect").set_text('Select Subject')

func modchosen(dict= {}, string = '', selected=''):
	var person = labperson
	var text = ''
	var allow = true
	var assist
	for i in globals.slaves:
		if i.work == 'labassist':
			assist = i
	var modification = str2var(var2str(dict))
	if modification.type == 'cosmetics':
		get_node("labmodpanel/labconfirm").set_disabled(true)
		for i in get_node("labmodpanel/ScrollContainer1/secondarymodlist").get_children():
			if globals.decapitalize(i.get_text()) != selected:
				i.set_pressed(false) 
		if person[modification.target] == selected:
			allow = false
			text = "$names already possess " + selected.capitalize().replace('None', 'no') + ' ' +  string + '.'
		else:
			text = "Change $name's " + string + ' to ' + selected.capitalize() + '? Currently $he has ' + person[string].capitalize().replace('None', 'no') + ' ' + string + '. \nRequirements: \n' 
			var priceModifier = 1 / (1+assist.wit/200.0)
			if person == globals.player:
				priceModifier *= 2
			###---Added by Expansion---### Hybrid Support
			if person.race.find('Demon') >= 0:
			###---End Expansion---###
				priceModifier *= 0.7
			for i in modification.price:
				modification.price[i] = round(modification.price[i] * priceModifier)
				if globals.resources[i] >= modification.price[i]:
					text = text + '[color=yellow]'+str(i) + '[/color] - [color=green]' + str(modification.price[i]) + '[/color], \n'
				else:
					allow = false
					text = text + '[color=yellow]' + str(i) + '[/color] - [color=red]' + str(modification.price[i]) + '[/color], \n'
			for i in modification.items:
				modification.items[i] = round(modification.items[i]/(1+assist.wit/200.0))
				if person == globals.player:
					modification.items[i] = modification.items[i]*2
				var item = globals.itemdict[i]
				if item.amount >= modification.items[i]:
					text = text + item.name + ' - [color=green]' + str(modification.items[i]) + '[/color], \n'
				else:
					allow = false
					text = text + item.name + ' - [color=red]' + str(modification.items[i]) + '[/color], \n'
			if person == globals.player:
				modification.time = 0
			else:
				modification.time = max(round(modification.time/(1+assist.smaf/15.0)),1)
			text = text + 'Required time - ' + str(modification.time) + globals.fastif(modification.time == 1, ' day',' days')+'. ' 
	
	if allow == true:
		get_node("labmodpanel/labconfirm").set_meta('data', modification)
		get_node("labmodpanel/labconfirm").set_meta('effect', selected)
		get_node("labmodpanel/labconfirm").set_disabled(false)
	else:
		get_node("labmodpanel/labconfirm").set_disabled(true)
	if person == globals.player:
		text = text.replace("has", "have")
		get_node("labmodpanel/modificationtext").set_bbcode(person.dictionaryplayer(text))
	else:
		get_node("labmodpanel/modificationtext").set_bbcode(person.dictionary(text))

func customenh(dict, action):
	var person = labperson
	var text = ''
	var allow = true
	var assist
	for i in globals.slaves:
		if i.work == 'labassist':
			assist = i
	var modification = str2var(var2str(dict))
	get_node("labmodpanel/labconfirm").set_disabled(true)
	
	for i in get_node("labmodpanel/ScrollContainer1/secondarymodlist").get_children():
		if i.has_meta('effect') == true:
			if i.get_meta('effect') != action:
				i.set_pressed(false) 
	
	if modification.code == 'penis' && action == 'grow':
		text = "$name's clit will be turned into a fully functional, fertile human penis. Semen will be produced by miniscule innards.\n\nRequirements: "
	elif modification.code == 'penis' && action == 'remove':
		text = "$name's penis will be magically reverted into a clitoris.\n\nRequirements:"
	elif modification.code == 'penis' && action == 'humanshape':
		text = "$name's cock will be changed to human shape. \n\nRequirements:"
	elif modification.code == 'penis' && action == 'felineshape':
		text = "$name's cock will be changed to feline shape, fitted with small barbs. \n\nRequirements:"
	elif modification.code == 'penis' && action == 'canineshape':
		text = "$name's cock will be changed to canine shape, with a sizeable knot at the base. \n\nRequirements:"
	elif modification.code == 'penis' && action == 'equineshape':
		text = "$name's cock will be changed to equine shape, with a blunt tip and flared head. \n\nRequirements:"
	elif modification.code == 'penis' && action == 'pussy':
		if person.vagina == 'none':
			text = "$name will obtain a fully functional vagina capable of pregnancy. \n\nRequirements:"
		else:
			text = "$name's womb will be restored and capable of pregnancy again. \n\nRequirements:"
	elif modification.code == 'penis' && action == 'removepussy':
		text = "$name's female genitals and reproduction system will be removed. \n\nRequirements"
	elif modification.code == 'tits' && action == 'developtits':
		text = "$name's additional rudimentary nipples will be developed into full-functional mammaries. \n\nRequirements:"
	elif modification.code == 'tits' && action == 'reversetits':
		text = "$name's secondary tits will be reverted back to rudimentary nipples. \n\nRequirements:"
	elif modification.code == 'tits' && action == 'addnipples':
		text = "$name's chest will be augmented with an additional pair of nipples.\n\nRequirements:"
	elif modification.code == 'tits' && action == 'removenipples':
		text = "A pair of secondary nipples will be removed from $name's chest. \n\nRequirements:"
	elif modification.code == 'tits' && action == 'maximizenipples':
		text = "$name's chest and stomach will be modified to hold 4 pairs of additional nipples. \n\nRequirements:"
	elif modification.code == 'tits' && action == 'minimizenipples':
		text = "All but one pair of $his original nipples will be removed from $name's chest. \n\nRequirements:"
	elif modification.code == 'tits' && action == 'hollownipples':
		text = "$name's nipples will be altered to be more elastic and sensitive, with the breasts hollow inside allowing $him to receive pleasure from penetration. \n\nRequirements:"
	elif modification.code == 'balls' && action == 'grow':
		text = "$name will grow a pair of small testicles. \n\nRequirements:"
	elif modification.code == 'balls' && action == 'remove':
		text = "$name will have $his testicles moved inside his body cavity, hiding them from sight (does not impact fertility). \n\nRequirements:"
	elif modification.code == 'mod' && action == 'fur':
		text = "$name's fur will be magically augmented to provide better protection. \n\nRequirements:"
	elif modification.code == 'mod' && action == 'scales':
		text = "$name's scales will be magically augmented to provide better protection. \n\nRequirements:"
	elif modification.code == 'mod' && action == 'tongue':
		text = "$name's tongue will be elongated allowing better performance during oral sex. \n\nRequirements:"
	elif modification.code == 'mod' && action == 'hearing':
		text = "$name's hearing will be magically augmented and will raise $his awareness. \n\nRequirements:"
	elif modification.code == 'mod' && action == 'str':
		text = "Due to magical augmentation, $name's muscles will have more room for growth. (increases maximum strength by 2) \n\nRequirements:"
	elif modification.code == 'mod' && action == 'agi':
		text = "Due to magical augmentation, $name's flexibility will have more room for growth. (increases maximum agility by 2) \n\nRequirements:"
	elif modification.code == 'mod' && action == 'beauty':
		text = "$name's visual appearance will be improved by correcting flaws and problematic parts. (inceases basic beauty, can only be used once per servant) \n\nRequirements:"
	
	
	
	var priceModifier = 1 / (1+assist.wit/200.0)
	if person == globals.player:
		priceModifier *= 2
	###---Added by Expansion---### Hybrid Support
	if person.race.find('Demon') >= 0:
		priceModifier *= 0.7
	###---End Expansion---###
	for i in modification.data[action].price:
		modification.data[action].price[i] = round(modification.data[action].price[i] * priceModifier)
		if globals.resources[i] >= modification.data[action].price[i]:
			text = text + str(i) + ' - [color=green]' + str(modification.data[action].price[i]) + '[/color], \n'
		else:
			allow = false
			text = text + str(i) + ' - [color=red]' + str(modification.data[action].price[i]) + '[/color], \n'
	for i in modification.data[action].items:
		modification.data[action].items[i] = round(modification.data[action].items[i] * priceModifier)
		var item = globals.itemdict[i]
		if item.amount >= modification.data[action].items[i]:
			text = text + item.name + ' - [color=green]' + str(modification.data[action].items[i]) + '[/color], \n'
		else:
			allow = false
			text = text + item.name + ' - [color=red]' + str(modification.data[action].items[i]) + '[/color], \n'
	
	if person == globals.player:
		modification.data[action].time = 0
	else:
		modification.data[action].time = max(round(modification.data[action].time/(1+assist.smaf/8.0)),1)
	text = text + 'Required time - ' + str(modification.data[action].time) + globals.fastif(modification.data[action].time == 1, ' day',' days')+'. ' 
	
	if allow == true:
		get_node("labmodpanel/labconfirm").set_meta('data', modification)
		get_node("labmodpanel/labconfirm").set_meta('effect', action)
		get_node("labmodpanel/labconfirm").set_disabled(false)
	else:
		get_node("labmodpanel/labconfirm").set_disabled(true)
	if person == globals.player:
		get_node("labmodpanel/modificationtext").set_bbcode(person.dictionaryplayer(text))
	else:
		get_node("labmodpanel/modificationtext").set_bbcode(person.dictionary(text))
