
func buyattributepoint():
	#ralphA - added "if globals.useRalphsTweaks:" section and adjusted tabs for original code 
	if globals.useRalphsTweaks && globals.expansionsettings.ralphs_tweaks_partial.restrict_convert_to_upgrade_point: #ralphA - closes attribute point to upgrade point conversion unless npcs are Loyalty 50 (no using recent additions for quick upgrade points)
		if person.loyal >=50 && person.skillpoints >= variables.attributepointsperupgradepoint:
			person.skillpoints -= variables.attributepointsperupgradepoint
			globals.resources.upgradepoints += 1
		else:
			get_tree().get_root().get_node("Mansion").infotext("Not enough attribute points or loyalty", 'red')
	else:
		if person.skillpoints >= variables.attributepointsperupgradepoint:
			person.skillpoints -= variables.attributepointsperupgradepoint
			globals.resources.upgradepoints += 1
		else:
			get_tree().get_root().get_node("Mansion").infotext("Not enough attribute points", 'red')
	#/ralphA
	upgradecostupdate()

func slavetabopen():
	var label
	var text = ""
	get_parent().get_node("mansion/mansioninfo").set_bbcode('')
	person = globals.slaves[get_tree().get_current_scene().currentslave]
	$stats.person = person
	sleeprooms()
	###---Added by Expansion---### Update Person
	globals.expansion.updatePerson(person)
	###---Expansion End---###
	if person.sleep == 'jail':
		tab = 'prison'
		get_tree().get_current_scene().background_set('jail')
	else:
		tab = null
		get_tree().get_current_scene().background_set('mansion')
	if OS.get_name() != "HTML5" && globals.rules.fadinganimation == true:
		yield(get_tree().get_current_scene(), 'animfinished')
	globals.currentslave = person
	self.visible = true
	text = person.description()
	$stats/basics/slavedescript.set_bbcode(text)
	text = person.status()
	$stats/statustext.set_bbcode(text)
	###---Added by Expansion---### Fix Fullbody Showing
	#if showfullbody == true:
	if globals.rules.showfullbody:
		$stats/basics/bodypanel/fullbody.set_texture(null)
		if person.imagefull != null && globals.loadimage(person.imagefull) != null:
			$stats/basics/bodypanel/fullbody.set_texture(globals.loadimage(person.imagefull))
		elif nakedspritesdict.has(person.unique):
			if person.obed <= 50 || person.stress > 50:
				$stats/basics/bodypanel/fullbody.set_texture(globals.spritedict[nakedspritesdict[person.unique].clothrape])
			else:
				$stats/basics/bodypanel/fullbody.set_texture(globals.spritedict[nakedspritesdict[person.unique].clothcons])
		$stats/basics/bodypanel.visible = ($stats/basics/bodypanel/fullbody.get_texture() != null)
		#---Jail Bars
		$stats/basics/fullbodyjail.visible = (person.sleep == 'jail')
	else:
		$stats/basics/bodypanel.visible = false
		#---Jail Bars
		$stats/basics/fullbodyjail.visible = false
	###---End Expansion---###
	for i in $stats/basics/traits/traitlist.get_children() + $stats/basics/sextraits/traitlist.get_children() :
		if i.get_name() != 'Label':
			i.visible = false
			i.free()
	for i in person.get_traits():
		label = $stats/basics/traits/traitlist/Label.duplicate()
		if i.tags.has("sexual"):
			$stats/basics/sextraits/traitlist.add_child(label)
		else:
			$stats/basics/traits/traitlist.add_child(label)
		label.visible = true
		label.set_text(i.name)
		label.connect("mouse_entered", self, 'traittooltip', [i])
		label.connect("mouse_exited", self, 'traittooltiphide')
	for i in $stats/customization/rules.get_children():
		if i.is_in_group('advrules'):
			if person.brand == 'advanced':
				i.visible = true
			else:
				i.visible = false
	#regulationdescription()
	for i in get_tree().get_nodes_in_group("slaverules"):
		if person.rules.has(i.get_name()):
			i.set_pressed(person.rules[i.get_name()])
	get_node("stats/workbutton").set_text(jobdict[person.work].name)
	$stats/customization/brandbutton.set_text(person.brand.capitalize())
	if globals.state.branding == 0:
		find_node('brandbutton').set_disabled(true)
	else:
		find_node('brandbutton').set_disabled(false)
#	text = "Health : " + str(round(person.health)) + '/' + str(round(person.stats.health_max)) + '\nEnergy : ' + str(round(person.energy)) + '/' + str(round(person.stats.energy_max)) + '\nLevel : '+str(person.level) + '\nExp : '+str(round(person.xp))+'\nSkillpoints : '+str(person.skillpoints)
#	get_node("stats/levelinfo").set_bbcode(text)
	for i in get_tree().get_nodes_in_group('prisondisable'):
		if tab == 'prison':
			i.visible = false
		else:
			i.visible = true
	var hairstyleBtn = $stats/customization/hairstyle
	for i in range(hairstyleBtn.get_item_count()):
		if hairstyleBtn.get_item_text(i) == person.hairstyle:
			hairstyleBtn.select(i)
			break
	###---Added by Expansion---###
	#Strip Toggle
	if int(person.exposed.chest) + int(person.exposed.genitals) + int(person.exposed.ass) >= 2:
		$stats/customization/ae_strip_toggle.set_pressed(true)
	else:
		$stats/customization/ae_strip_toggle.set_pressed(false)
	
	#Whims -- new colors for the slave list
	get_tree().get_current_scene().get_node("MainScreen/slave_tab/stats/customization/namecolor").clear()
	var namecolor = person.namecolor
	for i in namecolors:
		get_tree().get_current_scene().get_node("MainScreen/slave_tab/stats/customization/namecolor").add_item(i)
		if namecolor == i:
			get_tree().get_current_scene().get_node("MainScreen/slave_tab/stats/customization/namecolor").select(get_tree().get_current_scene().get_node("MainScreen/slave_tab/stats/customization/namecolor").get_item_count()-1)
	#Removed in New Version for some reason?
