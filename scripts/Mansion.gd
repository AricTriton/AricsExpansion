
###---Added by Expansion---### Deviate
var corejobs = ['rest','forage','hunt','cooking','library','nurse','maid','storewimborn','artistwimborn','assistwimborn','whorewimborn','escortwimborn','fucktoywimborn', 'lumberer', 'ffprostitution','guardian', 'research', 'slavecatcher','fucktoy','housepet','trainer','crystalresearcher']
var manaeaters = ['Succubus','Golem'] #ralphC - used in food consumption calcs, etc.
###---End Expansion---###
var outOfMansionJobs = ['storewimborn','artistwimborn','assistwimborn','whorewimborn','escortwimborn','fucktoywimborn', 'lumberer', 'ffprostitution','guardian', 'research', 'slavecatcher','fucktoy'] # /Capitulize - Jobs outside of the mansion.

func _ready():
	###---Added by Expansion---### Minor Tweaks by Dabros Mod Integration
		## CHANGED - 5/6/19 - create button here for slave-stats-export
	var exportSlaveStats = $MainScreen/mansion/selfinspect/spellbook.duplicate()
	exportSlaveStats.text = "Export Stats"
	exportSlaveStats.disconnect("pressed", self, '_on_spellbook_pressed')
	exportSlaveStats.connect("pressed", self, 'doExportSlaveStats')
	exportSlaveStats.margin_left += 150
	exportSlaveStats.margin_right += 150
	$MainScreen/mansion/selfinspect.add_child(exportSlaveStats)
		## END OF CHANGED
	###---End Expansion---###
	get_node("music").set_meta('currentsong', 'none')
	if OS.get_executable_path() == 'C:\\Users\\1\\Desktop\\godot\\Godot_v3.2.1-stable_win64.exe':
		globals.developmode = true
		debug = true
		get_node("startcombat").show()
		get_node("new slave button").show()
		get_node("debug").show()
	if !globals.state.tutorialcomplete:
		rebuildrepeatablequests()
	globals.main = self
	globals.items.main = self
	globals.mainscreen = 'mansion'
	globals.resources.panel = get_node("ResourcePanel")
	globals.events.textnode = globals.questtext
	if debug == true && globals.player.unique != 'player':
		globals.player.name = ''
		globals.player = globals.newslave('Human', 'teen', 'male')
		globals.player.ability.append('escape')
		globals.player.ability.append('heal')
		globals.player.abilityactive.append('escape')
		globals.player.abilityactive.append('mindread')
		globals.state.supporter = true
		for i in globals.gallery.charactergallery.values():
			i.unlocked = true
			i.nakedunlocked = true
			for k in i.scenes:
				k.unlocked = true
		_on_new_slave_button_pressed()
	rebuild_slave_list()
	globals.player.consent = true
	globals.spells.main = get_tree().get_current_scene()
	###---Added by Expansion---### Altered Birth Panel
	get_node("birthpanel/childpanel/child").connect('pressed', self, 'babyage', ['child'])
	get_node("birthpanel/childpanel/teen").connect('pressed', self, 'babyage', ['teen'])
	get_node("birthpanel/childpanel/adult").connect('pressed', self, 'babyage', ['adult'])
	###---End Expansion---###
	#exploration
	get_node("explorationnode").buttoncontainer = get_node("outside/buttonpanel/outsidebuttoncontainer")
	get_node("explorationnode").button = get_node("outside/buttonpanel/outsidebuttoncontainer/buttontemplate")
	get_node("explorationnode").main = self
	get_node("explorationnode").outside = get_node('outside')
	globals.events.outside = get_node("outside")
	globals.resources.update()
	
	get_tree().get_root().connect('size_changed',self,'on_resize_screen')
	for i in get_tree().get_nodes_in_group("invcategories"):
		i.connect("pressed",self,"selectcategory",[i])
	
	for i in get_tree().get_nodes_in_group("mansionbuttons"):
		i.connect("pressed",self,i.get_name())
	
	for i in get_tree().get_nodes_in_group("spellbookcategory"):
		i.connect("pressed",self,'spellbookcategory',[i])
	
	if globals.state.tutorialcomplete == false && globals.resources.day == 1:
		get_node("tutorialnode").starttutorial()
		globals.state.tutorialcomplete = true
	
	globals.state.setupracemarketsat() #ralph5
	if globals.showalisegreet == true:
		alisegreet()
	elif globals.gameloaded == true:
		infotext("Game Loaded.",'green')
		globals.gameloaded = false
	
	for i in ['sstr','sagi','smaf','send']:
		get(i).get_node('Control').connect('mouse_entered', self, 'stattooltip',[i])
		get(i).get_node('Control').connect('mouse_exited', globals, 'hidetooltip')
		get(i).get_node('Button').connect("pressed",self,'statup', [i])
	
	$MainScreen/mansion/selfinspect/relativespanel/relativestext.connect("meta_hover_started",self,'relativeshover')
	$MainScreen/mansion/selfinspect/relativespanel/relativestext.connect("meta_hover_ended",globals, 'slavetooltiphide')
	$MainScreen/mansion/selfinspect/relativespanel/relativestext.connect("meta_clicked",self, "relativesselected")
	
	$MainScreen/mansion/mansioninfo.connect("meta_hover_started",self,'slavehover')
	$MainScreen/mansion/mansioninfo.connect("meta_hover_ended",globals, 'slavetooltiphide')
	$MainScreen/mansion/mansioninfo.connect("meta_clicked",self, "slaveclicked")
	
	$outside/textpanel/outsidetextbox.connect("meta_hover_started",self,'slavehover')
	$outside/textpanelexplore/outsidetextbox2.connect("meta_hover_started",self,'slavehover')
	$outside/textpanel/outsidetextbox.connect("meta_hover_ended",globals, 'slavetooltiphide')
	$outside/textpanelexplore/outsidetextbox2.connect("meta_hover_ended",globals, 'slavetooltiphide')
	
	$MainScreen/mansion/selfinspect/Contraception.connect("pressed", self, 'contraceptiontoggle')
	
	if variables.oldemily == true:
		for i in ["emilyhappy", "emilynormal","emily2normal","emily2happy","emily2worried","emilynakedhappy","emilynakedneutral"]:
			globals.spritedict[i] = globals.spritedict['old'+ i]
		globals.characters.characters.Emily.imageportait = "res://files/images/emily/oldemilyportrait.png"
	
	
	for i in [$sexselect/managerypanel/dogplus, $sexselect/managerypanel/dogminus, $sexselect/managerypanel/horseplus, $sexselect/managerypanel/horseminus]:
		i.connect("pressed", self, 'animalforsex', [i])
	###---Added by Expansion---###
	prepareFarmOptionButtons()
	###---End Expansion---###
	get_node("FinishDayPanel/alise").hide()
	get_node("FinishDayPanel/FinishDayScreen/Global Report").set_bbcode(globals.state.daily_reports.global)
	get_node("FinishDayPanel/FinishDayScreen/Job Report").set_bbcode(globals.state.daily_reports.job)
	get_node("FinishDayPanel/FinishDayScreen/Secondary Report").set_bbcode(globals.state.daily_reports.secondary)
	get_node("FinishDayPanel/FinishDayScreen/Farm Report").set_bbcode(globals.state.daily_reports.farm)
	if get_node("FinishDayPanel/FinishDayScreen/Global Report").get_bbcode().empty():
		get_node("Navigation/endlog").disabled = true
	_on_mansion_pressed()
	#startending()

var awayReturnText = {
	'travel back': 'returned to the mansion and went back to $his duties.',
	'transported back': 'transported back to the mansion and went back to $his duties.',
	'in labor': 'recovered from labor and went back to $his duties.',
	'training': 'completed $his training and went back to $his duties.',
	'nurture': 'has finished being nurtured and went back to $his duties.',
	'growing': 'has matured and is now ready to serve you.',
	'lab': 'successfully recovered from laboratory modification and went back to $his duties.',
	'rest': 'finished resting and went back to $his duties.',
	'vacation': 'returned from vacation and went back to $his duties.',
	'default': 'returned to the mansion and went back to $his duties.',
}

func rebuild_slave_list():
	var personList = get_node("charlistcontrol/CharList/scroll_list/slave_list")
	var categoryButtons = [personList.get_node("mansionCategory"), personList.get_node("prisonCategory"), personList.get_node("farmCategory"), personList.get_node("awayCategory")]
	var awayLabel = personList.get_node('awayLabel')
	var nodeIndex = 0
	var isSlaveAway = false
	
	for catIdx in range(3):
		personList.move_child( categoryButtons[catIdx], nodeIndex)
		nodeIndex += 1
		
		var startIndex = nodeIndex
		for person in globals.slaves:
			if person.away.duration != 0:
				if person.away.at != 'hidden':
					isSlaveAway = true
				continue
			if catIdx == 0:
				if person.sleep == 'jail' || person.sleep == 'farm':
					continue
			elif catIdx == 1:
				if person.sleep != 'jail':
					continue
			elif catIdx == 2:
				if person.sleep != 'farm':
					continue
			
			###---Added by Expansion---### Person Expanded; Strip/Redress
			person.updateClothing()
			###---End Expansion---###
			
			if nodeIndex < personList.get_children().size() - (3 - catIdx):
				if personList.get_children()[nodeIndex].has_meta('id') && personList.get_children()[nodeIndex].get_meta('id') == person.id:
					updateSlaveListNode(personList.get_children()[nodeIndex], person, categoryButtons[catIdx].pressed)
				else: #search for correct node
					var notFound = true
					for searchIndex in range(nodeIndex, personList.get_children().size()):
						var searchNode = personList.get_children()[searchIndex]
						if searchNode.has_meta('id') && searchNode.get_meta('id') == person.id:
							personList.move_child( searchNode, nodeIndex)
							updateSlaveListNode(searchNode, person, categoryButtons[catIdx].pressed)
							notFound = false
							break
					if notFound:
						createSlaveListNode(personList, person, nodeIndex, categoryButtons[catIdx].pressed)
			else:
				createSlaveListNode(personList, person, nodeIndex, categoryButtons[catIdx].pressed)
			nodeIndex += 1
		categoryButtons[catIdx].visible = (startIndex != nodeIndex)

	personList.move_child( categoryButtons[3], nodeIndex)
	categoryButtons[3].visible = isSlaveAway
	nodeIndex += 1
	personList.move_child( awayLabel, nodeIndex)
	awayLabel.visible = isSlaveAway && categoryButtons[3].pressed
	nodeIndex += 1

	if isSlaveAway && categoryButtons[3].pressed:
		var text = ''
		for person in globals.slaves:
			if person.away.duration != 0 && person.away.at != 'hidden':
				text += "%s[color=aqua]%s[/color] %s[color=yellow]%s day%s[/color]." % ['' if text.empty() else '\n', person.name_long(), awayText.get(person.away.at, awayText.default), person.away.duration, 's' if (person.away.duration > 1) else '']
		awayLabel.bbcode_text = text
		call_deferred("fixAwayLabel", awayLabel)

	for clearIndex in range(nodeIndex, personList.get_children().size()):
		var clearNode = personList.get_children()[clearIndex]
		if clearNode.has_meta('id'):
			clearNode.hide()
			clearNode.queue_free()
	
	get_node("charlistcontrol/CharList/res_number").set_bbcode('[center]Residents: ' + str(globals.slavecount()) +'[/center]')
	get_node("ResourcePanel/population").set_text(str(globals.slavecount()))
	###---Added by Expansion---### Interactions Remaining
	get_node("charlistcontrol/interactionbutton").set_text(str(globals.state.nonsexactions)+" | "+str(globals.state.sexactions))
	get_node("charlistcontrol/interactionbutton").set_disabled(globals.state.sexactions < 1 && globals.state.nonsexactions < 1)
	###---End Expansion---###
	_on_orderbutton_pressed()

func _input(event):
	###---Added by Expansion---### Minor Tweaks by Dabros Integration
	## CHANGED NEW - 26/5/19 - for allowing prev/next keys for slave selection
	if event.is_action_pressed("ui_page_up") && get_node("charlistcontrol/CharList/scroll_list/slave_list").is_visible_in_tree():
		my_gotoslave_mansion_prev()
	if event.is_action_pressed("ui_page_down") && get_node("charlistcontrol/CharList/scroll_list/slave_list").is_visible_in_tree(): ## charlistcontrol/slavelist
		my_gotoslave_mansion_next()
	## END OF CHANGED
	###---End Expansion---###
	var anythingvisible = false
	for i in get_tree().get_nodes_in_group("blockmaininput"):
		if i.is_visible_in_tree() == true:
			anythingvisible = true
			break
	if event.is_echo() == true || event.is_pressed() == false || anythingvisible:
		if event.is_action_pressed("escape") == true && get_node("tutorialnode").visible == true:
			get_node("tutorialnode").close()
		return
	if event.is_action_pressed("escape") == true && $ResourcePanel/menu.visible == true && $ResourcePanel/menu.disabled == false:
		if get_node("FinishDayPanel").is_visible_in_tree():
			get_node("FinishDayPanel").hide()
			return
		if !get_node("menucontrol").is_visible_in_tree():
			_on_menu_pressed()
		else:
			if get_node("menucontrol/menupanel/SavePanel").is_visible_in_tree():
				get_node("menucontrol/menupanel/SavePanel").hide()
			_on_closemenu_pressed()
	
	if get_focus_owner() == get_node("MainScreen/mansion/selfinspect/defaultMasterNoun") && get_node("MainScreen").is_visible_in_tree():
		return
	if event.is_action_pressed("F") && get_node("Navigation/end").is_visible_in_tree():
		_on_end_pressed()
	elif event.is_action_pressed("Q") && get_node("MainScreen").is_visible_in_tree():
		mansion()
	elif event.is_action_pressed("W") && get_node("MainScreen").is_visible_in_tree():
		jail()
	elif event.is_action_pressed("E") && get_node("MainScreen").is_visible_in_tree():
		libraryopen()
	elif event.is_action_pressed("A") && get_node("MainScreen").is_visible_in_tree() && !get_node("Navigation/alchemy").is_disabled():
		alchemy()
	elif event.is_action_pressed("S") && get_node("MainScreen").is_visible_in_tree() && !get_node("Navigation/laboratory").is_disabled():
		laboratory()
	elif event.is_action_pressed("Z") && get_node("MainScreen").is_visible_in_tree() && !get_node("Navigation/farm").is_disabled():
		farm()
	elif event.is_action_pressed("X") && get_node("MainScreen").is_visible_in_tree() && !$MainScreen/mansion/portals.is_disabled():
		portals()
	elif event.is_action_pressed("C") && get_node("MainScreen").is_visible_in_tree():
		leave()
	elif event.is_action_pressed("B") && get_node("MainScreen").is_visible_in_tree():
		_on_inventory_pressed()
	elif event.is_action_pressed("R") && get_node("MainScreen").is_visible_in_tree():
		_on_personal_pressed()
	elif event.is_action_pressed("V") && get_node("MainScreen").is_visible_in_tree():
		_on_combatgroup_pressed()
	elif event.is_action_pressed("L") && get_node("MainScreen").is_visible_in_tree():
		_on_questlog_pressed()

###---Added by Expansion---### Minor Tweaks by Dabros Integration
func my_gotoslave_mansion_prev():
	## CHANGED NEW - 28/5/19 - for allowing prev/next keys for slave selection in mansion slave panel on right
	## NOTE - current_slave is index position (defaults at 0), globals.current_slave is an object reference (which may or may not be valid)
	##		- so sanity check is for whether youve selected a slave at all yet
	if globals.slaves.size() < 1:
		return
	if !currentslave && (!globals.currentslave || !('id' in globals.currentslave)):
		openslave(globals.slaves[0])
		return
	else:
		var prevslave
		## DEBUG
		#### var debug_text = ''
		#### var debug_rows = []
		## END DEBUG
		for i in get_node("charlistcontrol/CharList/scroll_list/slave_list").get_children():
			## DEBUG
			#### debug_rows.append({
			#### 'i': i
			#### ,'i.get_meta(\'id\')': (str(i.get_meta('id')) if i.has_meta('id') else '-error-')
			#### ,'currentslave': currentslave
			#### ,'globals.currentslave': (globals.currentslave if globals.currentslave else '-empty-')
			#### ,'globals.currentslave.id': (globals.currentslave.id if globals.currentslave && "id" in globals.currentslave else '-empty-')
			#### ,'prevslave': (prevslave if prevslave else '-empty-')
			#### ,'prevslave.id': (prevslave.id if prevslave && "id" in prevslave else '-empty-')
			#### ,'globals.slaves[currentslave]': (globals.slaves[currentslave] if globals.slaves[currentslave] else '-error-')
			#### ,'globals.state.findslave(i.get_meta(\'id\'))': (globals.state.findslave(i.get_meta('id')) if globals.state.findslave(i.get_meta('id')) else '-error-')
			#### ,'globals.state.findslave(i.get_meta(\'id\')).id': (globals.state.findslave(i.get_meta('id')).id if globals.state.findslave(i.get_meta('id')) && "id" in globals.state.findslave(#### globals.currentslave.id) else '-error-')
			#### })
			## END DEBUG
			if i.has_meta('id') && globals.currentslave && i.get_meta('id') == globals.currentslave.id:
				if prevslave && prevslave.has_meta('id'):
					openslave(globals.state.findslave(prevslave.get_meta('id')))
					return
			prevslave = i
		## DEBUG
		#### debug_text += to_json(debug_rows)
		#### OS.set_clipboard(debug_text)
		#### get_tree().get_current_scene().infotext('copied debug to clipboard','orange')
		## END DEBUG
	## END OF CHANGED

func my_gotoslave_mansion_next():
	## CHANGED NEW - 28/5/19 - for allowing prev/next keys for slave selection in mansion slave panel on right
	if globals.slaves.size() < 1:
		return
	if !currentslave && (!globals.currentslave || !('id' in globals.currentslave)):
		openslave(globals.slaves[0])
		return
	else:
		var found = false
		for i in get_node("charlistcontrol/CharList/scroll_list/slave_list").get_children():
			if found && i.has_meta('id'):
				openslave(globals.state.findslave(i.get_meta('id')))
				return
			elif i.has_meta('id') && globals.currentslave && i.get_meta('id') == globals.currentslave.id:
				found = true
	## END OF CHANGED

func doExportSlaveStats():
	#TBK - Needs to have Stats Updated to Current Person
	## CHANGED NEW - 24/05/19 - export function for slave stats
	var text = ''

	# var slaves = [] setget slaves_set
	var dict = {}
	dict.slaves = []
	##dict.babylist = []
	##for i in globals.state.babylist:
	##dict.babylist.append(inst2dict(i))
	##dict.player = inst2dict(globals.player) 
	# NOTE - define here so we can optionally print header column
	var tmpkeys = []
	var pos = 0
	for i in globals.slaves:
		pos += 1
		var pname = ''
		if(i.nickname):
			pname += "\""+i.nickname+"\" "
		pname += i.name
		if(i.surname):
			pname += " "+i.surname
		##pname = pname.substr(0,20)
		var numrules = 0
		for value in i.rules.values():
			if(value):
				numrules += 1
		##dict.slaves.append(inst2dict(i))
		##var text = ''
		##text += temp+"\t"
		##var prettyvars = {
		var temp = {
		'pos': pos
		,'stub':str("{name} -{beauty} {sex}{age} {race} {origins} -{sstr}{sagi}{smaf}{send}{cour}{conf}{wit}{charm} -{sp}{spec} {traits}").format({'name':"%-15s"%pname.substr(0,15),'sex':i.sex.substr(0,2).capitalize(),'age':i.age.substr(0,1).capitalize(),'race':"%-5s"%i.race.replacen('halfkin ','H-').replacen('beastkin ','B-').replacen('dark ','D-').substr(0,5),'origins':i.origins.substr(0,1),'spec':' spec-'+i.spec.substr(0,5).to_upper() if i.spec else '','traits':PoolStringArray(i.traits).join("_").replacen(" ","-").replacen("_"," "),'beauty':"%3d"%i.beauty,'sstr':"%3d"%i.sstr,'sagi':"%3d"%i.sagi,'smaf':"%3d"%i.smaf,'send':"%3d"%i.send,'cour':"%3d"%i.cour,'conf':"%3d"%i.conf,'wit':"%3d"%i.wit,'charm':"%3d"%i.charm,'sp':' +'+str(i.skillpoints)+'free' if i.skillpoints else ''})
		,'name':pname
		,'namef':"'"+pname ## str("{name}").format({'name':"%s"%pname})
		,'sex':i.sex.substr(0,2).capitalize() ##((i.sex=='futa')?'x':i.sex.substr(0,1))
		,'age':i.age.substr(0,1).capitalize()
		,'race':i.race.replacen('halfkin ','H-').replacen('beastkin ','B-').replacen('dark ','D-').substr(0,10)
		,'origins':i.origins.substr(0,1) if (i.origins != 'poor' && i.origins != 'slave') else ' '
		,'beauty':i.beauty
		,'stats1':str("{sstr} {sagi} {smaf} {send} {cour} {conf} {wit} {charm}").format({'sstr':"%3d"%i.sstr,'sagi':"%3d"%i.sagi,'smaf':"%3d"%i.smaf,'send':"%3d"%i.send,'cour':"%3d"%i.cour,'conf':"%3d"%i.conf,'wit':"%3d"%i.wit,'charm':"%3d"%i.charm})
		,'stats2':str("{sstr} {sagi} {smaf} {send}").format({'sstr':"%3d"%i.sstr,'sagi':"%3d"%i.sagi,'smaf':"%3d"%i.smaf,'send':"%3d"%i.send})
		,'stats3':str("{cour} {conf} {wit} {charm}").format({'cour':"%3d"%i.cour,'conf':"%3d"%i.conf,'wit':"%3d"%i.wit,'charm':"%3d"%i.charm})
		,'str':i.sstr
		,'agi':i.sagi
		,'mag':i.smaf
		,'end':i.send
		,'cour':i.cour
		,'conf':i.conf
		,'wit':i.wit
		,'charm':i.charm
		,'spec':i.spec.substr(0,4) if i.spec else ''
		,'specialisation':i.spec if i.spec else ''
		,'obd':int(round(i.obed))
		,'lp':i.learningpoints if i.learningpoints else ''
		,'sp':i.skillpoints if i.skillpoints else ''
		,'traits':to_json(i.traits) # NOTE - to_json for nested now we using csv approach
		,'rules':numrules if numrules else ''
		,'work':i.work
		,'preg':i.preg.duration if i.preg.duration else ''
		,'fert': int(round(i.preg.fertility)) if i.preg.has_womb else ''
		,'stress':int(round(i.stress))
		,'loyal':int(round(i.loyal))
		,'fear':int(round(i.fear))
		,'lewd':int(round(i.lewdness))
		,'energy':int(round(i.energy))
		,'level':i.level
		,'consent':'y' if i.consent else ''
		,'lactation':1 if i.lactation else ''
		,'lust':int(round(i.lust))
		## ,'naked':1 if i.naked else '' ## Aricsmod
		,'xp':i.xp
		}

		##dict.slaves.append(temp)
		tmpkeys = temp.keys();
		for tmpkey in tmpkeys: 
		   text += str(temp[tmpkey])+"\t";
		text += "\n"
	# NOTE - print header row
	var toprow = ''
	for tmpkey in tmpkeys: 
		toprow += tmpkey+"\t";
	text = toprow+"\n"+text
	##text = to_json(dict)
	##text = to_json(person)

	OS.set_clipboard(text)

	get_tree().get_current_scene().infotext("Stats for ALL slaves copied to clipboard",'green')

	## END OF CHANGED
###---End Expansion---###

func _on_end_pressed():
	if globals.state.mainquest == 41:
		popup("You can't afford to wait. You must go to the Mage's Order.")
		return
	enddayprocess = true


	var text = ''
	var temp = ''
	var poorcondition = false
#	var person
	var count
	var chef
	var jailer
	var headgirl
	var labassist
	var farmmanager
	var workdict
	var text0 = get_node("FinishDayPanel/FinishDayScreen/Global Report")
	var text1 = get_node("FinishDayPanel/FinishDayScreen/Job Report")
	var text2 = get_node("FinishDayPanel/FinishDayScreen/Secondary Report")
	###---Added by Expansion---### Separated Farm Report
	var text3 = get_node("FinishDayPanel/FinishDayScreen/Farm Report")
	###---End Expansion---###
	var start_gold = globals.resources.gold
	var start_food = globals.resources.food
	var start_mana = globals.resources.mana
	###---Added by Expansion---### Added Resource Types: Milk Bottles, Cum Bottles, Piss Bottles
	var start_milk_bottle = globals.resources.milk
	var start_semen_bottle = globals.resources.semen
	var start_lube_bottle = globals.resources.lube
	var start_piss_bottle = globals.resources.piss
	var escaped_array = []
	###---Expansion End---###
	var deads_array = []
	var gold_consumption = 0
	var lacksupply = false
	var results = 'normal'
	_on_mansion_pressed()
	#if OS.get_name() != 'HTML5':
	yield(self, 'animfinished')
	for i in range(globals.slaves.size()):
		if globals.slaves[i].away.duration == 0:
			if globals.slaves[i].work == 'cooking':
				chef = globals.slaves[i]
			elif globals.slaves[i].work == 'jailer':
				jailer = globals.slaves[i]
			elif globals.slaves[i].work == 'headgirl':
				headgirl = globals.slaves[i]
			elif globals.slaves[i].work == 'labassist':
				labassist = globals.slaves[i]
			elif globals.slaves[i].work == 'farmmanager':
				farmmanager = globals.slaves[i]

	###---Added by Expansion---### Events
	#Events
	if globals.resources.day >= 2 && globals.state.sidequests.dimcrystal == 0:
		globals.state.upcomingevents.append({code = 'dimcrystalinitiate', duration = 0})
	###---End Expansion---###
	
	globals.resources.day += 1
	text0.set_bbcode('')
	text1.set_bbcode('')
	text2.set_bbcode('')
	count = 0

#	if globals.player.preg.duration >= 1:
#		globals.player.preg.duration += 1
#		if globals.player.preg.duration == floor(globals.state.pregduration/6):
#			text0.set_bbcode(text0.get_bbcode() + "[color=yellow]You feel morning sickness. It seems you are pregnant. [/color]\n")

	###---Added by Expansion---### Update Player, Towns, and People
	var temptext
	text = "" if text0.get_bbcode().empty() else "\n"
	#---NPCs Expanded
	globals.expansion.dailyNPCs()
	#---Towns Expanded
	temptext = globals.expansion.dailyTownEvents()
	if temptext != null:
		text += temptext
	temptext = globals.expansion.dailyTownGuard()
	if temptext != null:
		text += temptext
	#Player
	temptext = globals.expansion.dailyUpdate(globals.player)
	if temptext != null:
		text += temptext + "\n\n"
	#slaves
	if !text.empty():
		text0.set_bbcode(text0.get_bbcode() + text + "")
	###---End Expansion---###

	###---Added by Expansion---### Category: Daily Update | Management First | Spacing
	var first_slave_processed = true
	###---Expansion End---###

	for person in globals.slaves:
		if person.away.duration == 0:
			if person.bodyshape == 'shortstack':
				globals.state.condition = -0.65
			###---Added by Expansion---### Hybrid Support
			elif person.findRace(['Lamia','Arachna','Centaur', 'Harpy', 'Scylla']):
				globals.state.condition = -1.8
			###---End Expansion---###
			elif person.race.find('Beastkin') >= 0:
				globals.state.condition = -1.3
			else:
				globals.state.condition = -1.0
	
	for person in globals.slaves:
		person.metrics.ownership += 1
		var handcuffs = false
		for i in person.gear.values():
			if i != null && globals.state.unstackables.has(i):
				var tempitem = globals.state.unstackables[i]
				if tempitem.code in ['acchandcuffs']:
					handcuffs = true
		text = ''

		###---Added by Expansion---### Update Player, Towns, and People
		if first_slave_processed == true:
			first_slave_processed = false
		else:
			text += "\n"
		text += globals.expansion.dailyUpdate(person) + "\n"
		###---End Expansion---###
	
		var jobRestore = person.work
		var slavehealing = person.send * 0.03 + 0.02
		if person.away.duration == 0: ## Sequence for all present slaves

			for i in person.relations:
				if person.relations[i] > 500:
					person.relations[i] -= 15
				elif person.relations[i] < -500:
					person.relations[i] += 15

			if person.sleep != 'jail' && person.sleep != 'farm':
				if person.work in corejobs:

					if person.work != 'rest' && person.energy < 30:
						person.work = 'rest'

					for i in globals.slaves:
						if i.away.duration == 0 && i.work == person.work && i != person:
							globals.addrelations(person, i, 0)
							if randf() < 0.25 + abs(person.relations[i.id])/2000:
								var badchance = 0
								if person.relations[i.id] > 600:
									badchance = 15
								elif person.relations[i.id] > 0:
									badchance = 33
								elif person.relations[i.id] > -200:
									badchance = 55
								elif person.relations[i.id] > -500:
									badchance = 70
								else:
									badchance = 80
								if randf() * 100 < badchance:
									globals.addrelations(person, i, -rand_range(25,50))
									text2.bbcode_text += person.dictionary("[color=yellow]$name has gotten into a minor quarrel with ") + i.dictionary('$name.[/color]\n')
								else:
									globals.addrelations(person, i, rand_range(25,50))
									temptext = ''
									if person.work == 'rest':
										temptext = person.dictionary("[color=yellow]$name has been resting together with ") + i.dictionary('$name and their relationship improved.[/color]\n')
									else:
										temptext = person.dictionary("[color=yellow]$name has been working together with ") + i.dictionary('$name and their relationship improved.[/color]\n')
									text2.bbcode_text += temptext
								#Calculate relations

