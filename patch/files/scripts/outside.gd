
extends Control

onready var main = get_parent()
onready var buttoncontainer = $buttonpanel/outsidebuttoncontainer
onready var button = $buttonpanel/outsidebuttoncontainer/buttontemplate
onready var questtext = globals.questtext
onready var mansion = get_parent()
var questgiveawayslave

#QMod - Variables
#onready var mainQuestTexts = globals.mainQuestTexts
#onready var sideQuestTexts = globals.sideQuestTexts

func _ready():
	if globals.guildslaves.wimborn.size() < 2:
		var rand = round(rand_range(4,6))
		newslaveinguild(rand, 'wimborn')
	if globals.guildslaves.gorn.size() < 2:
		var rand = round(rand_range(4,6))
		newslaveinguild(rand, 'gorn')
	if globals.guildslaves.frostford.size() < 2:
		var rand = round(rand_range(4,6))
		newslaveinguild(rand, 'frostford')
	if globals.guildslaves.umbra.size() < 4:
		var rand = round(rand_range(4,6))
		newslaveinguild(rand, 'umbra')
	for i in ['armor','weapon','costume','accessory','underwear']:
		$playergrouppanel/characterinfo.get_node(i).connect('mouse_entered',self,'iteminfo',[i])
		$playergrouppanel/characterinfo.get_node(i).connect('mouse_exited',self,'iteminfoclose')
	for i in ['sstr','sagi','smaf','send']:
		$playergrouppanel/characterinfo/stats.get_node(i).connect("mouse_entered",self,'statinfo',[i])
		$playergrouppanel/characterinfo/stats.get_node(i).connect("mouse_exited",self,'iteminfoclose')
	for i in ['attack','speed','armor','protection']:
		$playergrouppanel/characterinfo/combstats.get_node(i).connect("mouse_entered",self,'statinfo',[i])
		$playergrouppanel/characterinfo/combstats.get_node(i).connect("mouse_exited",self,'iteminfoclose')
	$minimappanel/map/Control.set_process_input(false)
	$shoppanel/Panel/exchange.connect("pressed", self, "exchangeitems")
	$shoppanel/exchange/TradeButton.connect('pressed', self, 'exchangeitemsconfirm')
	get_node("playergroupdetails/Panel/TabContainer/Items/_v_scroll").visible = false
	get_node("playergroupdetails/Panel/TabContainer/Spells/_v_scroll").visible = false



func _input(event):
	if self.is_visible_in_tree() == false || !(event is InputEventKey) || event.is_echo() == true || event.is_pressed() == false  || main.get_node("screenchange").visible:
		return
	var anythingvisible = false
	for i in get_tree().get_nodes_in_group("blockmaininput"):
		if i.is_visible_in_tree() == true:
			anythingvisible = true
			break
	if anythingvisible == true:
		return

	if str(event.as_text().replace("Kp ",'')) in str(range(1,9)):
		var key = int(event.as_text())
		if buttoncontainer.get_children().size() >= key+1 && buttoncontainer.get_child(key).disabled == false && self.is_visible() == true:
			buttoncontainer.get_child(key).emit_signal("pressed")

	if event.is_action_pressed("B") && get_node("playergrouppanel/details").is_visible_in_tree():
		_on_details_pressed()


func clearbuttons():
	for i in buttoncontainer.get_children():
		if i != button:
			i.visible = false
			i.queue_free()


func buildbuttons(array, target = self, doClear = true, curCount = 0):
	if doClear: #Added for multi-step button builds
		clearbuttons()
	var counter = curCount
	for i in array:
		var newbutton = button.duplicate()
		buttoncontainer.add_child(newbutton)
		newbutton.set_text(i.name)
		newbutton.get_node("Label").set_text(str(counter+1))
		newbutton.visible = true
		if i.has('args'): #QMod - Changed to handle args = [] vs single args only
			if typeof(i.args) == TYPE_ARRAY:
				newbutton.connect('pressed', target, i.function, i.args)
			else:
				newbutton.connect('pressed', target, i.function, [i.args])
		else:
			newbutton.connect('pressed', target, i.function)
		if i.has('disabled'):
			newbutton.set_disabled(i.disabled)
		if i.has('tooltip'):
			newbutton.set_tooltip(i.tooltip)
		if i.has('textcolor'):
			newbutton.set('custom_colors/font_color', Color(0.2,0.6,0.2))
		counter += 1

func addbutton(i, target = self):
	var newbutton = button.duplicate()
	buttoncontainer.add_child(newbutton)
	newbutton.set_text(i.name)
	var count = 1
	for node in buttoncontainer.get_children():
		if node.visible:
			count += 1
	newbutton.get_node("Label").set_text(str(count))
	newbutton.visible = true
	if i.has('args'):
		newbutton.connect('pressed', target, i.function, [i.args])
	else:
		newbutton.connect('pressed', target, i.function)
	if i.has('disabled'):
		newbutton.set_disabled(true)
	if i.has('tooltip'):
		newbutton.set_tooltip(i.tooltip)
	if i.has('textcolor'):
		newbutton.set('custom_colors/font_color', Color(0.2,0.6,0.2))

func _on_leave_pressed():
	if globals.state.calculateweight().overload == true:
		get_parent().infotext("Your backpack is too heavy to leave",'red')
		return
	get_parent().sound("door")
	get_parent().get_node("explorationnode").currentzone = get_parent().get_node("explorationnode").zones[globals.state.location]
	get_parent().get_node("explorationnode").zoneenter(globals.state.location)
	yield(main, 'animfinished')
	gooutside()

func playergrouppanel():
	var charpanel
	var array = []
	for i in get_node("playergrouppanel/VBoxContainer").get_children():
		if i != get_node("playergrouppanel/VBoxContainer/Panel"):
			i.visible = false
			i.queue_free()
	for i in $itemmenu/ScrollContainer/VBoxContainer.get_children():
		if i.get_name() != 'TextureButton':
			i.visible = false
			i.queue_free()
	$playergrouppanel/VBoxContainer.rect_size = $playergrouppanel/VBoxContainer.rect_min_size
	array.append(globals.player)
	for i in globals.state.playergroup:
		array.append(globals.state.findslave(i))
	for person in array:
		charpanel = get_node("playergrouppanel/VBoxContainer/Panel").duplicate()
		get_node("playergrouppanel/VBoxContainer").add_child(charpanel)
		charpanel.visible = true
		charpanel.get_node("button").connect("pressed",self,'opencharacter', [person])
		charpanel.set_meta("person", person)
		buildbars(charpanel, person)
	for i in ['supply','rope','bandage','lockpick','torch']:
		if globals.state.backpack.stackables.has(i):
			charpanel = $itemmenu/ScrollContainer/VBoxContainer/TextureButton.duplicate()
			$itemmenu/ScrollContainer/VBoxContainer.add_child(charpanel)
			charpanel.visible = true
			charpanel.get_node("icon").set_texture(globals.itemdict[i].icon)
			charpanel.hint_tooltip = globals.itemdict[i].name
			charpanel.get_node("Label").text = str(globals.state.backpack.stackables[i])

var geardefaulticon = {
	armor = load("res://files/buttons/inventory/28.png"),
	weapon = load("res://files/buttons/inventory/29.png"),
	accessory = load("res://files/buttons/inventory/27.png"),
	costume = load("res://files/buttons/inventory/25.png"),
	underwear = load("res://files/buttons/inventory/26.png"),
}

func iteminfo(gear):
	var item
	var text = ''
	if partyselectedchar.gear[gear] != null:
		item = globals.state.unstackables[partyselectedchar.gear[gear]]
		globals.itemtooltip(item)

func iteminfoclose():
	globals.hidetooltip()

func abilitytooltip(ability):
	var text = '[center]' + ability.name + '[/center]\n\n' + ability.description
	if partyselectedchar.abilityactive.has(ability.code):
		text += "\n\n[color=green]Ability active[/color]"
	else:
		text += "\n\nAbility inactive"
	globals.showtooltip(text)

func statinfo(stat):
	globals.showtooltip(globals.statsdescript[stat])

var partyselectedchar = null

func opencharacter(person, combat = false, combatant = null):
	partyselectedchar = person
	$playergrouppanel/characterinfo.popup()
	buildbars($playergrouppanel/characterinfo, person)
	for i in person.gear:
		$playergrouppanel/characterinfo.get_node(i).texture_normal = geardefaulticon[i]
		if person.gear[i] != null:
			var item = globals.state.unstackables[person.gear[i]]
			$playergrouppanel/characterinfo.get_node(i).texture_normal = globals.loadimage(item.icon)
	for i in $playergrouppanel/characterinfo/Container/GridContainer.get_children():
		if i.get_name() != 'Button':
			i.visible = false
			i.queue_free()
	for i in person.ability:
		var ability = globals.abilities.abilitydict[i]
		var newnode = $playergrouppanel/characterinfo/Container/GridContainer/Button.duplicate()
		$playergrouppanel/characterinfo/Container/GridContainer.add_child(newnode)
		newnode.visible = true
		newnode.texture_normal = ability.iconnorm
		newnode.texture_pressed = ability.icondisabled
		if !person.abilityactive.has(i):
			newnode.pressed = true
		newnode.connect("mouse_entered",self,'abilitytooltip',[ability])
		newnode.connect("mouse_exited",self,'iteminfoclose')
		newnode.connect("pressed", self, 'abilitytoggle', [i])
	for i in ['sstr','sagi','smaf','send']:
		$playergrouppanel/characterinfo/stats.get_node(i+'/Label').text = str(person[i]) + "/" +str(min(person.stats[globals.maxstatdict[i]], person.originvalue[person.origins]))
	$playergrouppanel/characterinfo/grade.texture = globals.gradeimages[person.origins]
	if person != globals.player:
		$playergrouppanel/characterinfo/spec.texture = globals.specimages[str(person.spec)]
	$playergrouppanel/characterinfo/grade.visible = person != globals.player
	$playergrouppanel/characterinfo/spec.visible = person != globals.player
	$playergrouppanel/characterinfo/switch.visible = combat
	$playergrouppanel/characterinfo/combstats.visible = combat
	$playergrouppanel/characterinfo/stats.visible = !combat
	###---Added by Expansion---### Movement Icons
	$playergrouppanel/characterinfo/movement.set_texture(globals.movementimages[str(globals.expansion.getMovementIcon(person))])
	$playergrouppanel/characterinfo/movement.visible = true
	###---End Expansion---###
	if combat == true:
		for i in ['attack','speed','armor','protection']:
			get_node("playergrouppanel/characterinfo/combstats/" + i + '/Label').text = str(combatant[i])
			if i == 'protection':
				get_node("playergrouppanel/characterinfo/combstats/" + i + '/Label').text += '%'

func abilitytoggle(ability):
	if !partyselectedchar.abilityactive.has(ability):
		partyselectedchar.abilityactive.append(ability)
	else:
		partyselectedchar.abilityactive.erase(ability)
	iteminfoclose()
	if get_parent().get_node('combat').is_visible_in_tree():
		var combatant = get_parent().get_node('combat').findcombatantfromslave(partyselectedchar)
		if combatant.actionpoints > 0:
			combatant.selectcombatant()
			combatant.buildabilities()

func _on_grade_mouse_entered():
	var text = ''
	for i in globals.originsarray:
		if i == partyselectedchar.origins:
			text += '[color=green] ' + i.capitalize() + '[/color]'
		else:
			text += i.capitalize()
		if i != 'noble':
			text += ' - '
	text += '\n\n' + globals.dictionary.getOriginDescription(partyselectedchar)
	globals.showtooltip(text)

func _on_spec_mouse_entered():
	var text
	if partyselectedchar.spec == null:
		text = "Specialization can provide special abilities and effects and can be trained at Slavers' Guild. "
	else:
		var spec = globals.jobs.specs[partyselectedchar.spec]
		text = "[center]" + spec.name + '[/center]\n'+ spec.descript + "\n[color=aqua]" +  spec.descriptbonus + '[/color]'
	globals.showtooltip(text)

func _on_grade_mouse_exited():
	globals.hidetooltip()

func _on_spec_mouse_exited():
	globals.hidetooltip()

func _on_movement_mouse_entered():
	var text
	if partyselectedchar.movement == 'walk':
		text = "[center][color=aqua]Normal Movement.[/color][/center]\n$name is walking around like normal."
	elif partyselectedchar.movement == 'fly':
		text = "[center][color=aqua]Will Fly until under 50 Energy[/color][/center]\n$name is currently flapping $his wings and hovering a foot or two off of the ground.\n\n[color=green]Attack and Speed increased by 125%\n[/color]"
	elif partyselectedchar.movement == 'crawl':
		text = "[center][color=red]Only able to Crawl.\nAttack and Speed Penalties in Combat.\nWill not Join the Party.\nUnable to work many jobs.[/color][/center]\n$name is currently crawling on the ground on all fours.\n\n"
	elif partyselectedchar.movement == 'none':
		text = "[center][color=red]Unable to Move.\nAttack and Speed Penalties in Combat.\nWill not Join the Party.\nUnable to work many jobs.[/color][/center]\n$name is currently unable to move at all. $He is currently completely incapacitated."
	else:
		text = "[center][color=red]Error[/color][/center]\n$name is somehow moving in an unnatural way. While interesting, you may want to report this to Aric on the itch.io forums or Discord. "

	#Give Reason for Crawling/Immobilized
	text += "\n\nReason for Movement: " + PoolStringArray(partyselectedchar.movementreasons).join("\n")

	globals.showtooltip( partyselectedchar.dictionary(text))

func _on_movement_mouse_exited():
	globals.hidetooltip()

func _on_closechar_pressed():
	$playergrouppanel/characterinfo.visible = false

func buildbars(parentnode, person):
	parentnode.get_node("name").text = person.name_short()
	parentnode.get_node("hp").value = (person.health/person.stats.health_max)*100
	parentnode.get_node("hp").hint_tooltip = "Health: " + str(person.health) + "/" + str(person.stats.health_max)
	parentnode.get_node("en").value = (float(person.energy)/person.stats.energy_max)*100
	parentnode.get_node("en").hint_tooltip = "Energy: " + str(round(person.energy)) + "/" + str(person.stats.energy_max)
	parentnode.get_node("portait").set_texture(globals.loadimage(person.imageportait))
	if parentnode.get_parent() == $playergrouppanel/VBoxContainer:
		parentnode.get_node("xp").value = person.xp
		parentnode.get_node("xp").hint_tooltip = "Experience: " + str(person.xp) + "/100"
		if person.xp == 100:
			parentnode.get_node("xp").tint_progress = Color(0.65,0.87,0.875,1)
		else:
			parentnode.get_node("xp").tint_progress = Color(0.3,0.74,0.75,1)
	if person != globals.player:
		parentnode.get_node("stress").visible = true
		parentnode.get_node("lust").visible = false
		parentnode.get_node("stress").value = (float(person.stress)/person.stats.stress_max)*100
		parentnode.get_node('stress').hint_tooltip = "Stress: " + str(floor(person.stress)) + "/100"
		#parentnode.get_node("lust").value = (float(person.lust)/person.stats.lust_max)*100

	else:
		parentnode.get_node("stress").visible = false
		parentnode.get_node("lust").visible = false

func town():
	main.get_node("explorationnode").zoneenter('wimborn')

func wimborn():
	gooutside()
	main.music_set('wimborn')
	get_node("charactersprite").visible = false
	get_parent().repeattweenanimate($charactersprite, 'stop')
	var array = [{name = "Visit the Mage's Order",function = 'mageorder'},{name = "Visit Slaver's Guild", function = 'slaveguild'},{name = "Visit Market District",function = 'market'},{name = "Visit Red Lantern District", function = 'backstreets'},{name = "Leave Town",function = 'outskirts'}]
	if globals.state.location == 'wimborn':
		array.append({name = "Return to Mansion",function = 'mansion'})
	###---Added by Expansion---### Towns Expanded
	var executions = globals.state.townsexpanded.wimborn.pendingexecution
	#Second Method, Currently Unused but opens options
	for npcs in globals.state.offscreennpcs:
		if npcs[1] == "wimborn" && npcs[3] == "condemned":
			executions.append(npcs[0])
	if !executions.empty():
		#text += "There seems to be a lot of commotion in the town today off near the City Dungeon."
		array.append({name = "Gathering in the Square", function = 'wimbornexecution', args = 'intro'})
	###---End Expansion---###
	buildbuttons(array)

###---Added by Expansion---### Towns Expanded
var executionmode = ''

func wimbornexecution(mode=''):
	main.background_set('wimborn')
	yield(main, 'animfinished')
	get_node("charactersprite").visible = false
	var executions = globals.state.townsexpanded.wimborn.pendingexecution
	var executiontypes = ['throatslit','stoning','beheading','hanging','burning','drowning','crucifixion']
	var executiontype = str(globals.randomitemfromarray(executiontypes))
	var text = ""
	var buttons = []
	var proceed = false

	#Eventually add Guard Captain and other as a full NPC to be captured/bartered with

	globals.player.npcexpanded.location = 'wimborn'

	if mode == 'intro':
		text += "There seems to be an execution scheduled for today. The crowd gets frantic as the doors to the city dungeon open and you see two guardsmen walk into the light carrying a chain between them. "
		if executions.size() == 1:
			text += "They jerk the chain forward and someone stumbles out of the darkened doorway to the jeers of the crowd. They look tattered and dirty from their capture and stay in the cells. They are dressed in rags and scraps of cloth that barely cover their body."
		else:
			text += "They jerk the chain forward and you see " +str(executions.size())+ " people start to stumble forward wearily. They look tattered and dirty from their capture and stay in the cells. They are dressed in rags and scraps of cloth that barely cover their bodies."
		text += "The guards pull the condemned onto the stage and one steps forward toward the crowd.\n\n[color=yellow]-By the authority invested in me by the citizens of Wimborn, I hearby sentence the following to death by " +executiontype+ ". \n"
		for npcid in executions:
			var npc = globals.state.findnpc(npcid)
			if npc == null:
				continue
			text += npc.dictionary("The $race $child, $name. \n[/color]Your skilled eyes can tell that that $name is level " + str(npc.level) + " and their appearance is " + str(npc.beauty) + "\n[color=yellow]")
		text += "\nMay whatever god you serve have mercy on your soul.[/color]\n\nThe executioner steps back from the podium towards the condemned. You realize that if you have any requests, now is the time to speak."
		if globals.state.reputation.wimborn <= 0:
			text += "\n\nYou do realize that it is very unlikely that they will listen to someone with your lack of reputation in regards to stopping an execution, however. You may be able to gain some reputation as being fiercely loyal to the law by suggesting a stronger punishment, if you can get the crowd behind you."
		executionmode = executiontype
		buttons = [{name = 'Just Observe', function = 'wimbornexecution', args = 'watch'},{name = 'Hold the Execution!', function = 'wimbornexecution', args = 'hold'},{name = str(executiontype).capitalize() + ' is too good for them!', function = 'wimbornexecution', args = 'changetype'}]
		buttons.append({name = 'Return to the Town Center', function = 'wimborn'})
	elif mode == 'hold':
		text += "The crowd seems to grow irritated by your interruption of their day's festivities. The guard wearily turns back toward you and cocks his eyebrow.\n\n[color=yellow]-What now? Who are you to stop an execution?[/color]"
		buttons = [{name = 'I am ' +str(globals.player.name_short())+ ' and I request custody.', function = 'wimbornexecution', args = 'offerrep'},{name = 'Merely a merchant. I would like to buy one of your wares from this good town.', function = 'wimbornexecution', args = 'offergold'},{name = 'Sorry, nevermind!', function = 'wimbornexecution', args = 'buyfinished'}]
	elif mode == 'offerrep':
		if globals.state.reputation.wimborn > 0:
			text += "The guard looks at the condemned, out at the crowd, and back at you.\n\n[color=yellow]-I see. I may have heard of you once or twice. Do you really want to sully your reputation by taking one of these scum and ruining these good citizen's event?[/color]"
			buttons.append({name = 'I will.', function = 'executionrepbuy', args = 'wimborn'})
			buttons.append({name = 'I suppose not.', function = 'wimbornexecution', args = 'refusebuy'})
		else:
			text += "The guard shrugs.\n\n[color=yellow]-I've never heard of you. And I definitely won't be releasing criminals into the hands of anyone I don't know.[/color]"
			proceed = true
	elif mode == "offergold":
		if globals.state.reputation.wimborn > 0:
			text += "The guard looks at the condemned, out at the crowd, and back at you.\n\n[color=yellow]-I see. I may have heard of you once or twice. Do you really want to sully your reputation and empty your pocket by taking one of these scum and ruining these good citizen's event?[/color]"
			buttons.append({name = 'I will.', function = 'executiongoldbuy', args = 'wimborn'})
			buttons.append({name = 'I suppose not.', function = 'wimbornexecution', args = 'refusebuy'})
		else:
			text += "The guard shrugs.\n\n[color=yellow]-I've never heard of you. And I definitely won't be releasing criminals into the hands of anyone I don't know.[/color]"
			proceed = true
	elif mode == 'refusebuy':
		text += "The guard looks at you and nods in a knowing, almost sympathetic way.\n\n[color=yellow]-Then we proceed.[/color]"
		proceed = true
	elif mode == 'buyfinished':
		text += "The guard sighs and nods.\n\n[color=yellow]-Good, that's done then. Shall we get to it then?[/color]\n\nThe crowd roars in excitement."
		proceed = true
	elif mode == 'changetype':
		text += "The crowd riles up behind you, voicing the same. The ravenous crowd has been incited by your words.\nThe guard turns back toward the crowd and sighs.\n\n[color=yellow]-We serve the citizens. What would be a fitting punishment?[/color]\n\nYou feel the eyes of the crowd resting on you. A harsher punishment will likely gain you reputation in their eyes.\n\n[color=red]Arics Note: This will likely be expanded in the future to have a kind or bloodthirsty town, with the player gaining reputation for matching their level of cruelty.[/color]"
		for type in executiontypes:
			if type == executiontype:
				continue
			buttons.append({name = str(type).capitalize() + " (Cruelty: " + str(executiontypes.find(type)) + ")", function = 'wimbornexecution', args = str(type)})
	elif mode == 'watch':
		executiontype = executionmode
		executionmode = ''
		proceed = true
	elif mode in executiontypes && proceed == false:
		if executiontypes.find(executiontype) < executiontypes.find(mode):
			executiontype = mode
			text += "The guard looks at his companion and shrugs.\n\n[color=yellow]-Is this your wish?\n\n[/color]The crowd roars their bloodthirsty agreement.\n\n[color=yellow]-So it shall be. The condemned will now be executed by " +str(executiontype).capitalize()+ " per the wishes of the people.[/color] "
			globals.state.reputation.wimborn += round(rand_range(1,5))
			text += "The crowd cheers and resumes their jeering at the condemned criminals. You seem to have gained some reputation in Wimborn for knowing how to please the crowd."
		else:
			text += "The guard looks at you and cocks an eyebrow.\n\n[color=yellow]-An easier death, is it? Do you all agree?[/color]\n\nThe crowd boos and you are even jostled by someone rudely.\nThe guard nods.\n\n[color=yellow]Then the condemned will die by " +str(executiontype).capitalize()+ " as decreed.[/color] "
			globals.state.reputation.wimborn -= round(rand_range(1,5))
			text += "You get several side-glances and overheard a few whispers of you being in league with the criminals and trying to help them. You seem to have lost some reputation in Wimborn for trying ruin their fun."
		proceed = true

	if proceed == true:
		#Setup
		if executiontype in ['throatslit','beheading','drowning']:
			text += "\n\nThe guard that has remained silent so far pushes the condemned onto their knees without mercy. "
		elif executiontype in ['hanging','crucifixion']:
			text += "\n\nThe guard that has remained silent so far grabs the condemned and leads them to a large, erected pole. "
		elif executiontype in ['stoning','burning']:
			text += "\n\nThe guard that has remained silent so far shoves the condemned towards the nearby small, erected pole and ties them firmly to it. "

		#Execution
		if executiontype == 'throatslit':
			text += "The guard then draws out a long, sharp knife from his belt. He walks around the condemned as they start to whimper, plead, beg, and scream for mercy. He takes the knife and presses it firmly against their neck before ripping it to the side. The crowd roars as the condemn's body falls twitching to the ground, blood spraying from its neck. "
		elif executiontype == 'stoning':
			text += "The guard then walks out toward the crowd with a large bucket filled with jagged rocks. The crowd eagerly grabs the rocks and begins pelting the condemned with the stones. Their screams are lost to the mirth of the crowd as the rocks batter and crush the criminal's flesh. "
		elif executiontype == 'beheading':
			text += "The guard walks beside the condemned and picks up a long, heavy battleaxe without any flourish. The condemned begin to whimper and scream for mercy, but the guard moves with the indifference of a man putting on his socks. He swings the axe up, then back down with a solid thud. The blood splatter sends the crowd into a maddening cheer. "
		elif executiontype == 'hanging':
			text += "The guard grabs the pre-tied nooses from the pole and slips it over the condemn's head. They begin to whimper and beg for mercy as the guard walks back to the pole and grabs the other end of the rope. They firmly tug, tightening the rope around the criminal's neck as their toes barely touch the ground. A few more heaves and they are fully dangling by their neck and gasping for air. "
			text += "The whole process is far more excruciating and drawn out than any gallows you've ever seen. The guard ties off the rope as their face begins to go purple and their kicking feet start to slow. "
			if rand_range(0,100) <= 50:
				text += "The condemn's eyes start bulging and they glance down in horror as they realize they have a steady stream of piss trickling from their legs that they have no control over. After a few more drawn out minutes, the kicking stops. "
		elif executiontype == 'burning':
			text += "The guard grabs a torch off of the nearby wall and quickly shoves it into the pile of wood at the pole's base. The condemned begins shouting for mercy, just a minute longer, and sobbing as the flames lick their legs. The flames crawl up them to a chorus of screams as the crowd looks on with cheerful smiles. "
		elif executiontype == 'drowning':
			text += "The guard grabs a large barrel and plops it down in front of the condemned. They try to pull back as he gracelessly slams their head into the bucket and fully submerges it. They struggle futile, but their chained arms and lack of oxygen makes it a futile fight. It isn't long until the bubbles stop rising to the surface and the guard releases the body, which makes no move to rise from the barrel. "
		elif executiontype == 'crucifixion':
			text += "The guard lowers the pole to the ground and ties them firmly to the beams with their arms outstretched. The convict attempts to pull away and is rewarded with an armored punch to the face and nails driven through their wrists. The cross is lifted back into place and their final days of watching over the town while stripped, naked, starving, and bleeding have begun. The crowd cheers and mostly disperses beyond the few who want to torment the criminal further. "

		for npcid in executions:
			var npc = globals.state.findnpc(npcid)
			npc.baddiedeath()

		globals.state.townsexpanded.wimborn.pendingexecution.clear()
		text += "\n\nWith the executions performed, the event is over and there is nothing remaining to be seen. "

		globals.state.townsexpanded.wimborn.dailyreport.text = "The executions slated for today have been concluded. "

		buttons.append({name = 'Return to the Town Center', function = 'wimborn'})
	mansion.maintext = text
	#QMod - New Event System
	if buttons.size() > 0:
		buildbuttons(buttons)

