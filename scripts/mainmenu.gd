
###---Added by Expansion---### Player Expanded | Added new Hobby
var hobbydescription = {
	'Physical' : '[color=aqua]+1 Max Strength, +25 Courage[/color]\n\n$name is no stranger to fighting and tends to act boldly in many situations.',
	'Etiquette' : "[color=aqua]+20 Confidence, +15 Charm[/color]\n\n$name has spent $his youth among elderly people and high society, learning how to be liked and present $himself while also feeling superior to commonfolk.",
	'Graceful' : "[color=aqua]+1 Max Agility, +10 Confidence[/color]\n\n$name was the fastest kid $he knew growing up and a natural when it came to hand-eye coordination in general.", #ralph3
	'Magic' : "[color=aqua]+1 Max Magic, +25 Wit[/color]\n\n$name was a very curious child and spent a lot of $his time reading and studying various things, including magic.", #ralph3
	'Servitude' : "[color=aqua]+1 Max Endurance, +35 Min Obedience, +20 Loyalty[/color]\n\n$name has spent $his youth in harsh training which lead to $him being more physically fit and respecting to $his superiors.",
	'Curious' : "[color=aqua]Start with the [color=green]Gifted[/color] trait.[/color]\n\n$name spends $his time searching for answers and meaning in this crazy world. This has led $him to become more receptive to new skills and knowledge.",
	'Genius' : "[color=aqua]Start with the [color=green]Clever[/color] trait and randomly either the [color=green]Responsive[/color] or [color=green]Gifted[/color] trait.[/color]\n[color=red]Gains either the Clumsy, Frail, or Weak trait.[/color]\n\n$name spends $his time studying and thinking and tends to not focus on physical activities.\n",
	'Socialite' : "[color=aqua]Start with the traits [color=green]Pretty Voice[/color] and either [color=green]Natural Beauty[/color] or [color=green]Ditzy[/color]. Gain [color=red]Fickle[/color].[/color]\n\n$name understands that the only real happiness in life comes from being popular and now even craves the attention from others.\n",
	'Waifu' : "[color=aqua]Start with the traits [color=green]Monogamous[/color], [color=green]Fertile[/color], [color=green]Ascetic[/color], [color=red]Clingy[/color], and [color=red]Submissive[/color][/color]\n\n$name has spent $his whole life preparing $himself to be the perfect, submissive partner.\n\n[color=yellow]Very Unbalanced[/color]\n",
	'Perfect Specimen' : "[color=aqua]Start with the traits [color=green]Strong[/color], [color=green]Quick[/color], [color=green]Robust[/color], and [color=green]Responsive[/color].[/color]\n\n$name has been perfectly crafted to be the perfect specimen of their race.\n\n[color=red]Insanely Unbalanced[/color]\n"
}

#Provides a container for Additional Hobbies
var slaveHobbiesExpanded = ['Graceful','Curious','Genius','Socialite','Waifu','Perfect Specimen'] #ralph3
###---Expansion End---###

#Added Penis Sizes
#QMod - Refactor
func _process_stage6_sex_options():
	#Add sex size options
	var sexSizes = []
	if makeoverPerson.sex == 'male':
		sexSizes = malesizes
	else:
		sexSizes = femalesizes

	for i in sexSizes:
		get_node("TextureFrame/newgame/stage6/asssize").add_item(i)
		if makeoverPerson.asssize == i:
			get_node("TextureFrame/newgame/stage6/asssize").select(get_node("TextureFrame/newgame/stage6/asssize").get_item_count()-1)
		get_node("TextureFrame/newgame/stage6/titssize").add_item(i)
		if makeoverPerson.titssize == i:
			get_node("TextureFrame/newgame/stage6/titssize").select(get_node("TextureFrame/newgame/stage6/titssize").get_item_count()-1)

	if makeoverPerson.sex != 'female':
		get_node("TextureFrame/newgame/stage6/penis").set_disabled(false)
		get_node("TextureFrame/newgame/stage6/balls").set_disabled(false)
		for i in ['none','micro','tiny','small','average','large','massive']:
			get_node("TextureFrame/newgame/stage6/penis").add_item(i)
			if makeoverPerson.penis == i:
				get_node("TextureFrame/newgame/stage6/penis").select(get_node("TextureFrame/newgame/stage6/penis").get_item_count()-1)
			get_node("TextureFrame/newgame/stage6/balls").add_item(i)
			if makeoverPerson.balls == i:
				get_node("TextureFrame/newgame/stage6/balls").select(get_node("TextureFrame/newgame/stage6/balls").get_item_count()-1)
	else:
		get_node("TextureFrame/newgame/stage6/penis").set_disabled(true)
		get_node("TextureFrame/newgame/stage6/penis").add_item('none')
		get_node("TextureFrame/newgame/stage6/balls").set_disabled(true)
		get_node("TextureFrame/newgame/stage6/balls").add_item('none')


