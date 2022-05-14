
var travel = globals.expansiontravel #ralphD

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
	elif scoutawareness < (enemyawareness + rand_range(globals.expansionsettings.random_enemy_awareness[0],globals.expansionsettings.random_enemy_awareness[1])): #ralph4
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

var guardRaces = {
	'wimborn' : [['Human', 12],['Demon', 2],['Taurus', 2],['Cat', 1]],
	'frostford' : [['Halfkin Wolf', 6],['Beastkin Wolf', 6],['Human', 5],['Halfkin Cat', 2],['Beastkin Cat', 2],['Halfkin Fox', 1],['Beastkin Fox', 1],['Halfkin Mouse', 2],['Beastkin Mouse', 2],],
	'gorn' : [['Orc', 4],['Goblin', 2],['Centaur', 1],['Taurus', 1]],
	'amberguard' : [['Elf', 12],['Tribal Elf', 1],['Dark Elf', 1]]
}

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
				race = globals.getracebygroup('active')
	
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

##############ralphD - space out combats through new noncombat enemyencounter
func noenemyencountered():
	var array = []
	#mansion.maintext = "Your journey continues peacefully. \n"
	#noenemyencounteredandthen(zone)
	#print("Ralph Test: enemygroup: "+str(enemygroup))
	mansion.maintext = travel.getzonetraveltext(currentzone,currentzone.length)
	array.append({name = "Proceed through area", function = 'enemyleave'})
	outside.buildbuttons(array, self)
#/ralphD


var treasuremisc = [['magicessenceing',7],['taintedessenceing',7],['natureessenceing',7],['bestialessenceing',7],['fluidsubstanceing',7],['gem',1],['claritypot',0.5],['regressionpot',1],['youthingpot',2],['maturingpot',2]]

###---Added by Expansion---### ElPresidente Items
var chestloot = {
	easy = ['armorleather','armorchain','weapondagger','weaponbasicstaff','weaponserrateddagger','weaponsword','clothsundress','clothmaid','clothbutler','armorpadded','weaponclaymore'],
	medium = ['armorchain','weaponsword','weaponserrateddagger','clothsundress','clothmaid','clothbutler', 'armorelvenchain','armorrobe', 'weaponhammer','weapongreatsword','clothkimono','clothpet','clothmiko','clothbedlah','accgoldring','accslavecollar','acchandcuffs','acctravelbag','weaponancientsword','accelvenboots'],
	hard = ['armorplate','accamuletemerald','accamuletruby','armorelvenhalfplate','armorhalfplate','armorfieldplate','weaponrunesword','armormagerobe','accbooklife'],
}
###---End Expansion---###

func winscreenclear():
	var winpanel = get_node("winningpanel")
	defeated = []
	enemyloot = {stackables = {}, unstackables = []}
	for i in winpanel.get_node("ScrollContainer/VBoxContainer").get_children():
		if i != winpanel.get_node("ScrollContainer/VBoxContainer/Button"):
			i.visible = false
			i.free()
	winpanel.get_node("ScrollContainer").visible = false
	winpanel.get_node("Panel").visible = false
	main.checkplayergroup()

func chestselectslave(action):
	chestaction = action
	var reqs = ''
	var text = ''
	if chestaction == 'chestlockpick':
		reqs = 'person.energy >= 5'
		text = 'Lock difficulty: ' + str(chest.agility)
	elif chestaction == 'chestmouselockpick':
		reqs = 'person.energy >= 10'
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
	array.append({name = 'Mouse w/o lockpick (10 energy)', function = 'chestselectslave', args = 'chestmouselockpick'})
	array.back().disabled = true
	if globals.player.race.find('Mouse') >= 0:
		array.back().disabled = false
	for i in globals.state.playergroup:
		if globals.state.findslave(i).race.find('Mouse') >= 0:
			array.back().disabled = false
	array.append({name = 'Crack it open (20 energy)', function = 'chestselectslave', args = 'chestbash'})
	array.append({name = "Leave", function = 'enemyleave'})
	outside.buildbuttons(array, self)

func chestlockpick(person):
	var unlock = false
	var text = ''
	person.energy -= 5
	globals.state.backpack.stackables.lockpick -= 1
	var agility = person.sagi
	if person.race.find('Mouse') >= 0:
		agility += 2
	if agility >= chest.agility:
		unlock = true
		text = "$name skillfully picks the lock on the chest."
	else:
		if 60 - (chest.agility - agility) * 10 >= rand_range(0,100):
			text = "With some luck, $name manages to pick the lock on the chest. "
			unlock = true
		else:
			text = "$name fails to pick the lock and breaks the lockpick. "
			unlock = false

	text = person.dictionary(text)
	if unlock == false:
		###---Added by Expansion---### Ank Bugfix v4
		outside.playergrouppanel()
		###---End Exploration---###
		treasurechestoptions(text)
	else:
		showlootscreen(text)