func executionrepbuy(location=''):
	main.background_set('wimborn')
	yield(main, 'animfinished')
	get_node("charactersprite").visible = false
	var text = ""
	var buttons = []
	var npc
	var reallocation = globals.player.npcexpanded.location
	var condemned = globals.state.townsexpanded[reallocation].pendingexecution

	if !str(location) in ['wimborn','frostford','amberguard','gorn']:
		npc = globals.state.findnpc(location)
		if npc != null:
			text += npc.dictionary("You point at $name and the guard shakes his head slowly. He walked over to the $race $child, separates his shackles from the chain, and brings them over to you.")
			globals.state.reputation[reallocation] -= round(rand_range(npc.level,npc.level+1))
			globals.state.townsexpanded[reallocation].pendingexecution.erase(location)
			npc.npcexpanded.enslavedby == str(reallocation).capitalize() + " Town Guards"
			globals.addrelations(npc, globals.player, round(rand_range(10,50)))
			globals.state.capturedgroup.append(npc)
			globals.state.allnpcs.erase(npc)
			for npcid in globals.state.offscreennpcs:
				if npcid[0] == location:
					globals.state.offscreennpcs.erase(npcid)
	if !condemned.empty():
		if globals.state.reputation[reallocation] > 0:
			text += "The guard steps aside, revealing the pitiful condemned trembling behind them.\n\n[color=yellow]-Take your pick, " +str(globals.player.name_long())+ ". Rescue your criminals.[/color] "
			for npcid in condemned:
				npc = globals.state.findnpc(npcid)
				if npc != null:
					buttons.append({name = npc.dictionary('I want the $race $child, $name'), function = 'executionrepbuy', args = npcid})
		else:
			text += "The guard steps in front of you, crossing his arms.\n\n[color=yellow]-No, " +str(globals.player.name_long())+ ". Your reputation will get you no more and no further in wasting our time.[/color] "
		buttons.append({name = 'Continue the Execution', function = str(reallocation)+'execution', args = 'buyfinished'})
	else:
		globals.state.townsexpanded[reallocation].pendingexecution.clear()
		text += "The guard sighs and the crowd mumbles and disperses.\n\n[color=yellow]That's all of them then. Move along.[/color]"
		buttons.append({name = 'Take your haul away.', function = 'wimborn'})
	mansion.maintext = text
	#QMod - New Event System
	if buttons.size() > 0:
		buildbuttons(buttons)

func executiongoldbuy(location=''):
	main.background_set('wimborn')
	yield(main, 'animfinished')
	get_node("charactersprite").visible = false
	var text = ""
	var buttons = []
	var reallocation = globals.player.npcexpanded.location
	var condemned = globals.state.townsexpanded[reallocation].pendingexecution
	var npc
	var price = 100

	if !str(location) in ['wimborn','frostford','amberguard','gorn']:
		npc = globals.state.findnpc(location)
		if npc != null:
			text += npc.dictionary("You point at $name and the guard shakes his head slowly. He walked over to the $race $child, separates his shackles from the chain, and brings them over to you. You hand him a pouch of " +str(price)+ " gold and hope you are not getting screwed over.")
			globals.state.reputation[reallocation] -= 1
			globals.resources.gold -= price
			npc.npcexpanded.enslavedby == str(reallocation).capitalize() + " Town Guards"
			globals.addrelations(npc, globals.player, round(rand_range(10,50)))
			globals.state.capturedgroup.append(npc)
			globals.state.allnpcs.erase(npc)
			globals.state.townsexpanded[reallocation].pendingexecution.erase(location)
			for npcid in globals.state.offscreennpcs:
				if npcid[0] == location:
					globals.state.offscreennpcs.erase(npcid)
	if !condemned.empty():
		if globals.state.reputation[reallocation] > 0 && globals.resources.gold >= price:
			text += "The guard steps aside, revealing the pitiful condemned trembling behind them.\n\n[color=yellow]-Take your pick, " +str(globals.player.name_long())+ ". Buy your criminals. "+str(price)+" each.[/color] "
			for npcid in condemned:
				npc = globals.state.findnpc(npcid)
				if npc != null:
					buttons.append({name = npc.dictionary('I want the $race $child, $name'), function = 'executiongoldbuy', args = npcid})
		else:
			text += "The guard steps in front of you, crossing his arms.\n\n[color=yellow]-No, " +str(globals.player.name_long())+ ". Your gold will get you no more and no further in wasting our time.[/color] "
		buttons.append({name = 'Continue the Execution', function = str(reallocation)+'execution', args = 'buyfinished'})
	else:
		globals.state.townsexpanded[reallocation].pendingexecution.clear()
		text += "The guard sighs and the crowd mumbles and disperses.\n\n[color=yellow]That's all of them then. Move along.[/color]"
		buttons.append({name = 'Take your haul away.', function = 'wimborn'})
	mansion.maintext = text
	#QMod - New Event System
	if buttons.size() > 0:
		buildbuttons(buttons)
###---End Expansion---###

func mansion():
	main._on_mansion_pressed()

func gooutside():
	globals.hidetooltip()
	get_node("playergrouppanel/VBoxContainer").visible = true
	main.checkplayergroup()
	get_parent().get_node("hideui").visible = true
	get_parent().get_node("ResourcePanel/menu").disabled = true
	get_parent().get_node("ResourcePanel/helpglossary").disabled = true
	main.get_node("Navigation").visible = false
	main.get_node('MainScreen').visible = false
	main.get_node("charlistcontrol").visible = false
	#main.get_node("ResourcePanel").visible = false
	self.visible = true
	$shoppanel.visible = false
	$shoppanel/inventory.visible = false
	playergrouppanel()
	if globals.state.tutorial.outside == false:
		main.get_node("tutorialnode").outside()

func outskirts():
	main.get_node("explorationnode").zoneenter('wimbornoutskirts')


############## person GUILD


func newslaveinguild(number, town = 'wimborn', raceadd = 'rand'): #ralph5 added 3rd entry: raceadd
	while number > 0:
		var racearray
		var race
		var origin
		var originpool
		if town == 'wimborn':
			racearray = ([[globals.getracebygroup("wimborn"),1],['Dark Elf', 1],['Tribal Elf', 1.5],['Elf', 2],['Human', 6]] if !globals.useRalphsTweaks else [[globals.getracebygroup("wimborn"),1],['Tribal Elf', 1],['Dark Elf', 1],['Elf', 4],['Human', 8]] )
		elif town == 'gorn':
			racearray = ([[globals.getracebygroup("gorn"),1],['Centaur', 1],['Human', 2],['Goblin', 2],['Orc', 5]] if !globals.useRalphsTweaks else [[globals.getracebygroup("gorn"),1],['Centaur', 1],['Human', 2],['Goblin', 4],['Orc', 6],['Dark Elf', 2]])
		elif town == 'frostford':
			racearray = ([[globals.getracebygroup("frostford"),1],['Human', 1.5],['Halfkin Wolf', 3],['Beastkin Wolf', 5]] if !globals.useRalphsTweaks else [[globals.getracebygroup("frostford"),1],['Human', 3],['Halfkin Wolf', 5],['Beastkin Wolf', 8],['Halfkin Cat', 5],['Halfkin Bunny', 1]])
		if town == 'umbra':
			racearray = [[globals.getracebygroup("active"),1]]
			originpool = [['noble', 1],['rich',2],['commoner',3], ['poor', 3], ['slave',1]]
		else:
			originpool = [['rich',1], ['commoner',3], ['poor', 6], ['slave', 6]]
		if raceadd != 'rand': #ralph
			if race in ['Beastkin Tanuki','Beastkin Fox','Beastkin Bunny','Beastkin Wolf','Beastkin Cat'] && rand_range(0,100) < 50:
				race = raceadd.replace('Beastkin','Halfkin')
			else:
				race = raceadd #/ralph
			origin = globals.weightedrandom(originpool)
		elif globals.rules.slaverguildallraces == true && globals.state.sandbox == true:
			race = globals.getracebygroup("active")
			originpool = ['slave','poor','commoner','rich','noble']
			origin = globals.randomfromarray(originpool)
		else:
			race = globals.weightedrandom(racearray)
			origin = globals.weightedrandom(originpool)
		var newslave = globals.newslave(race, 'random', 'random', origin)
		if town == 'umbra':
			newslave.obed = rand_range(0,80)
			if rand_range(0,100) >= 30:
				newslave.add_effect(globals.effectdict.captured)
		else:
			newslave.obed += 95
		newslave.fromguild = true
		globals.guildslaves[town].append(newslave)
		number -= 1


func setcharacter(text):
	get_parent().repeattweenanimate($charactersprite, 'stop')
	$charactersprite.visible = true
	if get_parent().spritedict.has(text):
		get_node("charactersprite").set_texture(get_parent().spritedict[text])
		if $charactersprite.modulate.a != 1:
			get_parent().nodeunfade($charactersprite, 0.3)

func marketsattext():
	if !globals.useRalphsTweaks:
		return ""
	#ralph5
	var sattext = ""
	var starttext = ""
	var endtext = ""
	var extrazero = ".0"
	var racetext
	var marketrate = 1
	sattext = "\nA Sign Board lists current relative pricing by race.\n\n[color=#d1b970]'Current Racial Pricing'[/color]\n"
	for i in globals.races:
		marketrate = round(globals.state.racemarketsat[i]*100)/100
		racetext = i.replace('Beastkin', '')
		if marketrate < 0.9:
			starttext = "[color=red]"
			endtext = "[/color]"
		elif marketrate >= 2.0:
			starttext = "[color=green]"
			endtext = "[/color]"
		else:
			starttext = "[color=yellow]"
			endtext = "[/color]"
		if !marketrate in [0,1,2,3,4,5,6,7,8,9,10]:
			sattext = sattext + "Price x " + starttext + str(marketrate) + endtext + " for [color=aqua]" + racetext + endtext + "\n"
		else:
			sattext = sattext + "Price x " + starttext + str(marketrate) + extrazero + endtext + " for [color=aqua]" + racetext + endtext + "\n"
	return sattext
		#print("Market pricing for " + str(i) + "'s increased by" + str(max(0.01,(1-globals.state.racemarketsat[i])*0.25)) + " from " + str(globals.state.racemarketsat[i]))
		#globals.state.racemarketsat[i] = clamp(globals.state.racemarketsat[i] + max(0.01,(1-globals.state.racemarketsat[i])*0.25),0.5,globals.races[i].pricemod) #under 1.0, recovers quickly toward 1 - over 1.0 increase 0.1 every 10 days
		#print("to " + str(globals.state.racemarketsat[i]) + "\n")
	#/ralph5

func slaveguild(guild = 'wimborn'):
	mindread = false
	var text = ''
	guildlocation = guild
	if guild == 'wimborn':
		slavearray = globals.guildslaves.wimborn
		if get_node("charactersprite").is_visible() == false || get_node("charactersprite").get_texture() != globals.spritedict.fairy:
			main.background_set('slaverguild')
			yield(main, 'animfinished')
			if globals.state.sidequests.maple < 7:
				setcharacter('fairy')
				#get_node("AnimationPlayer").play("spritemovefairy")
				get_parent().repeattweenanimate($charactersprite, 'fairy')
		clearselection()
		if globals.state.slaveguildvisited == 0:
			text += "The first time you enter through the doors of the town's central building, you are mildly surprised to find it it very clean and bright inside.  Arriving at the reception, a small cheerful fairy girl emerges from nearby to assist you.  Her friendly and somewhat whimsical looks make you realize she must be one of the main receptionists hired to drag in potential clients. \n\n[color=yellow]— Welcome $sir!  I do not believe I have see you here before, is this your first time?  I'm Maple.  You seem to be a respectable person!  If you will allow me, I shall help you get familiar with our establishment!\n\n— From our facilities here we can provide our clients with many affordable and obedient staff members.  Yes, the possession of another person is allowed as long as you have the right.  In your case, we received word of your arrival and your inborn talent to become a Mage grants you the right.  Despite civilization's progress, it is still very far from providing sufficient food and living conditions for everyone.  By selling themselves into the custody of another, many find a way to survive, pay their debts or help their family. \n\n— Sometimes we deal with so called 'prisoners of war' to help them to adapt to a life of servitude.  Don't you find this much more humane, giving them a new chance instead of outright slaughtering them?\n\n— This is where we come in.  Slaves give up a huge part of their freedom.  We take care to teach them to act appropriately, so you may be sure their initial behavior will be acceptable.  To strengthen your ownership we will gladly brand your purchase magically free of charge and attune the enchantment to you.  The slave brand makes your new asset physically incapable of harming its master.\n\n— After acquiring sentient property, you are free to employ them as you see fit, but keep in mind, that brutal treatment may cause you quite a few problems.  We strongly advise against unnecessary deaths and mutilations, nor we do support people harshly abusing their privileges over others. \n\n— Lastly, if you have possession of someone you no longer have a need for and wish to part with them, we can surely offer you something!\n\n— I hope, my explanation was helpful, $sir!  Let me know if there's something else I can assist you with![/color]" #ralphA - minor edits
			globals.state.slaveguildvisited = 1
			globals.charactergallery.maple.unlocked = true
		else:
			text += "You enter through the guild’s doors, and are greeted once again by the busy sights and sounds of customers, slaves, and workers shuffling around at blistering speeds. You give a polite bow to one of the receptionists and grab a pen to sign in. In few moments Maple appears before you.\n\n[color=yellow]— Ah, my pleasure, $name, how can I help you today?[/color] "
		var array = [{name = 'See slaves for sale', function = 'slaveguildslaves', args = 'wimborn'}, {name = 'Offer your servants',function = 'sellslavelist', args = 'wimborn'}, {name = 'See custom requests', function = 'slaveguildquests'},{name = 'Services for Slaves',function = 'slaveservice'},{name = 'Leave', function = 'town'}]
		if globals.state.sandbox == true && globals.state.sidequests.maple < 1: globals.state.sidequests.maple = 1
		if globals.state.mainquest == 3:
			array.insert(3, {name = "Ask about fairies", function = 'slaveguildfairy'})
		if globals.state.sidequests.maple in [1,3] && globals.state.reputation.wimborn >= 40:
			array.insert(3, {name = "Flirt with Maple", function = 'slaveguildfairy', args = 1})
		if globals.state.sidequests.maple == 6:
			array.insert(3, {name = "Take Maple into custody", function = 'slaveguildfairy', args = 5})
		if globals.state.sidequests.maple in [2,3,4,5,6]:
			text += "\n\nMaple gives you a playful, warm look."
		elif globals.state.sidequests.maple == 7:
			text = "You enter through the guild’s doors, and are greeted once again by the busy sights and sounds of customers, slaves, and workers shuffling around at blistering speeds. You give a polite bow to one of the receptionists and grab a pen to sign in."
		text = text + marketsattext() #ralph5
		mansion.maintext = globals.player.dictionary(text)
		buildbuttons(array)
	elif guild == 'gorn':
		clearselection()
		setcharacter('goblin')
		slavearray = globals.guildslaves.gorn
		mansion.maintext = globals.player.dictionaryplayer("A huge part of the supposed guild is taken up by a makeshift platform and tents with a few half-empty cages. In the middle, you can see a presentation podium which is easily observable from main street. Despite Gorn being very different from primarily human-populated towns, it still very much follows Mage Order directives — race diversity and casual slavery are omnipresent. \n\nAs you walk in, one of the goblin receptionists hastily grabs your attention, sensing a profitable customer.\n\n— $sir interested in some heat-tolerant 'orkers? *chuckles* Or you are in preference of short girls? We quite often get those as well, for every taste and color!" + marketsattext()) #ralph5
		var array = [{name = 'See slaves for sale',function = 'slaveguildslaves', args = 'gorn'}, {name = 'Offer your servants',function = 'sellslavelist', args = 'gorn'}, {name = 'See custom requests', function = 'slaveguildquests'},{name = 'Services for Slaves',function = 'slaveservice'}]
		#Old Event Hooks
		if globals.state.sidequests.emily in [14,15]:
			array.insert(1, {name = 'Search for Tisha', function = 'tishaquest'})

		array.append({name = 'Leave', function = 'togorn'})
		#QMod - New Event System
		if array.size() > 0:
			buildbuttons(array)
#
#		var place = {'region' : 'gorn', 'area' : 'slaveGuild', 'location' : 'lobby'}
#		var placeEffects
#		var buttonCount = array.size() #ToFix - Keep an eye on this, links old quest button and new quest button counts.
#
#		placeEffects = globals.events.call_events(place, 'trigger') #ToFix - Should a triggered event be able to create a 'hook' event as a follow-up?
#		if placeEffects.text != '':
#			text += '\n\n' + placeEffects.text
#
#		placeEffects = globals.events.call_events(place, 'hook', {source = self, function = 'slaveguild'})
#		if placeEffects.text != '':
#			text += '\n\n' + placeEffects.text
#		var buttons = placeEffects.buttons
#		if buttons.size() > 0:
#			buildbuttons(buttons, globals.events, false, buttonCount)
#			buttonCount += buttons.size()
		# - End New Event System

