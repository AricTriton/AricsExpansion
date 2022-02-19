
func initiate(tempperson):
	var text = ''
	self.visible = true
	self.mood = 0
	if tempperson.effects.has('drunk'):
		self.drunkness = max(0, tempperson.send)
	else:
		self.drunkness = 0
	globals.spells.caster = globals.player
	date = false
	public = false
	$sexswitch.visible = false
	$end.visible = false
	$textfield/RichTextLabel.clear()
	
	actionhistory.clear()
	dateclassarray.clear()
	
	
	person = tempperson
	person.recordInteraction()
	###---Added by Expansion---### Races Expanded
	if person.race.find('Human') >= 0:
#	if person.race == 'Human':
	###---Expansion End---###
		modFearObed = 1.5
	else:
		modFearObed = 1
	var newclass = dateclass.new()
	newclass.sex = globals.player.sex
	newclass.name = globals.player.name_short()
	newclass.person = globals.player
	dateclassarray.append(newclass)
	newclass = dateclass.new()
	newclass.person = person
	newclass.sex = person.sex
	newclass.name = person.name_short()
	dateclassarray.append(newclass)
	
	person.attention = 0
	
	jail = person.sleep == 'jail'
	
	self.stress = person.stress
	self.fear = person.fear
	self.obedStart = person.obed
	self.fearStart = person.fear
	self.stressStart = person.stress
	self.loyalStart = person.loyal
	self.lustStart = person.lust
	self.learningpointsStart = person.learningpoints
	self.turns = int(variables.timeformeetinteraction)
	$fullbody.set_texture(null)
	if nakedspritesdict.has(person.unique) && person.imageportait == globals.characters.characters[person.unique].get('imageportait','') && person.imagetype != 'naked':
		if person.obed >= 50 || person.stress < 10:
			$fullbody.set_texture(globals.spritedict[nakedspritesdict[person.unique].clothcons])
		else:
			$fullbody.set_texture(globals.spritedict[nakedspritesdict[person.unique].clothrape])
	elif person.imagefull != null && globals.loadimage(person.imagefull) != null:
		$fullbody.set_texture(globals.loadimage(person.imagefull))
	$textfield/slaveportrait.texture = null
	
	if person.imageportait != null && globals.loadimage(person.imageportait):
		$textfield/slaveportrait.set_texture(globals.loadimage(person.imageportait))
	else:
		person.imageportait = null
		$textfield/slaveportrait.set_texture(null)
	if $textfield/slaveportrait.texture == null:
		$textfield/slaveportrait/TextureRect.visible = false
	else:
		$textfield/slaveportrait/TextureRect.visible = true
	
	$textfield/masterportrait.texture = null
	if globals.player.imageportait != null && globals.loadimage(globals.player.imageportait):
		$textfield/masterportrait.set_texture(globals.loadimage(globals.player.imageportait))
	else:
		globals.player.imageportait = null
		$textfield/masterportrait.set_texture(null)
	if $textfield/masterportrait.texture == null:
		$textfield/masterportrait/TextureRect.visible = false
	else:
		$textfield/masterportrait/TextureRect.visible = true


	if jail == true:
		get_parent().background = 'jail'
		location = 'dungeon'
		text = "You visit [name2] in [his2] cell and decide to spend some time with [him2]. "
		$panel/categories/Location.disabled = true
	else:
		$panel/categories/Location.disabled = false
		get_parent().background = 'mansion'
		location = 'livingroom'
		text = "You meet [name2] and order [him2] to keep you company. "
		if person.loyal >= 25:
			text += "[he2] gladly accepts your order and is ready to follow you anywhere you take [him2]. "
			self.mood += 10
		elif person.obed >= 90:
			self.mood += 4
			text += "[he2] obediently agrees to your order and tries [his2] best to please you. "
		else:
			text += "Without great joy [he2] obeys your order and reluctantly joins you. "
		if person.lust >= 30:
			mood += 6
		if person.traits.has("Devoted"):
			mood += 10
	
	$panel/consent.visible = person.consent
	
	self.showntext = text
	updatelist()
	$panel/categories/Actions.emit_signal("pressed")

var category


func showtext_set(value):
	var text = decoder(value)
	$textfield/RichTextLabel.bbcode_text = text
	showntext = text

func showtext_get():
	return $textfield/RichTextLabel.bbcode_text

func turns_set(value):
	turns = value
	$turns/Label.text = 'x'+str(value)
	if turns == 0:
		endencounter()

