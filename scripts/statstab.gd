###---Added by Expansion---###
#Added 'person.quirk(__text__) into each dialogue coming from a slave

#Look for "#Change Dialogue" for what needs Randomization via personality/traits
var expansion = globals.expansion
var talk = globals.expansiontalk
###---Expansion End---###

func chooseability(ability):
	var text = ''
	var confirmbutton = get_node("trainingabilspanel/abilityconfirm")
	###---Added by Expansion---### Racial Abilities
	var dict = {'sstr': 'Strength', 'sagi' : 'Agility', 'smaf': 'Magic', 'level': 'Level', 'race': 'Primary Race', 'spec': 'Spec'}
	###---End Expansion---###
	for i in get_node("trainingabilspanel/ScrollContainer/VBoxContainer").get_children():
		if i.get_text() != ability.name:
			i.set_pressed(false)
	
	confirmbutton.set_disabled(false)
	
	text = '[center]'+ ability.name + '[/center]\n' + ability.description + '\nCooldown:' + str(ability.cooldown) + '\nLearn requirements: ' 
	if ability.has('iconnorm'):
		$trainingabilspanel/abilityicon.texture = ability.iconnorm
	else:
		$trainingabilspanel/abilityicon.texture = null
	var array = []
	for i in ability.reqs:
		array.append(i)
	array.sort_custom(self, 'levelfirst')
	
	for i in array:
		var temp = i
		var ref = person
		if i.find('.') >= 0:
			temp = i.split('.')
			for ii in temp:
				ref = ref[ii]
		else:
			ref = person[i]
		###---Added by Expansion---### Racial Abilities
		if i == 'race':
			if ref != ability.reqs[i]:
				confirmbutton.set_disabled(true)
				text += '[color=#ff4949]'+dict[i] + ': ' + str(ability.reqs[i]) + '[/color], '
			else:
				text += '[color=green]'+dict[i] + ': ' + str(ability.reqs[i]) + '[/color], '
		elif typeof(ability.reqs[i]) == TYPE_ARRAY: # Capitulize - Specialization based abilities 
			if !ability.reqs[i].has(ref):
				confirmbutton.set_disabled(true)
				text += '[color=#ff4949]'+dict[i] + ': ' + str(ability.reqs[i]) + '[/color], '
			else:
				text += '[color=green]'+dict[i] + ': ' + str(ability.reqs[i]) + '[/color], ' # /Capitulize: Fix this someday ugh
		elif ref < ability.reqs[i]:
			confirmbutton.set_disabled(true)
		###---End Expansion---###
			text += '[color=#ff4949]'+dict[i] + ': ' + str(ability.reqs[i]) + '[/color], '
		else:
			text += '[color=green]'+dict[i] + ': ' + str(ability.reqs[i]) + '[/color], '
	text = text.substr(0, text.length() - 2) + '.'
	
	if ability.has("learncost"):
		text += "\nRequred learning points: [color=aqua]" + str(ability.learncost) + "[/color]"
	
	confirmbutton.set_meta('abil', ability)
	
	
	
	if person.ability.find(ability.code) >= 0:
		confirmbutton.set_disabled(true)
		text += person.dictionary('\n[color=green]$name already knows this ability. [/color]')
	elif globals.resources.gold < ability.price:
		text += '\n\n[color=#ff4949]Price to learn: ' + str(ability.price) + ' gold.[/color]' 
		confirmbutton.set_disabled(true)
	else:
		text += '\n\n[color=green]Price to learn: ' + str(ability.price) + ' gold.[/color]' 
	
	
	if ability.has('requiredspell') == true:
		if globals.spelldict[ability.requiredspell].learned == false:
			confirmbutton.set_disabled(true)
			text += person.dictionary('\n[color=#ff4949]You must purchase this spell before you will be able to teach it others. [/color]')
	get_node("trainingabilspanel/abilitytext").set_bbcode(text)

func updateSprites(person):
	var sprite = []
	if nakedspritesdict.has(person.unique) && person.imageportait == globals.characters.characters[person.unique].get('imageportait','') && person.imagetype != 'naked':
		if person.obed >= 50 || person.stress < 10:
			sprite.append([nakedspritesdict[person.unique].clothcons, 'slave', 'opac'])
		else:
			sprite.append([nakedspritesdict[person.unique].clothrape, 'slave', 'opac'])
	elif person.imagefull != null:
		sprite.append([person.imagefull,'slave','opac'])
	if globals.player.imagefull != null:
		sprite.append([globals.player.imagefull,'player','opac'])
	return sprite

func _on_talk_pressed(mode = 'talk'):
	var state = true
	var buttons = []
	var text = ''

	###---Added by Expansion---###
	var difference = 0
	#Quick Update
	expansion.updatePerson(globals.player)
	expansion.updatePerson(person)
	#Setting Speech and Master's Name
	if person.randomname == true:
		talk.getMasterName(person)
	###---End Expansion---###

	if person.unique == 'Cali' && globals.state.sidequests.cali in [12,13,22]:
		globals.events.calitalk0()
		return
	elif person.unique == 'Ayda' && globals.state.sidequests.ayda in [9,12,15]:
		globals.events.aydapersonaltalk()
		return
	if mode == 'talk':
		###---Added by Expansion---###
		text = str(expansion.getLocation(person)) + " " + str(expansion.getIntro(person))
		text += "\n[color=yellow]-"+ person.quirk(str(talk.introGeneral(person))) + "[/color]"
		#Old Text
		#if person.sleep == 'jail':
		#	text = "You enter jail cell with $name handcuffed in it. "
		#else:
		#	text = "You summon $name to your apartments. "
		#if person.rules.silence:
		#	text = "After giving $him a permission to talk, you begin a conversation. "
		###---End Expansion---###
		text += '\n\n'

		###---Added by Expansion---### Cheat/Test Button
		if globals.expansionsettings.enablecheatbutton == true:
			buttons.append({text = "Piece of Candy?", function = 'cheatButton', args = 'intro', tooltip = 'You cheater'})
		###---End Expansion---###

		###---Added by Expansion---### Events
		
		#---Pregnancy Events
		#Discover Pregnancy Event
		if person.dailytalk.has('currentpregnancy'):
			text += "$He is holding $his " +expansion.nameBelly()+ " with a shy smile.\n\n[color=yellow]" + person.quirk("-$master, I have some news. I think it's good news![/color]\n")
			buttons.append({text = person.dictionary(str(globals.randomitemfromarray(["What is your news, $name?","$name, what is it?","Does your stomach hurt?"]))), function = 'eventPregnancyReveal', args = 'introtold', textcolor = 'green', tooltip = person.dictionary("What is $his news?")})
		elif !person.knowledge.has('currentpregnancy') && person.preg.duration > 0:
			if person.mind.secrets.has('currentpregnancy'):
				text += "You notice that $he is trying to casually keep $his arms or hands over $his " +expansion.nameBelly()+ " as though to block your view of it.\n"
			else:
				text += "You notice that $he seems to be unconsciously rubbing and holding $his " +expansion.nameBelly()+ ".\n"
			buttons.append({text = person.dictionary(str(globals.randomitemfromarray(["What is going on with your " +expansion.nameBelly()+"?","Does your stomach hurt?","Are you pregnant?"]))), function = 'eventPregnancyReveal', args = 'introdiscovered', tooltip = person.dictionary("$He sure is favoring that belly...")})

		#Wanted Baby Event
		if person.dailytalk.has('wantpregnancy') && !person.knowledge.has('currentpregnancywanted') && person.knowledge.has('currentpregnancy'):
			text += person.quirk("[color=yellow]-So...I'm pregnant. I want to talk to you about that.[/color]")
			buttons.append({text = person.dictionary("'What about your pregnancy, $name?"), function = 'eventWantedPregnancy', args = 'intro', tooltip = "Respond to her mentioning her pregnancy."})

		#Discover Lactation
		if !person.dailytalk.has('lactating') && !person.knowledge.has('lactating') && person.lactation == true:
			expansion.getMilkLeak(person,person.lactating.pressure*10)
			if person.lactating.leaking > 0:
				if person.exposed.chest == true:
					text += "[color=aqua]You notice a drizzle of milk trickle out of $his nipple and start to trace down $his " +expansion.nameBelly()+".[/color]\n"
				else:
					text += "[color=aqua]You notice a dark, wet spot slowly creep across $his shirt right over $his nipples.[/color]\n"
				buttons.append({text = person.dictionary(str(globals.randomitemfromarray(["Is that milk I see, $name?","You seem to be leaking there, $name.","So. You are lactating."]))), function = 'eventLactation', args = 'introdiscovered', tooltip = person.dictionary("Was $he trying to hide it?")})
		elif person.dailytalk.has('lactating'):
			text += person.quirk("$He seems to think for a moment, then hesitantly speaks.\n[color=yellow]-$master? I...I would like to show you something.[/color]")
			buttons.append({text = "What did you want to talk about?", function = 'eventLactation', args = 'introtold', tooltip = person.dictionary("What does $he want?")})
		
		#---Transformation Events
		#Sex Change from Potion
		if person.dailyevents.has('sex_changed_potion'):
			text += "$He is holding $his crotch with an odd look on $his face. "
			var transformation_factors = 0
			#Fetish
			if person.checkFetish('transformation', 0, false):
				transformation_factors += 50
			else:
				transformation_factors -= 50
			#Traits
			for positive_trait in ['Pervert','Pliable','Grateful']:
				if person.traits.has(positive_trait):
					transformation_factors += 25
			for negative_trait in ['Prude','Dominant']:
				if person.traits.has(negative_trait):
					transformation_factors -= 25
			if rand_range(0,100) <= person.loyal + transformation_factors:
				text += person.quirk("\n[color=yellow]-$master? I think I am getting used to how this feels. It is a little strange...but I think I might enjoy being a $sex.[/color]")
			else:
				text += person.quirk("\n[color=yellow]-$master, I cannot believe that you forced me to become a $sex. I don't even know who I am anymore! [/color]")
				person.loyal -= round(rand_range(2,5))
			person.dailyevents.erase('sex_changed_potion')
		
		#---Consent Events
		#Incest Consent Given
		if person.dailytalk.has('incestconsentgiven') && person.consentexp.incest == false:
			#Alter to Personality Changes Dialogue and Player Yes/No response
			text += person.quirk("[color=yellow]-I've been thinking and I don't think that Incest is really THAT bad. What do you think?[/color]")
			buttons.append({text = str(globals.randomitemfromarray(['So you are okay with incest now, '])) + person.dictionary(" $name?"), function = 'eventIncestConsentGiven', args = 'intro', tooltip = "Respond to her mentioning Incest."})
		
		#Incest Consent Removed
		if person.dailytalk.has('consentincestremoved') && person.consentexp.incest == true:
			text += person.quirk("[color=yellow]-I've been thinking and I just can't do incestuous actions anymore. It is just way too taboo for me to be comfortable with.[/color]")
			buttons.append({text = 'So you are okay with incest now, ' + person.dictionary(" $name?"), function = 'eventIncestConsentRemoved', args = 'intro', tooltip = "Respond to her mentioning Incest."})

		###Jail Content Alert
		if person.sleep == 'jail' && !globals.player.dailytalk.has('aricjailalert'):
			globals.player.dailytalk.append('aricjailalert')
			text += "\n[color=red]Aric's Note: Jail Dialogue Content Coming Soon![/color]\n"

#		if person.obed < 50:
#			text = text + "— I don't wanna talk with you afterF all you've done!\n"
#		elif person.traits.has('Sex-crazed') == true:
#			text = text + "— I don't care about my life, or anything, can we just fuck here, Master?"
#		else:
#			if person.loyal < 25:
#				text = text + '— Yes, I will obey your orders, $master. \n'
#				if person.brand != 'none':
#					text = text + "It's not like I have much of an option anyway. \n$name gives you a trapped look. "
#			elif person.loyal < 60:
#				text = text + "—It wasn't easy at first, but I think warmly of you, $master. \n"
#				if person.brand != 'none':
#					text = text + "Even though I'm just your little slave now. \n"
#			else:
#				text = text + "— I'll try my best for you, $master. Despite what others might think, you are invaluable to me!\n"
		###---Expansion End---###
			if person.stress > 50:
				text = text + "— It has been tough for me recently... Could you consider giving me a small break, please?\n"
			if person.lust >= 60 && person.consent == true && person.metrics.vag > 0:
				text = text + "— I actually would love to fuck right now. \n"
			elif person.lust >= 60 && person.consent == true:
				text = text + "— Uhm... would you like to give me some private attention? — $name gives you a deep lusting look. \n"
		if person.xp >= 100 && person.levelupreqs.has('code') == false:
			buttons.append({text = person.dictionary("Investigate $name's potential"), function = 'levelreqs'})
		elif person.levelupreqs.has('code'):
			text += "\n\n[color=yellow]Your investigation shown, that " + person.dictionary(person.levelupreqs.speech) + '[/color]'
			if person.levelupreqs.activate == 'fromtalk':
				buttons.append({text = person.levelupreqs.button, function = 'levelup', args = person.levelupreqs.effect})
		if person.unique == 'Zoe' && globals.state.sidequests.zoe == 5:
			if globals.state.getCountStackableItem('teleportseal') >= 10 && globals.state.getCountStackableItem('taintedessenceing') >= 5 && globals.state.getCountStackableItem('magicessenceing') >= 5:
				buttons.append({text = "Give Zoe requested items", function = 'zoequest'})
			else:
				buttons.append({text = "Give Zoe requested items", function = 'zoequest', disabled = true, tooltip = "You don't have everything requested."})

		###---Added by Expansion---###

		#General Slave Topics
		buttons.append({text = str(globals.randomitemfromarray(['General Slave Topics','General Slave Matters','General Slave Issues'])), function = '_on_talk_pressed', args = 'general_slave_topics', tooltip = "General topics for all slaves such as changing the Master Name, Releasing the Slave, etc"})

		#Slave Sex Topics
		buttons.append({text = 'Sexual Topics', function = '_on_talk_pressed', args = 'slave_sex_topics', tooltip = "Topics regarding to Sex and Sexuality"})

		#Once a Day Convos
		buttons.append({text = str(globals.randomitemfromarray(["I'd like a quick word.",'Can we talk quickly?',"Let's have a quick chat","One quick thing..."])), function = 'oneperdayconvos', args = 'intro', tooltip = "These conversations that can be held once per day per slave"})

		#Dimensional Crystal Topics - TBK Remove if Unneeded?
#		if person.work == 'headgirl' || person.sleep != 'jail':
#			buttons.append({text = person.dictionary("Walk with me to the Crystal"), function = 'thecrystal', args = 'intro', tooltip = "Take $him to the Crystal to Research or Use Abilities there."})

		#Head Girl Topics
		if person.work == 'headgirl':
			buttons.append({text = person.dictionary("Lets talk about running this mansion."), function = 'headgirltopics', args = 'intro'})

		#Farm Manager Topics (Disabled pending Farm Manager Convo rework)
#		if person.work == 'farmmanager':
#			buttons.append({text = person.dictionary("Lets talk about running the farm."), function = 'farmmanagertopics', args = 'intro'})

		#Consent Topics (Valid for All)
#		buttons.append({text = person.dictionary("I want to ask you something"), function = 'consent', args = 'intro'})

		#Quick Strip Option (Unneeded with Toggle?)
