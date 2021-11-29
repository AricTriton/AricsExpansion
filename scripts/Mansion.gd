
###---Added by Expansion---### Deviate
var corejobs = ['rest','forage','hunt','cooking','library','nurse','maid','storewimborn','artistwimborn','assistwimborn','whorewimborn','escortwimborn','fucktoywimborn', 'lumberer', 'ffprostitution','guardian', 'research', 'slavecatcher','fucktoy','housepet']
###---End Expansion---###

func _ready():
	###---Added by Expansion---### Minor Tweaks by Dabros Mod Integration
		## CHANGED - 5/6/19 - create button here for slave-stats-export
	var exportSlaveStats = $MainScreen/mansion/selfinspect/spellbook.duplicate()
	exportSlaveStats.text = "Export Stats"
	exportSlaveStats.disconnect("pressed", self, '_on_spellbook_pressed')
	exportSlaveStats.connect("pressed", self, 'doExportSlaveStats')
	exportSlaveStats.margin_top -= 39
	exportSlaveStats.margin_bottom -= 39
	exportSlaveStats.margin_left -= 0
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
	if get_node("FinishDayPanel/FinishDayScreen/Global Report").get_bbcode().empty():
		get_node("Navigation/endlog").disabled = true
	_on_mansion_pressed()
	#startending()

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

	globals.resources.day += 1
	text0.set_bbcode('')
	text1.set_bbcode('')
	text2.set_bbcode('')
	count = 0

	if globals.player.preg.duration >= 1:
		globals.player.preg.duration += 1
		if globals.player.preg.duration == floor(variables.pregduration/6):
			text0.set_bbcode(text0.get_bbcode() + "[color=yellow]You feel morning sickness. It seems you are pregnant. [/color]\n")

	###---Added by Expansion---### Update Player, Towns, and People
	var temptext
	text = "" if text0.get_bbcode().empty() else "\n"
	#---NPCs Expanded
	globals.expansion.dailyNPCs()
	#Update Towns
	temptext = globals.expansion.dailyTownGuard()
	if temptext != null:
		text += temptext
	#Player
	temptext = globals.expansion.dailyUpdate(globals.player)
	if temptext != null:
		text += temptext
	#slaves
	if !text.empty():
		text0.set_bbcode(text0.get_bbcode() + text + "")
	###---End Expansion---###

	###---Added by Expansion---### Category: Daily Update | Management First | Spacing
	var first_slave_processed = true
	for person in globals.slaves:
		if person.work in ['headgirl','farmmanager']:
			if first_slave_processed == true:
				first_slave_processed = false
			else:
				text += "\n"
			text += globals.expansion.dailyUpdate(person)
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
		if !person.work in ['headgirl','farmmanager']:
			if first_slave_processed == true:
				first_slave_processed = false
			else:
				text += "\n"
			text += globals.expansion.dailyUpdate(person)
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
							text = "$name almost collapsed from exhaustion and was forced to rest instead of work today. \n"
							person.dailyevents.append('exhaustion')
						else:
							text = '$name has spent most of the day relaxing.\n'
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
							globals.state.condition = (5.5 + (person.sagi+person.send)*6)/2
							text2.bbcode_text += person.dictionary("$name has managed to clean the mansion a bit while being around. \n")
						###---End Expansion---###
						if workdict.has("gold"):
							globals.resources.gold += workdict.gold
							if workdict.gold > 0:
								person.metrics.goldearn += workdict.gold
						if workdict.has("food"):
							globals.resources.food += workdict.food
							person.metrics.foodearn += workdict.food
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
			if chef != null:
				consumption = max(3, consumption - (chef.sagi + (chef.wit/20))/2)
				###---Added by Expansion---### Hybrid Support
				if chef.race.find('Scylla') >= 0:
					consumption = max(3, consumption - 1)
				###---End Expansion---###
			if person.traits.has("Small Eater"):
				consumption = consumption/3
			###---Added by Expansion---### ---PENDING: Add option to "Drink from the Source"
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
				person.stress += 20
				person.health -= rand_range(person.stats.health_max/6,person.stats.health_max/4)
				person.obed -= max(35 - person.loyal/3,10)
				if person.health < 1:
					text = person.dictionary('[color=#ff4949]$name has died of starvation.[/color]\n')
					deads_array.append({number = count, reason = text})
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
					###---Added by Expansion---### Ankmairdor's BugFix v4
					if i.spec == 'tamer' && i.away.duration == 0 && i.obed > 60 && (i.work == person.work || i.work in ['rest','nurse','headgirl'] || (i.work == 'jailer' && person.sleep == 'jail') || (i.work == 'farmmanager' && person.work in ['cow','hen'])):
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
				if person.loyal >= 60:
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

			if person.stress >= 99:
				person.mentalbreakdown()

			###---Added by Expansion---### Hybrid Support
			if person.race.find('Fairy') >= 0:
				person.stress -= rand_range(10,20)
			###---End Expansion---###
			else:
				person.stress -= rand_range(5,10)

			#sleep conditions
			if person.lust < 25 || person.traits.has('Sex-crazed'):
				person.lust += round(rand_range(3,6))
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
						person.stats.obed_cur += 10
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
						person.stats.obed_cur += 10
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
			if person.lust >= 90 && person.rules.masturbation == true && !person.traits.has('Sex-crazed') && (rand_range(0,10)>7 || person.effects.has('stimulated')) && globals.resources.day - person.lastsexday >= 5:
				person.add_trait('Sex-crazed')
				text0.set_bbcode(text0.get_bbcode() + person.dictionary("[color=yellow]Left greatly excited and prohibited from masturbating, $name desperate state led $him to become insanely obsessed with sex.[/color]\n"))
			elif person.lust >= 75 && globals.resources.day - person.lastsexday >= 5:
				person.stress += rand_range(10,15)
				person.obed -= rand_range(10,20)
				text0.bbcode_text += person.dictionary("[color=red]$name is suffering from unquenched lust.[/color]\n")

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
				
#				if person.preg.duration > variables.pregduration/6:
#					person.lactation = true
#					if headgirl != null:
#						if person.preg.duration == floor(variables.pregduration/5):
#							text0.set_bbcode(text0.get_bbcode() + headgirl.dictionary('[color=yellow]$name reports, that ') + person.dictionary('$name appears to be pregnant. [/color]\n'))
#						elif person.preg.duration == floor(variables.pregduration/2.7):
#							text0.set_bbcode(text0.get_bbcode() + headgirl.dictionary('[color=yellow]$name reports, that ') + person.dictionary('$name will likely give birth soon. [/color]\n'))
#				else:
#					if person.preg.duration > variables.pregduration/3:
#						person.lactation = true
#						if headgirl != null:
#							if person.preg.duration == floor(variables.pregduration/2.5):
#								text0.set_bbcode(text0.get_bbcode() + headgirl.dictionary('[color=yellow]$name reports, that ') + person.dictionary('$name appears to be pregnant. [/color]\n'))
#							elif person.preg.duration == floor(variables.pregduration/1.3):
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
				if !person.traits.has("Grateful") && luxury < personluxury && person.metrics.ownership - person.metrics.jail > 7:
					person.loyal -= (personluxury - luxury)/2.5
					person.obed -= (personluxury - luxury)
					text0.set_bbcode(text0.get_bbcode() + person.dictionary("[color=#ff4949]$name appears to be rather unhappy about quality of $his life and demands better living conditions from you. [/color]\n"))
		elif person.away.duration > 0:
			person.away.duration -= 1
			###---Added by Expansion---### Hybrid Support && Ankmairdor's BugFix v4
			if person.away.at == 'lab' && person.health < 5:
				temptext = "$name has not survived the laboratory operation due to poor health."
				deads_array.append({number = count, reason = temptext})
			else:
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
					###---Added by Expansion---### Colorized & Fixed Duplicate
					text0.set_bbcode(text0.get_bbcode() + person.dictionary("[color=aqua]$name[/color] returned to the mansion and went back to $his duty. \n"))
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
	if farmtext != null && text3 != null:
		text3.set_bbcode(farmtext)
	
	#####          Dirtiness
	###---Added by Expansion---### Ank BugFix v4a
	for person in globals.slaves:
		if person.spec == 'housekeeper' && person.away.duration == 0 && person.work in ['headgirl','farmmanager','labassist','jailer']:
			globals.state.condition = (5.5 + (person.sagi+person.send)*6)/2
			text2.bbcode_text += person.dictionary("$name has managed to clean the mansion a bit while being around. \n")
	###---End Expansion---###
	if globals.state.condition <= 40:
		for person in globals.slaves:
			if person.away.duration != 0:
				continue
			if globals.state.condition >= 30 && randf() >= 0.7:
				person.stress += rand_range(5,15)
				person.obed += -rand_range(15,20)
				text0.set_bbcode(text0.get_bbcode() + person.dictionary("[color=yellow]$name was distressed by mansion's poor condition. [/color]\n"))
			elif globals.state.condition >= 15 && randf() >= 0.5:
				person.stress += rand_range(10,20)
				person.obed += -rand_range(15,35)
				text0.set_bbcode(text0.get_bbcode() + person.dictionary("[color=yellow]$name was distressed by mansion's poor condition. [/color]\n"))
			elif globals.state.condition < 15 && randf() >= 0.4:
				person.stress += rand_range(15,25)
				person.health -= rand_range(5,10)
				text0.set_bbcode(text0.get_bbcode() + person.dictionary("[color=#ff4949]Mansion's terrible condition causes $name a lot of stress and impacted $his health. [/color]\n"))
	#####          Outside Events


	for guild in globals.guildslaves:
		var slaves = globals.guildslaves[guild]
		count = round(clamp(0.25, 0.75, 0.01 * slaves.size() + rand_range(0.1, 0.4)) * slaves.size())
		###---Added by Expansion---### Ank BugFix v4a
		var idx
		var removeId
		var tempslave
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
		if globals.state.sebastianorder.duration == 0:
			text0.set_bbcode(text0.get_bbcode() + "[color=green]Sebastian should have your order ready by this time. [/color]\n")
	globals.state.groupsex = true

	var consumption = variables.basefoodconsumption
	if chef != null:
		consumption = max(3, consumption - (chef.sagi + (chef.wit/20))/2)
		###---Added by Expansion---### Hybrid Support
		if chef.race.find('Scylla') >= 0:
			consumption = max(3, consumption - 1)
		###---End Expansion---###
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

	###---Added by Expansion---### Ovulation System
	globals.nightly_womb(globals.player)
	for i in globals.slaves:
		globals.nightly_womb(i)
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
	text0.set_bbcode(text0.get_bbcode() + text)
	globals.state.sexactions = ceil(globals.player.send/2.0) + variables.basesexactions
	globals.state.nonsexactions = ceil(globals.player.send/2.0) + variables.basenonsexactions
	if deads_array.size() > 0:
		results = 'worst'
		deads_array.invert()
		###---Added by Expansion---### Ank BugFix v4a
		for i in deads_array:
			globals.slaves[i.number].removefrommansion()
			text0.set_bbcode(text0.get_bbcode() + i.reason + '\n')
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