#
#		buildbuttons(array, self, false, buttonCount)
	elif guild == 'frostford':
		clearselection()
		setcharacter('frostfordslaver')
		slavearray = globals.guildslaves.frostford
		text = "A humble local guild building is bright and warm inside. Just as the whole of Frostford, this place is serene in its mood compared to what you are used to. "
		if globals.state.mainquest >= 2:
			text += "Realizing you belong to the Mage's Order, the attendant politely greets you and asks how she may assist you. "
		text = text + marketsattext() #ralph5
		mansion.maintext = globals.player.dictionaryplayer(text)
		var array = [{name = 'See slaves for sale',function = 'slaveguildslaves', args = 'frostford'},{name = 'Offer your servants',function = 'sellslavelist', args = 'frostford'}, {name = 'See custom requests', function = 'slaveguildquests'}, {name = 'Services for Slaves',function = 'slaveservice'}, {name = 'Leave', function = 'tofrostford'}]
		buildbuttons(array)
	get_node("playergrouppanel/VBoxContainer").visible = false
	if globals.spelldict.mindread.learned == false:
		get_node("slavebuypanel/mindreadbutton").visible = false
	else:
		get_node("slavebuypanel/mindreadbutton").visible = true

func slaveguildfairy(stage = 0):
	var text = ''
	var sprites
	var state = true
	var buttons = []
	var image
	if stage == 0:
		text = questtext.GuildFairyMainQuest
		globals.state.mainquest = 3.1
		globals.state.sidequests.maple = 1
		slaveguild()
		mansion.maintext = globals.player.dictionary(text)
		return
	elif stage == 1:
		if globals.player.penis == 'none':
			main.popup("This option requires player character to have a penis. ")
			return
		if globals.state.sidequests.maple == 1:
			sprites = [['fairy','pos1']]
			text = questtext.MapleFlirt
			image = 'maplebj'
			globals.state.sidequests.maple = 2
			globals.state.upcomingevents.append({code = 'mapletimepass', duration = 3})
			globals.charactergallery.maple.scenes[0].unlocked = true
			buttons.append({text = "Close", function = 'closescene'})
		elif globals.state.sidequests.maple == 3:
			sprites = [['fairynaked','pos1']]
			text = questtext.MapleFlirt2
			image = 'maplesex'
			globals.state.sidequests.maple = 4
			globals.charactergallery.maple.nakedunlocked = true
			globals.charactergallery.maple.scenes[1].unlocked = true
			buttons.append({text = "Close", function = 'closescene'})
		slaveguild()
	elif stage == 3:
		if globals.state.sidequests.maple == 4:
			if globals.resources.gold >= 7000:
				buttons.append({text = 'Purchase Contract',function = 'slaveguildfairy', args = 4})
			else:
				buttons.append({text = 'Purchase Contract',function = 'slaveguildfairy', args = 4, disabled = true})
			text = questtext.MapleAudience
			globals.state.sidequests.maple = 5
		elif globals.state.sidequests.maple == 5:
			text = questtext.MapleAudienceRepeat
			if globals.resources.gold >= 7000:
				buttons.append({text = 'Purchase Contract',function = 'slaveguildfairy', args = 4})
			else:
				buttons.append({text = 'Purchase Contract',function = 'slaveguildfairy', args = 4, disabled = true})
	elif stage == 4:
		text = questtext.MapleAudiencePurchase
		globals.state.sidequests.maple = 6
		globals.resources.gold -= 7000
	elif stage == 5:
		sprites = [['fairy','pos1']]
		text = questtext.MapleTake
		globals.state.sidequests.maple = 7
		globals.slaves = globals.characters.create("Maple")
		town()
		slaveguild()
	if image != null:
		globals.main.scene(globals.main, image, text, buttons)
	else:
		main.dialogue(state, self, globals.player.dictionary(text), buttons, sprites)

func togorn():
	get_parent().nodefade($charactersprite, 0.3)
	get_node("playergrouppanel/VBoxContainer").visible = true
	main.get_node("explorationnode").zoneenter('gorn')

func tofrostford():
	get_parent().nodefade($charactersprite, 0.3)
	get_node("playergrouppanel/VBoxContainer").visible = true
	main.get_node("explorationnode").zoneenter('frostford')

var selectedslave
var selectedslaveprice
var slavearray
var mindread = false
var guildlocation


func slaveguildslaves(location):
	guildlocation = location
	get_node("slavebuypanel").visible = true
	#ralph
	var cost = ceil(globals.spells.spellcost(globals.spelldict.mindread) * 1.5)
	get_node("slavebuypanel/mindreadbutton").text = "Use Mind Read (" +str(cost)+ ")"
	get_node("slavebuypanel/mindreadbutton").hint_tooltip = "Allows to see more information about all the slaves.\nCosts " +str(cost)+ " mana"
	#/ralph
	get_node("slavebuypanel/mindreadbutton").disabled = mindread == true || globals.spelldict.mindread.learned == false || globals.resources.mana < cost
	var slavelist = get_node("slavebuypanel/slavebuypanel/ScrollContainer/VBoxContainer")
	var slavebutton = get_node("slavebuypanel/slavebuypanel/ScrollContainer/VBoxContainer/slavebutton")
	for i in slavelist.get_children():
		if i != slavebutton:
			i.visible = false
			i.queue_free()
	for person in slavearray:
		var newbutton = slavebutton.duplicate()
		slavelist.add_child(newbutton)
		newbutton.visible = true
		newbutton.get_node('name').set_text(person.dictionary('$name, ')+ person.race)
		newbutton.get_node('age').set_text(person.age.capitalize())
		newbutton.get_node("grade").texture = globals.gradeimages[person.origins]
		newbutton.get_node("grade").connect("mouse_entered", globals, 'gradetooltip',[person])
		newbutton.get_node("grade").connect("mouse_exited",globals, 'hidetooltip')
		var price = max(person.buyprice()*0.8,50)
		if globals.state.reputation.has(location) && globals.state.reputation[location] <= -10 && location != 'umbra':
			price *= (10 - globals.state.reputation[location]) / 20.0
		if location == 'slavers':
			price = price * 0.5 + 50
		price = round(price)
		newbutton.set_meta('person', person)
		newbutton.get_node('price').set_text(str(price)+ ' gold')
		newbutton.set_meta('price', price)
		newbutton.get_node("sex").texture = globals.sexicon[person.sex]
		newbutton.get_node("sex").hint_tooltip = person.sex
		newbutton.connect('pressed',self,'selectslavebuy',[person])
	if location != 'slavers':
		mansion.maintext = 'You get a simple catalogue with currently present slaves available for purchase.'
	$slavebuypanel/statspanel.visible = false
	clearbuttons()

func selectslavebuy(person):
	var price = 0
	selectedslave = person
	for i in get_node("slavebuypanel/slavebuypanel/ScrollContainer/VBoxContainer").get_children():
		if i != get_node("slavebuypanel/slavebuypanel/ScrollContainer/VBoxContainer/slavebutton") && i.get_meta('person') == person:
			i.set_pressed(true)
			price = i.get_meta('price')
		else:
			i.set_pressed(false)
	var text = ''
	###---Added by Expansion---### Person Expanded
	globals.expansion.updatePerson(person)
	globals.expansion.quickStrip(person)
	###---End Expansion---###
	if person.effects.has('captured') == true:
		text += "During the examination $name only returned bold, angry look, showing $his [color=#ff4949]rebellious[/color] attitude. \n\n"
	elif person.obed < 40:
		text += "$name reacts to commands [color=#ff4949]poorly[/color] and does not seem to hold any enthusiasm about $his position. Perhaps $he will need an additional training...\n\n"
	###---Added by Expansion---### Genitals Expanded
	if person.vagvirgin == true && person.vagina != 'none':
		if person.obed >= 40:
			text += "After a gesture, $name reveals to you $his [color=aqua]virgin " +str(globals.expansion.getGenitals(person))+ "[/color] . \n\n"
		else:
			text += "With some assistance, $name is forced to demonstrate you $his [color=aqua]virgin " +str(globals.expansion.getGenitals(person))+ "[/color]. \n\n"
	elif person.vagina != 'none':
		if person.obed >= 40:
			text += "After a gesture, $name reveals to you $his [color=aqua]" +str(globals.expansion.getGenitals(person))+ "[/color]. \n\n"
		else:
			text += "With some assistance, $name is forced to demonstrate you $his [color=aqua]" +str(globals.expansion.getGenitals(person))+ "[/color]. \n\n"
	###---End Expansion---###
	text += "As you finish inspection, you are being reminded, that you can purchase $him for mere [color=yellow]"+str(price)+ " gold[/color].[/color] "
	mansion.maintext = person.descriptionsmall() + '\n\n[color=#ff5df8]'+ person.dictionary(text)
	if globals.resources.gold < price:
		get_node("slavebuypanel/purchasebutton").set_disabled(true)
	else:
		get_node("slavebuypanel/purchasebutton").set_disabled(false)
	get_node("slavebuypanel/statspanel").person = person
	get_node("slavebuypanel/statspanel").visible = true
	$slavebuypanel/statspanel/portrait.texture = globals.loadimage(person.imageportait)
	$slavebuypanel/statspanel/portrait.visible = $slavebuypanel/statspanel/portrait.texture != null
	selectedslaveprice = price
	if mindread == true:
		get_node("slavebuypanel/statspanel").mode = 'slaveadv'
	else:
		get_node("slavebuypanel/statspanel").mode = 'slavebase'
	get_node("slavebuypanel/statspanel").show()


func _on_mindreadbutton_pressed():
	var cost = ceil(globals.spells.spellcost(globals.spelldict.mindread) * 1.5)
	globals.resources.mana -= cost
	mindread = true
	get_node("slavebuypanel/mindreadbutton").disabled = true

	if selectedslave != null:
		selectslavebuy(selectedslave)


func selectslavesell(person, location):
	if location == 'sebastian':
		selectedslaveprice = round(person.sellprice(true)*0.7)
	elif location == 'umbra':
		selectedslaveprice = person.sellprice(true)
	else:
		selectedslaveprice = person.sellprice()
	selectedslave = person
	var text = ''
	text = 'After some time, you get an offer to sell this servant for [color=yellow]' + str(selectedslaveprice) + ' gold[/color]. '
	if selectedslave.fromguild == true:
		text += person.dictionary("\n\n[color=#ff4949]You won't get any upgrade points from selling this person as $he has been registered in the census.[/color]")
	elif !location in ['wimborn','gorn','frostford'] || (selectedslave.obed >= 80 && selectedslave.fromguild == false && selectedslave.effects.has('captured') == false):
		text += person.dictionary("\n\n[color=aqua]You will get upgrade points from selling this person here depending on $his grade.[/color]")
	else:
		text += person.dictionary("\n\n[color=#ff4949]You won't get any upgrade points from selling this person currently $he's too rebellious.[/color]")
	#get_node("slavesellpanel/slavedescription").set_bbcode(text)
	mansion.maintext = text
	get_node("slavesellpanel/slavesellbutton").set_disabled(false)

	for i in get_node("slavesellpanel/ScrollContainer/VBoxContainer").get_children():
		if i != get_node("slavesellpanel/ScrollContainer/VBoxContainer/slavebutton") && i.get_meta('person') == person:
			i.set_pressed(true)
		else:
			i.set_pressed(false)

func _on_slavelistcancel_pressed():
	get_node("slavebuypanel").visible = false
	clearselection()
	if guildlocation == 'slavers':
		get_parent().get_node("explorationnode").slaversenc(2)
		get_node("playergrouppanel/VBoxContainer").visible = true
	elif guildlocation == 'umbra':
		get_parent().get_node("explorationnode").zoneenter('umbra')
		get_node("playergrouppanel/VBoxContainer").visible = true
	else:
		slaveguild(guildlocation)

func _on_purchasebutton_pressed():
	globals.resources.gold -= selectedslaveprice

	if guildlocation == 'slavers':
		get_parent().get_node("explorationnode").captureeffect(selectedslave)
	else:
		globals.slaves = selectedslave
		main.popup('You pay ' + str(selectedslaveprice) + selectedslave.dictionary(" gold for $name. With that, guild's helper brands $him for you and $he's sent to your mansion. "))
		mansion.maintext = globals.player.dictionary("A finest choice, $sir. Anyone else caught your attention?")
		selectedslave.brand = 'basic'
		###---Added by Expansion---### Ank BugFix v4a
		if globals.state.relativesdata.has(selectedslave.id):
			globals.state.relativesdata[selectedslave.id].state = 'normal'
		###---End Expansion---###
	selectedslave.sleep = 'communal'
	slavearray.remove(slavearray.find(selectedslave))
	slaveguildslaves(guildlocation)
	clearselection('buy')

func _on_slavesellbutton_pressed():
	var upgradefromslave = false
	var text = ''
	var racepricemodchange = 0 #ralph5
	var racepricemod = 1 #ralph5
	globals.resources.gold += selectedslaveprice
	#ralph5
	racepricemod = globals.state.racemarketsat[selectedslave.race.replace('Halfkin', 'Beastkin')] #ralph5
	racepricemodchange = (racepricemod - 0.5)*0.1 #the bigger the premium the more the premium will be decreased
	racepricemod = clamp(racepricemod - racepricemodchange,0.5,5)
	globals.state.racemarketsat[selectedslave.race] = racepricemod
	#/ralph5
	if selectedslave.obed >= 80 && selectedslave.fromguild == false && selectedslave.effects.has('captured') == false:
		upgradefromslave = true
		###---Added by Expansion---###
		globals.expansion.updatePerson(selectedslave)
		if selectedslave.npcexpanded.mansionbred == true && globals.state.spec == 'Breeder':
			globals.resources.upgradepoints += round((globals.originsarray.find(selectedslave.origins)+1)*globals.expansionsettings.mansion_bred_and_breeder)
		elif selectedslave.npcexpanded.mansionbred == true:
			globals.resources.upgradepoints += round((globals.originsarray.find(selectedslave.origins)+1)*1.25)
		else:
			globals.resources.upgradepoints += globals.originsarray.find(selectedslave.origins)+1
		###---End Expansion---###
	elif guildlocation in ['sebastian','umbra'] && selectedslave.fromguild == false:
		upgradefromslave = true
		###---Added by Expansion---### Person Expanded / Breeder Specialty
		globals.expansion.updatePerson(selectedslave)
		if selectedslave.npcexpanded.mansionbred == true && globals.state.spec == 'Breeder':
			globals.resources.upgradepoints += round((globals.originsarray.find(selectedslave.origins)+1)*globals.expansionsettings.mansion_bred_and_breeder)
		elif selectedslave.npcexpanded.mansionbred == true:
			globals.resources.upgradepoints += round((globals.originsarray.find(selectedslave.origins)+1)*1.25)
		else:
			globals.resources.upgradepoints += globals.originsarray.find(selectedslave.origins)+1
		###---End Expansion---###
		if selectedslave.fromguild == false && (selectedslave.obed < 80 || selectedslave.effects.has('captured') == true):
			var reputationloss = [['wimborn',1],['gorn',1],['frostford',1],['amberguard',1]]
			###---Added by Expansion---### Hybrid Support
			if selectedslave.findRace(['Elf','Dark Elf','Tribal Elf']):
				reputationloss[3][1] += 12
			elif selectedslave.findRace(['Beastkin','Halfkin']):
				reputationloss[2][1] += 8
			elif selectedslave.findRace(['Orc','Goblin','Centaur']):
				reputationloss[1][1] += 10
			###---End Expansion---###
			reputationloss = globals.weightedrandom(reputationloss)
			globals.state.reputation[reputationloss] += globals.expansionsettings.reputation_loss
			text += "[color=yellow]Your reputation has suffered from this deal. [/color]\n"
	if globals.guildslaves.has(guildlocation):
		globals.guildslaves[guildlocation].append(selectedslave)
	selectedslave.removefrommansion()
	selectedslave.fromguild = true
	text += selectedslave.dictionary('You sell $name for ') + str(selectedslaveprice) + selectedslave.dictionary(" gold. ")
	if guildlocation != 'sebastian':
		text += selectedslave.dictionary("$He's taken away and put on sale for other customers. ")
	main.rebuild_slave_list()
	sellslavelist(guildlocation)
	clearselection('sell')
	mansion.maintext = text


func sellslavelist(location):
	guildlocation = location
	var text = 'Select a person you wish to sell. '
	if location in ['wimborn','gorn','frostford']:
		text += "You will receive Mansion Upgrade points if person haven't been registered before and is not rebellious."
	elif location in ['sebastian','umbra']:
		text = "[color=aqua]Selling slaves here will still provide upgrade points even if they are rebellious, but will lower your reputation. [/color]"
	mansion.maintext = text
	get_node("slavesellpanel").visible = true
	clearbuttons()
	var slavelist = get_node("slavesellpanel/ScrollContainer/VBoxContainer")
	var slavebutton = get_node("slavesellpanel/ScrollContainer/VBoxContainer/slavebutton")
	for i in slavelist.get_children():
		if i != slavebutton:
			i.visible = false
			i.queue_free()
	for person in globals.slaves:
		if person.away.duration == 0:
			var newbutton = slavebutton.duplicate()
			slavelist.add_child(newbutton)
			newbutton.visible = true
			newbutton.get_node("grade").texture = globals.gradeimages[person.origins]
			newbutton.get_node("grade").connect("mouse_entered", globals, 'gradetooltip',[person])
			newbutton.get_node("grade").connect("mouse_exited",globals, 'hidetooltip')

			newbutton.get_node("sex").texture = globals.sexicon[person.sex]
			newbutton.get_node("sex").hint_tooltip = person.sex
			newbutton.get_node('name').set_text(person.name_long())
			###---Added by Expansion---### Breeder Specialization
			if person.npcexpanded.mansionbred == true && globals.state.spec == 'Breeder':
				newbutton.get_node('name').hint_tooltip = person.name_long() + ', ' + person.race + ', ' + person.age + ', ' + globals.jobs.jobdict.get(person.work, {name=person.work.capitalize()}).name + '[color=aqua]Born in Mansion - x' + str(globals.expansionsettings.mansion_bred_and_breeder) + ' Gold/Upgrade Points[/color]' #ralph3
			elif person.npcexpanded.mansionbred == true:
				newbutton.get_node('name').hint_tooltip = person.name_long() + ', ' + person.race + ', ' + person.age + ', ' + globals.jobs.jobdict.get(person.work, {name=person.work.capitalize()}).name + '[color=aqua]Born in Mansion - +25% Gold/Upgrade Points[/color]'
			else:
				newbutton.get_node('name').hint_tooltip = person.name_long() + ', ' + person.race + ', ' + person.age + ', ' + globals.jobs.jobdict.get(person.work, {name=person.work.capitalize()}).name
			if location == 'sebastian':
				newbutton.get_node('price').set_text(str(round(person.sellprice(true)*0.7))+ ' gold')
			elif location == 'umbra':
				newbutton.get_node('price').set_text(str(person.sellprice(true))+ ' gold')
			else:
				newbutton.get_node('price').set_text(str(person.sellprice()) + ' gold')
			newbutton.set_meta('person', person)
			newbutton.connect('pressed',self,'selectslavesell',[person, location])
			###---End Expansion---###


func _on_slavesellcancel_pressed():
	get_node("slavesellpanel").visible = false
	clearselection()
	if guildlocation == 'umbra':
		get_parent().get_node("explorationnode").zoneenter('umbra')
		get_node("playergrouppanel/VBoxContainer").visible = true
	elif globals.guildslaves.has(guildlocation):
		slaveguild(guildlocation)
	elif guildlocation == 'sebastian':
		sebastian()

func clearselection(temp = ''):
	selectedslave = null
	selectedslaveprice = 0
	mansion.maintext = ''
	if temp == 'buy':
		if guildlocation == 'slavers':
			mansion.maintext = '[color=yellow]Purchased slave is added to your group. [/color]'
		else:
			mansion.maintext = '[color=yellow]Your newly purchased slave has been sent to your mansion. [/color]'
	elif temp == 'sell':
		mansion.maintext = "[color=yellow]You receive a nice purse of gold for your freshly sold servant. [/color]"
	get_node("slavebuypanel/purchasebutton").set_disabled(true)
	get_node("slavesellpanel/slavesellbutton").set_disabled(true)
	for i in get_node("slavebuypanel/slavebuypanel/ScrollContainer/VBoxContainer").get_children():
		i.set_pressed(false)
	for i in get_node("slavesellpanel/ScrollContainer/VBoxContainer").get_children():
		i.set_pressed(false)

var selectedquest
var offeredslave

func slaveguildquests():
	selectedquest = null
	var text
	clearbuttons()
	get_node("slaveguildquestpanel/questaccept").set_disabled(true)
	get_node("slaveguildquestpanel/questbrowse").visible = false
	get_node("slaveguildquestpanel/questcancel").visible = false
	mansion.maintext = ''
	text = "You walk to the Slaver Guild's request board.\n\n[color=yellow]Completing repeatable missions will earn you Mansion Upgrade points. [/color]"
	get_node("slaveguildquestpanel").visible = true
	var list = get_node("slaveguildquestpanel/ScrollContainer/VBoxContainer")
	var button = get_node("slaveguildquestpanel/ScrollContainer/VBoxContainer/questbutton")
	var questarray = []
	for i in list.get_children():
		if i != button:
			i.visible = false
			i.queue_free()
	questarray = globals.state.repeatables.get(guildlocation + 'slaveguild', [])
	for i in questarray:
		if i.taken == true:
			var fontcolor
			if i.difficulty == 'easy':
				fontcolor = Color(0,1,0,1)
			elif i.difficulty == 'medium':
				fontcolor = Color(1,1,0,1)
			elif i.difficulty == 'hard':
				fontcolor = Color(1,0,0,1)
			var newbutton = button.duplicate()
			list.add_child(newbutton)
			newbutton.visible = true
			newbutton.get_node("name").set_bbcode(i.shortdescription + ' — Taken')
			newbutton.get_node("reward").set_text(str(i.reward) + ' gold')
			newbutton.get_node("difficulty").set_text(i.difficulty.capitalize())
			newbutton.get_node("difficulty").set('custom_colors/font_color', fontcolor)
			newbutton.connect("pressed",self,'questbuttonpressed',[i])
			text = "[color=yellow]— Are you ready to fulfil your task? Your reward will be waiting. [/color]"
			mansion.maintext = text
			return
	for i in questarray:
		var fontcolor
		if i.difficulty == 'easy':
			fontcolor = Color(0,1,0,1)
		elif i.difficulty == 'medium':
			fontcolor = Color(1,1,0,1)
		elif i.difficulty == 'hard':
			fontcolor = Color(1,0,0,1)
		var newbutton = button.duplicate()
		list.add_child(newbutton)
		newbutton.visible = true
		newbutton.get_node("name").set_bbcode(i.shortdescription)
		newbutton.set_meta('quest', i)
		newbutton.get_node("reward").set_text(str(i.reward) + ' gold')
		newbutton.get_node("difficulty").set_text(i.difficulty.capitalize())
		newbutton.get_node("difficulty").set('custom_colors/font_color', fontcolor)
		newbutton.connect("pressed",self,'questbuttonpressed',[i])
	mansion.maintext = text