#							if person.relations[i.id] < 0 || i.relations[person.id] < -200:
#								globals.addrelations(person, i, (rand_range(-10,-20)))
#							else:
#								globals.addrelations(person, i, (rand_range(10,20)))

					if person.work == 'rest':
						if jobRestore != 'rest':
						###---Added by Expansion---### Added Event
							text += "$name almost collapsed from exhaustion and was forced to rest instead of work today. \n"
							person.dailyevents.append('exhaustion')
						else:
							text += '$name has spent most of the day relaxing.\n'
						###---End Expansion---###
						slavehealing += 0.15
						person.stress -= 20
					else:
						#---Add Job Skills, ETC
						workdict = globals.jobs.call(person.work, person)
						if workdict.has('dead') && workdict.dead == true:
							deads_array.append({number = count, reason = workdict.text})
							continue
						if person.traits.has("Clumsy") && get_node("MainScreen/slave_tab").jobdict[person.work].tags.has("physical"):
							if workdict.has('gold') && workdict.gold > 0:
								workdict.gold *= 0.7
							if workdict.has('food'):
								workdict.food *= 0.7
						if person.traits.has("Hard Worker") && !get_node("MainScreen/slave_tab").jobdict[person.work].tags.has("sex"):
							if workdict.has('gold') && workdict.gold > 0:
								workdict.gold *= 1.15
						for i in globals.state.reputation:
							if get_node("MainScreen/slave_tab").jobdict[person.work].tags.find(i) >= 0:
								if globals.state.reputation[i] < -10 && randf() < 0.33:
									person.obed -= max(abs(globals.state.reputation[i])*2 - person.loyal/6,0)
									person.loyal -= rand_range(1,3)
									text += "[color=#ff4949]$name has been influenced by local townfolk, which are hostile towards you. [/color]\n"
								elif globals.state.reputation[i] > 10 && randf() < 0.2:
									person.obed += abs(globals.state.reputation[i])
									person.loyal += rand_range(1,3)
									text += "[color=green]$name has been influenced by local townfolk, which are loyal towards you. [/color]\n"
						text += workdict.text
						###---Added by Expansion---### Ank BugFix v4a
						if person.spec == 'housekeeper' && person.work in ['cooking','library','nurse','maid']:
							globals.state.condition = (5.5 + max(0, person.sagi+person.send)*6)/2
							text2.bbcode_text += person.dictionary("$name has managed to clean the mansion a bit while being around. \n")
						###---End Expansion---###
						if workdict.has("gold"):
							globals.resources.gold += workdict.gold
							if workdict.gold > 0:
								person.metrics.goldearn += workdict.gold
						if workdict.has("food"):
							globals.resources.food += workdict.food
							person.metrics.foodearn += workdict.food
						if (outOfMansionJobs.has(person.work) && person.race.find('Gnoll') >= 0):
							var gnolldict = globals.jobs.call('gnollhunt', person)
							text += gnolldict.text
							globals.resources.food += gnolldict.food
							person.metrics.foodearn += gnolldict.food
			text1.set_bbcode(text1.get_bbcode()+person.dictionary(text))
			######## Counting food
			for i in person.effects.values():
				if i.has('duration') && i.code != 'captured':
					###---Added by Expansion---### Hybrid Support && Ank BugFix v4
					if person.race.find('Tribal Elf') < 0 || i.code in ['bandaged','sedated', 'drunk'] || randf() > 0.5:
						i.duration -= 1
					###---End Expansion---###
					if i.duration <= 0:
						person.add_effect(i, true)
				elif i.code == 'captured':
					i.duration -= 1
					###---Added by Expansion---### Modified: Jail Incenses >= instead of == to allow modification of that Mansion Upgrade
					if person.sleep == 'jail' && globals.state.mansionupgrades.jailincenses >= 1 && randf() >= 0.5:
					###---Expansion End---###
						i.duration -= 1
					if person.brand != 'none':
						i.duration -= 1
					if i.duration <= 0:
						if i.code == 'captured':
							###---Added by Expansion---### Colorized
							text0.set_bbcode(text0.get_bbcode() + person.dictionary('[color=aqua]$name[/color][color=yellow] grew accustomed to your ownership.[/color]\n'))
							###---Expansion End---###
						person.add_effect(i, true)
				if i.has("ondayend"):
					globals.effects.call(i.ondayend, person)
			var consumption = variables.basefoodconsumption
			#ralphC - Succubus, Golem, and any future mana eaters
			var hungryforfood = 1 #ralphC - only changed for mana eaters (ie. Succubus) below
			var manaconsumption = variables.basemanafoodconsumption
			var feedmana = true
			if person.race_display in manaeaters || person.race in manaeaters:
				hungryforfood = 0
				if !person.traits.has('Clockwork'): #trait to be added with Golem race expansion - needs no mana or food
					if person.race_display == 'Succubus' && person.vagvirgin && person.age in ["child"]:
						hungryforfood += 1
						feedmana = false
					elif person.race_display == 'Succubus':
						person.mana_hunger += manaconsumption * variables.succubusagemod[person.age]
					else:
						person.mana_hunger += manaconsumption
					if feedmana && globals.resources.mana > person.manafeedpolicy:
						#print("Ralph Test: About to try channelling mana to Succubus: " + str(person.name))
						if globals.resources.mana > person.mana_hunger + person.manafeedpolicy: #if there's enough mana
							text0.set_bbcode(text0.get_bbcode()+person.dictionary('[color=yellow]You channel ' + str(int(person.mana_hunger)) + ' mana into ' + str(person.name_short()) + '[/color]\n'))
							globals.resources.mana -= person.mana_hunger
							person.mana_hunger = 0
							#print("Ralph Test: Fully fed Succubus: " + str(person.name))
						else: #if there's not enough mana
							text0.set_bbcode(text0.get_bbcode()+person.dictionary('[color=yellow]You attempt to channel ' + str(int(person.mana_hunger)) + ' mana into ' + str(person.name_short()) + ' but your reserves run low before you can finish.[/color]\n'))
							person.mana_hunger -= globals.resources.mana - person.manafeedpolicy
							globals.resources.mana = person.manafeedpolicy
							if person.race_display == 'Succubus':
								if person.mana_hunger > variables.succubushungerlevel[2] * variables.basemanafoodconsumption * variables.succubusagemod[person.age]:
									person.health -= person.stats.health_max
									text = person.dictionary('[color=#ff4949]$name has died of mana starvation.[/color]\n')
									deads_array.append({number = count, reason = text})
								elif person.mana_hunger > variables.succubushungerlevel[1] * variables.basemanafoodconsumption && person.lust >= 90:
									person.add_trait('Sex-crazed')
									hungryforfood = 1.5
									person.stress += 20
									person.obed -= max(35 - person.loyal/3,10)
									person.attention += 40
									person.attention += 40
								elif person.mana_hunger > variables.succubushungerlevel[0] * variables.basemanafoodconsumption * variables.succubusagemod[person.age]:
									person.lust += 25
									hungryforfood = 1.5
									person.stress += 15
									person.obed -= max(35 - person.loyal/3,10)
									person.attention += 25
					#elif person.race_display in ['Golem']:
					# make the Golem sleep?
			if hungryforfood > 0: #ralphC - just indents below except where commented #ralphC
				if chef != null:
					consumption = max(3, consumption - (chef.sagi + (chef.wit/20))/2)
					###---Added by Expansion---### Hybrid Support
					if chef.race.find('Scylla') >= 0:
						consumption = max(3, consumption - 1)
					###---End Expansion---###
				if person.traits.has("Small Eater"):
					consumption = consumption/3
				if person.race.find('Giant') >= 0:
					consumption = consumption*3
				###---Added by Expansion---### ---PENDING: Add option to "Drink from the Source"
				consumption = consumption * hungryforfood #ralphC - hungryforfood should be 1 unless starving Succubus
				if person.traits.has("Altered Dietary Needs"): 
					if globals.expansion.altereddiet_foodavailable(person) == true:
						temptext
						consumption = 0
						temptext = globals.expansion.altereddiet_consumebottle(person)
						text2.set_bbcode(text2.get_bbcode()+person.dictionary(temptext))
					else:
						consumption = consumption * 2
						text0.set_bbcode(text0.get_bbcode()+person.dictionary('$name could not find any bottles that matched their new dietary needs and had to try to consume twice as much food to avoid starvation. \n'))
			###---Expansion End---###
				if globals.resources.food >= consumption:
					person.loyal += rand_range(0,1)
					person.obed += person.loyal/5 - (person.cour+person.conf)/10
					globals.resources.food -= consumption
				else:
					text0.set_bbcode(text0.get_bbcode()+person.dictionary('[color=red]There was not enough food for $name.[/color]\n')) 
					person.stress += 20
					person.health -= rand_range(person.stats.health_max/6,person.stats.health_max/4)
					person.obed -= max(35 - person.loyal/3,10)
					if person.health < 1:
						text = person.dictionary('[color=#ff4949]$name has died of starvation.[/color]\n')
						deads_array.append({number = count, reason = text})
						continue
			#/ralphC
			if person.obed < 25 && person.cour >= 50 && person.rules.silence == false && person.traits.find('Mute') < 0 && person.sleep != 'jail' && person.sleep != 'farm' && person.brand != 'advanced'&& rand_range(0,1) > 0.5:
				text0.set_bbcode(text0.get_bbcode()+person.dictionary('$name dares to openly show $his disrespect towards you and instigates other servants. \n'))
				for ii in globals.slaves:
					if ii != person && ii.loyal < 30 && ii.traits.find('Loner') < 0:
						ii.obed += -(person.charm/3)
			if person.obed < 50 && person.loyal < 25 && person.sleep != 'jail'&& person.sleep != 'farm'&& person.brand != 'advanced':
				###---Added by Expansion---### Colorized
				if randf() < 0.3 && globals.resources.food > 34:
					text0.set_bbcode(text0.get_bbcode()+person.dictionary('[color=red]You notice that some of your food is gone.[/color]\n'))
					globals.resources.food -= rand_range(35,70)
				elif randf() < 0.3 && globals.resources.gold > 19:
					text0.set_bbcode(text0.get_bbcode()+person.dictionary('[color=red]You notice that some of your gold is missing.[/color]\n'))
					globals.resources.gold -= rand_range(20,40)
				###---End Expansion---###
			if person.obed < 25 && person.sleep != 'jail' && person.sleep != 'farm' && person.tags.has('noescape') == false:
				var escape = 0
				var stay = 0
				if person.brand == 'none':
					escape = person.cour/3+person.wit/3+person.stress/2
					stay = person.loyal*2+person.obed
				else:
					escape = person.cour/4+person.stress/4
					stay = person.loyal*2+person.obed+person.wit/5

				if globals.state.mansionupgrades.mansionkennels == 1:
					escape *= 0.8
				###---Added by Expansion---### NPCs Expanded || Escaped
				if person.movement in ['crawling','none']:
					escape *= 0.8
				elif person.movement == "flying":
					escape *= 1.2
				
				if escape > stay:
					if handcuffs == false:
						temptext = person.dictionary('[color=#ff4949]$name has escaped during the night![/color]\n')
						escaped_array.append({number = person.id, reason = temptext})
					else:
						text0.set_bbcode(text0.get_bbcode()+person.dictionary('[color=#ff4949]$name attempted to escape during the night but being handcuffed slowed them down and they were quickly discovered![/color]\n'))
				###---End Expansion---###
			###---Added by Expansion---### Hybrid Support
			#Races
			if person.race.find('Orc') >= 0:
				slavehealing += 0.15
			elif person.race.find('Slime') >= 0:
				person.toxicity = 0
			###---End Expansion---###
			#Traits
			if person.traits.has("Uncivilized"):
				for i in globals.slaves:
					###---Added by Expansion---### Added Cow/Hen/Trainer/Trainee
					if i.spec == 'tamer' && i.away.duration == 0 && i.obed > 60 && (i.work == person.work || i.work in ['rest','nurse','headgirl'] || (i.work == 'jailer' && person.sleep == 'jail') || (i.work == 'farmmanager' && person.work in ['cow','hen']) || (i.work == 'trainer' && person.work == 'trainee')):
						person.obed += 30
						person.loyal += 5
						if randf() < 0.1:
							person.trait_remove("Uncivilized")
							text0.set_bbcode(text0.get_bbcode() + i.dictionary("[color=green]$name managed to lift ") + person.dictionary("$name out of $his wild behavior and turn into a socially functioning person.[/color]\n "))
					###---End Expansion---###
			if person.traits.has("Infirm"):
				slavehealing = slavehealing/3
			if person.attention < 150 && person.sleep != 'your':
				person.attention += rand_range(5,7)
			if person.traits.has("Clingy") && person.loyal >= 15 && person.attention > 40 && randf() > 0.5:
				person.obed -= rand_range(10,30)
				person.loyal -= rand_range(1,5)
				text0.set_bbcode(text0.get_bbcode() + person.dictionary("[color=yellow]$name is annoyed by you paying no attention to $him. [/color]\n"))
			if person.traits.has('Pliable'):
				if person.loyal >= 60 && !person.traits.has('Devoted'):
					person.trait_remove('Pliable')
					person.add_trait('Devoted')
					text0.set_bbcode(text0.get_bbcode() + person.dictionary('[color=green]$name has become Devoted. $His willpower strengthened.[/color]\n'))
				elif person.lewdness >= 60:
					person.trait_remove('Pliable')
					person.add_trait('Slutty')
					text0.set_bbcode(text0.get_bbcode() + person.dictionary('[color=green]$name has become Slutty. $His willpower strengthened.[/color]\n'))
			if person.traits.has("Scoundrel"):
				globals.resources.gold += 15
				text1.set_bbcode(text1.get_bbcode() + person.dictionary('[color=green]$name has brought some additional gold by the end of day.[/color]\n'))
			if person.traits.has("Authority") && person.obed >= 95:
				for i in globals.slaves:
					if i.away.duration == 0 && i != person:
						i.obed += 5
			if person.traits.has("Mentor"):
				for i in globals.slaves:
					if i.away.duration == 0 && i != person && i.level < 3:
						i.xp += 5
			if person.traits.has("Experimenter") && randf() >= 0.8:
				var array = []
				for i in globals.itemdict.values():
					if i.type == 'potion':
						array.append(i.code)
				array = globals.itemdict[array[randi()%array.size()]]
				array.amount += 1
				text0.bbcode_text += person.dictionary("$name has produced [color=aqua]1 " + array.name + '[/color]\n')
			#Rules and clothes effect
			if person.rules.contraception == true:
				if !person.effects.has("contraceptive"):
					if globals.resources.gold >= 5:
						globals.resources.gold -= 5
						person.add_effect(globals.effectdict.contraceptive)
						gold_consumption += 5
					else:
						text0.set_bbcode(text0.get_bbcode()+person.dictionary("[color=#ff4949]You couldn't afford to provide $name with contraceptives.[/color]\n"))
			if person.rules.aphrodisiac == true:
				var value
				if person.spec != 'housekeeper':
					value = 8
				else:
					value = 4
				if globals.resources.gold >= value:
					globals.resources.gold -= value
					person.lust += rand_range(10,15)
					gold_consumption += value
				else:
					text0.set_bbcode(text0.get_bbcode()+person.dictionary("[color=#ff4949]You couldn't supply $name's food with aphrodisiac.[/color]\n"))
			if person.rules.silence == true:
				if person.cour > 40:
					person.cour += -rand_range(3,5)
				person.obed += rand_range(5,10)
			if person.rules.pet == true:
				if person.conf > 25:
					person.conf -= rand_range(5,10)
				if person.charm > 25:
					person.charm -= rand_range(4,8)
				person.obed += rand_range(8,15)
			if person.rules.nudity == true:
				person.lust += rand_range(5,10)
				if person.lewdness < 40 && !person.traits.has("Pervert") && !person.traits.has("Sex-crazed"):
					person.stress += rand_range(5,10)
			for i in person.gear.values():
				if i != null && globals.state.unstackables.has(i):
					var tempitem = globals.state.unstackables[i]
					globals.items.person = person
					for k in tempitem.effects:
						if k.type == 'onendday':
							if k.has('effectvalue'):
								text2.bbcode_text += person.dictionary(globals.items.call(k.effect, k.effectvalue))
							else:
								text2.set_bbcode(text2.get_bbcode() + person.dictionary(globals.items.call(k.effect, person)))
			if person.fear > 0:
				var fearreduction = 10 + person.conf/20
				if person.brand != 'none':
					fearreduction /= 2
				if person.sleep == 'jail':
					fearreduction -= fearreduction*0.3
				if person.fear - fearreduction > 0:
					person.obed += 20
					person.fear -= fearreduction
				else:
					person.obed += 20 - abs(person.fear - fearreduction)*1.5
					text2.bbcode_text += person.dictionary("[color=yellow]$name seems no longer to be afraid of you.[/color]\n")
					person.fear = 0
			if person.toxicity > 0:
				if person.toxicity > 35 && randf() > 0.65:
					person.stress += rand_range(10,15)
					person.health -= rand_range(10,15)
					text2.set_bbcode(text2.get_bbcode() + person.dictionary("$name suffers from magical toxicity.\n"))
				if person.toxicity > 60 && randf() > 0.75:
					globals.spells.person = person
					text0.set_bbcode(text0.get_bbcode()+globals.spells.mutate(person.toxicity/30) + "\n\n")
				person.toxicity -= rand_range(1,5)
				if person.health < 1:
					text = person.dictionary('[color=#ff4949]$name has died of magical toxicity.[/color]\n')
					deads_array.append({number = count, reason = text})
					continue

			if person.stress >= 33 && randf() <= 0.3:
				if randf() >= 0.5:
					person.obed -= (person.stress - 33)/2
				else:
					person.energy -= rand_range(15,30)
				#text0.bbcode_text += person.dictionary("[color=#ff4949]$name suffers from stress [/color]")

			if person.stress >= 66 && randf() <= 0.3:
				if randf() >= 0.5:
					person.loyal -= rand_range(5,10)
				else:
					person.health -= person.stats.health_max/7
				if person.health < 1:
					text = person.dictionary('[color=#ff4949]$name has died of stress.[/color]\n')
					deads_array.append({number = count, reason = text})
					continue

			if person.stress >= 99:
				person.mentalbreakdown()
				if person.health < 1:
					text = person.dictionary('[color=#ff4949]$name has died during a mental breakdown.[/color]\n')
					deads_array.append({number = count, reason = text})
					continue

			###---Added by Expansion---### Hybrid Support
			if person.race.find('Fairy') >= 0:
				person.stress -= rand_range(10,20)
			###---End Expansion---###
			else:
				person.stress -= rand_range(5,10)

			###---Added by Expansion---### Flaws; Lust
			#sleep conditions
			if person.lust < 25 || person.traits.has('Sex-crazed') || person.checkVice('lust'):
				person.lust += round(rand_range(3,6))
			###---End Expansion---###
			if person.sleep == 'communal' && globals.count_sleepers()['communal'] > globals.state.mansionupgrades.mansioncommunal:
				person.stress += rand_range(5,15)
				slavehealing -= 0.1
				text2.set_bbcode(text2.get_bbcode() + person.dictionary('$name suffers from communal room being overcrowded.\n'))
			elif person.sleep == 'communal':
				person.stress -= rand_range(5,10)
				person.energy += rand_range(20,30)+ person.send*6
			elif person.sleep == 'personal':
				person.stress -= rand_range(10,15)
				slavehealing += 0.1
				person.energy += rand_range(40,50)+ person.send*6
				text2.set_bbcode(text2.get_bbcode() + person.dictionary('$name sleeps in a private room, which helps $him heal faster and provides some stress relief.\n'))
				if person.lust >= 50 && person.rules.masturbation == false && person.tags.find('nosex') < 0:
					person.lust -= rand_range(30,40)
					person.lastsexday = globals.resources.day
					text2.set_bbcode(text2.get_bbcode() + person.dictionary('In an attempt to calm $his lust, $he spent some time busying $himself in feverish masturbation, making use of $his private room.\n'))
			elif person.sleep == 'your':
				person.loyal += rand_range(1,4)
				person.energy += rand_range(25,45)+ person.send*6
				for i in globals.slaves:
					if i.sleep == 'your' && i != person && i.away.duration == 0:
						globals.addrelations(person, i, 0)
						if (person.relations[i.id] <= 200 && !person.traits.has("Fickle")) || person.traits.has("Monogamous"):
							globals.addrelations(person, i, -rand_range(50,100))
						else:
							globals.addrelations(person, i, rand_range(15,30))
				if person.loyal > 30:
					person.stress -= person.loyal/7
				if person.lust > 40 && person.consent && person.vagvirgin == false && person.tags.find('nosex') < 0:
					text2.set_bbcode(text2.get_bbcode() + person.dictionary('$name went down on you being unable to calm $his lust.\n'))
					person.lust -= rand_range(15,25)
					person.metrics.sex += 1
					person.lastsexday = globals.resources.day
					globals.resources.mana += round(rand_range(1,6))
					globals.impregnation(person, globals.player)
				else:
					text2.set_bbcode(text2.get_bbcode() + person.dictionary('$name keeps you company at night and you grew closer.\n'))
			elif person.sleep == 'jail':
				person.metrics.jail += 1
				person.obed += 25 - person.conf/6
				person.energy += rand_range(20,30) + person.send*6
				if person.stress > 66:
					person.stress -= rand_range(5,10)
				else:
					if globals.state.mansionupgrades.jailtreatment == 0:
						person.stress += person.conf/10
			###---Added by Expansion---### Added by Deviate - Kennel Sleep Location
			elif person.sleep == 'kennel':
				person.stress -= rand_range(5,10)
				person.energy += rand_range(10,15)+ person.send*6	

				if person.preg.has_womb == true && person.preg.ovulation_stage == 1 && rand_range(1,10) >= 4 && (person.race == 'Halfkin Wolf' || person.race == 'Beastkin Wolf'):
					text0.set_bbcode(text0.get_bbcode() + person.dictionary("$name is in heat. While sleeping in the kennels $name submissively allowed one of the kennel hounds to mount and fuck her.\n"))
					if person.vagvirgin == true:
						text0.set_bbcode(text0.get_bbcode() + person.dictionary("$name's virginity was taken by a dog.\n\n"))
						person.vagvirgin = false
						person.asser -= 10
						person.obed += 10
					person.lust -= round(person.lust/2)
					person.obed += 10
					person.loyal += 5
					person.wit -= 2
					person.conf -= 2
					person.charm -= 2
					person.asser -= 10
					person.lewdness += 5
					person.metrics.animalpartners += 1
					person.cum.pussy += 5
					globals.impregnation(person, null, 'dog')
					globals.resources.mana += int(rand_range(1,6))
				elif person.preg.has_womb == true && rand_range(1,10) >= 7:
					text0.set_bbcode(text0.get_bbcode() + person.dictionary("While sleeping in the kennels $name submissively allowed one of the kennel hounds to mount and fuck her.\n"))
					if person.vagvirgin == true:
						text0.set_bbcode(text0.get_bbcode() + person.dictionary("$name's virginity was taken by a dog.\n\n"))
						person.vagvirgin = false
						person.asser -= 10
						person.obed += 10
					else:
						text0.set_bbcode(text0.get_bbcode() + person.dictionary("\n"))
					person.lust -= round(person.lust/2)
					person.obed += 10
					person.loyal += 5
					person.wit -= 2
					person.conf -= 2
					person.charm -= 2
					person.asser -= 10
					person.lewdness += 5
					person.metrics.animalpartners += 1
					person.cum.pussy += 5
					if person.race.find('Wolf') >= 0:
						globals.impregnation(person, null, 'dog')
						globals.resources.mana += int(rand_range(1,6))
				elif rand_range(1,100) >= 50:
					text0.set_bbcode(text0.get_bbcode() + person.dictionary("While sleeping in the kennels, $name was awoken by the snarling of a hound. "))
					if person.vagina != "none" || person.penis != "none":
						if person.exposed.genitals == false:
							text0.set_bbcode(text0.get_bbcode() + person.dictionary("The beast viciously grabbed $his pants and shredded them in its attempts to access their genitals. "))
							person.exposed.genitals = true
							person.exposed.genitalsforced = true
						if person.vagina != "none":
							text0.set_bbcode(text0.get_bbcode() + person.dictionary("The beast lunged forward and violently thrust its throbbing member into the wimpering $name's " + str(globals.expansion.namePussy()) + ". "))
						else:
							text0.set_bbcode(text0.get_bbcode() + person.dictionary("The beast lunged forward and forced $name onto the floor before mounting $his " + str(globals.expansion.namePenis()) + " and having its way with $him. "))
			###---End Expansion---###
			person.health += slavehealing * person.stats.health_max

			if person.skillpoints < 0:
				person.skillpoints = 0

			###---Added by Expansion---### Category: Pregnancy | Replace Below
			if person.preg.duration > 0:
				#Leaving Miscarriages Here
				if person.health < 20 && rand_range(0,100) > person.health*2:
					globals.miscarriage(person)
					if person.preg.is_preg == true:
						text0.set_bbcode(text0.get_bbcode()+person.dictionary('[color=#ff4949]Due to $his poor health condition, $name had a miscarriage and lost one of $his unborn children.[/color]\n'))
					else:
						text0.set_bbcode(text0.get_bbcode()+person.dictionary('[color=#ff4949]Due to $his poor health condition, $name had a miscarriage and lost $his unborn child.[/color]\n'))
					person.stress += rand_range(35,50)
				
#				if person.preg.duration > globals.state.pregduration/6:
#					person.lactation = true
#					if headgirl != null:
#						if person.preg.duration == floor(globals.state.pregduration/5):
#							text0.set_bbcode(text0.get_bbcode() + headgirl.dictionary('[color=yellow]$name reports, that ') + person.dictionary('$name appears to be pregnant. [/color]\n'))
#						elif person.preg.duration == floor(globals.state.pregduration/2.7):
#							text0.set_bbcode(text0.get_bbcode() + headgirl.dictionary('[color=yellow]$name reports, that ') + person.dictionary('$name will likely give birth soon. [/color]\n'))
#				else:
#					if person.preg.duration > globals.state.pregduration/3:
#						person.lactation = true
#						if headgirl != null:
#							if person.preg.duration == floor(globals.state.pregduration/2.5):
#								text0.set_bbcode(text0.get_bbcode() + headgirl.dictionary('[color=yellow]$name reports, that ') + person.dictionary('$name appears to be pregnant. [/color]\n'))
#							elif person.preg.duration == floor(globals.state.pregduration/1.3):
#								text0.set_bbcode(text0.get_bbcode() + headgirl.dictionary('[color=yellow]$name reports, that ') + person.dictionary('$name will likely give birth soon. [/color]\n'))
#				if randf() < 0.4:
#					person.stress += rand_range(15,20)
				###---End Expansion---###

			if person.away.duration == 0 && !person.sleep in ['jail','farm']:
				var personluxury = person.calculateluxury()
				var luxurycheck = person.countluxury()
				var luxury = luxurycheck.luxury
				gold_consumption += luxurycheck.goldspent
				if luxurycheck.nosupply == true:
					lacksupply = true
				###---Added by Expansion---### Vices
				if !person.traits.has("Grateful") && luxury < personluxury && person.metrics.ownership - person.metrics.jail > 7:
					person.loyal -= (personluxury - luxury)/2.5
					person.obed -= (personluxury - luxury)
					text0.set_bbcode(text0.get_bbcode() + person.dictionary("[color=#ff4949][color=aqua]$name[/color] appears to be rather unhappy about quality of $his life and demands better living conditions from you. [/color]\n"))
				if luxurycheck.vice_modifier != 0:
					if person.mind.vice_known == false:
						person.mind.vice_presented = true
						if luxurycheck.vice_modifier > 0:
							text1.set_bbcode(text1.get_bbcode() + person.dictionary("[color=aqua]$name[/color] seems to have an unknown [color=aqua]Vice[/color] affecting $his happiness and [color=aqua]Luxury[/color] [color=green]positively[/color] today. Perhaps [color=aqua]reading $his mind[/color] will reveal more. \n"))
						elif luxurycheck.vice_modifier < 0:
							text1.set_bbcode(text1.get_bbcode() + person.dictionary("[color=aqua]$name[/color] seems to have an unknown [color=aqua]Vice[/color] affecting $his happiness and [color=aqua]Luxury[/color] [color=red]negatively[/color] today. Perhaps [color=aqua]reading $his mind[/color] will reveal more. \n"))
					else:
						text1.set_bbcode(text1.get_bbcode() + person.dictionary("[color=aqua]$name[/color] has a [color=aqua]"+ str(person.mind.vice.capitalize()) +" Vice[/color] which affected $his happiness and [color=aqua]Luxury[/color] "))
						if luxurycheck.vice_modifier > 0:
							text1.set_bbcode(text1.get_bbcode() + person.dictionary("[color=green]positively[/color] today. \n"))
						elif luxurycheck.vice_modifier < 0:
							text1.set_bbcode(text1.get_bbcode() + person.dictionary("[color=red]negatively[/color] today. \n"))
				###---End Expansion---###
		person.work = jobRestore
		count+=1
	if headgirl != null && globals.state.headgirlbehavior != 'none':
		var headgirlconf = headgirl.conf
		if headgirl.spec == 'executor':
			headgirlconf = max(100, headgirl.conf)
		count = 0
		for i in globals.slaves:
			if i != headgirl && i.traits.find('Loner') < 0 && i.away.duration == 0 && i.sleep != 'jail' && i.sleep != 'farm':
				count += 1
				globals.addrelations(i, headgirl, 15)
				if i.obed < 65 && globals.state.headgirlbehavior == 'strict':
					var obedbase = i.obed
					i.fear += max(0,(-(i.cour/15) + headgirlconf/7))
					if rand_range(0,100) < headgirlconf - i.conf / 4:
						i.obed += rand_range(3,5) + headgirlconf/15
					i.stress += rand_range(5,10)
					if i.obed <= obedbase:
						globals.addrelations(i, headgirl, -40)
						text0.set_bbcode(text0.get_bbcode() + i.dictionary('$name was acting frivolously. ') + headgirl.dictionary('$name tried to put ') + i.dictionary("$him in place, but failed to make any impact.\n\n"))
					else:
						text0.set_bbcode(text0.get_bbcode() + i.dictionary('$name was acting frivolously, but ') + headgirl.dictionary('$name managed to make ') + i.dictionary("$him submit to your authority and slightly improve $his behavior.\n\n"))
				elif globals.state.headgirlbehavior == 'kind':
					if rand_range(0,100) < headgirl.charm:
						i.obed += rand_range(3,5) + headgirl.charm/15
					i.stress -= (headgirl.charm/6)
		headgirl.xp += 3 * count
	if jailer != null:
		var jailerconf = jailer.conf
		if jailer.spec == 'executor':
			jailerconf = max(100, jailer.conf)
		count = 0
		for person in globals.slaves:
			if person.sleep == 'jail' && person.away.duration == 0:
				count += 1
				if person.obed < 80:
					globals.addrelations(person, jailer, 25)
				person.health += round(jailer.wit/10)
				person.obed += round(jailer.charm/8)
				if person.effects.has('captured') == true && jailerconf-30 >= rand_range(0,100):
					person.effects.captured.duration -= 1
		jailer.xp += count * 5
	
###---Added by Expansion---### Farm Expanded (Handled in expansionfarm.gd now)
#	var foodproduction = 0
#	var milkproduction = 0
#	var cumproduction = 0
#	var pissproduction = 0
#	var goldproduction = 0
	var farmtext = globals.expansionfarm.dailyFarm()
	if farmmanager != null:
		#Leaving for Relations
		var farmconf = farmmanager.conf
		if farmmanager.spec == 'executor':
			farmconf = max(100, farmmanager.conf)
		for person in globals.slaves:
			###---Added by Expansion---### Ankmairdor's BugFix v4
#			if person.sleep == 'farm' && person.away.duration == 0:
			###---End Expansion---###
				#if person.obed < 75:
				if rand_range(0,100) <= (person.obed-100) + (farmmanager.conf*1.25):
					globals.addrelations(person, farmmanager, rand_range(25,40))
				else:
					globals.addrelations(person, farmmanager, rand_range(-25,-40))
#	text3.set_bbcode(text3.get_bbcode()+farmtext)
	if farmtext != null && text3 != null && globals.state.farm >= 3:
		text3.set_bbcode(farmtext)
	
	for person in globals.slaves:
		if person.lust >= 90 && person.rules.masturbation == true && !person.traits.has('Sex-crazed') && (rand_range(0,10)>7 || person.effects.has('stimulated')) && globals.resources.day - person.lastsexday >= 5:
			person.add_trait('Sex-crazed')
			text0.set_bbcode(text0.get_bbcode() + person.dictionary("[color=yellow]Left greatly excited and prohibited from masturbating, $name desperate state led $him to become insanely obsessed with sex.[/color]\n"))
		elif person.lust >= 75 && globals.resources.day - person.lastsexday >= 5:
			person.stress += rand_range(10,15)
			person.obed -= rand_range(10,20)
			text0.bbcode_text += person.dictionary("[color=red]$name is suffering from unquenched lust.[/color]\n")
		
	###---Added by Expansion---### Ank BugFix v4a
	for person in globals.slaves:
		if person.spec == 'housekeeper' && person.away.duration == 0 && person.work in ['headgirl','farmmanager','labassist','jailer']:
			globals.state.condition = (5.5 + max(0, person.sagi+person.send)*6)/2
			text2.bbcode_text += person.dictionary("$name has managed to clean the mansion a bit while being around. \n")
	###---End Expansion---###
	#####          Dirtiness
	if globals.state.condition <= 40:
		for person in globals.slaves:
			if person.away.duration != 0:
				continue
			if globals.state.condition >= 30:
				if randf() >= 0.7:
					person.stress += rand_range(5,15)
					person.obed += -rand_range(15,20)
					text0.set_bbcode(text0.get_bbcode() + person.dictionary("[color=yellow]$name was distressed by mansion's poor condition. [/color]\n"))
			elif globals.state.condition >= 15:
				if randf() >= 0.5:
					person.stress += rand_range(10,20)
					person.obed += -rand_range(15,35)
					text0.set_bbcode(text0.get_bbcode() + person.dictionary("[color=yellow]$name was distressed by mansion's poor condition. [/color]\n"))
			elif randf() >= 0.4:
				person.stress += rand_range(15,25)
				person.health -= rand_range(5,10)
				text0.set_bbcode(text0.get_bbcode() + person.dictionary("[color=#ff4949]Mansion's terrible condition causes $name a lot of stress and impacted $his health. [/color]\n"))
				if person.health < 1:
					text = person.dictionary('[color=#ff4949]$name has died of poor cleanliness.[/color]\n')
					deads_array.append({number = count, reason = text})


	#####          Outside Events
	for guild in globals.guildslaves:
		var slaves = globals.guildslaves[guild]
		###---Added by Expansion---### Ank BugFix v4a
		var idx
		var removeId
		var tempslave
		count = round(clamp(0.01 * slaves.size() + rand_range(0.1, 0.4), 0.25, 0.75) * slaves.size())
		for i in range(count):
			idx = randi() % (slaves.size()*7/4) % slaves.size()
			removeId = slaves[idx].id
			for id in slaves[idx].relations:
				tempslave = globals.state.findslave(id)
				if tempslave:
					tempslave.relations.erase(removeId)
			slaves.remove(idx)
		###---End Expansion---###

		if slaves.size() < 4:
			get_node("outside").newslaveinguild(2, guild)
		if slaves.size() < 10 && randf() < 0.85:
			get_node("outside").newslaveinguild(1, guild)
		if randf() < 0.5:
			get_node("outside").newslaveinguild(1, guild)

	if globals.state.sebastianorder.duration > 0:
		globals.state.sebastianorder.duration -= 1
		###---Added by Expansion---### Secondary check for Sebastian Order
		if globals.state.sebastianorder.duration == 0 && globals.state.sebastianorder.taken == true:
			text0.set_bbcode(text0.get_bbcode() + "[color=green]Sebastian should have your order ready by this time. [/color]\n")
		###---End Expansion---###
	globals.state.groupsex = true

	var consumption = variables.basefoodconsumption
	if chef != null:
		consumption = max(3, consumption - (chef.sagi + (chef.wit/20))/2)
		###---Added by Expansion---### Hybrid Support
		if chef.race.find('Scylla') >= 0:
			consumption = max(3, consumption - 1)
		###---End Expansion---###
	if globals.player.race.find('Giant') >= 0:
		consumption = consumption*3
	if globals.resources.food >= consumption:
		globals.resources.food -= consumption
	else:
		if globals.resources.gold < 20:
			get_node("gameover").show()
			get_node("gameover/Panel/text").set_bbcode("[center]With no food and money your mansion falls in chaos. \nGame over.[/center]")
		else:
			globals.resources.gold -= 20
			text0.set_bbcode(text0.get_bbcode()+ "[color=#ff4949]You have no food in the mansion and left dining at town, paying 20 gold in process.[/color]\n")

	for guildQuests in globals.state.repeatables.values():
		var idx = 0
		while idx < guildQuests.size():
			var quest = guildQuests[idx]
			if quest.taken:
				quest.time -= 1
				if quest.time < 0:
					text0.bbcode_text += '[color=#ff4949]You have failed to complete your quest at ' + quest.location.capitalize() +'.[/color]\n'
					guildQuests.remove(idx)
				else:
					idx += 1
			elif randf() < 0.1:
				guildQuests.remove(idx)
			else:
				idx += 1
	if int(globals.resources.day)%5 == 0.0:
		rebuildrepeatablequests()

	if globals.player.xp >= 100:
		globals.player.xp -= 100
		globals.player.value += 1
		globals.player.skillpoints += 1
		text0.set_bbcode(text0.get_bbcode() + '[color=green]You have leveled up and earned an additional skillpoint. [/color]\n')
	globals.player.health += 50
	globals.player.energy += 100

	for i in globals.player.effects.values():
		if i.has("ondayend") && i.code.find("animalistic") >= 0:
			globals.effects.call(i.ondayend, globals.player)
		if i.has('duration') && i.code != "contraceptive":
			i.duration -= 1
			if i.duration <= 0:
				globals.player.add_effect(i, true)

	if globals.state.mansionupgrades.foodpreservation == 0 && globals.resources.food >= globals.resources.foodcaparray[globals.state.mansionupgrades.foodcapacity]*0.80:
		globals.resources.food -= globals.resources.food*0.03
		text0.set_bbcode(text0.get_bbcode() + '[color=yellow]Some of your food reserves have spoiled.[/color]\n')

	# Process away slaves now
	for person in globals.slaves:
		if person.away.duration > 0:
			person.away.duration -= 1
			###---Added by Expansion---### Hybrid Support && Ankmairdor's BugFix v4
			if person.away.at == 'lab' && person.health < 5:
				temptext = "$name has not survived the laboratory operation due to poor health.\n"
				deads_array.append({number = count, reason = temptext})
				person.removefrommansion()
				continue
			else:
				var slavehealing = person.send * 0.03 + 0.02
				if person.away.at in ['rest','vacation']:
					slavehealing += 0.15
					person.stress -= 20
				if person.race.find('Orc') >= 0:
					slavehealing += 0.15
				if person.traits.has("Infirm"):
					slavehealing = slavehealing/3
				person.health += slavehealing * person.stats.health_max
				if person.race.find('Fairy') >= 0:
					person.stress -= rand_range(10,20)
				else:
					person.stress -= rand_range(5,10)
				person.energy += rand_range(20,30) + person.send*6

				if person.away.duration == 0:
					if person.away.at == 'transported back':
						globals.itemdict['rope'].amount += globals.state.calcRecoverRope(1)
						if globals.count_sleepers().jail < globals.state.mansionupgrades.jailcapacity:
							person.sleep = 'jail'
							text0.set_bbcode(text0.get_bbcode() + person.dictionary("[color=aqua]$name[/color] has been transported to the mansion and placed in the jail. \n"))
						else:
							person.sleep = 'communal'
							text0.set_bbcode(text0.get_bbcode() + person.dictionary("[color=aqua]$name[/color] has been transported to the mansion. You are out of free jail cells and $he was assigned to the communal area. \n"))
					else:
						text0.set_bbcode(text0.get_bbcode() + person.dictionary("[color=aqua]$name[/color] " + awayReturnText.get(person.away.at, awayReturnText.default) + "\n"))
						if person.away.get("prev_work", "") != "":
							text0.set_bbcode(text0.get_bbcode() + person.dictionary("[color=aqua]$name[/color] was [color=red]removed[/color] from $his previous job (" + globals.jobs.jobdict[person.away.prev_work].name + ") while away, so will now be resting.\n"))
							person.away.erase("prev_work")
						###---End Expansion---###
						var sleepChange = false
						if person.sleep != 'communal':
							match person.sleep:
								'personal':
									sleepChange = globals.count_sleepers().personal > globals.state.mansionupgrades.mansionpersonal
								'your':
									sleepChange = globals.count_sleepers().your_bed > globals.state.mansionupgrades.mansionbed
								'jail':
									sleepChange = globals.count_sleepers().jail > globals.state.mansionupgrades.jailcapacity
								'farm':
									if globals.count_sleepers().farm > variables.resident_farm_limit[globals.state.mansionupgrades.farmcapacity]:
										sleepChange = true
										person.job = 'rest'
						if sleepChange:
							person.sleep = 'communal'
							###---Added by Expansion---### Colorized
							text0.set_bbcode(text0.get_bbcode() + person.dictionary("[color=aqua]$name's[/color] sleeping place is no longer available so $he has moved to the communal area. \n"))
							###---End Expansion---###
					person.away.at = ''
				for i in person.effects.values():
					if i.has('duration') && i.code != 'captured':
						###---Added by Expansion---### Hybrid Support && Ank BugFix v4
						if person.race.find('Tribal Elf') < 0 || i.code in ['bandaged','sedated', 'drunk'] || randf() > 0.5:
							i.duration -= 1
						###---End Expansion---###
						if i.duration <= 0:
							person.add_effect(i, true)
					elif i.code == 'captured':
						if i.duration <= 0:
							if i.code == 'captured':
								text0.set_bbcode(text0.get_bbcode() + person.dictionary('$name grew accustomed to your ownership.\n'))
							person.add_effect(i, true)
					if i.has("ondayend"):
						globals.effects.call(i.ondayend, person)

	###---Added by Expansion---### Ovulation System
	text0.set_bbcode(text0.get_bbcode()+globals.expansion.nightly_womb(globals.player))
	for i in globals.slaves:
		text0.set_bbcode(text0.get_bbcode()+globals.expansion.nightly_womb(i))
	###---End Expansion---###
	
	#####         Results
	if start_gold < globals.resources.gold:
		results = 'good'
		text = 'Your residents earned [color=yellow]' + str(globals.resources.gold - start_gold) + '[/color] gold by the end of day. \n'
	elif start_gold == globals.resources.gold:
		results = 'med'
		text = "By the end of day your gold reserve didn't change. "
	else:
		results = 'bad'
		text = "By the end of day your gold reserve shrunk by [color=yellow]" + str(start_gold - globals.resources.gold) + "[/color] pieces. "
	if start_food > globals.resources.food:
		text = text + 'Your food storage shrank by [color=aqua]' + str(start_food - globals.resources.food) + '[/color] units of food.\n'
	else:
		text = text + 'Your food storage grew by [color=aqua]' + str(globals.resources.food - start_food) + '[/color] units of food.\n'
	#ralph5 - daily market price recovery and chance of big market change for one race
	if globals.useRalphsTweaks:
		text = text + "\n\n Market pricing for slaves increased somewhat to suit demand.\n"
		for i in globals.races:
			if globals.state.racemarketsat[i] < globals.races[i].pricemod:
				globals.state.racemarketsat[i] = clamp(globals.state.racemarketsat[i] + max(0.01,(1-globals.state.racemarketsat[i])*0.25),0.5,globals.races[i].pricemod) #under 1.0, recovers quickly toward 1 - over 1.0 increase 0.1 every 10 days
		if rand_range(0,100) <= 100: #chance of a market event occuring to affect one races prices
			var temprandom = rand_range(0.25,1.0) #magnitude of ratio change
			var temprace
			var tempcount = 0.0
			var tempracecount = 0.0
			var tempracearray = []
			var tempracearray2 = []
			for i in globals.guildslaves:
				for person in globals.guildslaves[i]:
					if !tempracearray.has(person.race.replace('Halfkin', 'Beastkin')):
						tempracearray.append(person.race.replace('Halfkin', 'Beastkin')) #create array or races currently for sale
			if !tempracearray.empty() && rand_range(0,100) < 30: #chance specific race increase/decrease
				temprace = globals.randomfromarray(tempracearray) #select available race for price decrease or else: below (increase)
				if rand_range(0,100) < 50: #chance for price decrease
					if rand_range(0,100) <= 20: #chance for price decrease due to sudden supply
						#determine how amny to add; increase price; add them to a guild
						for i in globals.guildslaves: #get count of temprace for sale at the guilds
							for person in globals.guildslaves[i]:
								if temprace == person.race.replace('Halfkin', 'Beastkin'):
									tempracecount += 1
						tempracecount = max(min(tempracecount*2,10),4)-int(rand_range(0,1)) #set number of slaves to be added with scarce races added to less
						var town = globals.randomfromarray(['wimborn','gorn','frostford','umbra'])
						#globals.get_tree().get_current_scene().get_node("outside").newslaveinguild(tempracecount,town,temprace)
						get_node("outside").newslaveinguild(tempracecount,town,temprace)
						text = text + "An anonymous party floods the slave guild in [color=yellow]" + town + "[/color] with [color=yellow]" + str(tempracecount) + "[/color][color=aqua]" + globals.races[temprace].plural + "[/color]. Prices drop.\n"
						var racepricemod = 1
						var racepricemodchange = 0
						for i in tempracecount: #decrease price ratio for temprace for each sold (same amount as when player sells)
							racepricemod = globals.state.racemarketsat[temprace.replace('Halfkin', 'Beastkin')]
							racepricemodchange = (racepricemod - 0.5)*0.1 #the bigger the premium the more the premium will be decreased
							racepricemod = clamp(racepricemod - racepricemodchange,0.5,5)
							globals.state.racemarketsat[temprace] = racepricemod
					else: #chance for simple price decrease
						globals.state.racemarketsat[temprace] = clamp(globals.state.racemarketsat[temprace] - temprandom,0.5,5)
						text = text + str(globals.randomfromarray(globals.races[temprace].marketdown))
						#print("decrease price: " + str(globals.randomfromarray(globals.races[temprace].marketdown)))
				elif rand_range(0,100) < 80: #simple price increase for race missing from slave guilds
					for i in globals.races:
						if !i in tempracearray:
							tempracearray2.append(i) #create array of races not currently for sale
					if tempracearray2 != null:
						temprace = globals.randomfromarray(tempracearray2) #select available race for price increase
						globals.state.racemarketsat[temprace] = clamp(globals.state.racemarketsat[temprace] + temprandom,0.5,5)
						text = text + str(globals.randomfromarray(globals.races[temprace].marketup))
						#print("increase price: " + str(globals.randomfromarray(globals.races[temprace].marketup)))
				else: #price increase due to all existing race slaves being sold from slave guilds
					for guild in globals.guildslaves:
						for person in globals.guildslaves[guild].duplicate():
							if person.race.replace('Halfkin', 'Beastkin') == temprace:
								var start_size = globals.guildslaves[guild].size()
								globals.guildslaves[guild].erase(person)
								tempcount += 1.0
					text = text + "Demand skyrockets after an unknown party purchases every [color=aqua]" + temprace + "[/color] on the market.\n"
					globals.state.racemarketsat[temprace] = clamp(globals.races[temprace].pricemod + min(0.5,tempcount*0.1),0.5,5)
	#/ralph5
	text0.set_bbcode(text0.get_bbcode() + text)
	globals.state.sexactions = ceil(globals.player.send/2.0) + variables.basesexactions
	globals.state.nonsexactions = ceil(globals.player.send/2.0) + variables.basenonsexactions
	if deads_array.size() > 0:
		results = 'worst'
		###---Added by Expansion---### Ank BugFix v4a
		for i in deads_array:
			text0.set_bbcode(text0.get_bbcode() + i.reason)
		###---End Expansion---###
	###---Added by Expansion---### NPCs Expanded || Escaped
	if !escaped_array.empty():
		results = 'worst'
		escaped_array.invert()
		for i in escaped_array:
			var npcid = i.number
			var npc = globals.state.findslave(npcid)
			if npc == null:
				continue
			var reencounterchance = 50 + (globals.expansion.enemyreencounterchanceescape*2) - round(rand_range(npc.sagi,npc.sagi*5))
			var location = str(globals.state.location) + "outskirts"
			var reputation = round(rand_range(-1,-3))