func nextdayevents():
	get_node("FinishDayPanel").hide()
	var player = globals.player
	if player.preg.duration > variables.pregduration && player.preg.is_preg == true:
		childbirth_loop(player)
		checkforevents = true
		return
	for i in globals.slaves:
		###---Added by Expansion---### Hybrid Support
		if (i.preg.baby != null || !i.preg.unborn_baby.empty()) && (i.preg.duration > variables.pregduration || (i.race.find('Goblin') >= 0 && i.preg.duration > variables.pregduration/2)):
		#if i.preg.baby != null && (i.preg.duration > variables.pregduration || (i.race.find('Goblin') >= 0 && i.preg.duration > variables.pregduration/2)):
			if i.race.find('Goblin') >= 0:
				i.away.duration = 2
			else:
				i.away.duration = 3
			i.away.at = 'in labor'
			childbirth_loop(i)
			if !i.preg.womb.empty():
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
	###---End Expansion---###
	if globals.itemdict.zoebook.amount >= 1 && globals.state.sidequests.zoe == 3 && randf() >= 0.5:
		globals.events.zoebookevent()
		checkforevents = true
		return
	startnewday()

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
	if globals.player.imageportait != null && globals.canloadimage(globals.player.imageportait):
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
				elif person.fear >= (person.obed+person.obed) * .5:
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
					text += "[color=lime]" + str(person.energy) + "[/color] | [color=aqua]" + str(person.stats.energy_max) + "[/color]"
				elif person.energy >= person.stats.energy_max*.4:
					text += "[color=green]" + str(person.energy) + "[/color] | [color=aqua]" + str(person.stats.energy_max) + "[/color]"
				else:
					text += "[color=red]" + str(person.energy) + "[/color] | [color=aqua]" + str(person.stats.energy_max) + "[/color]"
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
		#---Pregnancy Expanded | The Crystal || TBK - Ensure No Overridden Text
		text += "\n\n[color=#d1b970]-----The Dimensional Crystal------[/color] [color=aqua](" + str(globals.state.mansionupgrades.dimensionalcrystal) + ")[/color]\n"
		text += "The Dimensional Crystal is located in the hallways beneath the Mansion. It is directly at the center of the Mansion and seems to be at exactly an equal distance from each end of the Mansion grounds. It seems to be a massive, perfectly symmetrical prism made out of a material that no one can identify. "
		#Mode
		if globals.state.thecrystal.mode == "light" && globals.state.mansionupgrades.dimensionalcrystal > 0:
			text += "\nIt eminates a bright, violet light that radiates around it. "
		elif globals.state.thecrystal.mode == "dark" && globals.state.mansionupgrades.dimensionalcrystal > 0:
			text += "\nIt eminates a dark, purplish light that is split with shadowy tendrils running through it like writhing cracks. "
		
		if globals.state.mansionupgrades.dimensionalcrystal == 0:
			text += "\nIt seems to be dull and lifeless, but catches and reflects the occassional candlelight that strikes it."
		elif globals.state.mansionupgrades.dimensionalcrystal == 1:
			text += "The glow seems to pulse with the rhythm of a weak heart. You occassionally see wisps of the same color radiating off of pregnancy women inside of the Mansion."
		elif globals.state.mansionupgrades.dimensionalcrystal == 2:
			text += "The Crystal pulses far more steadily recently and accompanies the glow with a light humming noise. You see wisps of the purplish glow it lets off trailing behind people all throughout the day as it works its strange magic on the Mansion's inhabitants."
		elif globals.state.mansionupgrades.dimensionalcrystal == 3:
			text += "The Dimensional Crystal pulses and hums slightly louder than it once did. You see the occassional flash of light come from it's chamber and feel a sense of peace at knowing that it is there and finally awakening once more."
		elif globals.state.mansionupgrades.dimensionalcrystal >= 4:
			text += "The Crystal pulses violently now and the low hum can be heard throughout the entire Mansion. Though it can grow irritating at times, you find that you quickly came to ignore the background noise. "
		#Hunger
		if globals.state.thecrystal.mode == "dark":
			if globals.state.thecrystal.power + globals.state.thecrystal.hunger >= globals.player.smaf:
				text += "It is hard to look at the Crystal. Something draws you toward it. It seems to beckon you closer with its dark, shadowy tendrils. You know that if you touch it, it will drain you of your very soul. "
			elif globals.state.thecrystal.hunger > 0:
				text += "You have a sense of unease when gazing into the Crystal. It seems to be...hungry. It wants to...consume. "
		
		#---Research
		if globals.state.thecrystal.research > 0:
			text += "\n\n[color=#d1b970]Crystal Research[/color]\nResearch: [color=aqua]" + str(globals.state.thecrystal.research) + "[/color]/100 \nResearch is the chance of discovering a new Crystal Ability at night. "
		#Attunement
		if globals.state.thecrystal.abilities.size() > 0 && !globals.state.thecrystal.abilities.has('attunement'):
			text += "\n[color=green]Inspiration[/color]: You think that you can [color=aqua]Attune[/color] yourself to the [color=aqua]Crystal[/color]. "
		#Preg Speed
		if globals.state.mansionupgrades.dimensionalcrystal >= 1 && !globals.state.thecrystal.abilities.has('pregnancyspeed'):
			text += "\n[color=green]Inspiration[/color]: You know that the [color=aqua]Crystal[/color] can affect the [color=aqua]Speed of Pregnancies[/color], but are not yet sure how to make it work. "
		#Second Wind
		if globals.state.mansionupgrades.dimensionalcrystal >= 2 && !globals.state.thecrystal.abilities.has('secondwind'):
			text += "\n[color=green]Inspiration[/color]: You think you may be able to learn how to make the [color=aqua]Crystal[/color] to revive you and your slaves to half health from a fatal blow in combat once per day."
		#Death Prevention
		if globals.state.mansionupgrades.dimensionalcrystal >= 3 && !globals.state.thecrystal.abilities.has('immortality'):
			text += "\n[color=green]Inspiration[/color]: You believe that the [color=aqua]Crystal[/color] can grant [color=aqua]Immortality[/color], but are not yet sure how."
		#Sacrifice
		if globals.state.thecrystal.mode == "dark" && !globals.state.thecrystal.abilities.has('sacrifice'):
			text += "\n[color=red]Dark Inspiration[/color]: There must be some way to [color=red]Sacrifice[/color] something to the [color=aqua]Crystal[/color] to sate its [color=aqua]Hunger[/color] for [color=aqua]Lifeforce[/color], but you are not yet sure how to do that."
		#---Powers
		if globals.state.thecrystal.abilities.empty():
			text += "\nThe truth behind what all the Crystal can do and why it was put here in the first place is still a complete mystery."
		else:
			text += "\n\n[color=#d1b970]Powers of the Crystal[/color]"
			#Attunement
			if globals.state.thecrystal.abilities.has('attunement'):
				text += "\nYou understand the basic properties of the [color=aqua]Crystal[/color]. "
				#Color
				text += "\n    [color=#d1b970]Color[/color]: " + globals.fastif(globals.state.thecrystal.mode == "light", "[color=aqua]Light[/color]", "[color=red]Dark[/color]")
				if globals.state.thecrystal.mode == "dark":
					text += "; The [color=aqua]Crystal[/color] is [color=red]Dark[/color], so there is a chance that it may consume a [color=aqua]Researcher[/color] to sate its [color=aqua]Hunger[/color] by an amount equal to their [color=aqua]Level[/color] and [color=aqua]1 Lifeforce[/color]. If it has no [color=aqua]Hunger[/color] and [color=aqua]0+ Lifeforce[/color], it may repair itself."
				#Lifeforce
				text += "\n    [color=#d1b970]Lifeforce[/color]: " + globals.fastif(globals.state.thecrystal.lifeforce >= 0, "[color=lime]" +str(globals.state.thecrystal.lifeforce) + "[/color]", "[color=red]" +str(globals.state.thecrystal.lifeforce) + "[/color]")
				if globals.state.thecrystal.mode == "light":
					text += "; The [color=aqua]Crystal[/color] may grow [color=red]Dark[/color] if it ever has negative [color=aqua]Lifeforce[/color]. It will restore [color=aqua]1 Lifeforce[/color] Daily. If it is still below its [color=aqua]Level[/color], it has a [color=aqua]Chance[/color] to gain [color=aqua]+2[/color] equal to a [color=aqua]Researcher's Wits[/color] as long as they are over a minimum of [color=aqua]40[/color]."
				else:
					text += "; The [color=aqua]Crystal[/color] will not restore any [color=aqua]Lifeforce[/color] Daily and must be fed slaves to recover [color=aqua]Lifeforce[/color]."
				#Hunger
				if globals.state.thecrystal.hunger != 0:
					text += "\n    [color=#d1b970]Hunger[/color]: " + globals.fastif(globals.state.thecrystal.hunger > 0, "[color=red]" +str(globals.state.thecrystal.hunger) + "[/color]", "[color=lime]" +str(globals.state.thecrystal.hunger) + "[/color]")
					text += "; The [color=aqua]Crystal[/color] will consume [color=aqua]Lifeforce[/color] daily equal to its [color=aqua]Hunger[/color]. "
					if globals.state.thecrystal.mode == "dark":
						text += "Its [color=aqua]Hunger[/color] grows by [color=red]1[/color] Daily. It must have a [color=aqua]Hunger[/color] of [color=aqua]0 or less[/color] to turn [color=aqua]Light[/color] again."
				text += "\n"
			#Pregnancy Speeds
			if globals.state.thecrystal.abilities.has('pregnancyspeed'):
				text += "\nYou have learned how to use the magic of the [color=aqua]Crystal[/color] to affect the [color=aqua]Speed of Pregnancies[/color] in the Mansion. "
			#Second Wind (1/Day Combat Revive)
			if globals.state.thecrystal.abilities.has('secondwind'):
				text += "\nYou have learned how to harness the magic of the [color=aqua]Crystal[/color] to revive you and your slaves to half health from a fatal blow in combat once per day. You know this will increase the [color=aqua]Crystal's Hunger[/color] and diminish any [color=aqua]Lifeforce[/color] stored within it."
			#Immortality (Death Prevention)
			if globals.state.thecrystal.abilities.has('immortality'):
				text += "\nYou have learned how to use the magic of the [color=aqua]Crystal[/color] to grant temporary [color=aqua]Immortality[/color] to people inside the Mansion and in combat with you. "
			#Sacrifice (Restore Lifeforce)
			if globals.state.thecrystal.abilities.has('sacrifice'):
				text += "\nYou know how to sacrifice your slaves sate the hunger of the [color=aqua]Crystal[/color] with their life-force. You understand that each level a slave has will provide more essence for the [color=aqua]Crystal[/color] to consume, and that the [color=aqua]Crystal[/color] can never fully heal while hungry. "
				if globals.state.thecrystal.hunger > 0:
					text += "\n\nCrystal's Hunger: [color=aqua]" + str(globals.state.thecrystal.hunger) + "[/color]"
				
				if globals.state.thecrystal.abilities.has('understandsacrifice'):
					text += "\n\nYou have come to understand that sacrificing someone to the [color=aqua]Crystal[/color] will feed it an amount equal to their level (reducing hunger) as well as restoring 1 life-force to the [color=aqua]Crystal[/color], partially healing it. "
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
	###---End Expansion---###
	
	if (globals.slaves.size() >= 8 && jobdict.headgirl != null) || globals.developmode == true:
		get_node("charlistcontrol/slavelist").show()
	else:
		get_node("charlistcontrol/slavelist").hide()


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
		person.preg.ovulation_stage = 1
		person.preg.ovulation_day = -3
###---End of Expansion---###

###---Added by Expansion---### Added by Deviate - Minor modifications to add multiple births
func childbirth(person,baby_id):
	person.preg.offspring_count += 1
	get_node("birthpanel").show()
	baby = globals.state.findbaby(baby_id)
	var text = ''
	###---Added by Expansion---### Add Metrics
	if person.mind.secrets.has('currentpregnancy') && !person.knowledge.has('currentpregnancy'):
		person.metrics.preg += 1
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
			text += person.dictionary(person.quirk("[color=yellow]I understand if you...have to do what you do with the [color=aqua]Crystal[/color]. I would rather you not, obviously, but if you have absolutely have to get rid of to keep the rest of us from being eaten or sacrificed...I won't hold it against you. If it is between me and the baby I didn't want to have...well, you understand.[/color]\n"))
		#---Modified Text and Raising Cost
		text += "\nThe power of the [color=aqua]Dimensional Crystal[/color] will help accelerate it's growth allowing for it to experience entire years in a matter of days as it rests in the [color=aqua]Nursery[/color] next to the [color=aqua]Crystal[/color]."
		text += "\nWould you like to [color=aqua]Raise[/color] it? This will cost you either [color=aqua]500 Gold[/color], [color=aqua]25 Mana and 250 Gold[/color], or [color=aqua]50 Mana[/color] to allow it to grow up healthy.\nYou may also [color=aqua]Give the Baby Away[/color] for no cost or penalty. "
		if globals.state.thecrystal.abilities.has('sacrifice'):
			text += "\nYou can also [color=red]Sacrifice[/color] the baby to the [color=aqua]Crystal[/color]. This will kill the baby but embue the [color=aqua]Crystal[/color] with [color=aqua]1 Life[/color] and lessen [color=aqua]1-3 Hunger[/color]."
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
	get_node("birthpanel/portraitpanel/portrait").set_texture(null)
	if person.imageportait != null && globals.loadimage(person.imageportait) != null:
		get_node("birthpanel/portraitpanel/portrait").set_texture(globals.loadimage(person.imageportait))
	elif globals.gallery.nakedsprites.has(person.unique):
		if person.obed <= 50 || person.stress > 50:
			get_node("birthpanel/portraitpanel/portrait").set_texture(globals.spritedict[globals.gallery.nakedsprites[person.unique].clothrape])
		else:
			get_node("birthpanel/portraitpanel/portrait").set_texture(globals.spritedict[globals.gallery.nakedsprites[person.unique].clothcons])
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

func babyage(age):
	baby.name = get_node("birthpanel/childpanel/LineEdit").get_text()
	if get_node("birthpanel/childpanel/surnamecheckbox").is_pressed() == true:
		baby.surname = globals.player.surname
	###---Added by Expansion---### Size Support || Replaced Functions
	if age == 'child':
		baby.age = 'child'
		baby.away.duration = variables.growuptimechild
	elif age == 'teen':
		baby.age = 'teen'
		baby.away.duration = variables.growuptimeteen
	elif age == 'adult':
		baby.age = 'adult'
		baby.away.duration = variables.growuptimeadult
	baby.away.at = 'growing'
	baby.obed += 75
	baby.loyal += 20
	if baby.sex != 'male':
		baby.vagvirgin = true
	baby.assvirgin = true
	globals.slaves = baby
	globals.state.relativesdata[baby.id].name = baby.name_long()
	globals.state.relativesdata[baby.id].state = 'normal'

	globals.state.babylist.erase(baby)
	baby = null
	get_node("birthpanel").hide()
	get_node("birthpanel/childpanel").hide()
	childbirth_loop(birthmother)

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
	text += text2 + '\nReputation: '
	for i in globals.state.reputation:
		text += i.capitalize() + " - "+ reputationword(globals.state.reputation[i]) + ", "
	text += "\nYour mage order rank: " + dict[int(globals.state.rank)]
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
	if counter >= residentlimit:
		get_node("MainScreen/mansion/farmpanel/ScrollContainer/VBoxContainer/farmadd").set_disabled(true)
	else:
		get_node("MainScreen/mansion/farmpanel/ScrollContainer/VBoxContainer/farmadd").set_disabled(false)
#	if globals.state.mansionupgrades.farmtreatment == 1:
#		text += "\n\n[color=green]Your farm won't break down its residents. [/color]"
#	else:
#		text += "\n\n[color=red]Your farm may cause heavy stress to its residents. [/color]"
	text = text + '\n\nYou have ' + str(counter)+ '/' + str(residentlimit) + ' people present in farm. '
	get_node("MainScreen/mansion/farmpanel").show()
	get_node("MainScreen/mansion/farmpanel/farminfo").set_bbcode(text)
	if globals.state.tutorial.farm == false:
		get_node("tutorialnode").farm()
	###---End Expansion---###

