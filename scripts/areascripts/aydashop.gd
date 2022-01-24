
func gornayda():
	var text = ''
	var state = true
	var sprite = [['aydanormal', 'pos1','opac']]
	var buttons = []

	if globals.state.sidequests.ayda == 5 || (globals.state.sandbox == true && globals.state.sidequests.ayda == 3 && globals.state.sidequests.yris >= 6):
		aydafinalereturn()
	elif globals.state.mainquest < 37 || (globals.state.sandbox == true && globals.state.sidequests.ayda < 6):
		globals.main.get_node("outside").setcharacter('aydanormal')
		if globals.state.mainquest == 15 && !globals.state.sidequests.ivran in ['tobealtered','potionreceived','notaltered']:
			text = textnode.MainQuestGornAydaIvran
			state = false
			buttons = [{name = 'Accept', function = 'gornaydaivran', args = 1}, {name = 'Reject',function = 'gornaydaivran', args = 2}]
		elif globals.state.mainquest == 15 && globals.state.sidequests.ivran == 'tobealtered':
			text = "Ayda asked you to provide her with someone of high magic affinity. "
			buttons = [{name = 'Select', function = 'gornaydaselect'}]
		else:
			if globals.state.sidequests.ayda == 0:
				text = textnode.MainQuestGornAydaFirstMeet
				globals.state.sidequests.ayda = 1
				globals.charactergallery.ayda.unlocked = true
			else:
				text = textnode.GornAydaReturn
			
			buttons.append({name = "See Ayda's assortments", function = 'aydashop'})
			if globals.state.sidequests.ayda == 1:
				buttons.append({name = 'Ask Ayda about herself', function = 'gornaydatalk', args = 1})
			elif globals.state.sidequests.ayda == 2:
				buttons.append({name = 'Ask Ayda about monster races',function = 'gornaydatalk', args = 2})
	
		if globals.state.sidequests.yris == 4:
			buttons.append({name = "Ask about the found ointment", function = "gornaydatalk", args = 3})
		if state == true:
			buttons.append({name = "Leave", function = 'leaveayda'})
		globals.main.maintext = globals.player.dictionary(text)
		globals.main.get_node("outside").buildbuttons(buttons, self)
	elif globals.state.mainquest == 38:
		text = textnode.MainQuestFinaleAydaShop
		sprite = []
		globals.state.sidequests.ayda = 4
		globals.state.mainquest = 39
		globals.main.dialogue(true, self, text, buttons, sprite)
	elif globals.state.sidequests.ayda >= 6:
		text = "The bunny boy greets you as you enter."
		###---Added by Expansion---### Sprite for Assistant
		if globals.state.reputation.gorn < 10:
			sprite = [['adya_assist_nervous', 'pos1','opac']]
		else:
			sprite = [['adya_assist_neutral', 'pos1','opac']]
		###---End Expansion---###
		globals.main.maintext = globals.player.dictionary(text)
		buttons.append({name = "See shop's assortments", function = 'aydashop'})
		buttons.append({name = "Leave", function = 'leaveayda'})
		globals.main.get_node("outside").buildbuttons(buttons, self)
		if globals.state.sidequests.ayda in [7,10,13]:
			aydaquest()
			#buttons.append({name = "Ask about Ayda's preferences", function = 'aydaquest'})
		
#	elif globals.state.mainquestcomplete && globals.state.decisions.has("mainquestelves"):
#		globals.main.dialogue(true, self, text, buttons, sprite)
#		buttons.append({name = "See Shop's assortments", function = 'aydashop'})
	else:
		text = "You try to enter Ayda's shop but nobody appears to be around. "
		sprite = []
		globals.main.dialogue(true, self, text, buttons, sprite)