func _on_questhide_pressed():
	get_node("slaveguildquestpanel").visible = false
	slaveguild(guildlocation)

func questbuttonpressed(quest):
	mansion.maintext = slavequesttext(quest)

func _on_questcancel_pressed():
	main.yesnopopup("Cancel this quest?", 'removequest', self)


func removequest():
	for i in globals.state.repeatables:
		for ii in globals.state.repeatables[i]:
			if ii == selectedquest:
				globals.state.repeatables[i].remove(globals.state.repeatables[i].find(ii))
	slaveguildquests()

func _on_questbrowse_pressed():
	if selectedquest.taken:
		main.selectslavelist(true, 'slaveforquestselected', self)

func _on_questaccept_pressed():
	if selectedquest.taken == false:
		selectedquest.taken = true
		slaveguildquests()
		mansion.maintext = "You sign under the request and take a copy of it."
	else:
		if get_node("slaveguildquestpanel/questaccept").get_text() == 'Turn in':
			main.popup(offeredslave.dictionary('You hand away $name and receive your reward. \n[color=yellow]You have gained ' + str(selectedquest.reward/10) + ' XP.[/color]\n\n[color=green]Your reputation with ' + guildlocation.capitalize() + " has increased.[/color]"))
			###---Added by Expansion---### Ank BugFix v4a
			offeredslave.removefrommansion()
			###---End Expansion---###
			selectedquest.taken = false
			globals.player.xp += selectedquest.reward/10
			globals.resources.gold += selectedquest.reward
			if selectedquest.difficulty == 'easy':
				globals.state.reputation[guildlocation] += 3
				globals.resources.upgradepoints += 3
			elif selectedquest.difficulty == 'medium':
				globals.state.reputation[guildlocation] += 5
				globals.resources.upgradepoints += 6
			elif selectedquest.difficulty == 'hard':
				globals.state.reputation[guildlocation] += 10
				globals.resources.upgradepoints += 10
			removequest()
		else:
			var array = []
			for person in globals.slaves:
				if person.away.duration != 0:
					continue
				if checkQuestOnPersonTextless(selectedquest, person):
					array.append(person)
			main.showChoosePerson(array, 'slaveforquestselected', self)

func slaveforquestselected(person):
	var result = checkQuestOnPerson(selectedquest, person)
	if result[0]:
		mansion.maintext = "There seems to be no problems with needed requirements.\n\n" + result[1]
		get_node("slaveguildquestpanel/questaccept").set_text("Turn in")
		offeredslave = person
	else:
		mansion.maintext = person.dictionary("$name does not meet all the requirements.\n\n") + result[1]
		get_node("slaveguildquestpanel/questaccept").set_text('Offer match')
		offeredslave = null

func checkQuestOnPerson(quest, person):
	var slavefits = true
	var textPool = PoolStringArray()
	for req in quest.reqs:
		if checkReqOnPerson(req, person):
			textPool.append( '[color=green][Pass]  ' + slaveReqText(req) + '[/color]')
		else:
			slavefits = false
			textPool.append( '[color=#ff4949][Fail]     ' + slaveReqText(req) + '[/color]')
	for i in quest.get('reqsfunc', []):
		if globals.repeatables.call(i, person):
			textPool.append( '[color=green][Pass]  ' + globals.repeatables.reqsfuncdescript[i] + '[/color]')
		else:
			slavefits = false
			textPool.append( '[color=#ff4949][Fail]     ' + globals.repeatables.reqsfuncdescript[i] + '[/color]')
	return [slavefits, textPool.join('')]

func checkQuestOnPersonTextless(quest, person):
	for req in quest.reqs:
		if !checkReqOnPerson(req, person):
			return false
	for i in quest.get('reqsfunc', []):
		if !globals.repeatables.call(i, person):
			return false
	return true

# reqs are case sensitive
func checkReqOnPerson(req, person):
	var ref1 = person
	for j in req[0].split('.'):
		ref1 = ref1[j]
	var ref2 = req[2]
	match req[0]:
		###---Added by Expansion---### Person Expanded
		'hairlength':
			ref1 = globals.hairlengtharray.find(person.hairlength)
		'titssize':
			ref1 = globals.titssizearray.find(person.titssize)
		'penis':
			ref1 = globals.penissizearray.find(person.penis)
		'origins':
			ref1 = globals.originsarray.find(person.origins)
			ref2 = globals.originsarray.find(ref2)
		###---End Expansion---###
	###---Added by Expansion---### Ank BugFix v4a
	if typeof(ref1) == TYPE_STRING && typeof(ref2) == TYPE_STRING:
		ref1 = ref1.to_lower()
		ref2 = ref2.to_lower()
	###---End Expansion---###
	match req[1]:
		'gte':
			return ref1 >= ref2
		'eq':
			return ref1 == ref2
		'neq':
			return ref1 != ref2
		'lte':
			return ref1 <= ref2
		'has': # can be used for single value in arrays or partial value of strings
			return ref1.find(ref2) != -1
		'nhas': # can be used for single value in arrays or partial value of strings
			return ref1.find(ref2) == -1
		'any': # used for intersection of 2 arrays
			return getIntersectionCount(ref1, ref2) > 0
		'all': # used for intersection of 2 arrays
			return getIntersectionCount(ref1, ref2) == ref2.size()
		'none':
			return getIntersectionCount(ref1, ref2) == 0
	globals.printErrorCode("unrecognized req op")
	return false

func getIntersectionCount(array1, array2):
	var count = 0
	for i in array1:
		if array2.has(i):
			count += 1
	return count


var repeatablesdict = {
	'sstr' : "Strength", 'sagi' : "Agility", 'smaf' : "Magic Affinity", 'send' : "Endurance",
	'cour' : "Courage", 'conf' : "Confidence", 'wit' : "Wit", 'charm' : "Charm",
	'obed' : "Obedience", 'loyal' : "Loyalty", 'asser' : "Role Preference", 'lewdness' : "Lewdness",
	'race' : "Race", 'age' : "Age", 'sex' : "Sex", 'origins' : "Grade", 'beauty': "Beauty",
	'level' : "Level", 'traits' : "Traits", 'spec' : "Specialization", 'ability' : "Ability",
	'hairlength' : "Hair Length", 'haircolor' : "Hair Color", 'eyecolor' : "Eye Color",
	'bodyshape' : "Body Type", 'titssize' : "Breast Size", 'penis' : "Penis Size",
	'lactation' : "Lactating", 'titsextradeveloped' : "Developed Extra Nipples into Tits",
	'titsextra' : "Additional Rows of Tits", 'vagvirgin' : "Virgin", "race_display":"Race",
}

func slavequesttext(quest):
	var text = ''
	var sex = ''
	var race = ''
	var text2 = ''
	get_node("slaveguildquestpanel/questaccept").set_disabled(false)
	selectedquest = quest
	for i in get_node("slaveguildquestpanel/ScrollContainer/VBoxContainer").get_children():
		if i.has_meta("quest") && i.get_meta('quest') != quest:
			i.set_pressed(false)
	for req in quest.reqs:
		text2 += slaveReqText(req)
		if req[0] == 'sex':
			sex = req[2]
		elif req[0] == 'race':
			race = req[2]
	if quest.has('reqsfunc'):
		for i in quest.reqsfunc:
			text2 += globals.repeatables.reqsfuncdescript[i]

	if quest.description.find('$sex')>= 0:
		quest.description = quest.description.replace("$sex",sex)
	if quest.description.find('$race')>= 0:
		quest.description = quest.description.replace("$race",race)
	if quest.description.find('$him') >= 0:
		quest.description = quest.description.replace("$him",him(sex))
	if quest.taken == true:
		get_node("slaveguildquestpanel/questbrowse").visible = true
		get_node("slaveguildquestpanel/questcancel").visible = true
		get_node("slaveguildquestpanel/questaccept").set_text('Offer match')
	else:
		get_node("slaveguildquestpanel/questbrowse").visible = false
		get_node("slaveguildquestpanel/questcancel").visible = false
		get_node("slaveguildquestpanel/questaccept").set_text('Accept')
	text = quest.description
	text = text + '\n\nRequired Slave Specifics:\n' + text2 + '\n[color=yellow]Reward: ' + str(quest.reward) + ' gold.[/color] [color=aqua]Time Limit: ' + str(quest.time) + ' days.[/color]'
	return text

var reqTextOpStart = {'neq': 'Not ', 'has': 'Has ', 'nhas': 'Does not have ', 'any': 'Any of these: ', 'all': 'All of these: ', 'none': 'None of these: '}
var reqTextOpEnd = {'gte' : ' or higher\n', 'lte' : ' or lower\n'}

func slaveReqText(req):
	var text = repeatablesdict[req[0]] + ' — ' + reqTextOpStart.get( req[1], '')
	var text2
	if typeof(req[2]) == TYPE_ARRAY:
		text2 = PoolStringArray()
		for val in req[2]:
			text2.append( getReqValText(req[0], val) )
		text2 = text2.join(', ')
	else:
		text2 = getReqValText(req[0], req[2])
	return text + text2 + reqTextOpEnd.get( req[1], '\n')

func getReqValText(reqType, reqVal):
#	if req[0].find('skills') >= 0:
#		text = repeatablesdict[req[0]] + ' — '+ text + globals.player.skill_level(req[2])
	match reqType:
		'hairlength':
			return str(globals.hairlengtharray[reqVal]).capitalize()
		###---Added by Expansion---### Person Expanded
		'titssize':
			return str(globals.titssizearray[reqVal]).replace('huge','giant').capitalize()
		'penis':
			return str(globals.penissizearray[reqVal]).capitalize()
		###---End Expansion---###
		'spec':
			return str(globals.jobs.specs[reqVal].name)
		'ability':
			return str(globals.abilities.abilitydict[reqVal].name)
		_:
			return str(reqVal).capitalize()

var slaveserviceselected
var serviceoperation

func him(sex):
	if sex == 'male':
		return 'him'
	else:
		return 'her'

func slaveservice():
	clearbuttons()
	mansion.maintext = ''
	get_node("slaveservicepanel/hairlengthbutton").visible = false
	get_node("slaveservicepanel").visible = true
	serviceselected()

func serviceselected(person = null):
	var list = get_node("slaveservicepanel/ScrollContainer/VBoxContainer")
	var button = get_node("slaveservicepanel/ScrollContainer/VBoxContainer/Button")
	var newbutton
	var array = []
	get_node("slaveservicepanel/speccontainer").visible = false
	for i in list.get_children():
		if i != button:
			i.visible = false
			i.queue_free()
	if person == null:
		slaveserviceselected = null
		get_node("slaveservicepanel/selectslavebutton").set_text('Select person')
		get_node("slaveservicepanel/serviceconfirm").set_disabled(true)
		mansion.maintext = 'Slave service allows you to perform many special, important operations with your servants. Select servant, then choose desired action. \n\n[color=yellow]This will cost money and likely withdraw servant for a time. Choose operation for further information.[/color]'
	else:
		slaveserviceselected = person
		get_node("slaveservicepanel/selectslavebutton").set_text('Deselect')
		for i in operationdict.values():
			array.append(i)
		array.sort_custom(globals, 'sortbynumber')
		for i in array:
			globals.currentslave = slaveserviceselected
			if globals.evaluate(i.reqs) == true:
				var price = i.price
				newbutton = button.duplicate()
				list.add_child(newbutton)
				newbutton.visible = true
				newbutton.set_text(i.name)
				newbutton.set_meta('operation', i.code)
				if i.code == 'uprise':
					price = 100 * (globals.originsarray.find(person.origins)+1)
				newbutton.get_node("price").set_text(str(price))
				newbutton.connect("pressed",self,'operationselected',[i.code])

func _on_selectslavebutton_pressed():
	if get_node("slaveservicepanel/selectslavebutton").get_text() == 'Select person':
		main.selectslavelist(true, 'serviceselected', self)
	else:
		serviceoperation = null
		serviceselected()

func operationselected(operation):
	serviceoperation = operation
	var person = slaveserviceselected
	var text = ''
	var price = operationdict[operation].price
	for i in get_node("slaveservicepanel/ScrollContainer/VBoxContainer").get_children():
		if i.is_pressed() == true && i.get_meta("operation") != operation:
			i.set_pressed(false)
	get_node("slaveservicepanel/speccontainer").visible = false
	for i in get_node("slaveservicepanel/speccontainer/VBoxContainer").get_children():
		if i != get_node("slaveservicepanel/speccontainer/VBoxContainer/Button"):
			i.visible = false
			i.queue_free()
	text = slaveserviceselected.dictionary(operationdict[operation].description)

	if operation == 'nurture':
		text += '\nRequired time: 5 days.'
	elif operation == 'uprise':
		price = 100 * (globals.originsarray.find(person.origins)+1)
		text += person.dictionary("\n\n$name's grade will become [color=aqua]") + globals.originsarray[globals.originsarray.find(person.origins)+1].capitalize() + "[/color]. Required time: " + str(globals.originsarray.find(person.origins)+2) + " days."
	elif operation == 'subjugate':
		text += person.dictionary("\n\n$name's grade will become [color=aqua]") + globals.originsarray[globals.originsarray.find(person.origins)-1].capitalize() + "[/color]. Required time: 1 day"
	elif operation == 'spec':
		var array = []
		for i in globals.jobs.specs.values():
			array.append(i)
		array.sort_custom(globals, 'sortbyname')
		get_node("slaveservicepanel/speccontainer").visible = true

		for i in array:
			var newbutton = get_node("slaveservicepanel/speccontainer/VBoxContainer/Button").duplicate()
			get_node("slaveservicepanel/speccontainer/VBoxContainer").add_child(newbutton)
			newbutton.visible = true
			newbutton.set_text(i.name)
			newbutton.set_meta("spec", i)
			newbutton.connect("pressed",self,'specchosen',[newbutton])


	text += '\n\n[color=yellow]Price: '+ str(price) + ' gold[/color]'

	if globals.resources.gold >= price && operation != 'spec':
		get_node("slaveservicepanel/serviceconfirm").set_disabled(false)
	else:
		get_node("slaveservicepanel/serviceconfirm").set_disabled(true)
	if operation == 'haircut':
		get_node("slaveservicepanel/hairlengthbutton").visible = true
		get_node("slaveservicepanel/hairlengthbutton").clear()
		for i in globals.hairlengtharray:
			if globals.hairlengtharray.find(slaveserviceselected.hairlength) > globals.hairlengtharray.find(i):
				get_node("slaveservicepanel/hairlengthbutton").add_item(i.capitalize()+' length')
	else:
		get_node("slaveservicepanel/hairlengthbutton").visible = false
	mansion.maintext = text


func _on_serviceconfirm_pressed():
	var person = slaveserviceselected
	var operation = operationdict[serviceoperation]
	var text = person.dictionary(operation.confirm)
	if operation.code == 'abortion':
		person.abortion()
		person.stress += rand_range(35,70)
		person.health -= 20
		globals.resources.gold -= operation.price
	elif operation.code == 'sterilize':
		person.preg.has_womb = false
		person.stress += rand_range(30,50)
		person.health -= 15
		globals.resources.gold -= operation.price
	elif operation.code == 'nurture':
		person.trait_remove('Regressed')
		person.away.duration = 5
		person.away.at = 'nurture'
		globals.resources.gold -= operation.price
	elif operation.code == 'haircut':
		var hairlength = get_node("slaveservicepanel/hairlengthbutton").get_item_text(get_node("slaveservicepanel/hairlengthbutton").get_selected())
		hairlength = hairlength.replace(' length', '')
		hairlength = globals.decapitalize(hairlength)
		person.hairlength = hairlength
		globals.resources.gold -= operation.price
	elif operation.code == 'subjugate':
		if person.origins == 'poor':
			person.stats.obed_mod += 0.25
		elif person.origins in ['rich','noble']:
			person.stats.obed_mod += 0.2
		person.origins = globals.originsarray[globals.originsarray.find(person.origins)-1]
		person.away.duration = 1
		person.away.at = 'training'
		globals.resources.gold -= operation.price
	elif operation.code == 'uprise':
		if person.origins == 'slave':
			person.stats.obed_mod -= 0.25
		elif person.origins in ['commoner','rich']:
			person.stats.obed_mod -= 0.2
		globals.resources.gold -= operation.price * (globals.originsarray.find(person.origins)+1)
		person.origins = globals.originsarray[globals.originsarray.find(person.origins)+1]
		if person.levelupreqs.has('code') && person.levelupreqs.code == 'improvegrade':
			person.levelup()
		person.away.duration = 1 + globals.originsarray.find(person.origins)
		person.away.at = 'training'
	elif operation.code == 'spec':
		if person.levelupreqs.has('code') && person.levelupreqs.code == 'specialization':
			person.levelup()
		globals.resources.gold -= 500
		if person.effects.has('bodyguardeffect'): person.add_effect(globals.effectdict.bodyguardeffect, true)
		person.spec = get_node("slaveservicepanel/serviceconfirm").get_meta('spec').code
		if person.spec == 'bodyguard': person.add_effect(globals.effectdict.bodyguardeffect)
		person.away.duration = 5
		person.away.at = 'training'
	slaveserviceselected = null
	serviceoperation = null
	slaveservice()
	main.popup(text)

func _on_slaveservicecancel_pressed():
	get_node("slaveservicepanel").visible = false
	slaveguild(guildlocation)

func specchosen(button):
	for i in get_tree().get_nodes_in_group('specsbutton'):
		if i != button:
			i.set_pressed(false)
	var spec = button.get_meta('spec')
	var text = "[center]" + spec.name + '[/center]\n' + spec.descript + "\nBonus: [color=aqua]" + spec.descriptbonus + "[/color]\n\nRequirements: [color=yellow]" + spec.descriptreqs + "[/color]\n\nCost: 500 gold.\nDuration: 5 days."
	mansion.maintext = text
	globals.currentslave = slaveserviceselected
	if globals.resources.gold >= 500 && globals.evaluate(spec.reqs) == true:
		get_node("slaveservicepanel/serviceconfirm").set_disabled(false)
		get_node("slaveservicepanel/serviceconfirm").set_meta('spec', spec)
	else:
		get_node("slaveservicepanel/serviceconfirm").set_disabled(true)

var operationdict = {
	haircut = {
		code = 'haircut',
		name = 'Cut Hair',
		number = 1,
		reqs = "person.hairlength != 'ear'",
		description = "[color=yellow]Simplest procedure to trim your servant's hair. [/color]",
		price = 25,
		confirm = "You leave $name in the custody of guild's barber. Later $he returns with shorter hair."
	},
	abortion = {
		code = 'abortion',
		name = 'Commit Abortion',
		number = 2,
		reqs = "person.preg.duration >= globals.state.pregduration/6",
		description = "[color=yellow]Stops pregnancy. [/color] ",
		price = 75,
		confirm = "You leave $name in the custody of guild's specialists. As $his pregnancy ends, you can notice how $name looks considerably more stressed."
	},
	sterilize = {
		code = 'sterilize',
		name = 'Sterilize',
		number = 2,
		reqs = "person.preg.has_womb == true && globals.currentslave.preg.duration == 0",
		description = "[color=yellow]Prevents new pregnancies. [/color]\n\n[color=#ff4949]This operation is difficult to reverse![/color]",
		price = 125,
		confirm = "After the operation $name becomes sterile. $He won't be able to carry any more children. "
	},
	nurture = {
		code = 'nurture',
		name = 'Nurture',
		number = 3,
		reqs = "person.traits.find('Regressed') >= 0",
		description = "[color=yellow]This option will neutralize Regressed trait.[/color]",
		price = 150,
		confirm = "You leave $name in the custody of guild trainers, who will train $him among other slaves and prepare for your domain."
	},
	uprise = {
		code = 'uprise',
		name = 'Elevate',
		number = 4,
		reqs = "person.origins != 'noble'",
		description = "[color=yellow]This option will raise servant's grade, but also will make them more demanding. [/color]",
		price = 100,
		confirm = "You leave $name in the custody of guild trainers, who will help $him raising $his self-esteem. ",
	},
	subjugate = {
		code = 'subjugate',
		name = 'Demote',
		number = 5,
		reqs = "person.origins != 'slave'",
		description = "[color=yellow]This option will lower servant's grade. [/color]",
		price = 50,
		confirm = "You leave $name in the custody of guild trainers, who will accustom $him to the less luxurious life. ",
	},
	spec = {
		code = "spec",
		name = "Specialization",
		number = 6,
		reqs = 'true',
		description = "[color=yellow]Teach servant a new specialization. Only one specialization can be learned per servant. [/color]",
		price = 500,
		confirm = "You leave $name in the custody of guild trainers, who will teach $him a new specialization."
	},
}

###############MAGE GUILD

func mageorder():
	main.background_set('mageorder')
	if OS.get_name() != "HTML5":
		yield(main, 'animfinished')
	var array = []
	if globals.state.mainquest in [40,41]:
		globals.events.orderfinale()
		return
	mansion.maintext = "This massive building takes a large part of the street. The Wimborn's Mage's Order is the centerpiece of your career achievements. Here you'll be able to buy necessary equipment and learn spells, assuming you are part of it of course."
	clearbuttons()
	#Old Event hooks
	#Main Quest
	if globals.state.mainquest <= 1:
		array.append({name = 'Seek Audience', function = 'mageorderquest1'})
	elif globals.state.mainquest == 2:
		array.append({name = 'Consult on further promotions',function = 'mageorderquest1'})
	elif globals.state.mainquest >= 3 && globals.state.mainquest < 40 && globals.state.mainquestcomplete != true:
		array.append({name = 'Find Melissa', function = 'mageorderquest1'})
	if globals.state.mainquest == 27:
		array.append({name = "Teleport to Capital", function = 'capitalteleport'})

	#Non-Quest Mage Order Spell Store
	if globals.state.rank >= 1:
		array.append({name = 'Purchase New Spells',function = 'mageservices'})

	#Sidequest
	if globals.state.sidequests.emily == 12:
		array.append({name = "Visit Tisha's workplace", function = "tishaquest"})
	if globals.state.sidequests.maple in [4,5]:
		array.append({name = "Audience Slaver Guild Host", function = 'slaveguildfairy', args = 3})

	array.append({name = 'Return to city',function = 'town'})
	buildbuttons(array, self, false)

	#QMod - New Event System
