
func enemyencounter():
	var enc
	var encmoveto
	var scoutawareness = -1
	var patrol = 'none'
	var text = ''
	var enemyawareness
	enemygear.clear()
	enemygroup.clear()
	inencounter = true
	outside.clearbuttons()
	scoutawareness = calculateawareness()
	if currentzone.encounters.size() > 0:
		for i in currentzone.encounters:
			enc = i[0]
			var condition = i[1]
			var chance = i[2]
			if globals.evaluate(condition) == true && rand_range(0,100) < chance:
				encmoveto = enc
				break
	if encmoveto != null:
		call(enc)
		return
	else:
		for i in currentzone.tags:
			if i in ['wimborn','frostford','gorn','amberguard'] && globals.state.reputation[i] <= -10 && max(10, min(abs(globals.state.reputation[i])/1.2,30)) - scoutawareness/2 > rand_range(0,100):
				if globals.state.reputation[i] <= -25 && rand_range(0,10) > 3:
					buildenemies(i+'guardsmany')
					patrol = 'patrolbig'
					break
				elif globals.state.reputation[i] <= -10:
					buildenemies(i+'guards')
					patrol = 'patrolsmall'
					break
		if enemygroup.empty() == true:
			buildenemies()
#		for i in enemygroup.units:
#			if i.capture == true:
#				buildslave(i)
		if enemygroup.captured != null:
			var group = enemygroup.captured
			enemygroup.captured = []
			for i in group:
				###---Added by Expansion---### NPCs Expanded
				enemygroup.captured.append(buildslave(capturespool[i],false))
				###---End Expansion---###
	enemyawareness = enemygroup.awareness
	if deeperregion == true:
		enemyawareness *= 1.25
	if patrol != 'none':
		text = encounterdictionary(enemygroup.description) + "Your bad reputation around here will certainly lead to a difficult fight..."
		encounterbuttons(patrol)
	elif scoutawareness < enemyawareness:
		ambush = true
		text = encounterdictionary(enemygroup.descriptionambush)
		if enemygroup.special == null:
			encounterbuttons()
		else:
			call(enemygroup.specialambush)
			return
	else:
		ambush = false
		text = encounterdictionary(enemygroup.description)
		if enemygroup.special == null:
			encounterbuttons()
		else:
			call(enemygroup.special)
			return
	mansion.maintext = text
	enemyinfo()

###---Added by Expansion---### NPCs Expanded | Criminal = False and to all buildslave calls
func buildslave(i, criminal = false):
	var race = ''
	var sex = ''
	var age = ''
	var origins = ''
	var rand = 0
	###---Added by Expansion---### NPCs Expanded
	var slavetemp
	var movemod = 0
	var createone = true
	if !globals.state.allnpcs.empty() && !globals.state.offscreennpcs.empty():
		for npc in globals.state.offscreennpcs.duplicate():
			if npc[1] == currentzone.code:
				slavetemp = globals.state.findnpc(npc[0])
				if slavetemp == null:
					globals.state.offscreennpcs.erase(npc)
					continue
				if criminal == true && slavetemp.npcexpanded.reputation >= 0 || criminal == false && slavetemp.npcexpanded.reputation < 0:
					continue
				if slavetemp.movement == 'flying':
					movemod = rand_range(-10,0)
				elif slavetemp.movement == 'crawling':
					movemod = rand_range(0,10)
				elif slavetemp.movement == 'none':
					movemod = rand_range(10,20)
				if rand_range(0,100) <= npc[2] + movemod + globals.expansion.npctrackbonus && createone == true:
					#Add Specific Tracking Support
					if str(globals.expansion.trackednpcid) != str(-1) && str(globals.expansion.trackednpcid) != npc[0]:
						continue
					createone = false
					var dupekiller = globals.state.allnpcs.count(slavetemp)
					while dupekiller > 0:
						globals.state.allnpcs.erase(slavetemp)
						dupekiller -= 1
					globals.state.offscreennpcs.erase(npc)
					#Chance to gain Strength over time
					var upgrade
					if rand_range(0,100) <= globals.expansion.npclevelupchance:
						upgrade = round(rand_range(slavetemp.npcexpanded.timesfought*.5,slavetemp.npcexpanded.timesfought))
					else:
						upgrade = 0
					var levelchance = slavetemp.level + clamp(upgrade,0,1)
					enemylevelup(slavetemp, [slavetemp.level,levelchance])
					break
				else:
					npc[2] += rand_range(0,3)
			else:
				continue
	###---End Expansion---###
	if createone == true:
		if currentzone != null && currentzone.has('races') == false:
			currentzone.races = [['Human', 1]]
		match i.capturerace[0]:
			'area':
				race = globals.weightedrandom(currentzone.races)
	
			'any':
				race = globals.allracesarray[rand_range(0,globals.allracesarray.size())]
	
			'bandits':
				if rand_range(0,100) <= variables.banditishumanchance:
					race = 'Human'
				else:
	
					race = globals.getracebygroup('bandits') #globals.banditraces[rand_range(0,globals.banditraces.size())]
	
			'amberguard', 'wimborn', 'frostford', 'gorn':
				race = globals.weightedrandom( guardRaces[ i.capturerace[0] ] )
			_:
				race = globals.weightedrandom(i.capturerace)
		race = globals.checkfurryrace(race)
		
	
		if i.capturesex.find('any') >= 0:
			sex = 'random'
		else:
			sex = globals.weightedrandom(i.capturesex)
		age = globals.weightedrandom(i.captureagepool)
		origins = globals.weightedrandom(i.captureoriginspool)
		if deeperregion == true && globals.originsarray.find(origins) < 4 && randf() > 0.3:
			origins = globals.originsarray[globals.originsarray.find(origins)+1]
	
		slavetemp = globals.newslave(race, age, sex, origins)
	#	var slavetemp = globals.newslave(race, age, sex, origins)
	
		enemylevelup(slavetemp, currentzone.levelrange)
		
		if criminal == true:
			slavetemp.npcexpanded.citizen = false
	
	if slavetemp == null:
		return buildslave(i, criminal)
	globals.expansion.updatePerson(slavetemp)
	###---End Expansion---###
	
	slavetemp.health = slavetemp.stats.health_max
	i.capture = slavetemp
	
	if i.has('gear'):

		for k in ['armor','weapon','costume','underwear','accessory']:
			if k == 'armor' && rand_range(1, 4) >= globals.player.level:
				continue
			if !combatdata.enemyequips[i.gear].has(k):
				continue
			var item = globals.weightedrandom(combatdata.enemyequips[i.gear][k])
			if item == 'nothing':
				continue
			var enchant = false


			if item.ends_with("+"):
				enchant = true
				item = item.replace("+","")
			item = globals.items.createunstackable(item)
			if enchant:
				globals.items.enchantrand(item)
			enemygear[item.id] = item
			globals.items.equipitem(item.id, slavetemp, true)
		slavetemp.health = 10 #update max health
		slavetemp.health = slavetemp.stats.health_max
	return slavetemp

###---Added by Expansion---### Ank BugFix v4a
func enemyinfo():
	var text = ''
	if enemygroup.units.size() <= 3:
		text = "Number: " + str(enemygroup.units.size())
	else:
		text = "Estimate number: " + str(max(round(enemygroup.units.size() + rand_range(-2,2)),3))
	var total = 0
	for i in enemygroup.units:
		if i.capture != null:
			total += i.capture.level
		elif deeperregion:
			total += ceil(i.level * 1.3)
		else:
			total += i.level
	text += "\nEstimated level: " + str(max(1,round(total/enemygroup.units.size()) + round(rand_range(-1,1))))
	var firstEnemy = enemygroup.units[0]
	text += '\nGroup: ' + firstEnemy.faction
	if enemygroup.captured != null && enemygroup.captured.size() >= 1:
		text += "\n\nHave other persons involved. "
	if firstEnemy.capture != null && firstEnemy.capture.sex != 'male' && firstEnemy.has('iconalt'):
		outside.get_node("textpanelexplore/enemyportrait").set_texture(firstEnemy.iconalt)
	else:
		outside.get_node("textpanelexplore/enemyportrait").set_texture(firstEnemy.icon)
	outside.get_node("textpanelexplore/enemyinfo").set_bbcode(text)