#			npc.npcexpanded.timesescaped += 1
			npc.unassignPartner()
			globals.slaves.erase(npc)
			globals.state.allnpcs = npc
			globals.state.offscreennpcs.append([npcid, location, reencounterchance, 'escaping', reputation, 'slave'])
			text0.set_bbcode(text0.get_bbcode() + i.reason + '\n')
	###---End Expansion---###
	text0.set_bbcode(text0.get_bbcode()+ "[color=yellow]" +str(round(gold_consumption))+'[/color] gold was used for various tasks.\n'  )
	###---Added by Expansion---### Dimensional Crystal
	var crystaltext = globals.expansion.dailyCrystal()
	if crystaltext != "":
		text0.set_bbcode(text0.get_bbcode()+ str(crystaltext))
	###---End Expansion---###
	
	get_node("FinishDayPanel/FinishDayScreen").set_current_tab(0)
	aliseresults = results
	if lacksupply == true:
		text0.set_bbcode(text0.get_bbcode()+"[color=#ff4949]You have expended your supplies and some of the actions couldn't be finished. [/color]\n")
	get_node("Navigation/endlog").disabled = false
	nextdayevents()

	globals.state.daily_reports.global = text0.get_bbcode()
	globals.state.daily_reports.job = text1.get_bbcode()
	globals.state.daily_reports.secondary = text2.get_bbcode()
	globals.state.daily_reports.farm = text3.get_bbcode()

func nextdayevents():
	get_node("FinishDayPanel").hide()
	var player = globals.player
	if player.preg.duration > globals.state.pregduration && player.preg.is_preg == true:
		childbirth_loop(player)
		checkforevents = true
		#ralphD - trying to stop my MC from being eternally fertilized 8P
		player.cum.pussy = 0
		player.preg.womb.clear()
		#/ralphD
		return
	for i in globals.slaves:
		###---Added by Expansion---### Hybrid Support
		if (i.preg.baby != null || !i.preg.unborn_baby.empty()) && (i.preg.duration > globals.state.pregduration || (i.race.find('Goblin') >= 0 && i.preg.duration > globals.state.pregduration/2)):
		#if i.preg.baby != null && (i.preg.duration > globals.state.pregduration || (i.race.find('Goblin') >= 0 && i.preg.duration > globals.state.pregduration/2)):
			var postpartum = 3
			if i.race.find('Goblin') >= 0:
				postpartum = 2
			i.away.duration = postpartum
			
			i.away.at = 'in labor'
			childbirth_loop(i)
			i.cum.pussy = 0 #ralphD - better help npcs keep from being eternally preggers from 1 f%$& too
			i.preg.womb.clear()
			checkforevents = true
			return
		###---End Expansion---###

	#QMod - Insert for new event system
#	var place = {region = 'any', area = 'mansion', location = 'foyer'}
#	var placeEffects = globals.events.call_events(place, 'schedule')
#	if placeEffects.hasEvent:
#		checkforevents = true
#		return
#
	#Old scheduled event system
	globals.state.upcomingevents.sort_custom(self, 'sortEvents')
	for i in globals.state.upcomingevents.duplicate():
		if $scene.is_visible_in_tree() == true:
			break
		i.duration -= 1
		if i.duration <= 0:
			var text = globals.events.call(i.code)
			globals.state.upcomingevents.erase(i)
			if text != null:
				get_node("FinishDayPanel/FinishDayScreen/Global Report").set_bbcode(get_node("FinishDayPanel/FinishDayScreen/Global Report").get_bbcode() + text)
			else:
				checkforevents = true
				return
	globals.state.dailyeventcountdown -= 1
	if globals.state.dailyeventcountdown <= 0 && !$scene.is_visible_in_tree() && !$dialogue.is_visible_in_tree():
		var event
		event = launchrandomevent()
		if event != null:
			globals.state.dailyeventcountdown = round(rand_range(5,10))
			get_node("dailyevents").show()
			get_node("dailyevents").currentevent = event
			get_node("dailyevents").call(event)
			dailyeventhappend = true
			checkforevents = true
			return
	if globals.state.sandbox == false && globals.state.mainquest < 42 && !$scene.is_visible_in_tree() && !$dialogue.is_visible_in_tree():

		if globals.state.mainquest >= 16 && !globals.state.plotsceneseen.has('garthorscene'):
			globals.events.garthorscene()
			globals.state.plotsceneseen.append('garthorscene')
			checkforevents = true
			return
		elif globals.state.mainquest >= 18 && !globals.state.plotsceneseen.has('hade1'):
			globals.events.hadescene1()
			globals.state.plotsceneseen.append('hade1')
			checkforevents = true
			return
		elif globals.state.mainquest >= 24 && !globals.state.plotsceneseen.has('hade2'):
			globals.events.hadescene2()
			globals.state.plotsceneseen.append('hade2')
			checkforevents = true
			return
		elif globals.state.mainquest >= 27 && !globals.state.plotsceneseen.has('slaverguild'):
			globals.events.slaverguild()
			globals.state.plotsceneseen.append('slaverguild')
			checkforevents = true
			return
		elif globals.state.mainquest >= 36 && !globals.state.plotsceneseen.has('frostfordscene'):
			globals.events.frostfordscene()
			globals.state.plotsceneseen.append('frostfordscene')
			checkforevents = true
			return

	###---Added by Expansion---### Ank BugFix v4a
	if globals.state.sandbox == false && !$scene.is_visible_in_tree() && !$dialogue.is_visible_in_tree() && globals.state.decisions.has("haderelease") && !globals.state.plotsceneseen.has('hademelissa'):
		globals.events.hademelissa()
		globals.state.plotsceneseen.append('hademelissa')
		checkforevents = true
		return
	#Dim Crystal
	if !$scene.is_visible_in_tree() && !$dialogue.is_visible_in_tree() && !globals.state.plotsceneseen.has('dimcrystalinitiate') && globals.resources.day >= 2 && globals.state.sidequests.dimcrystal == 0:
		globals.events.dimcrystalinitiate()
		globals.state.plotsceneseen.append('dimcrystalinitiate')
		checkforevents = true
		return
	if !$scene.is_visible_in_tree() && !$dialogue.is_visible_in_tree() && globals.state.thecrystal.lifeforce < 0 && globals.state.thecrystal.mode == "light" && rand_range(0,100) <= globals.expansionsettings.crystal_shatter_chance:
		globals.events.dimcrystaldarkened()
		checkforevents = true
		return
	###---End Expansion---###
	if globals.itemdict.zoebook.amount >= 1 && globals.state.sidequests.zoe == 3 && randf() >= 0.5:
		globals.events.zoebookevent()
		checkforevents = true
		return
	startnewday()

func _on_headgirlbehavior_item_selected( ID ):
	var text = ''
	if ID == 0:
		globals.state.headgirlbehavior = 'none'
		text += "Headgirl will not interfere with others' business. "
	if ID == 1:
		globals.state.headgirlbehavior = 'kind'
		text += 'The Headgirl will focus on a kind approach and reduce the stress of others, trying to endorse acceptance of their master. '
	if ID == 2:
		globals.state.headgirlbehavior = 'strict'
		text += "Headgirl will focus on putting other servants in line at the cost of their stress. "
	var headgirl = null
	for i in globals.slaves:
		if i.work == 'headgirl':
			headgirl = i
	if headgirl == null:
		text += "\nCurrently you have no headgirl assigned. "
	else:
		text += headgirl.dictionary("\n$name is your current headgirl. ")
	get_node("mansionsettings/Panel/headgirldescript").set_bbcode(text)
	get_node("mansionsettings/Panel/foodbuy").set_value(globals.state.foodbuy)
	get_node("mansionsettings/Panel/manastock").set_value(globals.state.manastock)
	get_node("mansionsettings/Panel/manastock/manabuy").set_pressed(globals.state.manabuy)
	get_node("mansionsettings/Panel/supplykeep").set_value(globals.state.supplykeep)
	get_node("mansionsettings/Panel/supplykeep/supplybuy").set_pressed(globals.state.supplybuy)

func _on_manastock_value_changed(value):
	globals.state.manastock = get_node("mansionsettings/Panel/manastock").get_value()


func _on_manabuy_pressed():
	globals.state.manabuy = get_node("mansionsettings/Panel/manastock/manabuy").is_pressed()

func hide_everything():
	for i in get_tree().get_nodes_in_group("mansioncontrols"):
		i.hide()
	get_node("MainScreen/mansion/jailpanel").hide()
	get_node("MainScreen/slave_tab").hide()
	get_node("MainScreen/mansion/alchemypanel").hide()
	get_node("MainScreen/mansion/mansioninfo").hide()
	get_node("MainScreen/mansion/labpanel").hide()
	get_node("MainScreen/mansion/labpanel/labmodpanel").hide()
	get_node("MainScreen/mansion/librarypanel").hide()
	get_node("MainScreen/mansion/farmpanel").hide()
	get_node("MainScreen/mansion/selfinspect").hide()
	get_node("MainScreen/mansion/portalspanel").hide()
	get_node("MainScreen/mansion/upgradespanel").hide()
	###---Added by Expansion---###
	#---Headgirl
	get_node("MainScreen/mansion/AE_Headgirl_TextRect").visible = false
	#---DimCrystal
	get_node("MainScreen/mansion/AE_DimCrystal").visible = false
	get_node("MainScreen/mansion/dimcrystalpanel").hide()
	###---End Expansion---###
	globals.hidetooltip()

#---Keeping to have the "X is following you" for pet groups
func _on_mansion_pressed():
	var text = ''
	background_set('mansion')
	yield(self, 'animfinished')
	hide_everything()
	for i in get_tree().get_nodes_in_group("mansioncontrols"):
		i.show()
	get_node("outside/slavesellpanel").hide()
	get_node("outside/slavebuypanel").hide()
	get_node("outside/slaveguildquestpanel").hide()
	get_node("outside/slaveservicepanel").hide()
	get_node("outside").hide()
	get_node("hideui").hide()
	get_node("charlistcontrol").show()
	get_node("MainScreen").show()
	get_node("Navigation").show()
	$ResourcePanel.show()
	get_node("ResourcePanel/menu").disabled = false
	get_node("ResourcePanel/helpglossary").disabled = false
	get_node("MainScreen/mansion/sexbutton").set_disabled(globals.state.sexactions < 1 && globals.state.nonsexactions < 1)
	if globals.canloadimage(globals.player.imageportait):
		$Navigation/personal/TextureRect.texture = globals.loadimage(globals.player.imageportait)
	else:
		$Navigation/personal/TextureRect.texture = selftexture
	$ResourcePanel/clean.set_text(str(round(globals.state.condition)) + '%')
	
	if globals.state.farm >= 3:
		get_node("Navigation/farm").set_disabled(false)
	else:
		get_node("Navigation/farm").set_disabled(true)
	if globals.state.mansionupgrades.mansionlab > 0:
		get_node("Navigation/laboratory").set_disabled(false)
	else:
		get_node("Navigation/laboratory").set_disabled(true)
	music_set('mansion')
	if globals.state.sidequests.emily == 3:
		globals.events.emilymansion()
	if globals.state.capturedgroup.size() > 0:
		var array = globals.state.capturedgroup
		globals.state.capturedgroup = []
		var nojailcells = false
		for i in array:
			for k in i.gear.values():
				if k != null:
					globals.items.unequipitem(k, i, true)
			globals.slaves = i
			if globals.count_sleepers().jail < globals.state.mansionupgrades.jailcapacity:
				i.sleep = 'jail'
			else:
				nojailcells = true
		globals.itemdict['rope'].amount += globals.state.calcRecoverRope(array.size())
		text = "You have assigned your captives to the mansion. " + globals.fastif(nojailcells, '[color=yellow]You are out of free jail cells and some captives were assigned to the living room.[/color]', '')
		popup(text)
	build_mansion_info()
	rebuild_slave_list()

func build_mansion_info():
	var textnode = get_node("MainScreen/mansion/mansioninfo")
	var text
	textnode.show()
	var sleepers = globals.count_sleepers()

	text = 'You are at your mansion, which is located near [color=aqua]'+ globals.state.location.capitalize()+'[/color].\n\n'
	text += "Mansion is " + findLowestRange(conditionRanges, globals.state.condition) + "[/color]." 

	text += fillRoomText("\n\nYou have %s%s/%s[/color] bed%s occupied in the communal room.", sleepers.communal, globals.state.mansionupgrades.mansioncommunal, 's')
	text += fillRoomText("\nYou have %s%s/%s[/color] personal room%s assigned for living.", sleepers.personal, globals.state.mansionupgrades.mansionpersonal, 's')
	text += fillRoomText("\nYour bed is shared with %s%s/%s[/color] person%s besides you.", sleepers.your_bed, globals.state.mansionupgrades.mansionbed, 's')
	###---Added by Expansion---### Kennels Expanded | Kennel Sleep Location
	text += fillRoomText("\nYou have %s%s/%s[/color] person%s sleeping in the kennels.", sleepers.kennel, globals.state.mansionupgrades.mansionkennels, 's')
	###---End Expansion---###
	text += fillRoomText("\n\nYour jail has %s%s/%s[/color] cell%s filled.", sleepers.jail, globals.state.mansionupgrades.jailcapacity, 's')
	if globals.state.farm >= 3:
		text += fillRoomText("\nYour farm has %s%s/%s[/color] booth%s holding livestock.", sleepers.farm, variables.resident_farm_limit[globals.state.mansionupgrades.farmcapacity], 's')
	textnode.set_bbcode(text)

	###---Added by Expansion---### Combat Party Aren't Showing | Vanilla Bug? | Moved Location up here
	text += "\n\n[center][color=#d1b970]---------------Adventuring Party---------------[/color][/center]"
	if globals.state.playergroup.empty():
		text += "\n[color=red]Nobody is assigned to follow you.[/color]\n"
	else:
		for i in globals.state.playergroup.duplicate():
			var person = globals.state.findslave(i)
			if person != null:
				if person.loyal >= (person.obed+person.fear) * .55:
					text += "\n[color=lime]Loyal Companion[/color]"
				elif person.obed >= (person.loyal+person.fear) * .52:
					text += "\n[color=green]Subserviant Slave[/color]"
				elif person.fear >= (person.obed+person.loyal) * .5:
					text += "\n[color=red]Terrified Slave[/color]"
				else:
					text += "\nBegrudging Bodyguard"
				text += ":  " + createPersonURL(person) + "      |---|   Status   |---| " 
				if person.metrics.win > 0:
					text += "[color=aqua]" + str(person.metrics.win) + "[/color] Battles Won"
					if person.metrics.capture > 0:
						text += "; [color=aqua]" + str(person.metrics.capture) + "[/color] Enemies Captured"
				text += "\nAwareness: [color=aqua]" + str(person.awareness()) + "[/color]   |   Health: "
				if person.health >= person.stats.health_max*.8:
					text += "[color=lime]" + str(person.health) + "[/color] | [color=aqua]" + str(person.stats.health_max) + "[/color]"
				elif person.health >= person.stats.health_max*.4:
					text += "[color=green]" + str(person.health) + "[/color] | [color=aqua]" + str(person.stats.health_max) + "[/color]"
				else:
					text += "[color=red]" + str(person.health) + "[/color] | [color=aqua]" + str(person.stats.health_max) + "[/color]"
				text += "  |  Stress: "
				if person.stress >= person.stats.stress_max*.8:
					text += "[color=red]" + str(round(person.stress)) + "[/color] | [color=aqua]" + str(person.stats.stress_max) + "[/color]"
				elif person.stress >= person.stats.stress_max*.4:
					text += "[color=green]" + str(round(person.stress)) + "[/color] | [color=aqua]" + str(person.stats.stress_max) + "[/color]"
				else:
					text += "[color=lime]" + str(round(person.stress)) + "[/color] | [color=aqua]" + str(person.stats.stress_max) + "[/color]"
				text += "  |  Energy: "
				if person.energy >= person.stats.energy_max*.8:
					text += "[color=lime]" + str(round(person.energy)) + "[/color] | [color=aqua]" + str(person.stats.energy_max) + "[/color]"
				elif person.energy >= person.stats.energy_max*.4:
					text += "[color=green]" + str(round(person.energy)) + "[/color] | [color=aqua]" + str(person.stats.energy_max) + "[/color]"
				else:
					text += "[color=red]" + str(round(person.energy)) + "[/color] | [color=aqua]" + str(person.stats.energy_max) + "[/color]"
				if person.ability.size() > 2:
					text += "\nAbilities Known: [color=aqua]" + str(person.ability.size() -2) + "[/color]" 
					if person.learningpoints > 0:
						text += "     |    "
				if person.learningpoints > 0:
					text += "\n[color=lime]" + str(person.learningpoints) + "[/color][color=yellow] Learning Points Available[/color]"
				text += "\n"
	textnode.set_bbcode(text)
	###---End Expansion---###

	var jobdict = {headgirl = null, jailer = null, farmmanager = null, cooking = null, nurse = null, labassist = null}
	for i in globals.slaves:
		if jobdict.has(i.work) && i.away.at != 'hidden':
			jobdict[i.work] = i
	
	###---Added by Expansion---### Jobs Aren't Showing | Vanilla Bug?
	text += "\n\n[center][color=#d1b970]---------------Head Mansion Staff---------------[/color][/center]"
	if globals.slaves.size() >= 8:
		text += "\nHeadgirl: " + createPersonURL(jobdict.headgirl)
	text += "\nJailer: " + createPersonURL(jobdict.jailer)
	if globals.state.farm >= 3:
		text += "\nFarm Manager: " + createPersonURL(jobdict.farmmanager)
	text += "\nChef: " + createPersonURL(jobdict.cooking)
	text += "\nNurse: " + createPersonURL(jobdict.nurse)
	text += "\nLab Assistant: " + createPersonURL(jobdict.labassist)
	textnode.set_bbcode(text)
	###---End Expansion---###

	textnode.push_table(2)
	if globals.slaves.size() >= 8:
		addTableCell(textnode, "Headgirl: ", RichTextLabel.ALIGN_RIGHT)
		addTableCell(textnode, createPersonURL(jobdict.headgirl))
	addTableCell(textnode, "Jailer: ", RichTextLabel.ALIGN_RIGHT)
	addTableCell(textnode, createPersonURL(jobdict.jailer))
	if globals.state.farm >= 3:
		addTableCell(textnode, "Farm Manager: ", RichTextLabel.ALIGN_RIGHT)
		addTableCell(textnode, createPersonURL(jobdict.farmmanager))
	addTableCell(textnode, "Chef: ", RichTextLabel.ALIGN_RIGHT)
	addTableCell(textnode, createPersonURL(jobdict.cooking))
	addTableCell(textnode, "Nurse: ", RichTextLabel.ALIGN_RIGHT)
	addTableCell(textnode, createPersonURL(jobdict.nurse))
	if globals.state.mansionupgrades.mansionlab > 0:
		addTableCell(textnode, "Lab Assistant: ", RichTextLabel.ALIGN_RIGHT)
		addTableCell(textnode, createPersonURL(jobdict.labassist))
	textnode.pop()

	if globals.state.playergroup.empty():
		###---Added by Expansion---### Added in \n to break up the text for the Dimensional Crystal block
		textnode.append_bbcode("\nCombat Group:  Nobody is assigned to follow you.\n")
		###---End Expansion---###
	else:
		textnode.append_bbcode("\n")
		textnode.push_table(4)
		for column in ["Health", "Energy", "Stress", "Combat Group"]:
			addTableCell(textnode, column)
		for column in ["~~~~~~~~~~~  ", "~~~~~~~~~  ", "~~~~~~~~~~~  ", "~~~~~~~~~~~~~~~~~  "]:
			addTableCell(textnode, column)
		for i in globals.state.playergroup.duplicate():
			var person = globals.state.findslave(i)
			if person != null:
				var temp = [findLowestRange( stateRangeDict.health, float(person.stats.health_cur)/person.stats.health_max),
					findLowestRange( stateRangeDict.energy, float(person.stats.energy_cur)/person.stats.energy_max), findLowestRange( stateRangeDict.stress, person.stress), createPersonURL(person)]
				#addTableCell(textnode, +"   ", RichTextLabel.ALIGN_RIGHT)	
				for column in temp:
					addTableCell(textnode, column)
			else:
				globals.state.playergroup.erase(i)
		textnode.pop()
	
	###---Added by Expansion---### Facilities Text Descriptions
	if globals.expansionsettings.show_facilities_details_in_mansion == true:
		text += "\n\n[center][color=#d1b970]---------------Facilities Details---------------[/color][/center]"
		
		#---Training Grounds
		if globals.state.mansionupgrades.traininggrounds > 0:
			text += "\n\n[color=#d1b970]-----Training Grounds------[/color] [color=aqua](" + str(globals.state.mansionupgrades.traininggrounds) + ")[/color]\n"
			text += "Outside of the mansion, a cleared section of the field is surrounded by a thin wooden fence. "
			if globals.state.mansionupgrades.traininggrounds >= 4:
				text += "Inside of the fence a few hay bales, training dummies, sandbags, crystal reflectors, and crates are set up to allow people to train their combat skills effectively. The side of the crate has a label reading Training Manuals."
				text += "\nThe [color=aqua]Trainer[/color] and [color=aqua]Trainee[/color] jobs are [color=lime]Unlocked[/color].\n[color=aqua]Training XP is Level Difference * 4 and the Chance to gain Learning Points becomes 20 + (Trainer Wit & Confidence/2) + (Trainee Wit & Courage/2).[/color]\nMax [color=aqua]Learning Points[/color] gained per person per day is [color=aqua]20[/color]."
			elif globals.state.mansionupgrades.traininggrounds >= 3:
				text += "Inside of the fence a few hay bales, training dummies and sandbags are set up to allow people to train their combat skills effectively."
				text += "\nThe [color=aqua]Trainer[/color] and [color=aqua]Trainee[/color] jobs are [color=lime]Unlocked[/color].\n[color=aqua]Training XP is Level Difference * 3 and the Chance to gain Learning Points becomes 10 + (Trainer Wit & Confidence/2) + (Trainee Wit & Courage/2).[/color]\nMax [color=aqua]Learning Points[/color] gained per person per day is [color=aqua]15[/color]."
			elif globals.state.mansionupgrades.traininggrounds >= 2:
				text += "Inside of the fence a few hay bales, training dummies and sandbags are set up to allow people to train their combat skills effectively."
				text += "\nThe [color=aqua]Trainer[/color] and [color=aqua]Trainee[/color] jobs are [color=lime]Unlocked[/color].\n[color=aqua]Training XP is Level Difference * 2 and the Chance to gain Learning Points becomes 10 + (Trainer Wit & Confidence/2) + (Trainee Wit & Courage/2).[/color]\nMax [color=aqua]Learning Points[/color] gained per person per day is [color=aqua]10[/color]."
			else:
				text += "Inside of the fence a few hay bales, training dummies and sandbags are set up to allow people to train their combat skills effectively."
				text += "\nThe [color=aqua]Trainer[/color] and [color=aqua]Trainee[/color] jobs are [color=lime]Unlocked[/color].\n[color=aqua]Training XP is Level Difference and the Chance to gain Learning Points is (Trainer Wit & Confidence/2) + (Trainee Wit & Courage/2).[/color]\nMax [color=aqua]Learning Points[/color] gained per person per day is [color=aqua]5[/color]."
	
#	Dreams?
#	text += "\nSome report having seen faint visions inside of the Crystal's hardened shell, flashing inside of the glow. You have not seen it. Though you don't understand the Crystal, everyone seems to enjoy it. You love having the Crystal."
#	text += "\nYou have heard that some slaves are reporting dreams of the Crystal in the dead of night. They can never recall what the Crystal did in their dreams, merely that it was there watching them and sensing every thought."
	textnode.set_bbcode(text)
	
	#---Headgirl Portrait
	if jobdict.headgirl != null && jobdict.headgirl.imageportait != null && globals.loadimage(jobdict.headgirl.imageportait):
		get_node("MainScreen/mansion/AE_Headgirl_TextRect").visible = true
		get_node("MainScreen/mansion/AE_Headgirl_TextRect/portrait").set_texture(globals.loadimage(jobdict.headgirl.imageportait))
	else:
		get_node("MainScreen/mansion/AE_Headgirl_TextRect").visible = false
		get_node("MainScreen/mansion/AE_Headgirl_TextRect/portrait").set_texture(globals.loadimage(globals.sexuality_images.unknown))
	#---Dimensional Crystal
	if globals.state.sidequests.dimcrystal == 0:
		get_node("MainScreen/mansion/AE_DimCrystal").visible = false
	else:
		if globals.state.mansionupgrades.dimensionalcrystal >= 6:
			get_node("MainScreen/mansion/AE_DimCrystal").set_normal_texture(globals.loadimage("res://files/aric_expansion_images/dimensional_crystal/button_images/crystal_6_transparent.png"))
			get_node("MainScreen/mansion/AE_DimCrystal").set_hover_texture(globals.loadimage("res://files/aric_expansion_images/dimensional_crystal/button_images/crystal_6_transparent.png"))
			get_node("MainScreen/mansion/AE_DimCrystal").set_pressed_texture(globals.loadimage("res://files/aric_expansion_images/dimensional_crystal/button_images/crystal_6_transparent.png"))
		elif globals.state.mansionupgrades.dimensionalcrystal == 5:
			get_node("MainScreen/mansion/AE_DimCrystal").set_normal_texture(globals.loadimage("res://files/aric_expansion_images/dimensional_crystal/button_images/crystal_5_transparent.png"))
			get_node("MainScreen/mansion/AE_DimCrystal").set_hover_texture(globals.loadimage("res://files/aric_expansion_images/dimensional_crystal/button_images/crystal_5_transparent.png"))
			get_node("MainScreen/mansion/AE_DimCrystal").set_pressed_texture(globals.loadimage("res://files/aric_expansion_images/dimensional_crystal/button_images/crystal_5_transparent.png"))
		elif globals.state.mansionupgrades.dimensionalcrystal == 4:
			get_node("MainScreen/mansion/AE_DimCrystal").set_normal_texture(globals.loadimage("res://files/aric_expansion_images/dimensional_crystal/button_images/crystal_4_transparent.png"))
			get_node("MainScreen/mansion/AE_DimCrystal").set_hover_texture(globals.loadimage("res://files/aric_expansion_images/dimensional_crystal/button_images/crystal_4_transparent.png"))
			get_node("MainScreen/mansion/AE_DimCrystal").set_pressed_texture(globals.loadimage("res://files/aric_expansion_images/dimensional_crystal/button_images/crystal_4_transparent.png"))
		elif globals.state.mansionupgrades.dimensionalcrystal == 3:
			get_node("MainScreen/mansion/AE_DimCrystal").set_normal_texture(globals.loadimage("res://files/aric_expansion_images/dimensional_crystal/button_images/crystal_3_transparent.png"))
			get_node("MainScreen/mansion/AE_DimCrystal").set_hover_texture(globals.loadimage("res://files/aric_expansion_images/dimensional_crystal/button_images/crystal_3_transparent.png"))
			get_node("MainScreen/mansion/AE_DimCrystal").set_pressed_texture(globals.loadimage("res://files/aric_expansion_images/dimensional_crystal/button_images/crystal_3_transparent.png"))
		elif globals.state.mansionupgrades.dimensionalcrystal == 2:
			get_node("MainScreen/mansion/AE_DimCrystal").set_normal_texture(globals.loadimage("res://files/aric_expansion_images/dimensional_crystal/button_images/crystal_2_transparent.png"))
			get_node("MainScreen/mansion/AE_DimCrystal").set_hover_texture(globals.loadimage("res://files/aric_expansion_images/dimensional_crystal/button_images/crystal_2_transparent.png"))
			get_node("MainScreen/mansion/AE_DimCrystal").set_pressed_texture(globals.loadimage("res://files/aric_expansion_images/dimensional_crystal/button_images/crystal_2_transparent.png"))
		else:
			get_node("MainScreen/mansion/AE_DimCrystal").set_normal_texture(globals.loadimage("res://files/aric_expansion_images/dimensional_crystal/button_images/crystal_1_transparent.png"))
			get_node("MainScreen/mansion/AE_DimCrystal").set_hover_texture(globals.loadimage("res://files/aric_expansion_images/dimensional_crystal/button_images/crystal_1_transparent.png"))
			get_node("MainScreen/mansion/AE_DimCrystal").set_pressed_texture(globals.loadimage("res://files/aric_expansion_images/dimensional_crystal/button_images/crystal_1_transparent.png"))
		get_node("MainScreen/mansion/AE_DimCrystal").visible = true
	###---End Expansion---###
	
	if (globals.slaves.size() >= 8 && jobdict.headgirl != null) || globals.developmode == true:
		get_node("charlistcontrol/slavelist").show()
	else:
		get_node("charlistcontrol/slavelist").hide()