#	$stats/customization/hairstyle.set_text(person.hairstyle)
	###---End Expansion---###
	updatestats()
	if globals.state.mansionupgrades.mansionparlor >= 1:
		$stats/customization/tattoo.set_disabled(false)
		$stats/customization/piercing.set_disabled(false)
		$stats/customization/tattoo.set_tooltip("")
		$stats/customization/piercing.set_tooltip("")
	else:
		$stats/customization/tattoo.set_disabled(true)
		$stats/customization/piercing.set_disabled(true)
		$stats/customization/tattoo.set_tooltip("Unlock Beauty Parlor to access Tattoo options. ")
		$stats/customization/piercing.set_tooltip("Unlock Beauty Parlor to access Piercing options. ")
	if globals.state.tutorial.has('person') && globals.state.tutorial.person == false:
		globals.state.tutorial.person = true
		get_tree().get_current_scene().get_node("tutorialnode").slaveinitiate()

	#$stats/basics/fullbodycheck.pressed = showfullbody

	if person.work == 'jailer':
		get_node("stats/workbutton").set_text('Jailer')
	elif person.work == 'headgirl':
		get_node("stats/workbutton").set_text('Headgirl')
	elif person.work == 'farmmanager':
		get_node("stats/workbutton").set_text('Farm Manager')
	elif person.work == 'labassist':
		get_node("stats/workbutton").set_text('Lab Assistant')