###---End Expansion---###

func enemyinfoclear():
	outside.get_node("textpanelexplore/enemyportrait").set_texture(null)
	outside.get_node("textpanelexplore/enemyinfo").set_bbcode('')

func enemylevelup(person, levelarray):
	var level = round(rand_range(levelarray[0], levelarray[1]))
	var statdict = ['sstr','sagi','smaf','send']
	var skillpoints = abs(level-person.level)*variables.skillpointsperlevel
	while skillpoints > 0 && statdict.size() > 0:
		var tempstat = statdict[randi()%statdict.size()]
		#slaves can be constructed with levels greater than they will recieve for the region of encounter
		if person.level < level:
			if randf() <= 0.2:
				person.skillpoints += 1
			elif person.stats[globals.maxstatdict[tempstat].replace('_max',"_base")] >= person.stats[globals.maxstatdict[tempstat]]:
				statdict.erase(tempstat)
				continue
			else:
				person.stats[globals.maxstatdict[tempstat].replace('_max',"_base")] += 1
		elif person.stats[globals.maxstatdict[tempstat].replace('_max',"_base")] <= 0:
			statdict.erase(tempstat)
			continue
		else:
			person.stats[globals.maxstatdict[tempstat].replace('_max',"_base")] -= 1
		skillpoints -= 1
	if skillpoints > 0 && statdict.empty():
		if person.level < level:
			person.skillpoints += skillpoints
		else:
			person.skillpoints = max(person.skillpoints - skillpoints, 0)
	person.level = level
	person.health = person.stats.health_max

func buildenemies(enemyname = null):
	if enemyname == null:
		enemygroup = enemygrouppools[globals.weightedrandom(currentzone.enemies)].duplicate()
	else:
		enemygroup = enemygrouppools[enemyname].duplicate()
	var tempunits = enemygroup.units.duplicate()
	var unitcounter = {}
	enemygroup.units = []
	var addnumbers
	for i in tempunits:
		addnumbers = false
		var count = round(rand_range(i[1], i[2]))
		if deeperregion && (enemyname == null || enemyname.find("guards") >= 0):
			count = round(count * rand_range(1.2,1.6))
		if count >= 2:
			addnumbers = true
		while count >= 1:
			var newunit = enemypool[i[0]].duplicate()
			if unitcounter.has(newunit.name) == false:
				unitcounter[newunit.name] = 1
			else:
				unitcounter[newunit.name] += 1
			if addnumbers:
				newunit.name = newunit.name + " " + str(unitcounter[newunit.name])
			enemygroup.units.append(newunit)
			count -= 1
	for i in enemygroup.units:
		if i.capture == true:
			###---Added by Expansion---### NPCs Expanded
			buildslave(i,true)
			###---End Expansion---###

func encounterbuttons(state = null):
	var array = []
	if state == null:
		if ambush == false:
			array.append({name = "Attack",function = "enemyfight"})
			array.append({name = "Leave", function = "enemyleave"})
		else:
			array.append({name = "Fight",function = "enemyfight"})
	elif state in ['patrolsmall', 'patrolbig']:
		array.append({name = "Fight",function = "enemyfight"})
		var dict = {}
		if state == 'patrolsmall':
			dict = {name = "Bribe with 100 gold", args = 100, function = 'patrolbribe'}
			if globals.resources.gold < 100 :
				dict.disabled = true
		elif state == 'patrolbig':
			dict = {name = "Bribe with 300 gold", args = 300, function = 'patrolbribe'}
			if globals.resources.gold < 300 :
				dict.disabled = true
		array.append(dict)
	outside.buildbuttons(array, self)

func patrolbribe(sum):
	var array = []
	globals.resources.gold -= sum
	array.append({name = "Leave", function = "enemyleave"})
	mansion.maintext = "You bribe Patrol's leader and hastily escape from the scene. "
	outside.buildbuttons(array, self)


##############


var treasuremisc = [['magicessenceing',7],['taintedessenceing',7],['natureessenceing',7],['bestialessenceing',7],['fluidsubstanceing',7],['gem',1],['claritypot',0.5],['regressionpot',1],['youthingpot',2],['maturingpot',2]]

###---Added by Expansion---### ElPresidente Items
var chestloot = {
	easy = ['armorleather','armorchain','weapondagger','weaponsword','clothsundress','clothmaid','clothbutler','armorpadded','weaponclaymore'],
	medium = ['armorchain','weaponsword','clothsundress','clothmaid','clothbutler', 'armorelvenchain','armorrobe', 'weaponhammer','weapongreatsword','clothkimono','clothpet','clothmiko','clothbedlah','accgoldring','accslavecollar','acchandcuffs','acctravelbag','weaponancientsword','accelvenboots'],
	hard = ['armorplate','accamuletemerald','accamuletruby','armorelvenhalfplate','armorhalfplate','armorfieldplate','weaponrunesword','armormagerobe','accbooklife'],
}
###---End Expansion---###


var chest = {strength = 0, agility = 0, treasure = {}, trap = ''}
var selectedpartymember = null
var chestaction = ''

func getchestlevel():
	var level = rand_range(currentzone.levelrange[0], currentzone.levelrange[1])
	if level < 5:
		level = 'easy'
		chest.strength = round(rand_range(1,3))
		chest.agility = round(rand_range(1,3))
	elif level < 10:
		level = 'medium'
		chest.strength = round(rand_range(3,5))
		chest.agility = round(rand_range(3,5))
	else:
		level = 'hard'
		chest.strength = round(rand_range(5,8))
		chest.agility = round(rand_range(5,8))
	return level

func treasurechest():
	var level = getchestlevel()
	treasurechestgenerate(level)
	var text = "You found a hidden [color=yellow]chest[/color]. However, it seems to be locked and is too heavy to carry with you. "
	treasurechestoptions(text)
	text = "Chest\nDifficulty level: [color=aqua]" + level.capitalize() + '[/color]\n\nStrength : ' + str(chest.strength) + '\nComplexity: ' + str(chest.agility)
	outside.get_node("textpanelexplore/enemyportrait").set_texture(load("res://files/buttons/chest.png"))
	outside.get_node("textpanelexplore/enemyinfo").set_bbcode(text)


func chestselectslave(action):
	chestaction = action
	var reqs = ''
	var text = ''
	if chestaction == 'chestlockpick':
		reqs = 'person.energy >= 5'
		text = 'Lock difficulty: ' + str(chest.agility)
	else:
		reqs = 'person.energy >= 20'
		text = 'Lock strength: ' + str(chest.strength)
	outside.chosepartymember(true, [self,chestaction], reqs, text)#func chosepartymember(includeplayer = true, targetfunc = [null,null], reqs = 'true'):


func treasurechestoptions(text = ''):
	var array = []
	mansion.maintext = text
	array.append({name = 'Use a lockpick (5 energy)', function = 'chestselectslave', args = 'chestlockpick'})
	if !globals.state.backpack.stackables.has("lockpick"):
		array.back().disabled = true
	array.append({name = 'Crack it open (20 energy)', function = 'chestselectslave', args = 'chestbash'})
	array.append({name = "Leave", function = 'enemyleave'})
	outside.buildbuttons(array, self)



func treasurechestgenerate(level = 'easy'):
	var gear = {number = 0, enchantchance = 0 }
	var misc = 0
	var text
	var miscnumber = 1
	if level == 'easy':
		gear.number = round(rand_range(1,2))
		gear.enchantchance = 45
		misc = round(rand_range(0,1))
		miscnumber = [1,2]
	elif level == 'medium':
		gear.number = round(rand_range(1,4))
		gear.enchantchance = 55
		misc = round(rand_range(0,2))
		miscnumber = [1,3]
	elif level == 'hard':
		gear.number = round(rand_range(2,4))
		gear.enchantchance = 65
		misc = round(rand_range(1,3))
		miscnumber = [1,4]
	var gearpool = chestloot[level]
	if level == 'hard':
		gearpool = chestloot.medium+chestloot.hard
	winscreenclear()
	generaterandomloot(gearpool, gear, misc, miscnumber)