func farminspect(person):
	###---Added by Expansion---### Farm Expansion
	hide_farm_panels()
	get_node("MainScreen/mansion/farmpanel/slavefarminsepct").show()
	var text = globals.expansionfarm.getFarmDescription(person)
	if person.work == 'cow':
	#	get_node("MainScreen/mansion/farmpanel/slavefarminsepct/slaveassigntext").set_bbcode(person.dictionary("You walk to the pen with $name. The " +person.race+ " $child is tightly kept here being milked out of $his mind all day long. $His eyes are devoid of sentience barely reacting at your approach."))
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/slaveassigntext").set_bbcode(person.dictionary(text))
	elif person.work == 'hen':
	#	get_node("MainScreen/mansion/farmpanel/slavefarminsepct/slaveassigntext").set_bbcode(person.dictionary("You walk to the pen with $name. The " +person.race+ " $child is tightly kept here as a hatchery for giant snail, with a sturdy leather harness covering $his body. $His eyes are devoid of sentience barely reacting at your approach. Crouching down next to $him, you can see the swollen curve of $his stomach, stuffed full of the creature's eggs. As you lay a hand on it, you can feel some movement inside - seems like something hatched quite recently and is making its way to be 'born' from $name's well-used hole."))
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/slaveassigntext").set_bbcode(person.dictionary(text))
	selectedfarmslave = person

	#---Bedding
	var haycounter = 0
	var cotcounter = 0
	var bedcounter = 0
	for i in globals.slaves:
		if i == person:
			continue
		if i.farmexpanded.stallbedding == 'hay':
			haycounter += 1
		elif i.farmexpanded.stallbedding == 'cot':
			cotcounter += 1
		elif i.farmexpanded.stallbedding == 'bed':
			bedcounter += 1
	#Build Buttons
	get_node("MainScreen/mansion/farmpanel/slavefarminsepct/stallbedding").clear()
	for i in globals.expansionfarm.allbeddings:
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/stallbedding").add_item(i)
		if person.farmexpanded.stallbedding == i:
			get_node("MainScreen/mansion/farmpanel/slavefarminsepct/stallbedding").select(get_node("MainScreen/mansion/farmpanel/slavefarminsepct/stallbedding").get_item_count()-1)
			
	#Disable if Needed
	#Hay
	if haycounter >= globals.resources.farmexpanded.stallbedding.hay:
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/stallbedding").set_item_disabled(1, true)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/stallbedding").set_item_text(1, 'Insufficient Hay')
	#Cot
	if cotcounter >= globals.resources.farmexpanded.stallbedding.cot:
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/stallbedding").set_item_disabled(2, true)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/stallbedding").set_item_text(2, 'Insufficient Cots')
	#Bed
	if bedcounter >= globals.resources.farmexpanded.stallbedding.bed:
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/stallbedding").set_item_disabled(3, true)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/stallbedding").set_item_text(3, 'Insufficient Beds')
	
	#---Workstations
	var workstations = globals.expansionfarm.allworkstations
	var rackcounter = 0
	var cagecounter = 0
	#Counters
	for i in globals.slaves:
		if i == person:
			continue
		if i.farmexpanded.workstation == 'rack':
			rackcounter += 1
		elif i.farmexpanded.workstation == 'cage':
			cagecounter += 1
	#Build Buttons
	get_node("MainScreen/mansion/farmpanel/slavefarminsepct/workstation").clear()
	for i in workstations:
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/workstation").add_item(i)
		if person.farmexpanded.workstation == i:
			get_node("MainScreen/mansion/farmpanel/slavefarminsepct/workstation").select(get_node("MainScreen/mansion/farmpanel/slavefarminsepct/workstation").get_item_count()-1)
		
	#Disable if Needed
	#Racks
	if rackcounter >= globals.resources.farmexpanded.workstation.rack:
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/workstation").set_item_disabled(1, true)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/workstation").set_item_text(1, 'Insufficient Racks')
	#Cages
	if cagecounter >= globals.resources.farmexpanded.workstation.cage:
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/workstation").set_item_disabled(2, true)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/workstation").set_item_text(2, 'Insufficient Cages')
	
	#---Daily Actions
	var farmhandcounter = 0
	var exhaustcounter = 0
	var inspectioncounter = 0
	var stimulatecounter = 0
	var pampercounter = 0
	var prodcounter = 0
	#Counter
	for i in globals.slaves:
		if i == person:
			continue
		#Count FarmHands to do Actions
		if i.work == 'farmhand':
			farmhandcounter += 1
		if i.farmexpanded.dailyaction == 'exhaust':
			exhaustcounter += 1
		elif i.farmexpanded.dailyaction == 'inspection':
			inspectioncounter += 1
		elif i.farmexpanded.dailyaction == 'pamper':
			pampercounter += 1
		elif i.farmexpanded.dailyaction == 'stimulate':
			stimulatecounter += 1
		elif i.farmexpanded.dailyaction == 'prod':
			prodcounter += 1
	
	#Build Buttons
	get_node("MainScreen/mansion/farmpanel/slavefarminsepct/dailyaction").clear()
	for i in globals.expansionfarm.alldailyactions:
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/dailyaction").add_item(i)
		if person.farmexpanded.dailyaction == i:
			get_node("MainScreen/mansion/farmpanel/slavefarminsepct/dailyaction").select(get_node("MainScreen/mansion/farmpanel/slavefarminsepct/dailyaction").get_item_count()-1)
	
	#Disable if Needed
	#Pamper
	if pampercounter >= farmhandcounter - (prodcounter + stimulatecounter):
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/dailyaction").set_item_disabled(1, true)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/dailyaction").set_item_text(1, 'Insufficient Farmhands')
	else:
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/dailyaction").set_item_disabled(1, false)
	#Stimulate
	if stimulatecounter >= farmhandcounter - (prodcounter + pampercounter):
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/dailyaction").set_item_disabled(2, true)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/dailyaction").set_item_text(2, 'Insufficient Farmhands')
	else:
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/dailyaction").set_item_disabled(2, false)
	#Exhaust
	if exhaustcounter >= farmhandcounter - inspectioncounter:
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/dailyaction").set_item_disabled(3, true)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/dailyaction").set_item_text(3, 'Insufficient Farmhands')
	else:
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/dailyaction").set_item_disabled(3, false)
	#Inspection
	if inspectioncounter >= farmhandcounter - exhaustcounter:
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/dailyaction").set_item_disabled(5, true)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/dailyaction").set_item_text(5, 'Insufficient Farmhands')
	else:
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/dailyaction").set_item_disabled(5, false)
	#Prod
	if prodcounter >= globals.resources.farmexpanded.farminventory.prods:
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/dailyaction").set_item_disabled(6, true)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/dailyaction").set_item_text(6, 'Insufficient Prods')
	elif prodcounter >= farmhandcounter - (pampercounter + stimulatecounter):
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/dailyaction").set_item_disabled(6, true)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/dailyaction").set_item_text(6, 'Insufficient Farmhands')
	else:
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/dailyaction").set_item_disabled(6, false)
	
	#---Breeding
	var choices = globals.expansionfarm.breedingoptions
	get_node("MainScreen/mansion/farmpanel/slavefarminsepct/breedingoption").set_disabled(false)
	get_node("MainScreen/mansion/farmpanel/slavefarminsepct/breedingoption").clear()
	for i in choices:
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/breedingoption").add_item(i)
		if person.farmexpanded.breeding.status == i:
			get_node("MainScreen/mansion/farmpanel/slavefarminsepct/breedingoption").select(get_node("MainScreen/mansion/farmpanel/slavefarminsepct/breedingoption").get_item_count()-1)
	
	#Disable if Needed
	if person.vagina == 'none':
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/breedingoption").set_item_disabled(1, true)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/breedingoption").set_item_text(1, 'No Vagina Present')
	if person.penis == 'none':
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/breedingoption").set_item_disabled(2, true)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/breedingoption").set_item_text(2, 'No Penis Present')
	if person.vagina == 'none' || person.penis == 'none':
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/breedingoption").set_item_disabled(3, true)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/breedingoption").set_item_text(3, 'Both Genitals are needed')
	
	#Breeding & Snails
	if person.farmexpanded.breeding.snails == true:
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/breedingoption").clear()
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/breedingoption").add_item('snails')
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/breedingoption").set_item_disabled(0, true)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/breedingoption").set_item_text(0, 'Breeding Snails')
		person.farmexpanded.breeding.status = 'snails'
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/specifybreedingpartnerbutton").set_disabled(true)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/specifybreedingpartnerbutton").set_tooltip(person.dictionary("$name's womb is being used to breed snails currently."))
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/snailbreeding").set_pressed(person.farmexpanded.breeding.snails)
	else:
		if person.farmexpanded.breeding.status == 'none':
			get_node("MainScreen/mansion/farmpanel/slavefarminsepct/specifybreedingpartnerbutton").set_disabled(true)
			get_node("MainScreen/mansion/farmpanel/slavefarminsepct/specifybreedingpartnerbutton").set_tooltip(person.dictionary('$name is not assigned to breed or be bred'))
		else:
			if person.farmexpanded.breeding.partner == str(-1):
				get_node("MainScreen/mansion/farmpanel/slavefarminsepct/specifybreedingpartnerbutton").set_text("No Partner Specified")
				get_node("MainScreen/mansion/farmpanel/slavefarminsepct/specifybreedingpartnerbutton").set_disabled(false)
			else:
				var partner = globals.state.findslave(person.farmexpanded.breeding.partner)
				get_node("MainScreen/mansion/farmpanel/slavefarminsepct/specifybreedingpartnerbutton").set_text(partner.name_long())
				get_node("MainScreen/mansion/farmpanel/slavefarminsepct/specifybreedingpartnerbutton").set_disabled(false)
				get_node("MainScreen/mansion/farmpanel/slavefarminsepct/specifybreedingpartnerbutton").set_tooltip('')

		var counter = 0
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/snailbreeding").set_disabled(false)
		for i in globals.slaves:
			if i.farmexpanded.breeding.snails == true:
				counter += 1
		if globals.state.mansionupgrades.farmhatchery == 0:
			get_node("MainScreen/mansion/farmpanel/slavefarminsepct/snailbreeding").set_disabled(true)
			get_node("MainScreen/mansion/farmpanel/slavefarminsepct/snailbreeding").set_tooltip("You have to unlock Hatchery first.")
		else:
			if counter >= globals.state.snails:
				get_node("MainScreen/mansion/farmpanel/slavefarminsepct/snailbreeding").set_disabled(true)
				get_node("MainScreen/mansion/farmpanel/slavefarminsepct/snailbreeding").set_tooltip("You don't have any free snails.")
			else:
				get_node("MainScreen/mansion/farmpanel/slavefarminsepct/snailbreeding").set_pressed(person.farmexpanded.breeding.snails)
				get_node("MainScreen/mansion/farmpanel/slavefarminsepct/snailbreeding").set_tooltip(person.dictionary('Set $name to breed snails.'))
	
	get_node("MainScreen/mansion/farmpanel/slavefarminsepct/keeprestrained").set_pressed(person.farmexpanded.restrained)
	get_node("MainScreen/mansion/farmpanel/slavefarminsepct/usesedative").set_pressed(person.farmexpanded.usesedative)
	get_node("MainScreen/mansion/farmpanel/slavefarminsepct/giveaphrodisiac").set_pressed(person.farmexpanded.giveaphrodisiac)
	
	#Milk Extraction
	if person.lactation == true:
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/extractmilk").set_disabled(false)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/extractmilk").set_tooltip('')
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/extractmilk").set_pressed(person.farmexpanded.extractmilk.enabled)
	else:
		person.farmexpanded.extractmilk.enabled = false
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/extractmilk").set_disabled(true)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/extractmilk").set_tooltip(person.dictionary("$name is not currently lactating."))
	#Disable if Not Extracting
	if person.farmexpanded.extractmilk.enabled == false:
		person.farmexpanded.extractmilk.method = 'leak'
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/milkextraction").set_disabled(true)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/milkextraction").set_tooltip(person.dictionary("$name is not having Milk collected."))
		person.farmexpanded.extractmilk.container = 'cup'
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/milkcontaineroptions").set_disabled(true)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/milkcontaineroptions").set_tooltip(person.dictionary("$name is not having Milk collected."))
	else:
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/milkextraction").set_disabled(false)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/milkextraction").set_tooltip('')
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/milkcontaineroptions").set_disabled(false)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/milkcontaineroptions").set_tooltip('')
	
	#Cum Extraction
	get_node("MainScreen/mansion/farmpanel/slavefarminsepct/extractcum").set_pressed(person.farmexpanded.extractcum.enabled)
	#Disable if Not Extracting
	if person.farmexpanded.extractcum.enabled == false:
		person.farmexpanded.extractcum.method = 'leak'
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/cumextraction").set_disabled(true)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/cumextraction").set_tooltip(person.dictionary("$name is not having their Cum collected."))
		person.farmexpanded.extractcum.container = 'cup'
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/cumcontaineroptions").set_disabled(true)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/cumcontaineroptions").set_tooltip(person.dictionary("$name is not having their Cum collected."))
	else:
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/cumextraction").set_disabled(false)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/cumcontaineroptions").set_disabled(false)
	
	#Piss Extraction
	get_node("MainScreen/mansion/farmpanel/slavefarminsepct/extractpiss").set_pressed(person.farmexpanded.extractpiss.enabled)
	#Disable if Not Extracting
	if person.farmexpanded.extractpiss.enabled == false:
		person.farmexpanded.extractpiss.method = 'leak'
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/pissextraction").set_disabled(true)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/pissextraction").set_tooltip(person.dictionary("$name is not having their Piss collected."))
		person.farmexpanded.extractpiss.container = 'cup'
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/pisscontaineroptions").set_disabled(true)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/pisscontaineroptions").set_tooltip(person.dictionary("$name is not having their Piss collected."))
	else:
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/pissextraction").set_disabled(false)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/pisscontaineroptions").set_disabled(false)

	#Build Extraction Options
	var types = globals.expansionfarm.liquidtypes
	#Set up Extraction options
	choices = globals.expansionfarm.extractorsarray
	var suctioncounter = 0
	var pumpcounter = 0
	var pressurepumpcounter = 0
	#Run Counts
	for i in globals.slaves:
		if i == person:
			continue
		for type in types:
			if i.farmexpanded['extract'+type].method == 'suction':
				suctioncounter += 1
			if i.farmexpanded['extract'+type].method == 'pump':
				pumpcounter += 1
			if i.farmexpanded['extract'+type].method == 'pressurepump':
				pressurepumpcounter += 1
	
	#Milk Extractions
	get_node("MainScreen/mansion/farmpanel/slavefarminsepct/milkextraction").clear()
	for i in choices:
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/milkextraction").add_item(i)
		if person.farmexpanded.extractmilk.method == i:
			get_node("MainScreen/mansion/farmpanel/slavefarminsepct/milkextraction").select(get_node("MainScreen/mansion/farmpanel/slavefarminsepct/milkextraction").get_item_count()-1)
	#Cum Extractions
	get_node("MainScreen/mansion/farmpanel/slavefarminsepct/cumextraction").clear()
	for i in choices:
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/cumextraction").add_item(i)
		if person.farmexpanded.extractcum.method == i:
			get_node("MainScreen/mansion/farmpanel/slavefarminsepct/cumextraction").select(get_node("MainScreen/mansion/farmpanel/slavefarminsepct/cumextraction").get_item_count()-1)
	#Piss Extractions
	get_node("MainScreen/mansion/farmpanel/slavefarminsepct/pissextraction").clear()
	for i in choices:
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/pissextraction").add_item(i)
		if person.farmexpanded.extractpiss.method == i:
			get_node("MainScreen/mansion/farmpanel/slavefarminsepct/pissextraction").select(get_node("MainScreen/mansion/farmpanel/slavefarminsepct/pissextraction").get_item_count()-1)

	#Disable Extractions per available items
	if suctioncounter >= globals.resources.farmexpanded.extractors.suction:
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/milkextraction").set_item_disabled(3, true)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/cumextraction").set_item_disabled(3, true)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/pissextraction").set_item_disabled(3, true)
	else:
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/milkextraction").set_item_disabled(3, false)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/cumextraction").set_item_disabled(3, false)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/pissextraction").set_item_disabled(3, false)
	if pumpcounter >= globals.resources.farmexpanded.extractors.pump:
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/milkextraction").set_item_disabled(4, true)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/cumextraction").set_item_disabled(4, true)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/pissextraction").set_item_disabled(4, true)
	else:
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/milkextraction").set_item_disabled(4, false)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/cumextraction").set_item_disabled(4, false)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/pissextraction").set_item_disabled(4, false)
	if pressurepumpcounter >= globals.resources.farmexpanded.extractors.pressurepump:
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/milkextraction").set_item_disabled(5, true)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/cumextraction").set_item_disabled(5, true)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/pissextraction").set_item_disabled(5, true)
	else:
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/milkextraction").set_item_disabled(5, false)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/cumextraction").set_item_disabled(5, false)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/pissextraction").set_item_disabled(5, false)
	
	#Set up Containers options ['cup','bucket','pail','jug','canister', 'bottle']
	choices = globals.expansionfarm.containersarray
	var bucketcounter = 0
	var pailcounter = 0
	var jugcounter = 0
	var canistercounter = 0
	#Run Counts
	for i in globals.slaves:
		if i == person:
			continue
		for type in types:
			if i.farmexpanded['extract'+type].container == 'bucket':
				bucketcounter += 1
			elif i.farmexpanded['extract'+type].container == 'pail':
				pailcounter += 1
			elif i.farmexpanded['extract'+type].container == 'jug':
				jugcounter += 1
			elif i.farmexpanded['extract'+type].container == 'canister':
				canistercounter += 1
	
	#Milk Containers
	get_node("MainScreen/mansion/farmpanel/slavefarminsepct/milkcontaineroptions").clear()
	for i in choices:
		#Bottles aren't valid containers for extraction (just for now)
		if i == 'bottle':
			continue
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/milkcontaineroptions").add_item(i)
		if person.farmexpanded.extractmilk.container == i:
			get_node("MainScreen/mansion/farmpanel/slavefarminsepct/milkcontaineroptions").select(get_node("MainScreen/mansion/farmpanel/slavefarminsepct/milkcontaineroptions").get_item_count()-1)
	#Cum Containers
	get_node("MainScreen/mansion/farmpanel/slavefarminsepct/cumcontaineroptions").clear()
	for i in choices:
		#Bottles aren't valid containers for extraction (just for now)
		if i == 'bottle':
			continue
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/cumcontaineroptions").add_item(i)
		if person.farmexpanded.extractcum.container == i:
			get_node("MainScreen/mansion/farmpanel/slavefarminsepct/cumcontaineroptions").select(get_node("MainScreen/mansion/farmpanel/slavefarminsepct/cumcontaineroptions").get_item_count()-1)
	#Piss Containers
	get_node("MainScreen/mansion/farmpanel/slavefarminsepct/pisscontaineroptions").clear()
	for i in choices:
		#Bottles aren't valid containers for extraction (just for now)
		if i == 'bottle':
			continue
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/pisscontaineroptions").add_item(i)
		if person.farmexpanded.extractpiss.container == i:
			get_node("MainScreen/mansion/farmpanel/slavefarminsepct/pisscontaineroptions").select(get_node("MainScreen/mansion/farmpanel/slavefarminsepct/pisscontaineroptions").get_item_count()-1)
	
	#Disable Containers per available items
	if bucketcounter >= globals.resources.farmexpanded.containers.bucket:
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/milkcontaineroptions").set_item_disabled(1, true)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/cumcontaineroptions").set_item_disabled(1, true)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/pisscontaineroptions").set_item_disabled(1, true)
#	else:
#		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/milkcontaineroptions").set_item_disabled(1, false)
#		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/cumcontaineroptions").set_item_disabled(1, false)
#		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/pisscontaineroptions").set_item_disabled(1, false)
	if pailcounter >= globals.resources.farmexpanded.containers.pail:
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/milkcontaineroptions").set_item_disabled(2, true)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/cumcontaineroptions").set_item_disabled(2, true)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/pisscontaineroptions").set_item_disabled(2, true)
#	else:
#		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/milkcontaineroptions").set_item_disabled(2, false)
#		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/cumcontaineroptions").set_item_disabled(2, false)
#		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/pisscontaineroptions").set_item_disabled(2, false)
	if jugcounter >= globals.resources.farmexpanded.containers.jug:
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/milkcontaineroptions").set_item_disabled(3, true)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/cumcontaineroptions").set_item_disabled(3, true)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/pisscontaineroptions").set_item_disabled(3, true)
	else:
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/milkcontaineroptions").set_item_disabled(3, false)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/cumcontaineroptions").set_item_disabled(3, false)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/pisscontaineroptions").set_item_disabled(3, false)
	if canistercounter >= globals.resources.farmexpanded.containers.canister:
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/milkcontaineroptions").set_item_disabled(4, true)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/cumcontaineroptions").set_item_disabled(4, true)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/pisscontaineroptions").set_item_disabled(4, true)
	else:
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/milkcontaineroptions").set_item_disabled(4, false)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/cumcontaineroptions").set_item_disabled(4, false)
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/pisscontaineroptions").set_item_disabled(4, false)
	
	#Show Cattle Avatar | Mirroring SlaveTab
	get_node("MainScreen/mansion/farmpanel/slavefarminsepct/bodypanel/body").set_texture(null)
	if person.imagefull != null && globals.loadimage(person.imagefull) != null:
		get_node("MainScreen/mansion/farmpanel/slavefarminsepct/bodypanel/body").set_texture(globals.loadimage(person.imagefull))
	elif globals.gallery.nakedsprites.has(person.unique):
		if person.obed <= 50 || person.stress > 50:
			get_node("MainScreen/mansion/farmpanel/slavefarminsepct/bodypanel/body").set_texture(globals.spritedict[globals.gallery.nakedsprites[person.unique].clothrape])
		else:
			get_node("MainScreen/mansion/farmpanel/slavefarminsepct/bodypanel/body").set_texture(globals.spritedict[globals.gallery.nakedsprites[person.unique].clothcons])
	get_node("MainScreen/mansion/farmpanel/slavefarminsepct/bodypanel/body").show()
	get_node("MainScreen/mansion/farmpanel/slavefarminsepct/bodypanel").show()
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
	get_node("MainScreen/mansion/farmpanel/slavetofarm").hide()
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
	get_node("MainScreen/mansion/farmpanel/slavetofarm").hide()
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
	selectslavelist(false, 'farmassignpanel')