func chestmouselockpick(person):
	var unlock = false
	var text = ''
	person.energy -= 10
	if person.sagi >= chest.agility:
		unlock = true
		text = "$name skillfully picks the lock on the chest."
	else:
		if 60 - (chest.agility - person.sagi) * 10 >= rand_range(0,100):
			text = "With some luck, $name manages to pick the lock on the chest. "
			unlock = true
		else:
			text = "$name fails to pick the lock. "
			unlock = false

	text = person.dictionary(text)
	if unlock == false:
		###---Added by Expansion---### Ank Bugfix v4
		outside.playergrouppanel()
		###---End Exploration---###
		treasurechestoptions(text)
	else:
		showlootscreen(text)

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
			var reencounterchance = globals.expansion.enemyreencounterchanceescape + round(globals.expansion.enemyreencountermodifier * rand_range(-1,1))
			for i in baddie.gear.values():
				if i != null:
					###---Added by Expansion---### Fix items flipping out on NPCs
					if globals.state.unstackables.has(i):
						globals.items.unequipitemraw(globals.state.unstackables[i],baddie)
					else:
						globals.items.unequipitemraw(enemygear[i],baddie)
			globals.state.allnpcs = baddie
			#Check is because the citizen will be altered elsewhere before and removed from above later
			if baddie.npcexpanded.citizen == true:
				reputation += round(rand_range(1,5)) + globals.originsarray.find(baddie.origins)
				status = 'citizen'
			else:
				reputation -= round(rand_range(1,5) + globals.originsarray.find(baddie.origins)*rand_range(-1, 1))
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
			if globals.expansionsettings.captureChance >= rand_range(0,100):
				defeated.append({"unit":unit.capture,"name":unit.name,"select":globals.expansionsettings.capturedSelect,"faction":unit.faction})
			else:
				text += " [color=red]"+unit.name+" died during capture.[/color]"
			for i in unit.capture.gear.values():
				if i != null:
					###---Added by Expansion---### Fix items flipping out on NPCs
					if globals.state.unstackables.has(i):
						globals.items.unequipitemraw(globals.state.unstackables[i],unit.capture)
						enemyloot.unstackables.append(globals.state.unstackables[i])
					else:
						globals.items.unequipitemraw(enemygear[i],unit.capture)
						var bonus = 0
						if globals.state.spec == 'Hunter':
							bonus+=20
						if randf() * 100 <= variables.geardropchance + bonus:
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
	
	
	if !defeated.empty():
		text += 'Your group gathers defeated opponents in one place for you to decide what to do about them. \n'
		###---Added by Expansion---### Quick Strip/Sizing Support
		for i in defeated:
			globals.expansion.quickStrip(i.unit)
		text += "You quickly strip off all of their clothing so you can see the potential merchandise you have gained. \n"
		###---End Expansion---###
	if enemygroup.captured != null:
		text += 'You are also free to decide what you wish to do with bystanders, who were in possession of your opponents. \n'
		for i in enemygroup.captured:
			###---Added by Expansion---### NPCs Expanded | Set Base Metrics
			i.npcexpanded.timesmet += 1
			i.npcexpanded.timesrescued += 1
			###---End Expansion---###
			defeated.append({"unit":i,"name":'Captured',"select":globals.expansionsettings.rescuedSelect,"faction":'stranger'})
	###---Added by Expansion---### NPCs Expanded | Baby && Noncombatants Support
	var extranpcs = 0
	var npc2
	var latetext = ""
	for i in defeated:
		var npc = i.unit
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
				defeated.append({"unit":npc2,"name":'Innocent Bystander',"select":globals.expansionsettings.foundSelect,"faction":'stranger'})
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
	for i in defeated:
		var person = i.unit
		if globals.races[person.race.replace("Halfkin", "Beastkin")].uncivilized && person.spec != 'tamer':
			person.add_trait('Uncivilized')
		person.stress += rand_range(20, 50)
		person.obed += rand_range(10, 20)
		person.health -= rand_range(40,70)
		if i.name == 'Captured':
			person.obed += rand_range(10,20)
			person.loyal += rand_range(5,15)
	buildcapturelist()
	builditemlists()
	
	if globals.state.sidequests.cali == 18 && currentzone.code == 'forest':
		for i in defeated:
			if "Bandit" in i.name:
				main.popup("One of the defeated bandits in exchange for their life reveals the location of their camp you've been searching for. ")
				globals.state.sidequests.cali = 19
				return
		

func buildcapturelist():
	var winpanel = get_node("winningpanel")
	var text = "Defeated and Captured | Free ropes left: "
	text += str(globals.state.backpack.stackables.get('rope', 0))
	winpanel.get_node("Panel/Label").set_text(text)
	for i in get_node("winningpanel/ScrollContainer/VBoxContainer").get_children():
		if i.get_name() != 'Button':
			i.visible = false
			i.queue_free()
	for i in defeated:
		var person = i.unit
		var newbutton = winpanel.get_node("ScrollContainer/VBoxContainer/Button").duplicate()
		winpanel.get_node("ScrollContainer/VBoxContainer").add_child(newbutton)
		newbutton.visible = true
		newbutton.get_node("capture").connect("pressed",self,'captureslave', [person])
		if globals.state.backpack.stackables.get('rope', 0) < variables.consumerope:
			newbutton.get_node('capture').set_disabled(true)
		newbutton.get_node("Label").set_text(i.name + ' ' + person.sex+ ' ' + person.race)
		if i.name == 'Captured':
			newbutton.get_node("Label").set('custom_colors/font_color', Color(0.25,0.3,0.75))
		else:
			newbutton.get_node("Label").set('custom_colors/font_color', Color(0.8,0.2,0.2))
		newbutton.connect("pressed", self, 'defeatedselected', [person])
		newbutton.connect("mouse_entered", globals, 'slavetooltip', [person])
		newbutton.connect("mouse_exited", globals, 'slavetooltiphide')
		newbutton.get_node("choice").set_meta('person', person)
		newbutton.get_node("mindread").connect("pressed",self,'mindreadslave', [person])
		if globals.resources.mana < globals.spells.spellcost(globals.spelldict.mindread) || !globals.spelldict.mindread.learned:
			newbutton.get_node('mindread').set_disabled(true)
		newbutton.get_node("choice").add_to_group('winoption')
		newbutton.get_node("choice").select(i.select)
		newbutton.get_node("choice").connect("item_selected",self, 'defeatedchoice', [person, newbutton.get_node("choice")])

func defeatedchoice(ID, person, node):
	for i in defeated:
		if i.unit == person:
			i.select = ID
			return

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