func chestlockpick(person):
	var unlock = false
	var text = ''
	person.energy -= 5
	globals.state.backpack.stackables.lockpick -= 1
	if person.sagi >= chest.agility:
		unlock = true
		text = "$name skillfully picks the lock on the chest."
	else:
		if 60 - (chest.agility - person.sagi) * 10 >= rand_range(0,100):
			text = "With some luck, $name manages to pick the lock on the chest. "
			unlock = true
		else:
			text = "$name fails to pick the lock and breaks the lockpick. "
			unlock = false
	
	text = person.dictionary(text)
	if unlock == false:
		outside.playergrouppanel()
		treasurechestoptions(text)
	else:
		showlootscreen(text)

func chestbash(person):
	var unlock = false
	var text = ''
	person.energy -= 20
	if person.sstr >= chest.strength:
		unlock = true
		text = "$name easily smashes the chest's lock mechanism."
	else:
		if 60 - (chest.strength - person.sstr) * 10 >= rand_range(0,100):
			text = "With some luck, $name manages to crack the chest open. "
			unlock = true
		else:
			text = "[color=yellow]$name seems to be too weak to break the chest open. [/color]"
			unlock = false
	
	text = person.dictionary(text)
	if unlock == false:
		outside.playergrouppanel()
		treasurechestoptions(text)
	else:
		showlootscreen(text)





###################

func blockedsection():
	var array = []
	
	mansion.maintext = "You found a hidden [color=yellow]section[/color] covered in thick roots. "
	if globals.state.backpack.stackables.has("torch"):
		array.append({name = "Use a torch", function = 'blockedsectionopen'})
	else:
		array.append({name = "Use a torch", function = 'blockedsectionopen', tooltip = 'You have no torches with you',disabled = true})
	
	array.append({name = "Leave", function = 'enemyleave'})
	outside.buildbuttons(array, self)

func blockedsectionopen():
	var gear = {number = round(randf()*3), enchantchance = 75 }
	var misc = rand_range(1,4)
	var text
	var miscnumber = [1,3]
	var loottable = chestloot.medium
	globals.state.backpack.stackables.torch -= 1
	text = "After roots burn down you discover a hidden stash."
	if gear.number == 0:
		gear.number = 1
	winscreenclear()
	generaterandomloot(loottable, gear, misc, miscnumber)
	showlootscreen(text)

func generateloot(loot = [], text = ''):
	var winpanel = get_node("winningpanel")
	var tempitem
	var enchant
	for i in winpanel.get_node("ScrollContainer/VBoxContainer").get_children():
		if i != winpanel.get_node("ScrollContainer/VBoxContainer/Button"):
			i.visible = false
			i.free()
	enchant = false
	var item = loot[0]
	if item.findn('+') >= 0:
		enchant = true
		item = item.replace("+","")
	if globals.itemdict[item].type == 'gear':
		var counter = loot[1]
		while counter > 0:
			tempitem = globals.items.createunstackable(item)
			if enchant:
				globals.items.enchantrand(tempitem)
			enemyloot.unstackables.append(tempitem)
			counter -= 1
	else:
		enemyloot.stackables[loot[0]] = loot[1]
	
	showlootscreen()

func generaterandomloot(loottable = [], gear = {number = 0, enchantchance = 0}, misc = 0, miscnumber = [0,0]):
	var tempitem
	while gear.number > 0:
		gear.number -= 1
		tempitem = globals.items.createunstackable(loottable[randi()%loottable.size()])
		if randf() <= float(gear.enchantchance)/100:
			globals.items.enchantrand(tempitem)
		enemyloot.unstackables.append(tempitem)
	while misc > 0:
		misc -= 1
		tempitem = globals.weightedrandom(treasuremisc)
		if enemyloot.stackables.has(tempitem):
			enemyloot.stackables[tempitem] += round(rand_range(miscnumber[0], miscnumber[1]))
		else:
			enemyloot.stackables[tempitem] = round(rand_range(miscnumber[0], miscnumber[1]))
	
	#showlootscreen()

func showlootscreen(text = ''):
	var winpanel = get_node("winningpanel")
	for i in winpanel.get_node("ScrollContainer/VBoxContainer").get_children():
		if i.name != "Button":
			i.visible = false
			i.free()
	winpanel.visible = true
	winpanel.get_node("wintext").set_bbcode(text)
	builditemlists()





func banditcamp():
	globals.get_tree().get_current_scene().get_node('outside').clearbuttons()
	newbutton = button.duplicate()
	buttoncontainer.add_child(newbutton)
	newbutton.set_text('Attack them')
	newbutton.visible = true
	newbutton.connect("pressed",self,'enemyfight')
	newbutton = button.duplicate()
	buttoncontainer.add_child(newbutton)
	newbutton.set_text('Ignore them')
	newbutton.visible = true
	newbutton.connect("pressed",self,'enemyleave')

func slaversenc(stage = 0):
	var state = false
	var buttons = []
	var image
	var sprites = []
	if stage == 0:
		if enemygroup.units.size() < 4:
			mansion.maintext = "You spot a small group of slavers escorting a captured person. "
		else:
			mansion.maintext = "You come across a considerable group of slavers escorting a few capturees. "
		buttons.append({name = 'Attack Slavers', function = 'slaversenc', args = 1})
		buttons.append({name = 'Greet Slavers',function = 'slaversenc',args = 2})
		buttons.append({name = 'Leave',function = 'enemyleave'})
		outside.mindread = false
	elif stage == 1:
		enemyfight()
		return
	elif stage == 2:
		mansion.maintext = "You greet the group of slavers and they offer you to check their freshly acquired merchandise. "
		buttons.append({name = 'Fight Slavers', function = 'slaversenc', args = 1})
		buttons.append({name = 'Check Victims',function = 'slaversenc',args = 4})
		buttons.append({name = 'Leave',function = 'enemyleave'})
	elif stage == 3:
		progress += 1
		zoneenter(currentzone.code)
	elif stage == 4:
		outside.get_node("playergrouppanel/VBoxContainer").visible = false
		globals.main.get_node("outside").slavearray = enemygroup.captured
		globals.main.get_node("outside").slaveguildslaves('slavers')
	outside.buildbuttons(buttons,self)
	#globals.main.dialogue(state, self, text, buttons, sprites)
	
#func slaverwin():
#	var state = false
#	var text = ''
#	var buttons = []
#	var sprites = []
#	text = textnode.SlaverWin1
#	globals.main.dialogue(state, self, text, buttons, sprites)
	
func merchantencounter(stage = 0):
	var state = false
	var text = ''
	var buttons = []
	var image
	var sprites = []
	if stage == 0:
		text = ""
		buttons.append({text = 'Trade',function = 'merchantencounter',args = 1})
		buttons.append({text = 'Ignore',function = 'merchantencounter',args = 2})
	elif stage == 1:
		globals.main.get_node("outside").shopinitiate('outdoor')
		globals.main.get_node("outside").shopbuy()
		globals.main.close_dialogue()
		return
	elif stage == 2:
		globals.main.close_dialogue()
		return
	globals.main.dialogue(state, self, text, buttons, sprites)
#-----------------------------------------------------------------------