func buildmetrics():
	var text = ""
	$stats/statisticpanel.visible = true
	text += "[color=#d1b970][center]Personal Achievements[/center][/color]\n"
	###---End Expansion---###
	text += "In your possession: " + textForCountNoun(person.metrics.ownership, " day") +"\n"
	text += "Spent in jail: " + textForCountNoun(person.metrics.jail, " day")+"\n"
	text += "Worked in brothel: " + textForCountNoun(person.metrics.brothel, " day")+"\n"
	text += "Won battles: " + textForCountNoun(person.metrics.win, " time") +"\n"
	text += "Captured enemies: " + textForCountNoun(person.metrics.capture, " enem","ies", "y") +"\n"
	text += "Earned gold: " + textForCountNoun(person.metrics.goldearn, " piece") +"\n"
	text += "Earned food: " + textForCountNoun(person.metrics.foodearn, " unit") +"\n"
	text += "Produced mana: " + textForCountNoun(person.metrics.manaearn, "", " mana") + "\n"
	text += "Used items: " + textForCountNoun(person.metrics.item, " time") +"\n"
	text += "Affected by spells: " + textForCountNoun(person.metrics.spell, " time") +"\n"
	text += "Modified in lab: " + textForCountNoun(person.metrics.mods, " time") +"\n"
	###---Added by Expansion---### Various
	if globals.state.perfectinfo == true:
		text +="\n[center][color=#d1b970]Cum Tracking[/color] [color=red]-DEBUG ONLY-[/color][/center]\n"
		text += "[center]Face: [color=aqua]" + str(person.cum.face) + "[/color][/center]\n"
		text += "[center]Mouth: [color=aqua]" + str(person.cum.mouth) + "[/color][/center]\n"
		text += "[center]Body: [color=aqua]" + str(person.cum.body) + "[/color][/center]\n"
		if person.vagina != "none":
			text += "[center]Pussy: [color=aqua]" + str(person.cum.pussy) + "[/color][/center]\n"
		text += "[center]Asshole: [color=aqua]" + str(person.cum.ass) + "[/color][/center]\n"
	if person.npcexpanded.timesmet > 0:
		text +="\n[center][color=#d1b970]Prior to Capture[/color][/center]\n\n"
		if person.npcexpanded.citizen == true:
			text += "[color=#d1b970]Previous Life: [/color][color=green]Free Citizen[/color]\n"
		else:
			text += "[color=#d1b970]Previous Life: [/color][color=red]Criminal[/color]\n"
		if person.npcexpanded.enslavedby != null && person.npcexpanded.enslavedby != "":
			text += "Enslaved by [color=red]" + str(person.npcexpanded.enslavedby) + "[/color]\n"
		text += "Encounters: [color=aqua]" + str(person.npcexpanded.timesmet) + "[/color]\n"
		if person.npcexpanded.timesfought > 0:
			text += "Times Fought: [color=red]" + str(person.npcexpanded.timesfought) + "[/color]\n"
		if person.npcexpanded.timesrescued > 0:
			text += "Times Rescued: [color=aqua]" + str(person.npcexpanded.timesrescued) + "[/color]\n"
		if person.npcexpanded.timesreleased > 0:
			text += "Times Released: [color=aqua]" + str(person.npcexpanded.timesreleased) + "[/color]\n"
		if person.npcexpanded.timesraped > 0:
			text += "Times Raped: [color=red]" + str(person.npcexpanded.timesraped) + "[/color]\n"
	elif person.fromguild == true:
		text += "[color=#d1b970]Previous Life: [/color][color=green]"+person.dictionary("$He")+" has been a Slave as long as "+person.dictionary("$he")+" can remember[/color]\n"
	elif person.npcexpanded.mansionbred == true:
		text += "[color=#d1b970]Previous Life: [/color][color=green]"+person.dictionary("$He")+" was born in the Mansion[/color]\n"
	###---End Expansion---###
	$stats/statisticpanel/statstext.set_bbcode(text)
	###---Added by Expansion---###
	#Check if Specific Info/Unlock for Specific Info or Generic (Description)
	if person.swollen > 0 && person.swollen >= globals.heightarrayexp.find(person.height) || person.swollen > 0 && globals.state.perfectinfo == true:
		text += "\nSwollen Belly: [color=aqua]" + str(person.swollen) + "[/color]"
	if person.mind.vice_known == true:
		text += "\n[color=#d1b970][center]Vice:[/color] [color=aqua]" + person.mind.vice.capitalize() + "[/color][/center]\n"
	else:
		text += "\n[color=#d1b970][center]Vice:[/color] [color=red]Unknown[/color][/center]\n"
	text = "[color=#d1b970][center]Sexual achievments[/center][/color]\n"
	text += "Had intimacy: " + textForCountNoun(person.metrics.sex, " time") +"\n"
	text += "Fucked by strangers: " + textForCountNoun(person.metrics.randompartners, " time") +"\n"
	if person.metrics.animalpartners > 0:
		text += "Fucked by animals: " + textForCountNoun(person.metrics.animalpartners, " time") +"\n"
	text += "Orgasms: " + textForCountNoun(person.metrics.orgasm, " time") +"\n"
	###---Added by Expansion---### Ank BugFix v4
	if person.vagina != 'none':
		text += "Vaginal penetrations: " + textForCountNoun(person.metrics.vag + person.metrics.randompartners + person.metrics.animalpartners, " time") +"\n"
	text += "Anal penetrations: " + textForCountNoun(person.metrics.anal, " time") +"\n"
	###---End Expansion---###
	text += "Gave oral: " + textForCountNoun(person.metrics.oral, " time") +"\n"
	text += "Was forced: " + textForCountNoun(person.metrics.roughsex, " time") +"\n"
	#text += person.dictionary("Of those $he liked: ") + str(person.metrics.roughsexlike) + " time"+globals.fastif(person.metrics.roughsexlike == 1, '','s')+";\n"
	text += "Had partners: " + textForCountNoun(person.sexexp.partners.size(), " partner") +"\n"
	text += "Participated in orgies: " + textForCountNoun(person.metrics.orgy, " time") +"\n"
	var known_preg = person.metrics.preg
	if person.preg.is_preg and !person.knowledge.has('currentpregnancy'):
		known_preg -= 1
	if (person.preg.has_womb == true) || (known_preg > 0) || (person.metrics.birth > 0):
		text += "Was pregnant: " + textForCountNoun(known_preg, " time") +"\n"
		if person.preg.baby_type == 'birth':
			text += "Gave birth: " + textForCountNoun(person.metrics.birth, " time") +" to " + textForCountNoun(person.preg.offspring_count, " kid") +"\n"
		else:
			text += "Laid Eggs: " + textForCountNoun(person.metrics.birth, " time") +", hatched " + textForCountNoun(person.preg.offspring_count, " kid") +"\n"
	#---Fetishes
	if !person.knownfetishes.empty():
		text +="\n[color=#d1b970][center]Known Fetishes[/center][/color]\n"
		for fetish in person.knownfetishes:
			var fetishname = globals.expansion.getFetishDescription(str(fetish))
			text += fetishname.capitalize() + ": " + str(person.fetish[fetish].capitalize())+ "\n"
	#---Consent
	text +="\n[color=#d1b970][center]Consent Given[/center][/color]\n"
	if person.consent == true:
		text += "You may fuck them"
		if person.consentexp.pregnancy == true:
			text += " and they will carry your "
			if person.race.find("Beastkin") >= 0:
				text += globals.randomitemfromarray(['litter','pups','brood'])
			else:
				text += globals.randomitemfromarray(['children','kids','babies','offspring'])
	if person.consentexp.breeder == true || person.consentexp.stud == true:
		if person.consent == true:
			text += ", they will "
		else:
			text += "They will "
		if person.consentexp.stud == true:
			text += globals.randomitemfromarray(['knock up','impregnate','have offspring with'])
		if person.consentexp.breeder == true:
			if person.consentexp.stud == true:
				text += " and have "
			else:
				text += " have "
		if person.race.find("Beastkin") >= 0:
			text += globals.randomitemfromarray(['a litter','pups','a brood']) + " with "
		else:
			text += globals.randomitemfromarray(['children','kids','babies','offspring']) + " with "
		text += " anyone you tell them to"
	if person.consentexp.incest == true:
		if person.consent == true || person.consentexp.breeder == true || person.consentexp.stud == true:
			if person.consent == true && person.consentexp.breeder == true || person.consent == true && person.consentexp.stud == true:
				text += ", and "
			else:
				text += ", "
			text += "they will fuck " + globals.randomitemfromarray(['family','family members','kin','kinfolk','relatives'])
		else:
			text += "They will fuck " + globals.randomitemfromarray(['family','family members','kin','kinfolk','relatives'])
		if person.consentexp.incestbreeder == true:
			text += " and have their "
			if person.race.find("Beastkin") >= 0:
				text += globals.randomitemfromarray(['litter','pups','brood'])
			else:
				text += globals.randomitemfromarray(['children','kids','babies','offspring'])
	if person.consent == true || person.consentexp.breeder == true || person.consentexp.stud == true || person.consentexp.incest == true:
		text += ".\n"
	if person.consentexp.party == true:
		text += "They will travel and fight alongside you.\n"
	if person.consent == false && person.consentexp.breeder == false && person.consentexp.stud == false && person.consentexp.incest == false && person.consentexp.party == false:
		text += "[center][color=red]None[/color][/center]\n"
	var haveNurse = false
	for person in globals.slaves:
		if person.away.duration == 0 && person.work == 'nurse':
			haveNurse = true
			break
	###---Added by Expansion---###
	text += "\n[color=#d1b970][center]Pregnancy Factors[/center][/color]\n"
	if person.knowledge.has('desiredoffspring') || globals.state.perfectinfo == true:
		text += "[center]Number of Children Wanted: " + str(round(person.pregexp.desiredoffspring)) + "[/center]\n"
	if (person.knowledge.has('currentpregnancy') || globals.state.perfectinfo == true) &&  person.preg.has_womb == true && person.preg.is_preg == true:
		text += "\n[color=#d1b970][center]Current Pregnancy[/center][/color]\n"
		if person.preg.baby_type == 'birth':
			text += "Current Trimester: " + globals.expansion.getTrimester(person).capitalize() + "\n"
		elif person.preg.duration >= floor(globals.state.pregduration/3):
			text += "Laid " + textForCountNoun(person.metrics.sex, " egg") +"\n"
		else:
			text += "Has not laid eggs yet\n"
		if globals.state.mansionupgrades.dimensionalcrystal >= 2 || globals.state.perfectinfo == true:
			text += "Pregnancy Duration: " +str(person.preg.duration) + "\n"
		if (haveNurse || globals.state.perfectinfo == true) && !person.preg.unborn_baby.empty():
			text += "Pregnant with " + person.get_birth_amount_name() + ".\n"
		if person.knowledge.has('currentpregnancywanted') || globals.state.mansionupgrades.dimensionalcrystal >= 2 || globals.state.perfectinfo == true:
			if person.pregexp.wantedpregnancy == true:
				text += "\n[center][color=green]She wants this pregnancy, won't resist her bodily changes, and will not be as stressed by those changes.[/color][/center]\n\n"
			else:
				text += "\n[center][color=red]She doesn't want this pregnancy and will be more stressed as she resists the changes her body goes through.[/color][/center]\n\n"
	if haveNurse || globals.state.perfectinfo == true:
		if person.preg.has_womb == true:
			if person.preg.ovulation_stage == 1:
				text += "[color=green]Is Currently Ovulating[/color]\n"
			else:
				text += "[color=red]Is Not Currently Ovulating[/color]\n"
		if person.penis != "none":
			text += "Virility: " + str(person.pregexp.virility) + "\n"
		if person.preg.has_womb == true:
			text += "Egg Strength: " + str(person.pregexp.eggstr) + "\n"
		if int(person.cum.pussy) > 0:
			text += "Live " + globals.randomitemfromarray(['Cum','Semen','Jizz','Spunk']) + " in " + globals.randomitemfromarray(['Pussy','Vagina','Cunt']) + ": " + globals.semen_volume(person.cum.pussy) + "\n"
		if int(person.get_wombsemen()) > 0:
			text += "Live " + globals.randomitemfromarray(['Cum','Semen','Jizz','Spunk']) + " in Womb: " + globals.semen_volume(person.get_wombsemen()) + "\n"	
		if int(person.cum.pussy) > 0:
			text += "Virility of Semen Inside: " + str(person.pregexp.latestvirility) + "\n"

	if person.lactation == true && globals.state.perfectinfo == true:
		text += "\n[color=#d1b970][center]Lactation Factors[/center][/color]\n"
		if person.lactating.daysunmilked > 0:
			text += "[center][color=red]Hasn't been milked in " + textForCountNoun(person.lactating.daysunmilked, "[/color] day") +"[/center]\n"
		if person.lactating.milkstorage - person.lactating.milkmax > 0:
			text += "[center][color=red]" +globals.expansion.nameTits().capitalize()+ " stretching due to [color=aqua]" + str(person.lactating.milkstorage - person.lactating.milkmax) + "oz[/color] pressure. They may gain size and cause stress and health damage.[/color]\n"
		text += "Lactating for [color=aqua]" + textForCountNoun(person.lactating.duration, "[/color] day") +"\n"
		text += "Produces [color=aqua]" + str(person.lactating.regen) + "[/color] milk daily\n"
		text += "Milk Glands: [color=aqua]" + str(person.lactating.milkstorage) + "[/color] stored / [color=aqua]" + str(person.lactating.milkmax) + "[/color] before stretching\n"
		
	###---Expansion End---###
	#text += "Participated in threesomes: " + str(person.metrics.threesome) + " time"+globals.fastif(person.metrics.threesome == 1, '','s')+";\n"
	$stats/statisticpanel/statssextext.set_bbcode(text)
	text = ''
	for i in person.relations:
		var tempslave = globals.state.findslave(i)
		###---Added by Expansion---### Family Matters && URL || Ank BugFix v4a
		if tempslave == null || person.away.at == 'hidden':