#		if (person.exposed.chest == false || person.exposed.genitals == false || person.exposed.ass == false) && person.obed >= 50:
#			buttons.append({text = person.dictionary("Strip Immediately!"), function = 'topicclothing', args = 'full strip', tooltip = "Remove all Clothing"})		

		#Succubus Talk Options	#ralphC
		if person.race_display == 'Succubus':
			#buttons.append({text = str(globals.randomitemfromarray(['General Slave Topics','General Slave Matters','General Slave Issues'])), function = '_on_talk_pressed', args = 'general_slave_topics', tooltip = "General topics for all slaves such as changing the Master Name, Releasing the Slave, etc"})
			buttons.append({text = person.dictionary("Lets talk about your hunger."), function = 'succubustopics', args = 'intro'})
		#/ralphC

	#General Slave Topics
	elif mode == 'general_slave_topics':
		text = str(expansion.getIntro(person)) + "\n[color=yellow]-"+ person.quirk(str(talk.introGeneral(person))) + "[/color]"
		#Change or Set Master's Noun
		if person.randomname == true:
			buttons.append({text = person.dictionary("You should call me ___"), function = 'callorder', args = 'static', tooltip = "Designate what you want them to call you."})
		else:
			buttons.append({text = person.dictionary("You can call me whatever you want."), function = 'callorder', args = 'random', tooltip = "They will call you a randomly selected Master name."})
		
		#Renaming Options
		buttons.append({text = str(globals.randomitemfromarray(['I want to change your name.','Your name is now...','I do not like your name...'])), function = 'slave_rename_hub', args = 'intro', tooltip = "Change the slave's name."})
		
		#Nudity Options
		var nudebuttontext = str(globals.randomitemfromarray(['Strip that ' + str(person.race) + ' body','Show me your ' + str(globals.randomitemfromarray(['Naked Body','Chest','Genitals']))]))
		buttons.append({text = person.dictionary(nudebuttontext), function = 'topicclothing', args = 'intro', tooltip = person.dictionary("Change $name's level of clothing.")})

		#Job Skills
		buttons.append({text = str(globals.randomitemfromarray(['Lets talk about your Job Skills','What Job Experience do you have?','What jobs have you been assigned to?'])), function = '_on_talk_pressed', args = 'general_slave_topics_jobskills', tooltip = "Display their relevant Job Skills."})
		
		buttons.append({text = str(globals.randomitemfromarray(['Release','Free','Remove','Set free'])) + person.dictionary(" $name"), function = 'release', tooltip = "You will lose this slave permanently."})
		buttons.append({text = str(globals.randomitemfromarray(['Go Back','Return','Previous Menu'])), function = '_on_talk_pressed', tooltip = "Go back to the previous screen"})
		#---End Expansion---#
	
	#---Number of Children---#
	elif mode == 'general_slave_topics_numberofkids':
		person.dailytalk.append('desiredoffspring')
		if rand_range(0,100) <= (person.loyal*.25) + (person.obed*.25) + (globals.fetishopinion.find(person.fetish.pregnancy) * 5) + rand_range(0,25) || checkEntrancement() == true:
			person.knowledge.append('desiredoffspring')
			text = str(expansion.getIntro(person)) + " $name thinks for a moment.\n[color=yellow]-"+ person.quirk('I think...about ' +str(person.pregexp.desiredoffspring)+ ' would be nice.')
			buttons.append({text = str(globals.randomitemfromarray(['More is better','That is not enough','I would say to have more',"Isn't more better?"])), function = '_on_talk_pressed', args = 'general_slave_topics_morekids', tooltip = person.dictionary("Encourage $name to have more kids.")})
			buttons.append({text = str(globals.randomitemfromarray(['Me too','I agree','Good to know','Thanks for telling me'])), function = '_on_talk_pressed', args = 'general_slave_topics', tooltip = "Go back to the previous screen"})
			buttons.append({text = str(globals.randomitemfromarray(['Less is better','That is too many','Thats a whole lot'])), function = '_on_talk_pressed', args = 'general_slave_topics_lesskids', tooltip = person.dictionary("Encourage $name to have less kids.")})
		else:
			expansion.updateMood(person,-1)
			text = str(expansion.getIntro(person)) + " $name shakes $his head.\n[color=yellow]-"+ person.quirk('Why do you think I would tell you that?')
	elif mode == 'general_slave_topics_numberofkidsknown':
		person.dailytalk.append('desiredoffspring')
		text = str(expansion.getIntro(person)) + " $name looks at you expectantly.\n[color=yellow]-"+ person.quirk('I want to have ' +str(person.pregexp.desiredoffspring)+ ' like I said last time. Why do you ask?')
		buttons.append({text = str(globals.randomitemfromarray(['More is better','That is not enough','I would say to have more',"Isn't more better?"])), function = '_on_talk_pressed', args = 'general_slave_topics_morekids', tooltip = person.dictionary("Encourage $name to have more kids.")})
		buttons.append({text = str(globals.randomitemfromarray(['Less is better','That is too many','Thats a whole lot'])), function = '_on_talk_pressed', args = 'general_slave_topics_lesskids', tooltip = person.dictionary("Encourage $name to have less kids.")})	
		buttons.append({text = str(globals.randomitemfromarray(['Nevermind','Oh, I remember now','That sounds good','Okay'])), function = '_on_talk_pressed', args = 'general_slave_topics', tooltip = "Go back to the previous screen"})
	elif mode == 'general_slave_topics_morekids':
		difference = round(((person.pregexp.desiredoffspring-(person.metrics.birth*1.35)) + person.instinct.reproduce)*.5)
		difference = clamp(difference,.5,3)
		#Add checkReaction
		if person.checkFetish('pregnancy', difference) && rand_range(0,100) <= 75|| checkEntrancement() == true:
			person.pregexp.desiredoffspring += 1
			text = str(expansion.getIntro(person)) + " $name thinks for a moment.\n[color=yellow]-"+ person.quirk('I suppose more would be nice. Maybe '+str(person.pregexp.desiredoffspring)+ '?')
			text += usedEntrancement()
		else:
			text = str(expansion.getIntro(person)) + " $name thinks for a moment.\n[color=yellow]-"+ person.quirk('No...no...'+str(person.pregexp.desiredoffspring)+ ' is plenty.')
		buttons.append({text = str(globals.randomitemfromarray(['Go Back','Return','Previous Menu'])), function = '_on_talk_pressed', tooltip = "Go back to the previous screen"})
	elif mode == 'general_slave_topics_lesskids':
		difference = round((person.loyal - ((person.pregexp.desiredoffspring-person.metrics.birth) + person.instinct.reproduce))*.1)
		difference = clamp(difference,.5,3)
		#Add checkReaction
		if person.checkFetish('pregnancy',difference) && rand_range(0,100) <= 75 || checkEntrancement() == true:
			person.pregexp.desiredoffspring -= 1
			if person.pregexp.desiredoffspring < 0:
				person.pregexp.desiredoffspring = 0
			text = str(expansion.getIntro(person)) + " $name thinks for a moment.\n[color=yellow]-"+ person.quirk('I suppose less would be less stressful. Maybe '+str(person.pregexp.desiredoffspring)+ '?')
			text += usedEntrancement()
		else:
			text = str(expansion.getIntro(person)) + " $name thinks for a moment.\n[color=yellow]-"+ person.quirk('No...no...'+str(person.pregexp.desiredoffspring)+ ' is what I want.')
		buttons.append({text = str(globals.randomitemfromarray(['Go Back','Return','Previous Menu'])), function = '_on_talk_pressed', tooltip = "Go back to the previous screen"})
	#---Number of Children End---#	
	#---Jobskills
	elif mode == 'general_slave_topics_jobskills':
		var firstskill = true
		if person.sleep != 'jail':
			for i in person.jobskills:
				if person.jobskills[i] > 0:
					if firstskill == true:
						text = str(expansion.getIntro(person)) + "\n[color=aqua]$name[/color] begins describing $his past job experience. You are able to glean the following from $him.\n"
						firstskill = false
					text += "\n[color=aqua]" + str(i).capitalize() + "[/color]: [color=lime]" + str(person.jobskills[i]) + "[/color]\nBonus [color=yellow]"
					#Job Skill Detail
					if i == 'trainer':
						text += " Affects the Chance of receiving a Critical Success Bonus while working with multiple Trainees. Maximum of 50% Chance"
					elif i == 'trainee':
						text += " Affects the Chance of receiving a Critical Success Bonus while being Trained. Maximum of 50% Chance"
					elif i == 'milking':
						text += " Affects the Chance of Manually Extracting Liquid from Cattle and Improves Cattle Reactions. "
					elif i == 'stud':
						text += " Lowers the Energy Cost of Breeding Cattle. "
					elif i == 'bottler':
						text += " Lowers the Energy Cost of Bottling Liquids and allows more Bottles completed per day. "
					elif i == 'cook':
						text += " Affects the Chance of getting 3x Food per Liquid converted from the farm instead of 2x. - [color=aqua]" + str(person.jobskills.cook + (person.wit/2)) + "%[/color] Also affects the chance to gain Bonus Food per day.  [color=aqua]-" + str(clamp(person.jobskills.cook, 0, 50)) + "%[/color] "
					elif i == 'milkmerchant':
						text += " Affects the Chance of increasing a Town's interest in Milk, increasing the overall value. - [color=aqua]" + str(person.jobskills.milkmerchant + person.wit) + "%[/color] "
					elif i == 'farmmanager':
						text += " [color=red]Currently Unused due to Farm Changes[/color] "
					elif i == 'sexworker':
						text += " Increases the bonus to Sex Work by [color=aqua]" + str(round(person.jobskills['sexworker']*.2)) + "[/color]. "
					elif i == 'forager':
						text += " Decreases the chance of bringing back less food due to low Courage and increases the chance of finding Nature Essence. [color=aqua]- " + str((person.smaf * 3) + 2 + person.jobskills.forager) + "% Chance[/color] " 
					elif i == 'hunter':
						text += " Decreases the chance of bringing back less food due to low Courage. "
					elif i == 'nurse':
						text += " Increases Health Gained while working as a nurse for all patients. [color=aqua]" + str(round(person.jobskills.nurse/2)) + " Bonus Health Restored[/color] "
					elif i == 'lumberjack':
						text += " Affects the Chance of receiving Bonus Gold per day. [color=aqua]- " + str(clamp(person.jobskills.lumberer + (person.energy*1), 1, 50)) + "% Chance[/color] "
					elif i == 'combat':
						text += " Affects the Chance of succeeding at a special event to gain bonus gold per day. "
					elif i in ['entertainer','merchant','mage']:
						text += " Affects the Chance of earning Bonus Gold per day. "
					elif i == 'maid':
						text += " Affects the Chance of cleaning more than usual per day. "
					elif i == 'pet':
						text += " Affects the number of Slaves per day that can be Serviced before losing Energy and gaining Stress. "
					text += "[/color]\n"
			if firstskill == true:
				text = str(expansion.getIntro(person)) + " $name thinks for a moment and shrugs.\n[color=yellow]-" + person.quirk("I'm not skilled at any jobs yet. ")
		else:
			text = str(expansion.getIntro(person))  + "\n[color=yellow]-" + person.quirk(str(globals.randomitemfromarray(["I can't work while I'm trapping in here!","Work? You want to talk about work? I just want to be free!","If you let me go, maybe I can get some job experience."]))) + "[/color]"
		buttons.append({text = str(globals.randomitemfromarray(['Go Back','Return','Previous Menu'])), function = '_on_talk_pressed', tooltip = "Go back to the previous screen"})
		
	#---Sexual Slave Topics---#
	elif mode == 'slave_sex_topics':
		text = str(expansion.getIntro(person)) + "\n[color=yellow]-"+ person.quirk(str(talk.introGeneral(person))) + "[/color]"
		
		#Known Sexuality
		if person.knowledge.has('sexuality'):
			text += "\n\n[color=#d1b970][center]Sexuality[/center][/color]\n"
			text += "[color=aqua]" + str(globals.expansion.getSexuality(person)) + "[/color] | "
			if person.sexexpanded.sexualitylocked == false:
				text += "[color=green]Unlocked[/color]"
			else:
				text += "[color=red]Locked[/color]"
		
		#Known Fetishes
		if !person.knownfetishes.empty():
			text += "\n\n[color=#d1b970][center]Known Fetishes[/center][/color]\n"
			for fetish in person.knownfetishes:
				var fetishname = globals.expansion.getFetishDescription(str(fetish))
				text += fetishname.capitalize() + ": " + globals.fastif(globals.fetishopinion.find(person.fetish[fetish]) >= 3,"[color=green]", "[color=red]") + str(person.fetish[fetish].capitalize())+ "[/color]\n"
		#Undiscovered Trait Fetishes
		if person.dailytalk.has('hint_dominance') || person.dailytalk.has('hint_submissive') || person.dailytalk.has('hint_sadism') || person.dailytalk.has('hint_masochism'):
			text += "\n\n[color=#d1b970][center]Undiscovered Trait[/center][/color]"
			if person.dailytalk.has('hint_dominance') || person.dailytalk.has('hint_submissive'):
				text += "\nYou get the feeling that $name may feel strongly about [color=aqua]Control[/color]."
			if person.dailytalk.has('hint_sadism') || person.dailytalk.has('hint_masochism'):
				text += "\nYou get the feeling that $name may feel strongly about [color=aqua]Pain[/color]."

		if person.cum.pussy > 0 || !person.preg.womb.empty():
			var cumtrail = str(globals.randomitemfromarray(['a small, white glob of ','a trail of ','something that looks like ','what might be ']))
			var ooze = str(globals.randomitemfromarray(['ooze','spurt','drip','fall','squelch','trickle']))
			text += "\n\nYou see " + cumtrail + " of " + str(globals.expansion.nameCum()) + " " + ooze + " onto $his leg from $his " + str(globals.expansion.namePussy()) + ". "
			if globals.expansionsettings.perfectinfo == true:
				text += "\n[color=#d1b970]Loads = " + str(person.cum.pussy) + "[/color]"
			buttons.append({text = 'I want you to drain your pussy of that cum.', function = 'eventDrainCum', args = 'intropussy', tooltip = person.dictionary("Order $him to drain the cum from $his pussy")})

		if person.cum.ass > 0 :
			var cumtrail = str(globals.randomitemfromarray(['a small, white glob of ','a trail of ','something that looks like ','what might be ']))
			var ooze = str(globals.randomitemfromarray(['ooze','spurt','drip','fall','squelch','trickle']))
			text += "\n\nYou see " + cumtrail + " of " + str(globals.expansion.nameCum()) + " " + ooze + " onto $his leg from $his " + str(globals.expansion.nameAsshole()) + ". "
			if globals.expansionsettings.perfectinfo == true:
				text += "\n[color=#d1b970]Loads = " + str(person.cum.ass) + "[/color]"
			buttons.append({text = 'I want you to drain your ass of that cum.', function = 'eventDrainCum', args = 'introass', tooltip = person.dictionary("Order $him to drain the cum from $his ass")})

		#Unlock Sexuality Knowledge
		if !person.knowledge.has('sexuality'):
			buttons.append({text = str(globals.randomitemfromarray(['How do you identify sexually?','What gender turns you on?','What is your sexuality?'])), function = 'oneperdayconvos', args = 'sexuality', tooltip = person.dictionary("Ask about $name's sexuality. -Available Once per Day")})
		#Sexuality Shift
		else:
			buttons.append({text = str(globals.randomitemfromarray(['Regarding your sexuality...'])), function = 'talkSexualityShiftToggle', args = 'intro', tooltip = "Lock or Unlock their Sexuality."})
		#Fetishes
		if !person.dailytalk.has('talk_new_fetish') || !person.dailytalk.has('talk_change_fetish'):
			buttons.append({text = str(globals.randomitemfromarray(['What are you into?','Will you tell me your fetishes?','I would like to know your fetishes','Can we talk about your fetishes?'])), function = 'talkfetishes', args = 'intro', tooltip = person.dictionary("Ask about $name's fetishes. -Available Once per Day")})
		
		buttons.append({text = str(globals.randomitemfromarray(['Nevermind','Go Back','Return','Cancel'])), function = '_on_talk_pressed', tooltip = "Go back to the previous screen"})
	
	elif mode == 'prison_slave_topics':
		text = str(expansion.getIntro(person)) + "\n[color=yellow]-"+ person.quirk(str(talk.introGeneral(person))) + "[/color]"
		#Change Prisoner Restraints


#			buttons.append({text = person.dictionary("You should call me ___"), function = 'callorder', args = 'static', tooltip = "Designate what you want them to call you."})

		buttons.append({text = str(globals.randomitemfromarray(['Nevermind','Go Back','Return','Cancel'])), function = '_on_talk_pressed', tooltip = "Go back to the previous screen"})
		#---End Expansion---#

#		if person.sleep != 'jail':
#			buttons.append({text = person.dictionary("Praise $name"), function = '_on_talk_pressed', args = 'praise'})
#		buttons.append({text = person.dictionary("Punish $name"), function = '_on_talk_pressed', args = 'punish'})
#		if person.sleep != 'jail' && person.consent == false:
#			buttons.append({text = person.dictionary("Propose intimate relationship (25 energy)"), function = 'unlocksex'})
#			if globals.player.energy < 25: buttons[buttons.size()-1].disabled = true
		
	elif mode == 'praise':
		if person.obed >= 85 && person.praise == 0:
			text = "$name obediently waits for your reaction looking beneath $himself. "
		elif person.praise > 0:
			text = "$name seems to be still in high spirits probably keeping in mind your recent approval. "
		elif person.obed < 85:
			text = "$name appears to be not very disciplined as $his eyes wander around the room. "
		buttons.append({text = "Praise (10 energy)", function = 'action', args = 'praise'})
		if globals.player.energy < 10: buttons[buttons.size()-1].disabled = true
		buttons.append({text = "Make a Gift (15 energy, 15 gold)", function = 'action', args = 'gift'})
		if globals.player.energy < 15 || globals.resources.gold < 15: buttons[buttons.size()-1].disabled = true
	elif mode in ['punish', 'sexpunish']:
		if person.punish.expect == true:
			text = "$name gives you a fearsome look indicating strong recent memories of your authority. "
		elif person.obed <= 65:
			text = "$name appears to be not very disciplined as $he shows slight irritation having to submit to you. "
		else:
			text = "$name shows mild awareness to your authority. "
		if mode == 'punish':
			buttons.append({text = "Berate (10 energy)", function = 'action', args = 'berate'})
			if globals.player.energy < 10: buttons[buttons.size()-1].disabled = true
			buttons.append({text = "Beat (15 energy)", function = 'action', args = 'beat'})
			if globals.player.energy < 15: buttons[buttons.size()-1].disabled = true
			buttons.append({text = "Sexual Punishments (20 energy)", function = "_on_talk_pressed", args = 'sexpunish'})
			if globals.player.energy < 20: buttons[buttons.size()-1].disabled = true
		elif mode == 'sexpunish':
			text += "\n\nYou can take $name to the punishment room for more oscure actions. These are not specifically harmful, but sufficiently painful and stimulating to provide a lesson. \nIf 'Public' is checked, other servants will also be watching and it will severe the punishment."
			buttons.append({text = "Tickling", function = 'action', args = 'tickling'})
			buttons.append({text = "Spanking", function = 'action', args = 'spanking'})
			buttons.append({text = "Whipping", function = 'action', args = 'whipping'})
			buttons.append({text = "Wooden Horse", function = 'action', args = 'woodenhorse'})
			buttons.append({text = "Hot Wax", function = 'action', args = 'hotwax'})
	if mode in ['praise', 'punish']:
		buttons.append({text = "Return", function = '_on_talk_pressed'})
	elif mode == 'sexpunish':
		buttons.append({text = "Return", function = '_on_talk_pressed', args = 'punish'})
	get_tree().get_current_scene().dialogue(state, self, person.dictionary(text), buttons, updateSprites(person))
	get_tree().get_current_scene().rebuild_slave_list()
	get_parent().slavetabopen()

###---Added by Expansion---###
#Dialogue Expanded - TBK


#Master's Name
func callorder(mode = ''):
	if mode == 'static':
		get_node("callorder").popup()
		get_node("callorder/Label").set_text(person.dictionary("What should $name call you?"))
		get_node("callorder/LineEdit").set_text(person.masternoun)
	else:
		person.randomname = true
		var text = "$name " + str(expansion.getExpression(person)) + " at you and says\n" + person.quirk("[color=yellow]-" + str(globals.randomitemfromarray(['Of course','Certainly','As you wish','Thank you','Fine','Alright','If that is your wish'])) + ",$master.[/color]")
		get_tree().get_current_scene().close_dialogue()
		get_tree().get_current_scene().popup(person.dictionary(text))

func _on_callconfirm_pressed():
	get_node("callorder").visible = false
	var text = "You have ordered $name to call you $master from this moment. "
	text += "$name " + str(expansion.getExpression(person)) + " at you and says\n" + person.quirk("[color=yellow]-" + str(globals.randomitemfromarray(['Of course','Certainly','As you wish','As you command','Fine','Alright','If that is your wish'])) + ", $master.[/color]")
	person.randomname = false
	person.masternoun = get_node("callorder/LineEdit").get_text()
	get_tree().get_current_scene().close_dialogue()
	get_tree().get_current_scene().popup(person.dictionary(text))

#Rename Slave
var pending_slave_rename = ""
var dictNameParts = {'name': "First name", 'surname': "Last name", 'nickname': "Nickname"}

func slave_rename_hub(mode = ''):
	var state = true
	var buttons = []
	var text = ""
	if mode == 'intro':
		text = str(expansion.getIntro(person)) + "\n[color=yellow]-"+ person.quirk(str(talk.introGeneral(person))) + "[/color]\n\nWhich name would you like to change?"
		buttons.append({text = "Your First name is now...", function = 'slave_rename_hub', args = 'name', tooltip = "Change the slave's First name."})
		buttons.append({text = "Your Last name is now...", function = 'slave_rename_hub', args = 'surname', tooltip = "Change the slave's Last name."})
		buttons.append({text = "Your Nickname is now...", function = 'slave_rename_hub', args = 'nickname', tooltip = "Change the slave's Nickname. Same as in Customize Slave."})
	elif mode in dictNameParts:
		get_node("slaverename").popup()
		get_node("slaverename/Label").set_text(("What should "+ person.name_short() +"'s new "+ dictNameParts[mode] +" be? It is currently " + str(person[mode])))
		get_node("slaverename/LineEdit").set_text(person[mode])
		pending_slave_rename = mode
	
	#Return Buttons`
	if mode != "intro":
		buttons.append({text = "Regarding another of your names...", function = 'slave_rename_hub', args = 'intro', tooltip = "Change another part of the slave's name."})
	buttons.append({text = str(globals.randomitemfromarray(['Go Back','Return','Previous Menu'])), function = '_on_talk_pressed', tooltip = "Go back to the previous screen"})
	get_tree().get_current_scene().dialogue(state, self, person.dictionary(text), buttons, updateSprites(person))
	get_tree().get_current_scene().rebuild_slave_list()
	get_parent().slavetabopen()

func _on_slaverename_pressed():
	get_node("slaverename").visible = false
	var text = "You demand that $he accept this as $his new name. "
	text += "$name " + str(expansion.getExpression(person)) + " at you and says\n" + person.quirk("[color=yellow]-" + str(globals.randomitemfromarray(['As you wish','As you command','Fine','Alright','If that is your wish'])) + ", $master.[/color]")
	if pending_slave_rename in dictNameParts:
		person[pending_slave_rename] = get_node("slaverename/LineEdit").get_text()
		pending_slave_rename = ""
	if globals.state.relativesdata.has(person.id):
		globals.state.relativesdata[person.id].name = person.name_long()
	get_tree().get_current_scene().close_dialogue()
	get_tree().get_current_scene().popup(person.dictionary(text))