#	if array.size() > 0:
#		buildbuttons(array)
#
#	var place = {'region' : 'wimborn', 'area' : 'mageOrder', 'location' : 'lobby'} #Even though 'MageOrder' is in 'WimbornCity', area = 'MageOrder', because it is a potential multi-location spot.  Rule of thumb - outdoor city areas = 'wimbornCity'
#	var placeEffects
#	var buttonCount = array.size() #ToFix - Keep an eye on this, links old quest button and new quest button counts.
#	var text = ''
#
#	placeEffects = globals.events.call_events(place, 'trigger')
#	if placeEffects.text != '':
#		text += '\n\n' + placeEffects.text
#
#	placeEffects = globals.events.call_events(place, 'hook', {source = self, function = 'mageorder'})
#	if placeEffects.text != '':
#		text += '\n\n' + placeEffects.text
#	var buttons = placeEffects.buttons
#	if buttons.size() > 0:
#		buildbuttons(buttons, globals.events, false, buttonCount)
#		buttonCount += buttons.size()
#	# - End Event System
#
#

func capitalteleport():
	var buttons = []
	var text = ''
	var state = true
	var sprites = null
	if globals.state.mainquest == 27:
		text = questtext.MainQuestFrostfordMainOrder
		globals.state.mainquest = 28

	main.dialogue(state, self, text, buttons, sprites, 'mainorder')
	mageorder()


func mageorderquest1(person = null):
	var buttons = []
	var text = ''
	var state = true
	var sprites = null
	questgiveawayslave = person
	if globals.state.mainquest == 0:
		sprites = [['chancellor','pos1','opac']]
		globals.state.mainquest = 1
		text = ("After some time you find a chancellor: a senior member responsible for accepting new applicants. You give a small knock to announce your presence, and the old man looks up from his paperwork with a sneer. You begin to introduce yourself, but he raises a hand to stop you.\n\n— Yes, yes, I already know who you are. You’ve been a hot topic these past few days, a trend that shall die soon, I’m sure. Allow me to hazard a guess, now that you’ve inherited that senile fool’s mansion, you’re here to apply for membership, correct? Well, I’ll have you know that I have no intention of shaming this institution, nor disgracing myself, by admitting a nameless imbecile such as yourself. Leave now, there are more important matters for me to attend to.\n\nHe returns to his work and waves his hand to shoo you away, but you came here for a purpose, and refuse to leave without seeing it fulfilled. You argue the case for your membership for several minutes; the chancellor growing visibly more frustrated with your presence every second you remain. Before long, he’s had enough of your filibustering and slams a hand on his desk.\n\n— Bah! If you so desperately want to gain membership, then so be it! If you can fulfil a simple request I've not had time to deal with, I shall consider your membership. Now, listen carefully, I will not repeat myself!\n\n— I’ve been looking for a secretary; one who is attractive, knows how to serve, and human. I would go to the Slaver Guild for this, but my duties here rarely permit me the time. Bring me a girl who meets my criteria, and I shall accept your membership. Now leave, before I force you to.\n\n[color=green]Your main quest has been updated. [/color]")
	elif globals.state.mainquest == 1:
		if questgiveawayslave == null:
			sprites = [['chancellor','pos1','opac']]
			text = "— Ah, you’ve returned, how very ‘wonderful’ of you. The arrangement has not been forgotten, provide me with what I want, and I’ll provide you with what you want."
			buttons.append(['Select matching slave', 'mageorderselect', 0])
			buttons.append(['Browse slaves', 'mageorderbrowse'])
		else:
			person = questgiveawayslave
			sprites = [['chancellor','pos1']]
			var result = checkQuestOnPerson(mageOrderSlaveQuests[0], person)
			if result[0]:
				text = "— Looks about right. Ready to part with her?"
				buttons.append(['Give away ' + person.name, 'givecompanion'])
				buttons.append(['Select matching slave', 'mageorderselect', 0])
				buttons.append(['Browse slaves', 'mageorderbrowse'])
			else:
				text = "— Do not waste my time.\n\n" + result[1]
				buttons.append(['Select matching slave', 'mageorderselect', 0])
				buttons.append(['Browse slaves', 'mageorderbrowse'])
	elif globals.state.mainquest == 2:
		sprites = [['melissafriendly','pos1','opac']]
		globals.charactergallery.melissa.unlocked = true
		text = ("After a brief talk, the girl at the reception desk leads to you a room where you find an exquisitely dressed woman.\n\n— Oh, a new face here. I'm Melissa. I am pleased to know that there's a new person in our glorious establishment; and an active one too. Fresh blood is exactly what we need here in the Order.\n\n— First thing, it's great that you helped out our grumpy fellow with new staff. Let me compensate you for that. No worries, you earned it, and it should help your sustain and our cause. \n\n[color=green]Melissa passes you 250 gold. [/color]\n\n— Promotions are not very useful in terms of privileges for the commonfolk we have around, but for you it will grant access to some of the great knowledge and technology we have. I'd like to offer you a partnership. You help me, and I will push you up the stairs. How does that sound?")
		buttons.append(['Agree','mageorderquest2'])
	elif str(globals.state.mainquest) in ['3','3.1']:
		sprites = [['melissafriendly','pos1','opac']]
		if questgiveawayslave == null:
			text = '— You are back. Did you find the fairy?'
			buttons.append(['Select matching slave', 'mageorderselect', 1])
		else:
			person = questgiveawayslave
			sprites = [['melissafriendly','pos1']]
			text = person.dictionary("— Looks about right. Ready to part with $him?")
			buttons.append(['Give away ' + person.name, 'givecompanion'])
			buttons.append(['Select matching slave', 'mageorderselect', 1])
	elif globals.state.mainquest == 4:
		sprites = [['melissaworried','pos1','opac']]
		globals.state.mainquest = 5
		text = "You find Melissa in her cabinet looking unusually grim.\n\n— Oh, it's you $name. I'm in a spot of trouble here. Two days ago I was supposed to receive  some important medication, but it has yet to arrive. I want you to go to the city market, find man named Sebastian, and figure out what happened to my delivery! Do that quickly and...\n\n— Well, do that, and we'll see about what you came for.\n\n[color=green]Your main quest has been updated. [/color]"
	elif globals.state.mainquest == 5:
		text = ("You decide it is unwise to see Melissa without her delivery right now.")
	elif globals.state.mainquest == 6 && globals.state.getCountStackableItem('youthingpot','backpack') > 0:
		globals.state.mainquest = 7
		globals.state.removeStackableItem('youthingpot',1,'backpack')
		globals.state.rank = 3
		sprites = [['melissafriendly','pos1','opac']]
		text = ("— You got it?” she inquires, “Splendid!\n\nAs you pass her the potion, she quickly puts it inside the desk.\n\n— Yeah, I've done the paperwork. Here's your new badge; you'll need it. You remind me of myself, back when I joined  the guild...\n\n— I was actually sold into slavery to one of the mages in my youth. Not gonna complain about my position back then much. *giggles* Eventually, I asked him to teach me, as I wanted to be something more than just another plaything. He agreed. I guess I wasn’t a disappointment, as in the end I inherited his manor in this city and have made it this far.\n\n— Anyway, come see me later. I still have business to take care of today.\n\n[color=yellow]You are now a Journeyman in the Mage guild.[/color]")
	elif globals.state.mainquest == 6:
		if globals.state.getCountStackableItem('youthingpot','inventory') > 0:
			text = ("You forgot to bring the Youthing Elixir in your backpack and decide it is unwise to see Melissa without her delivery right now.")
		else:
			text = ("You decide it is unwise to see Melissa without her delivery right now.")
	elif globals.state.mainquest == 7:
		globals.state.mainquest = 8
		sprites = [['melissafriendly','pos1','opac']]
		text = "— I hope you’ve noticed that you can now set up your own laboratory. If you have not, you really should.  Not only can you modify your servants to fit your tastes, but you can also make them more efficient. By law, you have all rights to do so."
		if globals.state.mansionupgrades.mansionlab < 1:
			text = text + "\n\n— Anyway, go set it up. You’ll need it  for your next task."
		else:
			text = text + "\n\n— You already have it? As I expected from someone as capable as you. Now, onto real business."
			globals.state.mainquest = 9
		if globals.state.mainquest == 9:
			buttons.append(["Continue", 'mageorderquest1'])
	elif globals.state.mainquest == 8 && globals.state.mansionupgrades.mansionlab < 1:
		text = ("You decide it's unwise to return to Melissa until you set up your laboratory.")
	elif (globals.state.mainquest == 8 || globals.state.mainquest == 9) && globals.state.mansionupgrades.mansionlab >= 1:
		###---Added by Expansion---### Quest Hint Added
		text = ("— So, about something new. Do you know about the farms? If not, Sebastian could probably tell you a few things. But anyway, the Taurus race in fact has a higher than average milk output. Not only that, but you'll be able to increase production even further by enhancing them with more and bigger... assets. This is your mission for now. Provide for me a taurus girl, ideally suited for milking, with multiple giant breasts. Not just extra nipples, but the breasts themselves need to be fully developed. You may need to use a laboratory to complete this.\n\n— I will leave the search for such a girl to you; consider it a part of a mission. While you are at it, I'll prepare your next promotion.")
		###---End Expansion---###
		globals.state.mainquest = 10
		sprites = [['melissafriendly','pos1','opac']]
	elif globals.state.mainquest == 10:
		if questgiveawayslave == null:
			sprites = [['melissafriendly','pos1','opac']]
			###---Added by Expansion---### Quest Hint Added
			text = "— You are back. Did you finish preparing the girl? Keep in mind that she needs to have her extra tits fully developed as well, which you may need the laboratory to do.\n\n\n\n-Aric's Note: This quest can be confusing to a lot of people. The Taurus needs extra nipples that are fully Developed as well. That is done via the Laboratory with the Develop Nipples action."
			###---End Expansion---###
			buttons.append(['Select matching slave', 'mageorderselect', 2])
			buttons.append(['Browse slaves', 'mageorderbrowse'])
		else:
			person = questgiveawayslave
			sprites = [['melissafriendly','pos1']]
			var result = checkQuestOnPerson(mageOrderSlaveQuests[2], person)
			if result[0]:
				text = "— Great work! Can I have her?"
				buttons.append(['Give away ' + person.name, 'givecompanion'])
				buttons.append(['Select matching slave', 'mageorderselect', 2])
				buttons.append(['Browse slaves', 'mageorderbrowse'])
			else:
				text = "— Not quite what I am looking for.\n\n" + result[1]
				buttons.append(['Select matching slave', 'mageorderselect', 2])
				buttons.append(['Browse slaves', 'mageorderbrowse'])
	elif globals.state.mainquest == 11:
		sprites = [['melissafriendly','pos1']]
		text = questtext.MainQuestGornStart
		globals.state.mainquest = 12
	elif globals.state.mainquest in [12,13,14,15]:
		text = "You decide it's unwise to return to Melissa until you finish your business in Gorn."
	elif globals.state.mainquest == 16:
		sprites = [['melissafriendly','pos1','opac']]
		text = questtext.MainQuestGornMelissaReturn
		state = false
		globals.resources.upgradepoints += 5
		buttons.append(['Close', "orderhade"])
		globals.state.mainquest = 17
	elif globals.state.mainquest == 25:
		globals.state.mainquest = 26
		globals.resources.upgradepoints += 5
		sprites = [['melissafriendly','pos1','opac']]
		text = questtext.MainQuestUndercityReturn
	elif globals.state.mainquest == 26:
		globals.state.mainquest = 27
		sprites = [['melissafriendly','pos1','opac']]
		text = questtext.MainQuestFrostfordMelissa
	elif globals.state.mainquest >= 27 && globals.state.mainquest <= 35:
		text = "You decide there's nothing you can gain from visiting Melissa right now. "
	elif globals.state.mainquest == 36:
		text = questtext.MainQuestFinaleOrder
		globals.state.mainquest = 37
		globals.resources.upgradepoints += 10
		sprites = [['melissafriendly','pos1','opac']]
	elif globals.state.mainquest == 37:
		text = "You decide there's nothing you can gain from visiting Melissa right now. "
	main.dialogue(state, self, text, buttons, sprites)
	mageorder()

var mageOrderSlaveQuests = [
	{reqs = [['sex','eq','female'],['race','eq','Human'],['beauty','gte',40],['obed','gte',80]]},
	{reqs = [['race','eq','Fairy']]},
	{reqs = [['race','eq','Taurus'],['sex','neq','male'],['lactation','eq',true],['titssize','gte',5],['titsextradeveloped','eq',true],['titsextra','gte',3]]},
]

func mageorderbrowse():
	main.selectslavelist(true, 'mageorderquest1', self)

func mageorderselect(stage):
	var quest = mageOrderSlaveQuests[stage]
	var array = []
	for person in globals.slaves:
		if person.away.duration != 0:
			continue
		if checkQuestOnPersonTextless(quest, person):
			array.append(person)
	main.showChoosePerson(array, 'mageorderquest1', self)

func orderhade():
	var text = globals.questtext.MainQuestGornMelissaAfter
	var buttons = []
	var sprites = null
	main.dialogue(true, self, text, buttons, sprites)

func selectslaveforquest(function):
	main.selectslavelist(true, function, self)

func givecompanion():
	var buttons = []
	var text = ''
	var person = questgiveawayslave
	var sprites = null
	if globals.state.mainquest == 1:
		if person != null:
			globals.state.mainquest = 2
			text = ("— Now that you are a member of the guild, I trust you’ll keep in mind that with status comes responsibility, and that you will not besmirch the guild’s name with your actions. As a neophyte, we have a variety of simple spells you may pay to learn. And, to repay an old debt to the fool you’re succeeding, I’ll teach you something basic for free. Mind Read is fairly simple and straightforward, allowing you limited insight into the subject’s thoughts and feelings. Much more informative than simply reading one’s expression and body language, but somewhat draining.\n\n[color=green]You are now a Neophyte in Mage guild.[/color]\n\n[color=green]You've learned a new spell: Mind Read. [/color]\n\n[color=green]Your main quest has been updated. [/color]")
			main.currentslave = globals.slaves.find(person)
			globals.spelldict.mindread.learned = true
			if globals.abilities.abilitydict.has('mindread') == true:
				globals.player.ability.append('mindread')
				globals.player.abilityactive.append('mindread')
			globals.state.branding = 1
			globals.state.rank = 1
			globals.resources.upgradepoints += 5
			main.getridof()
	elif str(globals.state.mainquest) in ['3','3.1']:
		if person != null:
			globals.state.mainquest = 4
			sprites = [['melissafriendly','pos1']]
			text = person.dictionary("— Oh, what a cutie! You are just as capable as I expected. Can't wait to play with $him in private, but business first.\n\nWith that, your companion is taken away and you are then taught Refined Branding. \n\n[color=green]You have been paid 500 gold. \n\nYour main quest has been updated. [/color]\n[color=yellow]You have gained an extra level.[/color]")
			main.currentslave = globals.slaves.find(person)
			globals.resources.gold += 500
			globals.state.rank = 2
			globals.state.branding = 2
			globals.player.levelup()
			globals.resources.upgradepoints += 5
			main.getridof()
	elif globals.state.mainquest == 10:
		globals.state.mainquest = 11
		sprites = [['melissafriendly','pos1']]
		text = ("— Splendid! You really are not held back by puny morals. I hope this will provide you with some useful information regarding the utilization of your servants. Now, if you’ll excuse me...\n\nWith that, your companion is taken away and you are promoted.[color=green] You are now an Adept in the Mage's Order.\n\nReceived 750 gold. [/color]\n[color=yellow]You have gained an extra level.[/color]")
		globals.state.rank = 4
		globals.resources.gold += 750
		main.currentslave = globals.slaves.find(person)
		globals.player.levelup()
		globals.resources.upgradepoints += 5
		main.getridof()
	questgiveawayslave = null
	main.dialogue(true, self, text, buttons, sprites)


func mageorderquest2():
	var text = ''
	var buttons = null
	var sprites = null
	if globals.state.mainquest == 2:
		sprites = [['melissafriendly','pos1']]
		globals.state.mainquest = 3
		globals.resources.gold += 250
		text = "— Marvelous! So here's the first thing we have on our hands. You likely know of the Brands and their utility. But those are the result of crude and very old work; surely anyone would want something much more efficient. For that, we have invented an upgrade to the old brands. They are generally referred to as 'Refined Brands' and are not very well known by the masses. The idea is pretty simple; to make the brand and branded person follow complex rules instead of just submissive basics. I can't overstate how amazingly useful it is, but those old fools at the council don't seem to bother.\n\n— The main issue is the magic essence, which is pretty hard to gather in large amounts as it is produced by fairies. Yeah, those shortstacks with childish behavior. Getting your hands on one seems to be getting harder and harder by the day. I want you to find me one, and in exchange I'll promote you, and share with you the knowledge of how to place a Refined Brand on a slave.\n\n— You will likely find fairies in the Far Eerie Woods or elven grove. It's a devilish looking place beyond the elven parts of the forest. That place is likely affected by a taint or some magical phenomenon that nobody can quite figure out. All of the creatures there seem to lose their sentience and become hostile to outsiders. Fairies are not generally like that, so I figured you may be able to tame one if you get it out of there. If not, it'd still be useful to us. Now, if you’ll excuse me, I still have some affairs to attend to today. Be careful, honey.\n\n[color=green]Your main quest has been updated. [/color]"
	main.dialogue(true, self, text, buttons, sprites)



func _on_close_pressed():
	get_node("mageorderservices").visible = false


func mageservices():
	get_node("mageorderservices").visible = true
	var spelllist = get_node("mageorderservices/ScrollContainer/spelllist")
	var spellbutton = get_node("mageorderservices/ScrollContainer/spelllist/spellbutton")
	for i in spelllist.get_children():
		if i != spellbutton:
			i.visible = false
			i.queue_free()
	for i in globals.spelldict.values():
		if globals.state.rank >= i.req:
			var newbutton = spellbutton.duplicate()
			spelllist.add_child(newbutton)
			newbutton.set_text(i.name)
			newbutton.set_name(i.code)
			newbutton.visible = true
			newbutton.connect('pressed',self,'spellbuttonpressed', [i])
			if i.learned == true:
				newbutton.set_disabled(true)
				newbutton.set_text(newbutton.get_text() + ' — learned')
	get_node("mageorderservices/learnspellbutton").set_disabled(true)

var spellselected

func spellbuttonpressed(spell):
	spellselected = spell
	for i in get_node("mageorderservices/ScrollContainer/spelllist").get_children():
		if i.pressed == true && i.get_name() != spell.code:
			i.set_pressed(false)
	get_node("mageorderservices/spelldescription").set_bbcode(spell.description + '\n\nPrice: ' + str(spell.price))
	if spell.price > globals.resources.gold:
		get_node("mageorderservices/learnspellbutton").set_disabled(true)
	else:
		get_node("mageorderservices/learnspellbutton").set_disabled(false)

func _on_learnspellbutton_pressed():
	var spell = spellselected
	if spell == null:
		return
	globals.resources.gold -= spell.price
	main.popup('You have learned new spell: ' + spell.name)
	spell.learned = true
	if globals.abilities.abilitydict.has(spell.code) == true:
		globals.player.ability.append(spell.code)
		globals.player.abilityactive.append(spell.code)
	mageservices()


func _on_upgradelibrary_pressed():
	if globals.state.library == 0:
		globals.state.library = 1
		globals.resources.gold -= 500
	elif globals.state.library == 1:
		globals.state.library = 2
		globals.resources.gold -= 1000
	elif globals.state.library == 2:
		globals.state.library = 3
		globals.resources.gold -= 1500
	main.popup('You have purchased fresh set of books for your library. ')
	_on_mageorderservices_visibility_changed()


func _on_upgradealchemy_pressed():
	if globals.state.alchemy == 0:
		var array = ['aphrodisiac','hairgrowthpot','amnesiapot','lactationpot','miscariagepot','stimulantpot','deterrentpot']
		for i in array:
			globals.itemdict[i].unlocked = true
		globals.state.alchemy = 1
		globals.resources.gold -= 500
		main.popup('You have purchased basic set of alchemy tools. ')
	elif globals.state.alchemy == 1:
		var array = ['oblivionpot','oblivionpot','minoruspot','majoruspot','aphroditebrew']
		for i in array:
			globals.itemdict[i].unlocked = true
		globals.state.alchemy = 2
		globals.resources.gold -= 1000
		main.popup('You have purchased advanced set of alchemy tools and unlocked new potion recipes. ')
	_on_mageorderservices_visibility_changed()

func _on_upgradelaboratory_pressed():
	if globals.state.laboratory == 0:
		globals.state.laboratory = 1
		globals.resources.gold -= 1000
		main.popup('You have purchased basic equipment for your laboratory. ')
	elif globals.state.laboratory == 1:
		globals.state.laboratory = 2
		globals.resources.gold -= 3000
		main.popup('You have purchased advanced equipment for your laboratory. ')
	_on_mageorderservices_visibility_changed()

func tishaquest():
	if globals.state.sidequests.emily == 12:
		globals.events.tishadorms()
	elif globals.state.sidequests.emily == 13:
		globals.events.tishabackstreets()
	elif globals.state.sidequests.emily in [14,15]:
		globals.events.tishagornguild()

#################### Markets