#---The Dimensional Crystal
func _on_dimcrystal_button_pressed():
	get_node("MainScreen/mansion/dimcrystalpanel").show()
	var text = ""
	var refCrystal = globals.state.thecrystal
	var buttonnode

	#Build Stats
	_on_dimcrystal_showstats_pressed()
	#Build Description
	_on_dimcrystal_description_pressed()
	
	#---Build Background Image
	var crystal_image = "dull"
	var textnode = get_node("MainScreen/mansion/dimcrystalpanel/description")
	if refCrystal.mode == "light" && globals.state.mansionupgrades.dimensionalcrystal > 0:
		crystal_image = "light"
	elif refCrystal.mode == "dark" && globals.state.mansionupgrades.dimensionalcrystal > 0:
		crystal_image = "dark"
	#Power Level
	if globals.state.mansionupgrades.dimensionalcrystal == 1:
		crystal_image += "1"
	elif globals.state.mansionupgrades.dimensionalcrystal == 2:
		crystal_image += "2"
	elif globals.state.mansionupgrades.dimensionalcrystal >= 3:
		crystal_image += "3"
	get_node("MainScreen/mansion/dimcrystalpanel/background").set_texture(globals.loadimage(globals.dimcrystal_images[crystal_image]))
	
	#---Research
	textnode = get_node("MainScreen/mansion/dimcrystalpanel/research_text")
	text = "[color=#008BFB]Research[/color] is the chance of discovering a new Crystal Ability that night if there are any more available abilities at the Crystal's current [color=#d1b970]Upgrade Level[/color]. You will need to assign a [color=aqua]Crystal Researcher[/color] via the [color=aqua]Jobs[/color] panel to make any progress in unlocking abilities. They must have a [color=aqua]Magical Affinity[/color] equal to or greater than the [color=aqua]Crystal's[/color] [color=#d1b970]Upgrade Level[/color] to understand any of the the mystical properties of the magical artifact. "
	#Attunement
	if globals.state.thecrystal.abilities.size() > 0 && !globals.state.thecrystal.abilities.has('attunement'):
		text += "\n[color=green]Inspiration[/color]: You think that you can [color=aqua]Attune[/color] yourself to the [color=#E389B9]Crystal[/color]. "
	#Preg Speed
	if globals.state.mansionupgrades.dimensionalcrystal >= 1 && !globals.state.thecrystal.abilities.has('pregnancyspeed'):
		text += "\n[color=green]Inspiration[/color]: You know that the [color=#E389B9]Crystal[/color] can affect the [color=aqua]Speed of Pregnancies[/color], but are not yet sure how to make it work. "
	#Empower Virginity
	if globals.state.mansionupgrades.dimensionalcrystal >= 1 && !globals.state.thecrystal.abilities.has('empowervirginity'):
		text += "\n[color=green]Inspiration[/color]: You know that the [color=#E389B9]Crystal[/color] can affect the [color=aqua]flow of Mana related to Sex Scenes[/color], but are not yet sure how to make it work. "
	#Second Wind
	if globals.state.mansionupgrades.dimensionalcrystal >= 2 && !globals.state.thecrystal.abilities.has('secondwind'):
		text += "\n[color=green]Inspiration[/color]: You think you may be able to learn how to make the [color=#E389B9]Crystal[/color] to revive you and your slaves to half health from a fatal blow in combat once per day."
	#Death Prevention
	if globals.state.mansionupgrades.dimensionalcrystal >= 3 && !globals.state.thecrystal.abilities.has('immortality'):
		text += "\n[color=green]Inspiration[/color]: You believe that the [color=#E389B9]Crystal[/color] can grant [color=aqua]Immortality[/color], but are not yet sure how."
	#Sacrifice
	if globals.state.thecrystal.mode == "dark" && !globals.state.thecrystal.abilities.has('sacrifice'):
		text += "\n[color=red]Dark Inspiration[/color]: There must be some way to [color=red]Sacrifice[/color] something to the [color=#E389B9]Crystal[/color] to sate its [color=aqua]Hunger[/color] for [color=aqua]Lifeforce[/color], but you are not yet sure how to do that."
	textnode.set_bbcode(text)
	textnode.show()
	
	#---Research Button
	var researcher = globals.expansion.getCrystalResearcher()
	if researcher == null:
		get_node("MainScreen/mansion/dimcrystalpanel/assistresearch").set_disabled(true)
		get_node("MainScreen/mansion/dimcrystalpanel/assistresearch").set_tooltip("No one is assigned to the Crystal Researcher position")
	elif globals.state.nonsexactions <= 0:
		get_node("MainScreen/mansion/dimcrystalpanel/assistresearch").set_disabled(true)
		get_node("MainScreen/mansion/dimcrystalpanel/assistresearch").set_tooltip("Not enough Non-Sex Interactions remaining to Assist Researcher")
	else:
		get_node("MainScreen/mansion/dimcrystalpanel/assistresearch").set_disabled(false)
		get_node("MainScreen/mansion/dimcrystalpanel/assistresearch").set_tooltip("Spend 1 Non-Sex Interaction to set the Researcher's Total Wits as today's Research Chance")
	
	#---Abilities
	textnode = get_node("MainScreen/mansion/dimcrystalpanel/abilities_text")
	text = "[center][color=#d1b970]Abilities[/color][/center]\n"
	if globals.state.thecrystal.abilities.empty():
		text += "[center]All [color=aqua]Abilities[/color] of the [color=#E389B9]Crystal[/color] remain a mystery to you.[/center]"
	else:
		text += "[center][color=#008BFB]Researched Powers[/color][/center]"
	#Reset Buttons & Finish
	reset_dimcrystal_ability_buttons()
	textnode.set_bbcode(text)
	textnode.show()
	
	return

func reset_dimcrystal_ability_buttons():
	var refCrystal = globals.state.thecrystal
	#Description
	get_node("MainScreen/mansion/dimcrystalpanel/description_button").set_disabled(false)
	get_node("MainScreen/mansion/dimcrystalpanel/research_explanation").set_disabled(false)
	
	#Abilities Test
	var moreabilitiesexist = false
	var allabilities = globals.expansion.dimcrystal_abilities_array
	for abilitycheck in allabilities:
		if !refCrystal.abilities.has(abilitycheck):
			moreabilitiesexist = true
			break
	if moreabilitiesexist == true && globals.state.nonsexactions > 0:
		get_node("MainScreen/mansion/dimcrystalpanel/assistresearch").set_disabled(false)
	else:
		get_node("MainScreen/mansion/dimcrystalpanel/assistresearch").set_disabled(true)
		if globals.state.nonsexactions > 0:
			get_node("MainScreen/mansion/dimcrystalpanel/assistresearch").set_tooltip("Not enough Non-Sex Interactions remaining to Assist Researcher")
		else:
			get_node("MainScreen/mansion/dimcrystalpanel/assistresearch").set_tooltip("There are no more Abilities to Research currently")
	
	#Attunement
	if refCrystal.abilities.has('attunement'):
		get_node("MainScreen/mansion/dimcrystalpanel/ability_attune").set_disabled(false)
	else:
		get_node("MainScreen/mansion/dimcrystalpanel/ability_attune").set_disabled(true)
		get_node("MainScreen/mansion/dimcrystalpanel/ability_attune").set_tooltip("Try Researching the Crystal")
	#Pregnancy Speeds
	get_node("MainScreen/mansion/dimcrystalpanel/ability_pregspeed_enable").hide()
	if refCrystal.abilities.has('pregnancyspeed'):
		get_node("MainScreen/mansion/dimcrystalpanel/ability_pregspeed").set_disabled(false)
		get_node("MainScreen/mansion/dimcrystalpanel/ability_pregspeed_enable").set_disabled(false)
	else:
		get_node("MainScreen/mansion/dimcrystalpanel/ability_pregspeed").set_disabled(true)
		get_node("MainScreen/mansion/dimcrystalpanel/ability_pregspeed").set_tooltip("Requires Upgrade Level 1")
	#Empower Virginity
	get_node("MainScreen/mansion/dimcrystalpanel/ability_empowervirginityenable").hide()
	get_node("MainScreen/mansion/dimcrystalpanel/ability_empowervirginitydisable").hide()
	if refCrystal.abilities.has('empowervirginity'):
		get_node("MainScreen/mansion/dimcrystalpanel/ability_empowervirginity").set_disabled(false)
	else:
		get_node("MainScreen/mansion/dimcrystalpanel/ability_empowervirginity").set_disabled(true)
		get_node("MainScreen/mansion/dimcrystalpanel/ability_empowervirginity").set_tooltip("Requires Upgrade Level 1")	
	#Second Wind (1/Day Combat Revive)
	if refCrystal.abilities.has('secondwind'):
		get_node("MainScreen/mansion/dimcrystalpanel/ability_secondwind").set_disabled(false)
	else:
		get_node("MainScreen/mansion/dimcrystalpanel/ability_secondwind").set_disabled(true)
		get_node("MainScreen/mansion/dimcrystalpanel/ability_secondwind").set_tooltip("Requires Upgrade Level 2")
	#Immortality
	if refCrystal.abilities.has('immortality'):
		get_node("MainScreen/mansion/dimcrystalpanel/ability_immortality").set_disabled(false)
	else:
		get_node("MainScreen/mansion/dimcrystalpanel/ability_immortality").set_disabled(true)
		get_node("MainScreen/mansion/dimcrystalpanel/ability_immortality").set_tooltip("Requires Upgrade Level 3")
	get_node("MainScreen/mansion/dimcrystalpanel/ability_immortality_enable").hide()
	get_node("MainScreen/mansion/dimcrystalpanel/ability_immortality_disable").hide()
	
	#Sacrifice (Restore Lifeforce)
	if refCrystal.abilities.has('sacrifice'):
		get_node("MainScreen/mansion/dimcrystalpanel/ability_understandsacrifice").show()
		get_node("MainScreen/mansion/dimcrystalpanel/ability_understandsacrifice").set_disabled(false)
		get_node("MainScreen/mansion/dimcrystalpanel/ability_choosesacrifice").show()
		get_node("MainScreen/mansion/dimcrystalpanel/ability_choosesacrifice").set_disabled(false)
	else:
		get_node("MainScreen/mansion/dimcrystalpanel/ability_understandsacrifice").hide()
		get_node("MainScreen/mansion/dimcrystalpanel/ability_understandsacrifice").set_disabled(true)
		get_node("MainScreen/mansion/dimcrystalpanel/ability_choosesacrifice").hide()
		get_node("MainScreen/mansion/dimcrystalpanel/ability_choosesacrifice").set_disabled(true)
	
	#Hide PregSpeed Panel
	nodeChangePregSpeed.hide()

func _on_dimcrystal_showstats_pressed():
	var refCrystal = globals.state.thecrystal
	var text = ""
	var textnode = get_node("MainScreen/mansion/dimcrystalpanel/scroll_text")
	var researcher = globals.expansion.getCrystalResearcher()
	text = "[color=#d1b970]Upgrade Level[/color]     "+ str(globals.state.mansionupgrades.dimensionalcrystal) + "\n"
	var displayedresearch = str(refCrystal.research)
	if refCrystal.research <= 0:
		if researcher == null:
			displayedresearch = "0\nNo Researcher"
		else:
			displayedresearch = str(researcher.smaf) + " - " + str(researcher.wit)
	text += "[color=#008BFB]Research %[/color]           "+ globals.fastif(refCrystal.research >= 50, "[color=lime]", "[color=red]") + displayedresearch + "[/color]\n"
	if refCrystal.abilities.has('attunement'):
		text += "[color=#65CD72]Lifeforce[/color]                "+ globals.fastif(refCrystal.lifeforce > 0, "[color=lime]", "[color=red]") + str(refCrystal.lifeforce) + "[/color]\n"
		if refCrystal.mode == "dark" && refCrystal.hunger > 0:
			text += "[color=#AE0000]Hunger[/color]                   "+ globals.fastif(refCrystal.lifeforce >= 0 && refCrystal.hunger <= 0 && refCrystal.mode == "dark", "[color=lime]", "[color=red]") + str(refCrystal.hunger) + "[/color]\n"
		else:
			text += "\n"
		text += "[center][color=#d1b970]Status[/color][/center]\n"+ globals.fastif(refCrystal.mode == "light", "[center][color=#1CB4B0]Light[/color][/center]", "[center][color=#B42E1C]Dark[/color][/center]")
	else:
		text += "\n[center]The [color=#E389B9]Crystal[/color] is still a mystery you aren't [color=red]Attuned[/color] to yet.[/center]"
	textnode.set_bbcode(text)
	textnode.show()

func _on_dimcrystal_assistresearcher_pressed():
	var refCrystal = globals.state.thecrystal
	var text = ""
	var textnode = get_node("MainScreen/mansion/dimcrystalpanel/description")
	var researcher = globals.expansion.getCrystalResearcher()
	if researcher == null:
		print("Invalid, No Researcher Available")
		text = "There is no [color=#008BFB]Researcher[/color] currently assigned for you to assist in [color=#008BFB]Researching[/color] the [color=#E389B9]Dimensional Crystal[/color].\n\nYou can assign a suitable candidate via the standard [color=aqua]Jobs[/color] menu on any [color=aqua]slave's[/color] sheet."
	elif globals.state.nonsexactions > 0 && researcher.dailyevents.count('assistedresearch') < 1:
		text = researcher.dictionary("You walk to the [color=#E389B9]Dimensional Crystal[/color] where [color=aqua]$name[/color] is diligently focused on studying one of the energy tendrils of the humming, floating [color=#E389B9]Crystal[/color]. $He looks up and smiles at you." + researcher.quirk("\n[color=yellow]-Have you come to assist me, $master? I think we can make a lot of progress together![/color]"))
		researcher.dailyevents.append('assistedresearch')
		if globals.player.smaf + researcher.smaf >= globals.state.mansionupgrades.dimensionalcrystal:
			globals.state.nonsexactions -= 1
			refCrystal.research = researcher.wit
			text += researcher.dictionary("\n\nYou both study the [color=#E389B9]Crystal[/color] together for some time and believe you are able to understand it. You realize that [color=aqua]$name[/color] is doing the very best $he can to impress you while you are there and that you now have a [color=aqua]" + str(refCrystal.research) + " Percent[/color] chance to make a new Discovery tonight.")
			researcher.loyal += round(rand_range(1, researcher.smaf))
		else:
			text += researcher.dictionary("\n\nYou and [color=aqua]$name[/color] try your very best to study and understand the [color=#E389B9]Crystal[/color] together, but every time either of you attempts to touch or interact with the mystical tendrils of magic flowing from it, you end up with a searing, overpowering headache. You realize one of you will have to have a greater [color=aqua]affinity[/color] with [color=aqua]magic[/color] to make any real progress or the inherent power of the [color=#E389B9]Crystal[/color] will continue to overpower you. Fortunately, you realize this early enough to not waste too much time on it today.\n[color=aqua]No Interactions were lost.[/color]")
			get_node("MainScreen/mansion/dimcrystalpanel/assistresearch").set_disabled(true)
			get_node("MainScreen/mansion/dimcrystalpanel/assistresearch").set_tooltip("You just actively researched the crystal.")
			###TBK - Add in "Fail Event" later (accidental sacrifice)
	else:
		if globals.state.nonsexactions <= 0:
			text = "[color=red][center]You do not have enough [color=aqua]Non-Sexual Actions[/color] left today to research the [color=#E389B9]Crystal[/color].[/center][/color]"
		else:
			text = "[color=red][center]You already assisted your [color=aqua]Researcher[/color] today.[/center][/color]"
	
	#Reset, Disable Buttons, Finish
	reset_dimcrystal_ability_buttons()
	_on_dimcrystal_showstats_pressed()
	textnode.set_bbcode(text)
	textnode.show()

func _on_dimcrystal_explainresearch_pressed():
	var refCrystal = globals.state.thecrystal
	var text = ""
	var textnode = get_node("MainScreen/mansion/dimcrystalpanel/description")
	
	text = "When you first find it, the [color=#E389B9]Dimensional Crystal[/color] has minimal power and no [color=aqua]Abilities[/color]. You can gain powerful [color=aqua]Abilities[/color] by spending time and effort [color=#008BFB]researching[/color] the mystical [color=#E389B9]Dimensional Crystal[/color]. Many [color=aqua]Abilities[/color] are only available at certain power levels, meaning that you must upgrade the [color=#E389B9]Crystal[/color] in the standard [color=aqua]Upgrade Menu[/color] to gain access to stronger [color=aqua]Abilities[/color].\n\nTo [color=#008BFB]Research[/color] the [color=#E389B9]Crystal[/color], you must first assign a [color=#008BFB]researcher[/color] in the standard [color=aqua]Job Panel[/color]. That [color=#008BFB]researcher[/color] requires a [color=aqua]Magic Affinity[/color] equal to or greater than the [color=#008BFB]Upgrade Level[/color] (ie: power) of the [color=#E389B9]Crystal[/color] itself. This [color=#008BFB]researcher[/color] has a chance to discover new [color=aqua]Abilities[/color] from the available possibilities at the current [color=#008BFB]Upgrade Level[/color] each night when you click [color=aqua]End of Day[/color].\n\nThere are two methods with which your assigned [color=#008BFB]researcher[/color] can [color=#008BFB]Research[/color] the [color=#E389B9]Dimensional Crystal[/color]: [color=aqua]Assisted[/color] or [color=aqua]Unassisted[/color].\n[color=aqua]Unassisted[/color] [color=#008BFB]research[/color] is simply the daily effort of your [color=#008BFB]researcher[/color] to unlock [color=aqua]abilities[/color] from the [color=#E389B9]Crystal[/color] with no required active effort or cost from you. As long as there is a slave assigned to the position of [color=#008BFB]Crystal Researcher[/color] and you did not Actively Assist the [color=#008BFB]researcher[/color] that day, they will have a random chance anywhere between their [color=aqua]magical affinity[/color] and their [color=aqua]Wits[/color] as their chance of success at making a discovery. Again, they must have a [color=aqua]Magical Affinity[/color] equal or greater to the [color=aqua]Crystal's[/color] current [color=#d1b970]Upgrade Level[/color] to succeed. \n\n[color=aqua]Assisted[/color] [color=#008BFB]research[/color] indicates you taking an active role in helping your slave uncover the [color=aqua]Crystal's[/color] secrets. This consumes [color=red]1 Non-Sex Interaction[/color] as you spend some of your limited time out of the day on the project, however you will immediately apply the assigned slave's [color=aqua]Total Wits[/color] as their chance of success of a discovery that night. You and your assigned [color=#008BFB]researcher[/color] must have a combined [color=aqua]Magical Affinity[/color] equal to or greater than the [color=aqua]Crystal's[/color] [color=#d1b970]Upgrade Level[/color] to succeed.\n\nHint: This method of working together is a great way to [color=#008BFB]research[/color] the [color=#E389B9]Crystal[/color] at its higher levels without needing a slave with overwhelming [color=aqua]Magical Affinity[/color] on their own as you can suppliment it with your own magic."
	
	#Reset, Disable Buttons, Finish
	reset_dimcrystal_ability_buttons()
	get_node("MainScreen/mansion/dimcrystalpanel/research_explanation").set_disabled(true)
	textnode.set_bbcode(text)
	textnode.show()

func _on_dimcrystal_description_pressed():
	var refCrystal = globals.state.thecrystal
	var text = ""
	var textnode = get_node("MainScreen/mansion/dimcrystalpanel/description")
	text = "The [color=#E389B9]Dimensional Crystal[/color] is located in the hallways beneath the mansion. It is directly at the center of the mansion and seems to be at exactly an equal distance from each end of the mansion's grounds. It seems to be a massive, perfectly symmetrical prism made out of a material that no one has been able to identify. "
	if refCrystal.mode == "light" && globals.state.mansionupgrades.dimensionalcrystal > 0:
		text += "\nIt eminates a bright, violet light that radiates around it warmly. "
	elif refCrystal.mode == "dark" && globals.state.mansionupgrades.dimensionalcrystal > 0:
		text += "\nIt eminates a dark, purplish light that is split with shadowy tendrils running through it like writhing cracks. "
	#Upgrade/Power
	if globals.state.mansionupgrades.dimensionalcrystal <= 0:
		text += "\nIt seems to be dull and lifeless, but catches and reflects the occassional candlelight that strikes it."
	elif globals.state.mansionupgrades.dimensionalcrystal == 1:
		text += "\n\nThe glow seems to pulse with the rhythm of a weak heart. You occassionally see wisps of the same color radiating off of pregnancy women inside of the mansion."
	elif globals.state.mansionupgrades.dimensionalcrystal == 2:
		text += "\n\nThe [color=#E389B9]Crystal[/color] pulses far more steadily recently and accompanies the glow with a light humming noise. You see wisps of the purplish glow it lets off trailing behind people all throughout the day as it works its strange magic on the Mansion's inhabitants."
	elif globals.state.mansionupgrades.dimensionalcrystal == 3:
		text += "\n\nThe [color=#E389B9]Dimensional Crystal[/color] pulses and hums slightly louder than it once did. You see the occassional flash of light come from it's chamber and feel a sense of peace at knowing that it is there and finally awakening once more."
	elif globals.state.mansionupgrades.dimensionalcrystal >= 4:
		text += "\n\nThe [color=#E389B9]Crystal[/color] pulses violently now and the low hum can be heard throughout the entire Mansion. Though it can grow irritating at times, you find that you quickly came to ignore the background noise. "
	#Hunger
	if globals.state.thecrystal.mode == "dark":
		if globals.state.thecrystal.power + globals.state.thecrystal.hunger >= globals.player.smaf:
			text += "\nIt is hard to look directly at the [color=#E389B9]Crystal[/color] without feeling drawn to press your hand against it. It beckons you closer with its dark, shadowy tendrils whipping towards you. A small voice in the back of your mind screams out that if you touch dare to touch it right now, it will drain you of your very soul. "
		elif globals.state.thecrystal.hunger > 0:
			text += "\nYou have a sense of unease when gazing into the Crystal. You feel a longing to consume. A growling hunger stirs within the longer you gaze at it. "
	
	#Reset, Disable Buttons, Finish
	reset_dimcrystal_ability_buttons()
	get_node("MainScreen/mansion/dimcrystalpanel/description_button").set_disabled(true)
	textnode.set_bbcode(text)
	textnode.show()

func _on_dimcrystal_ability_attunement_pressed():
	var refCrystal = globals.state.thecrystal
	var text = ""
	var textnode = get_node("MainScreen/mansion/dimcrystalpanel/description")
	if globals.state.thecrystal.abilities.has('attunement'):
		text += "You understand the basic properties of the [color=#E389B9]Crystal[/color] and can feel the pulse within it. "
		#Color
		text += "\n    [color=#d1b970]Color[/color]: " + globals.fastif(globals.state.thecrystal.mode == "light", "[color=aqua]Light[/color]", "[color=red]Dark[/color]")
		if globals.state.thecrystal.mode == "dark":
			text += "\n\nThe [color=#E389B9]Crystal[/color] is [color=red]Dark[/color], so there is a chance that it may consume a [color=aqua]Researcher[/color] to sate its [color=aqua]Hunger[/color] by an amount equal to their [color=aqua]Level[/color] and [color=aqua]1 Lifeforce[/color]. If it has no [color=aqua]Hunger[/color] and [color=aqua]0+ Lifeforce[/color], it may repair itself."
		#Lifeforce
		text += "\n    [color=#d1b970]Lifeforce[/color]: " + globals.fastif(globals.state.thecrystal.lifeforce >= 0, "[color=lime]" +str(globals.state.thecrystal.lifeforce) + "[/color]", "[color=red]" +str(globals.state.thecrystal.lifeforce) + "[/color]")
		if globals.state.thecrystal.mode == "light":
			text += "\n\nThe [color=#E389B9]Crystal[/color] may grow [color=red]Dark[/color] if it ever has negative [color=aqua]Lifeforce[/color]. It will restore [color=aqua]1 Lifeforce[/color] Daily. If it is still below its [color=aqua]Level[/color], it has a [color=aqua]Chance[/color] to gain [color=aqua]+2[/color] equal to a [color=aqua]Researcher's Wits[/color] as long as they are over a minimum of [color=aqua]40[/color]."
		else:
			text += "\n\nThe [color=#E389B9]Crystal[/color] will not restore any [color=aqua]Lifeforce[/color] Daily and must be fed slaves to recover [color=aqua]Lifeforce[/color]."
		#Hunger
		if globals.state.thecrystal.hunger != 0:
			text += "\n    [color=#d1b970]Hunger[/color]: " + globals.fastif(globals.state.thecrystal.hunger > 0, "[color=red]" +str(globals.state.thecrystal.hunger) + "[/color]", "[color=lime]" +str(globals.state.thecrystal.hunger) + "[/color]")
			text += "; The [color=#E389B9]Crystal[/color] will consume [color=aqua]Lifeforce[/color] daily equal to its [color=aqua]Hunger[/color]. "
			if globals.state.thecrystal.mode == "dark":
				text += "Its [color=aqua]Hunger[/color] grows by [color=red]1[/color] Daily. It must have a [color=aqua]Hunger[/color] of [color=aqua]0 or less[/color] to turn [color=aqua]Light[/color] again."
	
	#Reset, Disable Buttons, Finish
	reset_dimcrystal_ability_buttons()
	get_node("MainScreen/mansion/dimcrystalpanel/ability_attune").set_disabled(true)
	textnode.set_bbcode(text)
	textnode.show()

#Empowered Virginities
func _on_dimcrystal_ability_empoweredvirginity_pressed():
	var refCrystal = globals.state.thecrystal
	var text = ""
	var textnode = get_node("MainScreen/mansion/dimcrystalpanel/description")
	if refCrystal.abilities.has('empowervirginity'):
		text += "You have been granted the secret of [color=green]Empowering Virginities[/color] with mana. You may now ask the Crystal to give a [color=green]stacking multiplier of 5x the normal mana produced[/color] at the end of a sexual encounter in the Mansion for [color=green]any virginities taken[/color], but you will lose [color=red]half of the mana normally produced[/color] when [color=red]they lose neither vaginal or anal virginities during sex[/color]. It seems as though activating this is a risk weighted against the quality of dedicated long term sexual partners over the quantity of far more temporary, less experienced ones."
		if refCrystal.empoweredvirginity == true:
			text += "\n\nThis ability is currently [color=lime]Enabled[/color]."
		else:
			text += "\n\nThis ability is currently [color=red]Disabled[/color]."
	#Reset, Disable Buttons, Finish
	reset_dimcrystal_ability_buttons()
	get_node("MainScreen/mansion/dimcrystalpanel/ability_empowervirginity").set_disabled(true)
	#Set Toggle
	if refCrystal.empoweredvirginity == true:
		get_node("MainScreen/mansion/dimcrystalpanel/ability_empowervirginitydisable").show()
	else:
		get_node("MainScreen/mansion/dimcrystalpanel/ability_empowervirginityenable").show()
	textnode.set_bbcode(text)
	textnode.show()

func _on_dimcrystal_ability_empoweredvirginityenabled_pressed():
	var refCrystal = globals.state.thecrystal
	var text = ""
	var textnode = get_node("MainScreen/mansion/dimcrystalpanel/description")
	
	text += "You solemnly approach the [color=#E389B9]Dimensional Crystal[/color]. "
	if globals.state.thecrystal.mode == "light":
		text += "The [color=#E389B9]Crystal[/color] pulses softly with a deep, calming violet hue eminating out around it. "
	elif globals.state.thecrystal.mode == "dark":
		text += "The [color=#E389B9]Crystal[/color] pulses harshly with a dark deep-purple light that seems to be filled with shadows. "
	text += "You place your palm against the humming [color=#E389B9]Crystal[/color] and feel the raw reserves of power bubbling up from within it. It feels strained, pushed past the limits of natural law, but you feel a raw and unbridled power within. You feel that fascination from the dream with the natural, magical power in things that are so temporary and unique. You feel the [color=#E389B9]Crystal's[/color] power flood into these natural seals and barriers, understanding the intentional act over the physical object holds the true power.\n\nYou feel certain that the [color=#E389B9]Crystal[/color] will provide vastly more [color=aqua]mana[/color] when someone's [color=aqua]vaginal[/color] or [color=aqua]anal[/color] virginities are lost, but only [color=red]half as much mana[/color] when [color=aqua]no virginities are taken[/color]."
	refCrystal.empoweredvirginity = true
	reset_dimcrystal_ability_buttons()
	textnode.set_bbcode(text)
	textnode.show()

func _on_dimcrystal_ability_empoweredvirginitydisabled_pressed():
	var refCrystal = globals.state.thecrystal
	var text = ""
	var textnode = get_node("MainScreen/mansion/dimcrystalpanel/description")
	
	text += "You solemnly approach the [color=#E389B9]Dimensional Crystal[/color]. "
	if globals.state.thecrystal.mode == "light":
		text += "The [color=#E389B9]Crystal[/color] pulses softly with a deep, calming violet hue eminating out around it. "
	elif globals.state.thecrystal.mode == "dark":
		text += "The [color=#E389B9]Crystal[/color] pulses harshly with a dark deep-purple light that seems to be filled with shadows. "
	text += "You place your palm against the humming [color=#E389B9]Crystal[/color] and feel the raw reserves of power bubbling up from within it. It feels strained, pushed past the limits of natural law, but you feel a raw and unbridled power within. You feel that fascination from the dream with the natural, magical power in things that are so temporary and unique. You intentionally dissuade the interest and revisit an equal desire for all things beautiful. Why place any value over inexperience over the beauty and growing permanence of experience? You feel the [color=#E389B9]Crystal[/color] bend to your will.\n\nYou feel certain that the [color=#E389B9]Crystal[/color] will provide equal [color=aqua]mana[/color] with no concern for anyone's [color=aqua]virginity[/color]."
	refCrystal.empoweredvirginity = false
	reset_dimcrystal_ability_buttons()
	textnode.set_bbcode(text)
	textnode.show()

#Preg Speed
func _on_dimcrystal_ability_pregspeed_pressed():
	var refCrystal = globals.state.thecrystal
	var text = ""
	var textnode = get_node("MainScreen/mansion/dimcrystalpanel/description")
	if refCrystal.abilities.has('pregnancyspeed'):
		text += "You have learned how to use the magic of the [color=#E389B9]Crystal[/color] to affect the [color=aqua]Speed of Pregnancies[/color] in the mansion. The current duration of a woman's pregnancy while living in the mansion is [color=aqua]"+ str(globals.state.pregduration) +" Days[/color]."
	#Reset, Disable Buttons, Finish
	reset_dimcrystal_ability_buttons()
	get_node("MainScreen/mansion/dimcrystalpanel/ability_pregspeed").set_disabled(true)
	get_node("MainScreen/mansion/dimcrystalpanel/ability_pregspeed_enable").set_disabled(false)
	get_node("MainScreen/mansion/dimcrystalpanel/ability_pregspeed_enable").show()
	textnode.set_bbcode(text)
	textnode.show()

onready var nodeChangePregSpeed = get_node("MainScreen/mansion/dimcrystalpanel/pregspeed_panel")

func _on_dimcrystal_ability_pregspeed_enabled():
	refresh_pregspeed_panel()
	nodeChangePregSpeed.show()

func _on_dimcrystal_ability_pregspeed_panel_closed():
	nodeChangePregSpeed.hide()
	_on_dimcrystal_ability_pregspeed_pressed()