#---Events---#
func eventPregnancyReveal(mode=''):
	var text = ""
	var state = false
	var buttons = []
	var moodmod = 0
	
	#Intro + Player Choice
	if mode == 'introdiscovered':
		text += "$He looks shocked and touches $his "+expansion.nameBelly()+" reflexively.\n\n[color=yellow]" + person.quirk("-I...um...I think I may be pregnant. I was just scared to say anything...")
		person.knowledge.append('currentpregnancy')
		if person.mind.secrets.has('currentpregnancy'):
			person.mind.secrets.erase('currentpregnancy')
	
		text += "\n\n[color=aqua]Discovered $name is Pregnant[/color]"
	
		buttons.append({text = "I understand why you didn't tell me. Congratulations anyways!", function = 'eventPregnancyReveal', args = 'respected', tooltip = person.dictionary("$He did well in telling you.")})
		buttons.append({text = person.dictionary("Its a shame you hid it for so long. We could be having fun!"), function = 'eventPregnancyReveal', args = 'lewd', tooltip = person.dictionary("All that matters is sex, right?")})
		buttons.append({text = "You dared to hide this, breeding stock?", function = 'eventPregnancyReveal', args = 'degraded', tooltip = person.dictionary("Who does $he think $he is?")})
	
	if mode == 'introtold':
		text += "$He gently rubs $his swollen "+expansion.nameBelly()+" and smiles.\n\n[color=yellow]" + person.quirk("-I am pregnant, $master! Isn't that exciting?")
		person.knowledge.append('currentpregnancy')
		person.dailytalk.erase('currentpregnancy')
		
		text += "\n\n[color=aqua]Discovered $name is Pregnant[/color]"
		buttons.append({text = "Thank you for telling me! You will a wonderful mother.", function = 'eventPregnancyReveal', args = 'respected', tooltip = person.dictionary("$He did well in telling you.")})
		buttons.append({text = person.dictionary("Luckily, I'd like to fuck a pregnant $child."), function = 'eventPregnancyReveal', args = 'lewd', tooltip = person.dictionary("All that matters is sex, right?")})
		buttons.append({text = "Finally! It is just the start of breeding you like the animal you are!", function = 'eventPregnancyReveal', args = 'degraded', tooltip = person.dictionary("Who does $he think $he is?")})
	
	#Choices
	if mode == 'respected':
		expansion.getResponse(person,mode)
		text = str(expansion.getIntro(person)) + " $name smiles at your response.\n[color=yellow]-"+ person.quirk("Thank you, $master. I really appreciate your understanding!") + "[/color]"
	if mode == 'degraded':
		if expansion.getResponse(person,mode) == "positive":
			text = str(expansion.getIntro(person)) + " $name moans $his mouth to protest and seems to startle even $himself with a violent moan of delight.\n[color=yellow]-"+ person.quirk("I...don't think I'd mind being bred over and over...") + "[/color]"
		else:
			text = str(expansion.getIntro(person)) + " $name lets out a small whimper.\n[color=yellow]-"+ person.quirk("Please, $master, no! I'm so scared about having this baby! Don't force me to keep having them!") + "[/color]"
	if mode == 'lewd':
		for fetup in ['creampiepussy','pregnancy']:
			person.checkFetish(fetup, 2)
		if expansion.getResponse(person,mode) == "positive":
			text += " $name bites $his lower lip at your response.\n[color=yellow]-"+ person.quirk("I HAVE been really horny lately.") + "[/color]\n"
		else:
			text += "$name seems completely shocked by your suggestion.\n[color=yellow]-"+ person.quirk("You...want to fuck me because I'm pregnant? Oh...I...see.") + "[/color]"

	#Return after Choice
	if !mode in ['introtold','introdiscovered']:
		buttons.append({text = str(globals.randomitemfromarray(['Anyways, like we were saying','As we were saying...'])), function = '_on_talk_pressed', tooltip = "Return to the main talk screen."})

	get_tree().get_current_scene().dialogue(state, self, person.dictionary(text), buttons, updateSprites(person))
	get_tree().get_current_scene().rebuild_slave_list()
	get_parent().slavetabopen()

func eventLactation(mode=''):
	var text = ""
	var state = false
	var buttons = []
	var moodmod = 0
	
	#Intro + Player Choice
	if mode == 'introdiscovered':
		if person.exposed.chest == true:
			text += "$He looks down and spots $his leaking nipple. The trail has just started to reach $his belly-button. "
		else:
			text += "$He looks down and spots $his damp shirt. "
		if expansion.getSecret(person,'lactation') == true:
			text = "$name breathes out a small sigh then looks at you look of resignation.\n[color=yellow]-"+ person.quirk("I...I am lactating. I'm sorry I kept it from you, $master")
			var reason = str(globals.randomitemfromarray(["so grossed out by it! It is so disgusting to be leaking milk from your "+expansion.nameTits()+"!","so worried that you'd turn me into a cow and I'd spend the rest of my life being livestock!","so embarrassed that I didn't know what to say!","so worried that you would think it was gross!"]))
			text += "I was just so " +reason+"[/color]\n"
			buttons.append({text = "I understand your reasons. It is completely alright.", function = 'eventLactation', args = 'respected', tooltip = person.dictionary("$He did well in admitting it.")})
			buttons.append({text = "Don't worry. I'll show you how fun that can be!", function = 'eventLactation', args = 'lewd', tooltip = person.dictionary("All that matters is sex, right?")})
			buttons.append({text = "You dare lie to me? You are only udders and holes to fuck!", function = 'eventLactation', args = 'degraded', tooltip = person.dictionary("Who does $he think $he is?")})

		else:
			text = "$name looks back up at you with wide eyes and a look of complete terror on $his face.\n[color=yellow]-"+ person.quirk("N-no, $master. I'm...I'm not lactating. That's some water I spilled!") + "\n\nIt is painfully obvious from the tears welling up in $his eyes that $he is still trying to hide this from you."
			buttons.append({text = "I understand you are scared. It is completely normal.", function = 'eventLactation', args = 'respected', tooltip = person.dictionary("$He is obviously just scared.")})
			buttons.append({text = "Don't worry. I'll show you how fun that can be!", function = 'eventLactation', args = 'lewd', tooltip = person.dictionary("All that matters is sex, right?")})
			buttons.append({text = "You dare lie to me still? You are only udders and holes to fuck!", function = 'eventLactation', args = 'degraded', tooltip = person.dictionary("Who does $he think $he is?")})

		person.mind.secrets.erase('lactating')
		person.knowledge.append('lactating')
		text += "\n\n[color=aqua]Discovered $name is lactating[/color]"
		
	if mode == 'introtold':
		if person.exposed.chest == false:
			text += "$He reaches down and pulls $his shirt to the side. "
		text += "$He touches $his "+expansion.getChest(person)+" and squeezes $his nipple. A trickle of milk slides out of it after just a moment. "
		text += person.quirk("I just started lactating, $master. I don't know if you care...or if you are going to do anything with it, but you are my $master. You should know.")
		
		person.dailytalk.erase('lactating')
		person.knowledge.append('lactating')
		
		text += "\n\n[color=aqua]Discovered $name is lactating[/color]"
		buttons.append({text = "Thank you for telling me.", function = 'eventLactation', args = 'respected', tooltip = person.dictionary("$He did well in telling you.")})
		buttons.append({text = "Mmm. That give me some fun, new ideas for the bedroom.", function = 'eventLactation', args = 'lewd', tooltip = person.dictionary("All that matters is sex, right?")})
		buttons.append({text = "Finally! I can strap you down and milk you like the cow you are!", function = 'eventLactation', args = 'degraded', tooltip = person.dictionary("Who does $he think $he is?")})
	
	#Choices
	if mode == 'respected':
		expansion.getResponse(person,mode)
		text = str(expansion.getIntro(person)) + " $name smiles at your response.\n[color=yellow]-"+ person.quirk("Thank you, $master. I really appreciate your understanding!") + "[/color]"
	if mode == 'degraded':
		if expansion.getResponse(person,mode) == "positive":
			text = str(expansion.getIntro(person)) + " $name moans $his mouth to protest and seems to startle even $himself with a violent moan of delight.\n[color=yellow]-"+ person.quirk("A...cow? For the rest of my life? Oh...oh gods...") + "[/color]"
		else:
			text = str(expansion.getIntro(person)) + " $name lets out a small whimper.\n[color=yellow]-"+ person.quirk("Please, $master, anything but that! I've seen what that does to $child before and please no! They lose their minds, they start mooing! Please, $master!") + "[/color]"
	if mode == 'lewd':
		for fetup in ['drinkmilk','lactation','bemilked']:
			person.checkFetish(fetup, 2)
		if expansion.getResponse(person,mode) == "positive":
			text += " $name bites $his lower lip at your response.\n[color=yellow]-"+ person.quirk("You...you're into it? I think I may be too!") + "[/color]\n"
			text += "$He runs $his finger along $his erect nipple and brings back a droplet of milk to $his own lips, then licks it off."
			text += "\n[color=yellow]-" + person.quirk("Mmm...I taste pretty good!") + "[/color]\n"
		else:
			text += "$name seems completely shocked by your suggestion.\n[color=yellow]-"+ person.quirk("You...you are turned on by drinking...me? Um...okay...") + "[/color]"

	#Return after Choice
	if !mode in ['introtold','introdiscovered']:
		buttons.append({text = str(globals.randomitemfromarray(['Anyways, like we were saying','As we were saying...'])), function = '_on_talk_pressed', tooltip = "Return to the main talk screen."})

	get_tree().get_current_scene().dialogue(state, self, person.dictionary(text), buttons, updateSprites(person))
	get_tree().get_current_scene().rebuild_slave_list()
	get_parent().slavetabopen()

func eventWantedPregnancy(mode=''):
	var text = ""
	var state = false
	var buttons = []
	var moodmod = 0
	#Intro + Player Choice
	if mode == 'intro':
		person.knowledge.append('currentpregnancywanted')
		person.dailytalk.erase('wantpregnancy')
		if person.pregexp.wantedpregnancy == true:
			text = str(expansion.getIntro(person)) + " $name breathes deeply then looks at you with a shy smile.\n[color=yellow]-"+ person.quirk("I am okay with it. I wasn't at first, but the more I thought about it...why not? I will love this baby all the same. I just wanted you to know.") + "[/color]"
			buttons.append({text = "I am glad to hear it. You will be a great mother.", function = 'eventWantedPregnancy', args = 'respected', tooltip = person.dictionary("Give $him some kindness.")})
			buttons.append({text = "I'm sure you enjoyed making it, too!", function = 'eventWantedPregnancy', args = 'lewd', tooltip = person.dictionary("All that matters is sex, right?")})
		else:
			text = str(expansion.getIntro(person)) + " $name looks ashamed and doesn't want to meet your eyes.\n[color=yellow]-"+ person.quirk("I don't want it. I am just not okay with it. I know I can't do anything about it, but...it is my body! Shouldn't I be able to? I just...it's just not fair. I...I wish I wasn't having it.") + "[/color]"
			buttons.append({text = "I understand how you feel. I get it.", function = 'eventWantedPregnancy', args = 'respected', tooltip = person.dictionary("Respect $his feelings.")})
			buttons.append({text = "I don't really care. Remember how fun making it was?", function = 'eventWantedPregnancy', args = 'lewd', tooltip = person.dictionary("All that matters is sex, right?")})
		buttons.append({text = "It doesn't matter either way. You are my property to breed if I want.", function = 'eventWantedPregnancy', args = 'degraded', tooltip = person.dictionary("Who does $he think $he is?")})
	#Choices
	if mode == 'respected':
		expansion.getResponse(person,mode)
		text = str(expansion.getIntro(person)) + " $name smiles at your response.\n[color=yellow]-"+ person.quirk("Thank you, $master. That is really sweet of you to say!") + "[/color]"
	if mode == 'degraded':
		if expansion.getResponse(person,mode) == "positive":
			text = str(expansion.getIntro(person)) + " $name seems disheartened by your response.\n[color=yellow]-"+ person.quirk("Oh. You are very right, $master. I am your property and you can do anything you want to me!") + "[/color]"
		else:
			text = str(expansion.getIntro(person)) + " $name seems disheartened by your response.\n[color=yellow]-"+ person.quirk("Oh. I'm sorry for saying anything, $master. It...it won't happen again.") + "[/color]"
	if mode == 'lewd':
		for fetup in ['creampiepussy','pregnancy']:
			person.checkFetish(fetup, 2)
		if expansion.getResponse(person,mode) == "positive":
			text += " $name bites $his lower lip at your response.\n[color=yellow]-"+ person.quirk("It really was, $master! I can't wait to do that again!") + "[/color]"
		else:
			text += " $name seems offput by your attempt to redirect the conversation.\n[color=yellow]-"+ person.quirk("It...it was lovely, $master. Anyways, thanks for...listening, I guess?") + "[/color]"
	#Return after Choice
	if mode != 'intro':
		buttons.append({text = str(globals.randomitemfromarray(['As we were saying...'])), function = '_on_talk_pressed', tooltip = "Return to the main talk screen."})
	get_tree().get_current_scene().dialogue(state, self, person.dictionary(text), buttons, updateSprites(person))
	get_tree().get_current_scene().rebuild_slave_list()
	get_parent().slavetabopen()

func eventIncestConsentGiven(mode=''):
	var text = ""
	var state = false
	var buttons = []
	var moodmod = 0
	#Intro + Player Choice
	if mode == 'intro':
		text = str(expansion.getIntro(person)) + " $name nods at you.\n[color=yellow]-"+ person.quirk("I think I am okay with it. I used to think it was taboo, but the more I thought about it...why not? Being related shouldn't make it feel different in the bedroom.") + "[/color]"
		person.dailytalk.erase('incestconsentgiven')
		buttons.append({text = "I am glad to hear it. I think that's a smart way to think about it.", function = 'eventIncestConsentGiven', args = 'respected', tooltip = person.dictionary("Show $him you respect $his decisions.")})
		buttons.append({text = "Why do you think you have a say? You will fuck whoever I want, slave.", function = 'eventIncestConsentGiven', args = 'degraded', tooltip = person.dictionary("Remind $him who $he is to you.")})
		buttons.append({text = "When you feel a body against yours, who cares? Sex is amazing!", function = 'eventIncestConsentGiven', args = 'lewd', tooltip = person.dictionary("All that matters is sex, right?")})
	#Choices
	if mode == 'respected':
		person.consentexp.incest = true
		expansion.getResponse(person,mode)
		text = str(expansion.getIntro(person)) + " $name smiles at your response.\n[color=yellow]-"+ person.quirk("$Thanks, $master. I'm glad you agree! I look forward to trying it!") + "[/color]"
	if mode == 'degraded':
		if expansion.getResponse(person,mode) == "positive":
			person.consentexp.incest = true
			text += str(expansion.getIntro(person)) + " $name bites $his lower lip at your response.\n[color=yellow]-"+ person.quirk("You are right, $master. It isn't my place to decide what happens to me, that it yours.") + "[/color]"
		else:
			text = str(expansion.getIntro(person)) + " $name seems disheartened by your response.\n[color=yellow]-"+ person.quirk("Oh. I see. Well, I mean...nevermind, I guess. Forget I said anything.") + "[/color]"
	if mode == 'lewd':
		for fetup in ['incest']:
			person.checkFetish(fetup, 3)
		if expansion.getResponse(person,mode) == "positive":
			person.consentexp.incest = true
			text += str(expansion.getIntro(person)) + " $name bites $his lower lip at your response.\n[color=yellow]-"+ person.quirk("You are right about that, $master! I can't wait to try it!") + "[/color]"
		else:
			text += str(expansion.getIntro(person)) + " $name seems to consider. You may have been over-eager.\n[color=yellow]-"+ person.quirk("I...I dunno. Maybe there is a reason it's taboo? I'll have to think about it, $master.") + "[/color]"
	#Return after Choice
	if mode != 'intro':
		buttons.append({text = str(globals.randomitemfromarray(['As we were saying...'])), function = '_on_talk_pressed', tooltip = "Return to the main talk screen."})
	get_tree().get_current_scene().dialogue(state, self, person.dictionary(text), buttons, updateSprites(person))
	get_tree().get_current_scene().rebuild_slave_list()
	get_parent().slavetabopen()

func eventIncestConsentRemoved(mode=''):
	var text = ""
	var state = false
	var buttons = []
	var moodmod = 0
	#Intro + Player Choice
	if mode == 'intro':
		text = str(expansion.getIntro(person)) + " $name nods at you solemnly.\n[color=yellow]-"+ person.quirk("I just can't anymore. Every time I think about it, my skin crawls. I don't know if you understand, but I just am not okay with it.") + "[/color]"
		person.dailytalk.erase('incestconsentremoved')
		buttons.append({text = "I understand and respect your choice.", function = 'eventIncestConsentRemoved', args = 'respected', tooltip = person.dictionary("Show $him you respect $his decisions.")})
		buttons.append({text = "Why do you think you have a say? You will fuck whoever I want, slave.", function = 'eventIncestConsentRemoved', args = 'degraded', tooltip = person.dictionary("Remind $him who $he is to you.")})
		buttons.append({text = "When you feel a body against yours, who cares? Sex is amazing!", function = 'eventIncestConsentRemoved', args = 'lewd', tooltip = person.dictionary("All that matters is sex, right?")})
	#Choices
	if mode == 'respected':
		person.consentexp.incest = false
		expansion.getResponse(person,mode)
		text = str(expansion.getIntro(person)) + " $name smiles at your response.\n[color=yellow]-"+ person.quirk("$Thanks, $master. I'm glad you understand. I appreciate you accepting my choice!") + "[/color]"
	if mode == 'degraded':
		if expansion.getResponse(person,mode) == "positive":
			text += str(expansion.getIntro(person)) + " $name bites $his lower lip at your response.\n[color=yellow]-"+ person.quirk("You are right, $master. It isn't my place to decide what happens to me, that it yours.") + "[/color]"
		else:
			person.consentexp.incest = false
			text = str(expansion.getIntro(person)) + " $name seems disheartened by your response.\n[color=yellow]-"+ person.quirk("Oh. I see. Well, I mean...nevermind, I guess. Forget I said anything.") + "[/color]"
	if mode == 'lewd':
		if expansion.getResponse(person,mode) == "positive":
			text += str(expansion.getIntro(person)) + " $name bites $his lower lip at your response and seems to consider.\n[color=yellow]-"+ person.quirk("I guess you are right, $master. I'll think on it some more.") + "[/color]"
		else:
			person.consentexp.incest = false
			text += str(expansion.getIntro(person)) + " $name seems to consider.\n[color=yellow]-"+ person.quirk("I just can't agree with you, $master. I'm sorry.") + "[/color]"
	#Return after Choice
	if mode != 'intro':
		buttons.append({text = str(globals.randomitemfromarray(['As we were saying...'])), function = '_on_talk_pressed', tooltip = "Return to the main talk screen."})
	get_tree().get_current_scene().dialogue(state, self, person.dictionary(text), buttons, updateSprites(person))
	get_tree().get_current_scene().rebuild_slave_list()
	get_parent().slavetabopen()

#Diet Change: Change the person's Diet from Food to Milk, Cum, or Piss. They may reject the change. Options to Forcefeed now or Allow.