func captureslave(person):
	var location
	if variables.consumerope > 0:
		globals.state.backpack.stackables.rope -= variables.consumerope
	for i in person.gear:
		i = null
	captureeffect(person)
	for i in defeated:
		if i.unit == person:
			if i.name == 'Captured' || i.faction in ['stranger','elf']:
				for place in ['wimborn','frostford','gorn','amberguard']:
					if currentzone.tags.has(place):
						location = place
				if location != null:
					globals.state.reputation[location] -= 1
			defeated.erase(i)
			break
	get_tree().get_current_scene().infotext("New captive added to your group",'green')
	buildcapturelist()
	builditemlists()

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
	for i in defeated:
		###---Added by Expansion---### NPCs Expanded
		var reputation = 0
		var status = ""
		###---End Expansion---###
		if i.faction in ['stranger','elf'] && i.name != "Captured":
			globals.state.reputation[location] -= 1
		if i.select == 0:
			if i.name != 'Captured':
				###---Added by Expansion---### NPCs Expanded and Ank BugFix v4
				text += i.unit.dictionary("You have left the $race $child alone.\n")
				var baddie = i.unit
				baddie.npcexpanded.timesreleased += 1
				baddie.npcexpanded.lastevent = 'fought'
				var reencounterchance = globals.expansion.enemyreencounterchancerelease + round(globals.expansion.enemyreencountermodifier * rand_range(-1,1))
				if baddie.npcexpanded.citizen == true:
					reputation = round(rand_range(1,5)) + globals.originsarray.find(baddie.origins)
					status = 'citizen'
				else:
					reputation = -round(rand_range(1,5) + globals.originsarray.find(baddie.origins)*rand_range(-1, 1))
					status = 'criminal'
				globals.state.allnpcs = baddie
				globals.state.offscreennpcs.append([baddie.id, currentzone.code, reencounterchance, 'defeated', reputation, status])
				###---End Expansion---###
			else:
				text += i.unit.dictionary("You have released the $race $child. $His life is $his own.\n")
				###---Added by Expansion---### Category: Better NPCs
				var baddie = i.unit
				baddie.npcexpanded.timesreleased += 1
				baddie.npcexpanded.lastevent = 'rescued'
				var reencounterchance = globals.expansion.enemyreencounterchancerelease + round(globals.expansion.enemyreencountermodifier * rand_range(-1,1))
				if baddie.npcexpanded.citizen == true:
					reputation = round(rand_range(1,5)) + globals.originsarray.find(baddie.origins)
					status = 'citizen'
				else:
					reputation = -round(rand_range(1,5) + globals.originsarray.find(baddie.origins)*rand_range(-1, 1))
					status = 'criminal'
				globals.state.allnpcs = baddie
				globals.state.offscreennpcs.append([baddie.id, currentzone.code, reencounterchance, 'roaming', reputation, status])
				###---End Expansion---###
				globals.state.reputation[location] += rand_range(1,2)
				if randf() < 0.25 + globals.state.reputation[location]/20 && reward == false:
					reward = true
					rewardslave = i.unit
		elif i.select == 1:
			###---Added by Expansion---### Brutal Content && No Bandit Rep Loss
			if i.unit.npcexpanded.citizen == true:
				if !i.faction in ['bandit','monster']:
					globals.state.reputation[location] -= rand_range(0,1)
			###---End Expansion---###
			orgy = true
			orgyarray.append(i.unit)
		elif i.select == 2:
			killed = true
			###---Added by Expansion---### Brutal Content && No Bandit Rep Loss
			if globals.expansionsettings.brutalcontent == true:
				text += i.unit.dictionary("You walk towards the $race $child, $name, with a grimace on your face. " + globals.expansion.nameExecution())
			if i.unit.npcexpanded.citizen == true:
				if !i.faction in ['monster','bandit']:
					globals.state.reputation[location] -= 3
				elif i.faction == 'bandit':
					globals.state.reputation[location] -= 1
				if i.faction == 'elf':
					globals.state.reputation.amberguard -= 3
			###---End Expansion---###
			text += "\n[color=red] " + i.name + " has been killed.[/color] \n\n"
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
		var temp = 0
		var helpers = []	### statistically, 9 out of 10 people enjoy gangbangs. these are your "average" gangbangers
		var watchers = []	### we're going to keep track of who doesn't join in, though these slaves may still have a solo adventure if they're inclined
		for i in globals.state.playergroup: ### let's find our "helpers". bool 'allowed' should be set from a person.rules variable (or similar) to control whether the MC allows this conduct
			var person = globals.state.findslave(i)
			var allowed = !person.rules.masturbation ### for initial implimentation, let's just tie it (inversely) into masturbation
			if (person.checkVice('lust') || person.traits.has('Pervert') || person.traits.has('Sex-crazed') || person.checkFetish('dominance')) && (person.lewdness >= 60 && person.lust >= 50) && allowed == true:
				helpers.append(person)
			else:
				watchers.append(person)
		text += '\n'
		if orgyarray.size() >= 2: ### See if there's more than 1 enemy to rape
			text += "After freeing those left from their clothes, you joyfully start to savour their bodies one after another. \n\n"
		else:
			text += "You grab the " + orgyarray[0].dictionary("$race $child") + " with a determined look in your eye. \n"
		for i in orgyarray:
			#Vanilla
			temp += rand_range(1,3)

			#Expansion - Rape Scene
			var baddie = i
			var friend = null ### tracker for keeping our joining party member in the correct scope. prepared for null entry, which should be most cases.
			var mean = false ### this will track our victim's opinion at the start of the scene, used for continuity of scene
			for h in helpers: ### iterate the helpers array, return the last successful attraction check as our 'friend'
				if globals.expansion.getSexualAttraction(h,baddie):
					friend = h

			if friend != null:  ### introduction scene:
				helpers.erase(friend) ### consume instance
				text += friend.dictionary(globals.randomitemfromarray(['$name eagerly grapples ','$name dives onto ','$name quickly grabs ']))  #who initiates and how
				text += baddie.dictionary(globals.randomitemfromarray(['one of the prisoners ','a terrified $race $sex '])) #who it's done to
				text += baddie.dictionary(globals.randomitemfromarray(['and holds $him down ','and kneels on $his chest ','and grabs $his wrists '])) #what they do
				text += friend.dictionary(globals.randomitemfromarray(['with a twisted gleam in $his eye. ','with a menacing laugh. '])) #additional detail

			if globals.expansion.getSexualAttraction(baddie,globals.player) == true:
				mean = false
				text += baddie.dictionary("The $race $child, $name, begins to "+str(globals.randomitemfromarray(['squirm','moan','moan excitedly','rock $his hips toward you','start panting heavily']))+ ".")
				if baddie.npcexpanded.timesraped > 0:
					text += baddie.quirk("\n[color=yellow]-"+str(globals.randomitemfromarray(['Oh divines, I missed this!','Fuck! That is what I needed!','Yeah, come and get me!','Fuck me! Please!','You earned me. Ravage my body!','Take my body!','Sure, I will fuck you!']))+ "[/color]\n")
				else:
					text += baddie.quirk("\n[color=yellow]-"+str(globals.randomitemfromarray(['Oh divines! Yeah, lets do this!','Fuck! That is what I needed!','Yeah, come and get me!','Fuck me! Please!','You earned me. Ravage my body!','Take my body!','Sure, I will fuck you!']))+ "[/color]\n")
				relations = round(rand_range(10,20)) + (baddie.npcexpanded.timesraped*5)
				baddie.lewdness = round(baddie.npcexpanded.timesraped*2.5)+1
				baddie.metrics.roughsexlike += 1

			else:
				mean = true
				text += baddie.dictionary("The $race $child, $name, begins to "+str(globals.randomitemfromarray(['cry','sob','scream','whine','whimper pitifully','start bawling','feebly struggle to get away','weakly pull away']))+ ".")
				if baddie.npcexpanded.timesraped > 0:
					text += baddie.quirk("\n[color=yellow]-"+str(globals.randomitemfromarray(['No! No! Not again!','Please, no! Not again!','You...you are going to rape me AGAIN?','Why does this keep happening?','No! Please stop this!','I am going to be sick!','N-n-no!',"Please don't do this!",'Why me?!','Please stop!','Someone help me!',"I'll do anything! Please, no!"]))+ "[/color]\n")
				else:
					text += baddie.quirk("\n[color=yellow]-"+str(globals.randomitemfromarray(['No! Please stop this!','I am going to be sick!','N-n-no!',"Please don't do this!",'Why me?!','Please stop!','Someone help me!',"I'll do anything! Please, no!"]))+ "[/color]\n")
				relations = round(rand_range(-10,-20)) - (baddie.npcexpanded.timesraped*5)
				baddie.fear = round(baddie.npcexpanded.timesraped*2.5)+1

			if friend != null:  ### we react to the captive. this could be relatively short. could make a number of actions based on flaws, too...
				if (friend.checkVice('wrath') || friend.checkFetish('sadism')) && mean == true:
					text += friend.dictionary(globals.randomitemfromarray(['$name angrily grabs ', '$name growls and clutches ']))
					text += baddie.dictionary(globals.randomitemfromarray(['$his hair as $he protests, and strikes $his face again and again until $he is reduced to mere whimpers. ','$his throat until $he can no longer protest. ']))
					friend.stress -= rand_range(10,20)
				elif friend.checkFetish('submission') && mean == false:
					text += friend.dictionary(globals.randomitemfromarray(['$name kneels next to ','$name smiles to ']))
					text += baddie.dictionary(globals.randomitemfromarray(['$him and whispers encouragements into $his ear. ', '$him and strokes $his hair as $he coooperates. ']))
				elif friend.checkFetish('bondage') && mean == true:
					text += friend.dictionary(globals.randomitemfromarray(['$name tightens some rope around ','$name collects some nearby vines, then binds ']))
					text += baddie.dictionary(globals.randomitemfromarray(['$his arms and chest and $his struggles become more labored. ','$him and lifts $him into position for you. ']))
				else:
					text += friend.dictionary(globals.randomitemfromarray(['$name gives you a knowing smile ','$name grins in anticipation ']))
					text += baddie.dictionary(globals.randomitemfromarray(['while $he squirms. ','as you approach. ']))
				text += '\n'

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

			elif globals.player.vagina != "none":
				temp += rand_range(1,2)
				text += '\n'  ### step one, foreplay
				text += baddie.dictionary(globals.randomitemfromarray(['You grab $him by the back of $his neck as $he kneels and ','You push $him onto $his back to kneel over $his shoulders and ','You turn your back and pull $his cheeks under your ass to ']))
				text += baddie.dictionary(globals.randomitemfromarray(['bury $his face between the folds of your '+str(globals.expansion.namePussy())+'. ','grind your '+str(globals.expansion.namePussy())+' onto $his lips. ']))
				if mean == false: ### of *course* you can't resist loving our wonderful box. 
					text += baddie.dictionary(globals.randomitemfromarray(['$His eyes betray $his lust as $he breathes in your essence. ','$He moans lightly and you feel $his tongue as $he tastes you. ']))
				text += baddie.dictionary(globals.randomitemfromarray(['You rock your hips as you feel your orgasm approach, ','You feel your arousal swelling as you take your pleasure, ']))
				text += baddie.dictionary(globals.randomitemfromarray(['and hold $his dome against your '+str(globals.expansion.namePussy())+' as you cum. ',' and climax loudly with your fingers tangled in $his hair. ']))
				text += '\n'
				if baddie.penis != "none": ### oh, boy! a penis!
					var loaded = false  ### we're only tracking if we get creampied. if not, we molest them. then, it's all coming back out before our scene is over.
					text += baddie.dictionary(globals.randomitemfromarray(['You inspect $his '+str(globals.expansion.namePenis())+' with interest before wrapping your hand around $his shaft. ','$name\'s '+str(globals.expansion.namePenis())+' catches your eye, casting a wicked grin across your face. ']))
					text += baddie.dictionary(globals.randomitemfromarray(['In your hands, it quickly becomes stiff and responsive. ','It takes little coaxing from your lips before it swells to fullness. ']))
					if globals.player.vagvirgin == false: ### we know our way around a cock. let's play with it!
						if baddie.penisvirgin == true:
							baddie.penisvirgin == false   ### and all the girlies say he's pretty fly for a white guy
						text += '\n'
						text += baddie.dictionary(globals.randomitemfromarray(['You slam yourself down onto $his '+str(globals.expansion.namePenis())+', ','You take $his '+str(globals.expansion.namePenis())+' into your '+str(globals.expansion.namePussy())+' ','You quickly mount $him ']))
						text += baddie.dictionary(globals.randomitemfromarray(['and let out a moan of pleasure. ','and pound $his loins like a jackhammer. ','and ride $him like an animal. ']))
						text += baddie.dictionary(globals.randomitemfromarray(['You rock your hips until ','You sheath $his '+str(globals.expansion.namePenis())+' into yourself again and again, until ','You grind your flower on $him until ']))
						if rand_range(0,100) <= globals.expansion.rapedorgasmchance + ((globals.resources.day-baddie.lastsexday)*1.5):
							text += baddie.dictionary(globals.randomitemfromarray(['$he cums hard with you. ','$his throbbing '+str(globals.expansion.namePenis())+' sets you off. ','$his hot '+globals.expansion.nameCum()+' fills your quivering '+str(globals.expansion.namePussy())+'. ']))
							loaded = true
							temp += rand_range(1,3)
							relations += round(rand_range(10,20))
							baddie.metrics.orgasm += 1
						else:
							text += baddie.dictionary(globals.randomitemfromarray(['you cum hard on $his '+str(globals.expansion.namePenis())+'. ','you feel your '+str(globals.expansion.namePussy())+' violently convulse. ','the walls of your '+globals.expansion.namePussy()+' squeeze $his '+globals.expansion.namePenis()+'. ']))
							temp += rand_range(1,2)
					if loaded == false:  ### presumably, they didn't cum. let's molest them!
						text += baddie.dictionary(globals.randomitemfromarray(['You take $his '+str(globals.expansion.namePenis())+' into your hand and begin to stroke $him. ','Your begin to trace your fingers along $his '+globals.expansion.namePenis()+'. ']))
						text += baddie.dictionary(globals.randomitemfromarray(['Using a little of your spit, you lube up $his shaft and work it to completion. ','You slowly stroke and tease $his '+str(globals.expansion.namePenis())+' with your lips until $he lets out a moan. ']))
						text += baddie.dictionary(globals.randomitemfromarray(['You can\'t help but giggle a bit as you spray $his own '+globals.expansion.nameCum()+' all over $his chest and face. ','$He groans and convulses as $he bursts. You smile while smearing $his seed over $his body and face with your fingers. ']))
						baddie.cum.face += round(baddie.pregexp.cumprod*.25)
						baddie.cum.body += round(baddie.pregexp.cumprod*.25)
						relations += round(rand_range(-5,20))
						baddie.metrics.orgasm += 1
					if loaded == true:  ### we are creampied. *somebody* needs to clean up this mess
						text += baddie.dictionary(globals.randomitemfromarray(['You feel the slick but sticky '+globals.expansion.nameCum()+' inside you and smile. ','As you stand, $his '+globals.expansion.nameCum()+' begins to drip down your thigh. ']))
						text += '\n'
						text += baddie.dictionary(globals.randomitemfromarray(['You push the $race $child to the ground and ','You grab the $race $sex by the back of $his neck and ']))
						text += baddie.dictionary(globals.randomitemfromarray(['push $his '+globals.expansion.nameCum()+' out of your '+str(globals.expansion.namePussy())+'. ','drain $his '+globals.expansion.nameCum()+' into $his mouth. ']))
						if baddie.checkFetish('creampiemouth'):
							text += baddie.dictionary(globals.randomitemfromarray(['$He moans and blushes as $his seed is returned. ','$he gulps it down, staring into your eyes. ']))
						else:
							text += baddie.dictionary(globals.randomitemfromarray(['$He chokes and gasps while $he is fed. ','$His eyes go wide as $his seed slides out of your '+globals.expansion.namePussy()+'. ']))
						text += baddie.dictionary(globals.randomitemfromarray(['$His face is now smeared in '+globals.expansion.nameCum()+'. ','$His '+globals.expansion.nameCum()+' leaves a shine across $his cheeks and lips. ']))
						baddie.cum.face += round(baddie.pregexp.cumprod*.5)
					text += '\n'
				if baddie.vagina != "none": ### a vagina! my favorite!
					text += baddie.dictionary(globals.randomitemfromarray(['You turn your eyes to $his '+str(globals.expansion.namePussy())+' with a mischievious grin. ','$name\'s wet '+str(globals.expansion.namePussy())+' beckons to you. ']))
					if mean == true:
						text += baddie.dictionary(globals.randomitemfromarray(['$He whimpers pathetically as you begin to pleasure $him. ','$He quietly sobs as you enjoy $him. ']))
					text += baddie.dictionary(globals.randomitemfromarray(['You begin stroking $his slit ','You allow yourself a taste of $his sweet honey ','You bury your fingers into $him ']))
					text += baddie.dictionary(globals.randomitemfromarray(['while $he writhes and moans. ','and $he shudders in pleasure. ','causing $him to gasp in surprise. ']))
					text += baddie.dictionary(globals.randomitemfromarray(['It\'s not long before $name is rocking $his hips into you. ','$name begins groaning with desire and need. ']))
					text += '\n'
					text += baddie.dictionary(globals.randomitemfromarray(['You draw a dagger and push the pommel into $his '+str(globals.expansion.namePussy())+'. ','You reach for your sword, and penetrate $him with the grip. ','You retrieve a toy from your bag and insert it without warning. ']))
					if baddie.vagvirgin == true:
						baddie.vagvirgin = false
						text += baddie.dictionary(globals.randomitemfromarray(['With one sharp jab, you steal $his first time. $He sobs as $his hymen rips, but moans in spite of $himself. ','$His eyes go wide as you enter $him, but $his hymen offers little resistance. ','$His virgin '+str(globals.expansion.namePussy())+' stretches and tears while $he gasps. ']))
					text += baddie.dictionary(globals.randomitemfromarray(['You thrust into $him again and again ','$He has trouble breathing as you brutally pound $him with your tool ','$His lips quiver as you massage $his insides ']))
					temp += rand_range(1,2)
					relations += round(rand_range(10,20))
					baddie.metrics.orgasm += 1
					text += baddie.dictionary(globals.randomitemfromarray(['until $he\'s left gasping and spent. ','until a long, low moan rings out of $him. ','until $he screams in climax. ']))
					text += '\n'
				text += baddie.dictionary(globals.randomitemfromarray(['You smile at the quivering mess you leave on the ground. ','You straighten your hair as you walk away. ','You let out a satisfied sigh. ']))
				text += '\n'
				
			else:
				text += baddie.dictionary("\nYou take your time savoring $his $race body and enjoy $him immensely.")
				temp += rand_range(1,2)
				relations += round(rand_range(-20,20))
 
			if friend != null:			### This is the old (slightly modified) code for party members to join in. We will fire it here, instead.
				friend.asser += rand_range(6,12)
				friend.lastsexday = globals.resources.day
				friend.lust -= rand_range(20,35)
				text += friend.dictionary('\n$name, overwhelmed by the situation, joins you and pleasures $himself with ')
				text += baddie.dictionary(' the $race $child, $name. ')
				if friend.penis != "none":
					if baddie.vagina != "none":
							text += friend.dictionary("$He eventually cums inside of ") + baddie.dictionary("$name's "+str(globals.expansion.namePussy())+". \n")
							baddie.cum.pussy += friend.pregexp.cumprod
							globals.impregnation(baddie,friend)
					#Shared/Baddie Sexual Attraction
				if globals.expansion.getSexualAttraction(baddie,friend) == true:
					relations = round(rand_range(10,20))
					baddie.metrics.roughsexlike += 1
					text += baddie.dictionary("$name seemed to enjoy ") + friend.dictionary(" $name's attention and barely resists before ")
				else:
					relations = round(rand_range(-10,-20))
					text += baddie.dictionary("$name struggled against ") + friend.dictionary(" $name the entire time but ")
				if rand_range(0,100) <= globals.expansion.rapedorgasmchance + ((globals.resources.day-baddie.lastsexday)*5):
					relations += round(rand_range(10,20))
					baddie.metrics.orgasm += 1
					temp += rand_range(1,3)
					text += baddie.dictionary(" $he cums loudly and violently. \n")
				else:
					temp += 1
					text += friend.dictionary(" $name came loudly on top of ") + baddie.dictionary("$him.\n")
				globals.addrelations(baddie,friend,relations)
				baddie.metrics.sex += 1
				baddie.metrics.roughsex += 1
				baddie.metrics.partners.append(friend.id)
				#Person Relations Added
				if globals.expansion.getSexualAttraction(friend,baddie) == true:
					relations = round(rand_range(10,20))
				else:
					relations = -round(rand_range(10,20))
				globals.addrelations(friend,baddie,relations)
				friend.metrics.sex += 1
				friend.metrics.orgasm += 1
				friend.metrics.partners.append(baddie.id)

			text += '\n'
			globals.addrelations(baddie, globals.player, relations)
			globals.player.metrics.orgasm += 1
			baddie.lastsexday = globals.resources.day
			baddie.metrics.roughsex += 1
			baddie.metrics.partners.append(globals.player.id)
			#Sex Scene Finished
			baddie.npcexpanded.timesraped += 1
			baddie.npcexpanded.lastevent = 'raped'
			globals.player.lastsexday = globals.resources.day
			var reencounterchance = globals.expansion.enemyreencounterchancerelease + round(globals.expansion.enemyreencountermodifier * rand_range(-1,1))
			if baddie.npcexpanded.citizen == true:
				reputation = round(rand_range(1,5)) + globals.originsarray.find(baddie.origins)
				status = 'citizen'
			else:
				reputation = -round(rand_range(1,5) + globals.originsarray.find(baddie.origins)*rand_range(-1, 1))
				status = 'criminal'
			globals.state.allnpcs = baddie
			globals.state.offscreennpcs.append([baddie.id, currentzone.code, reencounterchance, 'raped', reputation, status])
			#globals.state.npclastlocation.append([currentzone.code, baddie.id, reencounterchance])
			###---End Expansion---###
		watchers.append_array(helpers) ### anyone who qualified as a helper but didn't help is now a watcher.
		for i in watchers:  ###  Repurposed the old code to handle everyone who didn't participate in the orgy.
			var person = i
			var toys = []
			var toy = globals.randomitemfromarray(orgyarray)  ### formerly shared
			if killed == true && person.fear < 50 && person.loyal < 40:
				person.fear += rand_range(20,30)
			for t in orgyarray:  ### Let's see if any of our guys really strike our fancy.
				var baddie = t
				if globals.expansion.getSexualAttraction(person,baddie):
					toys.push_back(baddie)
			if !toys.empty():  ### if toys isn't empty, there's a prefered partner, so we pick one of them. 
				toy = globals.randomitemfromarray(toys)
			if ((person.loyal < 30 && person.lewdness < 50) || person.traits.has('Prude')) && !person.checkVice('lust'):
				text+= person.dictionary('\n$name watches your actions with disgust, eventually averting $his eyes with a look of horror on $his face. \n')
				person.obed += -rand_range(15,25)
			elif (person.loyal >= 60 || globals.expansion.getSexualAttraction(person,globals.player) == true) && person.rules.masturbation == false && person.lewdness > 20:
				if (person.consent == true):
					text += person.dictionary(globals.randomitemfromarray(['\n$name watches openly and with great interest. After a few minutes, you see $his hand moving inside of $his pants as $he watches. ', '\nWhile you handle your business, $name keeps watch and busies one hand under $his clothes. ']))
					person.lust += rand_range(10,20)
					if person.lust >= 65 :
						text += toy.dictionary(globals.randomitemfromarray(['While $name\'s cries go unanswered, ','While you are having your way with $name, ']))
						text += person.dictionary(globals.randomitemfromarray(['$name lets out a moan and blushes. \n','$name smiles and gasps quietly. \n']))
						person.lust -= rand_range(20,35)
						person.metrics.orgasm += 1
						if person.penis != "none":
							person.cum.body += person.pregexp.cumprod
					else:
						text += ' \n'
				else:
					text += person.dictionary(globals.randomitemfromarray(['\n$name watches your deeds with some interest despite $himself. After a few minutes, you see $his hand moving inside of $his pants as $he watches. ','\nYou catch $name stealing glances while you work, and $his hands keep lingering near $his privates. ']))
					person.lust += rand_range(10,20)
					if person.lust >= 65:
						text += 'It\'s not long before '
						text += person.dictionary(globals.randomitemfromarray(['$he lets out a moan and blushes. \n','$he looks away with a quiet gasp. \n']))
						person.lust -= rand_range(20,35)
						person.metrics.orgasm += 1
						if person.penis != "none":
							person.cum.body += person.pregexp.cumprod
					else:
						text += ' \n'
			elif person.rules.masturbation == true && (person.lust >= 50 || person.loyal >= 50 || person.checkVice('lust')):
				text+= '\n'
				text += person.dictionary('As you work, $name\'s breathing grows heavier and $his eyes never leave you. While $he shifts from foot to foot, you recognize some glint of longing in $his gaze.\n ')
				person.lust += rand_range(5,15)
			elif person.lust >= 20 && person.lewdness <= 20 && (globals.expansion.getSexualAttraction(person,toy) || globals.expansion.getSexualAttraction(person,globals.player)):
				text += '\n'
				text += person.dictionary('$name watches your actions for several minutes before ')
				text += person.dictionary(globals.randomitemfromarray(['biting $his lip','blushing deeply']))
				text += person.dictionary(' and excusing $himself.')
				person.lewdness += rand_range(1,2)
				person.lust += rand_range(4,12)
				if person.lust >= 65 && person.rules.masturbation == false:
					text += person.dictionary(' $He returns looking flushed and embarassed. ')
					person.lust -= rand_range(20,35)
					person.metrics.orgasm += 1
					person.lewdness += rand_range(1,3)
					if person.penis != "none":
						person.cum.body += person.pregexp.cumprod
				text += '\n'
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
		if rand_range(0,100) >= 20 + globals.state.reputation[location]/4 + (rewardslave.npcexpanded.timesrescued*globals.expansionsettings.times_rescued_multiplier):
			text = "$name excuses $himself, but can't accept your proposal and quickly leaves. "
		else:
			rewardslave.obed = 85
			rewardslave.stress = 10
			globals.slaves = rewardslave
			text = "$name observes you for some time, measuring your words, but to your surprise, $he complies either out of symphathy, or out of the desperate life $he had to carry. "
			for i in globals.state.allnpcs.duplicate():
				if str(rewardslave.id) == str(i.id):
					globals.state.allnpcs.erase(i)
					break
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