func refresh_pregspeed_panel():
	var text = "You have harnessed the power of the [color=#E389B9]Dimensional Crystal[/color] to safely speed up the gestation period for all pregnant women within the mansion past the normal limits their bodies could handle. The [color=#E389B9]Crystal[/color] surpresses the unbearable physical pain and mental horror that the near instantaneous pregnancies cause to the affected women, fortunately preventing their bodies from permanently warping or their minds from snapping from the uncontrollable changes. Instead, the affected women's minds and memories are magically altered into believing that they are growing at only slightly faster than a natural, normal rate.\n\n"
	var textnode = get_node("MainScreen/mansion/dimcrystalpanel/pregspeed_panel/displaytext")
	var currentspeed = str(globals.state.pregduration)
	
	#Enable All Buttons
	get_node("MainScreen/mansion/dimcrystalpanel/pregspeed_panel/speed_1").set_disabled(false)
	get_node("MainScreen/mansion/dimcrystalpanel/pregspeed_panel/speed_3").set_disabled(false)
	get_node("MainScreen/mansion/dimcrystalpanel/pregspeed_panel/speed_5").set_disabled(false)
	get_node("MainScreen/mansion/dimcrystalpanel/pregspeed_panel/speed_7").set_disabled(false)
	get_node("MainScreen/mansion/dimcrystalpanel/pregspeed_panel/speed_10").set_disabled(false)
	get_node("MainScreen/mansion/dimcrystalpanel/pregspeed_panel/speed_14").set_disabled(false)
	get_node("MainScreen/mansion/dimcrystalpanel/pregspeed_panel/speed_21").set_disabled(false)
	get_node("MainScreen/mansion/dimcrystalpanel/pregspeed_panel/speed_30").set_disabled(false)
	get_node("MainScreen/mansion/dimcrystalpanel/pregspeed_panel/speed_45").set_disabled(false)
	get_node("MainScreen/mansion/dimcrystalpanel/pregspeed_panel/speed_60").set_disabled(false)
	get_node("MainScreen/mansion/dimcrystalpanel/pregspeed_panel/speed_90").set_disabled(false)
	get_node("MainScreen/mansion/dimcrystalpanel/pregspeed_panel/speed_180").set_disabled(false)
	get_node("MainScreen/mansion/dimcrystalpanel/pregspeed_panel/speed_270").set_disabled(false)
	
	#TBK - Add Images to Image Node at - MainScreen/mansion/dimcrystalpanel/pregspeed_panel/imagepanel/image
	#Then make MainScreen/mansion/dimcrystalpanel/pregspeed_panel/imagepanel visible
	
	#Disable Current Choice, Show Text
	match currentspeed:
		'1':
			get_node("MainScreen/mansion/dimcrystalpanel/pregspeed_panel/speed_1").set_disabled(true)
			text += "Pregnant women will give birth within [color=aqua]1 Day[/color] of getting pregnant. This extreme rate of gestation may still cause potential health and mental health issues, however.\n\n[color=red]This is essentially a Cheat mode and useful for pumping out slaves to sell. However, you will skip over the majority of pregnancy content.[/color]"
		'3':
			get_node("MainScreen/mansion/dimcrystalpanel/pregspeed_panel/speed_3").set_disabled(true)
			text += "Pregnant women will burst to full term, growing at a rate of 1 day per trimester for a total of [color=aqua]3 days[/color]. You can sense that this is the highest speed recommended by the mysterious creators of the [color=#E389B9]Crystal[/color], though it will still have a higher potential of health risks to the pregnant women affected as the [color=#E389B9]Crystal[/color] tries to keep up."
		'5':
			get_node("MainScreen/mansion/dimcrystalpanel/pregspeed_panel/speed_5").set_disabled(true)
			text += "Pregnant women will rapidly grow to full term within [color=aqua]5 days[/color]. You can sense that this rapid speed may still not fully allow enough time to recover from a previous pregnancy for the average breeder before she finds herself in labor once again. The speed of pregnancy almost guarantees that multiple generations of slave offspring will be seen, though the effects of pregnancy on their slave may go so rapidly that an unobservant slave-owner may entirely miss it."
		'7':
			get_node("MainScreen/mansion/dimcrystalpanel/pregspeed_panel/speed_7").set_disabled(true)
			text += "Pregnant women will stretch to full term within [color=aqua]7 days[/color]. You can sense that this speed is the most commonly recommended speed for industrial breeding farms with an intent to pump out new slaves for a tidy profit without a risk of damaging their womb-laden property. The speed of pregnancy almost guarantees that multiple generations of slave offspring will be seen, though the effects of pregnancy on their slave may go so rapidly that an unobservant slave-owner may miss it."
		'10':
			get_node("MainScreen/mansion/dimcrystalpanel/pregspeed_panel/speed_10").set_disabled(true)
			text += "Pregnant women will swell to full term within [color=aqua]10 days[/color]. You can sense that this speed is the most commonly recommended speed for standard farms seeking to produce new slaves, laborers, or cattle without a risk of damaging or stressing out their womb-laden property. Interations with multiple generations of slave offspring are very likely."
		'14':
			get_node("MainScreen/mansion/dimcrystalpanel/pregspeed_panel/speed_14").set_disabled(true)
			text += "Pregnant women will grow to full term within [color=aqua]14 days[/color]. You can sense that this speed is recommended for slave-owners that seek to use breeding for extending family lines without the risk being overrun by unwanted offspring. Interations with multiple generations of slave offspring are very likely.\n\n[color=lime]This is the Default option for AricsExpansion.[/color]"
		'21':
			get_node("MainScreen/mansion/dimcrystalpanel/pregspeed_panel/speed_21").set_disabled(true)
			text += "Pregnant women will grow to full term within [color=aqua]21 days[/color]. You can sense that this speed is recommended for slave-owners that are slightly curious in breeding but may not be fully committed to the concept. They will have plenty of time to enjoy the slow, daily progression of pregnancy and delight in the effects of pregnancy on their slaves. They will likely not see more than two to four generations of their offspring."
		'30':
			get_node("MainScreen/mansion/dimcrystalpanel/pregspeed_panel/speed_30").set_disabled(true)
			text += "Pregnant women will swell to full term within [color=aqua]30 days[/color]. You can sense that this speed is recommended for slave-owners who only have a passing interest in breeding their slaves. They will have plenty of time to enjoy the slow, daily progression of pregnancy and delight in the gradual pregnancy of their slaves. They will likely not see more than one to three generations of offspring."
		'45':
			get_node("MainScreen/mansion/dimcrystalpanel/pregspeed_panel/speed_45").set_disabled(true)
			text += "Pregnant women will slowly swell to full term within [color=aqua]45 days[/color]. You can sense that this speed is recommended for slave-owners who only have a vague interest in breeding their slaves. They will have plenty of time to enjoy the slow, daily progression of pregnancy and delight in the gradual pregnancy of their slaves. They will likely not see more than a one to two generations of their offspring."
		'60':
			get_node("MainScreen/mansion/dimcrystalpanel/pregspeed_panel/speed_60").set_disabled(true)
			text += "Pregnant women will slowly grow to full term within [color=aqua]60 days[/color]. You can sense that this speed is recommended for slave-owners who only have a very mild curiosity in breeding their slaves. They will have plenty of time to enjoy the slow, daily progression of pregnancy and delight in the gradual pregnancy of their slaves. They will likely not see more than one generation, if they see any offspring at all."
		'90':
			get_node("MainScreen/mansion/dimcrystalpanel/pregspeed_panel/speed_90").set_disabled(true)
			text = "You have chosen to allow a slight hold from the [color=#E389B9]Dimensional Crystal[/color] on the wombs of women in your mansion. Gestation will increase at a third of the standard rate. Women will only give birth once the baby is fully grown in [color=aqua]3 Months[/color].\n\n[color=red]This will likely prevent any offspring from being born within your mansion and may severely reduce access to any pregnancy content.[/color]"
		'180':
			get_node("MainScreen/mansion/dimcrystalpanel/pregspeed_panel/speed_180").set_disabled(true)
			text = "You have chosen to minimize the hold the [color=#E389B9]Dimensional Crystal[/color] has on the wombs of women in your mansion. Gestation will increase at a slight increase of the normal rate and women will only give birth once the baby is fully grown in [color=aqua]6 Months[/color].\n\n[color=red]This will likely prevent any offspring from being born within your mansion and essentially disable pregnancy content.[/color]"
		'270':
			get_node("MainScreen/mansion/dimcrystalpanel/pregspeed_panel/speed_270").set_disabled(true)
			text = "You have chosen to release the hold the [color=#E389B9]Dimensional Crystal[/color] has on the wombs of women in your mansion. Gestation will increase at a normal rate and women will only give birth once the baby is fully grown in [color=aqua]9 Months[/color]. At this rate, a slave-owner may never even see the effects of a slave's pregnancy affect her. \n\n[color=red]This will likely prevent any offspring from being born within your mansion and essentially disable pregnancy content.[/color]"
		_:
			text = "The current speed of Pregnancy within the mansion is [color=aqua]"+ currentspeed +"[/color]."
	
	textnode.set_bbcode(text)

#PregSpeed Panel Buttons
func _dimcrystal_pregspeedchange_1():
	globals.state.pregduration = 1
	refresh_pregspeed_panel()

func _dimcrystal_pregspeedchange_3():
	globals.state.pregduration = 3
	refresh_pregspeed_panel()

func _dimcrystal_pregspeedchange_5():
	globals.state.pregduration = 5
	refresh_pregspeed_panel()

func _dimcrystal_pregspeedchange_7():
	globals.state.pregduration = 7
	refresh_pregspeed_panel()

func _dimcrystal_pregspeedchange_10():
	globals.state.pregduration = 10
	refresh_pregspeed_panel()

func _dimcrystal_pregspeedchange_14():
	globals.state.pregduration = 14
	refresh_pregspeed_panel()

func _dimcrystal_pregspeedchange_21():
	globals.state.pregduration = 21
	refresh_pregspeed_panel()

func _dimcrystal_pregspeedchange_30():
	globals.state.pregduration = 30
	refresh_pregspeed_panel()

func _dimcrystal_pregspeedchange_45():
	globals.state.pregduration = 45
	refresh_pregspeed_panel()

func _dimcrystal_pregspeedchange_60():
	globals.state.pregduration = 60
	refresh_pregspeed_panel()

func _dimcrystal_pregspeedchange_90():
	globals.state.pregduration = 90
	refresh_pregspeed_panel()

func _dimcrystal_pregspeedchange_180():
	globals.state.pregduration = 180
	refresh_pregspeed_panel()

func _dimcrystal_pregspeedchange_270():
	globals.state.pregduration = 270
	refresh_pregspeed_panel()

func _on_dimcrystal_ability_secondwind_pressed():
	var refCrystal = globals.state.thecrystal
	var text = ""
	var textnode = get_node("MainScreen/mansion/dimcrystalpanel/description")
	if refCrystal.abilities.has('secondwind'):
		text += "You have learned how to harness the life-giving magic of the [color=#E389B9]Crystal[/color] to revive you and your slaves to half-health from a fatal blow in combat [color=aqua]Once per Day[/color]. You also know this will increase the [color=aqua]Crystal's[/color] [color=red]Hunger[/color] and reduce its [color=aqua]Lifeforce[/color]. If the [color=aqua]Lifeforce[/color] is consumed by its [color=red]Hunger[/color], the [color=#E389B9]Crystal[/color] will grow [color=red]Dark[/color]."
	#Reset, Disable Buttons, Finish
	reset_dimcrystal_ability_buttons()
	get_node("MainScreen/mansion/dimcrystalpanel/ability_secondwind").set_disabled(true)
	
	textnode.set_bbcode(text)
	textnode.show()

func _on_dimcrystal_ability_immortality_pressed():
	var refCrystal = globals.state.thecrystal
	var text = ""
	var textnode = get_node("MainScreen/mansion/dimcrystalpanel/description")
	if refCrystal.abilities.has('immortality'):
		text += "You have learned how to use the magic of the [color=#E389B9]Crystal[/color] to grant temporary [color=aqua]Immortality[/color] to your slaves both inside the Mansion and in combat with you. This is a huge strain on the [color=#E389B9]Crystal[/color]. It drastically increases the [color=aqua]Crystal's[/color] [color=red]Hunger[/color] and has a high chance of making it grow [color=red]Dark[/color]."
	#Reset, Disable Buttons, Finish
	reset_dimcrystal_ability_buttons()
	get_node("MainScreen/mansion/dimcrystalpanel/ability_immortality").set_disabled(true)
	
	#Set Immortality Button Option
	if refCrystal.preventsdeath == true:
		get_node("MainScreen/mansion/dimcrystalpanel/ability_immortality_disable").show()
	else:
		get_node("MainScreen/mansion/dimcrystalpanel/ability_immortality_enable").show()
	
	textnode.set_bbcode(text)
	textnode.show()

func _on_dimcrystal_ability_immortality_enabled():
	var refCrystal = globals.state.thecrystal
	var text = ""
	var textnode = get_node("MainScreen/mansion/dimcrystalpanel/description")

	text += "You solemnly approach the [color=#E389B9]Dimensional Crystal[/color]. "
	if globals.state.thecrystal.mode == "light":
		text += "The Crystal pulses softly with a deep, calming violet hue eminating out around it. "
	elif globals.state.thecrystal.mode == "dark":
		text += "The Crystal pulses harshly with a dark deep-purple light that seems to be filled with shadows. "
	text += "You place your palm against the humming crystal and feel the raw reserves of power bubbling up from within it. It is the essence of life, death, and all between. So it has mastery over life and death? Good, for you are its master. You focus your will into the [color=#E389B9]Crystal[/color] and beseech it to reach out its tendrils and protect the lives that you claim as your property. You feel the faint resistance, the tether of entropy and the allure of the natural cycle, begin to crack and relent. You pull back with a deep sigh and feel a certainty that the [color=#E389B9]Crystal[/color] will sacrifice its own [color=green]Lifeforce[/color] to keep you and yours alive. You understand the weight of your request and that it will certainly have a very heavy cost, but you feel confident that the [color=#E389B9]Crystal[/color] will pay it for you.\n\nThe tendrils of energy pierce out though the darkness around you. Death is chained and you rise above natural law. The shadows grow brighter, no true harm could befall you. Truth is what you make it, time is of your design. You walk fearless of any end among both Gods and men. As long as the Crystal remains intact, you know that you (and those you deem worthy) do as well."
	
	refCrystal.preventsdeath = true
	refCrystal.power = globals.state.mansionupgrades.dimensionalcrystal
	
	reset_dimcrystal_ability_buttons()
	textnode.set_bbcode(text)
	textnode.show()

func _on_dimcrystal_ability_immortality_disabled():
	var refCrystal = globals.state.thecrystal
	var text = ""
	var textnode = get_node("MainScreen/mansion/dimcrystalpanel/description")

	text += "You solemnly approach the [color=#E389B9]Dimensional Crystal[/color]. "
	if globals.state.thecrystal.mode == "light":
		text += "The Crystal pulses softly with a deep, calming violet hue eminating out around it. "
	elif globals.state.thecrystal.mode == "dark":
		text += "The Crystal pulses harshly with a dark deep-purple light that seems to be filled with shadows. "
	text += "You place your palm against the humming [color=#E389B9]Crystal[/color] and feel the raw reserves of power bubbling up from within it. It feels strained, pushed past the limits of natural law, but you feel a raw and unbridled power within. Should you allow yourself to believe there were a will inside, you would feel the dedication to protecting life at the cost of all that remains. You impose your mind into the crystal and bid it to rest. Its vigil is complete, the sacrifices of life and death may resume. It may rest.\n\nWith a dulling hum, you feel the energy pulsing around you soften and relax. The tendrils of energy seem shorter. The room feels darker than before. Unbidden thoughts of futures and pasts, regrets and choices, all return once more. Mortality awaits you, somewhere off in the shadows, to collect its fateful toll. "
	
	refCrystal.preventsdeath = false
	reset_dimcrystal_ability_buttons()
	textnode.set_bbcode(text)
	textnode.show()

func _on_dimcrystal_ability_understandsacrifice_pressed():
	var refCrystal = globals.state.thecrystal
	var text = ""
	var textnode = get_node("MainScreen/mansion/dimcrystalpanel/description")
	if refCrystal.abilities.has('sacrifice'):
		text += "You know how to sacrifice your slaves sate the hunger of the [color=#E389B9]Crystal[/color] with their life-force. You understand that each level a slave has will provide more essence for the [color=#E389B9]Crystal[/color] to consume, and that the [color=#E389B9]Crystal[/color] can never fully heal while hungry. "
		if globals.state.thecrystal.hunger > 0:
			text += "\n\nCrystal's Hunger: [color=aqua]" + str(globals.state.thecrystal.hunger) + "[/color]"
		if globals.state.thecrystal.abilities.has('understandsacrifice'):
			text += "\n\nYou have come to understand that sacrificing someone to the [color=#E389B9]Crystal[/color] will feed it an amount equal to their level (reducing hunger) as well as restoring 1 life-force to the [color=#E389B9]Crystal[/color], partially healing it. "
	#Reset, Disable Buttons, Finish
	reset_dimcrystal_ability_buttons()
	get_node("MainScreen/mansion/dimcrystalpanel/ability_understandsacrifice").set_disabled(true)
	textnode.set_bbcode(text)
	textnode.show()

func _on_dimcrystal_ability_choosesacrifice_pressed():
	var refCrystal = globals.state.thecrystal
	var text = ""
	var textnode = get_node("MainScreen/mansion/dimcrystalpanel/description")
	if refCrystal.abilities.has('sacrifice'):
		text += "TEMPORARY TEXT - Will allow Choosing Sacrifice and Proc Scene"
	#Reset, Disable Buttons, Finish
	reset_dimcrystal_ability_buttons()
#	get_node("MainScreen/mansion/dimcrystalpanel/ability_understandsacrifice").set_disabled(true)
	textnode.set_bbcode(text)
	textnode.show()

func _on_dimcrystal_closepanel_pressed():
	get_node("MainScreen/mansion/dimcrystalpanel").hide()
	
#---Jail Expanded
func _on_jailpanel_visibility_changed():
	var temp = ''
	var text = ''
	var count = 0
	var prisoners = []
	var jailer
	
	for i in get_node("MainScreen/mansion/jailpanel/ScrollContainer/prisonerlist").get_children():
		i.hide()
		i.queue_free()
	###---Added by Expansion---### Prisoner Release Panel
	for i in get_node("MainScreen/mansion/jailpanel/Scroll_Release/ready_prisonerlist").get_children():
		i.hide()
		i.queue_free()
	for i in get_node("MainScreen/mansion/jailpanel/jailer_button").get_children():
		i.hide()
		i.queue_free()
	###---End Expansion---###
	
	if get_node("MainScreen/mansion/jailpanel").visible == false:
		return
	for i in globals.slaves:
		if i.sleep == 'jail' && i.away.duration == 0:
			temp = temp + i.name
			prisoners.append(i)
			var button = Button.new()
			var node = get_node("MainScreen/mansion/jailpanel/ScrollContainer/prisonerlist")
			node.add_child(button)
			button.set_text(i.name_long())
			button.set_name(str(count))
			button.connect('pressed', self, 'prisonertab', [count])
			###---Added by Expansion---### Prisoner Release Panel
			var rebelling = false
			for check_captured in i.effects.values():
				if check_captured.code == 'captured':
					rebelling = true
					break
			if rebelling == false:
				button = Button.new()
				node = get_node("MainScreen/mansion/jailpanel/Scroll_Release/ready_prisonerlist")
				node.add_child(button)
				button.set_text(i.name_long())
				button.set_name(str(count))
				button.connect('pressed', self, 'prisonertab', [count])
			###---End Expansion---###
		if i.work == 'jailer' && i.away.duration == 0:
			jailer = i
			
		count += 1
	###---Added by Expansion---### Jail Expanded
	if temp == '':
		text = 'There are no prisoners currently in the Dungeon.'
	else:
		#Colorized Text
		text = 'There are a total of [color=aqua] '+str(prisoners.size()) + '[/color] prisoner(s) in the Dungeon.\nThere are currently [color=aqua]' + str(globals.state.mansionupgrades.jailcapacity-prisoners.size()) + '[/color] free cell(s).\nPrisoners can be disciplined via [color=aqua]Interactions > Meet[/color]. '
	if globals.state.mansionupgrades.jailtreatment:
		text += "\n[color=lime]Your jail is decently furnished and tiled. [/color]"
	if globals.state.mansionupgrades.jailincenses:
		text += "\n[color=lime]You can smell soft burning incenses in the air.[/color]"
	if jailer == null:
		get_node("MainScreen/mansion/jailpanel/jailer_text").set_bbcode('[color=#d1b970]Current Jailer[/color]\n[color=red]No [color=aqua]Jailer[/color] is assigned to manage the Dungeon.[/color]')
		get_node("MainScreen/mansion/jailpanel/TextureRect").visible = false
	else:
		get_node("MainScreen/mansion/jailpanel/jailer_text").set_bbcode('[color=#d1b970]Current Jailer[/color]')
		#Add Button
		var button = Button.new()
		var node = get_node("MainScreen/mansion/jailpanel/jailer_button")
		node.add_child(button)
		button.set_text(jailer.name_long())
		button.set_name(str(jailer.id))
		button.connect('pressed', self, 'openslavetab', [jailer])
		#Assign Portrait
		if jailer.imageportait != null && globals.loadimage(jailer.imageportait):
			get_node("MainScreen/mansion/jailpanel/TextureRect").visible = true
			get_node("MainScreen/mansion/jailpanel/TextureRect/portrait").set_texture(globals.loadimage(jailer.imageportait))
		else:
			jailer.imageportait = null
			#TBK - Debating on leaving Hidden or not
			get_node("MainScreen/mansion/jailpanel/TextureRect").visible = true
			get_node("MainScreen/mansion/jailpanel/TextureRect/portrait").set_texture(globals.loadimage(globals.sexuality_images.unknown))
		#text = text + jailer.dictionary('\n$name is assigned as jailer.')
	###---End Expansion---###
	
	get_node("MainScreen/mansion/jailpanel/jailtext").set_bbcode(text)

func prisonertab(number):
	self.currentslave = number
	###---Added by Expansion---### Jail Expanded
	background_set('jail')
	yield(self, 'animfinished')
	hide_everything()
	###---End Expansion---###
	get_node("MainScreen/slave_tab").tab = 'prison'
	get_node("MainScreen/slave_tab").slavetabopen()

###---Added by Expansion---### Added by Deviate, Tweaked by Aric, Tested by Banana
var birthmother
func childbirth_loop(person):
	birthmother = person
	if !person.preg.unborn_baby.empty():
		var babydict = person.preg.unborn_baby[0]
		var id = babydict.id
		childbirth(person,id)
		person.preg.unborn_baby.remove(0)
	else:
		person.metrics.birth += 1
		person.preg.is_preg = false
		person.preg.duration = 0
		person.preg.ovulation_stage = 2
		person.preg.ovulation_day = randi() % 3 - 5
###---End of Expansion---###

###---Added by Expansion---### Added by Deviate - Minor modifications to add multiple births
func childbirth(person,baby_id):
	person.preg.offspring_count += 1
	get_node("birthpanel").show()
	baby = globals.state.findbaby(baby_id)
	var text = ''
	if globals.state.mansionupgrades.mansionnursery >= 1:
		if globals.player == person:
			text = person.dictionary('[color=aqua]You[/color] gave birth to a ')
		else:
			text = person.dictionary('[color=aqua]$name[/color] gave birth to a ')
		text += baby.dictionary('healthy [color=aqua]$race $child[/color]. ') + globals.description.getBabyDescription(baby)
		if globals.state.mansionupgrades.dimensionalcrystal >= 2:
			text += baby.dictionary("\nYou see the octomarine remnants of magic slowly fading from $his skin. The Dimensional Crystal may have unlocked parts of $his DNA and given $him greater possible abilities than $his parents. ")
		###---Added by Expansion---###
		#Change the "0,5" to Lust/Orgasms,Stress+Pain*.5 ?
		if person.pregexp.desiredoffspring - person.metrics.birth - rand_range(0,5) > 0:
			#Randomize Dialogue - TBK
			text += person.dictionary("\n\n[color=aqua]$name[/color] " + str(globals.randomitemfromarray(['whimpers','pants','moans','says','meekly says'])) + "\n" + person.quirk("[color=yellow]-I need time to recover, of course, but I don't mind having another baby "))
			if globals.expansion.relatedCheck(globals.player,baby) == 'father':
				text += "with you.[/color]\n"
			else:
				text += "for you.[/color]\n"	
		else:
			#Randomize Dialogue - TBK
			text += person.dictionary("\n\n[color=aqua]$name[/color] " + str(globals.randomitemfromarray(['whimpers','pants','moans','says','meekly says'])) + "\n" + person.quirk("[color=yellow]-I really don't want to have another baby. Please don't make me have another baby...[/color]\n"))
			person.consentexp.pregnancy = false
			person.consentexp.breeder = false
			person.consentexp.incestbreeder = false
		var acceptsacrifice = round(rand_range(0,100))
		if person.knowledge.has('currentpregnancywanted') || person.pregexp.wantedpregnancy == true:
			text += person.dictionary(person.quirk("[color=yellow]Will you keep my baby? Please? I want to be able to be in ")) + baby.dictionary("$his") + person.dictionary(person.quirk(" life.[/color]\n"))
		elif globals.state.thecrystal.abilities.has('sacrifice') && (acceptsacrifice < (person.loyal+person.obed)*.5 || acceptsacrifice <= person.fear):
			person.dailytalk.append('acceptedsacrifice')
			text += person.dictionary(person.quirk("[color=yellow]I understand if you...have to do what you do with the [color=#E389B9]Crystal[/color]. I would rather you not, obviously, but if you have absolutely have to get rid of to keep the rest of us from being eaten or sacrificed...I won't hold it against you. If it is between me and the baby I didn't want to have...well, you understand.[/color]\n"))
		#---Modified Text and Raising Cost
		text += "\nThe power of the [color=#E389B9]Dimensional Crystal[/color] will help accelerate it's growth allowing for it to experience entire years in a matter of days as it rests in the [color=aqua]Nursery[/color] next to the [color=#E389B9]Crystal[/color]."
		text += "\nWould you like to [color=aqua]Raise[/color] it? This will cost you either [color=aqua]500 Gold[/color], [color=aqua]25 Mana and 250 Gold[/color], or [color=aqua]50 Mana[/color] to allow it to grow up healthy.\nYou may also [color=aqua]Give the Baby Away[/color] for no cost or penalty. "
		if globals.state.thecrystal.abilities.has('sacrifice'):
			text += "\nYou can also [color=red]Sacrifice[/color] the baby to the [color=#E389B9]Crystal[/color]. This will kill the baby but embue the [color=#E389B9]Crystal[/color] with [color=aqua]1 Life[/color] and lessen [color=aqua]1-3 Hunger[/color]."
			text += "\nHowever, [color=aqua]$name[/color] may hate you for this action depending on $his [color=aqua]Loyalty[/color] and will gain [color=aqua]Fear[/color]."
		#Raise with Gold
		if globals.resources.gold >= 500:
			get_node("birthpanel/raise").set_disabled(false)
			get_node("birthpanel/raise").set_tooltip("Spend 500 Gold to Raise the Baby")
		else:
			get_node("birthpanel/raise").set_disabled(true)
			get_node("birthpanel/raise").set_tooltip("You cannot afford the cost of 500 Gold")
		#Raise with Gold and Mana
		if globals.resources.gold >= 250 && globals.resources.mana >= 25:
			get_node("birthpanel/raisehybrid").set_disabled(false)
			get_node("birthpanel/raisehybrid").set_tooltip("Spend 250 Gold and 25 Mana to Raise the Baby")
		else:
			get_node("birthpanel/raisehybrid").set_disabled(true)
			get_node("birthpanel/raisehybrid").set_tooltip("You cannot afford the cost of 250 Gold and 25 Mana")
		#Raise with Mana
		if globals.resources.mana >= 50:
			get_node("birthpanel/raisemana").set_disabled(false)
			get_node("birthpanel/raisemana").set_tooltip("Spend 50 Mana to Raise the Baby")
		else:
			get_node("birthpanel/raisemana").set_disabled(true)
			get_node("birthpanel/raisemana").set_tooltip("You cannot afford the cost of 50 Mana")
		#Sacrifice Baby
		if globals.state.thecrystal.abilities.has('sacrifice'):
			get_node("birthpanel/sacrificebaby").show()
			if globals.state.thecrystal.mode == "dark":
				get_node("birthpanel/sacrificebaby").set_disabled(false)
				get_node("birthpanel/sacrificebaby").set_tooltip("Sacrifice the Baby to the Dark Crystal to lower its Hunger by 1 to 3 and gain 1 Lifeforce")
			else:
				get_node("birthpanel/sacrificebaby").set_disabled(true)
				get_node("birthpanel/sacrificebaby").set_tooltip("The Crystal is Light and will not currently accept Sacrifices")
		else:
			get_node("birthpanel/sacrificebaby").hide()
		###---Expansion End---###
	else:
		if globals.player == person:
			text = person.dictionary("You've had to use the town's hospital to give birth to your child. [color=red]Sadly, you can't keep it without Nursery Room and had to give it away.[/color]")
		else:
			text = person.dictionary("$name had to use the town's hospital to give birth to her child. [color=red]Sadly, you can't keep it without Nursery Room and had to give it away.[/color]")
		get_node("birthpanel/raise").set_disabled(true)
		###---Added by Expansion---### Disable if no nursery
		get_node("birthpanel/raise").set_disabled(true)
		get_node("birthpanel/raise").set_tooltip("You have no Nursery. You can build one in Mansion Upgrades.")
		get_node("birthpanel/raisehybrid").set_disabled(true)
		get_node("birthpanel/raisehybrid").set_tooltip("You have no Nursery. You can build one in Mansion Upgrades.")
		get_node("birthpanel/raisemana").set_disabled(true)
		get_node("birthpanel/raisemana").set_tooltip("You have no Nursery. You can build one in Mansion Upgrades.")
		get_node("birthpanel/sacrificebaby").hide()
		###---End Expansion---###
	
	#---Added Portrait
	if globals.canloadimage(person.imageportait):
		get_node("birthpanel/portraitpanel/portrait").set_texture(globals.loadimage(person.imageportait))
	elif globals.gallery.nakedsprites.has(person.unique):
		if person.obed <= 50 || person.stress > 50:
			get_node("birthpanel/portraitpanel/portrait").set_texture(globals.spritedict[globals.gallery.nakedsprites[person.unique].clothrape])
		else:
			get_node("birthpanel/portraitpanel/portrait").set_texture(globals.spritedict[globals.gallery.nakedsprites[person.unique].clothcons])
	else:
		get_node("birthpanel/portraitpanel/portrait").set_texture(null)
	get_node("birthpanel/portraitpanel/portrait").show()
	
	get_node("birthpanel/birthtext").set_bbcode(text)

#---Reset Stats after Pregnancy
func reset_after_pregnancy(person):
	person.preg.fertility = 5
	if person.knowledge.has('currentpregnancy'):
		person.knowledge.erase('currentpregnancy')
	if person.mind.secrets.has('currentpregnancy'):
		person.mind.secrets.erase('currentpregnancy')
	if person.knowledge.has('currentpregnancywanted'):
		person.knowledge.erase('currentpregnancywanted')
	if birthmother.dailytalk.has('acceptedsacrifice'):
		birthmother.dailytalk.erase('acceptedsacrifice')
	person.pregexp.wantedpregnancy = false
	person.pregexp.babysize = 0
	person.pregexp.incestbaby = false

###---Added by Expansion---### Childbirth Expanded
func _on_giveaway_pressed():
	if birthmother.knowledge.has('currentpregnancywanted') || birthmother.pregexp.wantedpregnancy == true:
		birthmother.loyal -= round(rand_range(10,25))
	reset_after_pregnancy(birthmother)
	get_node("birthpanel").hide()
	childbirth_loop(birthmother)

func _on_sacrificebaby_pressed():
	if birthmother.dailytalk.has('acceptedsacrifice'):
		birthmother.dailytalk.erase('acceptedsacrifice')
		birthmother.fear += round(rand_range(5,10))
	else:
		birthmother.loyal -= round(rand_range(15,30))
		birthmother.fear += round(rand_range(20,50))
	reset_after_pregnancy(birthmother)
	globals.state.thecrystal.hunger -= round(rand_range(1,3))
	globals.state.thecrystal.lifeforce += 1
	get_node("birthpanel").hide()
	childbirth_loop(birthmother)

func _on_raise_pressed():
	if globals.resources.gold >= 500:
		globals.resources.gold -= 500
	finish_raising()
	
#ralph - makes children not inherit parents sex traits and teens have lower chance to inherit them; also resets to Pliable
func ClearBabyTraits(age):
	if age == 'child':
		if baby.traits.has('Slutty') || baby.traits.has('Devoted'):
			baby.trait_remove('Slutty')
			baby.trait_remove('Devoted')
			baby.add_trait('Pliable')
		baby.trait_remove('Deviant')
		baby.trait_remove('Pervert')
		baby.trait_remove('Masochist')
		baby.trait_remove('Sadist')
		baby.trait_remove('Likes it rough')
		baby.trait_remove('Enjoys Anal')
		if !globals.expansionsettings.gratitude_for_all: #ralphC - by request
			baby.trait_remove('Grateful') #ralphC
		baby.trait_remove('Sex-crazed')
	elif age == 'teen':
		if baby.traits.has('Slutty') || baby.traits.has('Devoted'):
			baby.trait_remove('Slutty')
			baby.trait_remove('Devoted')
			baby.add_trait('Pliable')
		if baby.traits.has('Deviant') && rand_range(0,100) < 75:
			baby.trait_remove('Deviant')
		if baby.traits.has('Pervert') && rand_range(0,100) < 50:
			baby.trait_remove('Pervert')
		if baby.traits.has('Masochist') && rand_range(0,100) < 50:
			baby.trait_remove('Masochist')
		if baby.traits.has('Sadist') && rand_range(0,100) < 50:
			baby.trait_remove('Sadist')
		if baby.traits.has('Likes it rough') && rand_range(0,100) < 50:
			baby.trait_remove('Likes it rough')
		if baby.traits.has('Enjoys Anal') && rand_range(0,100) < 50:
			baby.trait_remove('Enjoys Anal')
		if baby.traits.has('Grateful') && rand_range(0,100) < 50:
			if !globals.expansionsettings.gratitude_for_all: #ralphC - by request
				baby.trait_remove('Grateful') #ralphC
		if baby.traits.has('Sex-crazed') && rand_range(0,100) < 75:
			baby.trait_remove('Sex-crazed')
	elif age == 'adult':
		if baby.traits.has('Slutty') || baby.traits.has('Devoted'):
			baby.trait_remove('Slutty')
			baby.trait_remove('Devoted')
			baby.add_trait('Pliable')
		if baby.traits.has('Sex-crazed') && rand_range(0,100) < 50:
			baby.trait_remove('Sex-crazed')
#/ralph


func babyage(age):
	###---Added by Expansion---### Size Support || Replaced Functions
	baby.name = get_node("birthpanel/childpanel/LineEdit").get_text()
	if get_node("birthpanel/childpanel/surnamecheckbox").is_pressed() == true:
		baby.surname = globals.player.surname
	if age == 'child':
		ClearBabyTraits(age) #ralph
		baby.age = 'child'
		baby.away.duration = variables.growuptimechild
	elif age == 'teen':
		ClearBabyTraits(age) #ralph
		baby.age = 'teen'
		baby.away.duration = variables.growuptimeteen
	elif age == 'adult':
		ClearBabyTraits(age) #ralph
		baby.age = 'adult'
		baby.away.duration = variables.growuptimeadult
	baby.away.at = 'growing'
	baby.obed += 75
	baby.loyal += 20
	if !baby.sex in ['male','dickgirl']:
		baby.vagvirgin = true
	baby.assvirgin = true
	baby.unique = null #ralph
	if globals.useRalphsTweaks:
		globals.expansionsetup.setRaceBonus(baby, false) #ralph - needed to override certain inherited traits for certain hybrids including race_display
		globals.expansionsetup.setRaceBonus(baby, true) #ralph
	globals.slaves = baby
	globals.state.relativesdata[baby.id].name = baby.name_long()
	globals.state.relativesdata[baby.id].state = 'normal'

	globals.state.babylist.erase(baby)
	baby = null
	get_node("birthpanel").hide()
	get_node("birthpanel/childpanel").hide()
	childbirth_loop(birthmother)

func _on_raisehybrid_pressed():
	if globals.resources.gold >= 250 && globals.resources.mana >= 25:
		globals.resources.gold -= 250
		globals.resources.mana -= 25
	finish_raising()	

func _on_raisemana_pressed():
	if globals.resources.mana >= 50:
		globals.resources.mana -= 50
	finish_raising()

func finish_raising():
	#Reset Pregnancy Stats
	if birthmother.knowledge.has('currentpregnancywanted') || birthmother.pregexp.wantedpregnancy == true:
		birthmother.loyal += round(rand_range(5,10))
		birthmother.obed += round(rand_range(10,25))
	reset_after_pregnancy(birthmother)
	get_node("birthpanel/childpanel").show()
	get_node("birthpanel/childpanel/LineEdit").set_text(baby.name)
	if globals.rules.children != true:
		get_node("birthpanel/childpanel/child").hide()
	else:
		get_node("birthpanel/childpanel/child").show()
###---End of Expansion---###

func _on_selfbutton_pressed():
	hide_everything()
	get_node("MainScreen/mansion/selfinspect").show()
	get_node("MainScreen/mansion/selfinspect/selflookspanel").hide()
	var text = '[center]Personal Achievements[/center]\n'
	var text2 = ''
	var person = globals.player
	$MainScreen/slave_tab.person = globals.player
	var dict = {
		0: "You do not belong in an Order.",
		1: "Neophyte",
		2: "Apprentice",
		3: "Journeyman",
		4: "Adept",
		5: "Master",
		6: "Grand Archmage",
	}
	text += 'Combat Abilities: '
	for i in person.ability:
		var ability = globals.abilities.abilitydict[i]
		if ability.learnable == true:
			text2 += ability.name + ', '
	if text2 == '':
		text += 'none. \n'
	else:
		text2 = text2.substr(0, text2.length() -2)+ '. '
	text += text2 + '\nReputation:\n'
	for i in globals.state.reputation:
		text += i.capitalize() + " - "+ reputationword(globals.state.reputation[i])
		###---Added by Expansion---### Towns Expanded
		if globals.expansionsettings.enable_public_nudity_system == true:
			var lawdict = globals.state.townsexpanded[i]
			#Public Nudity
			text += " - Local Laws: [color=aqua]Public Nudity[/color] " + globals.fastif(lawdict.laws.public_nudity == true, "[color=lime]Legal[/color]", "[color=red]Illegal[/color]")
		#End Line (Change to Multi-line Spacing?)
		text += "\n"
		###---End Expansion---###
	text += "Your mage order rank: " + dict[int(globals.state.rank)]
	###---Added by Expansion---###
	if globals.state.spec != "" && globals.state.spec != null:
		text += "\n\nYour speciality: [color=yellow]" + globals.state.spec + "[/color]\nBonuses: " + globals.expandedplayerspecs[globals.state.spec]
	###---End Expansion---###

	get_node("MainScreen/mansion/selfinspect/mainstatlabel").set_bbcode(text)
	updatestats(person)
	if globals.state.mansionupgrades.mansionparlor >= 1:
		$MainScreen/mansion/selfinspect/selftattoo.set_disabled(false)
		$MainScreen/mansion/selfinspect/selfpierce.set_disabled(false)
		$MainScreen/mansion/selfinspect/selftattoo.set_tooltip("")
		$MainScreen/mansion/selfinspect/selfpierce.set_tooltip("")
	else:
		$MainScreen/mansion/selfinspect/selftattoo.set_disabled(true)
		$MainScreen/mansion/selfinspect/selfpierce.set_disabled(true)
		$MainScreen/mansion/selfinspect/selftattoo.set_tooltip("Unlock Beauty Parlor to access Tattoo options. ")
		$MainScreen/mansion/selfinspect/selfpierce.set_tooltip("Unlock Beauty Parlor to access Piercing options. ")
	$MainScreen/mansion/selfinspect/Contraception.pressed = person.effects.has("contraceptive")
	$MainScreen/mansion/selfinspect/defaultMasterNoun.text = globals.state.defaultmasternoun