func thecrystal(mode=''):
	var text = ""
	var state = false
	var buttons = []
	var moodmod = 0
	var blockreturn = false
	
	if mode == 'intro':
		text += "You walk with $name into the hallways beneath the castle, where the Dimensional Crystal lies. $name looks at you expectantly. "
		text += "\n\n[color=yellow]" + person.quirk("-What do you want me to do?") + "[/color]"
		
		#Research
		if person.smaf > 0 && person.wit > 0 && !person.dailytalk.has('crystalresearch'):
			buttons.append({text = person.dictionary("Research the Crystal"), function = 'thecrystal', args = 'research', tooltip = person.dictionary("Once Per Day: Spend some time researching the Crystal.")})

		#Crystal Abilities
		if globals.state.mansionupgrades.dimensionalcrystal >= 1 && (person.work == 'headgirl' || globals.expansionsettings.changecrystalreq > 0 && person.smaf >= globals.expansionsettings.changecrystalreq):
			if globals.state.thecrystal.abilities.has('pregnancyspeed'):
				buttons.append({text = person.dictionary("Please alter the Speed of Pregnancies"), function = 'pregspeedchange', args = 'start', tooltip = "Change the pregnancy speeds using the Dimensional Crystal."})
			#Immortality
			if globals.state.thecrystal.abilities.has('immortality') && globals.state.thecrystal.preventsdeath == false:
				buttons.append({text = person.dictionary("Use the Crystal to Prevent Death."), function = 'crystalimmortalitytoggle', args = 'enable', tooltip = "Use the Crystal's power to prevent death in your Mansion."})
			elif globals.state.thecrystal.abilities.has('immortality') && globals.state.thecrystal.preventsdeath == true:
				buttons.append({text = person.dictionary("Remove the Crystal's hold on Death."), function = 'crystalimmortalitytoggle', args = 'disable', tooltip = "Reenable death inside of your Mansion."})
		#Sacrifice
		if globals.state.thecrystal.mode == "dark" && globals.state.thecrystal.abilities.has('sacrifice'):
			buttons.append({text = person.dictionary("Feed $name to the Crystal."), function = 'crystalconsequences', args = 'sacrificed', tooltip = person.dictionary("Kill $name!")})
	
	elif mode == "research":
		person.dailytalk.append('crystalresearch')
		var research = 0
		if globals.state.thecrystal.power > person.smaf:
			text += "You spend some time together researching the Crystal. The magical power of the Crystal seems to be more than $name can fully grasp. "
			research = round(person.wit * (rand_range(0,.9)))
		else:
			text += "$name seems to be able to fully grasp the magical energies of the Crystal. "
			research = person.wit
		if rand_range(0,100) <= person.wit:
			text += "While working on the Crystal, $he was forced to activate latent power inside of it and caused its energy to fluctuate violently. Further research today will require a higher Magical Affinity to fully comprehend it's magic. "
			globals.state.thecrystal.power += 1
		if research > globals.state.thecrystal.research:
			text += "$He was able to uncover some information on the Crystal. Maybe a good night's rest will allow you to make a discovery about it.\n\nCurrent Research Level: [color=aqua]" + str(research) + "[/color]"
			globals.state.thecrystal.research = research
		else:
			text += "Unfortunately, there wasn't anything new that $he could reveal about the Crystal today. Maybe a night's rest will let $him clear $his head. "
		if globals.state.thecrystal.mode == "dark" && globals.state.thecrystal.power + globals.state.thecrystal.hunger > person.smaf:
			text += "\n\nYou are wrapping up your research for the day when $name tries to pull their hand back from the Crystal after their research but looks up in shock as it remains firmly pressed against it. From where you stand, you see the shadowly, purple tendrils have slipped into the palm of $his hand and are spreading through $his skin. "
			text += "$He gasps and jerks back helplessly. $He looks at you pleadingly.\n\n[color=yellow]" + person.quirk("-Please, help me!!!") + "[/color]"
			blockreturn = true
			buttons.append({text = person.dictionary("Save $name from the Crystal."), function = 'crystalconsequences', args = 'save', tooltip = person.dictionary("Save $name!")})
			buttons.append({text = person.dictionary("Leave $name to the Crystal."), function = 'crystalconsequences', args = 'feed', tooltip = person.dictionary("Kill $name!")})
	
	#Return after Choice
	if blockreturn == false:
		buttons.append({text = str(globals.randomitemfromarray(['Nothing. Lets go back.'])), function = '_on_talk_pressed', tooltip = "Return to the main Talk screen."})
	get_tree().get_current_scene().dialogue(state, self, person.dictionary(text), buttons, updateSprites(person))
	get_tree().get_current_scene().rebuild_slave_list()
	get_parent().slavetabopen()

func crystalimmortalitytoggle(mode=''):
	var text = ""
	var state = false
	var buttons = []
	var moodmod = 0
	var finish = false
	#Intro + Player Choice
	if mode == 'enable':
		globals.state.thecrystal.preventsdeath = true
		globals.state.thecrystal.power = globals.state.mansionupgrades.dimensionalcrystal
		text += "$name nods with a smile and approaches the Dimensional Crystal. "
		if globals.state.thecrystal.mode == "light":
			text += "The Crystal pulses with a deep, calming violet hue eminating out around it. "
		elif globals.state.thecrystal.mode == "dark":
			text += "The Crystal pulses with a dark deep-purple light that seems to be filled with shadows. "
		text += "$He touches the sides of the Crystal and $his lips begin to move wordlessly. After a few minutes, the light inside seems to burst violently with a moment of great energy before returning to it's usual humming glow. It looks stronger than before. "
		if globals.state.thecrystal.mode == "dark" && globals.state.thecrystal.power + globals.state.thecrystal.hunger > person.smaf:
			text += "\n\n$name tries to pull their hand back from the Crystal but looks up in shock as it remains firmly pressed against it. From where you stand, you see the shadowly, purple tendrils have slipped into the palm of $his hand and are spreading through $his skin. "
			text += "$He gasps and jerks back helplessly. $He looks at you pleadingly.\n\n[color=yellow]" + person.quirk("-Please, help me!!!") + "[/color]"
			buttons.append({text = person.dictionary("Save $name from the Crystal."), function = 'crystalconsequences', args = 'save', tooltip = person.dictionary("Save $name!")})
			buttons.append({text = person.dictionary("Feed $name to the Crystal."), function = 'crystalconsequences', args = 'feed', tooltip = person.dictionary("Kill $name!")})
		else:
			finish = true
	elif mode == 'disable':
		globals.state.thecrystal.preventsdeath = false
		text += "$name frowns but approaches the Dimensional Crystal. "
		if globals.state.thecrystal.mode == "light":
			text += "The Crystal pulses with a deep, calming violet hue eminating out around it. "
		elif globals.state.thecrystal.mode == "dark":
			text += "The Crystal pulses with a dark deep-purple light that seems to be filled with shadows. "
		text += "$He touches the sides of the Crystal and $his lips begin to move wordlessly. After a few minutes, the light inside seems to sputter, then grow dimmer. "
		if globals.state.thecrystal.mode == "dark" && globals.state.thecrystal.power + globals.state.thecrystal.hunger > person.smaf:
			text += "\n\n$name tries to pull their hand back from the Crystal but looks up in shock as it remains firmly pressed against it. From where you stand, you see the shadowly, purple tendrils have slipped into the palm of $his hand and are spreading through $his skin. "
			text += "$He gasps and jerks back helplessly. $He looks at you pleadingly.\n\n[color=yellow]" + person.quirk("-Please, help me!!!") + "[/color]"
			buttons.append({text = person.dictionary("Save $name from the Crystal."), function = 'crystalconsequences', args = 'save', tooltip = person.dictionary("Save $name!")})
			buttons.append({text = person.dictionary("Feed $name to the Crystal."), function = 'crystalconsequences', args = 'feed', tooltip = person.dictionary("Kill $name!")})
		else:
			finish = true
	#Return after Choice
	if finish == true:
		buttons.append({text = str(globals.randomitemfromarray(['As we were saying...'])), function = '_on_talk_pressed', tooltip = "Return to the main Talk screen."})
	get_tree().get_current_scene().dialogue(state, self, person.dictionary(text), buttons, updateSprites(person))
	get_tree().get_current_scene().rebuild_slave_list()
	get_parent().slavetabopen()

func crystalconsequences(mode=''):
	var text = ""
	var state = false
	var buttons = []
	var moodmod = 0
	if mode == 'save':
		text += "You rush forward and pull $him back with all of your might. $He slips to the ground in your arms and falls unconscious as the tendrils ooze out of $his fingernails and vanish into the air.\n\n[color=red]$name will awaken, but it will take some time for $his soul to recover from $his experience with the Crystal.[/color]"
		buttons.append({text = person.dictionary("Take $name to recover."), function = 'crystalconsequences', args = 'recovery', tooltip = "Let $name rest and recover $his damaged essence."})
	elif mode == 'feed':
		text += "The crystal is hungry. Who are you to stop it from feeding? You stand still and watch as the tendrils crawl up $name's arm. $He is panicking and screaming wordlessly as $he watches $his hand slowly vanish into the glow around the Crystal. $He looks back at you as $his arm starts to glow the same color and fade away. "
		text += "[color=yellow]\n\n-" + person.quirk("$master, why? Why are you doing this to m-") + "[/color]"
		text += "\n\n$His words are cut off as $his face is covered with the shadowy tendrils, glows a violent, deep purple, and bursts into smoke. In the blink of an eye, you see no trace of $his body, the smoke, or anything else in the room except you and the pulsing glow of the Crystal. "
		buttons.append({text = person.dictionary("Walk away from the Crystal."), function = 'crystalconsequences', args = 'dead', tooltip = "Nothing left to do now."})
	elif mode == 'sacrificed':
		text += "The crystal is hungry. It needs to feed. You push $name into the Crystal and hold $him against it as the shadowy tendrils snake underneath $his skin, glowing with the dark essence of death. "
		text += "[color=yellow]\n\n-" + person.quirk("Please, no! $master, why? Why are you doing this to m-") + "[/color]"
		text += "\n\n$His words are cut off as $his entire body is covered with the shadowy tendrils, glows a violent, deep purple, and bursts into smoke. In the blink of an eye, you see no trace of $his body, the smoke, or anything else in the room except you and the pulsing glow of the Crystal. It has been fed.\n\nMaybe...just maybe...it will be enough? "
		buttons.append({text = person.dictionary("Walk away from the Crystal."), function = 'crystalconsequences', args = 'dead', tooltip = "Nothing left to do now."})
	elif mode == 'dead':
		text += "You remain in front of the crystal by yourself. "
		if !globals.state.thecrystal.abilities.has('understandsacrifice'):
			text += "You stare into the swirling, ravenous void and see the bright, violet stream of $name's lifeforce fading into the crystal. You think you understand how the sacrifice works for the crystal. The hunger of the crystal seemed to have lessened by the same amount as $name's level, and it has gained $his lifeforce which may replace any that it has used before. The circle of life continues in the swirl of the crystal. "
			globals.state.thecrystal.abilities.append('understandsacrifice')
		globals.state.thecrystal.hunger -= person.level
		globals.state.thecrystal.lifeforce += 1
		get_tree().get_current_scene().close_dialogue()
		get_tree().get_current_scene().popup(person.dictionary(text))
		person.death()
		get_tree().get_current_scene().rebuild_slave_list()
		return
	elif mode == 'recovery':
		text += "You turn to leave the crystal. "
		globals.state.thecrystal.hunger -= 1
		person.away.duration = globals.state.thecrystal.hunger
		person.away.at = 'recovering'
		get_tree().get_current_scene().rebuild_slave_list()
		get_tree().get_current_scene().close_dialogue()
		get_tree().get_current_scene().popup(person.dictionary(text))
		return
	#Return after Choice
#	buttons.append({text = str(globals.randomitemfromarray(['As we were saying...'])), function = '_on_talk_pressed', tooltip = "Return to the main Talk screen."})
	get_tree().get_current_scene().dialogue(state, self, person.dictionary(text), buttons, updateSprites(person))
	get_tree().get_current_scene().rebuild_slave_list()
	get_parent().slavetabopen()

#Headgirl Topics
func headgirltopics(mode=''):
	var text = ""
	var state = false
	var buttons = []
	
	#Intro Text
	text = str(expansion.getIntro(person)) + "\n[color=yellow]-"+ person.quirk(str(talk.introGeneral(person))) + "[/color]"
	#Pregnancy Speed Changes
	if globals.state.thecrystal.abilities.has('pregnancyspeed') && person.work == 'headgirl' && globals.state.mansionupgrades.dimensionalcrystal >= 1:
		buttons.append({text = person.dictionary("Lets talk about the speed of pregnancies in this mansion."), function = 'pregspeedchange', args = 'start', tooltip = "Change the pregnancy speeds using the Dimensional Crystal."})
	elif person.work == 'headgirl' && globals.state.mansionupgrades.dimensionalcrystal == 0:
		buttons.append({text = person.dictionary("Lets talk about the speed of pregnancies in this mansion."), function = 'pregspeedchange', disabled = true, tooltip = "You need to purchase the Dimensional Crystal to affect pregnancy speeds."})
	#Death Prevention
	if globals.state.mansionupgrades.dimensionalcrystal >= 4 && globals.state.thecrystal.preventsdeath == false:
		buttons.append({text = person.dictionary("Use the Crystal to Prevent Death."), function = 'crystalimmortalitytoggle', args = 'enable', tooltip = "Use the Crystal's power to prevent death in your Mansion."})
	elif globals.state.mansionupgrades.dimensionalcrystal >= 4 && globals.state.thecrystal.preventsdeath == true:
		buttons.append({text = person.dictionary("Remove the Crystal's hold on Death."), function = 'crystalimmortalitytoggle', args = 'disable', tooltip = "Re-enable death inside of your Mansion."})
	
	buttons.append({text = str(globals.randomitemfromarray(['Nevermind','Go Back','Return','Cancel'])), function = '_on_talk_pressed', tooltip = "Go back to the previous screen"})
	get_tree().get_current_scene().dialogue(state, self, person.dictionary(text), buttons, updateSprites(person))
	get_tree().get_current_scene().rebuild_slave_list()
	get_parent().slavetabopen()

func pregspeedchange(mode = ''):
	var text = ''
	var state = false
	var buttons = []
	if mode == 'start':
		text = '[color=green]$name[/color] stands in front of you holding an arcane rune tied to the Mansion and the dimensional crystals below it.\n[color=yellow]-' + person.quirk('It currently takes [color=green]' + str(globals.state.pregduration) + '[/color] days to fully grow a baby for the average slave right now. Do you have an issue with the current speed of pregnancy, $master? I can adjust the dimensional crystal chamber in the mansion to speed up or slow down the natural growth of babies in wombs while in the mansion, though that will not change the added speed that traits may provide or the speed increases of [color=aqua]Induction Potions[/color]. Would you like me to do that?[/color]\n\n') + 'You think for a moment.'
		buttons.append({text = person.dictionary("It's good as it is now"), function = '_on_talk_pressed'})
		if globals.state.mansionupgrades.dimensionalcrystal >= 2:
			buttons.append({text = person.dictionary("I want girls giving birth as soon as my dick leaves them."), function = 'pregspeedchange', args = 'instant', tooltip = "This may break the game and will certainly break immersion."})
			buttons.append({text = person.dictionary("Three days is a nice, round number, don't you think?"), function = 'pregspeedchange', args = 'threeday', tooltip = "This is going to cause a massive pregnancy influx and may leave you without slaves as they all recover."})
		else:
			buttons.append({text = person.dictionary("I want girls giving birth as soon as my dick leaves them."), function = 'pregspeedchange', disabled = true, tooltip = "Requires Dimensional Crystal level 2 or higher."})
			buttons.append({text = person.dictionary("Three days is a nice, round number, don't you think?"), function = 'pregspeedchange', disabled = true, tooltip = "Requires Dimensional Crystal level 2 or higher."})
		buttons.append({text = person.dictionary("A week of pregnancy sounds like plenty to me."), function = 'pregspeedchange', args = 'week', tooltip = "This is very short but may fit with quicker games."})
		buttons.append({text = person.dictionary("(Recommended) Two weeks should be a nice round number"), function = 'pregspeedchange', args = 'biweekly', tooltip = "This is the recommended speed."})
		buttons.append({text = person.dictionary("(Default) Lets keep it a month. A month is fine."), function = 'pregspeedchange', args = 'month', tooltip = "This is going to take a long time breed offspring and only recommended for longer or non-breeding focused games."})
		buttons.append({text = person.dictionary("So 4 plus 5 is 9, so maybe do 45 days?"), function = 'pregspeedchange', args = 'monthandahalf', tooltip = "This is only recommended for non-breeding focused games."})
		buttons.append({text = person.dictionary("A couple of months sounds good to me. "), function = 'pregspeedchange', args = 'twomonths', tooltip = "You are unlikely to see many offspring over the course of a normal game."})
		buttons.append({text = person.dictionary("I play this for the realism. The full 9 months."), function = 'pregspeedchange', args = 'ninemonths', tooltip = "You are unlikely to see an offspring and possibly never will see any slaves pregnant over the course of a normal game. It may be easier to use contraception."})
	if mode == 'instant':
		text = 'You smile leeringly at $name.\n[color=yellow]-Instant. Birth.[/color]\n\n$name shivers slightly at the thought of $his body splitting open to give birth in one day.\n[color=yellow]-Yes...$master. This is pretty much cheat mode, $master, and you will negate a lot of game features this way.[/color]\n$He runs off to do your will and returns a few minutes later.\n[color=yellow]-It is done, $master.[/color]'
		globals.state.pregduration = 0
		buttons.append({text = person.dictionary("Good. As we were saying..."), function = '_on_talk_pressed'})
		buttons.append({text = person.dictionary("On second thought..."), function = 'pregspeedchange', args = 'start'})
	if mode == 'threeday':
		text = 'You smile at $name.\n[color=yellow]-Three days should be plenty.[/color]\n\n$name shivers slightly at the thought of the growing pains crammed into three days.\n[color=yellow]-Yes...$master. You understand most of your girls who have sex will never be able to do anything, right?[/color]\n$He runs off to do your will.\n[color=yellow]-It is done, $master.[/color]'
		globals.state.pregduration = 3
		buttons.append({text = person.dictionary("Good. As we were saying..."), function = '_on_talk_pressed'})
		buttons.append({text = person.dictionary("On second thought..."), function = 'pregspeedchange', args = 'start'})
	if mode == 'week':
		text = 'You smile at $name.\n[color=yellow]-A week should be fine. Lets fill up this mansion.[/color]\n\n$name shivers slightly at the thought of the growing pains crammed into one week.\n[color=yellow]-Yes $master. This may feel fairly fast and have a handful of births daily still.[/color]\n$He runs off to do your will.\n[color=yellow]-It is done, $master.[/color]'
		globals.state.pregduration = 7
		buttons.append({text = person.dictionary("Good. As we were saying..."), function = '_on_talk_pressed'})
		buttons.append({text = person.dictionary("On second thought..."), function = 'pregspeedchange', args = 'start'})
	if mode == 'biweekly':
		text = 'You nod thoughtfully at $name.\n[color=yellow]-Two weeks will allow us to breed our girls steadily while keeping them from not being able to move.[/color]\n\n$name nods cheerfully.\n[color=yellow]-That sounds like a good trade-off of time pregnant to babies birthed.[/color]\n$He runs off to do your will.\n[color=yellow]-It is done, $master.[/color]'
		globals.state.pregduration = 14
		buttons.append({text = person.dictionary("Good. As we were saying..."), function = '_on_talk_pressed'})
		buttons.append({text = person.dictionary("On second thought..."), function = 'pregspeedchange', args = 'start'})
	if mode == 'month':
		text = 'You nod thoughtfully at $name.\n[color=yellow]-The gods of this land decreed a month when creating these crystals. A month it shall be.[/color]\n\n$name nods cheerfully.\n[color=yellow]-Yes, $master, and thus may he be honored, our grand creator.[/color]\n$He runs off to do your will.\n[color=yellow]-It is done, $master. Our god is honored. We should seal it by releasing the next baby born to the wilds in $his name. Surely, he shall bless our crops this harvest![/color]'
		globals.state.pregduration = 30
		buttons.append({text = person.dictionary("Good. As we were saying..."), function = '_on_talk_pressed'})
		buttons.append({text = person.dictionary("On second thought..."), function = 'pregspeedchange', args = 'start'})
	if mode == 'monthandahalf':
		text = 'You nod thoughtfully at $name.\n[color=yellow]-I am in this for the long haul. 45 days.[/color]\n\n$name widens $his eyes at the thought of that long carrying a baby.\n[color=yellow]-Yes...master, if you are sure. You are not going to see many babies however...[/color]\n$He runs off to do your will.\n[color=yellow]-It is done, $master.[/color]'
		globals.state.pregduration = 45
		buttons.append({text = person.dictionary("Good. As we were saying..."), function = '_on_talk_pressed'})
		buttons.append({text = person.dictionary("On second thought..."), function = 'pregspeedchange', args = 'start'})
	if mode == 'twomonths':
		text = 'You nod thoughtfully at $name.\n[color=yellow]-Who cares about babies? I want my girls working. 60 days.[/color]\n\n$name widens $his eyes at the thought of that long carrying a baby.\n[color=yellow]-Yes...master, if you are sure. You are not going to see many babies however...[/color]\n$He runs off to do your will.\n[color=yellow]-It is done, $master.[/color]'
		globals.state.pregduration = 60
		buttons.append({text = person.dictionary("Good. As we were saying..."), function = '_on_talk_pressed'})
		buttons.append({text = person.dictionary("On second thought..."), function = 'pregspeedchange', args = 'start'})
	if mode == 'ninemonths':
		text = 'You snort and look at $name.\n[color=yellow]-I want the immersion, and naturally babies grow in nine months. So nine months it is. Make it nine, and nine it shall be. Do it, plebian![/color]\n\n$name faints in terror, for the thought of a full term pregnancy in this land has all but been forgotten. Eventually, $he comes to.\n[color=yellow]-$master, surely not? Truely, this is your wish? We...we shall have no babies. We shall see nary a one.[/color]\n$He runs off to do your will while sobbing hysterically.\n[color=yellow]-It is done, $master. As...nature...intended....[/color]'
		globals.state.pregduration = 270
		buttons.append({text = person.dictionary("Good. As we were saying..."), function = '_on_talk_pressed'})
		buttons.append({text = person.dictionary("On second thought..."), function = 'pregspeedchange', args = 'start'})
		
	buttons.append({text = str(globals.randomitemfromarray(['Nevermind','Go Back','Return','Cancel'])), function = '_on_talk_pressed', tooltip = "Go back to the previous screen"})
	get_tree().get_current_scene().dialogue(state, self, person.dictionary(text), buttons, updateSprites(person))
	get_tree().get_current_scene().rebuild_slave_list()
	get_parent().slavetabopen()