###---Added by Expansion---### ElPresidente Items
var shops = {
	wimbornmarket = {
		code = 'wimbornmarket',
		sprite = 'merchant',
		name = "Wimborn's Market",
		items = ['teleportwimborn','food','supply','bandage','rope','torch','teleportseal', 'basicsolutioning','hairdye', 'aphrodisiac' ,'beautypot', 'magicessenceing', 'natureessenceing','armorleather','armorchain','weapondagger','weaponserrateddagger','weaponbasicstaff','weaponsword','weaponceremonialsword','clothsundress','clothmaid','clothbutler','underwearlacy','underwearboxers', 'acctravelbag'],
		selling = true
	},
	shaliqshop = {
		code = 'shaliqshop',
		name = "Village's Trader",
		items = ['teleportseal','lockpick','torch','hairdye','beautypot','armorleather','clothmiko','clothkimono','armorninja', 'acctravelbag'],
		selling = true
	},
	gornmarket = {
		code = 'gornmarket',
		sprite = 'centaur',
		name = "Gorn's Market",
		items = ['teleportgorn','food', 'supply','bandage','rope','teleportseal','magicessenceing',"armorleather",'armorchain','weaponclaymore','weaponhammer','clothbedlah','accslavecollar','acchandcuffs','armorpadded'],
		selling = true
	},
	frostfordmarket = {
		code = 'frostfordmarket',
		sprite = 'frostfordtrader',
		name = "Frostford's Market",
		items = ['aydabrandy','teleportfrostford', 'supply','bandage','rope','torch','teleportseal', 'basicsolutioning','bestialessenceing','clothpet', 'weaponsword','weaponclaymore','weapongreatsword','accgoldring', 'acctravelbag'],
		selling = true
	},
	aydashop = {
		code = 'aydashop',
		sprite = 'aydanormal',
		name = "Ayda's Assortments",
		items = ['regressionpot', 'beautypot', 'hairdye', 'basicsolutioning','bestialessenceing','taintedessenceing','fluidsubstanceing'],
		selling = false
	},
	amberguardmarket = {
		code = 'amberguardmarket',
		name = "Amberguard's Market",
		items = ['teleportamberguard','beautypot','bestialessenceing','magicessenceing','fluidsubstanceing','armorelvenchain','armorrobe','clothchainbikini','accelvenboots'],
		selling = true
	},
	sebastian = {
		code = 'sebastian',
		name = "Sebastian",
		items = ['teleportumbra'],
		selling = false
	},
	#----------------------------------------------------------------------------------------------------------
	outdoor = {
		code = 'outdoor',
		name = "Outdoor",
		items = [],
		selling = false
	},
	#----------------------------------------------------------------------------------------------------------
	blackmarket = {
		code = 'blackmarket',
		name = 'Black Market',
		items = ['aydabook','lockpick','accslavecollar','acchandcuffs','armorleather','armorchain','weaponsword','weaponhammer','armortentacle','clothchainbikini','oblivionpot'],
		selling = true
	},
}
###---End Expansion---###

func market():
	var array = [{name = 'Market stalls (shop)', function = 'shopinitiate', args = 'wimbornmarket'}, {name = 'Return', function = 'town'}]
	get_parent().nodefade($charactersprite, 0.3)
	main.background_set('market')
	if OS.get_name() != "HTML5":
		yield(main, 'animfinished')
	var text = "Densely populated area filled with stalls, small buildings and people allowing you to find anything for your daily life. "
	if globals.state.rank >= 3 && globals.state.sidequests.cali == 0:
		text +=  "\n\n[color=yellow]You spot some commotion ongoing near one of the stalls.[/color]"
		array.insert(1, {name = 'Check the commotion', function = "caliqueststart"})
	for person in globals.slaves:
		###---Added by Expansion---### Ank BugFix v4a
		if person.away.duration != 0:
			continue
		if person.work == 'storewimborn':
			text += person.dictionary('\nYou spot $name talking to one of the merchants.')
		elif person.work == 'artistwimborn':
			text += person.dictionary('\nYou spot $name giving a minor performance at one of the corners. ')
		###---End Expansion---###
	mansion.maintext = text
	if globals.state.mainquest == 5:
		array.insert(1, {name = 'Look for Sebastian', function = 'sebastian'})
	elif globals.state.mainquest >= 7:
		array.insert(1, {name = 'Visit Sebastian', function = 'sebastian'})
	buildbuttons(array)



var currentshop
var selecteditem
var mode

#-----------------------------------------------------------------------
func shoppanelclosecheck():
	if get_node("shoppanel/Panel").visible == false:
		get_node("shoppanel").visible = false
		get_node("shoppanel/Panel").visible = true
	playergrouppanel()
#-----------------------------------------------------------------------

func shopinitiate(shopname):
	currentshop = shops[shopname]
	selecteditem = null
#-----------------------------------------------------------------------
	if shopname == "outdoor":
		currentshop.items.append('food')
		get_node("shoppanel").visible = true
		get_node("shoppanel/Panel").visible = false
		get_node("shoppanel/itempanel").visible = false
		get_node("shoppanel/inventory/ScrollContainer/GridContainer/Button/sell").visible = false
	else:
#-----------------------------------------------------------------------
		get_node("shoppanel/Panel/title").set_text(currentshop.name)
		get_node("shoppanel").visible = true
		#get_node("shoppanel/itempanel").visible = false
	$shoppanel/Panel/exchange.visible = shopname == 'blackmarket'
	$shoppanel/exchange.visible = false

	if currentshop.has('sprite'):
		setcharacter(currentshop.sprite)


func shopbuy():
	$shoppanel/exchange.visible = false
	$shoppanel/inventory.merchantitems = currentshop.items
	$shoppanel/inventory.open()
	if currentshop.has('sprite') && currentshop.sprite != null:
		$shoppanel/inventory/merchant.texture = globals.spritedict[currentshop.sprite]
	else:
		$shoppanel/inventory/merchant.texture = null


func shopclose():
	get_node("shoppanel").visible = false
	if currentshop.has('sprite') && currentshop.code != 'aydashop':
		get_parent().nodefade($charactersprite, 0.3)

func exchangeRefresh():
	for i in $shoppanel/exchange/ScrollContainer/GridContainer.get_children():
		if i.name != 'Button':
			i.hide()
			i.free()

	for i in globals.state.unstackables.values():
		if i.owner == null && i.enchant == 'basic':
			var newbutton = $shoppanel/exchange/ScrollContainer/GridContainer/Button.duplicate()
			newbutton.show()
			newbutton.get_node('Icon').texture = globals.loadimage(i.icon)
			$shoppanel/exchange/ScrollContainer/GridContainer.add_child(newbutton)
			newbutton.connect('mouse_entered', globals, 'itemtooltip', [i])
			newbutton.connect("mouse_exited", globals, 'itemtooltiphide')
			newbutton.connect("pressed", self, 'calculateexchange')
			newbutton.set_meta("item", i)
	calculateexchange()

func exchangeitems():
	if $shoppanel/exchange.visible:
		$shoppanel/exchange.visible = false
		return
	else:
		$shoppanel/exchange.visible = true
	exchangeRefresh()

var ItemsForExchange = []

func calculateexchange():
	var itemarray = []
	ItemsForExchange.clear()
	for i in $shoppanel/exchange/ScrollContainer/GridContainer.get_children():
		if i.visible && i.pressed:
			itemarray.append(i.get_meta('item'))
	ItemsForExchange = itemarray.duplicate()
	$shoppanel/exchange/TradeButton.disabled = itemarray.size() == 0 || itemarray.size() % 3 != 0

var treasurepool = [
	['armorninja',5],['armorplate',1],['armorleather',20],['armorchain',11],['armorelvenchain',3],['armorrobe',4],
	['weapondagger',20], ['weaponsword',9], ['weaponclaymore',3], ['weaponhammer', 4], ['underwearlacy', 3], ['underwearboxers', 3],
	['clothsundress',10], ['clothmaid',10], ['clothkimono',7], ['clothmiko',5], ['clothpet',3], ['clothbutler',10], ['clothbedlah',4],
	['accgoldring',3],['accslavecollar',4],['acchandcuffs',3],['acctravelbag',5],['accamuletemerald', 1], ['accamuletruby', 1],
	['weaponelvensword',3], ['weaponnaturestaff',2], ['armortentacle', 0.5], ['clothtentacle', 1],
	['armorrogue', 0.5],['weaponcursedsword', 0.5],
]

func exchangeitemsconfirm():
	var numNew = ItemsForExchange.size() / 3
	for i in ItemsForExchange:
		globals.state.unstackables.erase(i.id)
	ItemsForExchange.clear()
	for i in range(numNew):
		var newitem = globals.items.createunstackable(globals.weightedrandom(treasurepool))
		if newitem.enchant != 'unique':
			if randf() >= 0.3:
				globals.items.enchantrand(newitem, 2)
			else:
				globals.items.enchantrand(newitem)
			#newitem.enchant = 'rare'
		globals.state.unstackables[newitem.id] = newitem
		if numNew < 6:
			get_parent().infotext('Received '+ newitem.name + ' from exchange','green')
	if numNew >= 6:
		get_parent().infotext('Received many items from exchange','green')
	exchangeRefresh()

####QUESTS
var cali

func caliqueststart(value = ''):
	var buttons = []
	var text = ''
	var sprites
	if typeof(value) != TYPE_STRING:
		globals.state.sidequests.cali = value
	if globals.state.sidequests.cali == 0:
		text = "As you walk by rows of traders you hear some noise and bunch of people gathering around.\n\n[color=yellow]— Let me go, you brute, I didn't do anything! — you hear girl's voice. [/color]\n\nAs you get closer, you notice a small dirty-looking halfkin wolf girl trying to break free from big man holding her.\n\n[color=aqua]— She's a thief! Everyone saw this! Why do they even let your kind roam around? You are no different from wild animals trying to hunt human flocks! [/color]\n\n[color=yellow]— Damn you, fat bastard! [/color]\n\nWith that girl tries to bite on hand holding her, but fails as her holder reacts to that and makes her struggling useless.\n\n[color=aqua]— Call the guards already! I still have stall to look after![/color]"
		buttons.append(["Intervene as a guild member",'caliqueststart', 1])
		buttons.append(["Ignore it",'caliqueststart', 10])
	elif globals.state.sidequests.cali == 1:
		text = "You approach the shop owner and tell him that it is improper to stereotype on other races and it is the guild's policy to welcome every other humanoid race. As he sees your badge, he quickly restrains himself and begs for pardon.\n\n[color=aqua]— She's a thief, " + globals.fastif(globals.player.sex == 'male', 'Milord', 'Milady')+ "! She stole a big chunk of pork from me. Witnesses will confirm it. [/color]\n\nAs you look at the girl, she glares back but doesn't deny the accusation. You notice that she looks pretty scrawny and is probably one of the homeless around town. By law theft is a considerable offence and will result in flagellation."
		globals.charactergallery.cali.unlocked = true
		if globals.resources.gold >= 50:
			buttons.append(["Offer compensation for her", 'caliqueststart', 2])
		else:
			buttons.append({text = "Offer compensation for her", function = 'caliqueststart', args = 2, disabled = true, tooltip = "Not enough gold"})
		buttons.append(["Offer to take her away for personal punishment", 'caliqueststart', 3])
		buttons.append(["Step away and leave it to guards", 'caliqueststart', 100])
		cali = globals.characters.create('Cali')
	elif globals.state.sidequests.cali == 2:
		globals.resources.gold -= 50
		text = "— That is... very noble of you " + globals.fastif(globals.player.sex == 'male', 'Milord', 'Milady')+ ", but I believe a thief should be punished.\n\nOn that you tell him to let you handle the girl and after a moment butcher agrees to drop his charge. You lead the girl away and after some time end up in desolated place."
		buttons.append(["Talk to her", 'caliqueststart', 4])
		buttons.append(["Take girl to jail", 'caliqueststart',5])
		cali.loyal += 10
	elif globals.state.sidequests.cali == 3:
		text = "You give a scary look and offer to take care of the thief. After a thought, butcher decides that being handled by one of the magi would be more than sufficient punishment and hands girl away. She barely tries to resist realising there's not much room for escape and you lead her away from public.\n\nAfter a while you end up in remotely desolated street."
		buttons.append(["Go with your words and take girl to jail", 'caliqueststart', 5])
		buttons.append(["Talk to her", 'caliqueststart', 4])
	elif globals.state.sidequests.cali == 4:
		text = "You share some food and ask her about her life.\n\n— Thanks for help... My name is Cali. I was captured from my village few weeks ago by bandits. They were about to sell me here but I managed to escape before they brought me to the guild. I have to get back home to my mother and father... I hope they are alright.\n\nAfter few moments she says goodbye and prepares to leave."
		buttons.append(["Offer to take her into your mansion", 'caliqueststart', 6])
		buttons.append(["Offer to help her get home", 'caliqueststart', 7])
		buttons.append(["Leave her on her own", 'caliqueststart', 100])
	elif globals.state.sidequests.cali == 5:
		text = "You take the young girl with you and return to the mansion."
		buttons.append(["Continue", 'caliqueststart', 100])
		cali.sleep = 'jail'
		globals.slaves = cali
	elif globals.state.sidequests.cali == 6:
		if cali.loyal > 5:
			text = "You offer Cali to take her into your mansion saying that even if she can't get home it's still better than living on the streets. After some thought she decides to accept your offer.\n\n— I can trust you I guess? You bribed me from trouble after all... Alright, please take care of me.\n\n[color=green]Cali is now your servant. [/color]"
			globals.slaves = cali
			buttons.append(["Continue", 'caliqueststart', 11])
			globals.state.upcomingevents.append({code = 'calievent1', duration = 7})
			globals.state.sidequests.caliparentsdead = false
			globals.state.upcomingevents.append({code = 'caliparentsdie', duration = 28})
		else:
			text = "You offer Cali to take her into your mansion saying that even if she can't get home it's still better than living on the streets. After some thought she decides to decline your offer.\n\n— Thanks for help, but I don't wanna stay here.\n\nWith that she shortly thanks you again and retreats."
			buttons.append(["Continue", 'caliqueststart', 100])
	elif globals.state.sidequests.cali == 7:
		text = "You offer Cali your help and roof over head in exchange for her service while you find out a way to get her home.\n\n— You would do that for me?!\n\nHer eyes shimmer with hope giving away her innocent nature.\n\n— I will... make sure to repay you in that case. My family is not rich, but I'm sure they would find a way.\n\n[color=green]Cali is now your servant.[/color]"
		cali.loyal += 5
		cali.obed += 25
		globals.slaves = cali
		globals.state.sidequests.caliparentsdead = false
		globals.state.upcomingevents.append({code = 'caliparentsdie', duration = 28})
		buttons.append(["Continue", 'caliqueststart', 12])
	elif globals.state.sidequests.cali >= 10:
		market()
		cali = null
		main.close_dialogue()
		return
	if globals.state.sidequests.cali == 0:
		sprites = [['caliangry', 'pos1','opac']]
	elif globals.state.sidequests.cali == 1:
		sprites = [['caliangry', 'pos1']]
	elif globals.state.sidequests.cali == 7:
		sprites = [['calihappy', 'pos1']]
	elif globals.state.sidequests.cali == 5:
		###---Added by Expansion---### Ank BugFix v4a
		sprites = [['caliangry', 'pos1']]
		###---End Expansion---###
	else:
		sprites = [['calineutral', 'pos1']]
	main.dialogue(false, self, text, buttons, sprites)

func sebastian():
	var text = ''
	setcharacter('sebastian')
	var array = [{name = 'Return',function = 'market'}]
	if globals.state.mainquest == 5:
		globals.state.mainquest = 6
		mansion.maintext = "After spending some time asking around, you finally find a shady looking warehouse, poorly decorated as some obscure workshop. Inside of it you meet a rather flamboyant man dressed head to toe in several layers of brightly colored clothing. He takes notice of your presence and comes to greet you, giving a flashy bow as he approaches. He speaks with a rather obvious accent, though you can’t quite place it.\n\n— Welcome, friend! Do I know you? We are not quite open to public you see...\n\nYou let him know that you are from Melissa and a part of the Mage's Order, at which he shines.\n\n— Oh, I see, Mister "+globals.player.name+"; a new face in our dependable government! I'm very pleased to meet you. Yes... about Melissa, I wanted to warn her but... It has been very rowdy these last few days... Yes, her elixir...\n\n— Well, sadly, I don't have it. Yes, I know I promised to get it last week, but our alchemist is lost... Not literally. He was experimenting with some new stuff he got his hands on and now he seems to have lost his senses; even spending too much time at the bar too...\n\n— Look, you are no stranger to working with magic, are you? Alchemy shouldn't be too much work either. Since you are in the Order, you must have a sizeable property. Why don't you get an alchemy kit and get milady what she wants? I'll share some formulas with you and you cover this up for me. I can see that you are a capable person.\n\nAfter some consideration, you agree with the offer, deciding that it will be a useful experience for your future researches.\n\n— Milady wants Youthing Elixir. No, I don't know why, and neither should you want to know. The thing allows you to reverse your aging a bit, which makes it very desirable with the ladies. You will need few rare ingredients to cook it, and I'll provide you those.[color=yellow] You should keep in mind though, nearly any magical potion will apply some toxicity to the subject's body, which may produce some nasty effects. I’m telling you this just in case you try to experiment. Try to keep the doses small, as toxicity will dissipate after some time. [/color]\n\n[color=green]Youthing Elixir recipe unlocked.\nMaturing Elixir recipe unlocked.[/color]"
		globals.itemdict.minoruspot.amount += 1
		globals.itemdict.magicessenceing.amount += 2
		globals.itemdict.youthingpot.unlocked = true
		globals.itemdict.maturingpot.unlocked = true
	elif globals.state.mainquest >= 7 && globals.state.farm == 0:
		globals.state.farm = 1
		mansion.maintext = "— Hey, "+globals.player.name+"! You took care of that little errand? Great, great! So what are you up to? Me? I'm working with not-so-easy-to-get merchandise. Since you're working with Melissa, I suppose you'd be interested as well! Yes, rare black market ingredients, mythical creatures, and forbidden magical devices; I tend to deal with many of those! Of course the service won't be cheap, as the rarity and legality is the main issue.\n\n— I can offer you one rare slave every couple of days, but I'll warn you: I only deal with rare species. Their obedience and branding is entirely up to you, so don't come back complaining if they bite you in your sleep!\n\nHe gives a mirthful chuckle.\n\n— Otherwise, a pleasure doing business with you. I'll let you know when I get something in that might interest you. Speaking of which, I have one proposal which may interest you, as I heard you own a nice isolated place, and tend to keep slaves around to help you."
	elif globals.state.mainquest >= 7:
		if globals.state.sebastianorder.taken == false:
			mansion.maintext = "— Glad to see you well, "+globals.player.name+"! How are you doing? Got a special order?"
		elif globals.state.sebastianorder.taken == true && globals.state.sebastianorder.duration != 0:
			mansion.maintext = "— Glad to see you well, "+globals.player.name+"! Your special order is not here yet, but worry not! Everything goes as planned. "
		else:
			mansion.maintext = "— Oh, Come in, " + globals.player.name + "! Your special order has been waiting for you. "
		if globals.resources.gold >= 100 && globals.state.sebastianorder.taken == false:
			array.insert(0, {name = 'Make a special request',function = 'sebastianorder'})
		elif globals.state.sebastianorder.taken == true && globals.state.sebastianorder.duration == 0:
			array.insert(0, {name = 'See special order', function = 'sebastianorder'})
		elif globals.state.sebastianorder.taken == false:
			mansion.maintext = mansion.maintext +"[color=#ff4949]\nYou don't have enough gold to make request (100 needed)[/color]"
	if globals.state.farm == 1:
		array.insert(0, {name = 'Consult on proposal', function = 'sebastianfarm'})
	elif globals.state.farm == 2:
		array.insert(0, {name = 'Consult on farm purchase', function = 'sebastianfarm'})
	if globals.state.sidequests.cali == 15 && globals.state.sidequests.calibarsex != 'sebastian':
		array.insert(0, {name = 'Ask Sebastian about mercenary', function = 'sebastianquest', args = 0})
	if globals.state.mainquest >= 7:
		if globals.state.sidequests.has('sebastianumbra'):
			if globals.state.sidequests.sebastianumbra == 0:
				array.insert(0, {name = 'Ask Sebastian about his sources', function = 'sebastianquest', args = 1})
			if globals.state.sidequests.sebastianumbra == 1:
				array.insert(0, {name = "Purchase", function = 'sebastianquest', args = 2})
			if globals.state.sidequests.sebastianumbra >= 1:
				array.insert(0, {name = 'Sell slaves', function = 'sebastianquest', args = 3})
	buildbuttons(array)

func sebastianquest(stage = 0):
	if stage == 0:
		globals.state.sidequests.calibarsex = 'sebastian'
		sebastian()
		mansion.maintext = questtext.CaliBarAskSebastian
	elif stage == 1:
		globals.state.sidequests.sebastianumbra = 1
		sebastian()
		mansion.maintext = globals.player.dictionary(questtext.sebastianumbra)
	elif stage == 2:
		shopinitiate('sebastian')
		sebastian()
	elif stage == 3:
		sellslavelist('sebastian')
	elif stage == 4:
		globals.state.sidequests.sebastianumbra = 2
		sebastian()
		mansion.maintext = globals.player.dictionary(questtext.sebastianumbra2)
	#sebastian()

func sebastianorder():
	if globals.state.sebastianorder.taken == false:
		mansion.maintext = "— If you need someone of a specific race, I'll make sure to get one next time you come.  That will cost you 100 gold though. Money up front!"
		clearbuttons()
		get_node("sebastiannode").visible = true
		$sebastiannode/sebastionorder.clear()
		for i in globals.racefile.groups.sebastian:
			$sebastiannode/sebastionorder.add_item(i)

#		if globals.rules.furry == false:
#			var counter = get_node("sebastiannode/sebastionorder").get_item_count()
#			var counter2 = 0
#			while counter > counter2:
#				if get_node("sebastiannode/sebastionorder").get_item_text(counter).find('Beastkin') >= 0:
#					get_node("sebastiannode/sebastionorder").remove_item(counter)
#				counter -= 1
	else:
		var person = globals.state.sebastianslave
		var array = [{name = "Pay", function = "sebastianpay"}, {name = "Refuse", function = "sebastianrefuse"}]
		mansion.maintext = "After few moments, Sebastian presents to you a chained " + person.race + person.dictionary(" $child, who still looks pretty rebellious.\n\n— Got you what you asked for!\n\nYou slowly inspect $him.") + person.descriptionsmall() + "\n\n— I would like to receive " + str(person.buyprice()) + person.dictionary(" gold for my service. If you don't want $him, it's fine, since I can find another buyer in huge town like this.")
		buildbuttons(array)