#QMod - Renamed, tweaked variable initialization
func _ready_newgame_creator():
	#Connect UI
	#Connect stage selection buttons
	for i in get_node("TextureFrame/newgame/stagespanel/VBoxContainer").get_children():
		if i.get_name() != 'cancel':
			i.connect("pressed", self, '_select_stage', [i])
	
	#Connect text entry boxes	
	for i in get_tree().get_nodes_in_group("lookline"):  
		i.connect("text_changed", self, '_lookline_text', [i])
	
	#Connect list options
	for i in get_tree().get_nodes_in_group("lookoption"):  
		i.connect("item_selected", self, '_option_select', [i])
	
	#Connect stat up/down buttons	
	for i in get_tree().get_nodes_in_group("statup"):  
		i.connect("pressed",self,'statup',[i])		
	for i in get_tree().get_nodes_in_group("statdown"):
		i.connect("pressed",self,'statdown',[i])
	
	#Connect slave name entry boxes
	for i in ["TextureFrame/newgame/stage8/slavename", "TextureFrame/newgame/stage8/slavesurname"]:
		var temp = get_node(i)
		temp.connect("text_changed", self, '_slavename_text', [temp])

	#Connect slave customization options
	for i in get_tree().get_nodes_in_group("slaveoption"):  
		i.connect("item_selected",self,'_slave_option', [i])
	
	#Connect game options/settings
	for i in get_tree().get_nodes_in_group("startoption"):  
		i.connect("pressed",self,'_option_toggle',[i])
	
	#Connect virgin option
	get_node("TextureFrame/newgame/stage6/virgin").connect("pressed", self, '_virgin_press')
	
	#Initialize newgame variables
	player = globals.newslave(playerDefaults.race, playerDefaults.age, playerDefaults.sex, playerDefaults.origins) #Prefer to use a constructor/builder
	#ralph
	player.playercleartraits()
	#/ralph
	player.hairstyle = 'straight'
	player.beautybase = variables.playerstartbeauty
	
	startSlave = globals.newslave(slaveDefaults.race, slaveDefaults.age, slaveDefaults.sex, slaveDefaults.origins) #Prefer a constructor/builder
	startSlave.cleartraits()
	startSlave.beautybase = variables.characterstartbeauty
	startSlave.memory = slaveBackgrounds.back()
	
	globals.resources.panel = null #Clear global variables
	globals.showalisegreet = false

	_build_player_portraits() #Build Player portrait list

func regenerateplayer():
	var imageportait = player.imageportait
	player = globals.newslave(player.race, player.age, player.sex, 'slave')
	globals.player = player
	#ralph
	player.playercleartraits()
	#/ralph
	player.unique = 'player'
	player.imageportait = imageportait
	player.imagefull = null
	player.beautybase = variables.playerstartbeauty
	playerBonusStatPoints = variables.playerbonusstatpoint
	for i in ['str','agi','maf','end']:
		player.stats[i+'_max'] = 4
	_update_stage5()