func slaversgreet():
	globals.get_tree().get_current_scene().get_node('outside').clearbuttons()
	globals.get_tree().get_current_scene().get_node('outside').maintext = globals.player.dictionary("You reveal yourself to the slavers' group and wonder if they'd be willing to part with their merchandise saving them hassle of transportation.\n\n- You, $sir, know how to bargain. We'll agree to part with our treasure here for ")+str(max(round(enemygroup.captured.buyprice()*0.7),40))+" gold.\n\nYou still might try to take their hostage by force, but given they know about your presence, you are at considerable disadvantage. "
	newbutton = button.duplicate()
	buttoncontainer.add_child(newbutton)
	newbutton.set_text('Inspect')
	newbutton.visible = true
	newbutton.connect("pressed",self,'inspectenemy')
	newbutton = button.duplicate()
	buttoncontainer.add_child(newbutton)
	newbutton.set_text('Agree on the deal')
	newbutton.visible = true
	newbutton.connect("pressed",self,'slaverbuy')
	if globals.resources.gold < max(round(enemygroup.captured.buyprice()*0.7),40):
		newbutton.set_disabled(true)
		newbutton.set_tooltip("You don't have enough gold.")
	if globals.spelldict.mindread.learned == true:
		newbutton = button.duplicate()
		buttoncontainer.add_child(newbutton)
		newbutton.set_text('Cast Mindread to check personality')
		newbutton.visible = true
		newbutton.connect("pressed",self,'mindreadcapturee', ['slavers'])
		if globals.spells.spellcost(globals.spelldict.mindread) > globals.resources.mana:
			newbutton.set_disabled(true)
	newbutton = button.duplicate()
	buttoncontainer.add_child(newbutton)
	newbutton.set_text('Fight')
	newbutton.visible = true
	newbutton.connect("pressed",self,'enemyfight')
	newbutton = button.duplicate()
	buttoncontainer.add_child(newbutton)
	newbutton.set_text('Refuse and leave')
	newbutton.visible = true
	newbutton.connect("pressed",self,'enemyleave')

func snailevent():
	var array = []
	mansion.maintext = "You come across a humongous snail making its way through the trees. It makes you remember hearing how you could use it for farming additional income but you will likely need to sacrifice some food to tame it first. "
	if globals.resources.food >= 200:
		array.append({name = 'Feed Snail (200 food)', function = 'snailget'})
	else:
		array.append({name = 'Feed Snail (200 food)', function = 'snailget', disabled = true, tooltip = "not enough food"})
	array.append({name = "Ignore it", function = "zoneenter", args = 'grove'})
	outside.buildbuttons(array,self)

func snailget():
	globals.resources.food -= 200
	globals.state.snails += 1
	main.popup("You've brought a giant snail back with you and left it at your farm. ")
	main._on_mansion_pressed()

func slaverbuy():
	globals.resources.gold -= max(round(enemygroup.captured.buyprice()*0.7),30)
	#enemycapture()
	globals.get_tree().get_current_scene().popup("You purchase slavers' captive and return to the mansion. " )

func inspectenemy():
	globals.get_tree().get_current_scene().popup(enemygroup.captured.descriptionsmall())

func mindreadcapturee(state = 'encounter'):
	globals.spells.person = enemygroup.captured
	globals.main.popup(globals.spells.mindreadeffect())
	if state == 'win':
		enemydefeated()
	elif state == 'slavers':
		slaversgreet()
	else:
		encounterbuttons()


func enemyleave():
	progress += 1.0
	var text = ''
	globals.player.energy -= max(5-floor((globals.player.sagi+globals.player.send)/2),1)
	for i in globals.state.playergroup:
		var person = globals.state.findslave(i)
		person.energy -= max(5-floor((person.sagi+person.send)/2),1)
	zoneenter(currentzone.code)
	if text != '':
		mansion.maintext = mansion.maintext +'\n[color=yellow]'+text+'[/color]'

func enemyfight(soundkeep = false):
	mansion.maintext = ''
	outside.clearbuttons()
	main.get_node("combat").currentenemies = enemygroup.units
	main.get_node('combat').area = currentzone
	main.get_node('combat').enemygear = enemygear
	main.get_node("combat").start_battle(soundkeep)


func winscreenclear():
	var winpanel = get_node("winningpanel")
	defeated = {units = [], names = [], select = [], faction = []}
	enemyloot = {stackables = {}, unstackables = []}
	for i in winpanel.get_node("ScrollContainer/VBoxContainer").get_children():
		if i != winpanel.get_node("ScrollContainer/VBoxContainer/Button"):
			i.visible = false
			i.free()
	winpanel.get_node("ScrollContainer").visible = false
	winpanel.get_node("Panel").visible = false
	main.checkplayergroup()