func farmassignpanel(person):
	#Handles putting a selected slave into the farm
	hide_farm_panels()
	selectedfarmslave = person
	if person.consentexp.livestock == true:
		get_node("MainScreen/mansion/farmpanel/slavetofarm/addcow").set_disabled(false)
		get_node("MainScreen/mansion/farmpanel/slavetofarm/addcow").set_tooltip('')
	else:
		get_node("MainScreen/mansion/farmpanel/slavetofarm/addcow").set_tooltip(person.dictionary('$name is not willing to become your livestock. Try talking to them about it first.'))
		get_node("MainScreen/mansion/farmpanel/slavetofarm/addcow").set_disabled(true)
	if person.sstr <= globals.player.sstr || person.sagi <= globals.player.sagi || person.energy < 50:
		get_node("MainScreen/mansion/farmpanel/slavetofarm/addcowforce").set_disabled(false)
		get_node("MainScreen/mansion/farmpanel/slavetofarm/addcowforce").set_tooltip(person.dictionary('This action will be very stressful to $name.'))
	else:
		get_node("MainScreen/mansion/farmpanel/slavetofarm/addcowforce").set_tooltip(person.dictionary('$name is both stronger and faster than you and has over most of their energy. Try again when you can overpower them or when they have less than half energy.'))
		get_node("MainScreen/mansion/farmpanel/slavetofarm/addcowforce").set_disabled(true)
	
#	var counter = 0
#	for i in globals.slaves:
#		if i.work == 'hen':
#			counter += 1
#	if globals.state.mansionupgrades.farmhatchery == 0:
#		get_node("MainScreen/mansion/farmpanel/slavetofarm/addhen").set_disabled(true)
#		get_node("MainScreen/mansion/farmpanel/slavetofarm/addhen").set_tooltip("You have to unlock Hatchery first.")
#	else:
#		if counter >= globals.state.snails:
#			get_node("MainScreen/mansion/farmpanel/slavetofarm/addhen").set_disabled(true)
#			get_node("MainScreen/mansion/farmpanel/slavetofarm/addhen").set_tooltip("You don't have any free snails.")
#		else:
#			get_node("MainScreen/mansion/farmpanel/slavetofarm/addhen").set_disabled(false)
#			get_node("MainScreen/mansion/farmpanel/slavetofarm/addhen").set_tooltip("")
	
	get_node("MainScreen/mansion/farmpanel/slavetofarm/slaveassigntext").set_bbcode("[color=#d1b970][center]Breasts[/center][/color]\nTits Size : [color=aqua]" + person.titssize.capitalize() + "[/color]\nLactation: " +globals.fastif(person.lactation == true, '[color=lime]present[/color]', '[color=#ff4949]not present[/color]')+ '. \nHyper-Lactation: ' +globals.fastif(person.lactating.hyperlactation == true, '[color=lime]present[/color]', '[color=#ff4949]not present[/color]')+ '. \n\n[color=#d1b970][center]Genitals[/center][/color]\nPenis: ' +globals.fastif(person.penis != 'none', '[color=green]present[/color]', '[color=#ff4949]not present[/color]')+ '. \nVagina: ' +globals.fastif(person.vagina != 'none', '[color=green]present[/color]', '[color=#ff4949]not present[/color]')+ '.\n\n' +globals.fastif(person.spec == 'hucow', '[color=lime]Trained Hucow[/color]', ''))
	
	###---Added by Expansion---### Display Image and Text | Ankmairdor's BugFix v4
	#Image
	get_node("MainScreen/mansion/farmpanel/slavetofarm/image").set_texture(null)
	if person.imageportait != null && globals.loadimage(person.imageportait) != null:
		get_node("MainScreen/mansion/farmpanel/slavetofarm/image").set_texture(globals.loadimage(person.imageportait))
	elif globals.gallery.nakedsprites.has(person.unique):
		if person.obed <= 50 || person.stress > 50:
			get_node("MainScreen/mansion/farmpanel/slavetofarm/image").set_texture(globals.spritedict[globals.gallery.nakedsprites[person.unique].clothrape])
		else:
			get_node("MainScreen/mansion/farmpanel/slavetofarm/image").set_texture(globals.spritedict[globals.gallery.nakedsprites[person.unique].clothcons])
	get_node("MainScreen/mansion/farmpanel/slavetofarm/image").show()
	#Image Text
	get_node("MainScreen/mansion/farmpanel/slavetofarm/underpictext").set_bbcode("[center][color=aqua]" + person.name_long()+ "[/color]\n\n" + globals.fastif(person.consentexp.livestock == true, '[color=lime]Consent Granted[/color]', '[color=#ff4949]Consent Not Granted[/color][/center]'))
	
	get_node("MainScreen/mansion/farmpanel/slavetofarm").show()
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
	for i in ['extractmilk','extractcum','extractpiss']:
		person.farmexpanded[i].enabled = false
		person.farmexpanded[i].method = 'leak'
		person.farmexpanded[i].container = 'cup'
	get_node("MainScreen/mansion/farmpanel/slavefarminsepct").hide()
	_on_farm_pressed()
	rebuild_slave_list()

func _on_closeslaveinspect_pressed():
	_on_farm_pressed()
	rebuild_slave_list()
	get_node("MainScreen/mansion/farmpanel/slavefarminsepct").hide()

#Currently Unused
func _on_sellproduction_pressed():
	selectedfarmslave.farmoutcome = get_node("MainScreen/mansion/farmpanel/slavefarminsepct/sellproduction").is_pressed()

func _on_over_pressed():
	mainmenu()

###---Added by Expansion---### Farm Expansion
func _on_workstation_selected( ID ):
	var person = selectedfarmslave
	var choices = globals.expansionfarm.allworkstations
	person.farmexpanded.workstation = choices[ID]
	farminspect(person)

func _on_stallbedding_selected( ID ):
	var person = selectedfarmslave
	var choices = globals.expansionfarm.allbeddings
	person.farmexpanded.stallbedding = choices[ID]
	farminspect(person)

func _on_dailyaction_selected( ID ):
	var person = selectedfarmslave
	var choices = globals.expansionfarm.alldailyactions
	person.farmexpanded.dailyaction = choices[ID]
	farminspect(person)

func _on_aphrodisiacbutton_pressed():
	selectedfarmslave.farmexpanded.giveaphrodisiac = get_node("MainScreen/mansion/farmpanel/slavefarminsepct/giveaphrodisiac").is_pressed()
	farminspect(selectedfarmslave)

func _on_keeprestrained_pressed():
	selectedfarmslave.farmexpanded.restrained = get_node("MainScreen/mansion/farmpanel/slavefarminsepct/keeprestrained").is_pressed()
	farminspect(selectedfarmslave)

func _on_extractmilk_pressed():
	selectedfarmslave.farmexpanded.extractmilk.enabled = get_node("MainScreen/mansion/farmpanel/slavefarminsepct/extractmilk").is_pressed()
	farminspect(selectedfarmslave)

func _on_extractmilkselected( ID ):
	var person = selectedfarmslave
	var choices = globals.expansionfarm.extractorsarray
	person.farmexpanded.extractmilk.method = choices[ID]
	farminspect(person)

func _on_milkcontainer_selected( ID ):
	var person = selectedfarmslave
	var choices = globals.expansionfarm.containersarray
	person.farmexpanded.extractmilk.container = choices[ID]
	farminspect(person)

func _on_extractcum_pressed():
	selectedfarmslave.farmexpanded.extractcum.enabled = get_node("MainScreen/mansion/farmpanel/slavefarminsepct/extractcum").is_pressed()
	farminspect(selectedfarmslave)

func _on_extractcumselected( ID ):
	var person = selectedfarmslave
	var choices = globals.expansionfarm.extractorsarray
	person.farmexpanded.extractcum.method = choices[ID]
	farminspect(person)

func _on_cumcontainer_selected( ID ):
	var person = selectedfarmslave
	var choices = globals.expansionfarm.containersarray
	person.farmexpanded.extractcum.container = choices[ID]
	farminspect(person)

func _on_extractpiss_pressed():
	selectedfarmslave.farmexpanded.extractpiss.enabled = get_node("MainScreen/mansion/farmpanel/slavefarminsepct/extractpiss").is_pressed()
	farminspect(selectedfarmslave)

func _on_extractpissselected( ID ):
	var person = selectedfarmslave
	var choices = globals.expansionfarm.extractorsarray
	person.farmexpanded.extractpiss.method = choices[ID]
	farminspect(person)

func _on_pisscontainer_selected( ID ):
	var person = selectedfarmslave
	var choices = globals.expansionfarm.containersarray
	person.farmexpanded.extractpiss.container = choices[ID]
	farminspect(person)

func _on_breeding_option_selected( ID ):
	var person = selectedfarmslave
	var breeding = globals.expansionfarm.breedingoptions
	person.farmexpanded.breeding.status = breeding[ID]
#Tried to get it to check consent first
#	person.assignBreedingJob(breeding[ID])
	farminspect(person)

