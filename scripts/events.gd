
#Main Quest Finale
func mountainwin(stage = 0):
	var state = false
	var text = ''
	var buttons = []
	var sprite = []
	if stage == 0:
		globals.charactergallery.hade.unlocked = true
		if globals.state.decisions.has("mainquestelves"):
			text = textnode.MainQuestFinaleElfWin
		elif globals.state.decisions.has("mainquestslavers"):
			text = textnode.MainQuestFinaleMercWin
		buttons.append({text = "Continue", function = 'mountainwin', args = 1})
	elif stage == 1:
		text += textnode.MainQuestFinaleHadeSpeech
		sprite = [['hadeneutral','pos1','opac']]
	###---Added by Expansion---### Races Expanded
		if globals.player.race.find('Human') >= 0:
			text += '\n\n' + textnode.MainQuestFinaleHadeSpeechHuman
	###---Expansion End---###
		buttons.append({text = "Continue", function = 'mountainwin', args = 2})
	elif stage == 2:
		var counter = 0
		sprite = [['hadeneutral','pos1']]
		text += "[color=yellow]— I propose you join with us against The Old Order. You will be able to achieve greatness beyond what could ever be possible if you choose to stick to the old ways. I promise, once we reform the old fools at The Order’s main branch we can give the capable people like you far more power, real power, and not be beholden to stupid, obsolete laws.[/color]\n\n[color=#ff5df8]— I know you love power and you wish to achieve more with it. We are the same in that regard. After all, you did force all those people into servitude. "
		if globals.state.decisions.has("emilyseduced"):
			text += "You didn’t hesitate to force yourself on that orphan girl. "
			counter += 1
		if globals.state.decisions.has("tishaemilytricked"):
			counter += 2
			text += "You tricked that Tisha girl into offering herself to you and also kept her sister despite your promise. "
		elif globals.state.decisions.has("tishatricked"):
			counter += 1
			text += "You tricked that Tisha girl into offering herself to you. "
		if globals.state.decisions.has("chloebrothel"):
			counter += 1
			text += "You also broken and sold that gnome girl to brothel. "
		elif globals.state.decisions.has("chloeamnesia"):
			text += "You also brainwashed that gnome girl, for your own benefit. "
			counter += 1
		elif globals.state.decisions.has("chloeaphrodisiac"):
			text += "You also broken that gnome girl for your own amusement before enslaving her. "
			counter += 1
		if globals.state.decisions.has('tiataken'):
			text += "I remember you kidnapped that village girl, as well. "
			counter += 1
		elif globals.state.decisions.has('tiatricked'):
			text += "I remember you brainwashed that village girl into joining you, as well. "
			counter += 1
		if globals.state.decisions.has("ivrantaken"):
			text += "You went so far as to take possession of a tribal elf leader. "
			counter += 1
		if globals.state.decisions.has("calisexforced"):
			text += "You even forced that wolf girl to sleep with a stranger just to save you some cash. "
			counter += 1
		text += "[/color]"
		
		globals.state.mainquest = 40
		
		if counter >= 3:
			text += '\n\n' + textnode.MainQuestFinaleHadeSpeechAdditional
		buttons.append({text = "Refuse", function = 'mountainwin', args = 4})
		buttons.append({text = "Join Hade", function = 'mountainwin', args = 3})
	elif stage == 3:
		state = true
		globals.state.decisions.append('badroute')
		sprite = [['hadesmile','pos1']]
		text = textnode.MainQuestFinaleBadAccept
		globals.main.exploration.zoneenter('mountaincave')
	elif stage == 4:
		state = true
		globals.state.decisions.append('goodroute')
		sprite = [['hadeangry','pos1']]
		text = textnode.MainQuestFinaleGoodChoice
		globals.main.exploration.zoneenter('mountaincave')
		
	globals.main.dialogue(state, self, text, buttons, sprite)

func chloeforest(stage = 0):
	var text = ''
	var state = false
	var sprite = [['chloehappy', 'pos1']]
	var buttons = []
	if stage == 0:
		sprite = [['chloeneutral', 'pos1', 'opac']]
		if globals.state.sidequests.chloe == 1:
			chloeforest(3)
			return
		else:
			var havegnomemember = false
			for i in globals.state.playergroup:
				var person = globals.state.findslave(i)
				###---Added by Expansion---### Races Expanded
				if person.race.find('Gnome') >= 0:
					havegnomemember = true
				###---End Expansion---###
			if havegnomemember == false:
				text = textnode.ChloeEncounter
				if globals.spelldict.sedation.learned == true && globals.spells.spellcost(globals.spelldict.sedation) <= globals.resources.mana:
					buttons.append({text = 'Cast Sedation',function = 'chloeforest',args = 1, disabled = false})
				elif globals.spelldict.sedation.learned == true:
					buttons.append({text = 'Cast Sedation',function = 'chloeforest',args = 1, disabled = true, tooltip = 'Not enough mana'})
				else:
					buttons.append({text = "You have no other available options yet",function = 'chloeforest',args = 1, disabled = true})
			else:
				text = textnode.ChloeEncounterGnome
				buttons.append({text = 'Talk with her',function = 'chloeforest',args = 2, disabled = false})
			buttons.append({text = 'Leave her alone',function = 'chloeforest',args = 6})
	
	
	
	elif stage == 1:
		globals.resources.mana -= globals.spells.spellcost(globals.spelldict.sedation)
		text = textnode.ChloeSedate + textnode.ChloeEncounterTalk
		globals.state.sidequests.chloe = 1
		buttons.append({text = 'Lead her to the Shaliq',function = 'chloeforest',args = 4})
		buttons.append({text = "Tell her you can't help",function = 'chloeforest',args = 5})
	elif stage == 2:
		text = textnode.ChloeEncounterTalk
		globals.state.sidequests.chloe = 1
		buttons.append({text = 'Lead her to the Shaliq',function = 'chloeforest',args = 4})
		buttons.append({text = "Tell her you can't help",function = 'chloeforest',args = 5})
	elif stage == 3:
		text = textnode.ChloeEncounterRepeat
		buttons.append({text = 'Lead her to the Shaliq',function = 'chloeforest',args = 4})
		buttons.append({text = "Tell her you can't help",function = 'chloeforest',args = 5})
	elif stage == 4:
		text = textnode.ChloeEncounterHelp
		buttons.append({text = 'Proceed to Shaliq with Chloe',function = 'chloeforest',args = 7})
	elif stage == 5:
		text = textnode.ChloeEncounterRefuse
		buttons.append({text = 'Continue',function = 'chloeforest',args = 6})
	elif stage == 6:
		globals.main.exploration.zoneenter('forest')
		closedialogue()
		return
	elif stage == 7:
		text = textnode.ChloeShaliq
		globals.state.sidequests.chloe = 2
		globals.main.exploration.progress = 0
		globals.main.exploration.zoneenter('shaliq')
		yield(globals.main, 'animfinished')
		buttons.append({text = 'Leave',function = 'chloevillage',args = 0})
	globals.main.dialogue(state,self,text,buttons,sprite)