func updatestats(person):
	var text = ''
	for i in ['sstr','sagi','smaf','send']:
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
	text = person.name_long() + '\n[color=aqua][url=race]' +person.dictionary('$race[/url][/color]').capitalize() +  '\nLevel : '+str(person.level)
	get_node("MainScreen/mansion/selfinspect/statspanel/info").set_bbcode(person.dictionary(text))
	get_node("MainScreen/mansion/selfinspect/statspanel/attribute").set_text("Free Attribute Points : "+str(person.skillpoints))
	
	for i in ['send','smaf','sstr','sagi']:
		if person.skillpoints >= 1 && (globals.slaves.find(person) >= 0||globals.player == person) && person.stats[globals.maxstatdict[i].replace('_max','_base')] < person.stats[globals.maxstatdict[i]]:
			get_node("MainScreen/mansion/selfinspect/statspanel/" + i +'/Button').visible = true
		else:
			get_node("MainScreen/mansion/selfinspect/statspanel/" + i+'/Button').visible = false
	get_node("MainScreen/mansion/selfinspect/statspanel/hp").set_value((person.stats.health_cur/float(person.stats.health_max))*100)
	get_node("MainScreen/mansion/selfinspect/statspanel/en").set_value((person.stats.energy_cur/float(person.stats.energy_max))*100)
	get_node("MainScreen/mansion/selfinspect/statspanel/xp").set_value(person.xp)
	text = "Health: " + str(person.stats.health_cur) + "/" + str(person.stats.health_max) + "\nEnergy: " + str(round(person.stats.energy_cur)) + "/" + str(person.stats.energy_max) + "\nExperience: " + str(person.xp)
	get_node("MainScreen/mansion/selfinspect/statspanel/hptooltip").set_tooltip(text)
	if person.imageportait != null && globals.loadimage(person.imageportait):
		$MainScreen/mansion/selfinspect/statspanel/TextureRect/portrait.set_texture(globals.loadimage(person.imageportait))
	else:
		person.imageportait = null
		$MainScreen/mansion/selfinspect/statspanel/TextureRect/portrait.set_texture(null)


#Save for modifying reputations
func reputationword(value):
	var text = ""
	if value >= 30:
		text = "[color=green]Great[/color]"
	elif value >= 10:
		text = "[color=green]Positive[/color]"
	elif value <= -10:
		text = "[color=#ff4949]Bad[/color]"
	elif value <= -30:
		text = "[color=#ff4949]Terrible[/color]"
	else:
		text = "Neutral"
	return text

func selfabilityselect(ability):
	var text = ''
	var person = globals.player
	var dict = {'sstr': 'Strength', 'sagi' : 'Agility', 'smaf': 'Magic', 'level': 'Level', 'spec': 'Spec'}
	var confirmbutton = get_node("MainScreen/mansion/selfinspect/selfabilitypanel/abilitypurchase")
	
	for i in get_node("MainScreen/mansion/selfinspect/selfabilitypanel/ScrollContainer/VBoxContainer").get_children():
		if i.get_text() != ability.name:
			i.set_pressed(false)
	
	confirmbutton.set_disabled(false)
	
	text = '[center]'+ ability.name + '[/center]\n' + ability.description + '\nCooldown:' + str(ability.cooldown) + '\nLearn requirements: '
	
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
		if typeof(ability.reqs[i]) == TYPE_ARRAY: # Capitulize - Specialization based abilities 
			if !ability.reqs[i].has(ref):
				confirmbutton.set_disabled(true)
				text += '[color=#ff4949]'+dict[i] + ': ' + str(ability.reqs[i]) + '[/color], '
			else:
				text += '[color=green]'+dict[i] + ': ' + str(ability.reqs[i]) + '[/color], ' #fix this someday UGHH
		elif ref < ability.reqs[i]: # /Capitulize
			confirmbutton.set_disabled(true)
			text += '[color=#ff4949]'+dict[i] + ': ' + str(ability.reqs[i]) + '[/color], '
		else:
			text += '[color=green]'+dict[i] + ': ' + str(ability.reqs[i]) + '[/color], '
	text = text.substr(0, text.length() - 2) + '.'
	
	confirmbutton.set_meta('abil', ability)

	get_node("MainScreen/mansion/selfinspect/selfabilitypanel/abilitydescript").set_bbcode(text)


###---Added by Expansion---### Family Expanded
func _on_selfrelatives_pressed():
	get_node("MainScreen/mansion/selfinspect/relativespanel").popup()
	var text = ''
	var person = globals.player
	var relativesdata = globals.state.relativesdata
	if !relativesdata.has(person.id):
		$MainScreen/mansion/selfinspect/relativespanel/relativestext.bbcode_text = person.dictionary("You don't know anything about your relatives. ")
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
	$MainScreen/mansion/selfinspect/relativespanel/relativestext.bbcode_text = text
###---End Expansion---###


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
###---End Expansion---###

########FARM
onready var nodeVats = get_node("MainScreen/mansion/farmpanel/vatspanel")
onready var nodeVatDetails = get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel")
onready var nodeFarmSlave = get_node("MainScreen/mansion/farmpanel/slavefarminspect")
onready var nodeSnailPanel = get_node("MainScreen/mansion/farmpanel/snailpanel")
onready var nodeFarmStore = get_node("MainScreen/mansion/farmpanel/storepanel")
onready var nodeSlaveToFarm = get_node("MainScreen/mansion/farmpanel/slavetofarm")

# call in _ready
func prepareFarmOptionButtons():
	var containers = globals.expansionfarm.containersarray.duplicate()
	containers.erase('bottle') #Bottles aren't valid containers for extraction (just for now)
	# node name : expansionfarm variable ref
	var dictOptions = {
		"stallbedding" : globals.expansionfarm.allbeddings,
		"workstation" : globals.expansionfarm.allworkstations,
		"dailyaction" : globals.expansionfarm.alldailyactions,
		"breedingoption" : globals.expansionfarm.breedingoptions,
		"milkextraction" : globals.expansionfarm.extractorsarray,
		"cumextraction" : globals.expansionfarm.extractorsarray,
		"pissextraction" : globals.expansionfarm.extractorsarray,
		"milkcontaineroptions" : containers,
		"cumcontaineroptions" : containers,
		"pisscontaineroptions" : containers,
	}
	var nodeTemp
	for entry in dictOptions:
		nodeTemp = nodeFarmSlave.get_node(entry)
		nodeTemp.clear()
		for i in dictOptions[entry]:
			nodeTemp.add_item(i)

	nodeTemp = nodeSnailPanel.get_node("autoassign")
	nodeTemp.clear()
	for i in globals.expansionfarm.snailautooptions:
		nodeTemp.add_item(i)

	nodeTemp = nodeVatDetails.get_node("autoassign")
	nodeTemp.clear()
	for i in globals.expansionfarm.vatsautooptions:
		nodeTemp.add_item(i)


func _on_farm_pressed(inputslave = null):
	_on_mansion_pressed()
	###---Added by Expansion---### Farm Expansion
	hide_farm_panels()
	yield(self, 'animfinished')
	var manager = inputslave
	var text = ''
	var residentlimit = variables.resident_farm_limit[globals.state.mansionupgrades.farmcapacity]
	for i in globals.slaves:
		if i.work == 'farmmanager':
			manager = i
			break
	if manager != null:
		manager.work = 'farmmanager'
		text = manager.dictionary('Your farm manager is [color=aqua]' + manager.name_long() + '[/color].')
	else:
		text = "[color=red]You have no assigned manager. Without manager you won't be able to receive farm income. [/color]"
	if globals.state.mansionupgrades.farmhatchery > 0:
		text = text + '\n\nYou have [color=aqua]' + str(globals.state.snails) + '[/color] snails.'
		if globals.state.snails == 0:
			text += "\n[color=aqua]Search the woods north of Shaliq.[/color]"
	var counter = 0
	var list = get_node("MainScreen/mansion/farmpanel/ScrollContainer/VBoxContainer")
	var button = get_node("MainScreen/mansion/farmpanel/ScrollContainer/VBoxContainer/farmbutton")
	for i in list.get_children():
		if i != button && i != get_node("MainScreen/mansion/farmpanel/ScrollContainer/VBoxContainer/farmadd"):
			i.hide()
			i.queue_free()
	for i in globals.slaves:
		if i.sleep == 'farm':
			counter += 1
			var newbutton = button.duplicate()
			newbutton.set_text(i.name_long())
			newbutton.show()
			list.add_child(newbutton)
			newbutton.connect("pressed",self,'farminspect',[i])
	get_node("MainScreen/mansion/farmpanel/ScrollContainer/VBoxContainer/farmadd").set_disabled(counter >= residentlimit)
#	if globals.state.mansionupgrades.farmtreatment == 1:
#		text += "\n\n[color=green]Your farm won't break down its residents. [/color]"
#	else:
#		text += "\n\n[color=red]Your farm may cause heavy stress to its residents. [/color]"
	text += '\n\nYou have ' + str(counter)+ '/' + str(residentlimit) + ' people present in farm. '
	get_node("MainScreen/mansion/farmpanel").show()
	get_node("MainScreen/mansion/farmpanel/farminfo").set_bbcode(text)
	if globals.state.tutorial.farm == false:
		get_node("tutorialnode").farm()
	###---End Expansion---###

func farminspect(person):
	###---Added by Expansion---### Farm Expansion
	hide_farm_panels()
	nodeFarmSlave.show()
	var text = globals.expansionfarm.getFarmDescription(person)
	if person.work == 'cow':
	#	nodeFarmSlave.get_node("slaveassigntext").set_bbcode(person.dictionary("You walk to the pen with $name. The " +person.race+ " $child is tightly kept here being milked out of $his mind all day long. $His eyes are devoid of sentience barely reacting at your approach."))
		nodeFarmSlave.get_node("slaveassigntext").set_bbcode(person.dictionary(text))
#	elif person.work == 'hen':
	#	nodeFarmSlave.get_node("slaveassigntext").set_bbcode(person.dictionary("You walk to the pen with $name. The " +person.race+ " $child is tightly kept here as a hatchery for giant snail, with a sturdy leather harness covering $his body. $His eyes are devoid of sentience barely reacting at your approach. Crouching down next to $him, you can see the swollen curve of $his stomach, stuffed full of the creature's eggs. As you lay a hand on it, you can feel some movement inside - seems like something hatched quite recently and is making its way to be 'born' from $name's well-used hole."))
#		nodeFarmSlave.get_node("slaveassigntext").set_bbcode(person.dictionary(text))
	selectedfarmslave = person

	#Counters
	var beddingCounters = {'hay':0, 'cot':0, 'bed':0}
	var workstationCounters = {'rack':0, 'cage':0}
	var dailyactionCounters = {'exhaust':0, 'inspection':0, 'pamper':0, 'stimulate':0, 'prod':0}
	var liquidExtraction = []
	for type in globals.expansionfarm.liquidtypes:
		liquidExtraction.append('extract'+type)
	var extractorCounters = {'suction':0, 'pump':0, 'pressurepump':0}
	var containerCounters = {'bucket':0, 'pail':0, 'jug':0, 'canister':0}

	var farmhandcounter = 0
	var snailBreeders = 0

	var minInt = -99999 # values not listed in counters recieve this value to prevent deficit
	var listSlaves = globals.slaves.duplicate()
	listSlaves.erase(person)
	for i in listSlaves:
		if i.work == 'farmhand':
			farmhandcounter += 1
		if i.sleep == 'farm':
			beddingCounters[i.farmexpanded.stallbedding] = beddingCounters.get(i.farmexpanded.stallbedding, minInt) + 1
			workstationCounters[i.farmexpanded.workstation] = workstationCounters.get(i.farmexpanded.workstation, minInt) + 1
			dailyactionCounters[i.farmexpanded.dailyaction] = dailyactionCounters.get(i.farmexpanded.dailyaction, minInt) + 1
			for liquid in liquidExtraction:
				var refLiquid = i.farmexpanded[liquid]
				if refLiquid.enabled:
					extractorCounters[refLiquid.method] = extractorCounters.get(refLiquid.method, minInt) + 1
					containerCounters[refLiquid.container] = containerCounters.get(refLiquid.container, minInt) + 1
			if i.farmexpanded.breeding.snails == true:
				snailBreeders += 1
	#temp fix, add selectedfarmslave to liquid counts to prevent assigning more than player has in stock
	for liquid in liquidExtraction:
		var refLiquid = person.farmexpanded[liquid]
		if refLiquid.enabled:
			extractorCounters[refLiquid.method] = extractorCounters.get(refLiquid.method, minInt) + 1
			containerCounters[refLiquid.container] = containerCounters.get(refLiquid.container, minInt) + 1

	#---Bedding
	#Update Buttons
	var counter = 0
	var nodeBedding = nodeFarmSlave.get_node("stallbedding")
	if !globals.selectForOptionButton(person.farmexpanded.stallbedding, nodeBedding, globals.expansionfarm.allbeddings):
		person.farmexpanded.stallbedding = 'dirt'
	for i in globals.expansionfarm.allbeddings:
		# Disable if not enough
		if beddingCounters.get(i,minInt) >= globals.resources.farmexpanded.stallbedding.get(i, 0):
			nodeBedding.set_item_disabled(counter, true)
			nodeBedding.set_item_text(counter, globals.expansionfarm.beddingdict[i].textLack)
		else:
			nodeBedding.set_item_disabled(counter, false)
			nodeBedding.set_item_text(counter, i)
		counter += 1
	
	#---Workstations
	#Build Buttons
	counter = 0
	var nodeWorkstation = nodeFarmSlave.get_node("workstation")
	if !globals.selectForOptionButton(person.farmexpanded.workstation, nodeWorkstation, globals.expansionfarm.allworkstations):
		person.farmexpanded.workstation = 'free'
	for i in globals.expansionfarm.allworkstations:
		# Disable if not enough
		if workstationCounters.get(i,minInt) >= globals.resources.farmexpanded.workstation.get(i, 0):
			nodeWorkstation.set_item_disabled(counter, true)
			nodeWorkstation.set_item_text(counter, globals.expansionfarm.workstationsdict[i].textLack)
		else:
			nodeWorkstation.set_item_disabled(counter, false)
			nodeWorkstation.set_item_text(counter, i)
		counter += 1
	
	#---Daily Actions
	#Build Buttons
	var nodeDailyaction = nodeFarmSlave.get_node("dailyaction")
	if !globals.selectForOptionButton(person.farmexpanded.dailyaction, nodeDailyaction, globals.expansionfarm.alldailyactions):
		person.farmexpanded.dailyaction = 'none'
	
	#Disable if Needed
	counter = 0
	for i in globals.expansionfarm.alldailyactions:
		var refDict = globals.expansionfarm.dailyActionReqDict[i]
		if refDict.has('farmitems'):
			if refDict.farmitems.has('prods') && dailyactionCounters.prod >= globals.itemdict.prods.amount:
				nodeDailyaction.set_item_disabled(counter, true)
				nodeDailyaction.set_item_text(counter, 'Insufficient Prods')
				counter += 1
				continue
		if refDict.farmhand:
			var reqWorkers = dailyactionCounters[i]
			for j in refDict.overlaps:
				reqWorkers += dailyactionCounters[j]
			if reqWorkers >= farmhandcounter:
				nodeDailyaction.set_item_disabled(counter, true)
				nodeDailyaction.set_item_text(counter, 'Insufficient Farmhands')
			else:
				nodeDailyaction.set_item_disabled(counter, false)
				nodeDailyaction.set_item_text(counter, i)
		counter += 1
	
	#---Breeding
	var nodeBreedingoption = nodeFarmSlave.get_node("breedingoption")
	if !globals.selectForOptionButton(person.farmexpanded.breeding.status, nodeBreedingoption, globals.expansionfarm.breedingoptions):
		person.farmexpanded.breeding.status = 'none'
	
	#Disable if Needed
	counter = 0
	var listBreedingReqs = [false, person.vagina == 'none', person.penis == 'none', person.vagina == 'none' || person.penis == 'none']
	var listBreedingDisableText = ['', 'No Vagina Present', 'No Penis Present', 'Both Genitals are needed']
	for i in globals.expansionfarm.breedingoptions:
		if listBreedingReqs[counter]:
			nodeBreedingoption.set_item_disabled(counter, true)
			nodeBreedingoption.set_item_text(counter, listBreedingDisableText[counter])
		else:
			nodeBreedingoption.set_item_disabled(counter, false)
			nodeBreedingoption.set_item_text(counter, i)
		counter += 1


	#Breeding & Snails
	if person.farmexpanded.breeding.snails == true:
		nodeBreedingoption.set_disabled(true)
		nodeBreedingoption.set_text('Breeding Snails')
		person.farmexpanded.breeding.status = 'snails'
		nodeFarmSlave.get_node("specifybreedingpartnerbutton").set_disabled(true)
		nodeFarmSlave.get_node("specifybreedingpartnerbutton").set_text("No Partner Specified")
		nodeFarmSlave.get_node("specifybreedingpartnerbutton").set_tooltip(person.dictionary("$name's womb is being used to breed snails currently."))
		nodeFarmSlave.get_node("snailbreeding").set_disabled(false)
	else:
		nodeBreedingoption.set_disabled(false)
		if person.farmexpanded.breeding.status == 'none':
			nodeFarmSlave.get_node("specifybreedingpartnerbutton").set_disabled(true)
			nodeFarmSlave.get_node("specifybreedingpartnerbutton").set_text("No Partner Specified")
			nodeFarmSlave.get_node("specifybreedingpartnerbutton").set_tooltip(person.dictionary('$name is not assigned to breed or be bred'))
		else:
			var partner
			if person.farmexpanded.breeding.partner != '-1':
				partner = globals.state.findslave(person.farmexpanded.breeding.partner)
				if partner == null:
					person.unassignPartner()
			nodeFarmSlave.get_node("specifybreedingpartnerbutton").set_disabled(false)
			if partner == null:
				nodeFarmSlave.get_node("specifybreedingpartnerbutton").set_text("No Partner Specified")
				nodeFarmSlave.get_node("specifybreedingpartnerbutton").set_tooltip('Click to choose new partner')
			else:
				nodeFarmSlave.get_node("specifybreedingpartnerbutton").set_text(partner.name_long())
				nodeFarmSlave.get_node("specifybreedingpartnerbutton").set_tooltip('Click to unassign partner')

		if person.vagina == 'none':
			nodeFarmSlave.get_node("snailbreeding").set_disabled(true)
			nodeFarmSlave.get_node("snailbreeding").set_tooltip("No Vagina Present.")
		elif globals.state.mansionupgrades.farmhatchery == 0:
			nodeFarmSlave.get_node("snailbreeding").set_disabled(true)
			nodeFarmSlave.get_node("snailbreeding").set_tooltip("You have to unlock Hatchery first.")
		elif snailBreeders >= globals.state.snails:
			nodeFarmSlave.get_node("snailbreeding").set_disabled(true)
			nodeFarmSlave.get_node("snailbreeding").set_tooltip("You don't have any free snails.")
		else:
			nodeFarmSlave.get_node("snailbreeding").set_disabled(false)
			nodeFarmSlave.get_node("snailbreeding").set_tooltip(person.dictionary('Set $name to breed snails.'))

	nodeFarmSlave.get_node("snailbreeding").set_pressed(person.farmexpanded.breeding.snails)
	nodeFarmSlave.get_node("keeprestrained").set_pressed(person.farmexpanded.restrained)
	nodeFarmSlave.get_node("usesedative").set_pressed(person.farmexpanded.usesedative)
	nodeFarmSlave.get_node("giveaphrodisiac").set_pressed(person.farmexpanded.giveaphrodisiac)


	#Milk Extraction only if lactating
	if person.lactation == true:
		nodeFarmSlave.get_node("extractmilk").set_disabled(false)
		nodeFarmSlave.get_node("extractmilk").set_tooltip('')
	else:
		person.farmexpanded.extractmilk.enabled = false
		nodeFarmSlave.get_node("extractmilk").set_disabled(true)
		nodeFarmSlave.get_node("extractmilk").set_tooltip(person.dictionary("$name is not currently lactating."))

	var nodesMethod = [nodeFarmSlave.get_node("milkextraction"), nodeFarmSlave.get_node("cumextraction"), nodeFarmSlave.get_node("pissextraction")]
	var nodesContainer = [nodeFarmSlave.get_node("milkcontaineroptions"), nodeFarmSlave.get_node("cumcontaineroptions"), nodeFarmSlave.get_node("pisscontaineroptions")]
	var nodeTemp1
	var nodeTemp2
	var temp
	#Disable if Not Extracting
	for i in range(liquidExtraction.size()):
		nodeTemp1 = nodesMethod[i]
		nodeTemp2 = nodesContainer[i]
		temp = person.farmexpanded[liquidExtraction[i]]
		nodeFarmSlave.get_node(liquidExtraction[i]).set_pressed(temp.enabled)
		if temp.enabled:
			nodeTemp1.set_disabled(false)
			nodeTemp1.set_tooltip('')
			nodeTemp2.set_disabled(false)
			nodeTemp2.set_tooltip('')
		else:
			temp.method = 'leak'
			temp.container = 'cup'
			temp = person.dictionary("$name is not having $his "+globals.expansionfarm.liquidtypes[i].capitalize()+" collected.")
			nodeTemp1.set_disabled(true)
			nodeTemp1.set_tooltip(temp)
			nodeTemp2.set_disabled(true)
			nodeTemp2.set_tooltip(temp)


	#Set up Extraction options
	var choices = globals.expansionfarm.extractorsarray

	#Select Extractions
	if !globals.selectForOptionButton(person.farmexpanded.extractmilk.method, nodesMethod[0], choices):
		person.farmexpanded.extractmilk.method = 'leak'

	if !globals.selectForOptionButton(person.farmexpanded.extractcum.method, nodesMethod[1], choices):
		person.farmexpanded.extractcum.method = 'leak'

	if !globals.selectForOptionButton(person.farmexpanded.extractpiss.method, nodesMethod[2], choices):
		person.farmexpanded.extractpiss.method = 'leak'

	#Disable Extractions per available items
	counter = 0
	for i in choices:
		temp = extractorCounters.get(i,minInt) >= globals.resources.farmexpanded.extractors.get(i, 0)
		for node in nodesMethod:
			node.set_item_disabled(counter, temp)
		counter += 1


	#Set up Containers options ['cup','bucket','pail','jug','canister', 'bottle']
	choices = globals.expansionfarm.containersarray.duplicate()
	choices.erase('bottle') #Bottles aren't valid containers for extraction (just for now)

	#Select Containers
	if !globals.selectForOptionButton(person.farmexpanded.extractmilk.container, nodesContainer[0], choices):
		person.farmexpanded.extractmilk.container = 'cup'

	if !globals.selectForOptionButton(person.farmexpanded.extractcum.container, nodesContainer[1], choices):
		person.farmexpanded.extractcum.container = 'cup'

	if !globals.selectForOptionButton(person.farmexpanded.extractpiss.container, nodesContainer[2], choices):
		person.farmexpanded.extractpiss.container = 'cup'

	#Disable Containers per available items
	counter = 0
	for i in choices:
		temp = containerCounters.get(i,minInt) >= globals.resources.farmexpanded.containers.get(i, 0)
		for node in nodesContainer:
			node.set_item_disabled(counter, temp)
		counter += 1


	#Show Cattle Avatar | Mirroring SlaveTab
	
	if globals.canloadimage(person.imagefull):
		nodeFarmSlave.get_node("bodypanel/body").set_texture( globals.loadimage(person.imagefull))
	elif globals.gallery.nakedsprites.has(person.unique):
		if person.obed <= 50 || person.stress > 50:
			nodeFarmSlave.get_node("bodypanel/body").set_texture( globals.spritedict[ globals.gallery.nakedsprites[ person.unique].clothrape])
		else:
			nodeFarmSlave.get_node("bodypanel/body").set_texture( globals.spritedict[ globals.gallery.nakedsprites[ person.unique].clothcons])
	else:
		nodeFarmSlave.get_node("bodypanel/body").set_texture(null)
	nodeFarmSlave.get_node("bodypanel/body").show()
	nodeFarmSlave.get_node("bodypanel").show()
	###---End Expansion---###

var selectedfarmslave

###---Added by Expansion---### Farm Expanded
func _on_addcow_pressed():
	var person = selectedfarmslave
	person.sleep = 'farm'
	person.work = 'cow'
	if person.npcexpanded.contentment == 0:
		person.npcexpanded.contentment = 3
	person.exposed.chest = true
	person.exposed.genitals = true
	person.exposed.ass = true
	person.movement = 'crawling'
	person.farmexpanded.dailyaction = 'rest'
	popup(person.dictionary("You lead $name into the farm and inform $him that $he is now going to be one of your livestock. $He nods understandingly, obviously prepared for this fate from your previous discussions.\nYou explain that $his clothing is not permitted here and will only get dirty. $He calmly removes $his clothing and hands it to you, exposing $his naked body.\nYou explain that all livestock must crawl to ensure gravity helps with fluid production. $He drops to $his hands and knees and crawls behind you into $his new stall.\n\nNow you must determine how you want $him to be used."))
#	popup(person.dictionary("You put $name into specially designed pen and hook milking cups onto $his nipples, leaving $him shortly after in the custody of farm."))
#	_on_closeslavefarm_pressed()
	nodeSlaveToFarm.hide()
	_on_farm_pressed()
	rebuild_slave_list()
	farminspect(person)
	
func _on_addcowforced_pressed():
	var person = selectedfarmslave
	person.sleep = 'farm'
	person.work = 'cow'
	person.exposed.chest = true
	person.exposed.genitals = true
	person.exposed.ass = true
	person.movement = 'crawling'
	person.farmexpanded.dailyaction = 'rest'
	if person.consentexp.livestock == true:
		person.npcexpanded.contentment -= 1
		popup(person.dictionary("You lead $name into the farm and coldly tell $him that $he is now going to be one of your livestock. Even though $he knew that this was coming based on your previous discussions and had even consented to it, your forceful demands scare $him.\n\nYou order $him to strip naked immediately and $he does so. You take $his clothes from $him and tell $him that livestock doesn't have any need for clothing. $He nods sadly while $his naked body trembles before you.\n\nYou tell $him that animals have to crawl and $he has no right to stand. $He falls to $his hands and knees before you. You make $him crawl to $his new home, the stall, where $he will await your orders.\n\nNow you must determine how you want $him to be used."))
	else:
		person.npcexpanded.contentment -= 3
		person.exposed.chestforced = true
		person.exposed.genitalsforced = true
		person.exposed.assforced = true
		#Consequences
		var stress = round(rand_range(25,75))
		person.stress += stress
		var loyalloss = round(person.loyal*.2)
		person.loyal -= loyalloss
		popup(person.dictionary("You lead $name into the farm and coldly tell $him that $he is now going to be one of your livestock. $He screams, sobs, and begs you to spare $him. $He pleads with you to release $him from the farm and not force this on $him.\n\nYou order $him to strip naked as livestock don't need to wear clothing. $He clutches $his clothing desparately, forcing you to rip and shred it off of $him. You collect the shredded remains of cloth from $his trembling naked body.\n\nYou order $him to $his knees, saying that livestock must crawl like the animals they are. $He struggles to stand and resist you, forcing you to hit the back of $his knees to force $him to the ground. $He is dragged away sobbing to the stall where $he will be kept until further notice. The experience added [color=red]" + str(stress)+ " Stress[/color] and $name has lost [color=red]" + str(loyalloss)+ " Loyalty[/color] to you for this 'betrayal'.\n\nNow you must determine how you want $him to be used."))
#	popup(person.dictionary("You put $name into specially designed pen and hook milking cups onto $his nipples, leaving $him shortly after in the custody of farm."))
#	_on_closeslavefarm_pressed()
	nodeSlaveToFarm.hide()
	_on_farm_pressed()
	rebuild_slave_list()
	farminspect(person)

#Not Currently Used
func _on_addhen_pressed():
	var person = selectedfarmslave
	person.sleep = 'farm'
	person.work = 'hen'
	popup(person.dictionary("You put $name into specially designed pen and fixate $his body, exposing $his orifices to be fully accessible to giant snail, leaving $him shortly after in the custody of farm."))
	_on_closeslavefarm_pressed()
	_on_farm_pressed()
	rebuild_slave_list()

func selectslavelist(prisoners = false, calledfunction = 'popup', targetnode = self, reqs = 'true', player = false, onlyparty = false):
	var array = []
	if player == true:
		array.append(globals.player)
	for person in globals.slaves:
		globals.currentslave = person
		if person.away.duration != 0:
			continue
		if onlyparty == true && !globals.state.playergroup.has(person.id):
			continue
		if globals.evaluate(reqs) == false:
			continue
		if prisoners == false && person.sleep == 'jail' :
			continue
		if person.sleep == 'farm':
			continue
		array.append(person)
	showChoosePerson(array, calledfunction, targetnode)
###---End Expansion---###

func _on_farmadd_pressed():
	selectslavelist(true, 'farmassignpanel')

func farmassignpanel(person):
	#Handles putting a selected slave into the farm
	hide_farm_panels()
	selectedfarmslave = person
	if person.consentexp.livestock == true:
		nodeSlaveToFarm.get_node("addcow").set_disabled(false)
		nodeSlaveToFarm.get_node("addcow").set_tooltip('')
	else:
		nodeSlaveToFarm.get_node("addcow").set_tooltip(person.dictionary('$name is not willing to become your livestock. Try talking to them about it first.'))
		nodeSlaveToFarm.get_node("addcow").set_disabled(true)
	if person.sstr <= globals.player.sstr || person.sagi <= globals.player.sagi || person.energy < 50:
		nodeSlaveToFarm.get_node("addcowforce").set_disabled(false)
		nodeSlaveToFarm.get_node("addcowforce").set_tooltip(person.dictionary('This action will be very stressful to $name.'))
	else:
		nodeSlaveToFarm.get_node("addcowforce").set_tooltip(person.dictionary('$name is both stronger and faster than you and has over most of their energy. Try again when you can overpower them or when they have less than half energy.'))
		nodeSlaveToFarm.get_node("addcowforce").set_disabled(true)
	
#	var counter = 0
#	for i in globals.slaves:
#		if i.work == 'hen':
#			counter += 1
#	if globals.state.mansionupgrades.farmhatchery == 0:
#		nodeSlaveToFarm.get_node("addhen").set_disabled(true)
#		nodeSlaveToFarm.get_node("addhen").set_tooltip("You have to unlock Hatchery first.")
#	else:
#		if counter >= globals.state.snails:
#			nodeSlaveToFarm.get_node("addhen").set_disabled(true)
#			nodeSlaveToFarm.get_node("addhen").set_tooltip("You don't have any free snails.")
#		else:
#			nodeSlaveToFarm.get_node("addhen").set_disabled(false)
#			nodeSlaveToFarm.get_node("addhen").set_tooltip("")
	var text = "[color=#d1b970][center]Breasts[/center][/color]\nTits Size: [color=aqua]" + person.titssize.capitalize() + "[/color]\nLactation: " + ('[color=lime]' if person.lactation == true else '[color=#ff4949]not ') + 'present[/color]\nHyper-Lactation: '
	text += ('[color=lime]' if person.lactating.hyperlactation == true else '[color=#ff4949]not ')+ 'present[/color]\n\n[color=#d1b970][center]Genitals[/center][/color]\nPenis: ' +('[color=green]' if person.penis != 'none' else '[color=#ff4949]not ')
	text += 'present[/color]\nVagina: ' +('[color=green]' if person.vagina != 'none' else '[color=#ff4949]not ')+ 'present[/color]\n\n' +('[color=lime]Trained Hucow[/color]' if person.spec == 'hucow' else '')
	nodeSlaveToFarm.get_node("slaveassigntext").set_bbcode(text)
	
	###---Added by Expansion---### Display Image and Text | Ankmairdor's BugFix v4
	#Image
	if globals.canloadimage(person.imageportait):
		nodeSlaveToFarm.get_node("image").set_texture(globals.loadimage(person.imageportait))
	elif globals.gallery.nakedsprites.has(person.unique):
		if person.obed <= 50 || person.stress > 50:
			nodeSlaveToFarm.get_node("image").set_texture(globals.spritedict[globals.gallery.nakedsprites[person.unique].clothrape])
		else:
			nodeSlaveToFarm.get_node("image").set_texture(globals.spritedict[globals.gallery.nakedsprites[person.unique].clothcons])
	else:
		nodeSlaveToFarm.get_node("image").set_texture(null)
	#Image Text
	nodeSlaveToFarm.get_node("underpictext").set_bbcode("[center][color=aqua]" + person.name_long()+ "[/color]\n\n" + ('[color=lime]Consent' if person.consentexp.livestock == true else '[color=#ff4949]Consent Not') +' Granted[/color][/center]')
	
	nodeSlaveToFarm.show()
	###---End Expansion---###

func _on_releasefromfarm_pressed():
	var person = selectedfarmslave
	hide_farm_panels()
	person.work = 'rest'
	person.sleep = 'communal'
	person.npcexpanded.contentment += 1
	person.farmexpanded.dailyaction = 'none'
	person.farmexpanded.workstation = 'free'
	person.farmexpanded.stallbedding = 'dirt'
	person.farmexpanded.breeding.status = 'none'
	person.farmexpanded.breeding.snails = false
	for i in ['extractmilk','extractcum','extractpiss']:
		person.farmexpanded[i].enabled = false
		person.farmexpanded[i].method = 'leak'
		person.farmexpanded[i].container = 'cup'
	nodeFarmSlave.hide()
	_on_farm_pressed()
	rebuild_slave_list()

func _on_closeslaveinspect_pressed():
	_on_farm_pressed()
	rebuild_slave_list()
	nodeFarmSlave.hide()

#Currently Unused
func _on_sellproduction_pressed():
	selectedfarmslave.farmoutcome = nodeFarmSlave.get_node("sellproduction").is_pressed()

func _on_over_pressed():
	mainmenu()

###---Added by Expansion---### Farm Expansion
func _on_workstation_selected( ID ):
	selectedfarmslave.farmexpanded.workstation = globals.expansionfarm.allworkstations[ID]
	farminspect(selectedfarmslave)

func _on_stallbedding_selected( ID ):
	selectedfarmslave.farmexpanded.stallbedding = globals.expansionfarm.allbeddings[ID]
	farminspect(selectedfarmslave)

func _on_dailyaction_selected( ID ):
	selectedfarmslave.farmexpanded.dailyaction = globals.expansionfarm.alldailyactions[ID]
	farminspect(selectedfarmslave)

func _on_aphrodisiacbutton_pressed():
	selectedfarmslave.farmexpanded.giveaphrodisiac = nodeFarmSlave.get_node("giveaphrodisiac").is_pressed()
	farminspect(selectedfarmslave)

func _on_usesedative_pressed():
	selectedfarmslave.farmexpanded.usesedative = nodeFarmSlave.get_node("usesedative").is_pressed()
	farminspect(selectedfarmslave)

func _on_keeprestrained_pressed():
	selectedfarmslave.farmexpanded.restrained = nodeFarmSlave.get_node("keeprestrained").is_pressed()
	farminspect(selectedfarmslave)

func _on_extractmilk_pressed():
	selectedfarmslave.farmexpanded.extractmilk.enabled = nodeFarmSlave.get_node("extractmilk").is_pressed()
	farminspect(selectedfarmslave)