func sebastianpay():
	var person = globals.state.sebastianslave
	if globals.resources.gold >= person.buyprice():
		var effect = globals.effectdict.captured
		var dict = {'slave':0.7, 'poor':1,'commoner':1.2,"rich": 2, "noble": 4}
		effect.duration = round((4 + (person.conf+person.cour)/20) * dict[person.origins])
		person.add_effect(effect)
		if globals.count_sleepers().jail < globals.state.mansionupgrades.jailcapacity:
			person.sleep = 'jail'
		globals.slaves = person
		globals.resources.gold -= person.buyprice()
		globals.state.sebastianorder.taken = false
		main.popup("You purchase your new toy and leave Sebastian. ")
		market()
	else:
		main.popup("You don't have enough money.")

func sebastianrefuse():
	globals.state.sebastianorder.taken = false
	market()

func _on_sebastianconfirm_pressed():
	var race = get_node("sebastiannode/sebastionorder").get_item_text(get_node("sebastiannode/sebastionorder").get_selected())
	globals.state.sebastianorder.race = race
	globals.state.sebastianorder.taken = true
	globals.state.sebastianorder.duration = round(rand_range(3,5))
	globals.resources.gold -= 100
	var caste = ['slave','poor','commoner','rich','noble']
	globals.state.sebastianslave = globals.newslave( globals.state.sebastianorder.race, 'random', 'random', globals.randomfromarray(caste))
	mansion.maintext = "— "+race+", huh? Got ya! Come see me in "+ str(globals.state.sebastianorder.duration)+ " days and don't forget the coins! Those are not cheap after all. "
	get_node("sebastiannode").visible = false
	var array = [{name = 'Leave', function = 'market'}]
	buildbuttons(array)


func _on_sebastiancancel_pressed():
	get_node("sebastiannode").visible = false
	sebastian()

func sebastianfarm():
	var array = [{name = 'Return', function = 'market'}]
	if globals.state.farm == 1:
		mansion.maintext = "— Do you know about farms? No, not the rural kind. You can use girls to make milk. Truthfully speaking, I have some of the necessary gear on my hands. So, if you ever consider starting your own small business, I'll gladly sell it to you.\n\n— You would need some space for that first though. I actually can help you with all that, for 1000 gold I'll get you builders and all basic equipment you will need to set your farm up. Let me know if you are interested. "
		globals.state.farm = 2
	elif globals.state.farm == 2:
		mansion.maintext = "— You are done with your preparations? Great, great! Now I'll pass you the rest of necessary equipment for 1000 gold."
		if globals.resources.gold >= 1000:
			array.insert(0,{name = 'Purchase farm equipment', function = 'sebastianfarmpurchase'})
	buildbuttons(array)

func sebastianfarmpurchase():
	globals.state.farm = 3
	globals.resources.gold -= 1000
	mansion.maintext = "— Pleased to have business with you!\n\n[color=yellow]Your mansion has now been fitted with an underground farm.[/color]\n\n— Oh, and by the way, that is not the only method to utilize your servants. Have you heard about giant snails? Their eggs are quite a delicacy, but they are really picky about where they lay them. I’ve heard that you can make them lay some in a human's orifices. — he slyly winks you — It looks like a human’s body temperature makes them attractive nests.\n\n— I've heard they can be found in the woods north of Shaliq. Getting yourself one can be tricky, but fortunately they are quite tame once you sate their voracious appetite. "
	var array = [{name = 'Return', function = 'sebastian'}]
	buildbuttons(array)

################ backstreets
func backstreets():
	var text = "This part of town is populated by criminals and the poor.  The brothel is located here."
	main.background_set('wimborn')
	yield(main, 'animfinished')
	get_node("charactersprite").visible = false

	var array = [{name = 'Enter Brothel',function = 'brothel'}]
	#Original quest event 'hooks'
	if globals.state.sidequests.emily <= 1:
		text += '\n\nYou see an urchin girl trying to draw your attention'
		array.insert(1,{name = 'Respond to the urchin girl', function = 'emily'})
	if globals.state.sidequests.cali in [14,15,16]:
		for i in globals.slaves:
			if i.unique == 'Cali':
				array.insert(1,{name = "Visit local bar", function = "calibarquest"})
				break
	if globals.state.sidequests.emily == 13:
		array.insert(1,{name = 'Search Backstreets', function = 'tishaquest'})


	#QMod - New Event System
	if array.size() > 0:
		buildbuttons(array)

	var place = {'region' : 'wimborn', 'area' : 'wimbornCity', 'location' : 'backstreets'}
	var placeEffects
	var buttonCount = array.size() #ToFix - Keep an eye on this, links old quest button and new quest button counts.
#
#	placeEffects = globals.events.call_events(place, 'trigger') #ToFix - Should a triggered event be able to create a 'hook' event as a follow-up?
#	if placeEffects.text != '':
#		text += '\n\n' + placeEffects.text
#
#	placeEffects = globals.events.call_events(place, 'hook', {source = self, function = 'backstreets'})
#	if placeEffects.text != '':
#		text += '\n\n' + placeEffects.text
#	var buttons = placeEffects.buttons
#	if buttons.size() > 0:
#		buildbuttons(buttons, globals.events, false, buttonCount)
#		buttonCount += buttons.size()
	# - End New Event System


	#Return to town center button
	array = [{name = 'Return', function = 'town'}]
	buildbuttons(array, self, false, buttonCount)

	mansion.maintext = text

var textnode = globals.questtext

func emily():
	globals.events.emily()


func brothel(person = null):
	mansion.background_set("brothel")
	yield(main, 'animfinished')
	clearbuttons()
	setcharacter('brothelhost')

	###---Added by Expansion---### Colorize Text
	var text = "The doorman greets you and leads you through the [color=aqua]brothel[/color] until you meet the [color=aqua]Madam[/color].\n[color=yellow]—Greetings! How can we pleasure you today?[/color]\n"
	for person in globals.slaves:
		if person.away.duration == 0:
			if person.work == 'whorewimborn' || person.work == 'escortwimborn':
				text += person.dictionary(globals.expansion.getBrothelWhoreDescription(person))
			elif person.work == 'fucktoywimborn':
				text += person.dictionary(globals.expansion.getBrothelFucktoyDescription(person))
	mansion.maintext = text
	var array = [{name = 'Return', function = 'backstreets'}]
	#---Brothel Services
	array.append({name = 'Check Available Prostitutes', function = 'brothelservices'})

	if globals.state.sidequests.brothel == 0:
		array.insert(0,{name = 'Can my slaves work here?', function = 'brothelquest'})
	elif globals.state.sidequests.brothel == 1:
		if person == null:
			array.insert(0,{name = 'Offer slave for quest', function = 'selectslavebrothelquest'})
		else:
			if person.race in ['Elf','Tribal Elf','Dark Elf'] && person.sex != 'male':
				mansion.maintext = "[color=yellow]— An [color=aqua]elf[/color], indeed. So, do you want to trade?[/color]"
				array = [{name = 'Give away ' + person.name,function = 'brothelquest'}, {name = 'Choose another person', function = 'selectslavebrothelquest'}, {name = 'Leave', function = 'backstreets'}]
				questgiveawayslave = person
			else:
				mansion.maintext = "[color=yellow]— I don't think this is an [color=aqua]Elf[/color] girl. Please, don't waste my time.[/color] "
				array = [{name = 'Offer slave for quest', function = 'selectslavebrothelquest'},{name = 'Leave',function = 'backstreets'}]
				questgiveawayslave = null
	buildbuttons(array)
	###---End Expansion---###

###---Added by Expansion---###
func brothelservices():
	mansion.background_set("brothel")
	yield(main, 'animfinished')
	clearbuttons()
	setcharacter('brothelhost')

	var text = "The [color=aqua]Madam[/color] smiles and motions you towards a couch at the front of the [color=aqua]brothel[/color] with a stage in front of it."
	if globals.player.energy < 100:
		text += "\n\n[color=yellow]—We have a few options for you. Do you prefer something young and exotic that will make you feel like the day has just begun?[/color]"
		text += "\n\nA petite, perky [color=aqua]Fairy[/color] girl bounces out onto the stage wearing nothing but hopes and dreams to cover her bouncy tits. She gets down on her knees and smiles lewdly at you, running her tongue around her lips."
	else:
		text += "\n\n[color=yellow]—Our [color=aqua]Fairy[/color] is out for the moment, but don't worry.[/color]"
	text += "\n\nThe Madam continues.\n\n[color=yellow]—Are you here to taste raw energy, experience, and sexual prowess?[/color]\n\n"
	text += "\n\nA tall, sultry [color=aqua]Dark Elf[/color] woman slinks onto the stage. She moves across it like water and if not for the sultry jiggling of her voluptuous breasts you may not be able to tell she was even moving. She sinks to her knees and heaves her chest out toward you while waiting breathlessly."
	if globals.player.energy < 100:
		text += "\n\n[color=yellow]—Both girls are just 50 gold each for the next half-hour.[/color]"
	else:
		text += "\n\n[color=yellow]—She is just 50 gold for the next half-hour.[/color]"
	text += "\nShe holds a parchment out towards you with the prices listed.\n\n[color=#d1b970]'Cost of Pleasure'[/color]\nDark Elf | -50 gold for +10 mana\nFairy | -50 gold for +25 energy"
	var counter = 0

	mansion.maintext = text
	var array = [{name = 'Choose the sensual Dark Elf', function = 'brothelservicesmana'},{name = 'No thanks', function = 'brothel'}]
	if globals.player.energy < 100:
		array.insert(0,{name = 'Choose the energetic Fairy', function = 'brothelservicesenergy'})
	buildbuttons(array)

func brothelservicesenergy():
	mansion.background_set("brothel")
	yield(main, 'animfinished')
	clearbuttons()
	setcharacter('brothelhost')
	var array = [{name = 'Head back to the street', function = 'backstreets'}]
	var text = "You point at the [color=aqua]Fairy[/color] and nod.\n[color=yellow]-I'll have her.[/color]\n\nThe [color=aqua]Madam[/color] looks at you with an understanding smile.\n[color=yellow]-I hope you thoroughly enjoy yourself.[/color]"
	if globals.resources.gold >= 50:
		globals.resources.gold -= 50
		globals.player.energy += 25
		text += "\n\nShe leads you to a back room. You enjoy the flitting of her wings as she lets you ravage her after teasing you and exciting you. You leave feeling satisfied and refreshed.\n\n[color=green]Gained 25 Energy[/color]\n[color=red]Lost 50 Gold[/color]"
	else:
		text += "\n\nThe [color=aqua]Madam[/color] looks at you and holds out her hand.\n\n[color=yellow]-Don't be trying anything tricky now, cutie. Either pay first or get out.[/color]\n\nYou stand and head for the door as the doorman looms over you. She calls after you from the couch.\n\n[color=yellow]-Come back when you have some money![/color]"
	mansion.maintext = text
	buildbuttons(array)

func brothelservicesmana():
	mansion.background_set("brothel")
	yield(main, 'animfinished')
	clearbuttons()
	setcharacter('brothelhost')
	var array = [{name = 'Head back to the street', function = 'backstreets'}]
	var text = "You point at the [color=aqua]Dark Elf[/color] and nod. [color=yellow]-I'll have her.[/color]\n\nThe [color=aqua]Madam[/color] looks at you with an understanding smile.\n[color=yellow]-I hope you thoroughly enjoy yourself.[/color]"
	if globals.resources.gold >= 50:
		globals.resources.gold -= 50
		globals.resources.mana += 10
		text += "\n\nThe [color=aqua]Dark Elf[/color] woman leads you to a back room. You walk out of the room some hours later having been infused with magical energy from her orgasms. You leave feeling satisfied and refreshed.\n\n[color=green]Gained 10 Mana[/color]\n[color=red]Lost 50 Gold[/color]"
	else:
		text += "\n\nThe [color=aqua]Madam[/color] looks at you and holds out her hand.\n\n[color=yellow]-Don't be trying anything tricky now, cutie. Either pay first or get out.[/color]\n\nYou stand and head for the door as the doorman looms over you. She calls after you from the couch.\n\n[color=yellow]-Come back when you have some money![/color]"
	mansion.maintext = text
	buildbuttons(array)
###---End Expansion---###

func selectslavebrothelquest():
	main.selectslavelist(true, 'brothel', self, 'person.race in ["Elf","Dark Elf","Tribal Elf"]')

func brothelquest():
	var array = []
	if globals.state.sidequests.brothel == 0:
		mansion.maintext = "— Huh, you want to whore your employees? You don't expect me to provide such opportunity for free, do you? How about a deal? You bring me an elf girl and I will consider such option. Elves are really in demand pretty much every season. \n\n[color=green]You obtained new sidequest. [/color] "
		array = [{name = 'Leave', function = 'backstreets'}]
		globals.state.sidequests.brothel = 1
	elif globals.state.sidequests.brothel == 1:
		###---Added by Expansion---### Ank BugFix v4a
		questgiveawayslave.removefrommansion()
		###---End Expansion---###
		mansion.maintext = "— Fine, you can send your servants to me and we'll offer them to clients. Keep in mind though we gonna keep some share of earnings for obvious reasons. Now we can't tell how much she'll made but I can give you few hints. Allure and endurance play some role here, but nothing can beat a sexually proactive girl who knows how to please her partner, especially if she has a pretty face.\n\n— Yeah, we'll keep her safe from possible aggression but don't blame on us if she decides to escape. We can't really watch her every movement. Although slaves rarely do that since they are basically outlaws at that point. \n\n[color=green]You have unlocked brothel as a workplace. [/color] "
		array = [{name = 'Leave', function = 'backstreets'}]
		globals.state.sidequests.brothel = 2
	buildbuttons(array)


func _on_slavedescription_meta_clicked( meta ):
	if meta == 'race':
		get_parent().showracedescript(selectedslave)

func calibarquest():
	globals.events.calibar()



func _on_questlog_pressed():
	get_parent()._on_questlog_pressed()


var backpackselecteditem
var backpackselectedspell
var partyselectedslave

func _on_details_pressed(empty = null):
	var newbutton
	if globals.state.getCountStackableItem(backpackselecteditem,'backpack') <= 0:
		backpackselecteditem = null
	if partyselectedslave != null:
		var foundSelected = false
		for i in [globals.player.id] + globals.state.playergroup:
			if str(i) == str(partyselectedslave.id):
				foundSelected = true
		for i in globals.state.capturedgroup:
			if i == partyselectedslave:
				foundSelected = true
		if !foundSelected:
			partyselectedslave = null
	if !globals.spelldict.get(backpackselectedspell,{}).get('learned'):
		backpackselectedspell = null
	if get_node("playergroupdetails/TabContainer").is_connected('tab_changed',self,'_on_details_pressed') == false:
		get_node("playergroupdetails/TabContainer").connect("tab_changed",self,"_on_details_pressed")
	if get_node("playergroupdetails/Panel/TabContainer").is_connected('tab_changed',self,'_on_details_pressed') == false:
		get_node("playergroupdetails/Panel/TabContainer").connect("tab_changed",self,"_on_details_pressed")
	if !backpackselecteditem:
		get_node("playergroupdetails/Panel/itemdescript").set_bbcode("")
		get_node("playergroupdetails/Panel/discardbutton").set_disabled(true)
		get_node("playergroupdetails/Panel/usebutton").set_disabled(true)
	for i in get_node("playergroupdetails/TabContainer/Captured Slaves/HBoxContainer/").get_children() + get_node("playergroupdetails/Panel/TabContainer/Items/VBoxContainer").get_children() + get_node("playergroupdetails/TabContainer/Party/HBoxContainer").get_children() + get_node("playergroupdetails/Panel/TabContainer/Spells/VBoxContainer").get_children():
		if i.get_name() != 'Button':
			i.visible = false
			i.queue_free()
	for i in globals.state.capturedgroup:
		newbutton = get_node("playergroupdetails/TabContainer/Captured Slaves/HBoxContainer/Button").duplicate()
		get_node("playergroupdetails/TabContainer/Captured Slaves/HBoxContainer/").add_child(newbutton)
		newbutton.visible = true
		newbutton.set_meta("person", i)
		newbutton.get_node("setfree").connect("pressed",self,'freecaptured', [i])
		newbutton.get_node("inspect").connect("pressed",self,'inspectslave', [i])
		newbutton.connect("mouse_entered", globals, 'slavetooltip', [i])
		newbutton.connect("mouse_exited", globals, 'slavetooltiphide')
		newbutton.set_text(i.race + " " + i.sex.capitalize() + " " + i.age.capitalize() + ", Grade: " + i.origins.capitalize())
		newbutton.connect("pressed",self,'selectpartymember',[i])

	var person

	for i in [globals.player.id] + globals.state.playergroup:
		person = globals.state.findslave(i)
		newbutton = get_node("playergroupdetails/TabContainer/Party/HBoxContainer/Button").duplicate()
		get_node("playergroupdetails/TabContainer/Party/HBoxContainer/").add_child(newbutton)
		newbutton.visible = true
		newbutton.set_meta("person", person)
		newbutton.set_text(person.dictionary("$name, HP: ") + str(person.health) + '/' + str(person.stats.health_max)  + ", EN: " + str(round(person.energy)) + '/' + str(person.stats.energy_max))
		newbutton.connect("mouse_entered", globals, 'slavetooltip', [person])
		newbutton.connect("mouse_exited", globals, 'slavetooltiphide')
		newbutton.connect("pressed",self,'selectpartymember',[person])

	for i in globals.state.backpack.stackables:
		var item = globals.itemdict[i]
		newbutton = get_node("playergroupdetails/Panel/TabContainer/Items/VBoxContainer/Button").duplicate()
		get_node("playergroupdetails/Panel/TabContainer/Items/VBoxContainer").add_child(newbutton)
		newbutton.visible = true
		newbutton.get_node("name").set_text(item.name)
		newbutton.set_meta("item", item)
		newbutton.get_node("amount").set_text(str(globals.state.backpack.stackables[i]))
		if item.icon != null:
			newbutton.get_node("icon").set_texture(item.icon)
		newbutton.connect("pressed",self,'itembackpackselect', [item])
	calculateweight()

	for i in ['heal','mindread','invigorate','guidance','mark']:
		var spell = globals.spelldict[i]
		if spell.learned == false:
			continue
		newbutton = get_node("playergroupdetails/Panel/TabContainer/Spells/VBoxContainer/Button").duplicate()
		get_node("playergroupdetails/Panel/TabContainer/Spells/VBoxContainer").add_child(newbutton)
		newbutton.visible = true
		newbutton.get_node("name").set_text(spell.name)
		newbutton.get_node("cost").set_text(str(globals.spells.spellcost(spell)))
		newbutton.set_meta('spell', spell)
		newbutton.connect("pressed",self,'spellbackpackselect',[spell])

	selectpartymember(partyselectedslave)
	if !get_parent().get_node("explorationnode").currentzone.code in ['wimborn','gorn','frostford', 'amberguard'] || globals.resources.gold <= 25:
		get_node("playergroupdetails/return").set_disabled(true)
	else:
		get_node("playergroupdetails/return").set_disabled(false)
	if get_parent().get_node("explorationnode").currentzone.code in ['wimborn','gorn','frostford'] && globals.state.capturedgroup.size() > 0:
		get_node("playergroupdetails/quicksell").set_disabled(false)
	else:
		get_node("playergroupdetails/quicksell").set_disabled(true)
	if !globals.useRalphsTweaks:
		get_node("playergroupdetails/bountysell").set_disabled(true)
		get_node("playergroupdetails/bountysell").set_tooltip("This feature requires enabling Ralph's Tweaks.")
	elif get_parent().get_node("explorationnode").currentzone.code in ['wimborn','gorn','frostford'] && globals.state.capturedgroup.size() > 0:
		get_node("playergroupdetails/bountysell").set_disabled(false)
	else:
		get_node("playergroupdetails/bountysell").set_disabled(true)
	if get_node("playergroupdetails/Panel/TabContainer").get_current_tab() == 1:
		get_node("playergroupdetails/Panel/discardbutton").visible = false
	else:
		get_node("playergroupdetails/Panel/discardbutton").visible = true
	get_node("playergroupdetails").popup()


func selectpartymember(person):
	partyselectedslave = person
	for i in get_node("playergroupdetails/TabContainer/Party/HBoxContainer").get_children() + get_node("playergroupdetails/TabContainer/Captured Slaves/HBoxContainer").get_children():
		if i.get_name() == 'Button' || i.get_meta('person') != person:
			i.set_pressed(false)
		else:
			i.set_pressed(true)
	if backpackselecteditem != null:
		itembackpackselect(backpackselecteditem)
	elif backpackselectedspell != null:
		spellbackpackselect(backpackselectedspell)

func itembackpackselect(item):
	backpackselecteditem = item
	for i in get_node("playergroupdetails/Panel/TabContainer/Items/VBoxContainer").get_children():
		i.set_pressed(i.get_name() != 'Button' && i.get_meta("item") == item)
	get_node("playergroupdetails/Panel/discardbutton").set_disabled(false)
	if item.code in ['bandage','teleportseal'] && partyselectedslave != null:
		get_node("playergroupdetails/Panel/usebutton").set_disabled(false)
	else:
		get_node("playergroupdetails/Panel/usebutton").set_disabled(true)
	var text ='[center]' + item.name + '[/center]\n' + item.description + '\n\nWeight: ' + str(item.weight)
	if item.code == 'teleportseal' && partyselectedslave == globals.player:
		text += '\n\n[color=yellow]You can choose to teleport alone, with your party or with your captured slaves, if you have enough teleport seals. [/color]'
	get_node("playergroupdetails/Panel/itemdescript").set_bbcode(text)