func enemydefeated():
	if launchonwin != null:
		globals.events.call(launchonwin)
		launchonwin = null
		return
	var text = 'You have defeated the enemy group!\n'
	var ranger = false
	for i in globals.state.playergroup:
		if globals.state.findslave(i).spec == 'ranger':
			ranger = true
	winscreenclear()
	enemyinfoclear()
	capturedtojail = 0
	#Fight rewards
	var winpanel = get_node("winningpanel")
	var goldearned = 0
	###---Added by Expansion---### NPCs Expanded
	var stolengold = 0
	var reputation = 0
	var status = ''
	###---End Expansion---###
	var expearned = 0
	var questitem = false
	for unit in enemygroup.units:
		if unit.state == 'escaped':
			###---Added by Expansion---### NPCs Expanded
			var baddie = unit.capture
			baddie.npcexpanded.timesmet += 1
			baddie.npcexpanded.timesfought += 1
			baddie.npcexpanded.timesescaped += 1
			baddie.npcexpanded.citizen = false
			var reencounterchance = globals.expansion.enemyreencounterchanceescape + round(rand_range(-globals.expansion.enemyreencountermodifier,globals.expansion.enemyreencountermodifier))
			globals.state.allnpcs = baddie
			#globals.state.npclastlocation.append([currentzone.code, baddie.id, reencounterchance])
			#Check is because the citizen will be altered elsewhere before and removed from above later
			if baddie.npcexpanded.citizen == true:
				reputation += round(rand_range(1,5)) + globals.originsarray.find(baddie.origins)
				status = 'citizen'
			else:
				reputation -= round(rand_range(1,5) + rand_range(-globals.originsarray.find(baddie.origins), globals.originsarray.find(baddie.origins)))
				status = 'criminal'
			globals.state.offscreennpcs.append([baddie.id, currentzone.code, reencounterchance, 'escaping', reputation, status])
			###---End Expansion---###
			expearned += unit.rewardexp*0.66
			continue
		if unit.capture != null:
			###---Added by Expansion---### NPCs Expanded | Set Base Metrics
			unit.capture.npcexpanded.timesmet += 1
			unit.capture.npcexpanded.timesfought += 1
			unit.capture.npcexpanded.citizen = false
			stolengold += unit.capture.npcexpanded.possessions.gold
			unit.capture.npcexpanded.possessions.gold = 0
			###---End Expansion---###
			defeated.units.append(unit.capture)
			defeated.names.append(unit.name)
			defeated.select.append(0)
			defeated.faction.append(unit.faction)
			for i in unit.capture.gear.values():
				if i != null:
					###---Added by Expansion---### Fix items flipping out on NPCs
					if globals.state.unstackables.has(i):
						globals.items.unequipitemraw(globals.state.unstackables[i],unit.capture)
						enemyloot.unstackables.append(globals.state.unstackables[i])
					else:
						globals.items.unequipitemraw(enemygear[i],unit.capture)
						if randf() * 100 <= variables.geardropchance:
							enemyloot.unstackables.append(enemygear[i])
					###---End Expansion---###
		var rewards = unit.rewardpool
		if int(globals.state.sidequests.ayda) == 14 && currentzone.code == 'gornoutskirts' && questitem == false && globals.itemdict.aydajewel.amount == 0:
			rewards = rewards.duplicate(true)
			rewards.aydajewel = 5
			questitem = true
		for i in rewards:
			var chance = rewards[i]
			var bonus = 1
			if ranger == true:
				bonus += 0.4
			if deeperregion:
				bonus += 0.25
			if globals.state.spec == "Hunter":
				bonus += 0.2
			chance = chance*bonus
			if rand_range(0,100) <= chance:
				if i == 'gold':
					var gold = round(rand_range(unit.rewardgold[0], unit.rewardgold[1]))
					if globals.state.spec == 'Hunter':
						gold *= 2
					goldearned += gold
				else:
					var enchant = false
					if i.ends_with("+"):
						enchant = true
						i = i.replace("+","")
					if globals.itemdict.has(i):
						var item = globals.itemdict[i]
						if item.type != 'gear':
							if enemyloot.stackables.has(item.code):
								enemyloot.stackables[item.code] += 1
							else:
								enemyloot.stackables[item.code] = 1
						else:
							var tempitem = globals.items.createunstackable(item.code)
							if enchant:
								globals.items.enchantrand(tempitem)
							enemyloot.unstackables.append(tempitem)
		expearned += unit.rewardexp
	if deeperregion:
		expearned *= 1.2
	expearned = round(expearned)
	###---Added by Expansion---### NPCs Expanded
	globals.resources.gold += stolengold
	###---End Expansion---###
	globals.resources.gold += goldearned
	text += '\nYou have received a total sum of [color=yellow]' + str(round(goldearned)) +'[/color] pieces of gold and [color=aqua]' + str(expearned) + '[/color] experience points. \n'
	###---Added by Expansion---### NPCs Expanded
	text += "You also found a total of [color=yellow]" + str(round(stolengold)) + "[/color] pieces of gold hidden in the pockets, boots, and various orifaces of your victims.\n"
	###---End Expansion---###
	globals.player.xp += round(expearned/(globals.state.playergroup.size()+1))
	for i in globals.state.playergroup:
		var person = globals.state.findslave(i)
		person.xp += round(expearned/(globals.state.playergroup.size()+1))
		if person.levelupreqs.has('code') && person.levelupreqs.code == 'wincombat':
			person.levelup()
			text += person.dictionary("[color=green]Your decisive win inspired $name, and made $him unlock new potential.[/color] \n")
		if person.health > person.stats.health_max/1.3:
			person.cour += rand_range(1,3)
	
	
	if defeated.units.size() > 0:
		text += 'Your group gathers defeated opponents in one place for you to decide what to do about them. \n'
		###---Added by Expansion---### Quick Strip/Sizing Support
		for i in defeated.units:
			globals.expansion.quickStrip(i)
		text += "You quickly strip off all of their clothing so you can see the potential merchandise you have gained. \n"
		###---End Expansion---###
	if enemygroup.captured != null:
		text += 'You are also free to decide what you wish to do with bystanders, who were in possession of your opponents. \n'
		for i in enemygroup.captured:
			###---Added by Expansion---### NPCs Expanded | Set Base Metrics
			i.npcexpanded.timesmet += 1
			i.npcexpanded.timesrescued += 1
			###---End Expansion---###
			defeated.units.append(i)
			defeated.names.append('Captured')
			defeated.select.append(0)
			defeated.faction.append('stranger')
	###---Added by Expansion---### NPCs Expanded | Baby && Noncombatants Support
	var extranpcs = 0
	var npc2
	var latetext = ""
	for npc in defeated.units:
		if !npc.npcexpanded.possessions.noncombatants.empty():
			for npc2id in npc.npcexpanded.possessions.noncombatants:
				extranpcs += 1
				npc2 = globals.state.findnpc(npc2id)
				npc.npcexpanded.possessions.noncombatants.erase(npc2id)
				latetext += npc2.dictionary("$race $child")
				if extranpcs > 1:
					latetext += ", "
				else:
					latetext += " "
				defeated.units.append(npc2)
				defeated.names.append('Innocent Bystander')
				defeated.select.append(0)
				defeated.faction.append('stranger')
	if extranpcs > 0:
		text += "You are surprised to see "
		if extranpcs > 1:
			text += "several others uncertainly coming toward you. "
		else:
			text += "someone else warily coming toward you. "
		
		if extranpcs > 1:
			text += " A " + latetext + " all walk closer, glancing over at your gathered victims.\n "
			text += "[color=yellow]-We are with them. What are you going to do to us?.\n"
		else:
			text += " A " + latetext + " walks closer, glancing over at your gathered victims.\n "
			text += "[color=yellow]-I...I'm with them.\n"
	###---End Expansion---###
	
	winpanel.get_node("ScrollContainer").visible = true
	winpanel.get_node("Panel").visible = true
	
	winpanel.visible = true
	winpanel.get_node("wintext").set_bbcode(text)
	for i in range(0, defeated.units.size()):
		var person = defeated.units[i]
		if globals.races[person.race.replace("Halfkin", "Beastkin")].uncivilized && person.spec != 'tamer':
			person.add_trait('Uncivilized')
		person.stress += rand_range(20, 50)
		person.obed += rand_range(10, 20)
		person.health -= rand_range(40,70)
		if defeated.names[i] == 'Captured':
			person.obed += rand_range(10,20)
			person.loyal += rand_range(5,15)
	buildcapturelist()
	builditemlists()
	
	if globals.state.sidequests.cali == 18 && defeated.names.find('Bandit 1') >= 0 && currentzone.code == 'forest':
		main.popup("One of the defeated bandits in exchange for their life reveals the location of their camp you've been searching for. ")
		globals.state.sidequests.cali = 19

func captureeffect(person):
	
	var effect = globals.effectdict.captured
	var dict = {'slave':0.7, 'poor':1,'commoner':1.2,"rich": 2, "noble": 4}
	###---Added by Expansion---### NPCs Expanded
	person.npcexpanded.enslavedby == globals.player.name_long()
	###---End Expansion---###
	person.fear += rand_range(30, 25+person.cour/4)
	effect.duration = round((4 + (person.conf+person.cour)/20) * dict[person.origins])
	person.add_effect(effect)
	globals.state.capturedgroup.append(person)