func turns_get():
	return turns

func selectcategory(button):
	for i in $panel/categories.get_children():
		i.pressed = false
		if i.name == button:
			i.pressed = true
	category = button
	updatelist()

func endencounter():
	if $sexswitch.visible == false && $end.visible == false:
		var text = calculateresults()
		$end/RichTextLabel.bbcode_text = text
		$end.visible = true

func updatelist():
	for i in $panel/ScrollContainer/GridContainer.get_children():
		if i.name != 'Button':
			i.visible = false
			i.queue_free()
	$textfield/Label.text = locationdicts[location].name
	for i in actionsdict.values():
		if evaluate(i.reqs) == true && i.group == category:
			if i.has('onetime') && checkhistory(i.effect) > 0:
				continue
			var newnode = $panel/ScrollContainer/GridContainer/Button.duplicate()
			$panel/ScrollContainer/GridContainer.add_child(newnode)
			newnode.visible = true
			newnode.text = person.dictionary(i.name)
			newnode.connect("pressed",self,'doaction', [i.effect])
			newnode.connect("mouse_entered",self,'actiontooltip', [i.descript])
			newnode.connect("mouse_exited",globals,'hidetooltip')
			if i.has('disablereqs') && evaluate(i.disablereqs):
				newnode.disabled = true
	if category == 'Location':
		for i in locationdicts.values():
			if i.code == location:
				continue
			var newnode = $panel/ScrollContainer/GridContainer/Button.duplicate()
			$panel/ScrollContainer/GridContainer.add_child(newnode)
			newnode.visible = true
			newnode.text = "Move to "+ i.name
			newnode.connect("pressed",self,'moveto', [i.code])
#			newnode.connect("mouse_entered",self,'actiontooltip', [i.descript])
#			newnode.connect("mouse_exited",globals,'hidetooltip')
	globals.hidetooltip()
	$panel/ScrollContainer/GridContainer.move_child($panel/ScrollContainer/GridContainer/Button, $panel/ScrollContainer/GridContainer.get_children().size())
	$mana/Label.text = str(globals.resources.mana)
	$gold/Label.text = str(globals.resources.gold)
	$supply/Label.text = str(globals.itemdict.supply.amount)

func moveto(newloc):
	self.location = newloc
	if locationdicts[location].background != 'localtown':
		get_parent().background = locationdicts[location].background
	else:
		get_parent().background = globals.state.location
	if OS.get_name() != 'HTML5':
		yield(get_parent(),'animfinished')
	self.showntext = 'You lead [name2] to the [color=yellow]' + locationdicts[location].name + '[/color]. '
	if date == false && !newloc in ['bedroom','dungeon']:
		date = true
		self.showntext += "\n[color=green][name2] seems to be quite happy to be taken out of the usual place and ready to spend some time with you. [/color]"
	
	updatelist()

func actiontooltip(descript):
	globals.showtooltip(person.dictionary(descript))

func evaluate(input): #used to read strings as conditions when needed
	var script = GDScript.new()
	script.set_source_code("var person\nvar location\nvar public\nfunc eval():\n\treturn " + input)
	script.reload()
	var obj = Reference.new()
	obj.set_script(script)
	obj.person = person
	obj.location = location
	obj.public = public
	return obj.eval()


func decoder(text):
	text = get_parent().get_node("interactions").decoder(text, [dateclassarray[0]], [dateclassarray[1]])
	return text

func doaction(action):
	self.showntext = decoder(call(action, person, checkhistory(action)))
	self.turns -= 1
	actionhistory.append(action)
	
	if turns%3:
		if location == 'bedroom':
			self.showntext += decoder("\n\n[color=yellow]Location influence:[/color] [name2] seems to be getting more into intimate mood...")
			person.lust += rand_range(2,3)
		elif location == 'garden' && person.conf < 50:
			self.mood += 3
			self.showntext += decoder("\n\n[color=yellow]Location influence:[/color] [name2] finds this place to be rather peaceful...")
		elif location == 'town' && person.conf >= 50:
			self.mood += 3
			self.showntext += decoder("\n\n[color=yellow]Location influence:[/color] [name2] finds this place to be rather joyful...")
		elif location == 'dungeon':
			self.fear += 4
			self.showntext += decoder("\n\n[color=yellow]Location influence:[/color] [name2] finds this place to be rather grim...")
	checkPassOut()
	updatelist()