#			tempslave = globals.state.findnpc(i)
#			if tempslave == null:
			continue
		var relationship = globals.expansion.relatedCheck(person,tempslave)
		if relationship == "unrelated":
			relationship = ""
		else:
			relationship = " [color=aqua](" + relationship + ")[/color] "
		text += '[color=yellow]' + tempslave.dictionary("$name") + '[/color]' + relationship + ": " + relationword(person.relations[i]) + '\n'
		###---End Expansion---###

	$stats/statisticpanel/relations/RichTextLabel.bbcode_text = text
		

func relationword(value):
	var text = 'neutral'
	###---Added by Expansion---### New Levels
	if value >= 1200:
		text = '[color=green]obsessed[/color]'
	elif value >= 900:
		text = '[color=green]love[/color]'
	###---End Expansion---###
	elif value >= 500:
		text = '[color=green]affectionate[/color]'
	elif value >= 200:
		text = 'friendly'
	elif value <= -900:
		text = '[color=red]hostile[/color]'
	elif value <= -500:
		text = '[color=red]bitter[/color]'
	elif value <= -200:
		text = 'aloof'
	return text

##############Regulation screen



###---Added by Expansion---### Deviate / Kennel Sleep Location
func regulationdescription():
	#var cloth = globals.clothes
	#var underwear = globals.underwear
	var text
	if !jobdict.has(person.work):
		person.work = 'rest'
	text = person.dictionary(jobdict[person.work].workline + '\n')
	if person.brand == 'none':
		text = text + '[color=#ff4949]Currently, $he is not branded. [/color]\n'
	elif person.brand == 'basic':
		text = text + 'On $his neck you can recognize the magic [color=green]brand[/color] you left on $him.\n'
	elif person.brand == 'advanced':
		text = text + 'On $his neck you can spot the complex symbol of your [color=green]refined brand[/color].\n'
	if person.gear.costume != null:
		text += "$He wears [color=green]" + globals.state.unstackables[person.gear.costume].name + '[/color]'
		if person.gear.armor != null:
			text += " with [color=green]" + globals.state.unstackables[person.gear.armor].name + "[/color] on top of it.\n"
		else:
			text += ".\n"
	elif person.gear.costume == null && person.gear.armor != null:
		text += "$He wears only suit of [color=green]" + globals.state.unstackables[person.gear.armor].name + "[/color] without any additional clothing under it. \n"
	elif person.gear.costume == null:
		text += "$He [color=yellow]does not wear any upper clothing[/color] while at mansion.\n"
	if person.gear.underwear != null && person.gear.underwear != 'underwearplain':
		text += " "
	#text = text + "$He wears [color=green]" + person.gear.costume + '[/color] and [color=green]' + person.gear.underwear + '[/color] on beneath.\n'
	if person.sleep == 'communal':
		text = text + 'At the night $he will be sleeping with others at [color=yellow]communal room[/color].\n'
	elif person.sleep == 'personal':
		text = text + 'At the night $he will be resting at [color=green]personal room[/color].\n'
	elif person.sleep == 'your':
		text = text + 'At the night $he will be warming [color=purple]your bed[/color].\n'
	###---Added by Expansion---### Added by Deviate
	elif person.sleep == 'kennel':
		text = text + 'At the night $he will be sleeping with the hounds in the [color=purple]kennel[/color].\n'
	###---End Expansion---###
	return find_node('regulationdescript').set_bbcode(person.dictionary(text))