func spellbackpackselect(spell):
	backpackselectedspell = spell
	for i in get_node("playergroupdetails/Panel/TabContainer/Spells/VBoxContainer").get_children():
		i.set_pressed(i.get_name() != 'Button' && i.get_meta("spell") == spell)
	get_node("playergroupdetails/Panel/discardbutton").set_disabled(false)
	var cost = globals.spells.spellcost(spell)
	if spell.code == 'mindread' && partyselectedslave == globals.player:
		get_node("playergroupdetails/Panel/usebutton").set_disabled(true)
	elif globals.resources.mana >= cost:
		if spell.code == 'guidance':
			get_node("playergroupdetails/Panel/usebutton").set_disabled(get_parent().exploration.inencounter)
		elif spell.code == 'mark':
			get_node("playergroupdetails/Panel/usebutton").set_disabled(!get_parent().exploration.currentzone.combat)
		else:
			get_node("playergroupdetails/Panel/usebutton").set_disabled(partyselectedslave == null)
	else:
		get_node("playergroupdetails/Panel/usebutton").set_disabled(true)
	var text ='[center]' + spell.name + '[/center]\n' + spell.description + '\n\nMana Cost: ' + str(cost)
	get_node("playergroupdetails/Panel/itemdescript").set_bbcode(text)


var teleport_seals_used = 0

func teleport_finale():
	main.close_dialogue()
	_on_closegroup_pressed()
	if teleport_seals_used > 0:
		globals.state.backpack.stackables['teleportseal'] -= teleport_seals_used
		globals.main.sound("teleport")
		main.exploration.deeperregion = false
		mansion()
	else:
		playergrouppanel()
		_on_details_pressed()


func teleportseal_player_self():
	teleport_seals_used = 1
	if globals.state.playergroup.empty():
		if globals.state.capturedgroup.empty():
			main.popup("After activating Teleportation Seal, you appear inside of your mansion. ")
		else:
			main.popup("After activating Teleportation Seal, you appear inside of your mansion, leaving your captives behind to free themselves. ")
	else:
		main.popup("After activating Teleportation Seal, you appear inside of your mansion, leaving your party behind. Hopefully they will find a way back in the near future. ")
		var away = round(rand_range(1,3))
		for i in globals.state.playergroup:
			var temp = globals.state.findslave(i)
			temp.away.duration = away
			temp.away.at = 'travel back'
		for temp in globals.state.capturedgroup:
			globals.slaves = temp
			temp.away.duration = away
			temp.away.at = 'transported back'
	globals.state.capturedgroup.clear()
	teleport_finale()


func teleportseal_player_party():
	teleport_seals_used = 1 + globals.state.playergroup.size()
	if globals.state.capturedgroup.empty():
		main.popup("After activating Teleportation Seals, you and your party appear inside of your mansion. ")
	else:
		main.popup("After activating Teleportation Seals, you and your party appear inside of your mansion, leaving your captives behind to free themselves. ")
	globals.state.capturedgroup.clear()
	teleport_finale()


func teleportseal_player_party_slaves():
	teleport_seals_used = 1 + globals.state.playergroup.size() + globals.state.capturedgroup.size()
	if globals.state.playergroup.empty():
		main.popup("After activating Teleportation Seals, you and your new slaves appear inside of your mansion. ")
	else:
		main.popup("After activating Teleportation Seals, you, your party and your new slaves appear inside of your mansion. ")
	teleport_finale()


func teleportseal_player():
	var text = ''
	var buttons = []
	var partysize = globals.state.playergroup.size()
	var capturedsize = globals.state.capturedgroup.size()
	var sealcount = globals.state.backpack.stackables['teleportseal']
	var not_enough_seals = 'You need %d teleport seals for teleporting everyone.'
	var have_seals = 'Use %d teleport seals.'
	teleport_seals_used = 0
	if partysize == 0 and capturedsize == 0:
		teleportseal_player_self()
	else:
		if partysize == 0:
			text = 'You can teleport yourself and leave your captives behind; or you can teleport with all slaves. '
		else:
			if capturedsize == 0:
				text = 'You can teleport yourself and leave your party to find their way back; or you can teleport everyone. '
			else:
				text = 'You can teleport yourself and leave your party to find their way back with slaves; you can teleport yourself and party and leave your captives behind; or you can teleport everyone. '
		buttons.append({text = 'Teleport yourself', function = 'teleportseal_player_self', tooltip = 'Use 1 teleport seal.'})
		if partysize > 0:
			var seals_needed = partysize + 1
			var enabled = sealcount >= seals_needed
			var tip = (have_seals if enabled else not_enough_seals) % seals_needed # Godot ternary operator is: [true] if [condition] else [false]
			buttons.append({text = 'Teleport with party', function = 'teleportseal_player_party', disabled = not enabled, tooltip = tip})
		if capturedsize > 0:
			var seals_needed = partysize + capturedsize + 1
			var enabled = sealcount >= seals_needed
			var tip = (have_seals if enabled else not_enough_seals) % seals_needed # Godot ternary operator is: [true] if [condition] else [false]
			buttons.append({text = 'Teleport everyone', function = 'teleportseal_player_party_slaves', disabled = not enabled, tooltip = tip})
		var dialogue_node = main.get_node("dialogue")
		main.dialogue(true, self, text, buttons)


func useitem(item, person):
	globals.items.person = person
	if item.code == 'teleportseal' and person == globals.player:
		teleportseal_player()
		return
	globals.state.backpack.stackables[item.code] -= 1
	if item.code == 'bandage':
		globals.items.call(item.effect)
	elif item.code == 'teleportseal':
		if person == globals.player:
			assert(false)
		elif globals.slaves.find(person) >= 0:
			get_parent().popup(person.dictionary("After activating Teleportation Seal, $name slowly dissipates in bright sparkles."))
			globals.state.playergroup.erase(person.id)
		else:
			if globals.count_sleepers().jail < globals.state.mansionupgrades.jailcapacity:
				person.sleep = 'jail'
			globals.slaves = person
			globals.state.capturedgroup.erase(person)
			globals.state.backpack.stackables.rope = globals.state.backpack.stackables.get('rope', 0) + globals.state.calcRecoverRope(1)
	playergrouppanel()
	_on_details_pressed()


func usespell(spell, person):
	var text = ''
	globals.spells.person = person
	if spell.code == 'heal':
		text = globals.spells.healeffect()
	elif spell.code == 'invigorate':
		text = globals.spells.invigorateeffect()
	elif spell.code == 'mindread' && person != globals.player:
		text = globals.spells.mindreadeffect()
	elif spell.code == 'guidance':
		text = globals.spells.guidanceeffect()
	elif spell.code == 'mark':
		text = globals.spells.markeffect()
	main.popup(text)
	_on_details_pressed()
	playergrouppanel()


func _on_usebutton_pressed():
	if get_node("playergroupdetails/Panel/TabContainer").get_current_tab() == 0:
		useitem(backpackselecteditem, partyselectedslave)
	else:
		usespell(backpackselectedspell, partyselectedslave)

func _on_discardbutton_pressed():
	var item = backpackselecteditem
	globals.state.backpack.stackables[item.code] -= 1
	get_parent().infotext('Discarded '+item.name,'red')
	_on_details_pressed()

var captureeselected

func selectcaptured(person):
	captureeselected = person
	get_node("playergroupdetails/capturedslave").popup()
	get_node("playergroupdetails/capturedslave/RichTextLabel").set_bbcode(person.description(true))
	get_node("playergroupdetails/capturedslave/capturedteleport").set_disabled(!(globals.state.backpack.stackables.has("teleportseal") && globals.state.backpack.stackables.teleportseal >= 1))

	get_node("playergroupdetails/capturedslave/capturedmindread").set_disabled(globals.resources.mana < globals.spells.spellcost(globals.spelldict.mindread))

func calculateweight():
	var weight = globals.state.calculateweight()
	get_node("playergroupdetails/TextureProgress/Label").set_text("Weight: " + str(weight.currentweight) + '/' + str(weight.maxweight))
	get_node("playergroupdetails/TextureProgress").set_value((weight.currentweight*10/max(weight.maxweight,1)*10))



func _on_closegroup_pressed():
	get_node("playergroupdetails").visible = false


func _on_capturedclose_pressed():
	get_node("playergroupdetails/capturedslave").visible = false

func inspectslave(person):
	get_parent().popup(person.descriptionsmall())

func freecaptured(person):
	partyselectedslave = person
	get_parent().yesnopopup("Free this person?", 'freetrue',self)

func freetrue():
	get_node("playergroupdetails/capturedslave").visible = false
	globals.state.capturedgroup.erase(partyselectedslave)
	get_parent().infotext('You have released '+ partyselectedslave.name, 'yellow')
	globals.state.backpack.stackables.rope = globals.state.backpack.stackables.get('rope', 0) + globals.state.calcRecoverRope(1)
	_on_details_pressed()
	playergrouppanel()

func _on_capturedmindread_pressed():
	get_node("playergroupdetails/capturedslave").visible = false
	globals.spells.person = captureeselected
	globals.main.popup(globals.spells.mindreadeffect())



func _on_quicksell_pressed():
	var text = ''
	var gold = 0
	var array = globals.state.capturedgroup
	globals.state.capturedgroup = []
	var racepricemodchange = 0
	var racepricemod = 1
	for i in array:
		gold += floor(i.sellprice()*globals.expansionsettings.quicksell_slave_pressed)
		#ralph5
		racepricemod = globals.state.racemarketsat[i.race.replace('Halfkin', 'Beastkin')]
		#print("Pricemod for " + i.race + " is " + str(racepricemod))
		racepricemodchange = (racepricemod - 0.5)*0.1 #the bigger the premium the more the premium will be decreased
		racepricemod = clamp(racepricemod - racepricemodchange,0.5,5)
		globals.state.racemarketsat[i.race.replace('Halfkin', 'Beastkin')] = racepricemod
		#print("Sold 1 " + i.race + "   Pricemod decreased " + str(racepricemodchange) + " to " + str(racepricemod))
		#/ralph5
	main.popup('You furtively delivered your captives to the local slaver guild. This earned you [color=yellow]' + str(gold) + '[/color] gold. ')
	globals.state.backpack.stackables.rope = globals.state.backpack.stackables.get('rope', 0) + globals.state.calcRecoverRope(array.size())
	globals.resources.gold += gold
	_on_details_pressed()
	playergrouppanel()

var lowcrime = ["theft","banditry","robbery","smuggling","poaching","assualt","assualt","indecent exposure","vandalism","fraud","threats against one of higher caste","threats upon a member of the guard","defacing a public monument","theft of livestock","harboring an escaped slave","banditry","banditry","banditry","banditry","banditry","banditry","banditry","banditry","aiding and abetting a known fugitive","trespassing","fencing stolen goods","sale of counterfeit potions","impersonating a guard","vagrancy","robbery","robbery","robbery","robbery","theft","theft","theft","theft","obstruction of justice","forgery"]
var midcrime = ["manslaughter","armed robbery","kidnapping","desertion","murder","assualt on a town guard","rape","removal of a slave brand","incitation to rebellion","assault of one of higher caste","impersonating a member of the mage guild"]
var highcrime = ["the rape of a noble","murder most foul","acts of cannibalism","crimes against the mage guild","a long list of truly sickening crimes","crimes against the nobility","the assassination of a prominent merchant","murder of one of higher caste","high treason","mass murder"]

func reputationgain(repgain):
	var location = ''
	if globals.state.location.find("wimborn") >= 0:
		location = 'wimborn'
	elif globals.state.location.find("frostford") >= 0:
		location = 'frostford'
	elif globals.state.location.find("gorn") >= 0:
		location = 'gorn'
	elif globals.state.location.find("amberguard") >= 0:
		location = 'amberguard'
	if location != null:
		globals.state.reputation[location] += repgain

func _on_bountysell_pressed():
	var text = "You turn your captives over to the town guard for whatever bounties may be on their heads.\n"
	var tempname = ""
	var gold = 0
	var repgaincount = 0
	var bountyprice = 0
	var bountycount = 0
	var norewards = true #determines if alt text for no collections is to be used
	var bountycrime = ""
	var location = globals.state.location #ralphD
	var array = []
	var array_lowcrime = []
	var array_midcrime = []
	var array_highcrime = []
	var array_nobounty = []
	var array_citizen = []
	var array_guard = []
	var array_noble = []
	var array_magespecimen = []
	for i in globals.state.capturedgroup:
		array.append(i)
		if i.race_type in [2,4]:
			array_magespecimen.append(i)
		elif i.origins == 'noble': # && !i.race_type in [2,4]:
			array_noble.append(i)
		elif i.npcexpanded.citizen:
			array_citizen.append(i)
		#if i is a guard: #tried to make guards count as citizens instead
			#array_guard.append(i)
		elif rand_range(0,100) <= 2: #0.5
			array_highcrime.append(i)
		elif rand_range(0,100) <= 10: #2.5
			array_midcrime.append(i)
		elif rand_range(0,100) <= 30 && i.origins != 'rich' && i.origins != 'noble': #~10
			array_lowcrime.append(i)
		else:
			array_nobounty.append(i)
	if !array_highcrime.empty():
		for i in array_highcrime:
			tempname = i.name + " " + i.surname
			bountycrime = globals.randomfromarray(highcrime)
			if i.traits.has("Pervert"):
				bountycrime = "multiple counts of necrophilia"
			if i.traits.has("Sadist"):
				bountycrime = "serial rape and torture"
			bountycount += 1
			bountyprice = round(sqrt(i.level)*rand_range(175,500))
			gold += bountyprice
			text += "\nA small crowd gathers as the guards take turns congratulating you on the capture of the infamous [color=aqua]" + str(tempname) + "[/color]."
			text += "\nYou collected the [color=yellow]" + str(bountyprice) + "[/color] gold bounty on [color=aqua]" + str(tempname) + "[/color] for [color=red]" + str(bountycrime) + "[/color]."
			repgaincount += 3
			text += "\n[color=green]Your reputation has improved.[/color]"
			norewards = false
	if !array_midcrime.empty():
		for i in array_midcrime:
			tempname = i.name + " " + i.surname
			bountycrime = globals.randomfromarray(midcrime)
			if i.traits.has("Pervert"):
				bountycrime = "public acts of bestiality"
			if i.traits.has("Sadist"):
				bountycrime = "kidnapping and torture"
			bountycount += 1
			bountyprice = round(sqrt(i.level)*rand_range(40,175))
			gold += bountyprice
			text += "\nYou collected a [color=yellow]" + str(bountyprice) + "[/color] gold bounty on " + str(tempname) + " for [color=red]" + str(bountycrime) + "[/color]."
			repgaincount += 1
			text += "\n[color=green]Your reputation has improved a little.[/color]"
			norewards = false
	if !array_lowcrime.empty():
		for i in array_lowcrime:
			tempname = i.name + " " + i.surname
			bountycrime = globals.randomfromarray(lowcrime)
			bountycount += 1
			bountyprice = round(sqrt(i.level)*rand_range(10,40))
			gold += bountyprice
			text += "\nYou collected a [color=yellow]" + str(bountyprice) + "[/color] gold reward from the guard for turning in " + str(tempname) + " who had a warrant out for [color=red]" + str(bountycrime) + "[/color]."
			norewards = false
	if !array_noble.empty():
		for i in array_noble:
			tempname = i.name + " " + i.surname
			bountyprice = round(sqrt(i.level)*rand_range(125,500))
			gold += bountyprice
			if i.npcexpanded.citizen:
				text += "\nYou collected a [color=yellow]" + str(bountyprice) + "[/color] gold reward from the guard for the safe return of " + str(tempname) + ", who avoids your gaze. It is likely that the " + str(i.surname) + "'s will desire to keep this matter quiet."
			else:
				text += "\nYou collected a [color=yellow]" + str(bountyprice) + "[/color] gold reward from the guard for the safe return of " + str(tempname) + ", who turns away haughtily. There is little doubt that " + str(i.name) + "'s indiscretions will be covered up by House " + str(i.surname) + " or some other noble affiliation."
			norewards = false
	if !array_magespecimen.empty():
		norewards = false
		if array_magespecimen.size() > 1:
			text += "\n\n"
			var count = 0
			var findersfees = 0
			for i in array_magespecimen:
				count += 1
				tempname = i.name + " " + i.surname
				bountyprice = round(i.calculateprice()*0.3*0.9) #equiv to quickselling (ralph modded 0.9 penalty) at slave guild but no influential/slaver boost
				gold += bountyprice
				findersfees += bountyprice
				if count == array_magespecimen.size():
					text += "and " + str(tempname) + " are hooded and led away."
				else:
					text += str(tempname) + ", "
			text += "\nYou collect [color=yellow]" + str(findersfees) + "[/color] gold in finders' fees for the delivery of research specimens in high demand by the mage guild.\n"
		else:
			for i in array_magespecimen:
				tempname = i.name + " " + i.surname
				bountyprice = round(i.calculateprice()*0.3*0.9) #equiv to quickselling (ralph modded 0.9 penalty) at slave guild but no influential/slaver boost
				gold += bountyprice
				text += "\nYou collect a finder's fee of [color=yellow]" + str(bountyprice) + "[/color] gold for the delivery of " + str(tempname) + " as a research specimen for the mage guild.\n"
	if !array_citizen.empty():
		text += "\n\n"
		if array_citizen.size() > 1:
			var count = 0
			for i in array_citizen:
				count += 1
				tempname = i.name + " " + i.surname
				if count == array_citizen.size():
						text += "and " + str(tempname) + " are taken aside by the guards and a hushed lecture ensues. You see horror creep onto their faces as they realize how close to enslavement or worse they had been. The guards make an impression and you doubt if they will ever set foot outside the town walls again.\n"
				else:
						text += str(tempname) + ", "
		else:
			for i in array_citizen:
				tempname = i.name + " " + i.surname
				text += "You collected a no bounty or reward for the safe return of " + str(tempname) + ". A hushed conversation with the guard leaves " + str(i.name) + " with a horrified expression as realization of how close enslavement or worse had been. " + str(i.name) + " decides to leave town and this little misunderstanding is taken care of.\n"
			#text += "Your reputation recovers somewhat."
	if !array_nobounty.empty() && !norewards:
		text += "\nThe rest of your captives are freed and instructed to leave town."
	elif gold > 0:
		text += "\n\nYou collected [color=aqua]" + str(bountycount) + " bounties [/color]and rewards totalling [color=yellow]" + str(gold) + "[/color] gold for this group. "
	else:
		text += "\nThe town guard retains them for questioning, but there is not a single bounty or reward to collect. All the same, you're not likely to see them again."
	main.popup(str(text))
	globals.state.backpack.stackables.rope = globals.state.backpack.stackables.get('rope', 0) + globals.state.calcRecoverRope(array.size()) #ralphA
	globals.resources.gold += gold
	globals.state.bountiescollected[location] += bountycount #ralphD
	reputationgain(repgaincount)
	for i in array: #erase them all so they won't reappear, just like quicksell
		globals.state.capturedgroup.erase(i)
	_on_details_pressed()
#/ralph4

func _on_return_pressed():
	globals.resources.gold -= 25
	mansion()
	get_node("playergroupdetails").visible = false





func _on_outsidetextbox_meta_clicked(meta):
	if meta == 'race':
		get_parent().showracedescript(selectedslave)




func _on_switch_pressed():
	$playergrouppanel/characterinfo/combstats.visible = !$playergrouppanel/characterinfo/combstats.visible
	$playergrouppanel/characterinfo/stats.visible = !$playergrouppanel/characterinfo/stats.visible


func _on_mapbutton_pressed():
	$bigmappanel.visible = !$bigmappanel.visible
	$bigmappanel/ScrollContainer/Control.centermap(main.exploration.currentzone.code)


func _on_mapclose_pressed():
	$bigmappanel.visible = false

var partymemberchosen = null
var execfunc = ''

func chosepartymember(includeplayer = true, targetfunc = [null,null], reqs = 'true', text = ''):
	$choseparty.visible = true
	partymemberchosen = null
	execfunc = targetfunc
	var array = []
	if includeplayer:
		array.append(globals.player)
	if execfunc[1] == "chestmouselockpick":
		for i in globals.state.playergroup:
			if globals.state.findslave(i).race.find('Mouse') >= 0:
				array.append(globals.state.findslave(i))
	else:
		for i in globals.state.playergroup:
			array.append(globals.state.findslave(i))
	for i in $choseparty/HBoxContainer.get_children():
		if i.name != 'Button':
			i.hide()
			i.queue_free()
	$choseparty/RTL.bbcode_text = text

	for i in array:
		var newbutton = $choseparty/HBoxContainer/Button.duplicate()
		$choseparty/HBoxContainer.add_child(newbutton)
		newbutton.show()
		newbutton.get_node("portrait").texture = globals.loadimage(i.imageportait)
		for k in ['sstr','sagi','smaf','send']:
			newbutton.get_node("stats/" + k).text = str(i[k])
		newbutton.get_node("stats/hp").value = (i.health/i.stats.health_max)*100
		newbutton.get_node("stats/hp").hint_tooltip = "Health: " + str(i.health) + "/" + str(i.stats.health_max)
		newbutton.get_node("stats/en").value = (float(i.energy)/i.stats.energy_max)*100
		newbutton.get_node("stats/en").hint_tooltip = "Energy: " + str(round(i.energy)) + "/" + str(i.stats.energy_max)
		newbutton.get_node("Label").text = i.name_short()
		newbutton.connect("mouse_entered", self, "partychoicebuttonenter", [newbutton])
		newbutton.connect("mouse_exited", self, "partychoicebuttonexit", [newbutton])
		newbutton.connect("pressed",self,'partymemberchosen', [i])
		globals.currentslave = i
		if globals.evaluate(reqs) == false:
			newbutton.disabled = true

func partychoicebuttonenter(button):
	if button.get_node("portrait").texture != null:
		get_parent().tween.interpolate_property(button.get_node("portrait"), 'modulate', Color(1,1,1,1), Color(1,1,1,0), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

func partychoicebuttonexit(button):
	if button.get_node("portrait").texture != null:
		get_parent().tween.interpolate_property(button.get_node("portrait"), 'modulate', Color(1,1,1,0), Color(1,1,1,1), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

func partymemberchosen(person):
	partymemberchosen = person
	$choseparty.hide()
	execfunc[0].call(execfunc[1], person)

func _on_chosepartyclose_pressed():
	$choseparty.hide()

func _on_mageorderservices_visibility_changed():
	pass