###---Added by Expansion---### Traits to Forbidden
#QMod - Refactor
func _process_stage6_body_options():
	#Process height
	for i in globals.heightarray:
		get_node("TextureFrame/newgame/stage6/height").add_item(i)
		if makeoverPerson.height == i:
			get_node("TextureFrame/newgame/stage6/height").select(get_node("TextureFrame/newgame/stage6/height").get_item_count()-1)

	#Process hair
	for i in globals.hairlengtharray:
		get_node("TextureFrame/newgame/stage6/hairlength").add_item(i)
		if makeoverPerson.hairlength == i:
			get_node("TextureFrame/newgame/stage6/hairlength").select(get_node("TextureFrame/newgame/stage6/hairlength").get_item_count()-1)

	#Process skin hues
	var skinHues
	if skindict.has(makeoverPerson.race.to_lower()):
		skinHues = skindict[makeoverPerson.race.to_lower()]
	else:
		skinHues = skindict.human
	for i in skinHues:
		get_node("TextureFrame/newgame/stage6/skin").add_item(i)
		if makeoverPerson.skin == i:
			get_node("TextureFrame/newgame/stage6/skin").select(get_node("TextureFrame/newgame/stage6/skin").get_item_count()-1)

	#Process horns
	var hornTypes
	if horndict.has(makeoverPerson.race.to_lower()):
		hornTypes = horndict[makeoverPerson.race.to_lower()]
		get_node("TextureFrame/newgame/stage6/horns").set_disabled(false)
	else:
		hornTypes = horndict.human
		get_node("TextureFrame/newgame/stage6/horns").set_disabled(true)
	for i in hornTypes:
		get_node("TextureFrame/newgame/stage6/horns").add_item(i.replace("_", " "))
		if makeoverPerson.horns == i:
			get_node("TextureFrame/newgame/stage6/horns").select(get_node("TextureFrame/newgame/stage6/horns").get_item_count()-1)

	#Process wings
	var wingTypes
	if wingsdict.has(makeoverPerson.race.to_lower()):
		wingTypes = wingsdict[makeoverPerson.race.to_lower()]
		get_node("TextureFrame/newgame/stage6/wings").set_disabled(false)
	else:
		wingTypes = wingsdict.human
		get_node("TextureFrame/newgame/stage6/wings").set_disabled(true)
	for i in wingTypes:
		get_node("TextureFrame/newgame/stage6/wings").add_item(i.replace("_", " "))
		###---Added by Expansion---### Ank Bugfix v4
		if makeoverPerson.wings == i:
			get_node("TextureFrame/newgame/stage6/wings").select(get_node("TextureFrame/newgame/stage6/wings").get_item_count()-1)
		###---End Expansion---###

	#Process fur colors
	var furColors
	if furcolordict.has(makeoverPerson.race.to_lower()):
		furColors = furcolordict[makeoverPerson.race.to_lower()]
		get_node("TextureFrame/newgame/stage6/furcolor").set_disabled(false)
	else:
		furColors = furcolordict.human
		get_node("TextureFrame/newgame/stage6/furcolor").set_disabled(true)
	for i in furColors:
		get_node("TextureFrame/newgame/stage6/furcolor").add_item(i.replace("_", " "))
		if makeoverPerson.furcolor == i:
			get_node("TextureFrame/newgame/stage6/furcolor").select(get_node("TextureFrame/newgame/stage6/furcolor").get_item_count()-1)

	###---Added by Expansion---### Person Expanded | Sexuality, Lip, Asshole, and Vagina Sizes
	for i in globals.kinseyscale:
		get_node("TextureFrame/newgame/stage6/sexuality").add_item(i)
		if makeoverPerson.sexuality == i:
			get_node("TextureFrame/newgame/stage6/sexuality").select(get_node("TextureFrame/newgame/stage6/sexuality").get_item_count()-1)

	for i in globals.lipssizearray:
		get_node("TextureFrame/newgame/stage6/lips").add_item(i)
		if makeoverPerson.lips == i:
			get_node("TextureFrame/newgame/stage6/lips").select(get_node("TextureFrame/newgame/stage6/lips").get_item_count()-1)

	for i in globals.vagsizearray:
		get_node("TextureFrame/newgame/stage6/asshole").add_item(i)
		if makeoverPerson.asshole == i:
			get_node("TextureFrame/newgame/stage6/asshole").select(get_node("TextureFrame/newgame/stage6/asshole").get_item_count()-1)

	if makeoverPerson.sex != 'male':
		get_node("TextureFrame/newgame/stage6/vagina").set_disabled(false)
		for i in globals.vagsizearray:
			get_node("TextureFrame/newgame/stage6/vagina").add_item(i)
			if makeoverPerson.vagina == i:
				get_node("TextureFrame/newgame/stage6/vagina").select(get_node("TextureFrame/newgame/stage6/vagina").get_item_count()-1)
	else:
		get_node("TextureFrame/newgame/stage6/vagina").set_disabled(true)
		get_node("TextureFrame/newgame/stage6/vagina").add_item('none')

	###---End Expansion---###