#Farm Topics ###Disabled for now as the farm logic is completely different.
#When reconfiguring, add the option to turn any Aphrodisiac/Sedatives into Farm Inventory and vice versa
func farmmanagertopics(mode=''):
	var text = ""
	var state = false
	var buttons = []
	
	#Milking Rack Restraints
	if mode == 'milkrackson':
		text = "[color=green]$name[/color] nods " + str(globals.randomitemfromarray(['excitedly','somberly','quickly'])) + " and jots down your orders in $his book.\n"
		text += person.quirk("[color=yellow]-Unless you told any of the cattle differently, all milk produced is currently being [/color]")
#		globals.state.expandedfarm.restraincattle = true
		mode = 'intro'
	if mode == 'milkracksoff':
#		globals.state.expandedfarm.restraincattle = false
		mode = 'intro'
	
	if mode == 'pisshub':
#		if globals.state.expandedfarm.storepiss == false:
		mode = 'intro' #Change After
	
	#Milk Production Change
	if mode == 'milkprodfood':
		text = "[color=yellow]-I'll get them to churning their breastmilk right away. You won't be able to tell the difference when we're done.[/color]."
		#globals.resources.farmexpanded.production = "food"
		mode = 'intro'
	if mode == 'milkprodgold':
		text = "[color=yellow]-I'll start marking the bottles for sale immediately. People love how sweet our milk tastes, we sell out every time.[/color]."
		#globals.resources.farmexpanded.production = "gold"
		mode = 'intro'
	if mode == 'milkprodmilk':
		text = "[color=yellow]-I'll start marking the bottles for storage immediately. I'm not sure what your long-term plans are with these, but it feels like a shame just letting them sit there.[/color]."
		#globals.resources.farmexpanded.production = "milk"
		mode = 'intro'
	
	#Needs to be last so it can be called by other changes
	if mode == 'intro':
		text = "[color=green]$name[/color] pulls out $his small ledger keeping account of all details currently related to the farm.\n\n"
		text += "[color=yellow]-Unless you told any of the cattle differently, all milk produced is currently being [/color]"
		#if globals.resources.farmexpanded.production == "food":
		#	text += "[color=yellow]churned into butter, cheese, or other dairy products. They are then being sent into the general food storage.\n[/color]"
		#if globals.resources.farmexpanded.production == "gold":
		#	text += "[color=yellow]bottled and sold to the general public.\nI have been monitoring the market and the bottles are currently selling for [color=aqua]" + str(round(globals.expansion.basemilkvalue*(globals.state.milkeconomy.currentvalue))) + "[/color] per bottle.\n[/color]"
		#	if person.wit >= 50:
		#		text += "[color=yellow]-I believe, based on market trends, that the price will fluctuate [color=aqua]" + str(10*globals.state.milkeconomy.currentvalue) + "%[/color] tomorrow.\n[/color]"
		#if globals.resources.farmexpanded.production == "milk":
		#	text += "[color=yellow]bottled and stored to be drunk by those you have on a strict 'Milk Only' diet.\n[/color]"
		text += "[color=yellow]-We currently have [/color]"
		if globals.resources.milk > 0:
			text += "[color=aqua]" + str(globals.resources.milk) + " bottles of milk[/color]"
			if globals.resources.cum == 0 && globals.resources.piss == 0:
				text += "[color=yellow] in storage.\n[/color]"
		if globals.resources.cum > 0:
			if globals.resources.milk > 0 && globals.resources.piss == 0:
				text += "[color=yellow]and  [/color]"
			else:
				text += "[color=yellow], [/color]"
			text += "[color=aqua]" + str(globals.resources.cum) + " bottles of semen[/color]"
			if globals.resources.piss > 0:
				text += "[color=yellow], and [/color]"
			else:
				text += "[color=yellow] in storage.\n[/color]"
		if globals.resources.piss > 0:
			text += "[color=aqua]" + str(globals.resources.piss) + " bottles of piss[/color][color=yellow] in storage.\n[/color]"
		text += "[color=yellow]-What would you like to discuss, $master?[/color]"
		#Set Milk Rack Restraints
#		if globals.state.mansionupgrades.farmtreatment >= 1:
#			if globals.state.expandedfarm.restraincattle == false:
#				buttons.append({text = person.dictionary("Lock the Cattle in the Milk Racks to maximize milking efficiency."), function = 'farmmanagertopics', args = 'milkrackson', tooltip = "This will stress your cattle, but milking efficiency and escape chances are negated."})
#			else:
#				buttons.append({text = person.dictionary("Unlock the Milking Racks and let the Cattle roam"), function = 'farmmanagertopics', args = 'milkracksoff', tooltip = "This will prevent stress on your cattle, but milking efficiency will plummet as they roam."})
		#Milk Production Result
		buttons.append({text = person.dictionary("Let's talk about what to do with the milk bottles we collect."), function = 'farmmanagertopics', args = 'milkprod', tooltip = "This will allow you to choose if milk is turned into Food, sold for Gold, or kept in bottles."})

		#Store Piss Bottles
		buttons.append({text = person.dictionary("Lets talk about collecting the piss of our livestock."), function = 'farmmanagertopics', args = 'pisshub', tooltip = "Open up options to discuss Piss Collection for Cattle"})

	if mode == 'milkprod':
		text = "[color=green]$name[/color] scribbles down a few things in $his ledger.\n[color=yellow]-" + person.quirk("What would you prefer done with the milk we are pumping out of the cattle?[/color]")
		buttons.append({text = person.dictionary("Let's turn the milk into normal food for our slaves to eat."), function = 'farmmanagertopics', args = 'milkprodfood', tooltip = "Milk will be added to the daily Food intake."})
		buttons.append({text = person.dictionary("Let's sell the milk to the local population"), function = 'farmmanagertopics', args = 'milkprodgold', tooltip = "Milk will be sold at the current market rate of " + str(round(globals.expansion.basemilkvalue*(globals.state.milkeconomy.currentvalue))) + " per unit."})
		buttons.append({text = person.dictionary("Let's turn them into normal food for our slaves to eat."), function = 'farmmanagertopics', args = 'milkprodmilk', tooltip = "Milk will be stored and used instead of food by anyone set to a Milk Only diet."})
		buttons.append({text = person.dictionary("Leave it how it is now."), function = 'farmmanagertopics', args = 'intro', tooltip = "No change"})

#	if person.work == 'farmmanager' && globals.state.mansionupgrades.mansionnursery >= 2:
#		buttons.append({text = person.dictionary("Lets talk about the speed of pregnancies in this mansion."), function = 'farmmanagertopics', args = 'start', tooltip = ""})

	buttons.append({text = str(globals.randomitemfromarray(['Nevermind','Go Back','Return','Cancel'])), function = '_on_talk_pressed', tooltip = "Go back to the previous screen"})
	
	get_tree().get_current_scene().dialogue(state, self, person.dictionary(text), buttons, updateSprites(person))
	get_tree().get_current_scene().rebuild_slave_list()
	get_parent().slavetabopen()

func oneperdayconvos(mode=''):
	#Conversations that can be held with anyone Once Per Day
	var text = ""
	var state = false
	var buttons = []
	
	if mode == "sexuality":
		person.dailytalk.append('talksexuality')
		person.knowledge.append('sexuality')
		person.mind.lewd = person.mind.lewd + 1
		text = str(expansion.getIntro(person)) + "\n[color=yellow]-"+person.quirk("I suppose it won't hurt anything to talk about it. I feel like I am " +str(expansion.getSexuality(person))+".")+"[/color]"
	
	if mode == "intro":
		text = "[color=red]Choices available Once Per Day[/color]\n\n" + str(expansion.getIntro(person)) + "\n[color=yellow]-"+ person.quirk(str(talk.introGeneral(person))) + "[/color]"
		#if !person.dailytalk.has('talkconsent'): Left Open for Options
		buttons.append({text = str(globals.randomitemfromarray(['Lets talk about Consent','I would like your consent','Can we talk about Consent?'])), function = 'talkconsent', args = 'intro', tooltip = person.dictionary("Ask for the various Consent types with $name")})
	
	#Number of Kids Wanted
	if !person.knowledge.has('desiredoffspring') && !person.dailytalk.has('desiredoffspring'):
		buttons.append({text = str(globals.randomitemfromarray(['How many kids do you want?','How many children would you like?','How many kids do you want to have?'])), function = '_on_talk_pressed', args = 'general_slave_topics_numberofkids', tooltip = "Find out how many kids they want."})
	elif person.knowledge.has('desiredoffspring') && !person.dailytalk.has('desiredoffspring'):
		buttons.append({text = str(globals.randomitemfromarray(['About how many kids you want...','Talk with me about children','About how many children you want to have...'])), function = '_on_talk_pressed', args = 'general_slave_topics_numberofkidsknown', tooltip = "Raise or Lower the number of Children they want to have."})
	
	buttons.append({text = str(globals.randomitemfromarray(['Nevermind','Go Back','Return','Cancel'])), function = '_on_talk_pressed', tooltip = "Go back to the previous screen"})
	get_tree().get_current_scene().dialogue(state, self, person.dictionary(text), buttons, updateSprites(person))
	get_tree().get_current_scene().rebuild_slave_list()
	get_parent().slavetabopen()

func talkfetishes(mode=''):
	#Conversations that can be held with anyone Once Per Day
	var text = ""
	var state = false
	var buttons = []
	var tempbuttons = []
	#Incomplete Fetish Variables
	var invalidfetishfound = false
	var incompletefetishtext = "\n\n\n[color=red]Aric's Note: The following fetishes have no current mechanical value. They may be implemented in the future but were implemented using another, more specific fetish instead. They are only for roleplay purposes at the moment. Any other fetishes that appear are have at least 1 fetish check and provide a mechanical benefit somewhere in the game. [/color]"
	#Added by Ralph
	var fetishstatus = "\n\n" + person.name + " has the following known fetishes:\n"
	var textcolor = ""
	for i in person.knownfetishes:
		if person.fetish[i] in ['mindblowing','enjoyable']:
			textcolor = "[color=green]"
		elif person.fetish[i] in ['acceptable','uncertain']:
			textcolor = "[color=yellow]"
		else:
			textcolor = "[color=red]"
		fetishstatus += str(i).capitalize() + ": " + textcolor + person.fetish[i].capitalize() + "[/color]\n"
	#/ralph7
	
	#The Fetish Response
	var fetishname
	if !mode in ["intro",'introknown','introunknown']:
		fetishname = globals.expansion.getFetishDescription(str(mode))
		person.dailytalk.append('talk_new_fetish')
		#Add the Accept/Refuse/Barter later
		if person.knownfetishes.find(mode) >= 0:
			person.dailyevents.append(mode)
			person.dailytalk.append(mode)
			text = person.quirk("[color=yellow]-You already know how I feel about " + fetishname + ". I think that " + fetishname + " is " + str(person.fetish[mode]) + ".[/color]")
			
		else:
			#Resistance Check
			person.knownfetishes.append(mode)
			if person.checkFetish(mode, 3) || checkEntrancement() == true:
				person.dailytalk.append(mode)
				if str(person.fetish[mode]) == 'mindblowing':
					text = person.quirk("[color=yellow]-Oh, " + fetishname + "?! I absolutely love " + fetishname + "! It is absolutely " + str(person.fetish[mode]).capitalize() + "!!![/color]")
					
				else:
					text += person.quirk("[color=yellow]-I suppose I can talk to you about how I feel about " + fetishname + ".")
					if str(person.fetish[mode]) == 'uncertain':
						text = person.quirk("[color=yellow]I feel pretty " + str(person.fetish[mode]) + " about it. I don't know enough about it to feel one way or the other.[/color]")
					else:
						text = person.quirk("[color=yellow]I think that " + fetishname + " is " + str(person.fetish[mode]) + ".[/color]")
			else:
				text = person.quirk("[color=yellow]-Ugh! " + fetishname + "?! I...I can't talk about " + fetishname + "! Are you crazy or just some kind of pervert? That's so disgusting to think about.[/color]")
				
	
	if mode == "introunknown":
		text = str(expansion.getIntro(person)) + "\n[color=yellow]-"+ person.quirk(str(talk.introGeneral(person))) + "[/color]"
		if !person.knownfetishes.empty():
			text += "\n\n[color=#d1b970][center]Known Fetishes[/center][/color]\n"
			for fetish in person.knownfetishes:
				fetishname = globals.expansion.getFetishDescription(str(fetish))
				text += fetishname.capitalize() + ": " + globals.fastif(globals.fetishopinion.find(person.fetish[fetish]) >= 3,"[color=green]", "[color=red]") + str(person.fetish[fetish].capitalize())+ "[/color]\n"
		for i in globals.fetishesarray:
			fetishname = globals.expansion.getFetishDescription(str(i))
			if globals.expansionsettings.unwantedfetishes.empty() == false && i in globals.expansionsettings.unwantedfetishes:
				continue
			#Discover Fetishes
			if person.knownfetishes.find(i) < 0:
				tempbuttons.append({text = str(globals.randomitemfromarray([person.dictionary('What do you think about '),person.dictionary('How do you feel about ')]) + fetishname), function = 'talkfetishes', args = str(i), tooltip = person.dictionary("Ask $name their opinion about " + fetishname)})
			
				#Incomplete Fetish Check
				if globals.expansion.incompletefetishes.size() > 0:
					if globals.expansion.incompletefetishes.find(i) >= 0:
						if invalidfetishfound == false:
							invalidfetishfound = true
							text += incompletefetishtext
						text += "| [color=aqua] " + str(i).capitalize() + "[/color] "
			
	if mode == "introknown":
		text = str(expansion.getIntro(person)) + "\n[color=yellow]-"+ person.quirk(str(talk.introGeneral(person))) + "[/color]"
		if !person.knownfetishes.empty():
			text += "\n\n[color=#d1b970][center]Known Fetishes[/center][/color]\n"
			for fetish in person.knownfetishes:
				fetishname = globals.expansion.getFetishDescription(str(fetish))
				text += fetishname.capitalize() + ": " + globals.fastif(globals.fetishopinion.find(person.fetish[fetish]) >= 3,"[color=green]", "[color=red]") + str(person.fetish[fetish].capitalize())+ "[/color]\n"
		for i in globals.fetishesarray:
			fetishname = globals.expansion.getFetishDescription(str(i))
			if person.knownfetishes.find(i) >= 0:
				if person.fetish[i] != globals.fetishopinion.back():
					tempbuttons.append({text = str(globals.randomitemfromarray(['Encourage ','Celebrate ','Condone ']) + fetishname), function = 'talkFetishEncourage', args = str(i), tooltip = person.dictionary("Try to increase $name's " + fetishname + " fetish.")})
				if person.fetish[i] != globals.fetishopinion[0]:
					tempbuttons.append({text = str(globals.randomitemfromarray(['Discourage ','Mock ','Ridicule ']) + fetishname), function = 'talkFetishDiscourage', args = str(i), tooltip = person.dictionary("Try to decrease $name's " + fetishname + " fetish.")})
			
				#Incomplete Fetish Check
				if globals.expansion.incompletefetishes.size() > 0:
					if globals.expansion.incompletefetishes.find(i) >= 0:
						if invalidfetishfound == false:
							invalidfetishfound = true
							text += incompletefetishtext
						text += "| [color=aqua] " + str(i).capitalize() + "[/color] "
	
	#The Intro 
	if mode == "intro":
		text = str(expansion.getIntro(person)) + "\n[color=yellow]-"+ person.quirk(str(talk.introGeneral(person))) + "[/color]"
		#Known Fetishes
		if !person.knownfetishes.empty():
			text += "\n\n[color=#d1b970][center]Known Fetishes[/center][/color]\n"
			for fetish in person.knownfetishes:
				fetishname = globals.expansion.getFetishDescription(str(fetish))
				text += fetishname.capitalize() + ": " + globals.fastif(globals.fetishopinion.find(person.fetish[fetish]) >= 3,"[color=green]", "[color=red]") + str(person.fetish[fetish].capitalize())+ "[/color]\n"	
		#Undiscovered Trait
		if person.dailytalk.has('hint_dominance') || person.dailytalk.has('hint_submissive') || person.dailytalk.has('hint_sadism') || person.dailytalk.has('hint_masochism'):
			text += "\n\n[color=#d1b970][center]Undiscovered Trait[/center][/color]"
			if person.dailytalk.has('hint_dominance') || person.dailytalk.has('hint_submissive'):
				text += "\nYou get the feeling that $name may feel strongly about [color=aqua]Control[/color]."
			if person.dailytalk.has('hint_sadism') || person.dailytalk.has('hint_masochism'):
				text += "\nYou get the feeling that $name may feel strongly about [color=aqua]Pain[/color]."
		if !person.dailytalk.has('talk_new_fetish'):
			buttons.append({text = person.dictionary("Let's talk about something new"), function = 'talkfetishes', args = 'introunknown', tooltip = person.dictionary("Learn how $name feels about a fetish.")})
		if person.knownfetishes.size() > 0 && !person.dailytalk.has('talk_change_fetish'):
			buttons.append({text = person.dictionary("Regarding that fetish you told me about..."), function = 'talkfetishes', args = 'introknown', tooltip = person.dictionary("Encourage or Discourage a Fetish.")})
		
		if globals.expansion.incompletefetishes.size() > 0:
			text += incompletefetishtext
			for i in globals.expansion.incompletefetishes:
				text += "| [color=aqua] " + str(i).capitalize() + "[/color] "

	buttons.append({text = str(globals.randomitemfromarray(['Nevermind','Go Back','Return'])), function = '_on_talk_pressed', tooltip = "Go back to the previous screen. IMPORTANT - You will not be able to discuss this again today."})
	#Added this way to have Return placed at the top
	if tempbuttons.size() > 0:
		for i in tempbuttons:
			buttons.append(i)
	get_tree().get_current_scene().dialogue(state, self, person.dictionary(text), buttons, updateSprites(person))
	get_tree().get_current_scene().rebuild_slave_list()
	get_parent().slavetabopen()