func touch(person, counter):
	var text = ''
	###---Added by Expansion---### Family Expanded | Incest Check
	var incest = globals.expansion.checkIncest(person)
	
	text += "You casually touch [name2] in various places. "
	
	if counter < 3 && person.obed + incest >= 80:
		text += "[he2] reacts relaxingly to your touch"
		self.mood += 2
		if person.loyal + incest >= 10 && randf() >= 0.65:
			text += ' and touches you back'
			person.lust += 3
	###---End Expansion---###
		text += '. '
	else:
		self.mood -= 1
		text += "[he2] reacts coldly to your touch. "
	return text

func holdhands(person, counter):
	var text = ''
	###---Added by Expansion---### Family Expanded | Incest Check
	var incest = globals.expansion.checkIncest(person)
	
	if location != 'bedroom':
		text += "You take [name2]'s hand into yours and stroll around. "
	else:
		text += "You take [name2]'s hand into yours and move closer. "
	if (counter < 3 || randf() >= 0.4) && self.mood + incest >= 4:
		text += "[he2] holds your hand firmly. "
		###---End Expansion---###
		self.mood += 2
		person.loyal += rand_range(2,3)
	else:
		self.mood -= 1
		text += "[he2] holds your hand, but looks reclusive. "
	
	return text

func combhair(person, counter): #play with hair would make more sense?
	var text = ''
	text += "You gently comb [name2]'s hair. "
	
	if (counter < 3 || randf() >= 0.8) && self.mood >= 4:
		text += "[he2] smiles and looks pleased. "
		self.mood += 2
		person.loyal += rand_range(2,3)
	else:
		self.mood -= 1
		text += "[he2] looks uncomfortable. "
	
	return text


func hug(person, counter): 
	var text = ''
	text += "You embrace [name2] in your arms. "
	###---Added by Expansion---### Family Expanded | Incest Check
	var incest = globals.expansion.checkIncest(person)
	
	if (counter < 3 || randf() >= 0.7) && self.mood + incest >= 6:
		text += "[he2] embraces you back and rests [his2] head on your chest. "
	###---End Expansion---###
		self.mood += 3
		person.lust += 3
		person.loyal += rand_range(2,3)
		
	else:
		self.mood -= 2
		text += "[he2] does not do anything waiting uncomfortably for you to finish. "
	
	return text

func kiss(person, counter): 
	var text = ''
	text += "You gently kiss [name2] on the cheek. "
	###---Added by Expansion---### Family Expanded | Incest Check
	var related = str(globals.expansion.relatedCheck(person,globals.player))
	var incest = globals.expansion.checkIncest(person)
	
	if (self.mood + incest >= 4 || person.loyal + incest >= 15):
		text += "[he2] blushes and looks away. "
		self.mood += 3
		person.lust += 1
		if related != 'unrelated':
			text += "[he2] " + str(globals.randomitemfromarray(['whispers','mumbles','quickly says','says','quietly says'])) + " " + person.quirk("\n[color=yellow]-I can not believe I am considering " + globals.expansion.nameKissing() + " my " + related + ". ")
	else:
		self.mood -= 2
		text += "[he2] abruptly stops you, showing [his2] disinterest. "
		if related != 'unrelated':
			text += "[he2] looks at you shocked. " + person.quirk("\n[color=yellow]-I just am not " + str(globals.randomitemfromarray(['comfortable with','interested in','ready to','prepared to','okay to'])) + " start " + globals.expansion.nameKissing() + " my " + related + ". ")
	###---End Expansion---###
	return text

func frenchkiss(person, counter): 
	var text = ''
	text += "You invade [name2]'s mouth with your tongue. "
	###---Added by Expansion---### Family Expanded | Incest Check
	var related = globals.expansion.relatedCheck(person,globals.player)
	var incest = globals.expansion.checkIncest(person)
	if (self.mood + incest >= 10 && person.lust + incest >= 20) || person.loyal + incest >= 25:
		text += "[he2] closes eyes and passionately accepts your kiss. "
		if str(related) != 'unrelated':
			text += "[he2] " + str(globals.randomitemfromarray(['whispers','mumbles','quickly says','says','quietly says'])) + " " + person.quirk("\n[color=yellow]-I can not believe I am ready to start " + globals.expansion.nameKissing() + " my " + str(related) + ". ")
		if globals.expansion.getSexualAttraction(person,globals.player):
			self.mood += 3
			person.lust += 3
		else:
			self.mood += 1
			person.lust += 1
	else:
		self.mood -= 4
		text += "[he2] abruptly stops you, showing [his2] disinterest. "
		if related != 'unrelated':
			text += "[he2] looks at you shocked. " + person.quirk("\n[color=yellow]-I just am not " + str(globals.randomitemfromarray(['comfortable with','interested in','ready to','prepared to','okay to'])) + " start " + globals.expansion.nameKissing() + " my " + str(related) + ". ")
	###---End Expansion---###
	return text