func townhall_enter(town):
	main.animationfade()
	yield(main, 'animfinished')
	var buttons = []
	var text = "You enter the town hall of [color=aqua]" + str(town).capitalize() + "[/color]. You see a few desks set up for members of the council, receptionists, and local town guard liasons. You know that your reputation here is [color=aqua]" + str(round(globals.state.reputation[town])) + "[/color]. You take a moment to decide what you would like to accomplish here."
	
	
	buttons.append({name = 'Inquire about Recent Events', function = 'getTownReport', args = town, textcolor = 'green', tooltip = 'Hear news from yesterday'})
	if !globals.state.townsexpanded[town].townhall.fines.empty():
		buttons.append({name = "Pay a Fine",function = 'townhall_fines', args = town})
	
	if globals.state.townsexpanded[town].townhall.autopay_fines == false:
		buttons.append({name = "Register to Autopay Fines", function = 'townhall_toggle_autopay', args = town})
	else:
		buttons.append({name = "Stop Autopaying Fines", function = 'townhall_toggle_autopay', args = town})
	buttons.append({name = "Request Meeting with Council",function = 'townhall_meet_council', args = town})
	
	buttons.append({name = "Leave Town Hall", function = 'zoneenter', args = town})
	mansion.maintext = text
	outside.buildbuttons(buttons,self)