func talkFetishEncourage(mode=''):
	var text = ""
	var state = false
	var buttons = []
	
	var topic = str(mode)
	var fetishname = globals.expansion.getFetishDescription(str(mode))
	var fetishmod = 1 + (person.loyal*.01)
	person.dailytalk.append('talk_change_fetish')
	person.dailyevents.append(mode)
	#Resistance Check
	if person.checkFetish(mode, 0, false) || checkEntrancement() == true:
		person.setFetish(mode, fetishmod)
		text = person.quirk("[color=yellow]-You make a good point...I guess that I can admit that " + fetishname + " is " + str(person.fetish[mode]) + ".[/color]")
		text += usedEntrancement()
	else:
		text = person.quirk("[color=yellow]-No. No, I think that " + fetishname + " is " + str(person.fetish[mode]) + ".[/color]")
	
	buttons.append({text = str(globals.randomitemfromarray(['As we were saying...','Anyways...','On another note...'])), function = '_on_talk_pressed', tooltip = "Go back to the main conversation."})
	get_tree().get_current_scene().dialogue(state, self, person.dictionary(text), buttons, updateSprites(person))
	get_tree().get_current_scene().rebuild_slave_list()
	get_parent().slavetabopen()

func talkFetishDiscourage(mode=''):
	var text = ""
	var state = false
	var buttons = []
	
	var fetishname = globals.expansion.getFetishDescription(str(mode))
	var fetishmod = -1 *(1+(person.loyal*.01))
	person.dailytalk.append('talk_change_fetish')
	person.dailyevents.append(mode)
	
	#Resistance Check
	if person.checkFetish(mode, 0, false, false) || checkEntrancement() == true:
		person.setFetish(mode, fetishmod)
		text = person.quirk("[color=yellow]-You make a good point. I guess that I can admit that " + fetishname + " is " + str(person.fetish[mode]) + ".[/color]")
		text += usedEntrancement()
	else:
		text = person.quirk("[color=yellow]-No. No, I think that " + fetishname + " is " + str(person.fetish[mode]) + ".[/color]")
	
	buttons.append({text = str(globals.randomitemfromarray(['As we were saying...','Anyways...','On another note...'])), function = '_on_talk_pressed', tooltip = "Go back to the main conversation."})
	get_tree().get_current_scene().dialogue(state, self, person.dictionary(text), buttons, updateSprites(person))
	get_tree().get_current_scene().rebuild_slave_list()
	get_parent().slavetabopen()

#Sexuality Shift Lock
func talkSexualityShiftToggle(mode=''):
	var text = ""
	var state = false
	var buttons = []
	
	if mode == 'lock':
		person.sexexpanded.sexualitylocked = true
		text += "[color=aqua]$name's[/color] sexuality, [color=aqua]" + str(globals.expansion.getSexuality(person)) + "[/color], is now [color=red]Locked[/color] and will no longer shift during sexual encounters."
	elif mode == 'unlock':
		person.sexexpanded.sexualitylocked = false
		text += "[color=aqua]$name's[/color] sexuality, [color=aqua]" + str(globals.expansion.getSexuality(person)) + "[/color], is now [color=green]Unlocked[/color] and can shift during sexual encounters."
	elif mode == 'intro':
		text = str(expansion.getIntro(person)) + "\n[color=yellow]-"+ person.quirk(str(talk.introGeneral(person))) + "[/color]"
		if person.sexexpanded.sexualitylocked == false:
			text += "\n[color=aqua]$name's[/color] sexuality, [color=aqua]" + str(globals.expansion.getSexuality(person)) + "[/color], is [color=green]Unlocked[/color] and will change during sexual encounters."
			buttons.append({text = str(globals.randomitemfromarray(['I want you to keep your currect sexuality as it is.'])), function = 'talkSexualityShiftToggle', args = 'lock', tooltip = "Lock their sexuality so it will not shift."})
		if person.sexexpanded.sexualitylocked == true:
			text += "\n[color=aqua]$name's[/color] sexuality, [color=aqua]" + str(globals.expansion.getSexuality(person)) + "[/color], is [color=red]Locked[/color] and will not change."
			buttons.append({text = str(globals.randomitemfromarray(['I want you to be open to new experiences.'])), function = 'talkSexualityShiftToggle', args = 'unlock', tooltip = "Unlock their sexuality so it can shift."})
	
	buttons.append({text = str(globals.randomitemfromarray(['While we are on that topic...'])), function = '_on_talk_pressed', args = 'slave_sex_topics', tooltip = "Go back to the previous screen"})
	buttons.append({text = str(globals.randomitemfromarray(['As we were saying...','Anyways...','On another note...'])), function = '_on_talk_pressed', tooltip = "Go back to the main conversation."})
	get_tree().get_current_scene().dialogue(state, self, person.dictionary(text), buttons, updateSprites(person))
	get_tree().get_current_scene().rebuild_slave_list()
	get_parent().slavetabopen()

#---Drain Cum from Pussy Scene---#
var puddle = 0
func eventDrainCum(mode = ''):
	var text = ""
	var state = false
	var buttons = []
	
	var amount = 0
	var reactions = ['$He moans slightly as $his '+str(globals.expansion.namePussy())+'','$He pushes out with $his '+str(globals.expansion.namePussy())+ ' as it ','$He turns bright red as $he spreads $his ' +str(globals.expansion.namePussy())+' and ']
	var cumdrips = ['spurts out a glob of cum','drips out a strand of cum','trickles out a line of semen','sprays out a gush of sticky cum','drains a load of cum']
	var landinglocations = ['onto the floor beneath $him.','onto $his squatting thigh before dripping onto the ground below.','all over the ground beneath $his quivering body.']
	
	if mode == 'intropussy':
		text += "[color=aqua]$name[/color] "
		if person.checkFetish('creampiepussy'):
			text += "smiles brightly.\n[color=yellow]-"+ person.quirk('Absolutely, I would be happy to $master!') + "[/color]\n\n"
		else:
			text += "turns bright red with embarrassment.\n[color=yellow]-"+ person.quirk('Do...do I have to, $master?') + "[/color]\n\n$He sees your determined face and sighs deeply."
		#Strip
		if person.exposed.genitals == false:
			text += "$He gently removes $his lower garments and places them to the side. "
		
		text += "$He squats down and holds $his " + str(globals.expansion.namePussy()) + " lips open. "
		if person.cum.pussy > 0:
			mode = 'pussycum'
		else:
			mode = 'pussycumempty'

	if mode == 'introass':
		text += "[color=aqua]$name[/color] "
		if person.checkFetish('creampieass'):
			text += "smiles brightly.\n[color=yellow]-"+ person.quirk('Absolutely, I would be happy to $master!') + "[/color]\n\n"
		else:
			text += "turns bright red with embarrassment.\n[color=yellow]-"+ person.quirk('Do...do I have to, $master?') + "[/color]\n\n$He sees your determined face and sighs deeply."
		#Strip
		if person.exposed.genitals == false:
			text += "$He gently removes $his lower garments and places them to the side. "
		text += "$He squats down and holds $his " + str(globals.expansion.nameAss()) + " cheeks open. "
		if person.cum.ass > 0:
			mode = 'asscum'
		else:
			mode = 'asscumempty'

	if mode == 'pussycum':
		if person.cum.pussy > 0:
			text += str(globals.randomitemfromarray(reactions)) + str(globals.randomitemfromarray(cumdrips)) + " " + str(globals.randomitemfromarray(landinglocations))
			amount = clamp(round(rand_range(1,person.cum.pussy/2)),1,person.cum.pussy)
			person.cum.pussy -= amount
			puddle += amount
			if globals.expansionsettings.perfectinfo == true:
				text += "\n[color=#d1b970]Loads = " + str(person.cum.pussy) + " Puddle = " + str(puddle) + "[/color]"
			buttons.append({text = str(globals.randomitemfromarray(['Keep going...','Continue','Dont stop draining','Did I say to stop?'])), function = 'eventDrainCum', args = 'pussycum', tooltip = person.dictionary("Order $him to continue")})
		else:
			mode = 'pussycumempty'

	if mode == 'asscum':
		if person.cum.ass > 0:
			text += str(globals.randomitemfromarray(reactions)) + str(globals.randomitemfromarray(cumdrips)) + " " + str(globals.randomitemfromarray(landinglocations))
			amount = clamp(round(rand_range(1,person.cum.ass/2)),1,person.cum.ass)
			person.cum.ass -= amount
			puddle += amount
			if globals.expansionsettings.perfectinfo == true:
				text += "\n[color=#d1b970]Loads = " + str(person.cum.ass) + " Puddle = " + str(puddle) + "[/color]"
			buttons.append({text = str(globals.randomitemfromarray(['Keep going...','Continue','Dont stop draining','Did I say to stop?'])), function = 'eventDrainCum', args = 'asscum', tooltip = person.dictionary("Order $him to continue")})
		else:
			mode = 'asscumempty'

	if mode == 'pussycumempty':
		text += "$name looks up at you, $his legs spread open revealing $his exposed " +str(globals.expansion.namePussy())+ ". $He pushes and squeezes $his pussy until $his face turns red but nothing else drips out of $him. $He looks up at you, seeking your next decision. "
		if rand_range(0,1) >= .5:
			text += "You order $him to check with $his fingers. $He thrusts $his fingers into $himself as deep as they will go and digs around. $His cheeks flush with the embarrassment, humiliation, and excitement as $his fingers probe $his most sensitive spots. $He pulls them out of $himself. You look them over carefully. While they are soaking wet, they don't appear to be wet with semen. "
		else:
			text += "You tell $him to lean back and expose $his " +str(globals.expansion.namePussy())+ " so you can easily reach it. You thrust your fingers into $him and dig around, not bothering to be gentle. $His breathing near your ear gets heavier as you drag your fingers through $his soaking pussy. After a moment, you pull your fingers out of $his gaping lips. $He breathes a long sigh of relief as $he turns $his head to hide $his shamefully bright cheeks as you check your fingers. Though wet, $he appears to be empty of semen in $his pussy. "
		if !person.preg.womb.empty():
			buttons.append({text = str(globals.randomitemfromarray(['Wash out your womb','Clean it all out','Wash it all clean','You are not getting pregnant. Wash it out.'])), function = 'eventDrainCum', args = 'wombwash', tooltip = person.dictionary("Have $him wash all semen out of $his womb")})
		elif puddle > 0:
			buttons.append({text = str(globals.randomitemfromarray(['Wash out your womb','Clean it all out','Wash it all clean','You are not getting pregnant. Wash it out.'])), function = 'eventDrainCum', args = 'cleanpuddle', tooltip = person.dictionary("Have $him wash all semen out of $his womb")})

	if mode == 'asscumempty':
		text += "$name looks up at you, $his legs spread open revealing $his exposed " +str(globals.expansion.nameAss())+ ". $He pushes and squeezes $his ass until $his face turns red but nothing else drips out of $him. $He looks up at you, seeking your next decision. "
		if rand_range(0,1) >= .5:
			text += "You order $him to check with $his fingers. $He thrusts $his fingers into $himself as deep as they will go and digs around. $His cheeks flush with the embarrassment, humiliation, and excitement as $his fingers probe $his most sensitive spots. $He pulls them out of $himself. You look them over carefully. While they are soaking wet, they don't appear to be wet with semen. "
		else:
			text += "You tell $him to lean back and expose $his " +str(globals.expansion.nameAss())+ " so you can easily reach it. You thrust your fingers into $him and dig around, not bothering to be gentle. $His breathing near your ear gets heavier as you drag your fingers through $his soaking ass. After a moment, you pull your fingers out of $his gaping hole. $He breathes a long sigh of relief as $he turns $his head to hide $his shamefully bright cheeks as you check your fingers. Though wet, $he appears to be empty of semen in $his ass. "

	if mode == 'wombwash':
		text += "You go and retrieve a womb-washing canister. You have $him lie on $his back in the puddle of semen. You use the provided speculum to spread and stretch open $his pussy until it is completely gaped. You take the nozzle and tube off of the canister and carefully press it against the tiny hole at the back of $his vagina that you recognize as $his cervix. "
		text += "With the nozzle firmly pressed against $his cervix, you press the small button on the side of the canister. $He audibly squeals as the nozzle extends a tiny tube into $his incredibly tight, almost fully sealed cervix. $He puts $his hand on $his belly, as though that will stop the discomfort deep inside of $him, as the nozzle breaks through into $his womb. "
		buttons.append({text = person.dictionary('Inflate $his womb until $he is bloated'), function = 'eventDrainCum', args = 'wombinflate', tooltip = "Inflate $his womb for fun"})
		buttons.append({text = person.dictionary('Just clean out $his womb'), function = 'eventDrainCum', args = 'wombclean', tooltip = "Just clean $his womb out"})
	
	if mode == 'wombinflate':
		text += "You hit the button labeled 'Clean' and feel the hose come alive. $He moans loudly as a thick, viscious liquid begins to pour directly into $his womb. $He writhes as you watch $his belly begin to rise and rise from the liquid swelling inside of $him. After you are satisfied, you click the 'Off' button and wait. "
		if person.checkFetish('pregnancy'):
			text += "$name holds $his belly and moans softly, but then whispers to you.\n[color=yellow]- " + person.quirk("I feel bloated, like I'm pregnant! Oh, it feels so good!")
		else:
			text += "$name can simply hold $his swollen belly and helplessly moan in discomfort. "
		mode = 'wombdrain'
	
	if mode == 'wombclean':
		text += "You hit the button labeled 'Clean' and feel the hose come alive. $He moans loudly as a thick, viscious liquid begins to pour directly into $his womb. You gauge about the correct amount needed and stop as soon as you see $his belly begin to move. "
		mode = 'wombdrain'
	
	if mode == 'wombdrain':
		text += "You hit the final button on the machine labeled 'Forced Dialation' and watch closely. The nozzle's extended portion seems to buzz for a moment, then it starts to grow. $name's body immediately reacts the only way that it knows how to a dialating cervix and $he starts going into minor contractions. Between $his breathless pushing, moans, and the forcefully growing nozzle, the process is reduced to mere minutes. When the cervix is unnaturally spread enough to allow the draining to complete, you withdraw the nozzle from inside of $him. "
		text += "You put your arm under $him and help $him up with $his vagina still gaping from the speculum inside. $He looks on in shock and horror while, between stomach contractions, $his vagina begins to gush and flow with a myriad of sticky, viscous fluid. You wait until all liquid has completely stopped draining from $his helpless body before removing the speculum. You help $him to $his feet as $he tries to regain any symblance of dignity or self-control $he once had, though this is undercut by $his feet soaking in a puddle of fluid that was inside of $him moments before. "
		for i in person.preg.womb:
			person.preg.womb.erase(i)
			puddle += 1
	
	if mode == 'lickuppuddle':
		if person.checkFetish('drinkcum'):
			text += "$name smiles and cheerfully drops to $his knees. $He kneels into the puddle of " +str(globals.expansion.nameCum())+ " and begins to lick and slurp. This continue until $he has cleaned the floor of the mess $he'd drained out of $himself. $He sits up and smiles brightly as $he swallows yet again. Then $he uses $his fingers to traces every drop from $his face into $his mouth before standing up again. "
		else:
			text += "$name suppresses a sob as $he falls to $his knees in the puddle. $He seems to hate the taste of the semen mixed with $his own juices as $he tries to avoid wretching. $He obediently licks up the puddle, though it takes longer as $he occassionally refills it with the tears dripping down $his face into the mess. $He pushes $himself to $his feet with haunted eyes as traces of the white, gloopy cum drip off of $his face unattended. "
		puddle = 0
	
	if mode == 'leavepuddle':
		globals.state.condition -= round(puddle/2)
		puddle = 0
	
	if puddle <= 0:
		buttons.append({text = str(globals.randomitemfromarray(['Stop,','Nevermind','Go Back','Return'])), function = '_on_talk_pressed', tooltip = "Go back to the main talk screen"})
	else:
		buttons.append({text = person.dictionary('Force $him to lick up the cum puddle'), function = 'eventDrainCum', args = 'lickuppuddle', tooltip = person.dictionary("Force $him to lick up the puddle - End Event")})
		buttons.append({text = person.dictionary('Walk away from the cum puddle'), function = 'eventDrainCum', args = 'leavepuddle', tooltip = "Leave the cum puddle for someone else, add to mansion cleaning duties - End Event"})
	get_tree().get_current_scene().dialogue(state, self, person.dictionary(text), buttons, updateSprites(person))
	get_tree().get_current_scene().rebuild_slave_list()
	get_parent().slavetabopen()

func getRollText(roll,consent_chance):
	return "\n\nRolled [color=aqua]" + str(roll) + "[/color] | Consent Chance [color=aqua]" + str(consent_chance) + "[/color]. "+ globals.fastif(roll <= consent_chance, '[color=green]Success[/color]', '[color=red]Failure[/color]') +" "