###########Brand popup window

func _on_brandbutton_pressed():
	var confirm = $stats/customization/brandpopup/confirm
	confirm.visible = false
	find_node('brandingtext').visible = false
	find_node('enhbrandingtext').visible = false
	find_node('brandremovetext').visible = false
	find_node('remove').visible = false
	$stats/customization/brandpopup.popup()
	if person.brand == 'basic' || person.brand == 'advanced':
		find_node('brandremovetext').visible = true
		if globals.resources.mana >= 5:
			find_node('remove').visible = true
	if person.brand == 'none' && globals.state.branding >= 1:
		find_node('brandingtext').visible = true
		###---Added by Expansion---### Patching Brand
		if globals.resources.mana >= 10 && globals.player.energy >= 10:
			confirm.visible = true
			confirm.set_meta('value', 1)
		else:
			confirm.visible = false
		###---End Expansion---###
	elif person.brand == 'basic' && globals.state.branding == 2:
		find_node('enhbrandingtext').visible = true
		###---Added by Expansion---### Patching Brand
		if globals.resources.mana >= 20 && globals.player.energy >= 10:
			confirm.visible = true
			confirm.set_meta('value', 2)
		###---End Expansion---###

func _on_confirm_pressed():
	var confirm = find_node('confirm')
	var popup = find_node('brandpopup')
	popup.visible = false
	if confirm.get_meta('value') == 1:
		person.brand = 'basic'
		###---Added by Expansion---### Patching Brand
		person.dailytalk.append('justbranded')
		person.stress += 15 + person.conf/5 - person.loyal/10
		get_tree().get_current_scene().popup(person.dictionary('You perform a Ritual of Branding on $name. As symbols are engraved onto $his neck, $he yelps in pain. \n\nWith this you put serious claim on $his future life: $He will be unable to raise a hand against you and will be far less tempted to escape. '))
		globals.resources.mana -= 10
		globals.player.energy -= 10
	elif confirm.get_meta('value') == 2:
		person.brand = 'advanced'
		globals.player.energy -= 10
		globals.resources.mana -= 20
		###---End Expansion---###
	slavetabopen()

##############Sleep

###---Added by Expansion---### Added by Deviate
var sleepdict = {
	'communal': 0,
	'personal': 1,
	'your': 2,
	'jail': 3,
	'kennel': 4
}

func sleeprooms():
	$stats/sleep.selected = sleepdict[person.sleep]
	var beds = globals.count_sleepers()
	$stats/sleep.set_item_disabled(1, beds.personal >= globals.state.mansionupgrades.mansionpersonal)
	$stats/sleep.set_item_disabled(2, beds.your_bed == globals.state.mansionupgrades.mansionbed)
	$stats/sleep.set_item_disabled(3, beds.jail >= globals.state.mansionupgrades.jailcapacity)
	###---Added by Expansion---### Added by Deviate
	$stats/sleep.set_item_disabled(4, globals.state.mansionupgrades.mansionkennels == 0)
	###---End Expansion---###