func _on_specifybreedingpartnerbutton_pressed():
	var person = selectedfarmslave
	selectslavelist_breedingpartner(false, 'assignspecificbreedingpartner', self, 'true', true)
	farminspect(person)

func selectslavelist_breedingpartner(prisoners = false, calledfunction = 'popup', targetnode = self, reqs = 'true', player = false, onlyparty = false):
	var cattle = selectedfarmslave
	var array = []
	nodetocall = targetnode
	functiontocall = calledfunction
	for i in $chooseslavepanel/ScrollContainer/chooseslavelist.get_children():
		if i.name != 'Button':
			i.hide()
			i.free()
	if player == true:
		array.append(globals.player)
	for person in globals.slaves:
		globals.currentslave = person
		if person == cattle:
			continue
		if person.away.duration != 0:
			continue
		if onlyparty == true && !globals.state.playergroup.has(person.id):
			continue
		if person.work != 'cow' && person.work != 'hen':
			if !globals.jobs.jobdict[person.work].location.has('farm') && !globals.jobs.jobdict[person.work].location.has('mansion') && !globals.jobs.jobdict[person.work].tags.has('farm') && !globals.jobs.jobdict[person.work].tags.has('mansion'):
				continue
		if cattle.farmexpanded.breeding.status == 'breeder':
			if person.penis == 'none':
				continue
		elif cattle.farmexpanded.breeding.status == 'stud':
			if person.vagina == 'none':
				continue
		elif cattle.farmexpanded.breeding.status == 'both':
			if person.vagina == 'none' && person.penis == 'none':
				continue
		if globals.evaluate(reqs) == false:
			continue
		if prisoners == false && person.sleep == 'jail' :
			continue
		array.append(person)
	for person in array:
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
		$chooseslavepanel/ScrollContainer/chooseslavelist/.add_child(button)
	if array.size() == 0:
		$chooseslavepanel/Label.text = "No characters fit the condition"
	else:
		$chooseslavepanel/Label.text = "Select Character"
	get_node("chooseslavepanel").show()

func assignspecificbreedingpartner(inputslave = null):
	var person = selectedfarmslave
	var person2 = inputslave
	var text = person.assignBreedingPartner(person2.id)
#	popup(person2.dictionary("You assign $name to be ") + person.dictionary("$name's breeding partner. They will breed together each day until your further instructions."))
	popup(text)
	rebuild_slave_list()
	farminspect(person)

func _on_usesedative_pressed():
	selectedfarmslave.farmexpanded.usesedative = get_node("MainScreen/mansion/farmpanel/slavefarminsepct/usesedative").is_pressed()
	farminspect(selectedfarmslave)
	
func _on_snailbreeding_pressed():
	if selectedfarmslave.farmexpanded.breeding.status != 'none':
		selectedfarmslave.farmexpanded.breeding.status = 'none'
	if selectedfarmslave.farmexpanded.breeding.partner != '-1':
		selectedfarmslave.unassignPartner()
	selectedfarmslave.farmexpanded.breeding.snails = get_node("MainScreen/mansion/farmpanel/slavefarminsepct/snailbreeding").is_pressed()
	farminspect(selectedfarmslave)

#---Snail Panel
func _on_snailbutton_pressed():
	hide_farm_panels()
	var text = "[center]Snail Pit Management[/center]"
	#Snail Display
	if globals.state.snails > 0:
		text += "\n[center]Total Snails Available: [color=aqua]" + str(globals.state.snails) + "[/color][/center] "
	else:
		text += "\n[center][color=red]No Snails Available[/color][/center] "
	get_node("MainScreen/mansion/farmpanel/snailpanel/snailheadertext").set_bbcode(text)
	
	text = ""
	#Unassigned Eggs Display
	get_node("MainScreen/mansion/farmpanel/snailpanel/assignstockpile/counter").set_bbcode(str(globals.resources.farmexpanded.snails.eggs))
	if globals.resources.farmexpanded.snails.eggs > 0:
		text += "\nTotal Unassigned Snail Eggs Available: [color=aqua]" + str(globals.resources.farmexpanded.snails.eggs) + "[/color] "
		get_node("MainScreen/mansion/farmpanel/snailpanel/assignfood/add").set_disabled(false)
		get_node("MainScreen/mansion/farmpanel/snailpanel/assignfood/add").set_tooltip('Pull from the Unassigned stockpile')
		get_node("MainScreen/mansion/farmpanel/snailpanel/assignsell/add").set_disabled(false)
		get_node("MainScreen/mansion/farmpanel/snailpanel/assignsell/add").set_tooltip('Pull from the Unassigned stockpile')
		get_node("MainScreen/mansion/farmpanel/snailpanel/assignhatch/add").set_disabled(false)
		get_node("MainScreen/mansion/farmpanel/snailpanel/assignhatch/add").set_tooltip('Pull from the Unassigned stockpile')
	else:
		get_node("MainScreen/mansion/farmpanel/snailpanel/assignfood/add").set_disabled(true)
		get_node("MainScreen/mansion/farmpanel/snailpanel/assignfood/add").set_tooltip('No unassigned eggs are available.')
		get_node("MainScreen/mansion/farmpanel/snailpanel/assignsell/add").set_disabled(true)
		get_node("MainScreen/mansion/farmpanel/snailpanel/assignsell/add").set_tooltip('No unassigned eggs are available.')
		get_node("MainScreen/mansion/farmpanel/snailpanel/assignhatch/add").set_disabled(true)
		get_node("MainScreen/mansion/farmpanel/snailpanel/assignhatch/add").set_tooltip('No unassigned eggs are available.')
		text += "\n[color=red]No Unassigned Snail Eggs Available[/color] "
		
	#Food
	get_node("MainScreen/mansion/farmpanel/snailpanel/assignfood/counter").set_bbcode(str(globals.resources.farmexpanded.snails.food))
	if globals.resources.farmexpanded.snails.food > 0: 
		text += "\nEggs for [color=aqua]Food[/color]: [color=aqua]" + str(globals.resources.farmexpanded.snails.food) + "[/color] "
		get_node("MainScreen/mansion/farmpanel/snailpanel/assignfood/subtract").set_disabled(false)
		get_node("MainScreen/mansion/farmpanel/snailpanel/assignfood/subtract").set_tooltip('Assign back to the Unassigned stockpile.')
	else:
		text += "\n[color=red]No Snail Eggs waiting to be [color=aqua]Cooked[/color][/color] "
		get_node("MainScreen/mansion/farmpanel/snailpanel/assignfood/subtract").set_disabled(true)
		get_node("MainScreen/mansion/farmpanel/snailpanel/assignfood/subtract").set_tooltip('No eggs are available in this stockpile.')
	if globals.resources.farmexpanded.snails.cookwithoutchef == true:
		text += "|| [color=green]Eggs will be still be cooked without a Chef present[/color] "
	else:
		text += "|| [color=green]Eggs will be not be cooked without a Chef present[/color] "
	get_node("MainScreen/mansion/farmpanel/snailpanel/nochefcook").set_pressed(globals.resources.farmexpanded.snails.cookwithoutchef)
	
	#Sell
	get_node("MainScreen/mansion/farmpanel/snailpanel/assignstockpile/counter").set_bbcode(str(globals.resources.farmexpanded.snails.sell))
	if globals.resources.farmexpanded.snails.sell > 0: 
		text += "\nEggs for [color=aqua]Sale[/color]: [color=aqua]" + str(globals.resources.farmexpanded.snails.sell) + "[/color] "
		get_node("MainScreen/mansion/farmpanel/snailpanel/assignsell/subtract").set_disabled(false)
		get_node("MainScreen/mansion/farmpanel/snailpanel/assignsell/subtract").set_tooltip('Assign back to the Unassigned stockpile.')
	else:
		text += "\n[color=red]No Snail Eggs Assigned to [color=aqua]Sell[/color][/color] "
		get_node("MainScreen/mansion/farmpanel/snailpanel/assignsell/subtract").set_disabled(true)
		get_node("MainScreen/mansion/farmpanel/snailpanel/assignsell/subtract").set_tooltip('No eggs are available in this stockpile.')
	text += "|| Current Price per Egg: [color=aqua]" +str(globals.resources.farmexpanded.snails.goldperegg)+ "[/color]"
	
	#Hatch
	get_node("MainScreen/mansion/farmpanel/snailpanel/assignhatch/counter").set_bbcode(str(globals.resources.farmexpanded.snails.hatch))
	if globals.resources.farmexpanded.snails.hatch > 0: 
		text += "\nEggs for [color=aqua]Hatching[/color]: [color=aqua]" + str(globals.resources.farmexpanded.snails.hatch) + "[/color] "
		get_node("MainScreen/mansion/farmpanel/snailpanel/assignhatch/subtract").set_disabled(false)
		get_node("MainScreen/mansion/farmpanel/snailpanel/assignhatch/subtract").set_tooltip('Assign back to the Unassigned stockpile.')
	else:
		text += "\n[color=red]No Snail Eggs Assigned to [color=aqua]Hatch[/color] in the Incubators[/color] "
		get_node("MainScreen/mansion/farmpanel/snailpanel/assignhatch/subtract").set_disabled(true)
		get_node("MainScreen/mansion/farmpanel/snailpanel/assignhatch/subtract").set_tooltip('No eggs are available in this stockpile.')
	
	#Incubators
	var counter = 0
	var temptext = ""
	var incubators = globals.resources.farmexpanded.incubators
	var incs = ['1','2','3','4','5','6','7','8','9','10']
	for i in incs:
		if incubators[i].level > 0:
			counter += 1
			temptext += "\n" + incubators[i].name + ": [color=aqua]Level " +str(incubators[i].level)+"[/color] - "
			if incubators[i].filled == true:
				temptext += "[color=green]Incubating Egg Growth (" +str(incubators[i].growth)+"/10) "
			else:
				temptext += "[color=red]Empty[/color]"
	text += "\n\n[center]Incubators[/center]\n[center]Total Incubators: [color=aqua]" +str(counter)+ " / 10[/color][/center]\n" + temptext
	get_node("MainScreen/mansion/farmpanel/snailpanel/snaildetailstext").set_bbcode(text)
	
	#AutoPanel
	get_node("MainScreen/mansion/farmpanel/snailpanel/autoassign").clear()
	for i in globals.expansionfarm.snailautooptions:
		get_node("MainScreen/mansion/farmpanel/snailpanel/autoassign").add_item(i)
		if globals.resources.farmexpanded.snails.auto == i:
			get_node("MainScreen/mansion/farmpanel/snailpanel/autoassign").select(get_node("MainScreen/mansion/farmpanel/snailpanel/autoassign").get_item_count()-1)
	
	get_node("MainScreen/mansion/farmpanel/snailpanel").show()

func _on_snailpanelfoodadd_pressed():
	globals.resources.farmexpanded.snails.food += 1
	globals.resources.farmexpanded.snails.eggs -= 1
	_on_snailbutton_pressed()

func _on_snailpanelfoodsubtract_pressed():
	globals.resources.farmexpanded.snails.food -= 1
	globals.resources.farmexpanded.snails.eggs += 1
	_on_snailbutton_pressed()

func _on_snailpanelselladd_pressed():
	globals.resources.farmexpanded.snails.sell += 1
	globals.resources.farmexpanded.snails.eggs -= 1
	_on_snailbutton_pressed()

func _on_snailpanelsellsubtract_pressed():
	globals.resources.farmexpanded.snails.sell -= 1
	globals.resources.farmexpanded.snails.eggs += 1
	_on_snailbutton_pressed()

func _on_snailpanelhatchadd_pressed():
	globals.resources.farmexpanded.snails.hatch += 1
	globals.resources.farmexpanded.snails.eggs -= 1
	_on_snailbutton_pressed()

func _on_snailpanelhatchsubtract_pressed():
	globals.resources.farmexpanded.snails.hatch -= 1
	globals.resources.farmexpanded.snails.eggs += 1
	_on_snailbutton_pressed()

func _on_nochefcook_pressed():
	globals.resources.farmexpanded.snails.cookwithoutchef = get_node("MainScreen/mansion/farmpanel/snailpanel/nochefcook").is_pressed()
	_on_snailbutton_pressed()

func _on_snail_autoassign_selected( ID ):
	var options = globals.expansionfarm.snailautooptions
	globals.resources.farmexpanded.snails.auto = options[ID]
	_on_snailbutton_pressed()

func _on_snailpanelclose_pressed():
	get_node("MainScreen/mansion/farmpanel/snailpanel").hide()