func _on_extractfluidselected( ID, fluidExtract ):
	selectedfarmslave.farmexpanded[fluidExtract].method = globals.expansionfarm.extractorsarray[ID]
	farminspect(selectedfarmslave)

func _on_fluidcontainer_selected( ID, fluidExtract ):
	selectedfarmslave.farmexpanded[fluidExtract].container = globals.expansionfarm.containersarray[ID]
	farminspect(selectedfarmslave)

func _on_extractcum_pressed():
	selectedfarmslave.farmexpanded.extractcum.enabled = nodeFarmSlave.get_node("extractcum").is_pressed()
	farminspect(selectedfarmslave)

func _on_extractpiss_pressed():
	selectedfarmslave.farmexpanded.extractpiss.enabled = nodeFarmSlave.get_node("extractpiss").is_pressed()
	farminspect(selectedfarmslave)

func _on_breeding_option_selected( ID ):
	selectedfarmslave.farmexpanded.breeding.status = globals.expansionfarm.breedingoptions[ID]
	if ID == 0:
		selectedfarmslave.unassignPartner()		
#Tried to get it to check consent first
#	person.assignBreedingJob(breeding[ID])
	farminspect(selectedfarmslave)

func _on_specifybreedingpartnerbutton_pressed():
	if selectedfarmslave.farmexpanded.breeding.partner == '-1':
		selectslavelist_breedingpartner()
	else:
		selectedfarmslave.unassignPartner()
		farminspect(selectedfarmslave)
	

func selectslavelist_breedingpartner():
	var array = []
	var breeding = selectedfarmslave.farmexpanded.breeding.status
	if breeding == 'breeder':
		if globals.player.penis != 'none':
			array.append(globals.player)
	elif breeding == 'stud':
		if globals.player.vagina != 'none':
			array.append(globals.player)
	elif breeding == 'both':
		if globals.player.vagina != 'none' || globals.player.penis != 'none':
			array.append(globals.player)
	for person in globals.slaves:
		if person == selectedfarmslave:
			continue
		if person.away.duration != 0:
			continue
		if person.work != 'cow' && person.work != 'hen':
			if !globals.jobs.jobdict[person.work].location.has('farm') && !globals.jobs.jobdict[person.work].location.has('mansion') && !globals.jobs.jobdict[person.work].tags.has('farm') && !globals.jobs.jobdict[person.work].tags.has('mansion'):
				continue
		if breeding == 'breeder': # TODO better consent limiting?
			if person.penis == 'none': # || !person.consentexp.stud:
				continue
		elif breeding == 'stud':
			if person.vagina == 'none': # || !person.consentexp.breeder:
				continue
		elif breeding == 'both':
			if person.vagina == 'none' && person.penis == 'none': #(person.vagina == 'none' || !person.consentexp.breeder) && (person.penis == 'none' || !person.consentexp.stud):
				continue
		if person.sleep == 'jail' :
			continue
		array.append(person)
	showChoosePerson(array, 'assignspecificbreedingpartner', self)

func assignspecificbreedingpartner(inputslave = null):
	popup( selectedfarmslave.assignBreedingPartner(inputslave.id) )
	rebuild_slave_list()
	farminspect(selectedfarmslave)
	
func _on_snailbreeding_pressed():
	selectedfarmslave.farmexpanded.breeding.status = 'none'
	selectedfarmslave.unassignPartner()
	selectedfarmslave.farmexpanded.breeding.snails = nodeFarmSlave.get_node("snailbreeding").is_pressed()
	farminspect(selectedfarmslave)

#---Snail Panel
var dictPiles = {
	'food': {'node':"assignfood", 'pos': "\nEggs for [color=aqua]Food[/color]: [color=aqua]", 'none': "\n[color=red]No Snail Eggs assigned to [color=aqua]Cook[/color][/color] "},
	'sell': {'node':"assignsell", 'pos': "\nEggs for [color=aqua]Sale[/color]: [color=aqua]", 'none': "\n[color=red]No Snail Eggs assigned to [color=aqua]Sell[/color][/color] "},
	'hatch': {'node':"assignhatch", 'pos': "\nEggs for [color=aqua]Hatching[/color]: [color=aqua]", 'none': "\n[color=red]No Snail Eggs assigned to [color=aqua]Hatch[/color] in the Incubators[/color] "},
}

func _on_snailbutton_pressed():
	hide_farm_panels()

	var text
	#Snail Display
	if globals.state.snails > 0:
		text = "[center]Total Snails Available: [color=aqua]" + str(globals.state.snails) + "[/color][/center] "
	else:
		text = "[center][color=red]No Snails Available[/color][/center] "

	#Unassigned Eggs Display
	var nodesAdd = [nodeSnailPanel.get_node("assignfood/add"), nodeSnailPanel.get_node("assignsell/add"), nodeSnailPanel.get_node("assignhatch/add")]
	var temp = globals.resources.farmexpanded.snails.eggs
	nodeSnailPanel.get_node("assignstockpile/counter").set_bbcode(str(temp))
	if temp > 0:
		text += "\nTotal Unassigned Snail Eggs Available: [color=aqua]" + str(temp) + "[/color] "
		for node in nodesAdd:
			node.set_disabled(false)
			node.set_tooltip('Pull from the Unassigned stockpile')
	else:
		text += "\n[color=red]No Unassigned Snail Eggs Available[/color] "
		for node in nodesAdd:
			node.set_disabled(true)
			node.set_tooltip('No unassigned eggs are available.')

	for pile in dictPiles:
		temp = globals.resources.farmexpanded.snails[pile]
		var node = nodeSnailPanel.get_node(dictPiles[pile].node)
		node.get_node("counter").set_bbcode(str(temp))
		if temp > 0: 
			text += dictPiles[pile].pos + str(temp) + "[/color] "
			node.get_node("subtract").set_disabled(false)
			node.get_node("subtract").set_tooltip('Assign back to the Unassigned stockpile.')
		else:
			text += dictPiles[pile].none
			node.get_node("subtract").set_disabled(true)
			node.get_node("subtract").set_tooltip('No eggs are available in this stockpile.')
		if pile == 'food':
			if globals.resources.farmexpanded.snails.cookwithoutchef == true:
				text += "|| [color=green]Eggs will still be cooked without a Chef present[/color] "
			else:
				text += "|| [color=green]Eggs will not be cooked without a Chef present[/color] "
		elif pile == 'sell':
			text += "|| Current Price per Egg: [color=aqua]" +str(globals.resources.farmexpanded.snails.goldperegg)+ "[/color]"

	nodeSnailPanel.get_node("nochefcook").set_pressed(globals.resources.farmexpanded.snails.cookwithoutchef)
	
	#Incubators
	var counter = 0
	var temptext = ""
	var incubators = globals.resources.farmexpanded.incubators
	for i in globals.expansionfarm.inc_array:
		if incubators[i].level > 0:
			counter += 1
			temptext += "\n" + incubators[i].name + ": [color=aqua]Level " +str(incubators[i].level)+"[/color] - "
			if incubators[i].filled == true:
				temptext += "[color=green]Incubating Egg Growth (" +str(incubators[i].growth)+"/10) "
			else:
				temptext += "[color=red]Empty[/color]"
	text += "\n\n[center]Incubators[/center]\n[center]Total Incubators: [color=aqua]" +str(counter)+ " / 10[/color][/center]\n" + temptext
	nodeSnailPanel.get_node("snaildetailstext").set_bbcode(text)
	
	#AutoPanel
	if !globals.selectForOptionButton(globals.resources.farmexpanded.snails.auto, nodeSnailPanel.get_node("autoassign"), globals.expansionfarm.snailautooptions):
		globals.resources.farmexpanded.snails.auto = 'none'
	
	nodeSnailPanel.show()

func _on_snailpanelchange_pressed(type, amount):
	globals.resources.farmexpanded.snails[type] += amount
	globals.resources.farmexpanded.snails.eggs -= amount
	_on_snailbutton_pressed()

func _on_nochefcook_pressed():
	globals.resources.farmexpanded.snails.cookwithoutchef = nodeSnailPanel.get_node("nochefcook").is_pressed()
	_on_snailbutton_pressed()

func _on_snail_autoassign_selected( ID ):
	globals.resources.farmexpanded.snails.auto = globals.expansionfarm.snailautooptions[ID]
	_on_snailbutton_pressed()

func _on_snailpanelclose_pressed():
	nodeSnailPanel.hide()

#Vats
func _on_vatsbutton_pressed():
	hide_farm_panels()
	var text
	var vatcount = 0
	var vatmax = 0
	var bottlecount = globals.resources.farmexpanded.containers.bottle
	var refVats = globals.resources.farmexpanded.vats

	#Vat Capacities
	for fluid in globals.expansionfarm.fluidtypes:
		var fluidVat = "vat" + fluid
		var nodeButton = nodeVats.get_node(fluidVat+"button")
		if globals.state.mansionupgrades[fluidVat] > 0:
			nodeButton.set_disabled(false)
			nodeButton.set_tooltip('Manage '+fluid.capitalize()+' Vat.')
			vatcount += 1
			vatmax = globals.getVatMaxCapacity(fluidVat)
			if refVats[fluid].vat < vatmax:
				text = "[center][color=aqua]"
			else:
				text = "[center][color=red]"
			text += str(refVats[fluid].vat) + "[/color] / [color=aqua]" + str(vatmax) + "[/color][/center]"
		else: #Disable Unpurchased Buttons
			nodeButton.set_disabled(true)
			nodeButton.set_tooltip('No '+fluid.capitalize()+' Vat Installed.')
			text = "[center][color=red]No "+fluid.capitalize()+" Vat[/color][/center]"
		nodeVats.get_node("capacity"+fluid+"text").set_bbcode(text)
		bottlecount -= refVats[fluid].bottle2refine + refVats[fluid].bottle2sell

	#Bottler
	var bottlerLevel = globals.resources.farmexpanded.bottler.level
	text = "[center][color=#d1b970]Bottler Level:[/color] [color=aqua]" + str(bottlerLevel) + "[/color][/center]"
	text += "\n[color=#d1b970]Energy Cost per Bottle Created: [/color]\nMilk: [color=aqua]" + str(refVats.milk.basebottlingenergy - bottlerLevel) + "[/color]\nSemen: [color=aqua]" + str(refVats.semen.basebottlingenergy - bottlerLevel)
	text += "[/color]\nLube: [color=aqua]" + str(refVats.lube.basebottlingenergy - bottlerLevel) + "[/color]\nPiss: [color=aqua]" + str(refVats.piss.basebottlingenergy - bottlerLevel) + "[/color]"
	text += "\n\n[color=#d1b970]Total Bottles Produced:[/color] [color=aqua]" + str(globals.resources.farmexpanded.bottler.totalproduced) + "[/color]"
	nodeVats.get_node("bottlertext").set_bbcode(text)

	#Bottle Count
	text = "[center]Stockpile: " + ( "([color=aqua]" if bottlecount > 0 else "([color=red]" )
	text += str(bottlecount) + "[/color]) / " + str(globals.resources.farmexpanded.containers.bottle) + "[/center] "
	nodeVats.get_node("buybottles/counter").set_bbcode(text)
	
	text = "[center]Cost: " + str(globals.expansionfarm.containerdict.bottle.cost) + "[/center]"
	nodeVats.get_node("buybottles/cost").set_bbcode(text)
	
	if globals.resources.gold >= globals.expansionfarm.containerdict.bottle.cost:
		nodeVats.get_node("buybottles/add1").set_disabled(false)
		nodeVats.get_node("buybottles/add1").set_tooltip('Buy 1 Bottle to use for Refining or Sales.')
	else:
		nodeVats.get_node("buybottles/add1").set_disabled(true)
		nodeVats.get_node("buybottles/add1").set_tooltip('You cannot afford 1 Bottle.')
	if globals.resources.gold >= globals.expansionfarm.containerdict.bottle.cost*10:
		nodeVats.get_node("buybottles/add10").set_disabled(false)
		nodeVats.get_node("buybottles/add10").set_tooltip('Buy 10 Bottles to use for Refining or Sales.')
	else:
		nodeVats.get_node("buybottles/add10").set_disabled(true)
		nodeVats.get_node("buybottles/add10").set_tooltip('You cannot afford 10 Bottles.')

	#Main Text: Spruce up with lively details or events later
	text = "You walk into the area of your farm that you have sectioned off and secured for your Vats. You see the " + str(vatcount) + (" vats" if vatcount != 1 else " vat") + " before you to store the fluids and liquids gathered from your slaves."
	if vatcount >= globals.state.mansionupgrades.vatspace:
		text += "[center][color=red]No Remaining Space for new Vats. " + str(vatcount) + " / " + str(globals.state.mansionupgrades.vatspace) + "[/color][/center]"
	else:
		text += "[center][color=aqua]Space Open for new Vats: " + str(globals.state.mansionupgrades.vatspace - vatcount) + " / " + str(globals.state.mansionupgrades.vatspace) + "[/color][/center]"
	nodeVats.get_node("vatgeneraltext").set_bbcode(text)

	nodeVats.show()

func _on_buybottles_pressed(num):
	globals.resources.gold -= globals.expansionfarm.containerdict.bottle.cost*num
	globals.resources.farmexpanded.containers.bottle += num
	_on_vatsbutton_pressed()

func _on_vatspanelclose_pressed():
	nodeVats.hide()

#---Vat Details (To manage the specific Vats)
func vatsdetailspanel(type):
	nodeVatDetails.set_meta('type', type)

	var refVats = globals.resources.farmexpanded.vats
	var vatCur = refVats[type]
	var vatmax = globals.getVatMaxCapacity('vat'+type)
	var text
	
	#Header Text
	nodeVatDetails.get_node("vatheadertext").set_bbcode("[center][color=aqua]" + str(type).capitalize() + " Vat Management[/color][/center]")
	
	#Body Text
	text = "Vat Level: [color=aqua]" + str(globals.state.mansionupgrades['vat'+type]) + "[/color]"
	#Bottle Count
	var bottlecount = globals.resources.farmexpanded.containers.bottle
	for fluid in globals.expansionfarm.fluidtypes:
		bottlecount -= refVats[fluid].bottle2refine + refVats[fluid].bottle2sell
	text += "\nTotal Bottles: [color=aqua]" + str(globals.resources.farmexpanded.containers.bottle) + "[/color]\nUnassigned Bottles: "
	text += ("[color=aqua]" if bottlecount >= 0 else "[color=red]") + str(bottlecount) + "[/color]"
	nodeVatDetails.get_node("vatdetailstext").set_bbcode(text)
	
	#Unassigned (General Vat)
	nodeVatDetails.get_node("assignstockpile/counter").set_bbcode("[center]" + str(vatCur.vat) + " / " + str(vatmax) + " [/center]")
	var freespace = vatmax - (vatCur.vat + vatCur.food + vatCur.bottle2refine + vatCur.bottle2sell)
	freespace = clamp(freespace, 0, 1000)
	text = ("[center]Free Space: [color=aqua]" if freespace > 0 else "[center]Free Space: [color=red]") + str(freespace) + "[/color]"
	nodeVatDetails.get_node("assignstockpile/freespace").set_bbcode(text)
	
	#Food
	nodeVatDetails.get_node("assignfood/counter").set_bbcode("[center]" + str(vatCur.food) + "[/center]")
	#Enable/Disable Add/Subtract buttons
	#Subtract Buttons
	if vatCur.food > 0:
		nodeVatDetails.get_node("assignfood/subtract").set_disabled(false)
		nodeVatDetails.get_node("assignfood/subtract").set_tooltip('Remove from the Food Stockpile.')
	else:
		nodeVatDetails.get_node("assignfood/subtract").set_disabled(true)
		nodeVatDetails.get_node("assignfood/subtract").set_tooltip('Nothing has been set to be cooked.')
	#Add Buttons
	if vatCur.vat > 0:
		nodeVatDetails.get_node("assignfood/add").set_disabled(false)
		nodeVatDetails.get_node("assignfood/add").set_tooltip('Assign to the Kitchen to be cooked.')
	else:
		nodeVatDetails.get_node("assignfood/add").set_disabled(true)
		nodeVatDetails.get_node("assignfood/add").set_tooltip('All of the liquid in the vat has been assigned to a stockpile.')
	
	#Refine
	nodeVatDetails.get_node("assignrefine/actualcounter").set_bbcode("[center]Stockpile: " + str(globals.itemdict['bottled'+type].amount) + "[/center]")
	nodeVatDetails.get_node("assignrefine/pendingcounter").set_bbcode("[center]" + str(vatCur.bottle2refine) + "[/center]")
	#Subtract Buttons
	if vatCur.bottle2refine > 0:
		nodeVatDetails.get_node("assignrefine/subtract").set_disabled(false)
		nodeVatDetails.get_node("assignrefine/subtract").set_tooltip('Remove from the Refined Stockpile.')
	else:
		nodeVatDetails.get_node("assignrefine/subtract").set_disabled(true)
		nodeVatDetails.get_node("assignrefine/subtract").set_tooltip('Nothing has been set to be refined.')
	#Add Buttons
	if vatCur.vat > 0:
		nodeVatDetails.get_node("assignrefine/add").set_disabled(false)
		nodeVatDetails.get_node("assignrefine/add").set_tooltip('Assign to be refined into usable bottles.')
	else:
		nodeVatDetails.get_node("assignrefine/add").set_disabled(true)
		nodeVatDetails.get_node("assignrefine/add").set_tooltip('All of the liquid in the vat has been assigned to a stockpile.')
	
	#Sell
	nodeVatDetails.get_node("assignsell/actualcounter").set_bbcode("[center]Stockpile: " + str(vatCur.sell) + "[/center]")
	nodeVatDetails.get_node("assignsell/pendingcounter").set_bbcode("[center]" + str(vatCur.bottle2sell) + "[/center]")
	#Subtract Buttons
	if vatCur.bottle2sell > 0:
		nodeVatDetails.get_node("assignsell/subtract").set_disabled(false)
		nodeVatDetails.get_node("assignsell/subtract").set_tooltip('Remove from the Sales Stockpile.')
	else:
		nodeVatDetails.get_node("assignsell/subtract").set_disabled(true)
		nodeVatDetails.get_node("assignsell/subtract").set_tooltip('Nothing has been set to be sold.')
	#Add Buttons
	if vatCur.vat > 0:
		nodeVatDetails.get_node("assignsell/add").set_disabled(false)
		nodeVatDetails.get_node("assignsell/add").set_tooltip('Assign to be bottled for sale.')
	else:
		nodeVatDetails.get_node("assignsell/add").set_disabled(true)
		nodeVatDetails.get_node("assignsell/add").set_tooltip('All of the liquid in the vat has been assigned to a stockpile.')
	
	#AutoBuy Bottles
	nodeVatDetails.get_node("autobuybottles").set_pressed(vatCur.autobuybottles)
	
	#AutoAssign Options
	if !globals.selectForOptionButton(vatCur.auto, nodeVatDetails.get_node("autoassign"), globals.expansionfarm.vatsautooptions):
		vatCur.auto = 'vat'
	
	nodeVatDetails.show()

func _on_vat_change_pressed(stockpile, amount):
	var type = nodeVatDetails.get_meta('type')
	globals.resources.farmexpanded.vats[type].vat -= amount
	globals.resources.farmexpanded.vats[type][stockpile] += amount
	vatsdetailspanel(type)

func _on_autobuybottles_pressed():
	var type = nodeVatDetails.get_meta('type')
	globals.resources.farmexpanded.vats[type].autobuybottles = nodeVatDetails.get_node("autobuybottles").is_pressed()
	vatsdetailspanel(type)

func _on_vats_autoassign_selected( ID ):
	var type = nodeVatDetails.get_meta('type')
	globals.resources.farmexpanded.vats[type].auto = globals.expansionfarm.vatsautooptions[ID]
	vatsdetailspanel(type)

func _on_vatsdetailspanelclose_pressed():
	nodeVatDetails.hide()
	_on_vatsbutton_pressed()

func _on_workersbutton_pressed():
	hide_farm_panels()
	#Display Farmhands, Milkmaids, Milk Merchants, and Studs
	var hasworkers = false
	var text = "[color=#d1b970][center]Workers Panel[/center][/color]"
	
	var workersDict = {
		'farmmanager' : [],
		'farmhand' : [],
		'milkmaid' : [],
		'bottler' : [],
		'milkmerchant' : [],
	}

	for person in globals.slaves:
		if workersDict.has(person.work):
			workersDict[person.work].append(person)

	#Farm Manager
	text += "\n\n\n[color=#d1b970][center]Farm Manager[/center][/color]"
	for person in workersDict.farmmanager:
		text += "\n[color=aqua]"+person.name_short()+"[/color] - Energy: " + ("[color=green]" if person.energy >= 20 else "[color=red]") +str(round(person.energy)) + "[/color] - Job Experience: " + str(person.jobskills.farmmanager)
		text += "\n\n[color=yellow]Your Farm Manager will serve as a substitute Farm Hand, Milk Maid, or Bottler if none are assigned.[/color]"
	if workersDict.farmmanager.empty():
		text += "\n[color=red]None Assigned[/color]"
	
	#Farmhands
	text += "\n\n[color=#d1b970][center]Farm Hands[/center][/color]"
	for person in workersDict.farmhand:
		text += "\n[color=aqua]"+person.name_short()+"[/color] - Energy: " + ("[color=green]" if person.energy >= 20 else "[color=red]") +str(round(person.energy)) + "[/color] - Job Experience: " + str(person.jobskills.farmhand)
		if person.traits.has('Sadist'):
			text += " - [color=aqua]Sadist[/color]"
		if person.traits.has('Dominant'):
			text += " - [color=aqua]Dominant[/color]"
	if workersDict.farmhand.empty():
		text += "\n[color=red]None Assigned[/color]"

	#Milk-Maids
	text += "\n\n[color=#d1b970][center]Milk Maids[/center][/color]"
	for person in workersDict.milkmaid:
		text += "\n[color=aqua]"+person.name_short()+"[/color] - Energy: " + ("[color=green]" if person.energy >= 20 else "[color=red]") +str(round(person.energy)) + "[/color] - Job Experience: " + str(person.jobskills.milking)
		if person.traits.has('Sadist'):
			text += " - [color=aqua]Sadist[/color]"
		if person.traits.has('Dominant'):
			text += " - [color=aqua]Dominant[/color]"
	if workersDict.milkmaid.empty():
		text += "\n[color=red]None Assigned[/color]"

	#Milk Merchant
	text += "\n\n[color=#d1b970][center]Milk Merchants[/center][/color]"
	for person in workersDict.milkmerchant:
		text += "\n[color=aqua]"+person.name_short()+"[/color] - Energy: " + ("[color=green]" if person.energy >= 20 else "[color=red]") +str(round(person.energy)) + "[/color] - Job Experience: " + str(person.jobskills.milkmerchant)
	if workersDict.milkmerchant.empty():
		text += "\n[color=red]None Assigned[/color]"

	#Bottlers
	text += "\n\n[color=#d1b970][center]Bottlers[/center][/color]"
	for person in workersDict.bottler:
		text += "\n[color=aqua]"+person.name_short()+"[/color] - Energy: " + ("[color=green]" if person.energy >= 20 else "[color=red]") +str(round(person.energy)) + "[/color] - Job Experience: " + str(person.jobskills.bottler)
	if workersDict.bottler.empty():
		text += "\n[color=red]None Assigned[/color]"
	
	#Apply Text
	get_node("MainScreen/mansion/farmpanel/workerspanel/textbody").set_bbcode(text)
	get_node("MainScreen/mansion/farmpanel/workerspanel").show()

func _on_workerpanelclose_closed():
	get_node("MainScreen/mansion/farmpanel/workerspanel").hide()

#---Store Panel
func _on_storebutton_pressed():
	hide_farm_panels()
	var farm = globals.resources.farmexpanded
	var nodeTemp
	var temp
	var refDict

	#---Containers
	refDict = globals.expansionfarm.containerdict
	for i in refDict:
		temp = refDict[i]
		if temp.size <= 8: #quick filter (cup and bottle) - keep an eye on this if container stats change
			continue
		nodeTemp = nodeFarmStore.get_node("containers/" + i)
		nodeTemp.get_node("current").set_bbcode("[right][color=aqua]" + str(farm.containers[i]) + "[/color][/right]")
		nodeTemp.get_node("price").set_bbcode("[right][color=yellow]" + str(temp.cost) + "[/color][/right]")
		if globals.resources.gold >= temp.cost:
			nodeTemp.get_node("add").set_disabled(false)
			nodeTemp.get_node("add").set_tooltip('Purchase 1 ' + i.capitalize())
		else:
			nodeTemp.get_node("add").set_disabled(true)
			nodeTemp.get_node("add").set_tooltip('Insufficient Funds')

	#---Extractors
	refDict = globals.expansionfarm.extractorsdict
	for i in refDict:
		temp = refDict[i]
		if temp.cost <= 0:
			continue
		nodeTemp = nodeFarmStore.get_node("extractors/" + i)
		nodeTemp.get_node("current").set_bbcode("[right][color=aqua]" + str(farm.extractors[i]) + "[/color][/right]")
		nodeTemp.get_node("price").set_bbcode("[right][color=yellow]" + str(temp.cost) + "[/color][/right]")
		if globals.resources.gold >= temp.cost:
			nodeTemp.get_node("add").set_disabled(false)
			nodeTemp.get_node("add").set_tooltip('Purchase 1 ' + temp.name)
		else:
			nodeTemp.get_node("add").set_disabled(true)
			nodeTemp.get_node("add").set_tooltip('Insufficient Funds')

	#---Workstations
	refDict = globals.expansionfarm.workstationsdict
	for i in refDict:
		temp = refDict[i]
		if temp.cost <= 0:
			continue
		nodeTemp = nodeFarmStore.get_node("workstations/" + i)
		nodeTemp.get_node("current").set_bbcode("[right][color=aqua]" + str(farm.workstation[i]) + "[/color][/right]")
		nodeTemp.get_node("price").set_bbcode("[right][color=yellow]" + str(temp.cost) + "[/color][/right]")
		if globals.resources.gold >= temp.cost:
			nodeTemp.get_node("add").set_disabled(false)
			nodeTemp.get_node("add").set_tooltip('Purchase 1 ' + temp.name)
		else:
			nodeTemp.get_node("add").set_disabled(true)
			nodeTemp.get_node("add").set_tooltip('Insufficient Funds')
	
	#---Bedding
	refDict = globals.expansionfarm.beddingdict
	for i in refDict:
		temp = refDict[i]
		if temp.cost <= 0:
			continue
		nodeTemp = nodeFarmStore.get_node("bedding/" + i)
		nodeTemp.get_node("current").set_bbcode("[right][color=aqua]" + str(farm.stallbedding[i]) + "[/color][/right]")
		nodeTemp.get_node("price").set_bbcode("[right][color=yellow]" + str(temp.cost) + "[/color][/right]")
		if globals.resources.gold >= temp.cost:
			nodeTemp.get_node("add").set_disabled(false)
			nodeTemp.get_node("add").set_tooltip('Purchase 1 ' + temp.name)
		else:
			nodeTemp.get_node("add").set_disabled(true)
			nodeTemp.get_node("add").set_tooltip('Insufficient Funds')
	
	#---Misc Items
	refDict = globals.expansionfarm.itemsdict
	for i in refDict:
		temp = refDict[i]
		nodeTemp = nodeFarmStore.get_node("items/" + i)
		nodeTemp.get_node("current").set_bbcode("[right][color=aqua]" + str(globals.itemdict[i].amount if globals.itemdict.has(i) else globals.resources.farmexpanded.farminventory[i]) + "[/color][/right]")
		nodeTemp.get_node("price").set_bbcode("[right][color=yellow]" + str(temp.cost) + "[/color][/right]")
		if globals.resources.gold >= temp.cost:
			nodeTemp.get_node("add").set_disabled(false)
			nodeTemp.get_node("add").set_tooltip('Purchase 1 ' + temp.name)
		else:
			nodeTemp.get_node("add").set_disabled(true)
			nodeTemp.get_node("add").set_tooltip('Insufficient Funds')
	
	nodeFarmStore.show()

#Buy Buttons
func _on_buy_container(type):
	globals.resources.gold -= globals.expansionfarm.containerdict[type].cost
	globals.resources.farmexpanded.containers[type] += 1
	_on_storebutton_pressed()

func _on_buy_extractor(type):
	globals.resources.gold -= globals.expansionfarm.extractorsdict[type].cost
	globals.resources.farmexpanded.extractors[type] += 1
	_on_storebutton_pressed()

func _on_buy_workstation(type):
	globals.resources.gold -= globals.expansionfarm.workstationsdict[type].cost
	globals.resources.farmexpanded.workstation[type] += 1
	_on_storebutton_pressed()

func _on_buy_bedding(type):
	globals.resources.gold -= globals.expansionfarm.beddingdict[type].cost
	globals.resources.farmexpanded.stallbedding[type] += 1
	_on_storebutton_pressed()

func _on_buy_farmitem(type):
	globals.resources.gold -= globals.expansionfarm.itemsdict[type].cost
	globals.itemdict[type].amount += 1
	_on_storebutton_pressed()

func _on_incubatorspanel_pressed():
	var text = ""
	var incubators = globals.resources.farmexpanded.incubators
	for num in globals.expansionfarm.inc_array:
		var nodeInc = nodeFarmStore.get_node("incubatorspanel/inc_" + num)
		var cost
		if incubators[num].level <= 0:
			nodeInc.get_node("status").set_bbcode('[center][color=red]Not Installed[/color][/center]')
			nodeInc.get_node("level").set_bbcode('[center][color=red]X[/color][/center]')
			cost = incubators.basecost
		else:
			if incubators[num].filled == true:
				nodeInc.get_node("status").set_bbcode('[center][color=green]Hatching Egg[/color][/center]')
			else:
				nodeInc.get_node("status").set_bbcode('[center][color=aqua]Installed[/color][/center]')
			nodeInc.get_node("level").set_bbcode('[center][color=aqua]'+ str(incubators[num].level) +'[/color][/center]')
			cost = round((incubators[num].level * incubators.upgrademultiplier) * incubators.basecost)

		nodeInc.get_node("cost").set_bbcode('[right][color=yellow]'+ str(cost) + '[/color][/right]')
		if globals.resources.gold >= cost:
			nodeInc.get_node("upgrade").set_disabled(false)
			nodeInc.get_node("upgrade").set_tooltip('Spend ' + str(cost) + ' Gold to upgrade this Incubator')
		else:
			nodeInc.get_node("upgrade").set_disabled(true)
			nodeInc.get_node("upgrade").set_tooltip('Insufficient Funds')
	
	nodeFarmStore.get_node("incubatorspanel").show()

func _on_incubator_upgrade(number):
	var incubators = globals.resources.farmexpanded.incubators
	if incubators[number].level <= 0:
		globals.resources.gold -= incubators.basecost
	else:
		globals.resources.gold -= round((incubators[number].level * incubators.upgrademultiplier) * incubators.basecost)
	incubators[number].level += 1
	_on_incubatorspanel_pressed()

func _on_incubatorspanel_close():
	nodeFarmStore.get_node("incubatorspanel").hide()

func _on_storepanel_close():
	nodeFarmStore.hide()

#---Help Button
func _on_farmhelpbutton_pressed():
	hide_farm_panels()
	var text = ""
	#---FAQ
	text += "[color=#d1b970][center]Farming Guide FAQ[/center][/color]"
	text += "\n\n[color=#d1b970]What is the Point of Farming?[/color]\nFarming is a great way to gain passive income or food from slaves that are not needed elsewhere. You can set your slaves to regularly breed with each other to breed traits or races that may be difficult otherwise (without having to use your limited [color=aqua]daily interactions[/color] to do so). You can also collect and refine liquids to make items that are impossible to obtain otherwise."
	#Basics
	text += "\n\n[color=#d1b970]What are the Basics?[/color]\nThere are a few core elements of farming that you will need to understand to get started. You will need [color=aqua]People[/color] in the form of [color=aqua]Workers[/color] or [color=aqua]Livestock[/color]. You will need [color=aqua]Equipment[/color] which can be bought at the [color=aqua]Store[/color]. Finally, assuming you are extracting liquids and not just breeding, you will need [color=aqua]Vats[/color] to store the liquids extracted until you can [color=aqua]Sell[/color], [color=aqua]Refine[/color], or [color=aqua]Cook[/color] those liquids."
	text += "\nExtracted Liquids are stocked in your [color=aqua]Vat Stockpile[/color] until assigned. If you go into your [color=aqua]Vats Panel[/color] for the specific [color=aqua]liquid[/color], you can assign extracted liquid to be used in a specific way. Those assignments won't actually kick in until the [color=aqua]End of the Day[/color], meaning your plans can be easily changed during the day."
	text += "\n[color=aqua]Kitchen Stock[/color] adds the fluids to a stockpile to be turned into [color=aqua]food[/color] by your [color=aqua]Cook[/color] or [color=aqua]slaves[/color] if no cook is assigned. A cook has a chance to significantly create more [color=aqua]food[/color] out of the same amount of fluid based on their [color=aqua]Wits[/color] and [color=aqua]Job Skills[/color]. "
	text += "\n[color=aqua]Refining[/color] creates items that can be accessed and used within the [color=aqua]Inventory[/color] menu. Most of the bottles will restore [color=aqua]Energy[/color], but their [color=aqua]Fetishes[/color] for [color=aqua]Drinking Milk, Cum, or Piss[/color] may affect that. "
	text += "\n[color=aqua]Bottles for Sale[/color] will [color=aqua]Bottled[/color] to be sold to each [color=aqua]town[/color] by your [color=aqua]Milk Merchant[/color], gaining [color=aqua]Gold[/color] and possibly [color=aqua]Reputation[/color] based on their [color=aqua]Wits[/color] and [color=aqua]Charm[/color]."
	text += "\n\nTo Start, I recommend assigning a [color=aqua]Farm Manager[/color] and purchasing a [color=aqua]cot[/color] or [color=aqua]bed[/color], a better [color=aqua]Extractor[/color] like a [color=aqua]Pump[/color], and a good container like a [color=aqua]Jug[/color] or [color=aqua]Canister[/color]. Purchase a [color=aqua]Milk Vat[/color] from your upgrades by [color=aqua]Clearing Space on the Farm[/color] and buying a [color=aqua]Milk Vat[/color].\nAdd a [color=aqua]Lactating Cattle[/color] with [color=aqua]large tits[/color] and [color=aqua]Livestock Consent[/color]. Make sure she has [color=aqua]Extract Milk[/color] selected then pick your purchased [color=aqua]extractor[/color] and [color=aqua]container[/color] from the dropdown menu. Select a [color=aqua]Daily Activity[/color] like [color=aqua]Pamper[/color] if possible.\nNow, go to your [color=aqua]Storage Vats[/color], [color=aqua]Milk Vats[/color] and select [color=aqua]Auto-Assign Refine[/color]. If you don't [color=aqua]Auto-Assign[/color], your extracted [color=aqua]milk[/color] will sit in your [color=aqua]Vat Stockpile[/color] until you manually assign it to be [color=aqua]Cooked[/color], [color=aqua]Refined into Items[/color], or [color=aqua]Sold[/color] by your [color=aqua]Milk Merchant[/color]."
	text += "\n\n\nPlease see the buttons below for more detailed explanations."
	
	get_node("MainScreen/mansion/farmpanel/farmhelppanel/farmhelptext").set_bbcode(text)
	get_node("MainScreen/mansion/farmpanel/farmhelppanel").show()