###---Added by Expansion---### Family Expanded
func _on_relativesbutton_pressed():
	var text = ''
	$stats/customization/relativespanel.popup()
	if !relativesdata.has(person.id):
		text = person.dictionary("You don't know anything about $name's relatives. ")
		$stats/customization/relativespanel/relativestext.bbcode_text = text
		return
	var entry = relativesdata[person.id]
	var entry2
	text += '[center]Parents[/center]\n'
	for i in ['father','mother']:
		if int(entry[i]) <= 0 || !relativesdata.has(entry[i]):
			text += i.capitalize() + ": Unknown\n"
		else:
			text += i.capitalize() + ": " + getentrytext(relativesdata[entry[i]]) + "\n"
	
	###---Added by Expansion---### Slime Breeding
	if person.race == 'Slime' || person.genealogy.slime > 0:
		for i in ['slimesire']:
			if entry[i] == null || int(entry[i]) <= 0:
				text += "Slimesire: Unknown\n"
			else:
				if relativesdata.has(entry[i]):
					entry2 = relativesdata[entry[i]]
					text += i.capitalize() + ": "
					if entry2.state == 'free':
						text += "[color=aqua]Free[/color] "
					text += getentrytext(entry2) + "\n"
				else:
					text += i.capitalize() + ": Unknown\n"
	###---End Expansion---###
	
	###---Added by Expansion---### Family Expanded
	var halfsiblings = []
	if !entry.siblings.empty():
		text += '\n[center]Full-Blooded Siblings[/center]\n'
		for i in entry.siblings:
			entry2 = relativesdata[i]
			if int(entry.father) == int(entry2.father) && int(entry.mother) == int(entry2.mother):
				if entry2.state == 'fetus':
					continue
				if entry2.sex == 'male':
					text += "Brother: "
				else:
					text += "Sister: "
				if entry2.state == 'free':
					text += "[color=aqua]Free[/color] "
				text += getentrytext(entry2) + "\n"
			else:
				halfsiblings.append(i)
	
	halfsiblings.append_array(entry.halfsiblings)
	if !halfsiblings.empty():
		text += '\n[center]Half-Siblings[/center]\n'
		for i in halfsiblings:
			entry2 = relativesdata[i]
			if entry2.state == 'fetus':
				continue
			if entry2.sex == 'male':
				text += "Half-Brother: " 
			else:
				text += "Half-Sister: "
			if entry2.state == 'free':
				text += "[color=aqua]Free[/color] "
			text += getentrytext(entry2) + "\n"
	###---End Expansion---###
	
	if !entry.children.empty():
		text += '\n[center]Children[/center]\n'
		for i in entry.children:
			entry2 = relativesdata[i]
			if entry2.state == 'fetus':
				continue
			if entry2.sex == 'male':
				text += "Son: " 
			else:
				text += "Daughter: "
			text += getentrytext(entry2) + "\n"
	$stats/customization/relativespanel/relativestext.bbcode_text = text

###---Added by Expansion---### Renamed Slaves don't Rename | Ank BugFix v4a
func getentrytext(entry):
	var text = ''
	var tempPerson = globals.state.findslave(entry.id)
	if tempPerson != null && tempPerson.away.duration == 0:
		var realname = str(tempPerson.name_long())
		text += '[url=id' + str(entry.id) + '][color=yellow]' + realname + '[/color][/url]'
	else:
		text += entry.name
	if entry.state == 'dead':
		text += " - Deceased"
	elif entry.state == 'free':
		text += " - Roaming Free"
	elif entry.state == 'left' || (tempPerson != null && tempPerson.away.at == 'hidden'):
		text += " - Status Unknown"
	text += ", " + entry.race
	return text

func _on_piercing_pressed():
	$stats/customization/piercingpanel.popup()
	for i in $stats/customization/piercingpanel/ScrollContainer/VBoxContainer.get_children():
		if i.get_name() != 'piercingline' :
			i.visible = false
			i.queue_free()
	if person.consent == true || person == globals.player:
		$stats/customization/piercingpanel/piercestate.set_text(person.dictionary('$name does not seems to mind you pierce $his private places.'))
	else:
		$stats/customization/piercingpanel/piercestate.set_text(person.dictionary('$name refuses to let you pierce $his private places'))
	$stats/customization/piercingpanel/piercestate.visible = person != globals.player
	for i in piercingdict:
		if person.piercing.has(i) == false:
			person.piercing[i] = null
	
	var array = []
	for i in piercingdict.values():
		array.append(i)
	array.sort_custom(self, 'idsort')
	
	###---Added by Expansion---### Vaginal Sizing
	for ii in array:
		if ii.requirement == null || ( person.consent == true && ii.requirement == 'lewdness') || (person.penis != 'none' && person.consent == true && ii.id == 10) || (person.vagina != 'none' && person.consent == true && (ii.id == 8 || ii.id == 9)):
			var newline = $stats/customization/piercingpanel/ScrollContainer/VBoxContainer/piercingline.duplicate()
	###---End Expansion---###
			newline.visible = true
			$stats/customization/piercingpanel/ScrollContainer/VBoxContainer/.add_child(newline)
			newline.get_node("placename").set_text(ii.name.capitalize())
			for i in ii.options:
				newline.get_node("pierceoptions").add_item(i)
				if person.piercing[ii.name] == i:
					newline.get_node("pierceoptions").select(newline.get_node("pierceoptions").get_item_count()-1)
			newline.get_node('pierceoptions').set_meta('pierce', ii.name)
			newline.get_node("pierceoptions").connect("item_selected", self, 'pierceselect', [newline.get_node("pierceoptions").get_meta('pierce')])