func _select_stage(button):
	#Check character creation - player or first slave
	if stage >= 7 && button.get_position_in_parent() < 7: #Moving from first slave creation back to player creation
		player = globals.player #Restore previously customized player character
		startSlave.cleartraits() #Clear starting slave selected trait(s)
		startSlave.memory = slaveBackgrounds[0]
		startSlaveHobby = slaveHobbies[0]
	
	if stage >= 6: #If backtracking after reaching player specialization stage
		var spec = player.spec
		#ralph
		player.playercleartraits()
		#/ralph
		
	#Update stage and advance
	self.stage = button.get_position_in_parent()


func _update_stage6():
	###---Added by Expansion---### Quick Strip
	globals.expansion.quickStrip(makeoverPerson)
	###---End Expansion---###
	var text = makeoverPerson.description()
	get_node("TextureFrame/newgame/stage6/chardescript").set_bbcode(text)

###---Added by Expansion---### Vaginal Sizes Expanded
func _virgin_press():
	if makeoverPerson.vagina != 'none':
		makeoverPerson.vagvirgin = get_node("TextureFrame/newgame/stage6/virgin").is_pressed()
	_update_stage6()
###---End Expansion---###

#Stage07 - Select specialization
func _stage7():
	#Reset specialization
	player.spec = null

	#Set default description
	var text = "Specialization provides a\n" + "considerable bonus to certain way of\n" + "playing."
	get_node("TextureFrame/newgame/stage7/backgroundtext").set_bbcode(text)

	#Clear specializations list
	for i in get_node("TextureFrame/newgame/stage7/backgroundcontainer/VBoxContainer").get_children():
		if i != get_node("TextureFrame/newgame/stage7/backgroundcontainer/VBoxContainer/Button"):
			i.visible = false
			i.queue_free()

	#Build specialization list
	###---Added by Expansion---### New Specializations
	for i in globals.expandedplayerspecs:
		var newbutton = get_node("TextureFrame/newgame/stage7/backgroundcontainer/VBoxContainer/Button").duplicate()
		get_node("TextureFrame/newgame/stage7/backgroundcontainer/VBoxContainer").add_child(newbutton)
		newbutton.visible = true
		newbutton.set_text(i)
		newbutton.set_meta('spec', i)
		newbutton.connect("pressed",self,'_select_specialization', [newbutton])
	###---End Expansion---###

	#Disable 'confirm' button
	get_node("TextureFrame/newgame/stage7/backgroundconfirm").set_disabled(true)