func _on_confirmwinning_pressed(): #0 leave, 1 capture, 2 rape, 3 kill
	var text = ''
	var selling = false
	var sellyourself = false
	var orgy = false
	var orgyarray = []
	var location
	var reward = false
	var killed = false
	if currentzone.tags.find("wimborn") >= 0:
		location = 'wimborn'
	elif currentzone.tags.find("frostford") >= 0:
		location = 'frostford'
	elif currentzone.tags.find("gorn") >= 0:
		location = 'gorn'
	elif currentzone.tags.find("amberguard") >= 0:
		location = 'amberguard'
	else:
		location = 'wimborn'
	for i in range(0, defeated.units.size()):
		###---Added by Expansion---### NPCs Expanded
		var reputation = 0
		var status = ""
		###---End Expansion---###
		if defeated.faction[i] in ['stranger','elf'] && defeated.names[i] != "Captured":
			globals.state.reputation[location] -= 1
		if defeated.select[i] == 0:
			if defeated.names[i] != 'Captured':
				###---Added by Expansion---### NPCs Expanded and Ank BugFix v4
				text += defeated.units[i].dictionary("You have left the $race $child alone.\n")
				var baddie = defeated.units[i]
				baddie.npcexpanded.timesreleased += 1
				baddie.npcexpanded.lastevent = 'fought'
				var reencounterchance = globals.expansion.enemyreencounterchancerelease + round(rand_range(-globals.expansion.enemyreencountermodifier,globals.expansion.enemyreencountermodifier))
				#globals.state.npclastlocation.append([currentzone.code, baddie.id, reencounterchance])
				if baddie.npcexpanded.citizen == true:
					reputation = round(rand_range(1,5)) + globals.originsarray.find(baddie.origins)
					status = 'citizen'
				else:
					reputation = -round(rand_range(1,5) + rand_range(-globals.originsarray.find(baddie.origins), globals.originsarray.find(baddie.origins)))
					status = 'criminal'
				globals.state.allnpcs = baddie
				globals.state.offscreennpcs.append([baddie.id, currentzone.code, reencounterchance, 'defeated', reputation, status])
				###---End Expansion---###
			else:
				text += defeated.units[i].dictionary("You have released the $race $child. $His life is $his own.\n")
				###---Added by Expansion---### Category: Better NPCs
				var baddie = defeated.units[i]
				baddie.npcexpanded.timesreleased += 1
				baddie.npcexpanded.lastevent = 'rescued'
				var reencounterchance = globals.expansion.enemyreencounterchancerelease + round(rand_range(-globals.expansion.enemyreencountermodifier,globals.expansion.enemyreencountermodifier))
				#globals.state.npclastlocation.append([currentzone.code, baddie.id, reencounterchance])
				if baddie.npcexpanded.citizen == true:
					reputation = round(rand_range(1,5)) + globals.originsarray.find(baddie.origins)
					status = 'citizen'
				else:
					reputation = -round(rand_range(1,5) + rand_range(-globals.originsarray.find(baddie.origins), globals.originsarray.find(baddie.origins)))
					status = 'criminal'
				globals.state.allnpcs = baddie
				globals.state.offscreennpcs.append([baddie.id, currentzone.code, reencounterchance, 'roaming', reputation, status])
				###---End Expansion---###
				globals.state.reputation[location] += rand_range(1,2)
				if randf() < 0.25 + globals.state.reputation[location]/20 && reward == false:
					reward = true
					rewardslave = defeated.units[i]
		elif defeated.select[i] == 1:
			###---Added by Expansion---### Brutal Content && No Bandit Rep Loss
			if defeated.units[i].npcexpanded.citizen == true:
				if !defeated.faction[i] in ['bandit','monster']:
					globals.state.reputation[location] -= rand_range(0,1)
			###---End Expansion---###
			orgy = true
			orgyarray.append(defeated.units[i])
		elif defeated.select[i] == 2:
			killed = true
			###---Added by Expansion---### Brutal Content && No Bandit Rep Loss
			if globals.expansionsettings.brutalcontent == true:
				text += defeated.units[i].dictionary("You walk towards the $race $child, $name, with a grimace on your face. " + globals.expansion.nameExecution())
			if defeated.units[i].npcexpanded.citizen == true:
				if !defeated.faction[i] in ['monster','bandit']:
					globals.state.reputation[location] -= 3
				elif defeated.faction[i] == 'bandit':
					globals.state.reputation[location] -= 1
				if defeated.faction[i] == 'elf':
					globals.state.reputation.amberguard -= 3
			###---End Expansion---###
			text += "\n[color=red] " +defeated.names[i] + " has been killed.[/color] \n\n"
	if killed == true:
		text += "[color=red]Your execution strikes fear into your group and captives.\n [/color]"
		for i in globals.state.capturedgroup:
			if i.fear < 80:
				i.fear += rand_range(20,35)
		#for i in captured
	get_node("winningpanel").visible = false
	if secondarywin:
		secondarywin = false
	else:
		enemyleave()
	get_node("winningpanel/defeateddescript").set_bbcode('')
	outside.playergrouppanel()
	if orgy == true:
		var totalmanagain = 0
		###---Added by Expansion---### NPCs Expanded
		var relations = 0
		var reputation = 0
		var status = ''
		var temp
		if orgyarray.size() >= 2: ### See if there's more than 1 enemy to rape
			text += "After freeing those left from their clothes, you joyfully start to savour their bodies one after another. "
		else:
			text += "You grab the " + orgyarray[0].dictionary("$race $child") + " with a determined look in your eye. "
		for i in orgyarray:
			#Vanilla
			temp = rand_range(3,5)
			
			#Expansion - Rape Scene
			var baddie = i

			if globals.expansion.getSexualAttraction(baddie,globals.player) == true:
				text += baddie.dictionary("\nThe $race $child, $name, begins to "+str(globals.randomitemfromarray(['squirm','moan','moan excitedly','rock $his hips toward you','start panting heavily']))+ ".")
				if baddie.npcexpanded.timesraped > 0:
					text += baddie.quirk("\n[color=yellow]-"+str(globals.randomitemfromarray(['Oh divines, I missed this!','Fuck! That is what I needed!','Yeah, come and get me!','Fuck me! Please!','You earned me. Ravage my body!','Take my body!','Sure, I will fuck you!']))+ "[/color]")
				else:
					text += baddie.quirk("\n[color=yellow]-"+str(globals.randomitemfromarray(['Oh divines! Yeah, lets do this!','Fuck! That is what I needed!','Yeah, come and get me!','Fuck me! Please!','You earned me. Ravage my body!','Take my body!','Sure, I will fuck you!']))+ "[/color]")
				relations = round(rand_range(10,20)) + (baddie.npcexpanded.timesraped*5)
				baddie.lewdness = round(baddie.npcexpanded.timesraped*2.5)+1
				baddie.metrics.roughsexlike += 1
			else:
				text += baddie.dictionary("\nThe $race $child, $name, begins to "+str(globals.randomitemfromarray(['cry','sob','scream','whine','whimper pitifully','start bawling','feebly struggle to get away','weakly pull away']))+ ".")
				if baddie.npcexpanded.timesraped > 0:
					text += baddie.quirk("\n[color=yellow]-"+str(globals.randomitemfromarray(['No! No! Not again!','Please, no! Not again!','You...you are going to rape me AGAIN?','Why does this keep happening?','No! Please stop this!','I am going to be sick!','N-n-no!',"Please don't do this!",'Why me?!','Please stop!','Someone help me!',"I'll do anything! Please, no!"]))+ "[/color]")
				else:
					text += baddie.quirk("\n[color=yellow]-"+str(globals.randomitemfromarray(['No! Please stop this!','I am going to be sick!','N-n-no!',"Please don't do this!",'Why me?!','Please stop!','Someone help me!',"I'll do anything! Please, no!"]))+ "[/color]")
				relations = round(rand_range(-10,-20)) - (baddie.npcexpanded.timesraped*5)
				baddie.fear = round(baddie.npcexpanded.timesraped*2.5)+1
			text += "\n"
			if globals.player.penis != "none":
				if baddie.vagina != "none":
					if baddie.vagvirgin == true:
						baddie.vagvirgin = false
						text += baddie.dictionary("\nYou slam your "+str(globals.expansion.namePenis())+" into $his tight, virgin "+str(globals.expansion.namePussy())+" mercilessly. You hear $him sob as $his hymen rips but keep fucking $him ")
					else:
						text += baddie.dictionary("\nYou slam your "+str(globals.expansion.namePenis())+" into $his "+str(globals.expansion.namePussy())+" relentlessly. You occassionally switch to pounding $his "+str(globals.expansion.nameAsshole())+" ")
					if baddie.assvirgin == true:
						baddie.assvirgin = false
						baddie.cum.ass += round(globals.player.pregexp.cumprod*.4)
					if rand_range(0,100) <= globals.expansion.chanceimpregnatebaddies:
						text += baddie.dictionary("and finish inside of $his "+str(globals.expansion.namePussy())+".\n ")
						baddie.cum.pussy += globals.player.pregexp.cumprod
						globals.impregnation(baddie, globals.player)
					else:
						if baddie.assvirgin == true:
							baddie.assvirgin = false
							text += baddie.dictionary("and finish inside of $his virgin "+str(globals.expansion.nameAsshole())+".\n ")
						else:
							text += baddie.dictionary("and finish inside of $his "+str(globals.expansion.nameAsshole())+".\n ")
						baddie.cum.ass += globals.player.pregexp.cumprod
					if rand_range(0,100) <= 50:
						text += baddie.dictionary("You pull out of $him and feel another one cumming rapidly. $He starts trying to squirm to move away but you jump up and spray your "+globals.expansion.nameCum()+" all over $his face, mouth, and body. $He is left dripping and soaked with your "+globals.expansion.nameCum()+".\n ")
						baddie.cum.face += round(globals.player.pregexp.cumprod*.75)
						baddie.cum.body += round(globals.player.pregexp.cumprod*.75)
						baddie.cum.mouth += round(globals.player.pregexp.cumprod*.25)
				else:
					if baddie.assvirgin == true:
						baddie.assvirgin = false
						text += baddie.dictionary("\nYou slam your "+str(globals.expansion.namePenis())+" into $his virginal "+str(globals.expansion.nameAsshole())+" relentlessly. You feel it tear and stretch as its virginity is lost. You continue to pound $him until you finish inside of $his "+str(globals.expansion.nameAsshole())+". ")
					else:
						text += baddie.dictionary("\nYou slam your "+str(globals.expansion.namePenis())+" into $his "+str(globals.expansion.nameAsshole())+" relentlessly and finish inside of $his "+str(globals.expansion.nameAsshole())+". ")
					baddie.cum.ass += globals.player.pregexp.cumprod
					relations += round(rand_range(10,20))
				if rand_range(0,100) <= globals.expansion.rapedorgasmchance + ((globals.resources.day-baddie.lastsexday)*5):
					text += baddie.dictionary("You step back from $his twitching body and watch your "+globals.expansion.nameCum()+" ooze out of $him. You see $his legs spasming and twiching slightly and $him gasping while recovering from an unexpected, forced orgasm.\n ")
					relations += round(rand_range(10,20))
					baddie.metrics.orgasm += 1
					temp += rand_range(1,3)
				else:
					temp += 1
			else:
				text += baddie.dictionary("\nYou take your time savoring $his $race body and enjoy $him immensely.")
				temp += rand_range(1,2)
				relations += round(rand_range(-20,20))
			globals.addrelations(baddie, globals.player, relations)
			globals.player.metrics.orgasm += 1
			baddie.lastsexday = globals.resources.day
			baddie.metrics.roughsex += 1
			baddie.metrics.partners.append(globals.player.id)
			#Sex Scene Finished
			baddie.npcexpanded.timesraped += 1
			baddie.npcexpanded.lastevent = 'raped'
			globals.player.lastsexday = globals.resources.day
			var reencounterchance = globals.expansion.enemyreencounterchancerelease + round(rand_range(-globals.expansion.enemyreencountermodifier,globals.expansion.enemyreencountermodifier))
			if baddie.npcexpanded.citizen == true:
				reputation = round(rand_range(1,5)) + globals.originsarray.find(baddie.origins)
				status = 'citizen'
			else:
				reputation = -round(rand_range(1,5) + rand_range(-globals.originsarray.find(baddie.origins), globals.originsarray.find(baddie.origins)))
				status = 'criminal'
			globals.state.allnpcs = baddie
			globals.state.offscreennpcs.append([baddie.id, currentzone.code, reencounterchance, 'raped', reputation, status])
			#globals.state.npclastlocation.append([currentzone.code, baddie.id, reencounterchance])
			###---End Expansion---###
		
		for i in globals.state.playergroup:
			var person = globals.state.findslave(i)
			if killed == true && person.fear < 50 && person.loyal < 40:
				person.fear += rand_range(20,30)
			if person.lust < 50 || person.vagina != "none" && person.vagvirgin == true:
				if person.loyal < 30 && person.lewdness < 50 || person.traits.has('Prude'):
					text+= person.dictionary('\n$name watches your actions with disgust, eventually averting $his eyes with a look of horror on $his face. \n')
					person.obed += -rand_range(15,25)
				else:
					text += person.dictionary('\n$name watches your deeds with some interest despite $himself. After a few minutes, you see $his hand moving inside of $his pants as $he watches. \n')
					person.lust = rand_range(15,25)
			elif person.lust >= 50 || person.lust >= 40 && person.lewdness >= 40 || person.traits.has('Sex-Crazed') || person.traits.has('Perverted'):
					person.asser += rand_range(6,12)
					person.lastsexday = globals.resources.day
					person.lust -= rand_range(5,15)
					text += person.dictionary('\n$name, overwhelmed by the situation, joins you and pleasures $himself with ')
					var shared = globals.randomitemfromarray(orgyarray)
					text += shared.dictionary(' the $race $child, $name. ')
					if person.penis != "none":
						if shared.vagina != "none":
							text += person.dictionary("$He eventually cums inside of ") + shared.dictionary("$name's "+str(globals.expansion.namePussy())+". \n")
							shared.cum.pussy += person.pregexp.cumprod
							globals.impregnation(shared, person)
					#Shared/Baddie Sexual Attraction
					if globals.expansion.getSexualAttraction(shared,person) == true:
						relations = round(rand_range(10,20))
						shared.metrics.roughsexlike += 1
						text += shared.dictionary("$name seemed to enjoy ") + person.dictionary(" $name's attention and barely resists before ")
					else:
						relations = round(rand_range(-10,-20))
						text += shared.dictionary("$name struggled against ") + person.dictionary(" $name the entire time but ")
					if rand_range(0,100) <= globals.expansion.rapedorgasmchance + ((globals.resources.day-shared.lastsexday)*5):
						relations += round(rand_range(10,20))
						shared.metrics.orgasm += 1
						temp += rand_range(1,3)
						text += shared.dictionary(" $he cums loudly and violently. \n")
					else:
						temp += 1
						text += person.dictionary(" $name finished inside of ") + shared.dictionary("$him.\n")
					globals.addrelations(shared, person, relations)
					shared.metrics.sex += 1
					shared.metrics.roughsex += 1
					shared.metrics.partners.append(person.id)
					#Person Relations Added
					if globals.expansion.getSexualAttraction(person,shared) == true:
						relations = round(rand_range(10,20))
					else:
						relations = -round(rand_range(10,20))
					globals.addrelations(person, shared, relations)
					person.metrics.sex += 1
					person.metrics.orgasm += 1
					person.metrics.partners.append(shared.id)
			else:
				text += person.dictionary("\n$name does not appear to be very interested in the ongoing action and just waits patiently.\n")
		text += "\n[color=green][center]---Rewards Earned---[/center][/color]\n"
		###---End Expansion---###
		globals.resources.mana += temp
		totalmanagain += temp
		text += "You've earned [color=aqua]" + str(round(totalmanagain)) + "[/color] mana. "
	if reward == true:
		capturereward()
	if text != '':
		main.popup(text)