#Vats
func _on_vatsbutton_pressed():
	hide_farm_panels()
	#Vat Header
	var text = "[center][color=#d1b970]Vat Management[/color]\n"
	var vattypes = ['vatmilk', 'vatsemen', 'vatlube', 'vatpiss']
	var vatcount = 0
	var vatmax = 0
	for vats in vattypes:
		if globals.state.mansionupgrades[vats] > 0:
			vatcount += 1
	if vatcount >= globals.state.mansionupgrades.vatspace:
		text += "[color=red]No Remaining Space for new Vats. " + str(vatcount) + " / " + str(globals.state.mansionupgrades.vatspace) + "[/color][/center]"
	else:
		vatcount = globals.state.mansionupgrades.vatspace - vatcount
		text += "[color=aqua]Space Open for New Vats: " + str(vatcount) + " / " + str(globals.state.mansionupgrades.vatspace) + "[/color][/center]"
	get_node("MainScreen/mansion/farmpanel/vatspanel/vatheadertext").set_bbcode(text)
	#Vat Capacity: Milk
	text = ""
	if globals.state.mansionupgrades.vatmilk > 0:
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatmilkbutton").set_meta('type', 'milk')
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatmilkbutton").set_disabled(false)
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatmilkbutton").set_tooltip('Manage Milk Vat.')
		vatmax = globals.getVatMaxCapacity('vatmilk')
		if globals.resources.farmexpanded.vats.milk.vat < vatmax:
			text += "[center][color=aqua]" + str(globals.resources.farmexpanded.vats.milk.vat) + "[/color] / [color=aqua]" + str(vatmax) + "[/color][/center]"
		else:
			text += "[center][color=red]" + str(globals.resources.farmexpanded.vats.milk.vat) + "[/color] / [color=aqua]" + str(vatmax) + "[/color][/center]"
	else:
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatmilkbutton").set_disabled(true)
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatmilkbutton").set_tooltip('No Milk Vat Installed.')
		text += "[center][color=red]No Milk Vat[/color][/center]"
	get_node("MainScreen/mansion/farmpanel/vatspanel/capacitymilktext").set_bbcode(text)
	#Vat Capacity: Semen
	text = ""
	if globals.state.mansionupgrades.vatsemen > 0:
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatsemenbutton").set_meta('type', 'semen')
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatsemenbutton").set_disabled(false)
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatsemenbutton").set_tooltip('Manage Semen Vat.')
		vatmax = globals.getVatMaxCapacity('vatsemen')
		if globals.resources.farmexpanded.vats.semen.vat < vatmax:
			text += "[center][color=aqua]" + str(globals.resources.farmexpanded.vats.semen.vat) + "[/color] / [color=aqua]" + str(vatmax) + "[/color][/center]"
		else:
			text += "[center][color=red]" + str(globals.resources.farmexpanded.vats.semen.vat) + "[/color] / [color=aqua]" + str(vatmax) + "[/color][/center]"
	else:
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatsemenbutton").set_disabled(true)
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatsemenbutton").set_tooltip('No Semen Vat Installed.')
		text += "[center][color=red]No Semen Vat[/color][/center]"
	get_node("MainScreen/mansion/farmpanel/vatspanel/capacitysementext").set_bbcode(text)
	#Vat Capacity: Lube
	text = ""
	if globals.state.mansionupgrades.vatlube > 0:
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatlubebutton").set_meta('type', 'lube')
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatlubebutton").set_disabled(false)
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatlubebutton").set_tooltip('Manage Lube Vat.')
		vatmax = globals.getVatMaxCapacity('vatlube')
		if globals.resources.farmexpanded.vats.lube.vat < vatmax:
			text += "[center][color=aqua]" + str(globals.resources.farmexpanded.vats.lube.vat) + "[/color] / [color=aqua]" + str(vatmax) + "[/color][/center]"
		else:
			text += "[center][color=red]" + str(globals.resources.farmexpanded.vats.lube.vat) + "[/color] / [color=aqua]" + str(vatmax) + "[/color][/center]"
	else:
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatlubebutton").set_disabled(true)
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatlubebutton").set_tooltip('No Lube Vat Installed.')
		text += "[center][color=red]No Lube Vat[/color][/center]"
	get_node("MainScreen/mansion/farmpanel/vatspanel/capacitylubetext").set_bbcode(text)
	#Vat Capacity: Piss
	text = ""
	if globals.state.mansionupgrades.vatpiss > 0:
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatpissbutton").set_meta('type', 'piss')
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatpissbutton").set_disabled(false)
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatpissbutton").set_tooltip('Manage Piss Vat.')
		vatmax = globals.getVatMaxCapacity('vatpiss')
		if globals.resources.farmexpanded.vats.piss.vat < vatmax:
			text += "[center][color=aqua]" + str(globals.resources.farmexpanded.vats.piss.vat) + "[/color] / [color=aqua]" + str(vatmax) + "[/color][/center]"
		else:
			text += "[center][color=red]" + str(globals.resources.farmexpanded.vats.piss.vat) + "[/color] / [color=aqua]" + str(vatmax) + "[/color][/center]"
	else:
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatpissbutton").set_disabled(true)
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatpissbutton").set_tooltip('No Piss Vat Installed.')
		text += "[center][color=red]No Piss Vat[/color][/center]"
	get_node("MainScreen/mansion/farmpanel/vatspanel/capacitypisstext").set_bbcode(text)
	
	#Disable Unpurchased Buttons
	for vats in vattypes:
		if globals.state.mansionupgrades[vats] == 0:
			get_node("MainScreen/mansion/farmpanel/vatspanel/"+str(vats)+"button").set_disabled(true)
			get_node("MainScreen/mansion/farmpanel/vatspanel/"+str(vats)+"button").set_tooltip("You haven't purchased that type of Vat.")
	
	#Bottler
	globals.resources.farmexpanded.bottler.level = globals.state.mansionupgrades.bottler
	text = "[center][color=#d1b970]Bottler Level:[/color] [color=aqua]" + str(globals.resources.farmexpanded.bottler.level) + "[/color][/center]"
	text += "\n\n[color=#d1b970]Total Bottles Produced:[/color] [color=aqua]" + str(globals.resources.farmexpanded.bottler.totalproduced) + "[/color]"
	text += "\n\n[color=#d1b970]Energy Cost per Bottle Created: [/color]\nMilk: [color=aqua]" + str(globals.resources.farmexpanded.vats.milk.basebottlingenergy - globals.resources.farmexpanded.bottler.level) + "[/color]\nSemen: [color=aqua]" + str(globals.resources.farmexpanded.vats.semen.basebottlingenergy - globals.resources.farmexpanded.bottler.level)
	text += "[/color]\nLube: [color=aqua]" + str(globals.resources.farmexpanded.vats.lube.basebottlingenergy - globals.resources.farmexpanded.bottler.level) + "[/color]\nPiss: [color=aqua]" + str(globals.resources.farmexpanded.vats.piss.basebottlingenergy - globals.resources.farmexpanded.bottler.level) + "[/color]"
	get_node("MainScreen/mansion/farmpanel/vatspanel/bottlertext").set_bbcode(text)
	
	#Bottle Count
	var count = globals.resources.farmexpanded.containers.bottle
	var vats = globals.resources.farmexpanded.vats
	for i in ['milk','semen','lube','piss']:
		if vats[i].bottle2refine > 0:
			count -= vats[i].bottle2refine
		if vats[i].bottle2sell > 0:
			count -= vats[i].bottle2sell
	text = "[center]Stockpile: "
	if count > 0:
		text += "([color=aqua]" + str(count) + "[/color]) / " + str(globals.resources.farmexpanded.containers.bottle) + "[/center] "
	else:
		text += "([color=red]" + str(count) + "[/color]) / " + str(globals.resources.farmexpanded.containers.bottle) + "[/center] "
	get_node("MainScreen/mansion/farmpanel/vatspanel/buybottles/counter").set_bbcode(text)
	
	text = "[center]Cost: " + str(globals.expansionfarm.containerdict.bottle.cost) + "[/center]"
	get_node("MainScreen/mansion/farmpanel/vatspanel/buybottles/cost").set_bbcode(text)
	
	if globals.resources.gold >= globals.expansionfarm.containerdict.bottle.cost:
		get_node("MainScreen/mansion/farmpanel/vatspanel/buybottles/add1").set_disabled(false)
		get_node("MainScreen/mansion/farmpanel/vatspanel/buybottles/add1").set_tooltip('Buy 1 Bottle to use for Refining or Sales.')
	else:
		get_node("MainScreen/mansion/farmpanel/vatspanel/buybottles/add1").set_disabled(true)
		get_node("MainScreen/mansion/farmpanel/vatspanel/buybottles/add1").set_tooltip('You cannot afford 1 Bottle.')
	if globals.resources.gold >= globals.expansionfarm.containerdict.bottle.cost*10:
		get_node("MainScreen/mansion/farmpanel/vatspanel/buybottles/add10").set_disabled(false)
		get_node("MainScreen/mansion/farmpanel/vatspanel/buybottles/add10").set_tooltip('Buy 10 Bottles to use for Refining or Sales.')
	else:
		get_node("MainScreen/mansion/farmpanel/vatspanel/buybottles/add10").set_disabled(true)
		get_node("MainScreen/mansion/farmpanel/vatspanel/buybottles/add10").set_tooltip('You cannot afford 10 Bottles.')
	
	#Main Text: Spruce up with lively details or events later
	text = "[center]You walk into the area of your farm that you have sectioned off and secured for your Vats. You see the " + str(vatcount) + " vats before you to store the fluids and liquids gathered from your slaves."
	get_node("MainScreen/mansion/farmpanel/vatspanel/vatgeneraltext").set_bbcode(text)
	
	get_node("MainScreen/mansion/farmpanel/vatspanel").show()

func _on_buybottle_pressed():
	globals.resources.gold -= globals.expansionfarm.containerdict.bottle.cost
	globals.resources.farmexpanded.containers.bottle += 1
	_on_vatsbutton_pressed()

func _on_buy10bottles_pressed():
	globals.resources.gold -= globals.expansionfarm.containerdict.bottle.cost*10
	globals.resources.farmexpanded.containers.bottle += 10
	_on_vatsbutton_pressed()

func _on_vatspanelclose_pressed():
	get_node("MainScreen/mansion/farmpanel/vatspanel").hide()

#---Vat Details (To manage the specific Vats)
func _on_vatmilkbutton_pressed():
	var type = 'milk'
	vatsdetailspanel(type)

func _on_vatsemenbutton_pressed():
	var type = 'semen'
	vatsdetailspanel(type)

func _on_vatlubebutton_pressed():
	var type = 'lube'
	vatsdetailspanel(type)

func _on_vatpissbutton_pressed():
	var type = 'piss'
	vatsdetailspanel(type)

func vatsdetailspanel(type):
	var vatscode = globals.resources.farmexpanded.vats[type]
	var vatmax = globals.getVatMaxCapacity('vat'+type)
	var text = ""
	
	get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel").set_meta('type', type)
	#Header Text
	text = "[center][color=aqua]" + str(type).capitalize() + " Vat Management[/color][/center]"
	get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel/vatheadertext").set_bbcode(text)
	
	#Body Text
	text = "Vat Level: [color=aqua]" + str(globals.state.mansionupgrades['vat'+type]) + "[/color]"
	#Bottle Count
	var count = globals.resources.farmexpanded.containers.bottle
	for i in ['milk','semen','lube','piss']:
		if globals.resources.farmexpanded.vats[i].bottle2refine > 0:
			count -= globals.resources.farmexpanded.vats[i].bottle2refine
		if globals.resources.farmexpanded.vats[i].bottle2sell > 0:
			count -= globals.resources.farmexpanded.vats[i].bottle2sell
	text += "\nTotal Bottles: [color=aqua]" + str(globals.resources.farmexpanded.containers.bottle) + "[/color]"
	if count >= 0:
		text += "\nUnassigned Bottles: [color=aqua]" + str(count) + "[/color] "
	else:
		text += "\nUnassigned Bottles: [color=red]" + str(count) + "[/color] "
	
	#Unassigned (General Vat)
	text = "[center]" + str(vatscode.vat) + " / " + str(vatmax) + " [/center] "
	get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel/assignstockpile/counter").set_bbcode(text)
	var freespace = vatmax - (vatscode.vat + vatscode.food + vatscode.bottle2refine + vatscode.bottle2sell)
	freespace = clamp(freespace, 0, 1000)
	if freespace > 0:
		text = "[center]Free Space: [color=aqua]" + str(freespace) + "[/color] "
	else:
		text = "[center]Free Space: [color=red]" + str(freespace) + "[/color] "
	get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel/assignstockpile/freespace").set_bbcode(text)
	
	#Food
	text = "[center]" + str(vatscode.food) + "[/center] "
	get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel/assignfood/counter").set_bbcode(text)
	#Enable/Disable Add/Subtract buttons
	#Subtract Buttons
	if vatscode.food > 0:
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel/assignfood/subtract").set_disabled(false)
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel/assignfood/subtract").set_tooltip('Remove from the Food Stockpile.')
	else:
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel/assignfood/subtract").set_disabled(true)
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel/assignfood/subtract").set_tooltip('Nothing has been set to be cooked.')
	#Add Buttons
	if vatscode.vat > 0:
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel/assignfood/add").set_disabled(false)
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel/assignfood/add").set_tooltip('Assign to the Kitchen to be cooked.')
	else:
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel/assignfood/add").set_disabled(true)
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel/assignfood/add").set_tooltip('All of the liquid in the vat has been assigned to a stockpile.')
	
	#Refine
	text = "[center]Stockpile: " + str(globals.itemdict['bottled'+type].amount) + "[/center] "
	get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel/assignrefine/actualcounter").set_bbcode(text)
	text = "[center]" + str(vatscode.bottle2refine) + "[/center] "
	get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel/assignrefine/pendingcounter").set_bbcode(text)
	#Subtract Buttons
	if vatscode.bottle2refine > 0:
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel/assignrefine/subtract").set_disabled(false)
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel/assignrefine/subtract").set_tooltip('Remove from the Refined Stockpile.')
	else:
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel/assignrefine/subtract").set_disabled(true)
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel/assignrefine/subtract").set_tooltip('Nothing has been set to be refined.')
	#Add Buttons
	if vatscode.vat > 0:
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel/assignrefine/add").set_disabled(false)
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel/assignrefine/add").set_tooltip('Assign to be refined into usable bottles.')
	else:
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel/assignrefine/add").set_disabled(true)
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel/assignrefine/add").set_tooltip('All of the liquid in the vat has been assigned to a stockpile.')
	
	#Sell
	text = "[center]Stockpile: " + str(vatscode.sell) + "[/center] "
	get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel/assignsell/actualcounter").set_bbcode(text)
	text = "[center]" + str(vatscode.bottle2sell) + "[/center] "
	get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel/assignsell/pendingcounter").set_bbcode(text)
	#Subtract Buttons
	if vatscode.bottle2sell > 0:
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel/assignsell/subtract").set_disabled(false)
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel/assignsell/subtract").set_tooltip('Remove from the Sales Stockpile.')
	else:
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel/assignsell/subtract").set_disabled(true)
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel/assignsell/subtract").set_tooltip('Nothing has been set to be sold.')
	#Add Buttons
	if vatscode.vat > 0:
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel/assignsell/add").set_disabled(false)
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel/assignsell/add").set_tooltip('Assign to be bottled for sale.')
	else:
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel/assignsell/add").set_disabled(true)
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel/assignsell/add").set_tooltip('All of the liquid in the vat has been assigned to a stockpile.')
	
	#AutoBuy Bottles
	get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel/autobuybottles").set_pressed(globals.resources.farmexpanded.vats[type].autobuybottles)
	
	#AutoAssign Options
	get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel/autoassign").clear()
	for i in globals.expansionfarm.vatsautooptions:
		get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel/autoassign").add_item(i)
		if globals.resources.farmexpanded.vats[type].auto == i:
			get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel/autoassign").select(get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel/autoassign").get_item_count()-1)
	
	get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel").show()

func _on_vatfood_add_pressed():
	var type = get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel").get_meta('type')
	globals.resources.farmexpanded.vats[type].vat -= 1
	globals.resources.farmexpanded.vats[type].food += 1
	vatsdetailspanel(type)

func _on_vatfood_subtract_pressed():
	var type = get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel").get_meta('type')
	globals.resources.farmexpanded.vats[type].vat += 1
	globals.resources.farmexpanded.vats[type].food -= 1
	vatsdetailspanel(type)

func _on_vatrefine_add_pressed():
	var type = get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel").get_meta('type')
	globals.resources.farmexpanded.vats[type].vat -= 1
	globals.resources.farmexpanded.vats[type].bottle2refine += 1
	vatsdetailspanel(type)

