### <CustomFile> ###
extends Node

var activeperson

func slimeTopics(person, mode = ''):
	#This is the hop for all Slime Topics
	var text = ""
	var state = false
	var buttons = []
	var sprite = []
	
	if mode == 'intro':
		globals.expansion_slimebreeding.activeperson = person
		text = str(expansion.getIntro(person)) + "\n[color=yellow]-"+ person.quirk(str(talk.introGeneral(person))) + "[/color]"
	
		#Split (Add Serum or Random Split chance?)
		if person.level >= 3:
			
	
		#Alter Penis
		if person.penis == 'none':
			buttons.append({text = "Grow a " + str(globals.expansion.namePenis()), function = 'slimeTopics', args = 'add_penis', tooltip = "Grow a Penis"})
		else:
			if person.penis != globals.penissizearray[0]:
				buttons.append({text = "Increase your " + str(globals.expansion.namePenis()) + " size", function = 'slimeTopics', args = 'grow_penis', tooltip = "Increase Penis Size"})
			if person.penis != globals.penissizearray.back():
				buttons.append({text = "Decrease your " + str(globals.expansion.namePenis()) + " size", function = 'slimeTopics', args = 'shrink_penis', tooltip = "Shrink Penis Size"})
			buttons.append({text = "Dissolve your " + str(globals.expansion.namePenis()), function = 'slimeTopics', args = 'remove_penis', tooltip = "Remove Penis"})
		
		#Alter Vagina
		if person.vagina == 'none':
			buttons.append({text = "Grow a " + str(globals.expansion.Pussy()), function = 'slimeTopics', args = 'add_vagina', tooltip = "Grow a Vagina"})
		else:
			if person.vagina != globals.vagsizearray[0]:
				buttons.append({text = "Increase your " + str(globals.expansion.namePussy()) + " size", function = 'slimeTopics', args = 'grow_vagina', tooltip = "Increase Vagina Size"})
			if person.vagina != globals.vagsizearray.back():
				buttons.append({text = "Decrease your " + str(globals.expansion.namePussy()) + " size", function = 'slimeTopics', args = 'shrink_vagina', tooltip = "Shrink Vagina Size"})
			buttons.append({text = "Dissolve your " + str(globals.expansion.namePussy()), function = 'slimeTopics', args = 'remove_vagina', tooltip = "Remove Penis"})
		
	
	buttons.append({text = str(globals.randomitemfromarray(['Nevermind','Go Back','Return','Cancel'])), function = '_on_talk_pressed', tooltip = "Go back to the previous screen"})
	if nakedspritesdict.has(person.unique):
		if person.consent:
			sprite = [[nakedspritesdict[person.unique].clothcons, 'pos1']]
		else:
			sprite = [[nakedspritesdict[person.unique].clothrape, 'pos1']]
	elif person.imagefull != null:
		sprite = [[person.imagefull,'pos1','opac']]
	get_tree().get_current_scene().dialogue(state, self, person.dictionary(text), buttons, sprite)
	get_tree().get_current_scene().rebuild_slave_list()
	get_parent().slavetabopen()


#Slime Conversion
func slimeConversionCheck(mother, father):
	var text = ""
	var strongestgenes = 0
	if father == null:
		return
	
	var conversionstrength = father.level*(1+(resources.day - father.lastsexday))
	var rapidpregnancydamage = 0
	
	for i in mother.preg.unborn_baby:
		baby = globals.state.findslave(i.id)
		#Find "Purest" Genes
		for genes in baby.genealogy:
			if baby.genealogy[genes] > 0:
				strongestgenes = baby.genealogy[genes]
		
		if rand_range(0,100) + conversionstrength > strongestgenes:
			baby.race = 'Slime'
			baby.race_type == 4
			expansionsetup.setRaceBonus(baby, false)
			for genes in baby.genealogy:
				if genes != 'slime' && baby.genealogy[genes] > 0:
					baby.genealogy[genes] = 0
				elif genes == 'slime':
					baby.genealogy[genes] = 100
			expansionsetup.setRaceBonus(baby, true)
			if father.id != ['-1'] && father.id != null:
				globals.connectrelatives(father, baby, 'slimesire')
			
			rapidpregnancydamage = (globals.state.pregduration-1) - person.preg.duration
			person.preg.duration = globals.state.pregduration-1
			mother.stress += rapidpregnancydamage*2
			mother.health -= rapidpregnancydamage
			text += mother.dictionary("$name felt a shift in $his body from the slimey goo inside of $him. $His baby, " + baby.dictionary("$name ") + mother.dictionary(", has been warped into a Slime and is about to ooze out of $him. Health -"+str(rapidpregnancydamage)+" / Stress +"+str(rapidpregnancydamage*2)))
	
	if get_tree().get_current_scene().has_node("infotext") && globals.slaves.find(mother) >= 0 && mother.away.at != 'hidden':
		get_tree().get_current_scene().infotext(text,'red')
	
	return

func checkSlimeSplitReq(person):
	var success = false
	if person.race.find('Slime') >= 0 || person.genealogy.slime >= 100:
		if person.level >= 4:
			success = true
	return success

#Slime Split
#Prompt #, Cap at Level

func slimeSplit(person, offspringwanted = 1):
	if person == null:
		print('Slime Split Invalid, No Person Object Found')
		return
	
	var offspring = clamp(offspringwanted, 1, person.level)
	var strmod = clamp(round(person.sstr/2), 0, 10)
	var agimod = clamp(round(person.sagi/2), 0, 10)
	var mafmod = clamp(round(person.smaf/2), 0, 10)
	var endmod = clamp(round(person.send/2), 0, 10)
	
	