func capturedecide(stage): #1 - no reward, 2 - material, 3 - sex, 4 - join
	var text = ""
	var location
	if currentzone.tags.find("wimborn") >= 0:
		location = 'wimborn'
	elif currentzone.tags.find("frostford") >= 0:
		location = 'frostford'
	elif currentzone.tags.find("gorn") >= 0:
		location = 'gorn'
	elif currentzone.tags.find("amberguard") >= 0:
		location = 'amberguard'
	else:
		location = 'wimborn'
	
	if stage == 1:
		text = rewardslave.dictionary("The $race").capitalize() + " $child is surprised by your generosity, and after thanking you again, leaves. "
		globals.state.reputation[location] += 1
	elif stage == 2:
		if randf() >= 0.25:
			text = "After getting through $his belongings, $name passes you some valueables and gold. "
			var goldreward = round(rand_range(3,6)*10)
			if globals.state.spec == 'Hunter':
				goldreward *= 2
			globals.resources.gold += goldreward
		else:
			text = "After getting through $his belongings, $name passes you a piece of gear. "
			var gear = {number = 1, enchantchance = 75 }
			var loottable = chestloot[getchestlevel()]
			winscreenclear()
			generaterandomloot(loottable, gear)
			secondarywin = true
			showlootscreen()
	elif stage == 3:
		###---Added by Expansion---### NPCs Expanded
		if globals.expansion.getSexualAttraction(rewardslave,globals.player) || rand_range(0,100) <= 65 + globals.state.reputation[location]/2:
			text = "After a brief pause, $name gives you an accepting nod. After you seclude to nearby bushes, $he rewards you with a passionate session. "
			
			if globals.player.penis != "none":
				if rewardslave.vagina != "none":
					if rewardslave.vagvirgin == true:
						rewardslave.vagvirgin = false
						text += rewardslave.dictionary("\nYou slip your "+str(globals.expansion.namePenis())+" into $his tight, virgin "+str(globals.expansion.namePussy())+" gratefully. You hear $him moan as $his hymen pops, but you keep going ")
					else:
						text += rewardslave.dictionary("\nYou thrust your "+str(globals.expansion.namePenis())+" into $his "+str(globals.expansion.namePussy())+" relentlessly ")
					text += rewardslave.dictionary("and finish inside of $his "+str(globals.expansion.namePussy())+".\n ")
					rewardslave.metrics.sex += 1
					rewardslave.metrics.orgasm += 1
					rewardslave.metrics.partners.append(globals.player.id)
					rewardslave.cum.pussy += globals.player.pregexp.cumprod
					globals.impregnation(rewardslave, globals.player)
			
			globals.resources.mana += 5
		else:
			text = "$name hastily refuses and retreats excusing $himself. "
		###---End Expansion---###
	elif stage == 4:
		if rand_range(0,100) >= 20 + globals.state.reputation[location]/4:
			text = "$name excuses $himself, but can't accept your proposal and quickly leaves. "
		else:
			rewardslave.obed = 85
			rewardslave.stress = 10
			globals.slaves = rewardslave
			text = "$name observes you for some time, measuring your words, but to your surprise, $he complies either out of symphathy, or out of desperate life $he had to carry. "
	main.dialogue(true,self,rewardslave.dictionary(text))
	