#QMod - Renamed, tweaked for 'select' and 'deselect' behavior, added allow 'confirm' only when spec selected
func _select_specialization(button):
	#If button 'unpressed' reset spec panel
	if !button.is_pressed():
		var text = "Specialization provides a\n" + "considerable bonus to certain way of\n" + "playing."
		get_node("TextureFrame/newgame/stage7/backgroundtext").set_bbcode(text)
		get_node("TextureFrame/newgame/stage7/backgroundconfirm").set_disabled(true)
		return

	#Set all non-selected buttons to 'unpressed'
	for i in get_tree().get_nodes_in_group('bgbutton'):
		if i != button:
			i.set_pressed(false)

	#Set player specialization to selected spec
	var spec = button.get_meta('spec')
	player.spec = spec
	#Set specialization description
	###---Added by Expansion---### New Specializations
	var text = globals.expandedplayerspecs[spec]
	if player.spec in ['Mage', 'Alchemist','Breeder']:
		text += "\n\n[color=yellow]Not recommended for inexperienced players.[/color]"
	###---End Expansion---###
	get_node("TextureFrame/newgame/stage7/backgroundtext").set_bbcode(text)

	#Enable 'confirm' button
	get_node("TextureFrame/newgame/stage7/backgroundconfirm").set_disabled(false)

#QMod - Refactor
func _process_stage8_hobby_list():
	#Clear slave hobby list
	for i in get_node("TextureFrame/newgame/stage8/hobbycontainer/VBoxContainer").get_children():
		if i != get_node("TextureFrame/newgame/stage8/hobbycontainer/VBoxContainer/Button"):
			i.visible = false
			i.queue_free()

	#Build slave hobby list
	for i in slaveHobbies:
		var newbutton = get_node("TextureFrame/newgame/stage8/hobbycontainer/VBoxContainer/Button").duplicate()
		newbutton.visible = true
		newbutton.set_meta('hobby', i)
		if startSlaveHobby == i:
			newbutton.set_pressed(true)
		get_node("TextureFrame/newgame/stage8/hobbycontainer/VBoxContainer").add_child(newbutton)
		newbutton.set_text(i)
		newbutton.connect("pressed",self,'_slave_hobby', [newbutton])
	for i in slaveHobbiesExpanded:
		var newbutton = get_node("TextureFrame/newgame/stage8/hobbycontainer/VBoxContainer/Button").duplicate()
		newbutton.visible = true
		newbutton.set_meta('hobby', i)
		if startSlaveHobby == i:
			newbutton.set_pressed(true)
		get_node("TextureFrame/newgame/stage8/hobbycontainer/VBoxContainer").add_child(newbutton)
		newbutton.set_text(i)
		newbutton.connect("pressed",self,'_slave_hobby', [newbutton])

#QMod - Refactor
var forbiddentraits = ['Dominant','Submissive']
func _process_stage8_traits():
	#Clear trait list
	for i in $TextureFrame/newgame/stage8/traitpanel/ScrollContainer/VBoxContainer.get_children():
		if i.name != 'Button':
			i.visible = false
			i.queue_free()

	#Build trait list
	for i in globals.origins.traitlist.values():
		###---Added by Expansion---### Trait Support
		if i.tags.has("secondary") || i.tags.has("lockedtrait") || forbiddentraits.has(i):
			continue
		###---End Expansion---###
		var newbutton = $TextureFrame/newgame/stage8/traitpanel/ScrollContainer/VBoxContainer/Button.duplicate()
		newbutton.visible = true
		$TextureFrame/newgame/stage8/traitpanel/ScrollContainer/VBoxContainer.add_child(newbutton)
		newbutton.text = i.name

		if i.name == slaveTrait:
			newbutton.set_pressed(true)
		else:
			newbutton.set_pressed(false)

		newbutton.connect("pressed",self,'_trait_toggle',[i, newbutton]) #Connect list buttons to trait toggle method