func townhall_meet_council(town):
	main.animationfade()
	yield(main, 'animfinished')
	var buttons = []
	var text = "You approach a receptionist to request a meeting with the town's leader. You are informed that you will not be able to make any requests or gain a meeting unless you have a Positive reputation (10+) with the town."
	#Assign/Get Leader
	var leader = globals.newslave('randomcommon', 'adult', 'random', 'rich')
	if str(globals.state.townsexpanded[town].localnpcs.leader) == str(-1):
		leader = globals.newslave('randomcommon', 'adult', 'random', 'rich')
	else:
		leader = globals.state.findslave(globals.state.townsexpanded[town].localnpcs.leader)
	#Show Leader Image
	
	#Show if Rep 10+
	if globals.state.reputation[town] >= 10:
		buttons.append({name = "Propose Law Change",function = 'townhall_law_change', args = town})
	
	buttons.append({name = "Return to the Town Hall Entryway", function = 'townhall_enter', args = town})
	mansion.maintext = text
	outside.buildbuttons(buttons,self)

func townhall_law_change(town):
	main.animationfade()
	yield(main, 'animfinished')
	var buttons = []
	var text = "You approach a receptionist and request that they consider voting on a potential law change. She gives you a form to submit the appeal. She informs you that making this request will cost you [color=aqua]" + str(globals.state.townsexpanded[town].townhall.law_change_cost) + " Reputation[/color] whether it passes or fails as you stake your reputation on it. "
	
	#Nudity Law
	text += "\n\n[center][color=#d1b970]Laws[/color][/center]\n\nPublic Nudity - "
	if globals.state.townsexpanded[town].laws.public_nudity == false && !globals.state.townsexpanded[town].currentevents.has('vote_public_nudity'):
		text += "[color=aqua]Illegal[/color] || Current Public Support to Legalize [color=aqua]" + str(globals.state.townsexpanded[town].nudity) + "[/color] "
		buttons.append({name = "Legalize Public Nudity", function = 'townhall_legalize_public_nudity', args = town})
	else:
		text += "[color=aqua]Legal[/color]"
	
	buttons.append({name = "Leave",function = 'zoneenter', args = town})
	mansion.maintext = text
	outside.buildbuttons(buttons,self)