func _on_vatrefine_subtract_pressed():
	var type = get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel").get_meta('type')
	globals.resources.farmexpanded.vats[type].vat += 1
	globals.resources.farmexpanded.vats[type].bottle2refine -= 1
	vatsdetailspanel(type)

func _on_vatsell_add_pressed():
	var type = get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel").get_meta('type')
	globals.resources.farmexpanded.vats[type].vat -= 1
	globals.resources.farmexpanded.vats[type].bottle2sell += 1
	vatsdetailspanel(type)

func _on_vatsell_subtract_pressed():
	var type = get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel").get_meta('type')
	globals.resources.farmexpanded.vats[type].vat += 1
	globals.resources.farmexpanded.vats[type].bottle2sell -= 1
	vatsdetailspanel(type)

func _on_autobuybottles_pressed():
	var type = get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel").get_meta('type')
	globals.resources.farmexpanded.vats[type].autobuybottles = get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel/autobuybottles").is_pressed()
	vatsdetailspanel(type)

func _on_vats_autoassign_selected( ID ):
	var type = get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel").get_meta('type')
	var options = globals.expansionfarm.vatsautooptions
	globals.resources.farmexpanded.vats[type].auto = options[ID]
	vatsdetailspanel(type)

func _on_vatsdetailspanelclose_pressed():
	get_node("MainScreen/mansion/farmpanel/vatspanel/vatdetailspanel").hide()
	_on_vatsbutton_pressed()

func _on_workersbutton_pressed():
	hide_farm_panels()
	#Display Farmhands, Milkmaids, Milk Merchants, and Studs
	var worker = null
	var hasworkers = false
	var text = "[color=#d1b970][center]Workers Panel[/center][/color]"
	
	#Farm Manager
	hasworkers = false
	text += "\n\n\n[color=#d1b970][center]Farm Manager[/center][/color]"
	for person in globals.slaves:
		if person.work == 'farmmanager':
			hasworkers = true
			text += person.dictionary("\n[color=aqua]$name[/color] - Energy: " + globals.fastif(person.energy >= 20, "[color=green]"+str(person.energy)+"[/color]", "[color=red]"+str(person.energy)+"[/color]") + " - Job Experience: " + str(person.jobskills.farmmanager) + " ")
			text += "\n\n[color=yellow]Your Farm Manager will serve as a substitute Farm Hand, Milk Maid, or Bottler if none are assigned.[/color]"
	if hasworkers == false:
		text += "\n[color=red]None Assigned[/color]"
	
	#Farmhands
	text += "\n\n[color=#d1b970][center]Farm Hands[/center][/color]"
	for person in globals.slaves:
		if person.work == 'farmhand':
			hasworkers = true
			text += person.dictionary("\n[color=aqua]$name[/color] - Energy: " + globals.fastif(person.energy >= 20, "[color=green]"+str(person.energy)+"[/color]", "[color=red]"+str(person.energy)+"[/color]") + " - Job Experience: " + str(person.jobskills.farmhand) + " ")
			if person.traits.has('Sadist'):
				text += " - [color=aqua]Sadist[/color]"
			if person.traits.has('Dominant'):
				text += " - [color=aqua]Dominant[/color]"
	if hasworkers == false:
		text += "\n[color=red]None Assigned[/color]"
	#Milk-Maids
	hasworkers = false
	text += "\n\n[color=#d1b970][center]Milk Maids[/center][/color]"
	for person in globals.slaves:
		if person.work == 'milkmaid':
			hasworkers = true
			text += person.dictionary("\n[color=aqua]$name[/color] - Energy: " + globals.fastif(person.energy >= 20, "[color=green]"+str(person.energy)+"[/color]", "[color=red]"+str(person.energy)+"[/color]") + " - Job Experience: " + str(person.jobskills.milking) + " ")
			if person.traits.has('Sadist'):
				text += " - [color=aqua]Sadist[/color]"
			if person.traits.has('Dominant'):
				text += " - [color=aqua]Dominant[/color]"
	if hasworkers == false:
		text += "\n[color=red]None Assigned[/color]"
	#Milk Merchant
	hasworkers = false
	text += "\n\n[color=#d1b970][center]Milk Merchants[/center][/color]"
	for person in globals.slaves:
		if person.work == 'milkmerchant':
			hasworkers = true
			text += person.dictionary("\n[color=aqua]$name[/color] - Energy: " + globals.fastif(person.energy >= 20, "[color=green]"+str(person.energy)+"[/color]", "[color=red]"+str(person.energy)+"[/color]") + " - Job Experience: " + str(person.jobskills.milkmerchant) + " ")
	if hasworkers == false:
		text += "\n[color=red]None Assigned[/color]"
	#Bottlers
	hasworkers = false
	text += "\n\n[color=#d1b970][center]Bottlers[/center][/color]"
	for person in globals.slaves:
		if person.work == 'bottler':
			hasworkers = true
			text += person.dictionary("\n[color=aqua]$name[/color] - Energy: " + globals.fastif(person.energy >= 20, "[color=green]"+str(person.energy)+"[/color]", "[color=red]"+str(person.energy)+"[/color]") + " - Job Experience: " + str(person.jobskills.bottler) + " ")
	if hasworkers == false:
		text += "\n[color=red]None Assigned[/color]"
	
	#Apply Text
	get_node("MainScreen/mansion/farmpanel/workerspanel/textbody").set_bbcode(text)
	get_node("MainScreen/mansion/farmpanel/workerspanel").show()

func _on_workerpanelclose_closed():
	get_node("MainScreen/mansion/farmpanel/workerspanel").hide()

#---Store Panel
func _on_storebutton_pressed():
	hide_farm_panels()
	var text = ""
	var farm = globals.resources.farmexpanded
	#globals.expansionfarm.extractorsdict | containersdict
	
	#---Containers
	#Bucket
	text = "[center][color=aqua]" + str(farm.containers.bucket) + "[/color][/center] "
	get_node("MainScreen/mansion/farmpanel/storepanel/containers/bucket/current").set_bbcode(text)
	text = "[center][color=yellow]" + str(globals.expansionfarm.containerdict.bucket.cost) + "[/color][/center] "
	get_node("MainScreen/mansion/farmpanel/storepanel/containers/bucket/price").set_bbcode(text)
	if globals.resources.gold >= globals.expansionfarm.containerdict.bucket.cost:
		get_node("MainScreen/mansion/farmpanel/storepanel/containers/bucket/add").set_disabled(false)
		get_node("MainScreen/mansion/farmpanel/storepanel/containers/bucket/add").set_tooltip('Purchase 1 Bucket')
	else:
		get_node("MainScreen/mansion/farmpanel/storepanel/containers/bucket/add").set_disabled(true)
		get_node("MainScreen/mansion/farmpanel/storepanel/containers/bucket/add").set_tooltip('Insufficient Funds')
	#Pail
	text = "[center][color=aqua]" + str(farm.containers.pail) + "[/color][/center] "
	get_node("MainScreen/mansion/farmpanel/storepanel/containers/pail/current").set_bbcode(text)
	text = "[center][color=yellow]" + str(globals.expansionfarm.containerdict.pail.cost) + "[/color][/center] "
	get_node("MainScreen/mansion/farmpanel/storepanel/containers/pail/price").set_bbcode(text)
	if globals.resources.gold >= globals.expansionfarm.containerdict.pail.cost:
		get_node("MainScreen/mansion/farmpanel/storepanel/containers/pail/add").set_disabled(false)
		get_node("MainScreen/mansion/farmpanel/storepanel/containers/pail/add").set_tooltip('Purchase 1 Pail')
	else:
		get_node("MainScreen/mansion/farmpanel/storepanel/containers/pail/add").set_disabled(true)
		get_node("MainScreen/mansion/farmpanel/storepanel/containers/pail/add").set_tooltip('Insufficient Funds')
	#Jug
	text = "[center][color=aqua]" + str(farm.containers.jug) + "[/color][/center] "
	get_node("MainScreen/mansion/farmpanel/storepanel/containers/jug/current").set_bbcode(text)
	text = "[center][color=yellow]" + str(globals.expansionfarm.containerdict.jug.cost) + "[/color][/center] "
	get_node("MainScreen/mansion/farmpanel/storepanel/containers/jug/price").set_bbcode(text)
	if globals.resources.gold >= globals.expansionfarm.containerdict.jug.cost:
		get_node("MainScreen/mansion/farmpanel/storepanel/containers/jug/add").set_disabled(false)
		get_node("MainScreen/mansion/farmpanel/storepanel/containers/jug/add").set_tooltip('Purchase 1 Jug')
	else:
		get_node("MainScreen/mansion/farmpanel/storepanel/containers/jug/add").set_disabled(true)
		get_node("MainScreen/mansion/farmpanel/storepanel/containers/jug/add").set_tooltip('Insufficient Funds')
	#Canister
	text = "[center][color=aqua]" + str(farm.containers.canister) + "[/color][/center] "
	get_node("MainScreen/mansion/farmpanel/storepanel/containers/canister/current").set_bbcode(text)
	text = "[center][color=yellow]" + str(globals.expansionfarm.containerdict.canister.cost) + "[/color][/center] "
	get_node("MainScreen/mansion/farmpanel/storepanel/containers/canister/price").set_bbcode(text)
	if globals.resources.gold >= globals.expansionfarm.containerdict.canister.cost:
		get_node("MainScreen/mansion/farmpanel/storepanel/containers/canister/add").set_disabled(false)
		get_node("MainScreen/mansion/farmpanel/storepanel/containers/canister/add").set_tooltip('Purchase 1 Canister')
	else:
		get_node("MainScreen/mansion/farmpanel/storepanel/containers/canister/add").set_disabled(true)
		get_node("MainScreen/mansion/farmpanel/storepanel/containers/canister/add").set_tooltip('Insufficient Funds')
	
	#---Extractors
	#Suction
	text = "[center][color=aqua]" + str(farm.extractors.suction) + "[/color][/center] "
	get_node("MainScreen/mansion/farmpanel/storepanel/extractors/suction/current").set_bbcode(text)
	text = "[center][color=yellow]" + str(globals.expansionfarm.extractorsdict.suction.cost) + "[/color][/center] "
	get_node("MainScreen/mansion/farmpanel/storepanel/extractors/suction/price").set_bbcode(text)
	if globals.resources.gold >= globals.expansionfarm.extractorsdict.suction.cost:
		get_node("MainScreen/mansion/farmpanel/storepanel/extractors/suction/add").set_disabled(false)
		get_node("MainScreen/mansion/farmpanel/storepanel/extractors/suction/add").set_tooltip('Purchase 1 ' + str(globals.expansionfarm.extractorsdict.suction.name))
	else:
		get_node("MainScreen/mansion/farmpanel/storepanel/extractors/suction/add").set_disabled(true)
		get_node("MainScreen/mansion/farmpanel/storepanel/extractors/suction/add").set_tooltip('Insufficient Funds')
	#Pump
	text = "[center][color=aqua]" + str(farm.extractors.pump) + "[/color][/center] "
	get_node("MainScreen/mansion/farmpanel/storepanel/extractors/pump/current").set_bbcode(text)
	text = "[center][color=yellow]" + str(globals.expansionfarm.extractorsdict.pump.cost) + "[/color][/center] "
	get_node("MainScreen/mansion/farmpanel/storepanel/extractors/pump/price").set_bbcode(text)
	if globals.resources.gold >= globals.expansionfarm.extractorsdict.pump.cost:
		get_node("MainScreen/mansion/farmpanel/storepanel/extractors/pump/add").set_disabled(false)
		get_node("MainScreen/mansion/farmpanel/storepanel/extractors/pump/add").set_tooltip('Purchase 1 ' + str(globals.expansionfarm.extractorsdict.pump.name))
	else:
		get_node("MainScreen/mansion/farmpanel/storepanel/extractors/pump/add").set_disabled(true)
		get_node("MainScreen/mansion/farmpanel/storepanel/extractors/pump/add").set_tooltip('Insufficient Funds')
	#Pressure Pump
	text = "[center][color=aqua]" + str(farm.extractors.pressurepump) + "[/color][/center] "
	get_node("MainScreen/mansion/farmpanel/storepanel/extractors/pressurepump/current").set_bbcode(text)
	text = "[center][color=yellow]" + str(globals.expansionfarm.extractorsdict.pressurepump.cost) + "[/color][/center] "
	get_node("MainScreen/mansion/farmpanel/storepanel/extractors/pressurepump/price").set_bbcode(text)
	if globals.resources.gold >= globals.expansionfarm.extractorsdict.pressurepump.cost:
		get_node("MainScreen/mansion/farmpanel/storepanel/extractors/pressurepump/add").set_disabled(false)
		get_node("MainScreen/mansion/farmpanel/storepanel/extractors/pressurepump/add").set_tooltip('Purchase 1 ' + str(globals.expansionfarm.extractorsdict.pressurepump.name))
	else:
		get_node("MainScreen/mansion/farmpanel/storepanel/extractors/pressurepump/add").set_disabled(true)
		get_node("MainScreen/mansion/farmpanel/storepanel/extractors/pressurepump/add").set_tooltip('Insufficient Funds')
	
	#---Workstations
	#Rack
	text = "[center][color=aqua]" + str(farm.workstation.rack) + "[/color][/center] "
	get_node("MainScreen/mansion/farmpanel/storepanel/workstations/rack/current").set_bbcode(text)
	text = "[center][color=yellow]" + str(globals.expansionfarm.workstationsdict.rack.cost) + "[/color][/center] "
	get_node("MainScreen/mansion/farmpanel/storepanel/workstations/rack/price").set_bbcode(text)
	if globals.resources.gold >= globals.expansionfarm.workstationsdict.rack.cost:
		get_node("MainScreen/mansion/farmpanel/storepanel/workstations/rack/add").set_disabled(false)
		get_node("MainScreen/mansion/farmpanel/storepanel/workstations/rack/add").set_tooltip('Purchase 1 ' + str(globals.expansionfarm.workstationsdict.rack.name))
	else:
		get_node("MainScreen/mansion/farmpanel/storepanel/workstations/rack/add").set_disabled(true)
		get_node("MainScreen/mansion/farmpanel/storepanel/workstations/rack/add").set_tooltip('Insufficient Funds')
	#Cage
	text = "[center][color=aqua]" + str(farm.workstation.cage) + "[/color][/center] "
	get_node("MainScreen/mansion/farmpanel/storepanel/workstations/cage/current").set_bbcode(text)
	text = "[center][color=yellow]" + str(globals.expansionfarm.workstationsdict.cage.cost) + "[/color][/center] "
	get_node("MainScreen/mansion/farmpanel/storepanel/workstations/cage/price").set_bbcode(text)
	if globals.resources.gold >= globals.expansionfarm.workstationsdict.cage.cost:
		get_node("MainScreen/mansion/farmpanel/storepanel/workstations/cage/add").set_disabled(false)
		get_node("MainScreen/mansion/farmpanel/storepanel/workstations/cage/add").set_tooltip('Purchase 1 ' + str(globals.expansionfarm.workstationsdict.cage.name))
	else:
		get_node("MainScreen/mansion/farmpanel/storepanel/workstations/cage/add").set_disabled(true)
		get_node("MainScreen/mansion/farmpanel/storepanel/workstations/cage/add").set_tooltip('Insufficient Funds')
	
	#---Bedding
	#Hay
	text = "[center][color=aqua]" + str(farm.stallbedding.hay) + "[/color][/center] "
	get_node("MainScreen/mansion/farmpanel/storepanel/bedding/hay/current").set_bbcode(text)
	text = "[center][color=yellow]" + str(globals.expansionfarm.beddingdict.hay.cost) + "[/color][/center] "
	get_node("MainScreen/mansion/farmpanel/storepanel/bedding/hay/price").set_bbcode(text)
	if globals.resources.gold >= globals.expansionfarm.beddingdict.hay.cost:
		get_node("MainScreen/mansion/farmpanel/storepanel/bedding/hay/add").set_disabled(false)
		get_node("MainScreen/mansion/farmpanel/storepanel/bedding/hay/add").set_tooltip('Purchase 1 ' + str(globals.expansionfarm.beddingdict.hay.name))
	else:
		get_node("MainScreen/mansion/farmpanel/storepanel/bedding/hay/add").set_disabled(true)
		get_node("MainScreen/mansion/farmpanel/storepanel/bedding/hay/add").set_tooltip('Insufficient Funds')
	#Cot
	text = "[center][color=aqua]" + str(farm.stallbedding.cot) + "[/color][/center] "
	get_node("MainScreen/mansion/farmpanel/storepanel/bedding/cot/current").set_bbcode(text)
	text = "[center][color=yellow]" + str(globals.expansionfarm.beddingdict.cot.cost) + "[/color][/center] "
	get_node("MainScreen/mansion/farmpanel/storepanel/bedding/cot/price").set_bbcode(text)
	if globals.resources.gold >= globals.expansionfarm.beddingdict.cot.cost:
		get_node("MainScreen/mansion/farmpanel/storepanel/bedding/cot/add").set_disabled(false)
		get_node("MainScreen/mansion/farmpanel/storepanel/bedding/cot/add").set_tooltip('Purchase 1 ' + str(globals.expansionfarm.beddingdict.cot.name))
	else:
		get_node("MainScreen/mansion/farmpanel/storepanel/bedding/cot/add").set_disabled(true)
		get_node("MainScreen/mansion/farmpanel/storepanel/bedding/cot/add").set_tooltip('Insufficient Funds')
	#Bed
	text = "[center][color=aqua]" + str(farm.stallbedding.bed) + "[/color][/center] "
	get_node("MainScreen/mansion/farmpanel/storepanel/bedding/bed/current").set_bbcode(text)
	text = "[center][color=yellow]" + str(globals.expansionfarm.beddingdict.bed.cost) + "[/color][/center] "
	get_node("MainScreen/mansion/farmpanel/storepanel/bedding/bed/price").set_bbcode(text)
	if globals.resources.gold >= globals.expansionfarm.beddingdict.bed.cost:
		get_node("MainScreen/mansion/farmpanel/storepanel/bedding/bed/add").set_disabled(false)
		get_node("MainScreen/mansion/farmpanel/storepanel/bedding/bed/add").set_tooltip('Purchase 1 ' + str(globals.expansionfarm.beddingdict.bed.name))
	else:
		get_node("MainScreen/mansion/farmpanel/storepanel/bedding/bed/add").set_disabled(true)
		get_node("MainScreen/mansion/farmpanel/storepanel/bedding/bed/add").set_tooltip('Insufficient Funds')
	
	#---Misc Items
	#Aphrodisiac
	text = "[center][color=aqua]" + str(globals.itemdict.aphrodisiac.amount) + "[/color][/center] "
	get_node("MainScreen/mansion/farmpanel/storepanel/items/aphrodisiac/current").set_bbcode(text)
	text = "[center][color=yellow]" + str(globals.expansionfarm.itemsdict.aphrodisiac.cost) + "[/color][/center] "
	get_node("MainScreen/mansion/farmpanel/storepanel/items/aphrodisiac/price").set_bbcode(text)
	if globals.resources.gold >= globals.expansionfarm.itemsdict.aphrodisiac.cost:
		get_node("MainScreen/mansion/farmpanel/storepanel/items/aphrodisiac/add").set_disabled(false)
		get_node("MainScreen/mansion/farmpanel/storepanel/items/aphrodisiac/add").set_tooltip('Purchase 1 ' + str(globals.expansionfarm.itemsdict.aphrodisiac.name))
	else:
		get_node("MainScreen/mansion/farmpanel/storepanel/items/aphrodisiac/add").set_disabled(true)
		get_node("MainScreen/mansion/farmpanel/storepanel/items/aphrodisiac/add").set_tooltip('Insufficient Funds')
	#Sedative
	text = "[center][color=aqua]" + str(globals.itemdict.sedative.amount) + "[/color][/center] "
	get_node("MainScreen/mansion/farmpanel/storepanel/items/sedative/current").set_bbcode(text)
	text = "[center][color=yellow]" + str(globals.expansionfarm.itemsdict.sedative.cost) + "[/color][/center] "
	get_node("MainScreen/mansion/farmpanel/storepanel/items/sedative/price").set_bbcode(text)
	if globals.resources.gold >= globals.expansionfarm.itemsdict.sedative.cost:
		get_node("MainScreen/mansion/farmpanel/storepanel/items/sedative/add").set_disabled(false)
		get_node("MainScreen/mansion/farmpanel/storepanel/items/sedative/add").set_tooltip('Purchase 1 ' + str(globals.expansionfarm.itemsdict.sedative.name))
	else:
		get_node("MainScreen/mansion/farmpanel/storepanel/items/sedative/add").set_disabled(true)
		get_node("MainScreen/mansion/farmpanel/storepanel/items/sedative/add").set_tooltip('Insufficient Funds')
	#Prods
	text = "[center][color=aqua]" + str(farm.farminventory.prods) + "[/color][/center] "
	get_node("MainScreen/mansion/farmpanel/storepanel/items/prods/current").set_bbcode(text)
	text = "[center][color=yellow]" + str(globals.expansionfarm.itemsdict.prods.cost) + "[/color][/center] "
	get_node("MainScreen/mansion/farmpanel/storepanel/items/prods/price").set_bbcode(text)
	if globals.resources.gold >= globals.expansionfarm.itemsdict.prods.cost:
		get_node("MainScreen/mansion/farmpanel/storepanel/items/prods/add").set_disabled(false)
		get_node("MainScreen/mansion/farmpanel/storepanel/items/prods/add").set_tooltip('Purchase 1 ' + str(globals.expansionfarm.itemsdict.prods.name))
	else:
		get_node("MainScreen/mansion/farmpanel/storepanel/items/prods/add").set_disabled(true)
		get_node("MainScreen/mansion/farmpanel/storepanel/items/prods/add").set_tooltip('Insufficient Funds')
	
	get_node("MainScreen/mansion/farmpanel/storepanel").show()