func propose(person, counter):
	var text = ''
	var mode
	###---Added by Expansion---### Family Expanded | Incest Check
	var consentexp = person.consentexp
	var related = globals.expansion.relatedCheck(person,globals.player)
	###---End Expansion---###
	if person.consent == true:
		text = "[name2] previously gave you [his2] consent and you proceed with your intentions. "
		mode = 'sex'
		globals.state.sexactions += 1
		showsexswitch(text, mode)
		text = ''
	else:
		text += "You ask [name2] if [he2] would like to take your relationship to the next level. "
		var difficulty = 300 - (self.mood + person.obed*3 + person.loyal*2 + person.lust + drunkness*10)
		if person.effects.has('captured'):
			difficulty += 100
		###---Added by Expansion---### Sexuality
		if globals.expansion.getSexualAttraction(person,globals.player) == true:
			difficulty += rand_range(10,40)
		else:
			difficulty -= rand_range(10,40)
		###---End Expansion---###
		#if !checkAcceptSexPairing(person):
		#	difficulty += 60
		###---Added by Expansion---### Family Expanded | Incest Check
		person.dailytalk.append('consentsexual')
		if related != "unrelated" && consentexp.incest == false:
			var incest = globals.fetishopinion.find(person.fetish.incest)-6 + round(person.dailyevents.count('incest')/4)
			difficulty -= incest*10
		#if globals.state.relativesdata.has(person.id) && (int(globals.state.relativesdata[person.id].father) == int(globals.player.id) || int(globals.state.relativesdata[person.id].mother) == int(globals.player.id)):
		#	difficulty += 60
		if person.traits.has('Prude'):
			difficulty += 50
		###---End Expansion---###
		if difficulty >= 0:
			text += "[he2] shows a troubled face and rejects your proposal. "
			###---Added by Expansion---### Family Expanded | Incest Check
			if related != 'unrelated' && consentexp.incest == false:
				text += "\n[he2] looks at you. " + person.quirk("\n[color=yellow]-I just am not " + str(globals.randomitemfromarray(['comfortable with','interested in','ready to','prepared to','okay to'])) + " " + globals.expansion.nameSex() + " my " + str(related) + ". ")
				person.dailyevents.append('incest')
				if rand_range(0,5) + person.dailyevents.count('incest') >= 5:
					text += "\nYou do see a flash of hesitation, however, and think that [he2] may be coming around to the idea of it. "
					person.dailyevents.append('incest')
			###---End Expansion---###
			self.mood -= 4
		else:
			person.lust += 3
			person.consent = true
			mode = 'sex'
			text += "[he2] gives a meek nod and you lead [him2] to bedroom."
			###---Added by Expansion---### Incest Check
			related = globals.expansion.relatedCheck(person, globals.player)
			if related != "unrelated":
				if consentexp.incest == false:
					consentexp.incest = true
				if person.fetish.incest in ['taboo','dirty','unacceptable']:
					person.fetish.incest = 'uncertain'
				text += "\n[he2] " + str(globals.randomitemfromarray(['whispers','mumbles','quickly says','says','quietly says'])) + " " + person.quirk("\n[color=yellow]-I can not believe I am about to " + globals.expansion.nameSex() + " my " + str(related) + ". ")
				text += "\n\n[color=green]Unlocked Sexual and Incestuous actions with [name2].[/color]"
			else:
				text += "\n\n[color=green]Unlocked sexual actions with [name2].[/color]"
			###---End Expansion---###
			if person.levelupreqs.has('code') && person.levelupreqs.code == 'relationship':
				text += "\n\n[color=green]After getting closer with [name2], you felt like [he2] unlocked new potential. [/color]"
				###---Modified by Expansion---### Levelup Removed by Ank BugFix v4a
			globals.state.sexactions += 1
			showsexswitch(text, mode)
			text = ''
			
	return text