func townhall_legalize_public_nudity(town):
	main.animationfade()
	yield(main, 'animfinished')
	var buttons = []
	var text = "You submit the request form for them to vote on legalizing public nudity. The vote will take place tonight, you won't hear about the results until tomorrow.\n[color=red]You have lost 5 Reputation with " + town.capitalize() + ". [/color]"
	globals.state.townsexpanded[town].currentevents.append('vote_public_nudity')
	globals.state.reputation[town] -= 5
	
	buttons.append({name = "Return to the Entryway", function = 'townhall_enter', args = town})
	mansion.maintext = text
	outside.buildbuttons(buttons,self)

func townhall_fines(town):
	main.animationfade()
	yield(main, 'animfinished')
	var buttons = []
	var text = "You approach the Town Guard desk and explain that you are interested in seeing the fines accrued under your estate. The officer brings forth the records of the fines. You will have to pay them in order of oldest to newest, but with a high enough reputation may be able to have some waived at a cost to that reputation."
	
	var currenttown =  globals.state.townsexpanded[town]
	buttons.append({name = "From Date = " + str(currenttown.townhall.fines.front()[0]) + "; Gold Cost = " + str(currenttown.townhall.fines.front()[1]), function = 'townhall_pay_fine_gold', args = town})
	if globals.state.reputation[town] >= 0:
		buttons.append({name = "Use Your Reputation to Waive 1 Fine", function = 'townhall_pay_fine_rep', args = town})
		
	buttons.append({name = "Return to the Entryway", function = 'townhall_enter', args = town})
	mansion.maintext = text
	outside.buildbuttons(buttons,self)