#Buy Buttons
func _on_buy_bucket():
	globals.resources.gold -= globals.expansionfarm.containerdict.bucket.cost
	globals.resources.farmexpanded.containers.bucket += 1
	_on_storebutton_pressed()

func _on_buy_pail():
	globals.resources.gold -= globals.expansionfarm.containerdict.pail.cost
	globals.resources.farmexpanded.containers.pail += 1
	_on_storebutton_pressed()

func _on_buy_jug():
	globals.resources.gold -= globals.expansionfarm.containerdict.jug.cost
	globals.resources.farmexpanded.containers.jug += 1
	_on_storebutton_pressed()

func _on_buy_canister_add():
	globals.resources.gold -= globals.expansionfarm.containerdict.canister.cost
	globals.resources.farmexpanded.containers.canister += 1
	_on_storebutton_pressed()

func _on_buy_suction_add():
	globals.resources.gold -= globals.expansionfarm.extractorsdict.suction.cost
	globals.resources.farmexpanded.extractors.suction += 1
	_on_storebutton_pressed()

func _on_buy_pump_add():
	globals.resources.gold -= globals.expansionfarm.extractorsdict.pump.cost
	globals.resources.farmexpanded.extractors.pump += 1
	_on_storebutton_pressed()

func _on_buy_pressurepump_add():
	globals.resources.gold -= globals.expansionfarm.extractorsdict.pressurepump.cost
	globals.resources.farmexpanded.extractors.pressurepump += 1
	_on_storebutton_pressed()

func _on_buy_rack_add():
	globals.resources.gold -= globals.expansionfarm.workstationsdict.rack.cost
	globals.resources.farmexpanded.workstation.rack += 1
	_on_storebutton_pressed()

func _on_buy_cage_add():
	globals.resources.gold -= globals.expansionfarm.workstationsdict.cage.cost
	globals.resources.farmexpanded.workstation.cage += 1
	_on_storebutton_pressed()

func _on_buy_hay_add():
	globals.resources.gold -= globals.expansionfarm.beddingdict.hay.cost
	globals.resources.farmexpanded.stallbedding.hay += 1
	_on_storebutton_pressed()

func _on_buy_cot_add():
	globals.resources.gold -= globals.expansionfarm.beddingdict.cot.cost
	globals.resources.farmexpanded.stallbedding.cot += 1
	_on_storebutton_pressed()

func _on_buy_bed_add():
	globals.resources.gold -= globals.expansionfarm.beddingdict.bed.cost
	globals.resources.farmexpanded.stallbedding.bed += 1
	_on_storebutton_pressed()

func _on_buy_aphrodisiac_add():
	globals.resources.gold -= globals.expansionfarm.itemsdict.aphrodisiac.cost
	globals.itemdict.aphrodisiac.amount += 1
	_on_storebutton_pressed()

func _on_buy_sedative_add():
	globals.resources.gold -= globals.expansionfarm.itemsdict.sedative.cost
	globals.itemdict.sedative.amount += 1
	_on_storebutton_pressed()

func _on_buy_prods_add():
	globals.resources.gold -= globals.expansionfarm.itemsdict.prods.cost
	globals.resources.farmexpanded.farminventory.prods += 1
	_on_storebutton_pressed()

func _on_incubatorspanel_pressed():
	var text = ""
	var incubators = globals.resources.farmexpanded.incubators
	var inc = ""
	var inc_array = [1,2,3,4,5,6,7,8,9,10]
	for num in inc_array:
		inc = 'inc_' + str(num)
		#Status
		if incubators[str(num)].level <= 0:
			text = '[center][color=red]Not Installed[/color][/center]'
		else:
			if incubators[str(num)].filled == true:
				text = '[center][color=green]Hatching Egg[/color][/center]'
			else:
				text = '[center][color=aqua]Installed[/color][/center]'
		get_node("MainScreen/mansion/farmpanel/storepanel/incubatorspanel/" + inc + "/status").set_bbcode(text)
		#Level
		if incubators[str(num)].level <= 0:
			text = '[center][color=red]X[/color][/center]'
		else:
			text = '[center][color=aqua]'+ str(incubators[str(num)].level) +'[/color][/center]'
		get_node("MainScreen/mansion/farmpanel/storepanel/incubatorspanel/" + inc + "/level").set_bbcode(text)
		#Cost
		var cost = 0
		if incubators[str(num)].level <= 0:
			cost = incubators.basecost
		else:
			cost = round((incubators[str(num)].level * incubators.upgrademultiplier) * incubators.basecost)
		text = '[center][color=red]'+ str(cost) + '[/color][/center]'
		get_node("MainScreen/mansion/farmpanel/storepanel/incubatorspanel/" + inc + "/cost").set_bbcode(text)
		#Upgrade
		if globals.resources.gold >= cost:
			get_node("MainScreen/mansion/farmpanel/storepanel/incubatorspanel/" + inc + "/upgrade").set_disabled(false)
			get_node("MainScreen/mansion/farmpanel/storepanel/incubatorspanel/" + inc + "/upgrade").set_tooltip('Spend ' + str(cost) + ' Gold to upgrade this Incubator')
		else:
			get_node("MainScreen/mansion/farmpanel/storepanel/incubatorspanel/" + inc + "/upgrade").set_disabled(true)
			get_node("MainScreen/mansion/farmpanel/storepanel/incubatorspanel/" + inc + "/upgrade").set_tooltip('Insufficient Funds')
	
	get_node("MainScreen/mansion/farmpanel/storepanel/incubatorspanel").show()

func _on_inc1_pressed():
	_on_incubator_upgrade('1')

func _on_inc2_pressed():
	_on_incubator_upgrade('2')

func _on_inc3_pressed():
	_on_incubator_upgrade('3')

func _on_inc4_pressed():
	_on_incubator_upgrade('4')

func _on_inc5_pressed():
	_on_incubator_upgrade('5')

func _on_inc6_pressed():
	_on_incubator_upgrade('6')

func _on_inc7_pressed():
	_on_incubator_upgrade('7')

func _on_inc8_pressed():
	_on_incubator_upgrade('8')

func _on_inc9_pressed():
	_on_incubator_upgrade('9')

func _on_inc10_pressed():
	_on_incubator_upgrade('10')

func _on_incubator_upgrade(number):
	var num = number
	var incubators = globals.resources.farmexpanded.incubators
	var cost = 0
	if incubators[num].level <= 0:
		cost = incubators.basecost
	else:
		cost = round((incubators[num].level * incubators.upgrademultiplier) * incubators.basecost)
	globals.resources.gold -= cost
	incubators[num].level += 1
	_on_incubatorspanel_pressed()

func _on_incubatorspanel_close():
	get_node("MainScreen/mansion/farmpanel/storepanel/incubatorspanel").hide()

func _on_storepanel_close():
	get_node("MainScreen/mansion/farmpanel/storepanel").hide()

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
	get_node("MainScreen/mansion/farmpanel/slavefarminsepct").hide()
	get_node("MainScreen/mansion/farmpanel/snailpanel").hide()
	get_node("MainScreen/mansion/farmpanel/vatspanel").hide()
	get_node("MainScreen/mansion/farmpanel/workerspanel").hide()
	get_node("MainScreen/mansion/farmpanel/storepanel").hide()
	get_node("MainScreen/mansion/farmpanel/storepanel/incubatorspanel").hide()
	get_node("MainScreen/mansion/farmpanel/farmhelppanel").hide()
###---End Expansion---###

func _on_defeateddescript_meta_clicked( meta ):
	var person = get_node("explorationnode/winningpanel/defeateddescript").get_meta('slave')
	showracedescript(person)

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