#QMod - Incomplete refactor, removed firecheck
func _on_slaveconfirm_pressed():
	#Finish processing slave
	startSlave.cleartraits() #Clear traits, reset basics
	###---Added by Expansion---### Ank Bugfix v4
	startSlave.health = 1000
	###---End Expansion---###

	#Generate mental stats
	for i in ['conf','cour','wit','charm']:
		startSlave[i] = rand_range(30,35)
	startSlave.obed = 90
	startSlave.beautybase = variables.characterstartbeauty
	if startSlave.memory.find('$sibling') >= 0:
		globals.connectrelatives(startSlave, player, 'sibling')
	
	#Apply hobby bonus
	if startSlaveHobby == 'Physical':
		startSlave.cour += 25
		startSlave.stats.str_max += 1
	elif startSlaveHobby == 'Etiquette':
		startSlave.conf += 20
		startSlave.charm += 15
	#ralph3
	elif startSlaveHobby == 'Graceful':
		startSlave.conf += 10
		startSlave.stats.agi_max += 1
	#/ralph3
	elif startSlaveHobby == 'Magic':
		startSlave.wit += 25
		startSlave.stats.maf_max += 1 #ralph3
	elif startSlaveHobby == 'Servitude':
		startSlave.stats.end_max += 1
		startSlave.loyal += 20
		startSlave.stats.obed_min += 35
	###---Added by Expansion---### New Hobbies
	elif startSlaveHobby == 'Curious':
		startSlave.add_trait('Gifted')
	elif startSlaveHobby == 'Genius':
		startSlave.add_trait('Clever')
		if rand_range(0,1) > .5:
			startSlave.add_trait('Responsive')
		else:
			startSlave.add_trait('Gifted')
		var random = rand_range(0,1)
		if random >= .7:
			startSlave.add_trait('Clumsy')
		elif random <= .3:
			startSlave.add_trait('Weak')
		else:
			startSlave.add_trait('Frail')
	elif startSlaveHobby == 'Socialite':
		startSlave.add_trait('Pretty voice')
		if rand_range(0,1) > .5:
			startSlave.add_trait('Natural Beauty')
		else:
			startSlave.add_trait('Ditzy')
		startSlave.add_trait('Fickle')
	elif startSlaveHobby == 'Waifu':
		startSlave.add_trait('Monogamous')
		startSlave.add_trait('Ascetic')
		startSlave.add_trait('Clingy')
		startSlave.add_trait('Fertile')
		startSlave.add_trait('Submissive')
	elif startSlaveHobby == 'Perfect Specimen':
		startSlave.add_trait('Strong')
		startSlave.add_trait('Quick')
		startSlave.add_trait('Responsive')
		startSlave.add_trait('Robust')
	###---End Expansion---###

	#Add traits
	if slaveTrait != '':
		if slaveTrait == 'Gifted' && startSlave.traits.has('Gifted') == false:
			startSlave.add_trait(slaveTrait)
		else:
			startSlave.add_trait(slaveTrait)

	#Assign start slave to global slave list
	startSlave.unique = 'startslave'
	###---Added by Expansion---### Ovulation Cycle/Genealogy
	#Test Assign
	globals.constructor.set_genealogy(startSlave)
	globals.constructor.forceFullblooded(startSlave)
	globals.constructor.setRaceDisplay(startSlave)
	globals.constructor.set_ovulation(startSlave)
	###---End Expansion---###
	globals.slaves = startSlave#A bit deceptive as it assigns 'person' to 'array', works because of 'setget'

	player.health = 1000

	#Apply player racial bonuses
	###---Added by Expansion---### Races Expanded
	if player.race.find('Elf') >= 0 && player.race.find("Tribal Elf") < 0 && player.race.find("Dark Elf") < 0:
		player.stats.maf_base += 1
	elif player.race.find("Tribal Elf") >= 0:
		player.stats.agi_base += 1
	elif player.race.find('Orc') >= 0:
		globals.state.reputation.gorn += 30
	elif player.race.find('Demon') >= 0:
		for i in globals.state.reputation:
			globals.state.reputation[i] -= 10
		player.skillpoints += 1
	elif player.race.find('Taurus') >= 0:
		player.stats.end_base += 1
	elif player.race.find("Beastkin") >= 0:
		globals.state.reputation.frostford += 30
	elif player.race.find("Halfkin") >= 0:
		for i in globals.state.reputation:
			globals.state.reputation[i] += 15
	###---End Expansion---###
	else:
		globals.state.reputation.wimborn += 30

	#Add starting player abilities
	player.ability.append('escape')
	player.abilityactive.append('escape')
	player.ability.append("protect")
	player.abilityactive.append("protect")

	#Apply external player specialization bonuses
	globals.state.spec = player.spec
	if player.spec == 'Alchemist':
		globals.state.mansionupgrades.mansionalchemy += 1
	###---Added by Expansion---###
	elif player.spec == 'Breeder':
		globals.state.mansionupgrades.mansionnursery += 1
	###---End Expansion---###
	var tempitem
	if player.spec == 'Hunter':
		tempitem = globals.items.createunstackable("weapondagger")
		globals.state.unstackables[str(tempitem.id)] = tempitem
	else:
		tempitem = globals.items.createunstackable("weapondaggerrust")
		globals.state.unstackables[str(tempitem.id)] = tempitem


	#Set globals
	globals.resources.energy = 100
	globals.resources.day = 1
	globals.guildslaves.wimborn = []
	globals.guildslaves.gorn = []
	globals.guildslaves.frostford = []
	globals.guildslaves.umbra = []

	#Apply Game-mode specific bonuses
	if isSandbox == false:
		globals.resources.upgradepoints = 5
		globals.resources.gold += 250
		globals.resources.food += 200
		globals.resources.mana += 10
		###---Added by Expansion---### Farm Expanded
		#Unused Below
		globals.resources.milk = 0
		globals.resources.semen = 0
		globals.resources.lube = 0
		globals.resources.piss = 0
		#Reset Workstations
		globals.resources.farmexpanded.workstation.rack = 0
		globals.resources.farmexpanded.workstation.cage = 0
		#Reset Bedding
		globals.resources.farmexpanded.stallbedding.hay = 0
		globals.resources.farmexpanded.stallbedding.cot = 0
		globals.resources.farmexpanded.stallbedding.bed = 0
		#Reset Extractors
		globals.resources.farmexpanded.extractors.suction = 0
		globals.resources.farmexpanded.extractors.pump = 0
		globals.resources.farmexpanded.extractors.pressurepump = 0
		#Reset Containers
		globals.resources.farmexpanded.containers.bucket = 0
		globals.resources.farmexpanded.containers.pail = 0
		globals.resources.farmexpanded.containers.jug = 0
		globals.resources.farmexpanded.containers.canister = 0
		globals.resources.farmexpanded.containers.bottles = 0
		#Reset Farm Inventory
		globals.resources.farmexpanded.farminventory.prods = 0
		#Reset Vats
		for type in globals.resources.farmexpanded.vats.processingorder:
			globals.resources.farmexpanded.vats[type].vat = 0
			globals.resources.farmexpanded.vats[type].new = 0
			globals.resources.farmexpanded.vats[type].sell = 0
			globals.resources.farmexpanded.vats[type].food = 0
			globals.resources.farmexpanded.vats[type].refine = 0
			globals.resources.farmexpanded.vats[type].bottle2sell = 0
			globals.resources.farmexpanded.vats[type].bottle2refine = 0
			globals.resources.farmexpanded.vats[type].priceper = 0
			globals.resources.farmexpanded.vats[type].foodper = 0
			globals.resources.farmexpanded.vats[type].auto = 'vat'
			globals.resources.farmexpanded.vats[type].autobuybottles = false
		#Reset Incubators
		if globals.resources.farmexpanded.has('incubators') && globals.resources.farmexpanded.incubators.has('1'):
			for num in [1,2,3,4,5,6,7,8,9,10]:
				globals.resources.farmexpanded.incubators[str(num)].level = 0
				globals.resources.farmexpanded.incubators[str(num)].filled = false
				globals.resources.farmexpanded.incubators[str(num)].growth = 0
		#Reset Bottler
		globals.resources.farmexpanded.bottler.level = 0
		globals.resources.farmexpanded.bottler.totalproduced = 0
		globals.expansionsetup.expandGame()
		###---Expansion End---###
	else:
		for i in globals.state.portals.values():
			if i.code != startingLocation:
				i.enabled = true
		globals.resources.upgradepoints = 30
		globals.resources.gold += 5000
		globals.resources.food += 500
		globals.resources.mana += 100
		###---Added by Expansion---### Farm Expanded
		#Unused Below
		globals.resources.milk = 0
		globals.resources.semen = 0
		globals.resources.lube = 0
		globals.resources.piss = 0
		#Reset Workstations
		globals.resources.farmexpanded.workstation.rack = 0
		globals.resources.farmexpanded.workstation.cage = 0
		#Reset Bedding
		globals.resources.farmexpanded.stallbedding.hay = 0
		globals.resources.farmexpanded.stallbedding.cot = 0
		globals.resources.farmexpanded.stallbedding.bed = 0
		#Reset Extractors
		globals.resources.farmexpanded.extractors.suction = 0
		globals.resources.farmexpanded.extractors.pump = 0
		globals.resources.farmexpanded.extractors.pressurepump = 0
		#Reset Containers
		globals.resources.farmexpanded.containers.bucket = 0
		globals.resources.farmexpanded.containers.pail = 0
		globals.resources.farmexpanded.containers.jug = 0
		globals.resources.farmexpanded.containers.canister = 0
		globals.resources.farmexpanded.containers.bottles = 0
		#Reset Farm Inventory
		globals.resources.farmexpanded.farminventory.prods = 0
		#Reset Vats
		for type in globals.resources.farmexpanded.vats.processingorder:
			globals.resources.farmexpanded.vats[type].vat = 0
			globals.resources.farmexpanded.vats[type].new = 0
			globals.resources.farmexpanded.vats[type].sell = 0
			globals.resources.farmexpanded.vats[type].food = 0
			globals.resources.farmexpanded.vats[type].refine = 0
			globals.resources.farmexpanded.vats[type].bottle2sell = 0
			globals.resources.farmexpanded.vats[type].bottle2refine = 0
			globals.resources.farmexpanded.vats[type].priceper = 0
			globals.resources.farmexpanded.vats[type].foodper = 0
			globals.resources.farmexpanded.vats[type].auto = 'vat'
			globals.resources.farmexpanded.vats[type].autobuybottles = false
		#Reset Incubators
		if globals.resources.farmexpanded.has('incubators') && globals.resources.farmexpanded.incubators.has('1'):
			for num in [1,2,3,4,5,6,7,8,9,10]:
				globals.resources.farmexpanded.incubators[str(num)].level = 0
				globals.resources.farmexpanded.incubators[str(num)].filled = false
				globals.resources.farmexpanded.incubators[str(num)].growth = 0
		#Reset Bottler
		globals.resources.farmexpanded.bottler.level = 0
		globals.resources.farmexpanded.bottler.totalproduced = 0
		globals.expansionsetup.expandGame()
		###---Expansion End---###
		globals.state.mainquest = 42
		globals.state.rank = 4
		globals.state.sidequests.brothel = 2
		globals.state.branding = 2
		globals.state.farm = 4
		globals.state.portals.amberguard.enabled = true
		globals.itemdict.youthingpot.unlocked = true
		globals.itemdict.maturingpot.unlocked = true
		globals.state.sidequests.sebastianumbra = 2
		globals.state.portals.umbra.enabled = true
		globals.state.sandbox = true #Added this in case it used somewhere in the future?

	###---Added by Expansion---### Pregnancy Expanded | Ovulation Cycle/Genealogy
	#Test Assign
	globals.constructor.set_genealogy(player)
	globals.constructor.forceFullblooded(player)
	globals.constructor.setRaceDisplay(player)
	globals.constructor.set_ovulation(player)
	globals.expansion.updatePerson(player)
	###---End Expansion---###
	globals.player = player
	###---Added by Expansion---### Ovulation Cycle/Genealogy
	globals.expansion.updatePerson(globals.player)
	###---End Expansion---###
	globals.state.upcomingevents.append({code = 'ssinitiate', duration = 1})
	#Change scene to game start 'Mansion'
	globals.ChangeScene("Mansion")
	#self.queue_free()
	#get_tree().change_scene("res://files/Mansion.scn")