func townhall_pay_fine_gold(town):
	main.animationfade()
	yield(main, 'animfinished')
	var buttons = []
	var text = "You state that you are ready to pay your oldest fine. The guard extends their hand patiently. You hand over the pouch of gold and watch as they shred the fine and purge it from their records."
	
	var currenttown =  globals.state.townsexpanded[town]
	globals.resources.gold -= currenttown.townhall.fines.front()[1]
	currenttown.townhall.fines.pop_front()

	if !globals.state.townsexpanded[town].townhall.fines.empty():
		buttons.append({name = "Pay another Fine", function = 'townhall_fines', args = town})
	
	buttons.append({name = "Return to the Entryway", function = 'townhall_enter', args = town})
	mansion.maintext = text
	outside.buildbuttons(buttons,self)

func townhall_pay_fine_rep(town):
	main.animationfade()
	yield(main, 'animfinished')
	var buttons = []
	var text = "You ask if they know who you are and what you've done for this time. The guard nods slowly with growing confusion. You ask if while keeping in mind all of that good that there's anything they can do about this fine. The guard looks exasperated but nods and shreds it. You've lost some reputation with the town but your oldest fine is waived."
	
	var currenttown =  globals.state.townsexpanded[town]
	globals.state.reputation[town] -= floor(currenttown.townhall.fines.front()[1]/15)
	currenttown.townhall.fines.pop_front()
	
	if !globals.state.townsexpanded[town].townhall.fines.empty():
		buttons.append({name = "Pay another Fine", function = 'townhall_fines', args = town})
	
	buttons.append({name = "Return to the Entryway", function = 'townhall_enter', args = town})
	mansion.maintext = text
	outside.buildbuttons(buttons,self)