func _on_farmhelpbutton_workers():
	var text = ""
	text += "[color=#d1b970][center]Workers[/center][/color]"
	text += "\nWorkers are the core backbone of your Farm. Having the best Livestock won't matter if there is no one there to work the farm. There are a few different types of workers that address separate parts of the process. Depending on your route, some may or may not be mandatory to have a functioning farm and will simply help optimize it in a certain direction."
	#Farm Manager
	text += "\n\n[color=#d1b970]Farm Manager[/color]\nThe [color=aqua]Farm Manager[/color] is the most crucial role for a well functioning farm. A good [color=aqua]Farm Manager[/color] can take over for any missing [color=aqua]Milk Maids[/color] or [color=aqua]Farm Hands[/color], allowing your farm to continue functioning even if understaffed. If there is not a [color=aqua]Farm Manager[/color], [color=aqua]Milk Maid[/color], or [color=aqua]Farm Hand[/color] available, the farm will not be able to function. You ideally want someone [color=aqua]witty[/color]."
	text += "\n[color=#d1b970][center]Duties and Skills[/center][/color]\n[color=aqua]Discover Livestock Pregnancies[/color] - ([color=aqua]Chance equal to Wit + JobSkill; Increases Job Skill[/color])\nPurchase Bottles (if Auto-Purchase Bottles is selected)\nSubstitute for missing [color=aqua]Farm Hand[/color] and [color=aqua]Milk Maid[/color]. See those positions for more details.\n[color=yellow]You can only ever have 1 Farm Manager at a time.[/color]"
	#Farm Hand
	text += "\n\n[color=#d1b970]Farm Hand[/color]\nA [color=aqua]Farm Hand[/color] is the basic laborer of the farm. They restrain, care for, and train [color=aqua]Livestock[/color]. You ideally want someone [color=aqua]strong[/color] and [color=aqua]energetic[/color]."
	text += "\n[color=#d1b970][center]Duties and Skills[/center][/color]\nInject [color=aqua]Aphrodisiac[/color] and [color=aqua]Sedatives[/color] if selected in [color=aqua]Livestock[/color] options.\n[color=aqua]Subdue Resistant Livestock[/color] - ([color=aqua]Energy & Strength[/color])\nMay Gain or Lose [color=aqua]Relations[/color] with [color=aqua]Livestock[/color] - ([color=aqua]Based on Resistance, Farm Hand Confidence + Strength, and Livestock Obedience. Livestock Affected by Masochistic and Submissive; Farm Hand by Sadistic and Dominant[/color])\n[color=yellow]Will work as [color=aqua]Bottler[/color] if enough [color=aqua]Energy[/color] is left over after their day's work; Effort depends on Endurance.[/color]"
	#Milk Maid
	text += "\n\n[color=#d1b970]Milk Maid[/color]\n[color=aqua]Milk Maids[/color] use their hands to carefully milk the [color=aqua]Livestock[/color] to ensure that they maximize [color=aqua]Milk[/color] production. While it is not necessary to milk by [color=aqua]hand[/color] with modern technology like pumps. They can often be less beneficial or efficient, but an exceptionally [color=aqua]skilled Milk Maid[/color] will help [color=aqua]Livestock[/color] produce more than even the best machines. Training a quality [color=aqua]Milk Maid[/color] is a long term investment that will pay dividends in the end."
	text += "\n[color=#d1b970][center]Duties and Skills[/center][/color]\n[color=aqua]Extracting Milk from Cattle[/color] - [color=aqua]Milk[/color] extracted based on [color=aqua]Milking Job Skill; Effort depends on Endurance; Gains Milking Job Skills[/color]\n[color=aqua]Extracting Cum from Cattle[/color] - Cum extracted based on [color=aqua]Milk Maid's Lust, Lewdness, Milking Job Skill; Effort depends on Endurance; Gains Job Skills[/color]\n[color=aqua]Extracting Piss from Cattle[/color] - May lose [color=aqua]Loyalty[/color] based on the [color=aqua]Milk Maid's Fetish for Other's Pissing[/color]\nMay Gain or Lose [color=aqua]Relations[/color] with [color=aqua]Cattle[/color] - ([color=aqua]Based on Milk Maid's Charm and Job Skill, Livestock Obedience, their Fetishes for Milking and Being Milked. Cattle Affected by Masochistic and Submissive; Milk Maid by Sadistic and Dominant[/color])\n[color=aqua]Deliver Extracted Milk, Cum, and Piss to Vats[/color] - Necessary whether [color=aqua]manually[/color] extracted or not. Avoiding Spills is chance based on the [color=aqua]Container[/color] and the [color=aqua]Milk Maid's Agility[/color]. Better [color=aqua]Containers[/color] can severely lessen or negate the chance of spilling anything and losing it.\n[color=yellow]Will work as [color=aqua]Bottler[/color] if enough [color=aqua]Energy[/color] is left over after their day's work; Effort depends on Endurance.[/color]"
	#Bottlers
	text += "\n\n[color=#d1b970]Bottler[/color]\n[color=aqua]Bottlers[/color] are responsible for refining the [color=aqua]fluids[/color] brought to the [color=aqua]Vats[/color] by your [color=aqua]Milk Maids[/color]. They are almost entirely dependant on [color=aqua]Energy[/color], making [color=aqua]Bottler[/color] a perfect position for anyone with terrible [color=aqua]stats[/color] or bad [color=aqua]traits[/color]. However, out of all of the [color=aqua]Worker[/color] positions, it is the one that is the least crucial as [color=aqua]Farm Managers[/color], [color=aqua]Farm Hands[/color], and [color=aqua]Milk Maids[/color] will also assist.\nThe [color=aqua]Energy Cost[/color] per bottle can be decreased by purchasing better [color=aqua]Bottling Machines[/color] in your [color=aqua]Mansion Upgrades[/color]."
	text += "\n[color=#d1b970][center]Duties and Skills[/center][/color]\n[color=aqua]Refining Bottles[/color] - The [color=aqua]Energy Cost[/color] per bottle can also be reduced by the [color=aqua]Bottler's Job Skill[/color]; [color=aqua]Gains Job Skills[/color]."
	text += "\n[color=yellow]Important Note: [color=aqua]Bottlers[/color] will only bottle [color=aqua]fluids[/color] until they meet your requested order in the [color=aqua]Vat Panel[/color][/color]"
	#Milk Merchant
	text += "\n\n[color=#d1b970]Milk Merchant[/color]\n[color=aqua]Milk Merchants[/color] are responsible for taking all of the extracted [color=aqua]Fluids[/color] marked for sale into each town to sell it to the local population. They try to increase [color=aqua]Interest[/color] to sway [color=aqua]Supply and Demand[/color] in your favor to sell your bottles for more, but should you flood the market and supply far more than demanded they will find the cost decreasing. Available bottles are divided evenly (if possible) among all assigned Milk Merchants."
	text += "\n[color=#d1b970][center]Duties and Skills[/center][/color]\n[color=aqua]Selling Bottles in Towns[/color] - The [color=aqua]Milk Merhant's Wit[/color] and [color=aqua]Job Skill[/color] will determine if they are clever enough to manipulate the market and increase the price in your favor. [color=aqua]Increases Job Skill[/color]\n[color=aqua]Increase Future Interest in your Products[/color] - The [color=aqua]Milk Merchant's Charm[/color] and [color=aqua]Job Skill[/color] determine their success. There is a 5% chance of the product tasting bad and the town lowering their Interest.\n[color=aqua]Increase Reputation in Town[/color] - Depending on Interest and Reception. "
	
	get_node("MainScreen/mansion/farmpanel/farmhelppanel/farmhelptext").set_bbcode(text)
	get_node("MainScreen/mansion/farmpanel/farmhelppanel").show()

func _on_farmhelpbutton_livestock():
	var text = ""
	text += "[color=#d1b970][center]Livestock[/center][/color]"
	text += "\nLivestock, otherwise referred to as [color=aqua]Cattle[/color], are what actually produce [color=aqua]fluids[/color] and can [color=aqua]breed[/color] or be [color=aqua]bred[/color] in your farm. There are two primary of Livestock: [color=aqua]Consensual[/color] and [color=aqua]Non-Consentual[/color]."
	#Consent
	text += "\n\n[color=green]Consensual Livestock[/color] - Consentual Livestock are the best type of Livestock. They don't [color=red]Resist[/color] your [color=aqua]Farm Hands[/color], are more likely to gain [color=green]positive relations[/color] with [color=aqua]Farm Hands[/color] and [color=aqua]Milk Maids[/color], they are more likely to comply with their [color=aqua]Daily Activities[/color], won't need to be [color=red]Restrained[/color], and will have a higher [color=aqua]Contentment.[/color]\nYou can gain a potential [color=aqua]Livestock's Consent[/color] by [color=aqua]Talking[/color] to them. They will need to have consented to other things first to even consider it."
	text += "\n\n[color=red]Non-Consensual Livestock[/color] - Non-Consentual Livestock are any slaves that you forced into becoming [color=aqua]Livestock[/color]. They are likely to [color=red]Resist[/color] your [color=aqua]Farm Hands[/color] (causing your [color=red]Farm Hands to lose Energy[/color]), they are less likely to comply with their [color=aqua]Daily Activities[/color], are more likely to gain [color=red]negative relations[/color] with [color=aqua]Farm Hands[/color] and [color=aqua]Milk Maids[/color], may need to be [color=red]Sedated[/color], may need to be [color=red]Restrained[/color] to comply with [color=aqua]extracting fluids[/color], and will have a low starting [color=aqua]Contentment.[/color]"
	#Contentment
	text += "\n\n[color=#d1b970][center]Contentment[/center][/color]"
	text += "\nAll [color=aqua]Livestock[/color] have a level of [color=aqua]Contentment[/color] that reflects their acceptance and treatment in your farm. [color=aqua]Contentment[/color] comes in 4 tiers: [color=lime]Happy[/color], [color=green]Content[/color], [color=aqua]Discontent[/color], and [color=aqua]Miserable[/color]."
	text += "\n[color=lime]Happy[/color] (>= 5): [color=aqua]Livestock[/color] gain [color=green]2-4 Loyalty[/color], [color=green]3-5 Obedience[/color], and lose [color=green]5-15 Stress[/color] Daily. They may [color=aqua]consent[/color] to being [color=aqua]Livestock[/color] on their own if they haven't already."
	text += "\n[color=green]Content[/color] (1 to 4): [color=aqua]Livestock[/color] gain [color=green]1 Loyalty[/color], [color=green]1 Obedience[/color], and lose [color=green]3-10 Stress[/color] Daily."
	text += "\n[color=red]Discontent[/color] (-4 to 0): [color=aqua]Livestock[/color] lose some [color=red]Loyalty[/color], [color=red]Obedience[/color], and gain [color=red]Stress[/color] Daily. They may revoke [color=aqua]consent[/color] to being [color=aqua]Livestock[/color] if they granted it previously."
	text += "\n[color=red]Miserable[/color](<= -5): [color=aqua]Livestock[/color] lose a lot of [color=red]Loyalty[/color], [color=red]Obedience[/color], and gain [color=red]Fear[/color] and [color=red]Stress[/color] Daily. They are likely to revoke [color=aqua]consent[/color] to being [color=aqua]Livestock[/color] if they granted it previously."
	#Daily Actions
	text += "\n\n[color=#d1b970][center]Daily Actions[/center][/color]"
	text += "\nOne of the benefits of having [color=aqua]Livestock[/color] in the farm is the ability to assign them a [color=aqua]Daily Action[/color]. Some of these need a [color=aqua]Farm Hand[/color] or store-bought [color=aqua]Equipment[/color], but they provide a consistant daily benefit or detriment."
	#Rest
	text += "\n[color=aqua]Rest[/color]\n[color=aqua]Cattle[/color] are allowed to relax. This will regain some [color=aqua]Energy[/color], [color=aqua]Health[/color], and likely gain [color=aqua]Contentment[/color]."
	text += "\n[color=green]May increase [color=aqua]Contentment[/color][/color]"
	#Pamper
	text += "\n[color=aqua]Pamper[/color] - Requires [color=aqua]Farm Hand[/color]\n[color=aqua]Cattle[/color] are treated kindly to increase their [color=aqua]Contentment[/color]."
	text += "\n[color=green]Increases [color=aqua]Contentment[/color][/color]"
	#Stimulate
	text += "\n[color=aqua]Stimulate[/color] - Requires [color=aqua]Farm Hand[/color]\nKeeping [color=aqua]Cattle[/color] in a constant state of arousal will increase their [color=aqua]Lust[/color] and [color=aqua]Lewdness[/color]. This may increase their [color=aqua]Cum[/color] production."
	text += "\nMay [color=green]increase[/color] or [color=red]decrease[/color] [color=aqua]Contentment[/color][/color]"
	#Inspection
	text += "\n[color=aqua]Inspection[/color] - Requires [color=aqua]Farm Hand[/color]\nPublicly inspecting [color=aqua]Cattle[/color] will either [color=green]increase[/color] or [color=red]decrease[/color] their [color=aqua]Confidence[/color] based on their [color=aqua]Exhibitionism fetish[/color]."
	text += "\nMay [color=green]increase[/color] or [color=red]decrease[/color] [color=aqua]Contentment[/color][/color]"
	#Exhaust
	text += "\n[color=aqua]Exhaust[/color] - Requires [color=aqua]Farm Hand[/color]\nForcing [color=aqua]Cattle[/color] to run will decrease their [color=aqua]Energy[/color]. This will keep them from being able to [color=red]Resist[/color] as easily."
	text += "\n[color=red]May decrease [color=aqua]Contentment[/color][/color]"
	#Prod
	text += "\n[color=aqua]Prod[/color] - Purchase from [color=aqua]Store[/color]\nProds may decrease a [color=aqua]Cattle's[/color] [color=aqua]Confidence[/color] by 1-10 while increasing their [color=aqua]Obedience[/color] the same amount.\n[color=red]Prods have a chance to damage a Cattle's Health. This chance decreases with the cattle's Endurance.[/color]"
	text += "\n[color=red]May decrease [color=aqua]Contentment[/color] unless [color=aqua]Masochistic[/color][/color]"
	#Moo
	text += "\n[color=aqua]Moo[/color]\nForcing [color=aqua]Cattle[/color] to moo instead of speaking may decrease their [color=aqua]Wits[/color] by 1-10 while increasing their [color=aqua]Obedience[/color] the same amount."
	text += "\n[color=red]May decrease [color=aqua]Contentment[/color][/color]"
	#Bedding
	text += "\n\n[color=#d1b970][center]Bedding[/center][/color]"
	text += "\nThe type of bedding that a [color=aqua]Livestock[/color] is given will determine their [color=aqua]Contentment[/color], [color=aqua]Energy Restoration[/color], and [color=aqua]Stress Restoration[/color] Daily. The daily stats for each type are listed below."
	text += "\n[color=aqua]Dirt[/color] (Price: Free) - [color=red]Gain 10 Stress[/color]; [color=aqua]Gain 25 Energy[/color]; [color=aqua]25 Percent Chance to Heal[/color]"
	text += "\n[color=aqua]Pile of Hay[/color] (Price: 100) - [color=red]Gain 5 Stress[/color]; [color=aqua]Gain 50 Energy[/color]; [color=aqua]50 Percent Chance to Heal[/color]"
	text += "\n[color=aqua]Metal Cot[/color] (Price: 500) - [color=green]Lose 5 Stress[/color]; [color=aqua]Gain 75 Energy[/color]; [color=aqua]75 Percent Chance to Heal[/color]"
	text += "\n[color=aqua]Feather Bed[/color] (Price: 1000) - [color=lime]Lose 10 Stress[/color]; [color=aqua]Gain 100 Energy[/color]; [color=aqua]100 Percent Chance to Heal[/color]"
	#Workstations
	text += "\n\n[color=#d1b970][center]Workstations[/center][/color]"
	text += "\n[color=aqua]Workstations[/color] come in either [color=aqua]Free[/color], [color=aqua]Rack[/color], or [color=aqua]Cage[/color]. Racks and Cages will severely limit the ability of a [color=red]Resistant[/color] [color=aqua]Livestock[/color] to [color=red]Struggle[/color] against your [color=aqua]Farm Hands[/color]."
	get_node("MainScreen/mansion/farmpanel/farmhelppanel/farmhelptext").set_bbcode(text)
	get_node("MainScreen/mansion/farmpanel/farmhelppanel").show()

func _on_farmhelpbutton_close():
	get_node("MainScreen/mansion/farmpanel/farmhelppanel").hide()

func hide_farm_panels():
	nodeFarmSlave.hide()
	nodeSnailPanel.hide()
	nodeVats.hide()
	nodeVatDetails.hide()
	get_node("MainScreen/mansion/farmpanel/workerspanel").hide()
	nodeFarmStore.hide()
	nodeFarmStore.get_node("incubatorspanel").hide()
	get_node("MainScreen/mansion/farmpanel/farmhelppanel").hide()
###---End Expansion---###

func _on_defeateddescript_meta_clicked( meta ):
	var person = get_node("explorationnode/winningpanel/defeateddescript").get_meta('slave')
	showracedescript(person)

func showChoosePerson(arrayPersons, calledfunction = 'popup', targetnode = self):
	nodetocall = targetnode
	functiontocall = calledfunction
	for i in $chooseslavepanel/ScrollContainer/chooseslavelist.get_children():
		if i.name != 'Button':
			i.hide()
			i.free()
	for person in arrayPersons:
		var button = $chooseslavepanel/ScrollContainer/chooseslavelist/Button.duplicate()
		button.show()
		button.get_node('Label').text = person.name_long()
		button.connect('mouse_entered', globals, "slavetooltip", [person])
		button.connect('mouse_exited', globals, "slavetooltiphide")
		#button.get_node("slaveinfo").set_bbcode(person.name_long()+', '+person.race+ ', occupation - ' + person.work + ", grade - " + person.origins.capitalize())
		button.connect("pressed", self, "slaveselected", [button])
		button.connect("pressed", self, 'hideslaveselection')
		button.set_meta("slave", person)
		button.get_node("portrait").set_texture(globals.loadimage(person.imageportait))
		###---Added by Expansion---### Jail Expanded
		button.get_node("jailportrait").visible = (person.sleep == 'jail')
		###---End Expansion---###
		$chooseslavepanel/ScrollContainer/chooseslavelist/.add_child(button)
	if arrayPersons.empty():
		$chooseslavepanel/Label.text = "No characters fit the condition"
	else:
		$chooseslavepanel/Label.text = "Select Character"
	get_node("chooseslavepanel").show()

#---Lab Scripts for Sizing Below
func seteyecolor(person):
	var assist
	for i in globals.slaves:
		if i.work == 'labassist':
			assist = i
			break
	var priceModifier = 1 / (1+assist.wit/200.0)
	var timeCost = 0
	if person == globals.player:
		priceModifier *= 2
	else:
		timeCost = max(round(2/(1+assist.smaf/8.0)),1)
	###---Added by Expansion---### Hybrid Support
	if person.race.find('Demon') >= 0:
		priceModifier *= 0.7
	###---End Expansion---###
	var manaCost = round(40 * priceModifier)
	var goldCost = round(100 * priceModifier)
	var text = person.dictionary("Choose new eye color for $name. \n[color=yellow]Requires ") + str(manaCost) + " Mana, "
	text += str(goldCost) + " Gold, 1 Nature Essence and " + str(timeCost) + " days.[/color]"
	$entertext.show()
	$entertext.set_meta('action', 'eyecolor')
	$entertext.set_meta("slave", person)
	$entertext.set_meta("manaCost", manaCost)
	$entertext.set_meta("goldCost", goldCost)
	$entertext.set_meta("timeCost", timeCost)
	$entertext/LineEdit.text = person.eyecolor
	$entertext/dialoguetext.bbcode_text = text
	if globals.resources.mana < manaCost || globals.resources.gold < goldCost || globals.itemdict.natureessenceing.amount < 1:
		$entertext/confirmentertext.disabled = true
	else:
		$entertext/confirmentertext.disabled = false

func _on_confirmentertext_pressed():
	var text = get_node("entertext/LineEdit").get_text()
	if text == "":
		return
	var person
	var meta = get_node("entertext").get_meta("action")
	if meta == 'rename':
		person = get_node("entertext").get_meta("slave")
		person.name = text
		if globals.state.relativesdata.has(person.id):
			globals.state.relativesdata[person.id].name = person.name_long()
		rebuild_slave_list()
	elif meta == 'eyecolor':
		person = get_node("entertext").get_meta("slave")
		var manaCost = get_node("entertext").get_meta("manaCost")
		var goldCost = get_node("entertext").get_meta("goldCost")
		var timeCost = get_node("entertext").get_meta("timeCost")
		person.eyecolor = text
		if person != globals.player:
			person.away.duration = timeCost
			person.away.at = 'lab'
		globals.resources.gold -= goldCost
		globals.resources.mana -= manaCost
		globals.itemdict.natureessenceing.amount -= 1
		rebuild_slave_list()
		$MainScreen/mansion/labpanel._on_labstart_pressed()
	get_node("entertext").hide()

#---Keeping for more sleep options, like Stables
func sleeppressed(button):
	var person = button.get_meta('slave')
	var beds = globals.count_sleepers()
	button.clear()
	button.add_item(globals.sleepdict['communal'].name)
	if person.sleep == 'communal':
		button.set_item_disabled(button.get_item_count()-1, true)
		button.select(button.get_item_count()-1)
	button.add_item(globals.sleepdict['jail'].name)
	if beds.jail >= globals.state.mansionupgrades.jailcapacity:
		button.set_item_disabled(button.get_item_count()-1, true)
	if person.sleep == 'jail':
		button.set_item_disabled(button.get_item_count()-1, true)
		button.select(button.get_item_count()-1)
	button.add_item(globals.sleepdict['personal'].name)
	if beds.personal >= globals.state.mansionupgrades.mansionpersonal:
		button.set_item_disabled(button.get_item_count()-1, true)
	if person.sleep == 'personal':
		button.set_item_disabled(button.get_item_count()-1, true)
		button.select(button.get_item_count()-1)
	button.add_item(globals.sleepdict['your'].name)
	if beds.your_bed >= globals.state.mansionupgrades.mansionbed || (person.loyal + person.obed < 130 || person.tags.find('nosex') >= 0):
		button.set_item_disabled(button.get_item_count()-1, true)
	if person.sleep == 'your':
		button.set_item_disabled(button.get_item_count()-1, true)
		button.select(button.get_item_count()-1)
	###---Added by Expansion---### Dog Kennels
	button.add_item(globals.sleepdict['kennel'].name)
	if globals.state.mansionupgrades.mansionkennels == 0:
		button.set_item_disabled(button.get_item_count()-1, true)
	if person.sleep == 'kennel':
		button.set_item_disabled(button.get_item_count()-1, true)
		button.select(button.get_item_count()-1)
	###---End Expansion---###

###---Added by Expansion---### Dog Kennels
var sleepdict = {0 : 'communal', 1 : 'jail', 2 : 'personal', 3 : 'your', 4 : "kennel"}
###---End Expansion---###

func sleepselect(item, button):
	var person = button.get_meta('slave')
	person.sleep = sleepdict[item]
	if person.sleep == 'jail':
		person.work = 'rest'
	rebuild_slave_list()
	slavelist()

###---Added by Expansion---### Ank BugFix v4a
func _on_sexbutton_pressed():
	sexslaves.clear()
#	sexassist.clear()
	var newbutton
	get_node("sexselect").show()
	get_node("sexselect/selectbutton").set_text('Mode: ' + sexmode.capitalize())
	for i in sexanimals:
		sexanimals[i] = 0
	$sexselect/managerypanel.visible = sexmode != 'meet' && globals.state.mansionupgrades.mansionkennels > 0
	for i in get_node("sexselect/ScrollContainer1/VBoxContainer").get_children() + get_node("sexselect/ScrollContainer/VBoxContainer").get_children():
		if i.get_name() != 'Button':
			i.hide()
			i.queue_free()
	for i in globals.slaves:
		if i.away.duration != 0 || i.sleep == 'farm':
			continue
		newbutton = get_node("sexselect/ScrollContainer/VBoxContainer/Button").duplicate()
		get_node("sexselect/ScrollContainer/VBoxContainer").add_child(newbutton)
		newbutton.set_text(i.dictionary('$name'))
		newbutton.show()
		newbutton.connect("pressed",self,'selectsexslave',[newbutton, i])
		var numInteractions = i.getRemainingInteractions()
		var tooltip = ''
		if sexmode == 'meet':
			if numInteractions > 0:
				tooltip = 'You can interact with %s %s more time%s today.' % [i.name_long(), numInteractions, 's' if numInteractions > 1 else '']
			else:
				newbutton.set_disabled(true)
				tooltip = 'You have already interacted with %s too many times today.' % i.name_long()
		elif sexmode == 'sex':
			###---Added by Expansion---### Breeding Consent and Incest Sex Blocker
			if i.consent == false:
				if sexslaves.size() >= 1 && i.consentexp.stud == true || sexslaves.size() >= 1 && i.consentexp.breeder == true:
					newbutton.set('custom_colors/font_color', Color(1,0.2,0.2))
					newbutton.set('custom_colors/font_color_pressed', Color(1,0.2,0.2))
					tooltip = i.dictionary('$name gave you no consent, but did consent to have sex with others for you.\n')
				else:
					newbutton.set('custom_colors/font_color', Color(1,0.2,0.2))
					newbutton.set('custom_colors/font_color_pressed', Color(1,0.2,0.2))
					tooltip = i.dictionary('$name gave you no consent.\n')
			elif globals.expansion.relatedCheck(i, globals.player) != 'unrelated':
				if i.consentexp.incest == false:
					newbutton.set('custom_colors/font_color', Color(1,0.2,0.2))
					newbutton.hint_tooltip = i.dictionary('You are related to $name and $he has not given consent for incestuous actions.')
			if sexslaves.size() >= 1:
				for r in sexslaves:
					if globals.expansion.relatedCheck(i, r) != 'unrelated':
						newbutton.set('custom_colors/font_color', Color(1,0.2,0.2))
						newbutton.hint_tooltip = i.dictionary(str(r.name)+ ' and ' +str(i.name)+ ' are related have not given consent for incestuous actions.')
			###---Expansion End---###
			if numInteractions > 0:
				tooltip += 'You can interact with %s %s more time%s today.' % [i.name_long(), numInteractions, 's' if numInteractions > 1 else '']
			else:
				newbutton.set_disabled(true)
				tooltip += 'You have already interacted with %s too many times today.' % i.name_long()
		newbutton.set_tooltip(i.dictionary(tooltip))
	updatedescription()
	if globals.state.tutorial.interactions == false:
		get_node("tutorialnode").interactions()

func updatedescription():
	var text = ''
	
	if sexmode == 'meet':
		text += "[center][color=yellow]Meet[/color][/center]\nBuild relationship or train your servant: "
		for person in sexslaves:
			text += '[color=aqua]%s[/color]. ' % person.name_short()
	elif sexmode == 'sex':
		var consensual = true
		for person in sexslaves:
			if !person.consent:
				consensual = false
				break
		if sexslaves.empty():
			text += "[center][color=yellow]Sex[/color][/center]\nCurrent participants: "
		else:
			if sexslaves.size() == 1:
				if consensual:
					text += "[center][color=yellow]Consensual Sex[/color][/center]"
				else:
					text += "[center][color=yellow]Rape[/color][/center]"
			elif sexslaves.size() in [2,3]:
				if consensual:
					text += "[center][color=yellow]Consensual Group Sex[/color][/center]"
				else:
					text += "[center][color=yellow]Group Rape[/color][/center]"
			else:
				text += "[center][color=yellow]Orgy[/color][/center]\n[color=aqua]Aphrodite's Brew[/color] is required to initialize an orgy."

			if consensual:
				text += "\nAll participants have given consent."
			else:
				text += "\nNot all participants have given consent."
			text += "\nCurrent participants: "
			for person in sexslaves:
				if person.consent:
					text += '[color=aqua]%s[/color], ' % person.name_short()
				else:
					text += '[color=#ff3333]%s[/color], ' % person.name_short()
			text = text.substr(0, text.length() - 2) + '.'
		for animal in sexanimals:
			if sexanimals[animal] != 0:
				text += "\n" + animal.capitalize() + '(s): ' + str(sexanimals[animal])
		
#	elif sexmode == 'abuse':
#		text += "[center][color=yellow]Rape[/color][/center]"
#		text += "\nRequires a target and an optional assistant. Can be initiated with prisoners. \nCurrent target: "
#		for i in sexslaves:
#			text += i.dictionary('[color=aqua]$name[/color]') + ". "
#		text += "\nCurrent assistant: "
#		for i in sexassist:
#			text += i.dictionary('[color=aqua]$name[/color]') + ". "
#		for i in sexanimals:
#			if sexanimals[i] != 0:
#				text += "\n" + i.capitalize() + '(s): ' + str(sexanimals[i])
#		get_node("sexselect/startbutton").set_disabled(sexslaves.size() == 1 && sexassist.size() <= 1)
	if sexslaves.empty():
		text += '\nSelect slaves to start.'
	else:
		text += '\nClick Start to initiate.'
	###---Added by Expansion---### Interaction Hint
	text += "\n\nNon-sex Interactions left for today: [color=aqua]" + str(globals.state.nonsexactions) + "[/color]"
	text += "\nSex Interactions left for today: [color=aqua]" + str(globals.state.sexactions) + "[/color]"
	###---End Expansion---###
	get_node("sexselect/sextext").set_bbcode(text)
	
	var enablebutton = true
	if sexslaves.size() == 0:
		enablebutton = false
	elif sexmode == 'meet':
		if globals.state.nonsexactions < 1:
			enablebutton = false 
	elif sexmode == 'sex':
		if globals.state.sexactions < 1:
			enablebutton = false 
		elif sexslaves.size() >= 4 && sexmode == 'sex' && globals.itemdict.aphroditebrew.amount < 1:
			enablebutton = false 
	$sexselect/startbutton.disabled = !enablebutton

###---End Expansion---###

func traitpanelshow(person, effect):
	$traitselect.show()# = true
	traitaction = effect
	var text = ''
	var array = []
	var timeCost = 0
	var manaCost = 0
	var goldCost = 0
	for i in $traitselect/Container/VBoxContainer.get_children():
		if i.name != 'Button':
			i.hide()
			i.queue_free()
	if effect == 'clearmental':
		text += person.dictionary("Select mental trait to remove from $name.")
	elif effect == 'clearphys':
		var assist
		for i in globals.slaves:
			if i.work == 'labassist':
				assist = i
				break
		var priceModifier = 1 / (1+assist.wit/200.0)
		if person == globals.player:
			priceModifier *= 2
		else:
			timeCost = max(round(3/(1+assist.smaf/8.0)),1)
		###---Added by Expansion---### Hybrid Support
		if person.race.find('Demon') >= 0:
			priceModifier *= 0.7
		###---End Expansion---###
		manaCost = round(50 * priceModifier)
		goldCost = round(100 * priceModifier)
		text += person.dictionary("Select physical trait to remove from $name. Requires 1 [color=yellow]Elixir of Clarity[/color], ") + str(manaCost) + " mana, " + str(goldCost) +" gold, and " + str(timeCost) + " days."
	for i in person.traits:
		var trait = globals.origins.trait(i)
		###---Added by Expansion---### Hybrid Support
		if effect == 'clearmental':
			if trait.tags.has('mental') && !trait.tags.has('lockedtrait'):
				array.append(trait)
		elif effect == 'clearphys' && !trait.tags.has('lockedtrait'):
			if globals.itemdict.claritypot.amount < 1 || globals.resources.gold < goldCost || globals.resources.mana < manaCost || trait.tags.has('physical') == false:
				continue
			else:
				array.append(trait)
		###---End Expansion---###
	for i in array:
		var newnode = $traitselect/Container/VBoxContainer/Button.duplicate()
		$traitselect/Container/VBoxContainer.add_child(newnode)
		newnode.show()
		newnode.text = i.name
		newnode.connect("mouse_entered", globals, 'showtooltip', [person.dictionary(i.description)])
		newnode.connect("mouse_exited", globals, 'hidetooltip')
		newnode.connect("pressed", self, 'traitselect', [person, i, manaCost, goldCost, timeCost])
	$traitselect/RichTextLabel.bbcode_text = text

func updateSlaveListNode(node, person, visible):
	node.visible = visible
	node.find_node('name').set_text(person.name_long())
	#Whims -- change text color
	node.find_node('name').set('custom_colors/font_color', ColorN(person.namecolor))
	if person.xp >= 100:
		node.find_node('name').rect_min_size.x = 208 # manual resize since auto glitched
		node.find_node('levelup').visible = true
		node.find_node('levelup').hint_tooltip = person.dictionary("Talk to $him to investigate unlocking $his potential." if person.levelupreqs.empty() else "Check requirements for unlocking $his potential.")
	else:
		node.find_node('levelup').visible = false
		node.find_node('name').rect_min_size.x = 235 # manual resize since auto glitched
	node.find_node('health').set_normal_texture( person.health_icon())
	node.find_node('healthvalue').set_text( str(round(person.health)))
	node.find_node('obedience').set_normal_texture( person.obed_icon())
	node.find_node('stress').set_normal_texture( person.stress_icon())
	if person.imageportait != null:
		node.find_node('portait').set_texture( globals.loadimage(person.imageportait))

func dialogue(showcloseButton, destination, dialogtext, dialogbuttons = null, sprites = null, background = null): #for arrays: 0 - boolean to show close button or not. 1 - node to return connection back. 2 - text to show 3+ - arrays of buttons and functions in those
	var text = get_node("dialogue/dialoguetext")
	var buttons = $dialogue/buttonscroll/buttoncontainer
	var newbutton
	var counter = 1
	get_node("dialogue/blockinput").hide()
	get_node("dialogue/background").set_texture(null if background == null else globals.backgrounds[background])
	if !get_node("dialogue").visible:
		get_node("dialogue").show()
#		get_node("dialogue").popup()
		nodeunfade($dialogue, 0.4)
		#get_node("dialogue/AnimationPlayer").play("fading")
	text.set_bbcode('')
	for i in buttons.get_children():
		if i.name != "Button":
			i.hide()
			i.queue_free()
	if dialogtext == "":
		dialogtext = var2str(dialogtext)
	text.set_bbcode(globals.player.dictionary(dialogtext))
	text.scroll_to_line(0)
	if dialogbuttons != null:
		for i in dialogbuttons:
			dialoguebuttons(dialogbuttons[counter-1], destination, counter)
			counter += 1
	if showcloseButton == true:
		newbutton = $dialogue/buttonscroll/buttoncontainer/Button.duplicate()
		newbutton.show()
		newbutton.set_text('Close')
		newbutton.connect('pressed',self,'close_dialogue')
		newbutton.get_node("Label").set_text(str(counter))
		buttons.add_child(newbutton)
	
	var clearSprites = []
	for key in nodedict:
		if nodedict[key].get_texture() != null:
			clearSprites.append(key)
	
	if sprites != null && globals.rules.spritesindialogues == true:
		for i in sprites:
			if !spritedict.has(i[0]) && globals.loadimage(i[0]) == null:
				var temp = "WARNING: Dialogue cannot display sprite '%s'." %[i[0]]
				print(temp)
				globals.traceFile(temp)
				continue
			else:
				if spritedict.has(i[0]):
					if i.size() > 2 && (i[2] != 'opac' || spritedict[i[0]] != nodedict[i[1]].get_texture()):
						tweenopac(nodedict[i[1]])
					nodedict[i[1]].set_texture(spritedict[i[0]])
				else:
					if i.size() > 2 && (i[2] != 'opac' || globals.loadimage(i[0]) != nodedict[i[1]].get_texture()):
						tweenopac(nodedict[i[1]])
					nodedict[i[1]].set_texture(globals.loadimage(i[0]))
				clearSprites.erase(i[1])
	for key in clearSprites:
		nodedict[key].set_texture(null)

func _on_upgradesclose_pressed():
	get_node("MainScreen/mansion/upgradespanel").hide()
	get_tree().get_current_scene()._on_mansion_pressed()