#Consent Topics
func talkconsent(mode=''):
	var text = ""
	var state = false
	var buttons = []
	
	var related = globals.expansion.relatedCheck(person,globals.player)
	var consent_chance = 0
	var roll = 0
	#Consent to Join Combat Party
	if mode == "party":
		person.dailytalk.append('consentparty')
		#Chance & Roll
		consent_chance = round(person.metrics.ownership*5 + person.obed*.25 + person.loyal*.5 + person.fear*.25)
		roll = round(rand_range(0,100))
		#Modifiers; Captured Effect, Wrath Vice
		for i in person.effects.values():
			if i.code == 'captured':
				consent_chance -= i.duration * 25
		if person.checkVice('wrath'):
			consent_chance += round(person.cour * .2)
		#Result
		if roll <= consent_chance || checkEntrancement() == true:
			#Add Variable Text
			text += person.quirk("[color=yellow]-" + str(talk.consentPartyAccept(person)) +"[/color]")
			person.consentexp.party = true
			#Reduce Rebellion
			var reduced_rebellion = false
			for i in person.effects.values():
				if i.code == 'captured':
					i.duration -= clamp(round(rand_range(1,3)), 1, i.duration)
					reduced_rebellion = true
			if reduced_rebellion == true:
				text += "\n\nYou overhear $him whisper quietly to $himself." + person.quirk("\n[color=yellow]-" + str(talk.consentPartyReduceRebellion(person)) +"[/color]") + "\n\n$His [color=aqua]Rebellion[/color] slightly decreased."
			text += usedEntrancement()
		else:
			expansion.updateMood(person,-1)
			text += person.quirk("[color=yellow]-" + str(talk.consentPartyRefuse(person)) +"[/color]")
		if globals.expansionsettings.perfectinfo == true:
			text += getRollText(roll,consent_chance)

	elif mode == "sexual":
		consent_chance = round(person.obed*3 + person.loyal*2 + person.lust - 250)
		roll = round(rand_range(0,100))
		if person.effects.has('captured'):
			consent_chance -= 100
		###---Sexuality
		if globals.expansion.getSexualAttraction(person,globals.player) == true:
			consent_chance += round(rand_range(10,40))
		else:
			consent_chance -= round(rand_range(10,40))
		###---Family Matters; Incest Check
		person.dailytalk.append('consent')
		if related != "unrelated" && person.consentexp.incest == false:
			person.dailytalk.append('consentincest')
			var incest = (globals.fetishopinion.find(person.fetish.incest)-6) + round(person.dailyevents.count('incest')/4)
			consent_chance += incest*10
		
		if person.traits.has('Prude'):
			consent_chance -= 50
		if roll <= consent_chance || checkEntrancement() == true:
			person.lust += 3
			text += "$He gives you a meek nod.\n[color=yellow]-" + person.quirk("Okay...I will have sex with you. ") + "[/color]"
			###---Added by Expansion---### Incest Check
			related = globals.expansion.relatedCheck(person,globals.player)
			if related != "unrelated":
				person.consentexp.incest = true
				if person.fetish.incest in ['taboo','dirty','unacceptable']:
					person.fetish.incest = 'uncertain'
				text += "\n$He " + str(globals.randomitemfromarray(['whispers','mumbles','quickly says','says','quietly says'])) + " " + person.quirk("\n[color=yellow]-I "+ str(globals.randomitemfromarray(["can't believe I'm ready to","am so ready to","didn't ever think that I would","can't wait to","never thought that I would"])) +" "+ globals.expansion.nameSex() + " my " + str(related) + ". ")
				text += "\n\n[color=green]Unlocked Sexual and Incestuous actions with $name.[/color]"
			else:
				text += "\n\n[color=green]Unlocked sexual actions with $name.[/color]"
			if person.levelupreqs.has('code') && person.levelupreqs.code == 'relationship':
				text += "\n\n[color=green]After getting closer with $name, you felt like $he unlocked new potential. [/color]"
				### Levelup Removed by Ank BugFix v4a
			person.consent = true
			text += usedEntrancement()
		else:
			text += "$He shows a troubled face and rejects your proposal. "
			###---Added by Expansion---### Incest Check
			if related != "unrelated" && person.consentexp.incest != true:
				text += "\n$He looks at you. " + person.quirk("\n[color=yellow]-I just am not " + str(globals.randomitemfromarray(['comfortable with','interested in','ready to','prepared to','okay to'])) + " " + globals.expansion.nameSex() + " my " + str(related) + ". [/color]")
				person.dailyevents.append('incest')
				if rand_range(0,5) + person.dailyevents.count('incest') >= 5:
					text += "\n\nYou do catch onto a flash of hesitation, however, and think that $he may be coming around to the idea of it. "
					person.dailyevents.append('incest')
			else:
				text += "\n$He looks at you. " + person.quirk("\n[color=yellow]-I just am not " + str(globals.randomitemfromarray(['comfortable with','interested in','ready to','prepared to','okay to'])) + " " + globals.expansion.nameSex() + " you. [/color]")
		if globals.expansionsettings.perfectinfo == true:
			text += getRollText(roll,consent_chance)

	elif mode == "pregnancy":
		person.dailytalk.append('consentpregnant')
		if person.consent == true:
			#Chance & Roll
			consent_chance = round(person.loyal + person.instinct.reproduce - person.metrics.birth*10)
			roll = round(rand_range(0,100))
			#Modifiers; Fetishes: Pregnancy & Incest
			related = globals.expansion.relatedCheck(person,globals.player)
			if related != "unrelated" && person.checkFetish('incest'):
				consent_chance += globals.fetishopinion.find(person.fetish.incest)-3*10
			if person.checkFetish('pregnancy'):
				consent_chance += 50
			#Result
			if roll <= consent_chance || checkEntrancement() == true:
				#Change Dialogue
				text += str(expansion.getIntro(person)) + "[color=yellow]-"+person.quirk(talk.consentBreederAccept(person))+"[/color]"
				person.consentexp.pregnancy = true
				person.pregexp.wantedpregnancy = true
				if related != "unrelated":
					person.consentexp.incestbreeder = true
					text += "\n$He " + str(globals.randomitemfromarray(['whispers','mumbles','quickly says','says','quietly says'])) + " " + person.quirk("[color=yellow]-I can not believe I want to " + globals.expansion.nameSex() + " my " + str(related) + ". ")
				text += "\n\n[color=green]$name is willing to have a baby with you.[/color]"
				text += usedEntrancement()
			else:
				expansion.updateMood(person,-1)
				if person.metrics.birth > 0:
					text += str(expansion.getIntro(person)) + person.quirk("[color=yellow]-I don't think I am ready for more kids.[/color]")
				else:
					text += str(expansion.getIntro(person)) + person.quirk("[color=yellow]-I am just not ready for children. Sorry.[/color]")
			if globals.expansionsettings.perfectinfo == true:
				text += getRollText(roll,consent_chance)
		else:
			expansion.updateMood(person,-1)
			text += str(expansion.getIntro(person)) + "[color=yellow]-"+person.quirk("I haven't agreed to have sex with you, why do you think I'd have your baby? Shouldn't we talk about that first?")+"[/color]"

	elif mode == "stud":
		person.dailytalk.append('consentstud')
		#Chance & Roll
		consent_chance = round(person.loyal*.2 + person.lewdness*.3 + person.lust*.3 + person.instinct.reproduce*5 - (person.metrics.birth-person.pregexp.desiredoffspring)*5)
		roll = round(rand_range(25,100))
		#Modifiers; Fetish: Pregnancy
		if person.checkFetish('pregnancy'):
			consent_chance += 25
		#Result
		if roll <= consent_chance || checkEntrancement() == true:
			#Change Dialogue
			text += str(expansion.getIntro(person)) + "[color=yellow]-"+person.quirk(talk.consentStudAccept(person))+"[/color]"
			person.consentexp.stud = true
			text += "\n\n[color=green]$name will now Breed other slaves for you as a Stud.[/color]"
			text += usedEntrancement()
		else:
			expansion.updateMood(person,-1)
			text += str(expansion.getIntro(person)) + "[color=yellow]-"+person.quirk("Nah, I'm not interested.")+"[/color]"
		if globals.expansionsettings.perfectinfo == true:
			text += getRollText(roll,consent_chance)

	elif mode == "breeder":
		person.dailytalk.append('consentbreeder')
		#Chance & Roll
		consent_chance = round(person.loyal*.2 + person.lewdness*.2 + person.lust*.2 + person.instinct.reproduce - (person.metrics.birth-person.pregexp.desiredoffspring)*10)
		roll = round(rand_range(50,100))
		#Modifiers; Fetish: Pregnancy
		if person.checkFetish('pregnancy'):
			consent_chance += 50
		if roll <= consent_chance || checkEntrancement() == true:
			#Change Dialogue
			text += str(expansion.getIntro(person)) + "[color=yellow]-"+person.quirk(talk.consentBreederAccept(person))+"[/color]"
			person.consentexp.breeder = true
			text += "\n\n[color=green]$name will now be Bred by other slaves for you.[/color]"
			text += usedEntrancement()
		else:
			expansion.updateMood(person,-1)
			if person.metrics.birth > 0:
				text += str(expansion.getIntro(person)) + person.quirk("[color=yellow]-I don't think I am ready for more kids.[/color]")
			else:
				text += str(expansion.getIntro(person)) + person.quirk("[color=yellow]-I am just not ready for children yet.[/color]")
		if globals.expansionsettings.perfectinfo == true:
			text += getRollText(roll,consent_chance)

	elif mode == "incest":
		person.dailytalk.append('consentincest')
		#Auto-Success
		if expansion.relatedCheck(person,globals.player) != "unrelated":
			if person.consent == true:
				person.consentexp.incest = true
				text += str(expansion.getIntro(person)) + "[color=yellow]-"+person.quirk("Okay, I'll fuck my other family members for you too.")+"[/color]"
				text += "\n\n[color=green]$name will now do Incestuous Actions for you.[/color]"
		else:
			#Chance & Roll
			consent_chance = round(person.loyal*.2 + person.lewdness*.2 + person.lust*.1 + globals.fetishopinion.find(person.fetish.incest)*10 + person.dailyevents.find('incest')*5)
			roll = round(rand_range(0,100))
			if roll <= consent_chance || checkEntrancement() == true:
				text += str(expansion.getIntro(person)) + "[color=yellow]-"+person.quirk("Okay, I'll fuck my family members for you.")+"[/color]"
				person.consentexp.incest = true
				text += "\n\n[color=green]$name will now do Incestuous Actions for you.[/color]"
				text += usedEntrancement()
			else:
				expansion.updateMood(person,-1)
				text += str(expansion.getIntro(person)) + "[color=yellow]-"+person.quirk("No! I'm not interested.")+"[/color]"
			if globals.expansionsettings.perfectinfo == true:
				text += getRollText(roll,consent_chance)

	elif mode == "incestbreeder":
		person.dailytalk.append('consentincestbreeder')
		#Chance & Roll
		consent_chance = round(person.loyal*.2 + person.lewdness*.2 + person.lust*.1 + person.instinct.reproduce + globals.fetishopinion.find(person.fetish.incest)*10 + person.dailyevents.find('incest')*5 - person.metrics.birth*10)
		roll = round(rand_range(0,100))
		if roll <= consent_chance || checkEntrancement() == true:
			#Change Dialogue
			text += str(expansion.getIntro(person)) + "[color=yellow]-"+person.quirk(talk.consentBreederAccept(person))+"[/color]"
			person.consentexp.incestbreeder = true
			text += "\n\n[color=green]$name will now be Bred by related slaves for you.[/color]"
			text += usedEntrancement()
		else:
			expansion.updateMood(person,-1)
			text += str(expansion.getIntro(person)) + "[color=yellow]-"+person.quirk("Nah, I'm not interested.")+"[/color]"
		if globals.expansionsettings.perfectinfo == true:
			text += getRollText(roll,consent_chance)
	
	elif mode == "livestock":
		person.dailytalk.append('consentlivestock')
		if person.consentexp.breeder == true || person.consentexp.stud == true:
			#Chance & Roll
			consent_chance = round(globals.expansionsettings.baselivestockconsentchance + person.loyal*.35 + person.obed*.25)
			roll = round(rand_range(50,100))
			#Modifiers; Lactating, Fetish: BeMilked, Pregnancy, & Submission, 
			var livestockcounter = 0
			if person.lactation == true && person.knowledge.has('lactating'):
				livestockcounter += 2
				if person.lactating.pressure > 0:
					livestockcounter += round(person.lactating.pressure * .2)
			if person.checkFetish('bemilked', 1) == true:
				livestockcounter += 3
			if person.checkFetish('pregnancy', 1) == true:
				livestockcounter += 2
			if person.checkFetish('oviposition', 1) == true:
				livestockcounter += 2
			if person.checkFetish('submission', 1) == true:
				livestockcounter += 1		
			if livestockcounter > 0:
				consent_chance += livestockcounter * 10
			#Result
			if roll <= consent_chance || checkEntrancement() == true:
				#Change Dialogue
				text += str(expansion.getIntro(person)) + "[color=yellow]-"+person.quirk("If that is really what you want for me, I trust you. I...I won't fight you if that is what you want from me.")+"[/color]"
				person.consentexp.livestock = true
				text += "\n\n[color=green]$name will go willingly to be livestock in the farm.[/color]"
				text += usedEntrancement()
			else:
				expansion.updateMood(person,-1)
				text += str(expansion.getIntro(person)) + "[color=yellow]-"+person.quirk("NO! Please, no! Anything but that. Don't send me to that awful place! I'm not livestock!")+"[/color]"
			if globals.expansionsettings.perfectinfo == true:
				text += getRollText(roll,consent_chance)
		else:
			expansion.updateMood(person,-1)
			text += str(expansion.getIntro(person)) + "[color=yellow]-"+person.quirk("Seriously? I haven't even agreed to any [color=aqua]Breeding[/color] whatsoever, why do you think I'd agree to get stuck in the farm and milked, fucked, and " + globals.fastif(person.preg.has_womb, 'be bred', 'breed others') + " at your whim? No thank you.")+"[/color]"

	if mode == "intro":
		#Change Dialogue
		text += "[color=red]Consent Topics are once per day. If Consent failed, you can try again tomorrow.[/color]\n\n[color=yellow]-What did you want to talk about?[/color]"
		#Added by RalphTweaks
		var consentstatus = "\n\n" + person.name + " has consented to the following:\n"
		if person.consentexp.party:
			consentstatus += "$He will [color=green]fight[/color] for you.\n"
		else:
			consentstatus += "$He will [color=red]not fight[/color] for you.\n"
		if person.consent:
			consentstatus += "$He has given consent to [color=green]have sex[/color] with you.\n"
		else:
			consentstatus += "$He has not given consent to [color=red]have sex[/color] with you.\n"
		if person.consentexp.pregnancy && person.preg.has_womb && globals.player.penis != "none":
			consentstatus += "$He has given consent to [color=green]be impregnated[/color] by you.\n"
		elif person.preg.has_womb && globals.player.penis != "none":
			consentstatus += "$He has not given consent to [color=red]be impregnated[/color] by you.\n"
		if person.consentexp.stud && person.penis != "none":
			consentstatus += "$He has agreed to [color=green]stud[/color] for you and will impregnate other slaves.\n"
		elif person.penis != "none":
			consentstatus += "$He has not agreed to [color=red]stud[/color] for you and does not want to father children with other slaves.\n"
		if person.consentexp.breeder && person.preg.has_womb:
			consentstatus += "$He has agreed to [color=green]be bred[/color] by other slaves for you.\n"
		elif person.preg.has_womb:
			consentstatus += "$He has not agreed to [color=red]be bred[/color] by other slaves for you.\n"
		if person.consentexp.incest:
			consentstatus += "$He has consented to have [color=green]incestuous sex[/color].\n"
		else:
			consentstatus += "$He has not consented to have [color=red]incestuous sex[/color].\n"
		if person.consentexp.incestbreeder && person.preg.has_womb:
			consentstatus += "$He has consented to [color=green]be bred by family[/color].\n"
		elif person.preg.has_womb:
			consentstatus += "$He has not consented to [color=red]be bred by family[/color].\n"
		if person.consentexp.livestock && globals.state.farm >= 3:
			consentstatus += "$He has consented to [color=green]be treated as livestock[/color] in the [color=aqua]Farm[/color].\n"
		elif globals.state.farm >= 3:
			consentstatus += "$He has not consented to [color=red]be treated as livestock[/color] in the [color=aqua]Farm[/color].\n"
		text += consentstatus
		#Party Up Consent
		if !person.dailytalk.has('consentparty') && person.consentexp.party == false:
			buttons.append({text = person.dictionary("Will you travel and fight with me?"), function = 'talkconsent', args = 'party'})
		#Sexual Consent
		if !person.dailytalk.has('consent') && person.consent == false:
			buttons.append({text = person.dictionary("Are you willing to have sex with me?"), function = 'talkconsent', args = 'sexual'})
		#Pregnancy Consent (With Player)
		if person.consent == true && !person.dailytalk.has('consentpregnant') && person.consentexp.pregnancy == false:
			if person.preg.has_womb == true && globals.player.penis != "none":
				buttons.append({text = person.dictionary("I want to impregnate you"), function = 'talkconsent', args = 'pregnancy'})
		#Breeding Stud
		if !person.dailytalk.has('consentstud') && person.consentexp.stud == false:
			if person.penis != "none":
				buttons.append({text = person.dictionary("Do you want to "+str(expansion.nameBreed())+" other slaves for me?"), function = 'talkconsent', args = 'stud'})
		#Breeder
		if !person.dailytalk.has('consentbreeder') && person.consentexp.breeder == false:
			if person.preg.has_womb == true:
				buttons.append({text = person.dictionary("Will you allow me to have other slaves "+str(expansion.nameBreed())+" you?"), function = 'talkconsent', args = 'breeder'})
		#Incest
		if !person.dailytalk.has('consentincest') && person.consentexp.incest == false:
			buttons.append({text = person.dictionary("Will you "+str(expansion.nameSex())+" with family members?"), function = 'talkconsent', args = 'incest'})
		#Incest Breeder
		if person.consentexp.incest == true && (person.consentexp.breeder == true || person.consentexp.stud == true) && !person.dailytalk.has('consentincestbreeder') && person.consentexp.incestbreeder == false:
			buttons.append({text = person.dictionary("Will you "+str(expansion.nameBeBred())+" by relatives?"), function = 'talkconsent', args = 'incestbreeder'})
		#Livestock
		if globals.state.farm >= 3 && !person.dailytalk.has('consentlivestock') && person.consentexp.livestock == false:
			buttons.append({text = person.dictionary("Would you willingly work in the Farm as livestock?"), function = 'talkconsent', args = 'livestock'})
	
	else:
		buttons.append({text = person.dictionary("While we are discussing Consent..."), function = 'talkconsent', args = 'intro'})
	buttons.append({text = str(globals.randomitemfromarray(['Nevermind','Go Back','Return','Cancel'])), function = '_on_talk_pressed', tooltip = "Go back to the previous screen"})
	get_tree().get_current_scene().dialogue(state, self, person.dictionary(text), buttons, updateSprites(person))
	get_tree().get_current_scene().rebuild_slave_list()
	get_parent().slavetabopen()