func showsexswitch(text, mode):
	$sexswitch.visible = true
	sexmode = mode
	$end/RichTextLabel.bbcode_text = text
	###---Added by Expansion---### QOL | Cancel Option Always Available
	if mode == 'abuse':
		text += "\n[color=yellow]Rape [name2] anyway?[/color]"
		$sexswitch/confirmsex.visible = true
		$sexswitch/cancelsex.visible = true
	elif mode == 'rapeconsent':
		sexmode = 'sex'
		$sexswitch/confirmsex.visible = true
		$sexswitch/cancelsex.visible = true
	elif mode == 'sex':
		$sexswitch/confirmsex.visible = true
		$sexswitch/cancelsex.visible = true
	###---End Expansion---###
	
	text = decoder(text) 
	if $sexswitch/cancelsex.visible == false:
		text += calculateresults()
	$sexswitch/RichTextLabel.bbcode_text = text

func praise(person, counter):
	var text = ''
	text += "You praise [name2] for [his2] recent behavior. "
	
	###---Added by Expansion---### Valid Praise Bonus
	if person.dailyevents.has('rule_nudity_obeyed'):
		text += "\nYou explain your happiness at [his2] obedience in following your [color=aqua]Nudity[/color] order. [name2] seems to accept that this praise is for a valid reason.\n[color=red]Praise Valid Reason removed[/color]; [color=green]3 Turns Gained[/color] "
		turns += 3
		while person.dailyevents.find('rule_nudity_obeyed') >= 0:
			person.dailyevents.erase('rule_nudity_obeyed')
	###---End Expansion---###
	
	if person.obed >= 85 && counter < 2:
		self.mood += 3
		self.stress -= rand_range(5,10)
		text = text + "[he2] listens to your praise with joy evident on [his2] face.  "
	elif person.obed >= 85:
		text = text + "[he2] takes your words respectfully but without great joy. You've probably overpraised [him2] lately. "
		
	else:
		text = text + "[he2] takes your praise arrogantly, gaining joy from it. "
		self.mood += 3
		person.loyal -= rand_range(1,2)
	
	return text

func punishaddedeffect():
	var text = ''
	self.stress += 8
	if person.traits.has("Masochist") && randf() >= 0.5:
		text += "[Masochist][name2] seems to take [his2] punishment with some unusual enthusiasm... "
		person.lust += rand_range(2,4)
		self.mood += 3
		self.stress -= 5
	if person.traits.has("Coward"):
		self.fear += 5 * modFearObed
		text += "[Coward][name2] reacts strongly to your aggression. "
	if public == true:
		var slavearray = []
		for i in globals.slaves:
			if i.away.duration == 0 && i.sleep != 'farm' && i != person:
				slavearray.append(i)
		if slavearray.size() > 0:
			text += "\n\n[color=yellow]Invited slaves watch over [name2] in awe. [/color] "
			self.stress += 4
			for i in slavearray:
				###---Added by Expansion---### Races Expanded
				if i.race.find('Human') >= 0:
				###---Expansion End---###
					i.fear += 4.5
				else:
					i.fear += 3
				i.stress += 3
				if actionhistory.back() in ['woodenhorse','flagellate']:
					i.lust += 2
	###---Added by Expansion---### Valid Punishment Bonus
	if person.dailyevents.has('rule_nudity_disobeyed'):
		text += "\nYou explain that [his2] punishment is due to [his2] refusal to follow your [color=aqua]Nudity[/color] order. [name2] seems to understand that this punishment is for a valid reason.\n[color=red]Punishment Valid Reason removed[/color]; [color=green]3 Turns Gained[/color] "
		turns += 3
		while person.dailyevents.find('rule_nudity_disobeyed') >= 0:
			person.dailyevents.erase('rule_nudity_disobeyed')
	###---End Expansion---###
	
	return text

func teach(person, counter):
	var text = ''
	var value = round(3 + person.wit/12) - drunkness*2
	if person.traits.has("Clever"):
		value += value*0.25
	text += "You spend some time with [name2], teaching [him2]. "
	
	if stress < 10+person.wit/2 || counter < 4:
		person.learningpoints += max(0, round(value))
		self.mood -= 1
		self.stress += 10 - person.wit/15
		text += "[name2] learns new things under your watch. " 
		if person.traits.has("Clever"):
			text += "\n[Clever]Bonus points"
	else:
		text += "[name2] looks heavily bored, not taking the lesson seriously. " 
	
	if drunkness > 0:
		text += "\nLesson was less effective due to [name2]'s alcohol intoxication. "
	
	return text