func updatestats():
	var text = ''
	var mentals = [$stats/statspanel/cour, $stats/statspanel/conf, $stats/statspanel/wit, $stats/statspanel/charm]
	for i in globals.statsdict:
		text = str(person[i]) 
		get(i).get_node('cur').set_text(text)
		if i in ['sstr','sagi','smaf','send']:
			get(i).get_node('base').set_text(str(person.stats[globals.basestatdict[i]]))
			if person.stats[globals.maxstatdict[i].replace("_max",'_mod')] >= 1:
				get(i).get_node('cur').set('custom_colors/font_color', Color(0,1,0))
			elif person.stats[globals.maxstatdict[i].replace("_max",'_mod')] < 0:
				get(i).get_node('cur').set('custom_colors/font_color', Color(1,0.29,0.29))
			else:
				get(i).get_node('cur').set('custom_colors/font_color', Color(1,1,1))
		get(i).get_node('max').set_text(str(min(person.stats[globals.maxstatdict[i]], person.originvalue[person.origins])))
		#get(i).set_bbcode(text)
	for i in mentals:
		if person == globals.player:
			i.get_parent().visible = false
		else:
			i.get_parent().visible = true
	if !person.traits.empty():
		text = "$name has trait(s): "
		var text2 = ''
		for i in person.get_traits():
			text2 += '[url=' + i.name + ']' + i.name + "[/url]"
			if i.tags.find('sexual') >= 0:
				text2 = "[color=#ff5ace]" + text2 + '[/color]'
			elif i.tags.find('detrimental') >= 0:
				text2 = "[color=#ff4949]" + text2 + '[/color]'
			text2 += ', '
			text += text2
		text = text.substr(0, text.length() - 2) + '.'
	text = person.name_long() + '\n[color=aqua][url=race]' +person.dictionary('$race[/url][/color]').capitalize() +  '\nLevel : '+str(person.level)
	get_node("stats/statspanel/info").set_bbcode(person.dictionary(text))
	get_node("stats/statspanel/attribute").set_text("Free Attribute Points : "+str(person.skillpoints))
	
	for i in ['send','smaf','sstr','sagi']:
		if person.skillpoints >= 1 && (globals.slaves.find(person) >= 0||globals.player == person) && person.stats[globals.maxstatdict[i].replace('_max','_base')] < person.stats[globals.maxstatdict[i]]:
			get_node("stats/statspanel/" + i +'/Button').visible = true
		else:
			get_node("stats/statspanel/" + i+'/Button').visible = false
	if person.levelupreqs.empty() && person.xp < 100:
		$stats/basics/levelupreqs.set_bbcode("")
	get_node("stats/statspanel/hp").set_value((person.stats.health_cur/float(person.stats.health_max))*100)
	get_node("stats/statspanel/en").set_value((person.stats.energy_cur/float(person.stats.energy_max))*100)
	get_node("stats/statspanel/xp").set_value(person.xp)
	text = "Health: " + str(person.stats.health_cur) + "/" + str(person.stats.health_max) + "\nEnergy: " + str(round(person.stats.energy_cur)) + "/" + str(person.stats.energy_max) + "\nExperience: " + str(person.xp) 
	get_node("stats/statspanel/hptooltip").set_tooltip(text)
	get_node("stats/statspanel/grade").set_texture(gradeimages[person.origins])
	###---Added by Expansion---### Jail Images
	if person.imageportait != null && globals.loadimage(person.imageportait):
		$stats/statspanel/TextureRect/portrait.set_texture(globals.loadimage(person.imageportait))
	else:
		person.imageportait = null
		$stats/statspanel/TextureRect/portrait.set_texture(null)
	#---Jail Icons
	if person.sleep == 'jail':
		get_node("stats/statspanel/jailportrait").visible = true
	else:
		get_node("stats/statspanel/jailportrait").visible = false
	###---End Expansion---###
	$stats/statspanel/spec.set_texture(specimages[str(person.spec)])
	if person.xp >= 100:
		get_node("stats/statspanel/xp").tint_progress = Color(2.167,1.176,1.167,1)
		if person.levelupreqs.empty():
			$stats/basics/levelupreqs.set_bbcode(person.dictionary("You don't know what might unlock $name's potential further, yet. "))
		else:
			$stats/basics/levelupreqs.set_bbcode(person.levelupreqs.descript)
	else:
		get_node("stats/statspanel/xp").tint_progress = ColorN("white")
		$stats/basics/levelupreqs.set_bbcode('')
	###---Added by Expansion---### New Images
	#---Movement Icons
	$stats/statspanel/movement.set_texture(movementimages[str(globals.expansion.getMovementIcon(person))])
	#---Sexuality Icons
	$stats/statspanel/sexuality_male.set_texture(sexuality_images[str(person.sexuality_images.male)])
	$stats/statspanel/sexuality_female.set_texture(sexuality_images[str(person.sexuality_images.female)])
	$stats/statspanel/sexuality_futa.set_texture(sexuality_images[str(person.sexuality_images.futa)])
	$stats/statspanel/sexuality_base.set_texture(sexuality_images[str(person.sexuality_images.base)])
	###---End Expansion---###

func _on_hairstyle_item_selected( ID ):
	person = globals.currentslave
	var hairstyles = ['bald', 'straight', 'ponytail', 'twintails', 'braid', 'two braids', 'bun']
	person.hairstyle = hairstyles[ID]
	slavetabopen()

var gradeimages = globals.gradeimages

var specimages = globals.specimages


func _on_traittext_meta_clicked( meta ):
	var text = globals.origins.trait(meta).description
	globals.showtooltip(person.dictionary(text))


func _on_traittext_mouse_exit():
	globals.hidetooltip()


#warning-ignore:unused_argument
func _on_info_meta_clicked( meta ):
	get_tree().get_current_scene().showracedescript(person)

func _on_spec_mouse_entered():
	var text 
	if person.spec == null:
		text = "Specialization can provide special abilities and effects and can be trained at Slavers' Guild. "
	else:
		var spec = globals.jobs.specs[person.spec]
		text = "[center]" + spec.name + '[/center]\n'+ spec.descript + "\n[color=aqua]" +  spec.descriptbonus + '[/color]'
	globals.showtooltip(text)


func _on_spec_mouse_exited():
	globals.hidetooltip()


func _on_inspect_pressed():
	$stats/inspect.pressed = true
	$stats/customize.pressed = false
	$stats/basics.visible = true
	$stats/customization.visible = false

func _on_customize_pressed():
	$stats/inspect.pressed = false
	$stats/customize.pressed = true
	$stats/basics.visible = false
	$stats/customization.visible = true




func _on_fullbodycheck_pressed():
	globals.rules.showfullbody = $stats/basics/fullbodycheck.pressed
	globals.overwritesettings()
	slavetabopen()