func townhall_toggle_autopay(town):
	main.animationfade()
	yield(main, 'animfinished')
	var buttons = []
	var text = ""
	if globals.state.townsexpanded[town].townhall.autopay_fines == false:
		text += "You gather some paperwork, fill it out, and approach a front desk to make arrangements to have your estate automatically pay for any fines accrued by any of your slaves while working in this town.\n\nThe young, perky female clerk smiles brightly at you as she takes your paperwork and files it away.\n[color=yellow]-No problem at all! We will make sure to automatically deduct any fines from your estate automatically. You won't have to come back here yourself to pay fines or anything.[/color]\n\nYou turn to leave as you here her giggle slightly behind you and whisper to herself.\n[color=yellow]-Assuming you couldn't think of any other reason to drop by, that is.[/color]"
		globals.state.townsexpanded[town].townhall.autopay_fines = true
	else:
		text += "You approach a clerk and explain that you want to revoke the arrangement currently in place for your estate to automatically pay for any fines accrued by any of your slaves while working in this town.\n\nShe nods and ruffles around for your paperwork before destroying it.\n[color=yellow]-Done. I guess we'll be seeing you around here a lot more now as you pay off all your debts to society, huh?[/color]\n\nShe laughs coyly and smiles at you as you walk out."
		globals.state.townsexpanded[town].townhall.autopay_fines = false
	
	buttons.append({name = "Return to the Entryway", function = 'townhall_enter', args = town})
	mansion.maintext = text
	outside.buildbuttons(buttons,self)
	
###---End Expansion---###

func wimborn():
	main.get_node('outside').wimborn()
	
	###---Added by Expansion---### Towns Expanded
	outside.addbutton({name = 'Enter Town Hall', function = 'townhall_enter', args = 'wimborn', textcolor = 'green', tooltip = 'Enter the Town Hall to pay fines or affect laws'}, self)
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
	array.append({name = 'Enter Town Hall', function = 'townhall_enter', args = 'gorn', textcolor = 'green', tooltip = 'Enter the Town Hall to pay fines or affect laws'})
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
	array.append({name = 'Enter Town Hall', function = 'townhall_enter', args = 'amberguard', textcolor = 'green', tooltip = 'Enter the Town Hall to pay fines or affect laws'})
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
		main.selectslavelist(true, 'shuriyaelfselect', self, 'person.findRace(["Elf"]) && !person.findRace(["Dark Elf"]) && !person.findRace(["Tribal Elf"])')
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
	array.append({name = 'Enter Town Hall', function = 'townhall_enter', args = 'frostford', textcolor = 'green', tooltip = 'Enter the Town Hall to pay fines or affect laws'})
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