func gift(person, counter):
	var text = ''
	text += "You present [name2] with a small decorative gift. "
	
	###---Added by Expansion---### Person Expanded | Greed Vice and Spelling Fixes
	if person.obed >= 75 || person.mind.vice == 'greed':
		self.mood += 7
		person.loyal += 4
		text = text + "[he2] accepts your gift with a pleasant smile on [his2] face.  "
	else:
		text = text + "[he2] takes your gift arrogantly, barely respecting your intentions. "
		self.mood += 3
	
	###---Person Expanded; Vice - Greed
	if person.mind.vice_known == true && person.checkVice('greed'):
		text += "You know that [he2] is " + globals.randomitemfromarray(['greedy','obsessed with material possessions','pretty greedy']) + " and is very susceptible to gifts and money.\n[color=green]Gifts and Money will always give the best result.[/color]\n "
	###---End Expansion---###
	
	globals.resources.gold -= 10
	
	return text

func sweets(person, counter):
	var text = ''
	text += "You purchase some candies for [name2] from a local vendor. "
	
	###---Added by Expansion---### Person Expanded; Vice - Gluttony & Spelling Fixes
	if person.obed >= 55 || person.mind.vice == 'gluttony':
		self.mood += 6
		person.loyal += 3
		text = text + "[he2] joyfully accepts them and enjoys the sweet taste.  "
		
	else:
		text = text + "[he2] takes your gift arrogantly, barely respecting your intentions. "
		self.mood += 3
	
	###---Person Expanded; Vice - Gluttony
	if person.mind.vice_known == true && person.checkVice('gluttony'):
		text += "You know that [he2] is " + globals.randomitemfromarray(['a glutton','gluttonous','obsessed with food and drink','a foodie','obsessed with food']) + " and takes joy in food and drinks.\n[color=green]Food and Drink Interactions will always give the best result.[/color]\n "
	###---Expansion End---###
	
	globals.resources.gold -= 5
	
	return text


func tea(person, counter):
	var text = ''
	text += "You serve tea for you and [name2]. While drinking, you both chat and get a bit closer.  "
	###---Added by Expansion---### Person Expanded | Gluttony Vice
	if counter <= 3 || randf() >= 0.5 || person.mind.vice == 'gluttony':
		self.mood += 5
		self.stress -= rand_range(2,5)
		text += "[name2] seems to be pleased with your generosity and enjoys your company. "
	###---Expansion End---###
	else:
		self.mood += 1
	
	###---Person Expanded; Vice - Gluttony
	if person.mind.vice_known == true && person.checkVice('gluttony'):
		text += "You know that [he2] is " + globals.randomitemfromarray(['a glutton','gluttonous','obsessed with food and drink','a foodie','obsessed with food']) + " and takes joy in food and drinks.\n[color=green]Food and Drink Interactions will always give the best result.[/color]\n "
	###---Expansion End---###
	
	globals.itemdict.supply.amount -= 1
	
	return text

func wine(person, counter):
	var text = ''
	text += "You serve fresh wine for you and [name2]. "
	
	###---Added by Expansion---### Person Expanded | Gluttony Vice
	var refusal = false
	if person.mind.vice != 'gluttony':
		if self.mood < 23 && person.obed < 80:
			refusal = true
			text += "[he2] refuses to drink with you. "
		else:
			refusal = false
	if refusal == false:
		if counter < 3 || person.mind.vice == 'gluttony':
			text += "[he2] drinks with you and [his2] mood seems to improve."
			self.mood += 4
			self.stress -= rand_range(6,12)
		else:
			self.mood += 2
			text += "[he2] keeps you company, but the wine does not seem to affect [him2] as heavily as before. "
		###---Person Expanded; Vice - Gluttony
		if person.mind.vice_known == true && person.checkVice('gluttony'):
			text += "You know that [he2] is " + globals.randomitemfromarray(['a glutton','gluttonous','obsessed with food and drink','a foodie','obsessed with food']) + " and takes joy in food and drinks.\n[color=green]Food and Drink Interactions will always give the best result.[/color]\n "
		###---Expansion End---###
	###---Expansion End---###
	if person.traits.has("Alcohol Intolerance"):
		drunkness += 2
	else:
		drunkness += 1
	
	globals.itemdict.supply.amount -= 2	
	
	return text