func _process(delta):
	var panel = $stats/basics/bodypanel
	if panel.is_visible_in_tree():
		if globals.main && globals.main.get_node("dialogue").visible:
			panel.modulate.a = max(panel.modulate.a - 0.1, 0.0)
		else:
			var pos = panel.get_local_mouse_position()
			var area = panel.rect_size
			var val = -0.05 if (0 <= pos.x && 0 <= pos.y && pos.x <= area.x && pos.y <= area.y) else 0.05
			panel.modulate.a = clamp(panel.modulate.a + val, 0.2, 1.0)

###---Added by Expansion---### New Images and Icons
#---Movement Images
var movementimages = globals.movementimages

func _on_movement_mouse_entered():
	var text 
	if person.movement == 'walk':
		text = "[center][color=aqua]Normal Movement.[/color][/center]\n$name is walking around like normal."
	elif person.movement == 'fly':
		text = "[center][color=aqua]Will Fly until under 50 Energy[/color][/center]\n$name is currently flapping $his wings and hovering a foot or two off of the ground.\n\n[color=green]Attack and Speed increased by 125%\n[/color]"
	elif person.movement == 'crawl':
		text = "[center][color=red]Only able to Crawl.\nAttack and Speed Penalties in Combat.\nWill not Join the Party.\nUnable to work many jobs.[/color][/center]\n$name is currently crawling on the ground on all fours.\n\n"
	elif person.movement == 'none':
		text = "[center][color=red]Unable to Move.\nAttack and Speed Penalties in Combat.\nWill not Join the Party.\nUnable to work many jobs.[/color][/center]\n$name is currently unable to move at all. $He is currently completely incapacitated."
	else:
		text = "[center][color=red]Error[/color][/center]\n$name is somehow moving in an unnatural way. While interesting, you may want to report this to Aric on the itch.io forums or Discord. "
	
	#Give Reason for Crawling/Immobilized
	text += "\n\nReason for Movement: " + PoolStringArray(person.movementreasons).join("\n")
	
	globals.showtooltip( person.dictionary(text))

func _on_movement_mouse_exited():
	globals.hidetooltip()

#---Sexuality Images
var sexuality_images = globals.sexuality_images

func _on_sexuality_mouse_entered():
	var text
	if person.knowledge.has('sexuality'):
		match person.sexuality:
			'straight':
				text = "[center][color=yellow]Straight[/color][/center]\n$name is as straight as straight can be, only enjoying sexual relations with members of the opposite sex.\n\n[color=aqua]No chance of arousal penalty to any members of the opposite sex.[/color]\n[color=red]Guaranteed chance of arousal penalty to any members of the same sex.[/color]"
			'mostlystraight':
				text = "[center][color=yellow]Usually Straight[/color][/center]\n$name is pretty straight, but a particularly attractive member of the same sex may sway them.\n\n[color=aqua]Slight chance of arousal penalty to any members of the opposite sex.[/color]\n[color=red]High chance of arousal penalty to any members of the same sex.[/color]"
			'rarelygay':
				text = "[center][color=yellow]Very Rarely Feels Gay[/color][/center]\n$name is generally straight, but $he has had some homosexual experiences in the past and isn't opposed to them.\n\n[color=aqua]Low chance of arousal penalty to any members of the opposite sex.[/color]\n[color=red]Decent chance of arousal penalty to any members of the same sex.[/color]"
			'bi':
				text = "[center][color=yellow]Bisexual[/color][/center]\n$name identifies as truly bisexual and will consider sex with anyone of any gender.\n\n[color=aqua]Low chance of arousal penalty to any members of the opposite sex.[/color]\n[color=aqua]Low chance of arousal penalty to any members of the same sex.[/color]"
			'rarelystraight':
				text = "[center][color=yellow]Very Rarely Feels Straight[/color][/center]\n$name is generally homosexual, but $he has had some straight experiences in the past and isn't opposed to them.\n\n[color=red]Decent chance of arousal penalty to any members of the opposite sex.[/color]\n[color=aqua]Low chance of arousal penalty to any members of the same sex.[/color]"
			'mostlygay':
				text = "[center][color=yellow]Usually Gay[/color][/center]\n$name is pretty homosexual, but a particularly attractive member of the opposite sex may sway them.\n\n[color=red]High chance of arousal penalty to any members of the opposite sex.[/color]\n[color=aqua]Slight chance of arousal penalty to any members of the same sex.[/color]"
			'gay':
				text = "[center][color=yellow]Gay[/color][/center]\n$name is as gay as gay can be, only enjoying sexual relations with members of the same sex.\n\n[color=red]Guaranteed chance of arousal penalty to any members of the opposite sex.[/color]\n[color=aqua]No chance of arousal penalty to any members of the same sex.[/color]"
	else:
		text = "[center][color=yellow]Unknown[/color][/center]\nYou don't know anything about $name's sexual preferences. You can ask $him about $his [color=aqua]Sexuality[/color] if you [color=green]Talk[/color] to $him."
	text = person.dictionary(text)
	globals.showtooltip(text)

func _on_sexuality_mouse_exited():
	globals.hidetooltip()

###---Added by Expansion---###
#---Strip Toggle
func _on_strip_toggle_pressed():
	person.exposed.chest = $stats/customization/ae_strip_toggle.pressed
	person.exposed.genitals = $stats/customization/ae_strip_toggle.pressed
	person.exposed.ass = $stats/customization/ae_strip_toggle.pressed
	slavetabopen()

#---Whim's Name Coloration
var namecolors = ['blue', 'brown', 'cyan', 'fuchsia', 'gold', 'gray', 'green', 'orange', 'purple', 'red', 'salmon', 'sienna', 'tan', 'violet', 'white', 'yellow']

func _on_namecolor_item_selected(id):
	person.namecolor = namecolors[id]
	get_tree().get_current_scene().rebuild_slave_list()
###---End Expansion---###