###---Added by Expansion---###
func getTownReport(town):
	main.animationfade()
	yield(main, 'animfinished')
	var buttons = []
	var text = globals.expansion.getTownReportText(town)
	buttons.append({name = "Leave",function = 'zoneenter', args = town})
	mansion.maintext = text
	outside.buildbuttons(buttons,self)
###---End Expansion---###

func wimborn():
	main.get_node('outside').wimborn()
	
	###---Added by Expansion---### Towns Expanded
	outside.addbutton({name = 'Inquire about Recent Events', function = 'getTownReport', args = 'wimborn', textcolor = 'green', tooltip = 'Hear yesterdays news'}, self)
	###---End Expansion---###
	
	if globals.state.location != 'wimborn':
		if globals.resources.gold >= 25 :
			outside.addbutton({name = 'Teleport to Mansion - 25 gold', function = 'teleportmansion', textcolor = 'green', tooltip = '25 gold'}, self)
		else:
			outside.addbutton({name = 'Teleport to Mansion - 25 gold', function = 'teleportmansion', textcolor = 'green', tooltip = '25 gold', disabled = true}, self)

func gorn():
	main.music_set('gorn')
	var array = []
	array.append({name = "Visit local Slaver Guild", function = 'gornslaveguild'})
	array.append({name = "Visit local bar", function = 'gornbar'})
	if globals.state.mainquest in [12,13,14,15,37]:
		array.append({name = "Visit Palace", function = 'gornpalace'})
	if ((globals.state.sidequests.ivran in ['tobetaken','tobealtered','potionreceived','notaltered'] || globals.state.mainquest >= 16) && !globals.state.decisions.has("mainquestslavers")) || globals.state.sandbox == true:
		array.append({name = "Visit Alchemist", function = 'gornayda'})
	array.append({name = "Gorn's Market (shop)", function = 'gornmarket'})
	###---Added by Expansion---### Towns Expanded
	array.append({name = 'Inquire about Recent Events', function = 'getTownReport', args = 'gorn', textcolor = 'green', tooltip = 'Hear yesterdays news'})
	###---End Expansion---###
	array.append({name = "Outskirts", function = 'zoneenter', args = 'gornoutskirts'})
	if globals.state.location == 'gorn':
		array.append({name = "Return to Mansion",function = 'mansion'})
	else:
		if globals.resources.gold >= 25 :
			array.append({name = 'Teleport to Mansion - 25 gold', function = 'teleportmansion', textcolor = 'green', tooltip = '25 gold'})
		else:
			array.append({name = 'Teleport to Mansion - 25 gold', function = 'teleportmansion', textcolor = 'green', tooltip = '25 gold', disabled = true})
	outside.buildbuttons(array,self)
	
func amberguard():
	var array = []
	main.music_set('frostford')
#	if globals.state.portals.amberguard.enabled == false:
#		globals.state.portals.amberguard.enabled = true
#		mansion.maintext = mansion.maintext + "\n\n[color=yellow]You have unlocked new portal![/color]"
	if globals.state.mainquest == 17:
		globals.state.mainquest = 18
	elif globals.state.mainquest == 19:
		array.append({name = "Search for clues", function = "amberguardsearch"})
	elif globals.state.mainquest == 20:
		array.append({name = 'Find stranger', function = 'amberguardsearch', args = 2})
	array.append({name = "Local Market (shop)", function = 'amberguardmarket'})
	###---Added by Expansion---### Towns Expanded
	array.append({name = 'Inquire about Recent Events', function = 'getTownReport', args = 'amberguard', textcolor = 'green', tooltip = 'Hear yesterdays news'})
	###---End Expansion---###
	array.append({name = "Return to Elven Grove", function = 'zoneenter', args = 'elvenforest'})
	array.append({name = "Move to the Amber Road", function = 'zoneenter', args = 'amberguardforest'})
	if globals.state.sidequests.ayneris == 6:
		for i in globals.state.playergroup:
			if globals.state.findslave(i).unique == 'Ayneris':
				event("aynerisrapieramberguard")
	outside.buildbuttons(array,self)
	if globals.state.location != 'amberguard':
		if globals.resources.gold >= 25 :
			outside.addbutton({name = 'Teleport to Mansion - 25 gold', function = 'teleportmansion', textcolor = 'green', tooltip = '25 gold'}, self)
		else:
			outside.addbutton({name = 'Teleport to Mansion - 25 gold', function = 'teleportmansion', textcolor = 'green', tooltip = '25 gold', disabled = true}, self)

func shuriyaslaveselect(stage):
	###---Added by Expansion---### Races Expanded
	if stage == 1:
		main.selectslavelist(true, 'shuriyaelfselect', self, 'person.findRace(["Elf"])')
	else:
		main.selectslavelist(true, 'shuriyadrowselect', self, 'person.findRace(["Dark Elf"])')
	###---End Expansion---###

func frostford():
	main.music_set('frostford')
	var array = []
	if globals.state.mainquest in [28, 29, 30, 31, 33, 34, 35]:
		array.append({name = "Visit City Hall", function = "frostfordcityhall"})
	if globals.state.reputation.frostford >= 20 && globals.state.mainquest == 30 && globals.state.sidequests.zoe == 0:
		var text = globals.questtext.MainQuestFrostfordCityhallZoe
		var buttons = []
		var sprite = [['zoeneutral','pos1','opac']]
		globals.charactergallery.zoe.unlocked = true
		buttons.append({text = 'Accept', function = "frostfordzoe", args = 1})
		buttons.append({text = 'Refuse', function = "frostfordzoe", args = 2})
		main.dialogue(false, self, text, buttons, sprite)
	if globals.state.sandbox == true && globals.state.reputation.frostford >= 20 && globals.state.sidequests.zoe < 3:
		array.append({name = "Invite Zoe to your mansion", function = 'frostfordzoe', args = 3})
	array.append({name = "Visit local Slaver Guild", function = 'frostfordslaveguild'})
	array.append({name = "Frostford's Market (shop)", function = 'frostfordmarket'})
	###---Added by Expansion---### Towns Expanded
	array.append({name = 'Inquire about Recent Events', function = 'getTownReport', args = 'frostford', textcolor = 'green', tooltip = 'Hear yesterdays news'})
	###---End Expansion---###
	array.append({name = "Outskirts", function = 'zoneenter', args = 'frostfordoutskirts'})
	if globals.state.location == 'frostford':
		array.append({name = "Return to Mansion",function = 'mansion'})
	else:
		if globals.resources.gold >= 25 :
			array.append({name = 'Teleport to Mansion - 25 gold', function = 'teleportmansion', textcolor = 'green', tooltip = '25 gold'})
		else:
			array.append({name = 'Teleport to Mansion - 25 gold', function = 'teleportmansion', textcolor = 'green', tooltip = '25 gold', disabled = true})
	outside.buildbuttons(array,self)