func topicclothing(mode=''):
	#This will let you strip or clothe the Tits/Chest, Genitals, or Ass of any Slave (revealing them in Descriptions)
	var text = ""
	var state = false
	var buttons = []
	
	#Reactions to Requests
	if mode == 'strip chest':
		#Add Slave Reaction
		mode = "strip chest success"
	if mode == 'strip genitals':
		#Add Slave Reaction
		mode = "strip genitals success"
	if mode == 'strip ass':
		#Add Slave Reaction
		mode = "strip ass success"
	if mode == 'full strip':
		#Add Slave Reaction: Add in "Accept", "Refuse", and "Barter" dialogue
		mode = 'full strip success'
	
	#Reactions to Request (Only Refuse if Exhibitionist)
	if mode == 'clothe chest':
		#Add Slave Reaction
		mode = "clothe chest success"
	if mode == 'clothe genitals':
		#Add Slave Reaction
		mode = "clothe genitals success"
	if mode == 'clothe ass':
		#Add Slave Reaction
		mode = "clothe ass success"
	if mode == 'full clothe':
		#Add Slave Reaction: Add in "Accept", "Refuse", and "Barter" dialogue
		mode = 'full clothe success'
	
	#Success if for Accepted or Barter Success
	if mode == 'full strip success':
		text += "[color=green]$name[/color] " + expansion.getExpression(person) +  " at you and begins to strip " + str(globals.randomitemfromarray(['slowly','eagerly','quickly']))
		person.exposed.chest = true
		person.exposed.genitals = true
		person.exposed.ass = true
		mode = 'intro'
	if mode == 'strip chest success':
		text += "[color=green]$name[/color] " + expansion.getExpression(person) +  " at you and begins to reveal $his " + str(expansion.getChest(person)) + " " + str(globals.randomitemfromarray(['slowly','eagerly','quickly']))
		person.exposed.chest = true
		mode = 'intro'
	if mode == 'strip genitals success':
		text += "[color=green]$name[/color] " + expansion.getExpression(person) +  " at you and begins to strip $his lower body " + str(globals.randomitemfromarray(['slowly','eagerly','quickly']))
		person.exposed.genitals = true
		mode = 'intro'
	if mode == 'strip ass success':
		text += "[color=green]$name[/color] " + expansion.getExpression(person) +  " at you and begins to reveal $his backside " + str(globals.randomitemfromarray(['slowly','eagerly','quickly']))
		person.exposed.ass = true
		mode = 'intro'
	#Forced is for "Torn" clothing under Refuse or Barter
	if mode == 'full strip forced':
		text += "[color=green]$name[/color] " + expansion.getExpression(person) +  " at you as you begin to strip them " + str(globals.randomitemfromarray(['brutally','eagerly','cruelly','mercilessly']))
		person.exposed.chest = true
		person.exposed.genitals = true
		person.exposed.ass = true
		person.exposed.chestforced = true
		person.exposed.genitalsforced = true
		person.exposed.assforced = true
		text += "$He is left " + str(globals.randomitemfromarray(['cowering','whimpering','shivering','shaking'])) + " while " + str(expansion.nameNaked())
		mode = 'intro'
	#Clothing is rarely Refused
	if mode == 'full clothe success':
		text += "[color=green]$name[/color] " + expansion.getExpression(person) +  " at you " + str(globals.randomitemfromarray(['gratefully','eagerly','respectfully'])) + "."
		if person.exposed.chestforced == false:
			text += "$He covers $his " + str(expansion.getChest(person))
			person.exposed.chest = false
		if person.exposed.genitalsforced == false:
			if person.penis != "none" || person.vagina != "none":
				text += ", $his " + str(expansion.getGenitals(person))
			person.exposed.genitals = false
		if person.exposed.assforced == false:
			if person.asshole != "none":
				text += ", and $his " + str(person.asshole) + " " + str(expansion.nameAsshole())
			person.exposed.ass = false
		text += "\n"
		if person.exposed.chestforced == true:
			text += "$He can't cover $his " + str(expansion.getChest(person))
			text += " as that part of $his clothing was " + str(globals.randomitemfromarray(['torn','ripped','taken away'])) + ".\n"
		if person.exposed.genitalsforced == true:
			text += "$He can't cover $his "
			if person.penis != "none":
				text += str(person.penis) + " " + str(expansion.namePenis())
			if person.vagina != "none":
				text += str(person.vagina) + " " + str(expansion.namePussy())
			text += " as that part of $his clothing was " + str(globals.randomitemfromarray(['torn','ripped','taken away'])) + ".\n"
		if person.exposed.assforced == true:
			text += "$He can't cover $his " + str(person.asshole) + " " + str(expansion.nameAsshole())
			text += " as that part of $his clothing was " + str(globals.randomitemfromarray(['torn','ripped','taken away'])) + ".\n"
		mode = 'intro'
	if mode == 'clothe chest success':
		if person.exposed.chestforced == false:
			text += "[color=green]$name[/color] " + expansion.getExpression(person) +  " at you " + str(globals.randomitemfromarray(['gratefully','eagerly','respectfully'])) + " and covers $his " + str(expansion.getChest(person))
			person.exposed.chest = false
		elif person.exposed.chestforced == true:
			text += "$He can't cover $his " + str(expansion.getChest(person))
			text += " as that part of $his clothing was " + str(globals.randomitemfromarray(['torn','ripped','taken away']))
		text += ".\n"
		mode = 'intro'
	if mode == 'clothe genitals success':
		if person.exposed.genitalsforced == false:
			text += "[color=green]$name[/color] " + expansion.getExpression(person) +  " at you " + str(globals.randomitemfromarray(['gratefully','eagerly','respectfully'])) + " and covers $his " + str(expansion.getGenitals(person))
			person.exposed.genitals = false
		elif person.exposed.genitalsforced == true:
			text += "$He can't cover $his " + str(expansion.getGenitals(person))
			text += " as that part of $his clothing was " + str(globals.randomitemfromarray(['torn','ripped','taken away']))
		text += ".\n"
		mode = 'intro'
	if mode == 'clothe ass success':
		if person.exposed.assforced == false:
			text += "[color=green]$name[/color] " + expansion.getExpression(person) +  " at you " + str(globals.randomitemfromarray(['gratefully','eagerly','respectfully'])) + " and covers $his "
			text += str(person.asshole) + " " + str(expansion.nameAsshole())
			person.exposed.ass = false
		elif person.exposed.assforced == true:
			text += "$He can't cover $his " + str(person.asshole) + " " + str(expansion.nameAsshole())
			text += " as that part of $his clothing was " + str(globals.randomitemfromarray(['torn','ripped','taken away']))
		text += ".\n"
		mode = 'intro'

	#It All Starts Here
	if mode == 'intro':
		text = "$name " + str(expansion.getExpression(person)) + " at you and says\n" + person.quirk("[color=yellow]-" + str(talk.introStrip(person)) + "[/color]")
		#Full Strip/Reclothe
		if person.exposed.chest == false || person.exposed.genitals == false || person.exposed.ass == false:
			buttons.append({text = person.dictionary("Strip down fully."), function = 'topicclothing', args = 'full strip', tooltip = "Remove all Clothing"})
		if person.exposed.chest == true || person.exposed.genitals == true || person.exposed.ass == true:
			buttons.append({text = person.dictionary(str(globals.randomitemfromarray(['Cover yourself up','Hide that shameful body','Reclothe yourself','You may dress']))), function = 'topicclothing', args = 'full clothe', tooltip = "Put all clothing back on (if possible)"})
		#Chest
		if person.exposed.chest == false:
			buttons.append({text = person.dictionary("Show me your " + str(expansion.getChest(person))), function = 'topicclothing', args = 'strip chest', tooltip = person.dictionary("Strip $his upper body")})
		elif person.exposed.chest == true:
			buttons.append({text = person.dictionary("Cover your " + str(expansion.getChest(person))), function = 'topicclothing', args = 'clothe chest', tooltip = person.dictionary("Cover $his upper body")})
		#Genitals
		if person.exposed.genitals == false:
			buttons.append({text = person.dictionary("Show me your " + str(expansion.getGenitals(person))), function = 'topicclothing', args = 'strip genitals', tooltip = person.dictionary("Strip $his " + str(expansion.getGenitals(person)))})
		elif person.exposed.genitals == true:
			buttons.append({text = person.dictionary("Cover your " + str(expansion.getGenitals(person))), function = 'topicclothing', args = 'clothe genitals', tooltip = person.dictionary("Cover $his " + str(expansion.getGenitals(person)))})
		#Ass
		if person.exposed.ass == false:
			buttons.append({text = person.dictionary("Show me your " + str(expansion.nameAsshole())), function = 'topicclothing', args = 'strip ass', tooltip = person.dictionary("Strip $his " + str(expansion.nameAsshole()))})
		elif person.exposed.ass == true:
			buttons.append({text = person.dictionary("Cover your " + str(expansion.nameAsshole())), function = 'topicclothing', args = 'clothe ass', tooltip = person.dictionary("Cover $his " + str(expansion.nameAsshole()))})
	expansion.updateBodyImage(person)
	buttons.append({text = str(globals.randomitemfromarray(['Nevermind','Go Back','Return','Cancel'])), function = '_on_talk_pressed', tooltip = "Go back to the previous screen"})
	get_tree().get_current_scene().dialogue(state, self, person.dictionary(text), buttons, updateSprites(person))
	get_tree().get_current_scene().rebuild_slave_list()
	get_parent().slavetabopen()
###---End Expansion---###

###---Added by Expansion---### Cheat/Test Button
func cheatButton(mode = ''):
	#This will let you strip or clothe the Tits/Chest, Genitals, or Ass of any Slave (revealing them in Descriptions)
	var text = ""
	var state = false
	var buttons = []
	#Add Items
	# Removed 'gear' as it won't Add Correctly
	var itemtypes = ['supply','ingredient','potion','gear']
	var gearsubtypes = ['costume','underwear','armor','weapon','accessory']
	
	#Start
	if mode == 'intro':
		buttons.append({text = "Add an Item", function = 'cheatButton', args = 'additem', tooltip = 'You cheater'})
		buttons.append({text = "Add a Farm Item", function = 'cheatButton', args = 'addfarm', tooltip = 'You cheater'})
		buttons.append({text = "Prep Crystal for Sacrifice", function = 'cheatButton', args = 'feedcrystal', tooltip = 'You cheater'})
		if person.preg.has_womb == true:
			buttons.append({text = "Impregnate", function = 'cheatButton', args = 'impregnate', tooltip = 'Give them ' + str(person.preg.unborn_baby.size() + 1) + ' Babies '})
			if person.preg.unborn_baby.size() > 0:
				buttons.append({text = "Gain Pregnancy Day", function = 'cheatButton', args = 'gainpregday', tooltip = 'Set days pregnant to ' + str(person.preg.duration + 1)})
	
	#---Add Item Cheats
	if mode in itemtypes && mode != 'gear':
		for i in globals.itemdict:
			if globals.itemdict[i].type == mode:
				buttons.append({text = "Add 1 " + str(globals.itemdict[i].name), function = 'cheatButtonAddItem', args = globals.itemdict[i].code, tooltip = 'You cheater'})
	
	if mode in gearsubtypes:
		for i in globals.itemdict:
			if globals.itemdict[i].has('subtype') && globals.itemdict[i].subtype == mode:
				buttons.append({text = "Add 1 " + str(globals.itemdict[i].name), function = 'cheatButtonAddItem', args = globals.itemdict[i].code, tooltip = 'You cheater'})
	
	#Split into Gear Category
	if mode == 'gear':
		for i in gearsubtypes:
			buttons.append({text = "Add a " + str(i).capitalize() + " Type Item", function = 'cheatButton', args = i, tooltip = 'You cheater'})
	
	#Primary Item Category
	if mode == 'additem':
		for i in itemtypes:
			buttons.append({text = "Add a " + str(i).capitalize() + " Type Item", function = 'cheatButton', args = i, tooltip = 'You cheater'})
	
	
	#Farm Categories
	if mode == 'addfarm':
		buttons.append({text = "Add 1 Snail", function = 'cheatButton', args = 'addfarm_snail', tooltip = 'Add for ' + str(globals.state.snails + 1) + ' snails'})
		buttons.append({text = "Add 1 Snail Egg", function = 'cheatButton', args = 'addfarm_snailegg', tooltip = 'You cheater'})
	
	if mode == 'addfarm_snail':
		globals.state.snails += 1
		text += "1 [color=aqua]Snail[/color] Added"
	
	if mode == 'addfarm_snailegg':
		globals.resources.farmexpanded.snails.eggs += 1
		text += "1 [color=aqua]Snail Egg[/color] Added"
	
	#Crystal Consquences
	if mode == "feedcrystal":
		globals.state.thecrystal.mode = "dark"
		globals.state.thecrystal.abilities.append('sacrifice')
	
	#Impregnation
	if mode == "impregnate":
		globals.expansion.fertilize_egg(person, globals.player.id, globals.player.unique)
		text += "Egg Fertilized by Player. $name is now pregnant with " + str(person.preg.unborn_baby.size()) + " babies."
	
	#Gain Pregnancy Day
	if mode == "gainpregday":
		person.preg.duration += 1
		text += "Day gained. Days Pregnant now " + str(person.preg.duration) + ". "
	
	buttons.append({text = str(globals.randomitemfromarray(['Nevermind','Go Back','Return','Cancel'])), function = '_on_talk_pressed', tooltip = "Go back to the previous screen"})
	get_tree().get_current_scene().dialogue(state, self, person.dictionary(text), buttons, updateSprites(person))
	get_tree().get_current_scene().rebuild_slave_list()
	get_parent().slavetabopen()

func cheatButtonAddItem(mode = ''):
	#This will let you strip or clothe the Tits/Chest, Genitals, or Ass of any Slave (revealing them in Descriptions)
	var text = ""
	var state = false
	var buttons = []
	
	text += "1 [color=aqua]" +str(globals.itemdict[mode].name).capitalize() + "[/color] Added"
	
	if globals.itemdict[mode].type != 'gear':
		globals.itemdict[mode].amount += 1
	else:
		var tmpitem = globals.items.createunstackable(globals.itemdict[mode].code)
		globals.state.unstackables[str(tmpitem.id)] = tmpitem
	
	buttons.append({text = str(globals.randomitemfromarray(['Nevermind','Go Back','Return','Cancel'])), function = '_on_talk_pressed', tooltip = "Go back to the previous screen"})
	get_tree().get_current_scene().dialogue(state, self, person.dictionary(text), buttons, updateSprites(person))
	get_tree().get_current_scene().rebuild_slave_list()
	get_parent().slavetabopen()
	
#ralphC - Succubus Topics
func succubustopics(mode=''):
	var text = ""
	var state = false
	var buttons = []
	
	#Intro Text
	text += str(expansion.getIntro(person)) + "\n[color=yellow]-"+ person.quirk(str(talk.introsuccubus(person)) + "[/color]")
	if person.mana_hunger > 0 && !person.vagvirgin:
		var manahungertext = ""
		if person.mana_hunger >= variables.succubushungerlevel[1] * variables.basemanafoodconsumption * variables.succubusagemod[person.age]:
			manahungertext = "[color=red]"+str(person.mana_hunger)+"[/color]"
		elif person.mana_hunger >= variables.succubushungerlevel[0] * variables.basemanafoodconsumption * variables.succubusagemod[person.age]:
			manahungertext = "[color=yellow]"+str(person.mana_hunger)+"[/color]"
		else:
			manahungertext = "[color=green]"+str(person.mana_hunger)+"[/color]"
		text += "\n\nLooking deep into $name's eyes, you can sense that $his \ncurrent hunger for mana is: " + manahungertext + "\n\n$He needs to absorb \n[color=yellow]" + str(variables.basemanafoodconsumption * variables.succubusagemod[person.age]) + "[/color] mana per day to keep $his hunger from increasing.\n"
	#The Birds and the Bees
	if !person.knowledge.has('issuccubus'):
		buttons.append({text = person.dictionary("The Birds and the Bees."), function = 'birdsandbees', args = 'start', tooltip = "Explain $his true nature to $him."})	
	#Mana Feeding Policy
	elif (person.age == 'child' && person.vagvirgin == false) || person.age != 'child':
		buttons.append({text = person.dictionary("Set min mana storage before feeding $name."), function = 'setmanafeedfloor', args = 'getmanafloor', tooltip = 'mana reserves will not be fed to $name at the end of each day if below this amount'})
	#Whoring Rules (later expansion)
	#if timeswhoredout > 1 && person.work in ['all whore types','etc']:
	#	priotitize feeding
	#	prioritize making money		
	buttons.append({text = str(globals.randomitemfromarray(['Nevermind','Go Back','Return','Cancel'])), function = '_on_talk_pressed', tooltip = "Go back to the previous screen"})
	get_tree().get_current_scene().dialogue(state, self, person.dictionary(text), buttons, updateSprites(person))
	get_tree().get_current_scene().rebuild_slave_list()
	get_parent().slavetabopen()

func birdsandbees(mode = ''):
	var text = ''
	var state = false
	var buttons = []
	if mode == "revealsuccubus":
		if person.vagvirgin && person.age == 'child':
			text += "You explain to $name that $he is a "+str(person.race_display)+", that once $he's older or loses $his virginity, $he will require mana derived from sexual energy in order to survive. "+"\n\n[color=yellow]-"+ person.quirk(str(talk.succubusrevealed1(person)) + "[/color]") 
		else:
			text += "You explain to $name that $he is a "+str(person.race_display)+" and that only mana derived from sexual energy can sustain $him. "+"\n\n[color=yellow]-"+ person.quirk(str(talk.succubusrevealed2(person)) + "[/color]") 
		person.knowledge.append('issuccubus')
	if mode == "start":
		if !person.knowledge.has('issuccubus'):
			buttons.append({text = person.dictionary("Reveal a "+str(person.race_display)+"'s true nature."), function = 'birdsandbees', args = 'revealsuccubus', tooltip = "Explain $his true nature to $him."})
		elif rand_range(0,10) > 6:
			text += "I know $master. Some day I'll grow up to be a Succuba- a Succubutts? No I mean a suck, a suck, a Succubus!"
		else:
			text += "I already understand $master. When I grow up, I'll need to make a lot of men really, really happy instead of eating."
	buttons.append({text = str(globals.randomitemfromarray(['Nevermind','Go Back','Return','Cancel'])), function = '_on_talk_pressed', tooltip = "Go back to the previous screen"})
	get_tree().get_current_scene().dialogue(state, self, person.dictionary(text), buttons, updateSprites(person))
	get_tree().get_current_scene().rebuild_slave_list()
	get_parent().slavetabopen()	

func setmanafeedfloor(mode = ''):
	var text = ''
	var state = false
	var buttons = []
	if mode == 'selection_0':
		person.manafeedpolicy = 0
		text += "Don't worry, so long as I have mana, I'll always feed you."
		text += "\n\n[color=aqua]Mana will always be shared with $name according to $his hunger.[/color]"
	if mode == 'selection_50':
		person.manafeedpolicy = 50
		text += "I'll feed you, but I have to keep some minimal reserves."
		text += "\n\n[color=aqua]50 mana will be kept in reserve even if $name is hungry.[/color]"
	if mode == 'selection_100':
		person.manafeedpolicy = 100
		text += "I'll feed you, but I have to keep some minimal reserves."
		text += "\n\n[color=aqua]100 mana will be kept in reserve even if $name is hungry.[/color]"
	if mode == 'selection_250':
		person.manafeedpolicy = 250
		text += "I'll feed you, but I have to keep some minimal reserves."
		text += "\n\n[color=aqua]250 mana will be kept in reserve even if $name is hungry.[/color]"	
	if mode == 'selection_500':
		person.manafeedpolicy = 500
		text += "I'll feed you, but I have to keep some minimal reserves."
		text += "\n\n[color=aqua]500 mana will be kept in reserve even if $name is hungry.[/color]"
	if mode == 'selection_1000':
		person.manafeedpolicy = 1000
		text += "I'll feed you, but I have to keep some minimal reserves."
		text += "\n\n[color=aqua]1,000 mana will be kept in reserve even if $name is hungry.[/color]"
	if mode == 'selection_10000':
		person.manafeedpolicy = 10000
		text += "I'll feed you, but I have to keep some minimal reserves."
		text += "\n\n[color=aqua]10,000 mana will be kept in reserve even if $name is hungry.[/color]"
	if mode == 'selection_99999':
		person.manafeedpolicy = 99999
		text += "You'll be expected to gather your own mana."
		text += "\n\n[color=aqua]Mana will not be shared with $name unless you have a tremendous stockpile.[/color]"
	if mode == 'getmanafloor':
		text += "As long as there is at least this amount of mana in reserve,\n $name will be fed at the end of each day.\n\n[color=gold]Otherwise $his only source of sustenance will be male orgasms $he absorbs during interactions, jobs, or events[/color]."
		buttons.append({text = "0 (Always try to feed)", function = 'setmanafeedfloor', args = "selection_0"})
		buttons.append({text = "50 mana", function = 'setmanafeedfloor', args = "selection_50"})
		buttons.append({text = "100 mana", function = 'setmanafeedfloor', args = "selection_100"})
		buttons.append({text = "250 mana", function = 'setmanafeedfloor', args = "selection_250"})
		buttons.append({text = "500 mana", function = 'setmanafeedfloor', args = "selection_500"})
		buttons.append({text = "1000 mana", function = 'setmanafeedfloor', args = "selection_1000"})
		buttons.append({text = "10000 mana", function = 'setmanafeedfloor', args = "selection_10000"})
		buttons.append({text = "99999 (Probably never feed)", function = 'setmanafeedfloor', args = "selection_99999"})
		#get_node("slaverename").popup()
		#get_node("slaverename/Label").set_text(person.dictionary("Enter a number between 0 and 99999."))
		#print("Ralph Test: person.manafeedpolicy == " + str(person.manafeedpolicy))
		#get_node("slaverename/LineEdit").set_text(person.manafeedpolicy)
		#pending_slave_rename = "manapolicyfloor"
	buttons.append({text = str(globals.randomitemfromarray(['Nevermind','Go Back','Return','Cancel'])), function = '_on_talk_pressed', tooltip = "Go back to the previous screen"})
	get_tree().get_current_scene().dialogue(state, self, person.dictionary(text), buttons, updateSprites(person))
	get_tree().get_current_scene().rebuild_slave_list()
	get_parent().slavetabopen()
#/ralphC

func checkEntrancement():
	var success = false
	var effect = globals.effectdict.entranced.duplicate()
	if person.effects.has(effect.code):
		success = true
	return success

func usedEntrancement():
	var text = ""
	if checkEntrancement() == true:
		person.add_effect(globals.effectdict.entranced, true)
		text = "\nYou watch as $his eyes begin to refocus and $he seems to shake $himself out of the mental fog. $His [color=aqua]entrancement[/color] seems to have worn off.\n"
	return text
