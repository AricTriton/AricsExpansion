### <CustomFile> ###

extends Node

###---Contains Functions for the Farm Expansion---###

var settings = {
	#---Farm Worker Determination
	#Skill: Most Skilled Chosen / Energy: Most Energy Chosen / Equal: Cycles Through All Available
	farmhand = 'equal',
	milkmaid = 'equal',
	stud = 'equal',
	#Adds a flat Lust bonus to Breeders. Orgasm per 100. Below 100 may not give an Orgasm
	basebreedlust = 75,
}

#Farm Arrays
var fluidtypes = ['milk','semen','lube','piss']
var snailautooptions = ['none','food','sell','hatch']
var vatsautooptions = ['vat','food','refine','sell']
var alldailyactions = ['rest','pamper','stimulate','exhaust','moo','inspection','prod']
var liquidtypes = ['milk','cum','piss']
var breedingoptions = ['none','breeder','stud','both']

#!!!
#Needed Functions: Buying Upgrades (Globals.State.Zones for Work (breed/milk) + sleep). Adding to Farm (showing options if available in the array, removing if selected), removing from the farm (re-adding to array if not Field/Dirt/Etc)
#Display Function showing # of Farm Zones (Work, Sleep), Furnishings (Bed, Propoganda), and Tools (Restraints, Pumps) Available
#Selector for Work (Breed/Milk) & Sleep, Dining (When Added, with Diet), and Furnishings/Tools
#!!!


#Description Dict's are called for each Farm Person when inspected
#Format is Person.Expression / GetIntro (specific Farm Intro added to it) + DailyAction(via adding farm1, 2, etc to chat for a variety) with the person's reaction (accidental mooing, enjoyment/hatred, etc)

var dailyActionReqDict = {
	'rest' : {'farmhand' : false},
	'pamper' : {'farmhand' : true, 'overlaps' : ['prod', 'stimulate']},
	'stimulate' : {'farmhand' : true, 'overlaps' : ['prod', 'pamper']},
	'exhaust' : {'farmhand' : true, 'overlaps' : ['inspection']},
	'moo' : {'farmhand' : false},
	'inspection' : {'farmhand' : true, 'overlaps' : ['exhaust']},
	'prod' : {'farmhand' : true, 'overlaps' : ['pamper', 'stimulate'], 'farmitems' : ['prods']},
}


#Extrators: Method of Obtaining Milk
#Old Extraction Ideas

var extractorsarray = ['sealed', 'hand', 'leak', 'suction', 'pump', 'pressurepump']
var extractorsdict = {
	sealed = {name = 'Sealed', description = "couldn't be collected as $he was sealed up", low = 0, high = 0, cost = 0},
	hand = {name = 'Hand', description = "was extracted by hand", low = 0, high = 1, cost = 0},
	leak = {name = 'Leaking', description = "dripped out of $him", low = .2, high = 0.5, cost = 0},
	suction = {name = 'Suction Cup', description = "flowed out of $him into the suction cups", low = .3, high = .6, cost = 50},
	pump = {name = 'Basic Pump', description = "was actively pumped out of $him", low = .4, high = .8, cost = 100},
	pressurepump = {name = 'Pressure Pump', description = "was pumped out of $him using extreme suction", low = .5, high = 1, cost = 250},
}

#Containers: The % of milk preserved
var containersarray = ['cup','bucket','pail','jug','canister', 'bottle']
var containerdict = {
	cup = {name = 'cup', description = "A cup was pressed up against $his", size = 6, spillchance = 'high', cost = 0},
	bucket = {name = 'bucket', description = "A bucket was placed beneath $his", size = 16, spillchance = 'high', cost = 15},
	pail = {name = 'pail', description = "A metal pail was placed beneath $his", size = 14, spillchance = 'medium', cost = 25},
	jug = {name = 'jug', description = "The mouth of a ceramic jug was pressed against $his", size = 12, spillchance = 'low', cost = 35},
	canister = {name = 'canister', description = "A strange, metallic canister was pressed against $his", size = 18, spillchance = 'low', cost = 50},
	bottle = {name = 'bottle', description = "The mouth of a glass bottle was pressed against $his", size = 2, spillchance = 'none', cost = 10},
}

var allworkstations = ['free','rack','cage']
var workstationsdict = {
	free = {name = 'Free Roaming', cost = 0},
	rack = {name = 'Milk Rack', cost = 250, textLack = "Insufficient Racks"},
	cage = {name = 'Metal Cage', cost = 500, textLack = "Insufficient Cages"},
}

var allbeddings = ['dirt','hay','cot','bed']
var beddingdict = {
	dirt = {name = 'dirt', gainstress = 10, losestress = 0, gainenergy = 25, healchance = 25, cost = 0},
	hay = {name = 'pile of hay', gainstress = 5, losestress = 0, gainenergy = 50, healchance = 50, cost = 100, textLack = "Insufficient Hay"},
	cot = {name = 'metal cot', gainstress = 0, losestress = 5, gainenergy = 75, healchance = 75, cost = 500, textLack = "Insufficient Cots"},
	bed = {name = 'feather bed', gainstress = 0, losestress = 10, gainenergy = 100, healchance = 100, cost = 1000, textLack = "Insufficient Beds"},
}

var itemsdict = {
	aphrodisiac = {name = 'Aphrodisiac', cost = 75},
	sedative = {name = 'Sedative', cost = 75},
	prods = {name = 'Cattle Prod', cost = 50},
}

var spillchances = {
	none = {'min': 0, 'max': 0},
	low = {'min': 0, 'max': 10},
	medium = {'min': 5, 'max': 15},
	high = {'min': 10, 'max': 25},
}


var reactiondict = {
	henreaction = {
		nointerest = {
			horny = "$He actually seems disappointed that no snail found $him attractive enough to breed.",
			pleading = "$He seems relieved that there isn't a snail pounding $his [pussy] right now. [color=yellow]\n-Oh thank goodness...[/color]",
			horrified = "$He seems to be in shock as $he looks around at the disinterested snails with $his [pussy] completely vulnerable."
		},
		attracted = {
			horny = "$He seems to be turned on by the situation. $He keeps slightly wiggling $his hips invitingly while staring at the snail, and it looks like $his [pussy] is dripping wet.",
			pleading = "$He watches the approaching snail with a panic. $He keeps shouting and pleading with it to go away and just leave $him alone. [color=yellow]\n-Please, just go away![/color]",
			horrified = "$He seems to be in shock and is merely watching $his fate slowly approach $him."
		},
		fucking = {
			horny = "$He is pushing $his [pussy] against the snail and grinding it. $He has obviously fully embraced the situation and lets out a happy squeal as $he cums with a loud squealching noise.",
			pleading = "$He starts begging you and the farm manager to stop this in a deep, breathy whimper as the snail starts to flood $his brain with aphrodesiacs. [color=yellow]\n-S-stop this! P-please! I...I...NGH![/color]",
			horrified = "$He has $his eyes closed and keep trying to resist. It is obviously not working. $He suddenly arches $his back and shudders, then looks even more horrified that $he just came from this."
		},
		inseminated = {
			horny = "Not all of that cum seems to be from the snail, however. As you watch, $he is so overcome with pleasure from the oozing feeling between $his legs that $he sprays out a little stream of cum from $his [pussy].",
			pleading = "$He is whimpering and cowering pitifully as $his body leaks fluids. $He whines at you. [color=yellow]\n-It coming out is a good thing, right?[/color]",
			horrified = "$He is gasping and as pale as a ghost. $He can't seem to stop staring blankly as $his own oozing orifice."
		},
		impregnated = {
			horny = "$He is laying back with a little smile. $He seems to have fully accepted the situation.",
			pleading = "$He looks over at you and pouts. [color=yellow]\n-Its not too late, right? It...it can be stopped?[/color]",
			horrified = "$He seems to be in shock still. [color=yellow]\n-Wh-what's happening to me?/color]"
		},
		swollen = {
			horny = "$He seems to be enjoying the feeling of the mass inside of $him. $He is slowly rubbing $his [pussy] while touching $his belly fondly.",
			pleading = "$He is merely laying there while rubbing $his belly meekly. As you get closer, you hear $him whispering to $his belly. [color=yellow]\n-Just come right out and make it easy for me, please?[/color]",
			horrified = "$He seems to be in extreme discomfort. As you watch, $he loses control of $his bladder and starts gushing all over $himself from the pressure."
		},
		wriggling = {
			horny = "$He seems unable to stop touching $himself as $his belly squirms. $He watches a lump rise and fall in $his stomach while rubbing $his clit furiously and moaning loudly.",
			pleading = "$He seems to be in denial as $his stomach writhes and moves. $He keeps pleading to get out of the pit and for it all to stop. Reality will come sliding out of $him soon enough.",
			horrified = "$He is pale-faced and obviously trying to keep from vomiting as $his stomach writhes. $He watches as a slimey leg slips out of $his [pussy] and back inside, then loses it at last.",
		},
		birth = {
			horny = "$He seems to be enjoying $himself. As $his pussy pushes out the snail, $he moans and shudders in a violent orgasm.",
			pleading = "$He seems to be completely in shock as $he sobs and whimpers pitifully. $He just keeps saying [color=yellow]\n-Not again, please! Please, no more![/color]",
			horrified = "$He is passed out cold with $his eyes still open. You see no signs of consciousness as $his body violently shakes and squirts again as the snail exits fully."
		},
	},
}

#Hen Check gives Snail Growth for the day. Then Text is Growth + " " + Reaction + Dialogue Reaction (change Pleadings with Dialogue)
#Similar for Cows

#The "Result" of a Hen's day 
var snailgrowth = ['nointerest','attracted','fucking','inseminated','impregnated','swollen','wriggling','birthing']


#Used by most scripts: var farmmanager = getFarmManager()
func getFarmManager():
	for i in globals.slaves:
		if i.work == 'farmmanager':
			return i
	return null

var person

#---Description Options---#
#Called via getdescription('object')

var descriptions = {
	stallbedding = {
		dirt = "in the corner of $his stall. $He is sleeping directly on the dirt and the dirt clings to $his shivering naked body. ",
		hay = "on a pile of hay that has been spread out to make an uncomfortable looking bed. ",
		cot = "on a small, metal cot that has been erected in the corner of the room. It is barely big enough for $his body and $his arms and legs are hanging off of the sides. ",
		bed = "on a small wooden bed in the corner of the room. It seems to be sized just right to allow $him to sleep comfortably. ",
	},
	workstation = {
		free = "on all fours. ",
		rack = "locked inside of a metal milking rack. ",
		cage = "locked inside of a tight metal cage. $He seems to be completely unable to move or shift and the metal is digging into different parts of $his body all over. ",
	},
#	extractionmethod = {
#	buckets = "$name's udders are milked by hand into [color=aqua]wooden buckets[/color]. These wooden buckets leak often and usually leak up to half of what it holds.",
#	pails = "$name's udders are milked by hand into [color=aqua]metal pails[/color]. The amount of milk depends entirely on the skill of the farm's manager.",
#	handpumps = "$name's udders are milked using [color=aqua]hand-operated pumps[/color] by the Farm Manager. Their efficiency is far better at extracting milk, but still requires the Farm Manager to operate.",
#	autopumps = "$name's udders are attached to [color=aqua]automatic pumping machines[/color] via suction cups, which loudly whir away while tugging at the cow's nipples. They are very efficient, though prone to clogging.",
#	premiumpumps = "$name's udders are attached to [color=aqua]high quality automatic pumping machines[/color] via suction cups, which quietly hum while tugging at the cow's nipples. They are very efficient and far less prone to clogging up.",
#	mysticalpumps = "$name's udders are attached to [color=aqua]magically infused automatic pumps[/color] via suction cups and almost never clog. The pumps have small, glowing crystals around the suction cups which occassionally flash brightly. The pumps are completely silent, though the flashes are accompanied by moans and a violent gushing sound as milk explodes from $his nipples."
#	},
	henresult = {
		nointerest = "$name doesn't seem to have gained the interest of any snails today.",
		attracted = "$name has a snail sliding slowly toward $his exposed pussy.",
		fucking = "$name has a snail on $him currently. You see the snail's slimey [penis] sliding sloppily into $his waiting [pussy].",
		inseminated = "$name has a pile of slimey, gloopy gunk oozing out of $his [pussy] right now. It appears $he was recently inseminated.",
		impregnated = "$name has a small bump in $his belly. It is obvious that $he has been successfully bred and is pregnant.",
		swollen = "$name's belly is incredibly swollen. $He looks incredibly uncomfortable as it sways back and forth.",
		wriggling = "$name's stomach is wriggling and churning with life inside. $He is going to pop very soon.",
		birth = "$name's pussy is spurting and oozing fluids and slime constantly. You watch as a baby snail slides through $his gaping pussy lips to a gush of viscous fluid. You doubt if even $name knows if that was piss, embreotic fluid, or something from the snail itself.",
	},
}

#Shows when the person is selected in the Farm
func getFarmDescription(tempperson):
	var text = ""
	var person = tempperson
	globals.expansion.updatePerson(person)
	#Bedding
	if person.dailytalk.has('farmmorning'):
		person.dailytalk.append('farmmorning')
		text += "You walk over to see the stall where [color=aqua]$name[/color] sleeps. The " +str(person.race)+ " $child is curled up and sleeping " + getdescription(person, 'stallbedding')
	#Work Station
	else:
		text += "You walk over to see the stall where [color=aqua]$name[/color] sleeps. The " +str(person.race)+ " $child is " + getdescription(person, 'workstation')
	
	#Restrained
	if person.farmexpanded.restrained == true:
		text += "\n$He has a collar, cuffs, and restraints all over $his body to keep $him as restricted as possible. "
	
	###CHANGE THIS: Add Milking Extraction / Snail/Breeder
	
	#Contentment
	text += "\n\n"
	if person.npcexpanded.contentment >= 0:
		text += "$He looks up at you and gives you a relaxed smile. "
	else:
		if person.cour >= 50:
			text += "$He looks up at you and sneers. $He looks very upset. "
		elif person.energy <= 50:
			text += "$He wearily lifts $his head and looks at you. $He seems to be utterly exhausted and physically broken. "
		else:
			text += "$He doesn't look up at you as you come close. $He looks utterly miserable. "
	
	#Mind-Broken
	if person.wit <= 10:
		text += "You look into $his blank eyes and see very little signs of intelligence left. $His mind seems to have broken and $his wits have fled $him. "
	elif person.conf <= 10:
		text += "You look into $his eyes and $he whimpers and tries to look away. $He seems to be a meek, skittish, and submissive cow. "
	
	#Daily Action: Moo
	if person.farmexpanded.dailyaction == 'moo':
		if person.mind.accepted.has('moo'):
			text += "\n\n$He lets out a loud [color=yellow]-Moooo[/color] as you watch, obviously unashamed in $his daily assignment. "
		else:
			text += "\n\n$He opens $his mouth to speak then quickly stops $himself. $He whimpers, then lets out a weak [color=yellow]-Mooo[/color]. $He is obviously still coming to terms with $his daily assignment. " 
	elif person.farmexpanded.dailyaction == 'prod':
		text += "\n\n$He opens $his mouth to speak. $He is touched gently by a cattle [color=aqua]prod[/color] held by one of your farm hands, which then sends $him into a series of painful spasms. "
	elif person.farmexpanded.dailyaction == 'pamper':
		text += "\n\n$He is being stroked and massaged by one of your farmhands and looks like $he is enjoying a moment of comfort as $he is [color=aqua]pampered[/color]. "
	elif person.farmexpanded.dailyaction == 'rest':
		text += "\n\n$He is [color=aqua]resting[/color] as best $he can and seems to be enjoying the peaceful moment to $himself. "
	elif person.farmexpanded.dailyaction == 'inspection':
		text += "\n\n$He is naked and shivering slightly from his time outside during $his mandatory [color=aqua]public inspection[/color] earlier. "
	elif person.farmexpanded.dailyaction == 'exhaust':
		text += "\n\n$His naked body is glistening with sweat as $he breathes heavily, still [color=aqua]exhausted[/color] from $his forced workout earlier. "
	elif person.farmexpanded.dailyaction == 'stimulate':
		text += "\n\n$He is moaning as a farmhand strokes $his genitals, asshole, and around $his naked body. $His arousal from the [color=aqua]constant stimulation[/color] is apparent. "
	
	#Display Tits
	text += "\n\nYou look and see that $his " + str(globals.expansion.getChest(person)) + " are "
	if person.lactation == true:
		if person.lactating.hyperlactation == true:
			text += "[color=lime]Hyperlactating[/color], producing far more [color=aqua]Milk[/color] than $he could naturally."
		else:
			text += "[color=aqua]Lactating[/color]."
	else:
		text += "[color=red]Not Lactating[/color]. $He will provide no [color=aqua]Milk[/color] unless you use a [color=aqua]Nursing Potion[/color], the [color=aqua]Leak[/color] Spell, or $he becomes [color=aqua]Pregnant[/color]."
	
	#Contentment Summary
	text += "\n\nContentment: " + str(person.displayContentment())
	
#Changed Format
#	text = getdescription('livingspace') + getdescription('bedding') + getdescription('livingspace')
#	else:
#		if person.movement != 'none' && rand_range(0,1) <=.25:
#			text = getdescription('mobility') + getdescription('movement') + getdescription('hobby')
#		else:
#			if person.work == 'cow':
#				text = getdescription('milkingspace') + getdescription('extractionmethod') #getEvent &or Reaction
#			elif person.work == 'hen':
#				text = getdescription('breedingspace') + getdescription('breedingmethod') #getEvent &or Reaction
	text = person.dictionary(text)
	#decode(text)
	return text

#Run Decoder after Descriptions
func decode(text):
	text = text.replace('[penis]',str(globals.randomitemfromarray(['penis','cock','member','dick','penis','cock','member','dick','johnson','todger','wick'])))
	text = text.replace('[pussy]',str(globals.randomitemfromarray(['pussy','pussy','twat','cunt','cunt','vagina','fanny','box','cunny'])))
	return text

#Modified from Description.gd
func getdescription(person, value):
	if value == 'field':
		#Field
		if globals.state.mansionupgrades.farmfield >= 2:
			value = 'walledfield'
		elif globals.state.mansionupgrades.farmfield >= 1:
			value = 'fencedfield'
		else:
			value = 'openfield'

	if descriptions.has(value) && descriptions[value].has(person.farmexpanded[value]):
		return globals.randomitemfromarray( descriptions[value][ person.farmexpanded[value] ].split('|',true) )
	elif descriptions.has(value) && descriptions[value].has('default'):
		return descriptions[value].default
	else:
		return "[color=red]Error at getting description for " + value + ": " + person.farmexpanded[value] + '[/color]. '

###---End Expansion---###

#---Full Milking Function
#var counter = 0

var refSnails
var refVats
var refContainers
var refWorkerCycles
var merchantcounter

func dailyFarm():
	var text = ""
	var farmmanager = null
	var studs = []
	#QuickRefs
	refSnails = globals.resources.farmexpanded.snails
	refVats = globals.resources.farmexpanded.vats
	refContainers = globals.resources.farmexpanded.containers
	refWorkerCycles = globals.resources.farmexpanded.worker_cycle
	
	var workersDict = {
		'farmmanager' : [],
		'farmhand' : [],
		'milkmaid' : [],
		'bottler' : [],
		'milkmerchant' : [],
		'cooking' : [],
		'storewimborn' : [],
		'cow' : [],
	}
	
	#Farm Not Built Check
	if globals.state.farm < 3:
		text += "[center]You've always wondered what it would be like to own a [color=aqua]Farm[/color]. Perhaps one day you will?[/center]"
		return text
	
	#---Assign NPC Roles
	for person in globals.slaves:
		if person.away.duration == 0:
			if workersDict.has(person.work):
				workersDict[person.work].append(person)
			#Assign Studs
			if person.farmexpanded.breeding.status in ["stud","both"]:
				if person.penis != 'none' && person.farmexpanded.restrained == false && person.farmexpanded.workstation == 'free':
					studs.append(person)

	merchantcounter = workersDict.storewimborn.size()

	#---Empty Positions Check
	if workersDict.cow.empty():
		text += "[color=red]No Cattle were present for milking in the Farm today.[/color]\n"
	else:
		#temp filter, TODO: check for problem sources then remove filter
		for cattle in workersDict.cow.duplicate():
			if cattle.sleep != 'farm':
				workersDict.cow.erase(cattle)
	
	var farmhands = workersDict.farmhand
	var canwork = true
	#Farm Manager Substitutes for Empty Positions
	if workersDict.farmmanager.empty():
		var tempText = PoolStringArray()
		if farmhands.empty():
			tempText.append("[color=aqua]Farmhands[/color] to [color=aqua]herd[/color] the Cattle")
		if workersDict.milkmaid.empty():
			tempText.append("[color=aqua]Milkmaids[/color] to [color=aqua]milk[/color] the Cattle")
		if !tempText.empty():
			canwork = false
			text += "[color=red]There are no available "+tempText.join(" and no ")+" today, and there is no [color=aqua]Farm Manager[/color] available to do the work instead.\n[/color]"
	else:
		farmmanager = workersDict.farmmanager.front()
		farmmanager.add_jobskill('farmmanager')
		if farmhands.empty():
			farmhands.append(farmmanager)
		if workersDict.milkmaid.empty():
			workersDict.milkmaid.append(farmmanager)

	#End if No Positions and No Farm Manager
	
	text += "\n[color=#d1b970][center]-----Morning-----[/center][/color]"
	if canwork == false:
		if !workersDict.cow.empty():
			text += "\n[color=red]The Cattle went [color=aqua]unmilked[/color] today.\n[/color]"
	else:
		#---Herd Cattle
		var tempText = PoolStringArray()
		for cattle in workersDict.cow:
			tempText.append(morningUpdate(cattle, farmhands))
		text += tempText.join("\n")

		#var lustmod = 0
		var milkmaid
		text += "[color=#d1b970]\n\n[center]-----Daytime-----[/center][/color]"
		for cattle in workersDict.cow:
			milkmaid = chooseworker('milkmaid', workersDict.milkmaid)
			#lustmod = clamp(round((cattle.lust-50)*.1), 0, 5) * 4
			#Correct Spacing
			if cattle != workersDict.cow.front():
				text += "\n"
			text += "[color=#d1b970]\nLivestock: [color=aqua]$name[/color][/color]"

			if cattle.farmexpanded.extractmilk.enabled == true:
				text += extractMilk(cattle, milkmaid, farmmanager)

			if cattle.farmexpanded.dailyaction == 'stimulate':
				text += stimulateCattle(cattle)
			
			if cattle.farmexpanded.breeding.status in ["both","breeder"]:
				if cattle.vagina != 'none':
					text += breedCattle(cattle, studs)

			if cattle.farmexpanded.breeding.status == 'snails' || cattle.farmexpanded.breeding.snails == true:
				text += breedSnails(cattle)

			if cattle.farmexpanded.extractcum.enabled == true:
				text += captureFluids(cattle, milkmaid)

			if cattle.farmexpanded.extractpiss.enabled == true:
				text += extractPiss(cattle, milkmaid)

			if cattle.farmexpanded.dailyaction == 'prod':
				text += prodCattle(cattle)
			elif cattle.farmexpanded.dailyaction == 'moo':
				text += mooCattle(cattle)
			elif cattle.farmexpanded.dailyaction == 'pamper':
				text += pamperCattle(cattle)
			elif cattle.farmexpanded.dailyaction == 'rest':
				text += restCattle(cattle)

			text += updateContentment(cattle)

			text = cattle.dictionary(text)
	
	#---Sleep/Bedding Effects
	text += "[color=#d1b970][center]\n\n-----Evening-----[/center][/color]"
	for cattle in workersDict.cow:
		text += sleepCattle(cattle)

	text += manageSnails(workersDict)
	text += manageVats(workersDict)

	text += "[color=#d1b970][center]\n\n-----Sales Results-----[/center][/color]"
	text += sellFluids(workersDict)
	text += sellMilk(workersDict)

	#Finished
	return text


func morningUpdate(cattle, farmhands):
	var farmhand = chooseworker('farmhand', farmhands)
	
	if !farmhand.jobskills.has('farmhand'):
		farmhand.jobskills['farmhand'] = 0
	farmhand.add_jobskill('farmhand')

	var text = "[color=#d1b970]\nLivestock: [color=aqua]$name[/color] | Worker: [color=aqua]" + farmhand.name_short() + "[/color][/color]"
	
	if cattle.spec == 'hucow':
		text += "\n[color=aqua]$name[/color] is a trained [color=aqua]Hucow[/color]."
				
	var actionresult
	#Daily Action: Exhaust
	if cattle.farmexpanded.dailyaction == 'exhaust':
		actionresult = round(cattle.energy/2) - (cattle.send*2)
		cattle.energy -= actionresult
		text += "\n[color=aqua]$name[/color] was forced to run around the fields for the first part of the morning to try and tire $him out. $He lost [color=red]" + str(actionresult) + " Energy[/color] from the exercise and should be easier for your workers to manage today. "
		if cattle.checkContentmentLoss('med') == true:
			text += "$He seemed to be upset by being forced to exercise today and has lost [color=aqua]Contentment[/color]. "
	#Daily Action: Inspection
	elif cattle.farmexpanded.dailyaction == 'inspection':
		text += "\n[color=aqua]$name[/color] was paraded out in front of the entire farm. Everyone available gathered around and inspected $his body and intimate parts with close scrutiny. "
		if cattle.checkFetish('exhibitionism') == true || cattle.spec == 'hucow':
			cattle.setFetish('exhibitionism', 1)
			actionresult = clamp(round(cattle.beauty*.1), 1, 10)
			cattle.conf += actionresult
			text += "$He seemed to actually enjoy the attention that $he got from everyone and seemed to gain [color=green]" +str(actionresult) + " Confidence[/color] in $himself. "
			if cattle.checkContentmentLoss('low') == true:
				text += "Despite the fact that $he seemed to enjoy it in the end, it still was not pleasant standing shivering and naked in front of everyone. $He has lost [color=aqua]Contentment[/color]. "
			else:
				cattle.npcexpanded.contentment += 1
				text += "$He really seemed to enjoy it the public humiliation and seemed visibly aroused while shivering and naked in front of everyone at the farm. $He has gained [color=aqua]Contentment[/color]. "
		else:
			actionresult = clamp(round((100-cattle.beauty)*.1), 1, 10)
			cattle.conf -= actionresult
			text += "$He seemed very upset as everyone pointed out every tiny imperfection on $his body. The experience seemed to shake his [color=aqua]Confidence[/color] and $he lost [color=red]" +str(actionresult) + " Confidence[/color] in $himself. "
			if cattle.checkContentmentLoss('high') == true:
				text += "$He seemed very upset by the humiliation of standing shivering and naked in front of everyone. $He has lost [color=aqua]Contentment[/color]. "

	#Inject Sedative
	if cattle.farmexpanded.usesedative == true:
		if globals.itemdict.sedative.amount > 0:
			globals.itemdict.sedative.amount -= 1
			cattle.farmexpanded.sedative += 1
			text += "\n[color=aqua]" + farmhand.name_short() + "[/color] successfully dosed [color=aqua]$name[/color] with a [color=aqua]Sedative[/color] as instructed. "
		else:
			text += "\n[color=aqua]" + farmhand.name_short() + "[/color] tried to give [color=aqua]$name[/color] $his dose of [color=aqua]Sedative[/color] as instructed, but [color=red]none were available[/color]. "
	
	#Sedative Effects
	if cattle.farmexpanded.sedative > 0:
		cattle.farmexpanded.sedative -= 1
		text += "[color=aqua]$name[/color]'s body was flooded by the [color=aqua]Sedative[/color] inside of $him. $His energy has been halved. "
		cattle.energy = round(cattle.energy*.5)
	
	#Resistance Factors
	var mentresist = ((cattle.conf + cattle.wit)/2) * (cattle.cour*.001)
	mentresist = clamp(mentresist, 1 ,100)
	var physresist = (1 + cattle.sstr + cattle.sagi)*(cattle.energy*.01)
	physresist = clamp(physresist, 1, 100)
	var struggle = 0
	
	#Herd Cattle (Determine Resistance)
	if cattle.checkFetish('submission', 1.25) == true || cattle.consentexp.livestock == true || mentresist <= 0 || cattle.spec == 'hucow':
		text += "\n[color=aqua]$name[/color] [color=lime]peacefully[/color] allowed [color=aqua]" + farmhand.name_short() + "[/color] "
		if cattle.farmexpanded.workstation == 'cage':
			text += "to lock $him into the tight, metal cage for the day.\n "
		elif cattle.farmexpanded.workstation == 'rack':
			text += "to hook $him into $his place on the metal rack for the day.\n "
		else:
			text += "to help $him onto $his hands and knees to begin milking for the day.\n "
		struggle = -1
	else:
		text += "\n[color=aqua]$name[/color] [color=red]resisted[/color] [color=aqua]" + farmhand.name_short() + "[/color] "
		if cattle.farmexpanded.workstation == 'cage':
			text += "as $he was locked into the tight, metal cage for the day. $He was barely able to move once inside of the cage."
			struggle = globals.expansionsettings.cagestrugglemod + mentresist + physresist
			if rand_range(0,100) <= globals.expansionsettings.cagedamagechance + physresist:
				cattle.health -= round(clamp(physresist, 0, cattle.health/2))
				text += "[color=aqua]$name[/color] lost [color=red]" + str(round(physresist)) + " Health [/color] from struggling inside of the cage. "
		elif cattle.farmexpanded.workstation == 'rack':
			text += "as $he was hooked into $his place on the metal rack for the day. $He was held so $his valuable privates could be accessed, though $he found that $he could still wiggle around to cause trouble. "
			struggle = globals.expansionsettings.rackstrugglemod + mentresist + physresist
		else:
			text += "as $he was forced to stay still on $his hands and knees while $he was used like an animal today. "
			struggle = globals.expansionsettings.freestrugglemod + mentresist + physresist
		cattle.energy -= round(physresist)
		text += "\n[color=aqua]$name[/color] spent [color=red]" + str(round(physresist)) + " Energy [/color] struggling against [color=aqua]" + farmhand.name_short() + "[/color]. "

		#Keep Restrained
		if cattle.farmexpanded.restrained == true:
			struggle += globals.expansionsettings.restrainedstrugglemod
			cattle.stress += round(mentresist)
			text += "\n[color=aqua]$name[/color] gained [color=red]" + str(round(mentresist)) + " Stress [/color] struggling against the restraints $he was kept in all day. "
			if cattle.checkContentmentLoss('high') == true:
				text += "$He was obviously very upset by being unable to move and has lost [color=aqua]Contentment[/color]."
		struggle -= farmhand.sstr
		struggle = clamp(struggle, 0, 9)
		if farmhand.energy >= struggle:
			farmhand.energy -= round(struggle)
			text += "\n[color=aqua]" + farmhand.name_short() + "[/color] spent [color=red]" + str(round(struggle)) + " Energy [/color] subduing the struggling cattle.\n "
	cattle.farmexpanded.resistance = struggle

	#Add Relations
	#Cattle Relation
	if rand_range(0,100) <= (cattle.obed-100) + (farmhand.conf + farmhand.sstr) || struggle > 0 && (cattle.traits.has('Masochist') || cattle.traits.has('Submissive')) || cattle.spec == 'hucow':
		globals.addrelations(cattle, farmhand, rand_range(20,40))
	else:
		globals.addrelations(cattle, farmhand, rand_range(-20,-40))
	#Worker Relations
	if struggle <= 0 || struggle > 0 && (farmhand.traits.has('Sadist') || farmhand.traits.has('Dominant')):
		globals.addrelations(farmhand, cattle, rand_range(20,40))
	else:
		globals.addrelations(farmhand, cattle, rand_range(-20,-40))
	
	#Inject Aphrodisiac
	if cattle.farmexpanded.giveaphrodisiac == true:
		if globals.itemdict.aphrodisiac.amount > 0:
			globals.itemdict.aphrodisiac.amount -= 1
			cattle.farmexpanded.aphrodisiac += 1
			text += "\n[color=aqua]" + farmhand.name_short() + "[/color] successfully dosed [color=aqua]$name[/color] with [color=aqua]Aphrodisiac[/color] as instructed. "
		else:
			text += "\n[color=aqua]" + farmhand.name_short() + "[/color] tried to give [color=aqua]$name[/color] $his dose of [color=aqua]Aphrodisiac[/color] as instructed, but [color=red]none were available[/color]. "
	elif cattle.farmexpanded.aphrodisiac > 0:
		cattle.farmexpanded.aphrodisiac -= 1
		if cattle.farmexpanded.aphrodisiac <= 0:
			text += "[color=aqua]$name[/color]'s body shook off the lingering [color=aqua]Aphrodisiac[/color] in $his system and returned to normal. "
		elif rand_range(0,1) <= .2:
			text += "[color=aqua]$name[/color]'s body is still feeling the lingering effects of the [color=aqua]Aphrodisiac[/color] in $his system. "
	
	#Aphrodisiac Effects
	if cattle.farmexpanded.aphrodisiac > 0:
		var aphroeffect = clamp(cattle.farmexpanded.aphrodisiac * 5, 0, 100)
		text += "[color=aqua]$name[/color]'s body was flooded by the [color=aqua]Aphrodisiac[/color] inside of $him. $His lust is enflamed by " + str(aphroeffect) + ". "
		cattle.lust += aphroeffect
		if rand_range(0,100) <= aphroeffect:
			text += "[color=aqua]$name[/color]'s wits are so clouded by the flood of [color=aqua]Aphrodisiac[/color] that they have permanently dulled. It may be a good idea to take $him off of them for a while to prevent further damage. "
			cattle.wit -= 3
			cattle.lewdness += 3

	return cattle.dictionary(text)


func extractMilk(cattle, milkmaid, farmmanager):
	#Invalid Check
	if cattle.lactation == false:
		return "\n[color=red]$name is not currently lactating.[/color] "
	elif cattle.lactating.milkstorage <= 0:
		return "\n[color=red]$name did not successfully produce any milk today.[/color] "
	
	var milkproduced = 0
	var extractionmod = 0
	var effort = 0
	var text = ''
	var container = containerdict[cattle.farmexpanded.extractmilk.container]

	#Perfect Info
	if globals.expansionsettings.perfectinfo == true:
		text += "\n[color=aqua]$name[/color] has the following stats: "
		if cattle.lactating.hyperlactation == true:
			text += "[color=lime]Hyperlactation[/color] | "
		text +=  "Milk Storage: " +str(cattle.lactating.milkstorage)+ " | Milk Regeneration: " +str(cattle.lactating.regen)+ ""
		if cattle.lactating.pressure > 0:
			text += " | Pressure = " +str(cattle.lactating.pressure)+ "\n "
	
	#Container Description
	text += "\n[color=aqua]$name[/color] was prepped for [color=aqua]milking[/color]. " + container.description + " " + globals.expansion.nameTitsMilking() + ". "
	#Determine Milk Extraction Method
	if cattle.farmexpanded.extractmilk.method != 'hand':
		var refExtractor = extractorsdict.get(cattle.farmexpanded.extractmilk.method)
		if refExtractor != null:
			#Automatic Extraction
			text += "$His milk [color=aqua]" + str(refExtractor.description) + "[/color]. [color=aqua]" + milkmaid.name_short() + "[/color] assisted in retrieving the extracted milk. "
			extractionmod = rand_range(refExtractor.low, refExtractor.high)
		else:
			extractionmod = rand_range(0,1)
			print("Milk Extractor not found for Cattle ID " + str(cattle.id) + ". Random 0-100 substituted")
	else:
		#Manual Extraction
		text += "$He was milked manually today by [color=aqua]" + milkmaid.name_short() + "[/color]. "
		effort = round(rand_range(1, milkmaid.send+1))
		milkmaid.energy -= effort
		milkmaid.add_jobskill('milking', round(effort*.25))
		text += "[color=aqua]" + milkmaid.name_short() + "[/color] spent [color=aqua]" + str(effort) + " Energy[/color] milking [color=aqua]$name[/color]. "
		extractionmod = clamp(milkmaid.jobskills.milking * .25, 0, effort)
	
	#Metrics
	cattle.lactating.milkedtoday = true
	cattle.farmexpanded.timesmilked += 1
	cattle.lactating.daysunmilked = 0
	
	#Pressure Production (100% Extraction)
	milkproduced = cattle.lactating.pressure
	if cattle.lactating.pressure > 0:
		text += "$His " + globals.expansion.getChest(cattle) + " were swollen beyond their normal capacity. $His " + globals.expansion.nameTits() + " exploded with [color=green]" + str(cattle.lactating.pressure) + "[/color] Milk as soon as the milking started. "
		cattle.lactating.milkstorage -= cattle.lactating.pressure
		cattle.lactating.pressure = 0
	
	#Pregnancy/Hyperlactation Bonus
	var lactationbonus = 0
	var extraproduction = 0
	if cattle.preg.duration > 0:
		lactationbonus = clamp(cattle.metrics.preg*.05, .05, 2)
		extraproduction = round(cattle.lactating.milkstorage * lactationbonus)
		if cattle.knowledge.has('currentpregnancy'):
			text += "$He was able to produce more milk than normal today due to $his [color=aqua]pregnancy[/color]. $His [color=aqua]" + str(cattle.metrics.preg) + "[/color] pregnancies have altered $his body to produce milk at a greater rate throughout the day. "
		else:
			text += "$He continued to produce milk far longer than $he was expected to today. "
			if farmmanager != null && rand_range(0,100) <= farmmanager.wit + farmmanager.jobskills.farmmanager:
				text += farmmanager.dictionary("[color=aqua]$name[/color] suspects that [color=aqua]" + cattle.name_short() + "[/color] is [color=aqua]pregnant[/color]. $He tests the cow while it is being milked and confirms the happy news. ")
				farmmanager.add_jobskill('farmmanager')
				cattle.knowledge.append('currentpregnancy')
			elif farmmanager != null:
				text += "[color=aqua]$" + farmmanager.name_short() + "[/color] isn't sure why yet. "
	if cattle.lactating.hyperlactation == true:
		lactationbonus = clamp(cattle.lactating.duration*.2, .2, 5)
		extraproduction = round(cattle.lactating.milkstorage * lactationbonus)
		text += "Just when $he thought that $he had no more milk $he could possible give, $his tits continued pouring out even more. The [color=aqua]Hyperlactation[/color] serum is forcing $his body to produce longer than it normally would and the results will only get better the longer $he continues lactating. "
		if lactationbonus >= 5:
			text += "$His breasts gushed out around [color=aqua]five times[/color] the amount of milk that $he may naturally be able to produce. You suspect that even with the serum, $he is producing at $his body's maximum capacity. "
		elif lactationbonus >= 4:
			text += "$His breasts gushed out around [color=aqua]four times[/color] the amount of milk that $he may naturally be able to produce. "
		elif lactationbonus >= 3:
			text += "$His breasts gushed out around [color=aqua]three times[/color] the amount of milk that $he may naturally be able to produce. "
		elif lactationbonus >= 2:
			text += "$His breasts gushed out around [color=aqua]twice[/color] the amount of milk that $he may naturally be able to produce. "
	
	#Extraction Addition
	if cattle.farmexpanded.resistance <= 0 || cattle.farmexpanded.extractmilk.fate != "undecided" || cattle.spec == 'hucow':
		milkproduced += clamp(round((cattle.lactating.milkstorage + extraproduction) * extractionmod), 0, 50)
		text += "[color=aqua]$name[/color] allowed $himself to be milked without resistance and produced [color=green]" + str(milkproduced) + "[/color] Milk in total. "
		cattle.lactating.milkstorage -= milkproduced
		if cattle.lactating.milkstorage > 0:
			text += "$He seems to have about [color=aqua]" + str(cattle.lactating.milkstorage) + "[/color] remaining that wasn't able to be extracted today. "
	else:
		milkproduced += clamp(round(((cattle.lactating.milkstorage + extraproduction) * extractionmod) * (cattle.farmexpanded.resistance*.1)), 0, 50)
		text += "[color=aqua]$name[/color] [color=red]resisted[/color] milking today. This interfered with the milking process and $he only produced [color=green]" + str(milkproduced) + "[/color] Milk total. "
		cattle.lactating.milkstorage -= milkproduced
		if cattle.lactating.milkstorage > 0:
			text += "$He seems to have about [color=aqua]" + str(cattle.lactating.milkstorage) + "[/color] remaining that wasn't able to be extracted today. "

	
	#Cattle Reaction && Relations
	var gain = round(rand_range(1,5))
	if cattle.checkFetish('bemilked', 1.5) == true || cattle.spec == 'hucow':
		if milkmaid != null && (rand_range(0,100) <= (cattle.obed-100) + (milkmaid.charm + milkmaid.jobskills.milking)):
			globals.addrelations(cattle, milkmaid, rand_range(20,40))
			text += "[color=aqua]" + milkmaid.name_short() + "[/color] made it enjoyable for [color=aqua]$name[/color] to be milked today. $He has gained [color=green]" + str(gain) + " Lust[/color] "
			cattle.farmexpanded.extractmilk.opinion.append('accepted')
			cattle.lust += gain
		else:
			globals.addrelations(cattle, milkmaid, rand_range(10,20))
			text += "[color=aqua]$name[/color] didn't mind being milked today. "
			cattle.farmexpanded.extractmilk.opinion.append('obeyed')
	elif cattle.farmexpanded.resistance >= 0:
		if cattle.traits.has('Masochist') || cattle.traits.has('Submissive'):
			text += "[color=aqua]$name[/color] resisted being milked and would have hated $his treatment, but being mistreated turns $him on. $He has gained [color=green]" + str(gain) + " Lust[/color].\n "
			cattle.farmexpanded.extractmilk.opinion.append('accepted')
			cattle.lust += gain
			if milkmaid != null && (rand_range(0,100) <= (cattle.obed-100) + (milkmaid.charm + milkmaid.jobskills.milking)):
				globals.addrelations(cattle, milkmaid, rand_range(20,40))
			elif milkmaid != null:
				globals.addrelations(cattle, milkmaid, rand_range(10,20))
		else:
			#var stressgain = round(rand_range(1,5))
			text += "[color=aqua]$name[/color] was stressed out by being milked today. $He has gained [color=red]" + str(gain) + " Stress[/color].\n "
			cattle.farmexpanded.extractmilk.opinion.append('forced')
			cattle.stress += gain
			if milkmaid != null:
				globals.addrelations(cattle, milkmaid, rand_range(-20,-40))
	else:
		text += "[color=aqua]$name[/color] let $himself be milked today obediently, though $he didn't like it. "
		cattle.farmexpanded.extractmilk.opinion.append('obeyed')
		if milkmaid != null && (rand_range(0,100) <= (cattle.obed-100) + (milkmaid.charm + milkmaid.jobskills.milking)):
			globals.addrelations(cattle, milkmaid, rand_range(20,40))
		else:
			globals.addrelations(cattle, milkmaid, rand_range(-20,-40))
	#Add Milkmaid Relations
	if cattle.farmexpanded.resistance <= 0 || cattle.farmexpanded.resistance >= 0 && (milkmaid.traits.has('Sadist') || milkmaid.traits.has('Dominant')):
		globals.addrelations(milkmaid, cattle, rand_range(20,40))
	else:
		globals.addrelations(milkmaid, cattle, rand_range(-20,-40))
	
	#Check Fate
	text += setFate(cattle, 'extractmilk')
	
	#Deliver Milk
	var remainingMilk = calcUnspilled(container, milkmaid, milkproduced)
	if remainingMilk < milkproduced:
		milkproduced = remainingMilk
		text += "Unfortunately, " + milkmaid.name_short() + " [color=red]spilled[/color] the " + container.name + " of milk on the way back to the Vat and only delivered [color=aqua]" + str(milkproduced) + "[/color] Milk. The " + container.name + " had a [color=aqua]" + container.spillchance + "[/color] chance of spilling. \n"
	
	#Generic/Racial Milk Sorting
	###Add Racial Milk Here (if Hand Milked)
	
	refVats.milk.new += milkproduced
	#globals.resources.milk += milkproduced
	return text


func stimulateCattle(cattle):
	var actionresult = round(cattle.lust*round(rand_range(1.25,2)))
	cattle.lust += actionresult
	cattle.lewdness += 1
	var text = "\n[color=aqua]$name[/color] was teased and stimulated all over $his body today to keep $him in a constant state of arousal. $He gained [color=green]" + str(actionresult) + " Lust[/color] over the course of the day, giving $him a total of [color=green]" + str(cattle.lust) + " Lust[/color]. "
	if cattle.checkContentmentLoss('low') == true:
		text += "The constant stimulation left $him feeling hot, weak, and dehydrated. The forced arousal ended up being less pleasant than natural arousal and $he lost [color=aqua]Contentment[/color]. "
	else:
		cattle.npcexpanded.contentment += 1
		text += "The constant stimulation left $him feeling sexy and tingly. The forced arousal overwhelmed $him and $he gained [color=aqua]Contentment[/color]. "
	return text


func breedCattle(cattle, studs):
	var stud
	if cattle.farmexpanded.breeding.partner != '-1':
		stud = globals.state.findslave(cattle.farmexpanded.breeding.partner)
	if stud == null:
		stud = chooseworker('stud', studs)
		if stud == null:
			return "[color=aqua]$name[/color] was assigned to be bred today but no [color=aqua]stud[/color] was available today. "

	#Start Sex
	var text = "\n[color=aqua]" + stud.name_short() + "[/color] fucked [color=aqua]$name[/color] during the day today. "
	cattle.lastsexday = globals.resources.day
	stud.lastsexday = globals.resources.day
	stud.add_jobskill('stud')
	
	#Determine Lust
	var clust = cattle.lust
	var slust = stud.lust
	var breedstruggle = 0
	
	#Base Attraction
	if globals.expansion.getSexualAttraction(stud, cattle):
		slust += settings.basebreedlust + stud.lust + stud.beauty
	else:
		slust = settings.basebreedlust + stud.lust
	
	if globals.expansion.getSexualAttraction(cattle, stud):
		clust += settings.basebreedlust + cattle.lust + stud.beauty
	else:
		clust = settings.basebreedlust + cattle.lust
	
	#Fetishes
	if !cattle.npcexpanded.restrained.empty():
		text += "[color=aqua]$name[/color] was restrained during their breeding encounter "
		if cattle.checkFetish('bondage', 1) == true:
			text += "and [color=green]enjoyed[/color] the fact that $he was bound. "
			clust *= 1.1
		else:
			text += "and [color=red]didn't like[/color] the fact that $he was bound. "
			clust *= .9
			cattle.stress += round(rand_range(0,2))
			
		text += "[color=aqua]" + stud.name_short() + "[/color] "
		if stud.checkFetish('bondage', 1.5) == true:
			text += "[color=green]enjoyed[/color] the fact that [color=aqua]$name[/color] was bound and helpless. "
			slust *= 1.1
		else:
			text += "[color=red]didn't like[/color] the fact that [color=aqua]$name[/color] was bound and helpless. "
			slust *= .9
			stud.stress += round(rand_range(0,2))
	
	if cattle.checkFetish('submission', 1) == true || cattle.spec == 'hucow':
		text += "[color=aqua]$name[/color] [color=green]enjoyed[/color] being forced to submit to "
		clust *= 1.1
	else:
		text += "[color=aqua]$name[/color] [color=red]didn't like[/color] being forced to submit to "
		clust *= .9
		cattle.stress += round(rand_range(0,2))
	
	if stud.checkFetish('dominance', 1) == true || stud.spec == 'hucow':
		text += "[color=aqua]" + stud.name_short() + "[/color], who [color=green]enjoyed[/color] acting dominantly today. "
		slust *= 1.1
	else:
		text += "[color=aqua]" + stud.name_short() + "[/color], who [color=red]didn't like[/color] acting dominantly today. "
		slust *= .9
		stud.stress += round(rand_range(0,2))
	
	if stud.checkFetish('creampiepussy', 2) == true || stud.spec == 'hucow':
		text += "[color=aqua]" + stud.name_short() + "[/color] [color=green]relished[/color] getting to fill up $his " + globals.expansion.namePussy() + ". "
		slust *= 1.1
	else:
		text += "[color=aqua]" + stud.name_short() + "[/color] was [color=red]worried[/color] about cumming inside of $his " + globals.expansion.namePussy() + ". "
		slust *= .9
		stud.stress += round(rand_range(0,2))
	
	if cattle.checkFetish('pregnancy', 2) == true || cattle.spec == 'hucow':
		text += "[color=aqua]$name[/color] seemed [color=green]excited[/color] to be impregnated. "
		clust *= 1.1
	else:
		text += "[color=aqua]$name[/color] was [color=red]worried[/color] about getting pregnant. "
		clust *= .9
		cattle.stress += round(rand_range(0,2))
		
	#Determine Struggle
	if str(globals.expansion.relatedCheck(cattle, stud)) == "unrelated" && cattle.consentexp.breeder == true || str(globals.expansion.relatedCheck(cattle, stud)) != "unrelated" && cattle.consentexp.incestbreeder == true:
		breedstruggle = -1
	else:
		breedstruggle = 0 if cattle.npcexpanded.restrained.has('pussy') else (cattle.sstr + cattle.sagi)

	#
	var timesfucked = min(stud.send, round(stud.energy/5))
	var effort = round((timesfucked * 5) + breedstruggle / (1+(stud.jobskills.stud*.2)))
	effort = clamp(effort, 0, stud.energy - 20)
	stud.energy -= effort

	text += "[color=aqua]" + stud.name_short() + "[/color] spent [color=aqua]" + str(effort) + "[/color] Energy while fucking [color=aqua]$name[/color]. \n"

	#ralphC
	if cattle.race_display == "Succubus":
		cattle.mana_hunger -= timesfucked * variables.orgasmmana
	#/ralphC

	#Trigger Orgasms (Capture Fluids)
	var corgasms = floor(clust / 100)
	clust -= 100 * corgasms
	cattle.lust = clust

	#1 Orgasm Guaranteed
	var sorgasms = max(1, floor(slust / 100))
	cattle.cum.pussy += stud.pregexp.cumprod * sorgasms
	for i in range(sorgasms):
		globals.impregnation(cattle, stud)
	slust -= 100 * sorgasms
	stud.lust = slust

	#Metrics
	cattle.metrics.orgasm += corgasms
	cattle.sexexp.orgasmpartners[stud.id] = cattle.sexexp.orgasmpartners.get(stud.id, 0) + corgasms
	globals.addrelations(cattle, stud, cattle.sexexp.orgasmpartners[stud.id])
	
	stud.metrics.orgasm += sorgasms
	stud.sexexp.orgasmpartners[cattle.id] = stud.sexexp.orgasmpartners.get(cattle.id, 0) + sorgasms
	globals.addrelations(stud, cattle, stud.sexexp.orgasmpartners[cattle.id])
	
	#Breeding Text
	text += "[color=aqua]" + stud.name_short() + "[/color] " + globals.expansion.namePenisCumming() + " into [color=aqua]$name[/color] [color=green]" + str(sorgasms) + "[/color] times, while " + globals.expansion.nameHelplessOrgasmPreface() + globals.expansion.nameHelplessOrgasm() + " [color=green]" + str(corgasms) + "[/color] times. "

	return text


func breedSnails(cattle):
	var snaileggs = 0
	var snaileggcounter = 0
	var corgasms
	var clust = cattle.lust

	var text = "\n[color=aqua]$name[/color]'s "+ globals.expansion.namePussy() +" was assigned to be filled with snail eggs today. "
	#Return if Error
	if cattle.vagina == 'none':
		return text + "This was obviously a mistake as [color=red]$he has no " + globals.expansion.namePussy() + "[/color]. "

	if cattle.checkFetish('pregnancy',.5) || cattle.checkFetish('oviposition',1.5) || (cattle.lust >= 50 || cattle.lewdness >= 50) && cattle.wit <= 20 || cattle.spec == 'hucow':
		text += "[color=aqua]$name[/color] willingly spread $his legs as the snail approached today, allowing it's slimy ovipositor to squirm its way to $his " + globals.expansion.namePussy() + ". "
	elif cattle.farmexpanded.restrained == true || cattle.farmexpanded.workstation in ['rack','cage']:
		text += "[color=aqua]$name[/color] tried to squirm away from the snail as it's slimy ovipositor traced up $his legs to $his helpless " + globals.expansion.namePussy() + ", but $he was unable to get away. "
	else:
		if globals.expansionsettings.chancetokillsnail > max(0, rand_range(0,100) -(cattle.sstr + cattle.sagi + cattle.smaf)):
			globals.state.snails -= 1
			cattle.farmexpanded.breeding.status = 'none'
			cattle.farmexpanded.breeding.snails = false
			text += "[color=aqua]$name[/color] fought, squirmed, and resisted the snail with all of $his might. During $his struggles, $he accidentally kicked a soft, vulnerable part of the snail. The poor creature was killed instantly. [color=aqua]If you wish for this cow to breed snails, you must assign it a new snail. [/color]"
		else:
			text += "[color=aqua]$name[/color] fled, squirmed, and resisted the snail with all of $his might. The snail left dissatisfied, unable to lay its eggs inside of $him. "
		return text
			
	#Successfully Filled
	snaileggs = round(rand_range(1, globals.vagsizearray.find(cattle.vagina)))
	#Eggs Entry
	if cattle.preg.has_womb == true:
		snaileggs += round(rand_range(1,globals.vagsizearray.find(cattle.vagina)*.5))
	
	#Add Pleasure for Oviposition
	snaileggcounter = snaileggs
	while snaileggcounter > 0:
		clust += rand_range(25,75)
		snaileggcounter -= 1
	#Entry Orgasms
	corgasms = floor(clust/100)
	clust -= 100 * corgasms
	
	text += "$He moaned and groaned as [color=aqua]" +str(snaileggs)+ " eggs[/color] were pushed through the ovipositor into $his wet and waiting " + globals.expansion.namePussy() + ". "
	if corgasms > 0:
		text += "The sensation of the eggs filling $him up, protruding $his belly, and sending spurts of wet, warm slime gushing inside of $his body was so intense that $he orgasmed " +str(corgasms)+ " times while $he was being filled up. "
	
	#Egg Labor
	if snaileggs > 0:
		var laborresult = 0
		var laborpain = 0
		var laborlust = 0
		var effort = 0
		var saidoversized = false
		var saidnormal = false
		text += "After the snail slid away and left its prey bulging with eggs, $he felt something shift inside of $him. $His stomach, not able to contain the mixture of snail-slime and eggs, began going into violent contractions. "
		snaileggcounter = snaileggs
		text += "\n[color=aqua]$name[/color] was in full labor the eggs were coming out whether $he wanted them to or not. "
		while snaileggcounter > 0:
			var labordifficulty = globals.expansionsettings.snailegglabordifficulty
			if snaileggcounter > globals.vagsizearray.find(cattle.vagina):
				#Overstuffed: Pain > Pleasure but guaranteed Exit
				labordifficulty += snaileggcounter - globals.vagsizearray.find(cattle.vagina)
				#Text Check
				if globals.expansionsettings.snailegglabordetails == true && saidoversized == false:
					saidoversized = true
					text += "$He was stretched and bloated by the sheer number of eggs filling $his body. $He was so full that they were going to slide and pop out of $him no matter if $he pushed or not. "
				if rand_range(0,100) <= globals.expansionsettings.snailegglaborpainchance + (labordifficulty*5) - cattle.farmexpanded.breeding.eggsbirthed:
					#Pain
					laborpain += labordifficulty
					if globals.expansionsettings.snailegglabordetails == true:
						text += "An egg stretched $him open painfully as it exited $him and plopped to the ground.\n "
				elif rand_range(0,100) <= globals.expansionsettings.snailegglaborpleasurechance + (labordifficulty*5) + cattle.farmexpanded.breeding.eggsbirthed:
					#Pleasure
					laborlust += labordifficulty
					if globals.expansionsettings.snailegglabordetails == true:
						text += "$He suddenly gasped in pleasure as an egg slid down $his pussy, rubbing $his throbbing inside all the way down. With a loud moan, the egg split $his lips and slid out of $him.\n "
				#Layed
				snaileggcounter -= 1
			else:
				labordifficulty += round(rand_range(-globals.expansionsettings.snailegglaborvariable,globals.expansionsettings.snailegglaborvariable))
				if globals.expansionsettings.snailegglabordetails == true && saidnormal == false:
					saidnormal = true
					text += "There were just enough eggs to fill $his pussy. $He felt $his body contracting to push out the eggs and knew that birthing these eggs was entirely left to $him. "
				#Push
				effort = round(rand_range(1,3))
				if globals.expansionsettings.snailegglabordetails == true:
					if effort == 1:
						text += "$He pushed a little but couldn't muster enough energy to squeeze $his stuffed pussy hard. "
					elif effort == 2:
						text += "$He grunted and pushed hard, even holding $his breath as $he tried to force the foreign entity from $his body. "
					else:
						text += "$He screamed and pushed as hard as $he could. $He held $his breath as $he gave it his all, only breathing again after $his face was completely flushed and sweat glistened off of $him. "
				cattle.energy -= clamp(cattle.sstr * effort, 1, 10)
				laborresult += clamp(cattle.sstr * effort, 1, 10)
				#Layed
				if laborresult >= labordifficulty:
					if globals.expansionsettings.snailegglabordetails == true:
						text += "With a satisfying squelch, $he managed to birth another snail egg from $his throbbing " + str(globals.expansion.namePussy()) + ".\n " 
					snaileggcounter -= 1
					laborresult = 0
					#Pleasure
					if rand_range(0,100) <= globals.expansionsettings.snailegglaborpleasurechance + (labordifficulty*5) + cattle.farmexpanded.breeding.eggsbirthed:
						laborlust += labordifficulty + effort
						if globals.expansionsettings.snailegglabordetails == true:
							text += "The egg was accompanied by a small gush as $he moaned helplessly as pleasure wracked $his body from the sensation of the egg-laying. "
				else:
					if globals.expansionsettings.snailegglabordetails == true:
						if laborresult < labordifficulty/3:
							text += "$He gasped for breath as $he tried to work up the energy for another push, feeling the egg that barely made any progress. "
						elif laborresult < labordifficulty/1.5:
							text += "$He sniffed and whimpered as $he felt the egg still stuck inside of him, just under halfway through $his sore walls. "
						else:
							text += "$His mouth hung open and $he didn't even notice the drool dripping from $his mouth as $he mindlessly squeezed, gasped for air, then squeezed again on the egg lodged inside of $his body. "
					#Pain
					if rand_range(0,100) <= globals.expansionsettings.snailegglaborpainchance + ((labordifficulty-laborresult)*5) - cattle.farmexpanded.breeding.eggsbirthed:
						laborpain += labordifficulty + effort
						if globals.expansionsettings.snailegglabordetails == true:
							text += "$He grunted and sobbed in pain as $his insides violently contracted around the egg still stuck inside stretched out $him open. "
		
		clust += laborlust
		#Laying Orgasms
		corgasms = floor(clust/100)
		clust -= 100 * corgasms
		if corgasms > 0:
			text += "\nThe sensations were so intense that you are certain [color=aqua]$name[/color] orgasmed from the whole experience at least " +str(corgasms)+" times. "
		
		var cattleendurance = clamp(cattle.send, 1, 100)
		
		#Check Opinions
		if laborlust >= laborpain:
			laborresult = laborlust - laborpain
			if cattle.checkFetish('oviposition', laborresult):
				text += "\n[color=aqua]$name[/color] pleasurable experience seems more open to the idea of breeding snails in the future. "
			#Bad Result
			if (laborpain / cattleendurance) - corgasms > 0 && globals.expansionsettings.snailegglaborbadresult:
				cattle.stress += (laborpain / cattleendurance) - corgasms
				text += "\n[color=aqua]$name[/color]'s body was stressed by laying [color=aqua]" + str(snaileggs) + " eggs[/color] but otherwise unaffected. "
		else:
			laborresult = laborpain - laborlust
			if cattle.checkFetish('oviposition', -laborresult) == false:
				text += "\n[color=aqua]$name[/color]'s painful experience seems less open to the idea of breeding snails in the future. "
				cattle.setFetish('oviposition', -1)
			#Bad Result
			if globals.expansionsettings.snailegglaborbadresult:
				cattle.stress += round((laborpain / cattleendurance) - corgasms*.5)
				cattle.health -= round(cattle.health*.1)
				text += "\n[color=aqua]$name[/color]'s body was both stressed and slightly injured by laying [color=aqua]" + str(snaileggs) + " eggs[/color]. [color=red]$His health has declined[/color]. "
		
		cattle.farmexpanded.breeding.eggsbirthed += snaileggs
		refSnails.neweggs += snaileggs

	cattle.lust = clust
	cattle.metrics.orgasm += corgasms
	cattle.lastsexday = globals.resources.day

	return text


#Capture Fluids from Orgasms
func captureFluids(cattle, milkmaid):
	var extraorgasms = 0
	var clust = cattle.lust
	var extractionmod = 0
	var semenproduced = 0
	var lubeproduced = 0

	var container = containerdict[cattle.farmexpanded.extractcum.container]

	#Container Description
	var text = "\n\n[color=aqua]$name[/color] was prepped to have $his [color=aqua]cum[/color] collected. " + container.description + " " + str(globals.expansion.getGenitals(cattle)) + ". "
	#Extraction Method
	if cattle.farmexpanded.extractcum.method != 'hand':
		var refExtractor = extractorsdict.get(cattle.farmexpanded.extractcum.method)
		if refExtractor != null:
			#Automatic Extraction
			text += "$His cum [color=aqua]" + str(refExtractor.description) + "[/color]. "
			extractionmod = rand_range(refExtractor.low, refExtractor.high)
		else:
			extractionmod = rand_range(0,1)
			print("Cum Extractor not found for Cattle ID " + str(cattle.id) + ". Random 0-100 substituted")
		#Add Orgasms
		extraorgasms = extractorsarray.find(cattle.farmexpanded.extractcum.method)*3
		while extraorgasms > 0:
			clust += round(rand_range(25,150))
			extraorgasms -= 1
	else:
		#Manual Extraction
		text += "[color=aqua]$name[/color]'s cum was collected by [color=aqua]" + milkmaid.name_short() + "[/color]. "
		var effort = round(rand_range(1,milkmaid.send+1))
		milkmaid.energy -= effort
		milkmaid.add_jobskill('milking', round(effort*.25))
		text += "[color=aqua]" + milkmaid.name_short() + "[/color] spent [color=aqua]" + str(effort) + " Energy[/color] pleasuring [color=aqua]$name[/color] to collect $his cum. "
		extractionmod = clamp(milkmaid.jobskills.milking * .25, 0, effort)
		#Add Orgasms
		extraorgasms = effort
		while extraorgasms > 0:
			clust += round(rand_range(milkmaid.lewdness + milkmaid.jobskills.milking/2, milkmaid.lust + milkmaid.lewdness + milkmaid.jobskills.milking))
			extraorgasms -= 1
	
	#Secondary Orgasm Method (After Breeding)
	var corgasms = floor(clust/100)
	clust -= 100 * corgasms
	
	#Semen Produced
	var semen = 0
	if cattle.penis != "none":
		if cattle.pregexp.cumprod > 0:
			semen = clamp(round((cattle.pregexp.cumprod*corgasms) * extractionmod), 0, 50)
		else:
			semen = 1
		#Futa Dillution
		if globals.expansionsettings.futacumweakened == true && cattle.vagina != "none":
			semen = round(semen*globals.expansionsettings.futacumweakenedpercentage)
		
		semenproduced += semen
		text += "[color=aqua]$name[/color] had [color=aqua]" + str(semen) + " Semen[/color] extracted out of $his " + str(globals.expansion.namePenis()) + " today.\n "
	
	if cattle.vagina != "none" && cattle.cum.pussy > 0:
		semen = clamp(round(cattle.cum.pussy * extractionmod), 0, cattle.cum.pussy)
		cattle.cum.pussy -= semen
		semenproduced += semen
		text += "[color=aqua]$name[/color] had [color=aqua]" + str(semen) + " Semen[/color] extracted from $his " + str(globals.expansion.namePussy()) + " today that had been left inside of $him.\n "
	
	if cattle.asshole != "none" && cattle.cum.ass > 0:
		semen = clamp(round(cattle.cum.ass * extractionmod), 0, cattle.cum.ass)
		cattle.cum.ass -= semen
		semenproduced += semen
		text += "[color=aqua]$name[/color] had [color=aqua]" + str(semen) + " Semen[/color] extracted from $his " + str(globals.expansion.nameAsshole()) + " today that had been left inside of $him.\n "
	
	#Lubricant Produced
	if cattle.vagina != "none":
		var lube = clamp(round((cattle.pregexp.cumprod*corgasms) * extractionmod), 0, globals.vagsizearray.find(cattle.vagina)*5)
		#Futa Dillution
		if globals.expansionsettings.futacumweakened == true && cattle.penis != "none":
			lube = round(lube*globals.expansionsettings.futacumweakenedpercentage)
		lube = clamp(lube, 1, 100)
		lubeproduced = lube
		text += "[color=aqua]$name[/color] had [color=aqua]" + str(lubeproduced) + " Lube[/color] extracted from $his " + str(globals.expansion.namePussy()) + " as " + str(globals.expansion.nameHelplessOrgasmPreface()) + "" + str(globals.expansion.nameHelplessOrgasm()) + ".\n "
	
	text += setFate(cattle, 'extractcum')
	
	var remainingSemen = calcUnspilled(container, milkmaid, semenproduced)
	var remainingLube = calcUnspilled(container, milkmaid, lubeproduced)
	if remainingSemen < semenproduced:
		semenproduced = remainingSemen
		text += milkmaid.dictionary("Unfortunately, $name [color=red]spilled[/color] the " + container.name + " of semen on the way back to the Vat and only delivered [color=aqua]" + str(semenproduced) + "[/color] Semen. The " + container.name + " had a [color=aqua]" + container.spillchance + "[/color] chance of spilling. \n")
	if remainingLube < lubeproduced:
		lubeproduced = remainingLube
		text += milkmaid.dictionary("Unfortunately, $name [color=red]spilled[/color] the " + container.name + " of lube on the way back to the Vat and only delivered [color=aqua]" + str(lubeproduced) + "[/color] Lubricant. The " + container.name + " had a [color=aqua]" + container.spillchance + "[/color] chance of spilling. \n")

	refVats.semen.new += semenproduced
	refVats.lube.new += lubeproduced
	cattle.metrics.orgasm += corgasms
	#globals.resources.semen += semenproduced
	#globals.resources.lube += lubeproduced
	return text


#---Piss Extraction: Major Factor (Diet) not yet implimented. Amount will be based on Diet when applied
func extractPiss(cattle, milkmaid):
	var pissproduced = 0
	var extractionmod = 0
	#Container Description
	var container = containerdict[cattle.farmexpanded.extractpiss.container]
	var text = "\n[color=aqua]$name[/color] was prepped to have $his [color=aqua]piss[/color] collected. " + container.description + " " + str(globals.expansion.getGenitals(cattle)) + ". "
	#Extraction Method
	if cattle.farmexpanded.extractpiss.method != 'hand':
		var refExtractor = extractorsdict.get(cattle.farmexpanded.extractpiss.method)
		if refExtractor != null:
			#Automatic Extraction
			text += "$His piss [color=aqua]" + str(refExtractor.description) + "[/color]. "
			extractionmod = rand_range(refExtractor.low, refExtractor.high)
		else:
			extractionmod = rand_range(0, 1)
			print("Piss Extractor not found for Cattle ID " + str(cattle.id) + ". Random 0-100 substituted")
	else:
		#Manual Extraction
		var effort
		text += "[color=aqua]" + milkmaid.name_short() + "[/color] forced [color=aqua]$name[/color] to drink throughout the day. Occassionally they would press against $his bladder, forcing $him to let helplessly let loose a warm stream which [color=aqua]" + milkmaid.name_short() + "[/color] would collect. "
		var pissextractmod = globals.fetishopinion.find(milkmaid.fetish.otherspissing)*.5
		if milkmaid.checkFetish('otherspissing') == true:
			effort = round(rand_range(1, globals.fetishopinion.find(milkmaid.fetish.otherspissing) + 1))
			globals.addrelations(milkmaid, cattle, rand_range(10,30))
			text += "[color=aqua]" + milkmaid.name_short() + "[/color] got off on seeing [color=aqua]$name[/color] forced to piss in front of " + milkmaid.dictionary("$him and made sure that it happened as much as possible today. ")
		else:
			effort = round(rand_range(.25,1)) #TODO- check zero max
			if milkmaid.checkContentmentLoss('med') == true:
				text += "[color=aqua]" + milkmaid.name_short() + "[/color] felt disgusted by having to deal with someone else's piss and lost [color=aqua]Contentment[/color]."
			if rand_range(0,100) <= milkmaid.loyal:
				text += "[color=aqua]" + milkmaid.name_short() + "[/color] seemed disgusted by [color=aqua]$name[/color] not being able to control $himself. "
				globals.addrelations(milkmaid, cattle, rand_range(-10,-30))
			else:
				text += milkmaid.dictionary("[color=aqua]$name[/color] seemed upset at you specifically for making $him do that. ")
				globals.addrelations(milkmaid, cattle, rand_range(10,30))
		extractionmod = clamp(pissextractmod, .25, effort)
	
	var temppiss = round(rand_range(1,globals.heightarrayexp.find(cattle.height)))
	#Production
	if cattle.farmexpanded.resistance <= 0 || cattle.farmexpanded.extractpiss.fate != "undecided" || cattle.spec == 'hucow':
		pissproduced += clamp(round(temppiss * extractionmod), 0, 10)
		text += "[color=aqua]$name[/color] didn't fight it when $his piss was collected and $his bladder drained [color=green]" + str(pissproduced) + " Piss[/color] total. "
	else:
		pissproduced += clamp(round((temppiss * extractionmod) * (cattle.farmexpanded.resistance*.1)), 0, 10)
		text += "[color=aqua]$name[/color] fought as best $he could to keep $his piss from being collected and only [color=green]" + str(pissproduced) + " Piss[/color] was collected. "
	text += setFate(cattle, 'extractpiss')
	
	var remainingPiss = calcUnspilled(container, milkmaid, pissproduced)
	if remainingPiss < pissproduced:
		pissproduced = remainingPiss
		text += "Unfortunately, " + milkmaid.name_short() + " [color=red]spilled[/color] the " + container.name + " of urine on the way back to the Vat and only delivered [color=aqua]" + str(pissproduced) + "[/color] Piss. The " + container.name + " had a [color=aqua]" + container.spillchance + "[/color] chance of spilling. \n"
		if milkmaid.checkFetish('wearpiss') == false:
			if milkmaid.checkContentmentLoss('high') == true:
				text += "[color=aqua]" + milkmaid.name_short() + "[/color] was utterly disgusted by being covered in piss and lost [color=aqua]Contentment[/color]."
	
	refVats.piss.new += pissproduced
	#globals.resources.piss += pissproduced
	return text


func prodCattle(cattle):
	var actionresult = clamp(round(cattle.cour*.1)+1, 1, 10)
	cattle.cour -= actionresult
	cattle.obed += actionresult
	var text = "\nEvery time that [color=aqua]$name[/color] tried to speak, move, or do anything outside of the actions of a submissive, mindless cattle $he was prodded incredible painfully. $He lost [color=red]" + str(actionresult) + " Courage[/color] to speak up. "
	if rand_range(0,100) <= globals.expansionsettings.proddamagechance - cattle.send:
		actionresult = round(actionresult*1.25)
		cattle.health -= actionresult
		text += "$He also lost [color=red]" +str(actionresult)+" Health[/color] from the repeated electric shocks. "
	if cattle.traits.has('Masochist') || cattle.checkFetish('masochism') == true:
		cattle.npcexpanded.contentment += 1
		cattle.lust += actionresult
		text += "$He seemed to get off on the painful shocks and gained [color=aqua]Contentment[/color] and [color=aqua]Lust[/color] from the pure agony. "
	elif cattle.checkContentmentLoss('high') == true:
		cattle.npcexpanded.contentment -= 1
		text += "The pain was excrutiating and $he lost quite a bit of [color=aqua]Contentment[/color]. "
	return text


func mooCattle(cattle):
	var text = ""
	if cattle.spec == 'hucow':
		text += "\n[color=aqua]$name[/color] was forced to moo like a cow any time $he needed to communicate all day. This made $him feel more comfortable and like $himself, and thus $he gained [color=aqua]Confidence[/color] in who $he was meant to be. "
		cattle.conf += round(rand_range(2,5))
	elif rand_range(0,100) <= globals.expansionsettings.witlosschance:
		var actionresult = clamp(round(cattle.wit*.1), 1, 10)
		cattle.wit -= actionresult
		text += "\n[color=aqua]$name[/color] was forced to moo like a cow any time $he needed to communicate all day. This seems to have made it slightly harder for $him to talk and $he even hesitates before talking now as though $he is trying to remember how to speak correctly. $He lost [color=red]" +str(actionresult)+" Wits[/color] today. "
		if cattle.checkContentmentLoss('med') == true:
			text += "$He seems to have realized that $he is having a harder time thinking and seems upset. $He lost [color=aqua]Contentment[/color]. "
	else:
		text += "\nDespite being forced to moo like a cow all day, [color=aqua]$name[/color] doesn't seem any dumber than $he was before. "
		if cattle.checkContentmentLoss('low') == true:
			text += "$He seems to have realized that you are actively trying to make $him stupider and seems upset. $He lost [color=aqua]Contentment[/color]. "
	return text


func pamperCattle(cattle):
	var actionresult = round(rand_range(1,3))
	cattle.npcexpanded.contentment += actionresult
	return "\n[color=aqua]$name[/color] was pampered and doted on today, making $him feel far more [color=aqua]Content[/color] with $his lot in life. $He gained [color=aqua]" +str(actionresult)+ " Contentment[/color] today. "
			

func restCattle(cattle):
	cattle.energy += (cattle.energy*1.5)
	cattle.health += round(rand_range(3,5))
	var text = "\n[color=aqua]$name[/color] just rested today and recovered some [color=green]Energy[/color] and [color=green]Health[/color]. "
	if rand_range(0,100) <= globals.expansionsettings.restgainchance:
		var actionresult = 1
		cattle.npcexpanded.contentment += actionresult
		text += "$He enjoyed not having to do anything else today and gained [color=aqua]Contentment[/color]"
	return text


func updateContentment(cattle):
	var text = ""
	#Hucow Bonus
	if cattle.spec == 'hucow' && cattle.npcexpanded.contentment < 5:
		cattle.npcexpanded.contentment += 1
		text += "\n[color=aqua]$name[/color] naturally feels at home on the [color=aqua]Farm[/color] and truly believes that this is where $he belongs. $He gains [color=lime]1 Contentment[/color] from his [color=aqua]Hucow[/color] training. "
	#Contentment Displays
	if cattle.npcexpanded.contentment >= 5:
		cattle.loyal += rand_range(2,4)
		cattle.obed += rand_range(3,5)
		cattle.stress -= rand_range(5,15)
		text += "\n[color=aqua]$name[/color] feels that $he is very well taken care of and is [color=lime]Happy[/color]. $His happiness made $him feel more [color=green]Loyal[/color] and [color=green]Obedient[/color] to you today. "
		if cattle.consentexp.livestock == false && rand_range(0,100) <= globals.expansionsettings.livestockautoconsentchance:
			cattle.consentexp.livestock = true
			text += "\n[color=aqua]$name[/color] is enjoying life as one of your livestock so much that $he approaches you and indicates that $he is happy to stay that way for a long time. You now have $his [color=aqua]Consent[/color] and $he will not resist you. "
	elif cattle.npcexpanded.contentment > 0:
		cattle.loyal += 1
		cattle.obed += 1
		cattle.stress -= rand_range(3,10)
		text += "\n[color=aqua]$name[/color] feels that $he is very well taken care of and is [color=green]Content[/color]. $His comfort made $him feel slightly more [color=green]Loyal[/color] and [color=green]Obedient[/color] to you today. "
	elif cattle.npcexpanded.contentment > -5:
		cattle.loyal -= rand_range(1,3)
		cattle.obed -= rand_range(2,5)
		cattle.stress += rand_range(3,7)
		text += "\n[color=aqua]$name[/color] feels [color=red]Discontent[/color] and [color=red]Stressed[/color] as your livestock. $He lost [color=red]Loyalty[/color] and [color=red]Obedience[/color] for $his master. "
		if cattle.consentexp.livestock == true && globals.expansionsettings.livestockcanloseconsent && rand_range(0,100) <= globals.expansionsettings.livestockloseconsentchance:
			cattle.consentexp.livestock = false
			text += "\n[color=aqua]$name[/color] hates life as one of your livestock so much that $he approaches you and indicates that $he wants it to stop. You no longer have $his [color=aqua]Consent[/color] and $he might even resist you in the future. "
	elif cattle.npcexpanded.contentment <= -5:
		cattle.loyal -= rand_range(3,7)
		cattle.obed -= rand_range(5,10)
		cattle.fear += rand_range(5,10)
		cattle.stress += rand_range(5,20)
		text += "\n[color=aqua]$name[/color] feels [color=red]Miserable[/color] and [color=red]Stressed[/color] as your livestock. $He lost a lot of [color=red]Loyalty[/color] and [color=red]Obedience[/color], but gained [color=green]Fear[/color] for $his master. "
		if cattle.consentexp.livestock == true && globals.expansionsettings.livestockcanloseconsent && rand_range(0,50) <= globals.expansionsettings.livestockloseconsentchance:
			cattle.consentexp.livestock = false
			text += "\n[color=aqua]$name[/color] hates life as one of your livestock so much that $he approaches you and indicates that $he wants it to stop. You no longer have $his [color=aqua]Consent[/color] and $he might even resist you in the future. "
	return text


func sleepCattle(cattle):
	var bedding = beddingdict[cattle.farmexpanded.stallbedding]
	var text = "\n[color=aqua]$name[/color] settled down for the night in $his [color=aqua]" + str(bedding.name) + "[/color] and "
	if bedding.gainstress > 0:
		if cattle.spec == 'hucow':
			cattle.stress -= bedding.gainstress
			text += "would have gained [color=red]" + str(bedding.gainstress) + " Stress[/color] from the uncomfortable " + str(bedding.name) + ", but lost that much Stress instead due to $his [color=aqua]Hucow[/color] training. $He "
		else:
			cattle.stress += bedding.gainstress
			text += "gained [color=red]" + str(bedding.gainstress) + " Stress[/color] from the uncomfortable " + str(bedding.name) + ". $He "
	else:
		cattle.stress -= bedding.losestress
		text += "recovered [color=green]" + str(bedding.losestress) + " Stress[/color] from the comfortable " + str(bedding.name) + ". $He "
	cattle.energy += bedding.gainenergy
	text += "recovered [color=green]" + str(bedding.gainenergy) + " Energy[/color] from resting in the " + str(bedding.name) + ". "
	if rand_range(0,100) <= bedding.healchance && cattle.health < cattle.stats.health_max:
		var healthgained = round(rand_range(cattle.stats.health_max*.1, cattle.stats.health_max*.35))
		cattle.health += healthgained
		text += "[color=aqua]$name[/color] had such a restful sleep that $he recovered [color=green]" +str(healthgained)+ " Health[/color] as well. "
	return cattle.dictionary(text)


var inc_array = ['1','2','3','4','5','6','7','8','9','10']
func manageSnails(workersDict):
	var snailresults = 0
	var text = ""
	if refSnails.neweggs > 0:
		text += "\n\nThe mansion received [color=green]" +str(refSnails.neweggs)+ " new snail eggs[/color] from our breeders today. "
		if refSnails.auto == 'food':
			text += "They were taken to the kitchens immediately, per your order. "
			refSnails.food += refSnails.neweggs
		elif refSnails.auto == 'sell':
			text += "They were taken to be sold immediately, per your order. "
			refSnails.sell += refSnails.neweggs
		elif refSnails.auto == 'hatch':
			var incubators = globals.resources.farmexpanded.incubators
			for num in inc_array:
				if incubators[num].level > 0 && incubators[num].filled == false:
					incubators[num].filled = true
					incubators[num].growth = 0
					refSnails.neweggs -= 1
			text += "They were used to fill the Incubators and put aside for hatching. "
			refSnails.hatch += refSnails.neweggs
		else:
			text += "They were added to the stockpile to await your decision. "
			refSnails.eggs += refSnails.neweggs
		refSnails.neweggs = 0

	#Cook Snails
	if refSnails.food > 0:
		var chef
		if !workersDict.cooking.empty():
			chef = workersDict.cooking.front()
		if chef != null:
			snailresults = refSnails.food * refSnails.foodperchef
			globals.resources.food += snailresults
			text += "\nYour chef, [color=aqua]" +chef.name+ "[/color] was able to cook up the snail eggs and provide [color=green]" +str(snailresults)+ " Food[/color] from the stockpile. "
		elif refSnails.cookwithoutchef == true:
			snailresults = refSnails.food
			globals.resources.food += snailresults
			text += "\nThere was no chef available but the snail eggs were still cooked up as ordered. Without the expertise of a chef, however, they could only produce [color=green]" +str(snailresults)+ " Food[/color] from the eggs. "
	
	#Sell Snails
	if refSnails.sell > 0:
		merchantcounter += workersDict.milkmerchant.size()
		snailresults = refSnails.sell
		while merchantcounter > 0 && snailresults > 0:
			snailresults -= round(rand_range(0, snailresults))
			merchantcounter -= 1
		refSnails.sell = snailresults
		var gold = snailresults * refSnails.goldperegg
		text += "\nYour merchants were able to sell [color=green]" +str(snailresults)+ " eggs [/color] today for [color=green]" +str(gold)+ " gold[/color]. "
		globals.resources.gold += snailresults
	
	#Incubate & Hatch
	var hatchedsnails = 0
	var incubators = globals.resources.farmexpanded.incubators
	for num in inc_array:
		if incubators[num].level == 0:
			continue
		if incubators[num].filled == true:
			incubators[num].growth += incubators[num].level
			if incubators[num].growth >= 10:
				hatchedsnails += 1
				incubators[num].growth = 0
				if refSnails.hatch > 0:
					refSnails.hatch -= 1
				else:
					incubators[num].filled = false
		elif refSnails.hatch > 0:
			incubators[num].filled = true
			incubators[num].growth = 0
			refSnails.hatch -= 1
				
	if hatchedsnails > 0:
		globals.state.snails += hatchedsnails
		text += "\n\n[color=green]" +str(hatchedsnails)+" Snails[/color] were successfully hatched in your Incubators today and taken to the snail pit. "
	return text

var bottlerJobs = ['bottler','milkmaid','farmhand']
func manageVats(workersDict):
	#Sort New Production - Options are Vat, Sell, Food, Refine. If Sell or Refine, adds to Bottles for Bottling.
	var text = "[color=#d1b970][center]\n\n-----Vat Stockpile Changes-----[/center][/color]"
	for fluid in refVats.processingorder:
		var sort = refVats[fluid].auto
		var fluidVat = "vat" + fluid
		if globals.state.mansionupgrades[fluidVat] == 0:
			text += "\n[center][color=red]No [color=aqua]"+ fluid.capitalize() +" Vat[/color] is installed.[/color][/center]"
		elif refVats[fluid].new != 0:
			if sort in ['sell','refine']:
				text += "\n[color=aqua]" + str(refVats[fluid].new) + " bottles[/color] of [color=aqua]" + fluid.capitalize() + "[/color] were added to the [color=aqua]" + sort + "[/color] queue today. "
				sort = 'bottle2' + sort
			elif sort == 'vat':
				var waste = refVats[fluid][sort] + refVats[fluid].new - globals.getVatMaxCapacity('vat'+fluid)
				if waste > 0:
					refVats[fluid].new -= waste
					text += "\n[color=aqua]" + str(refVats[fluid].new) + "[/color] units of [color=aqua]" + fluid.capitalize() + "[/color] were added to the [color=aqua]vat[/color] stockpile today. The vat was full and [color=red]" + str(refVats[fluid].new) + "[/color] units of [color=aqua]" + fluid.capitalize() + "[/color] had to be disposed."
				else:
					text += "\n[color=aqua]" + str(refVats[fluid].new) + "[/color] units of [color=aqua]" + fluid.capitalize() + "[/color] were added to the [color=aqua]" + sort + "[/color] stockpile today."
			else:
				text += "\n[color=aqua]" + str(refVats[fluid].new) + "[/color] units of [color=aqua]" + fluid.capitalize() + "[/color] were added to the [color=aqua]" + sort + "[/color] stockpile today."
			refVats[fluid][sort] += refVats[fluid].new
			refVats[fluid].new = 0

	#Bottling
	text += "[color=#d1b970][center]\n\n-----Bottler Production-----[/center][/color]"
	var bottlespurchased = 0
	for fluid in refVats.processingorder:
		var totalbottlesneeded = refVats[fluid].bottle2refine + refVats[fluid].bottle2sell
		var bottlesproduced = 0

		#Check Bottles vs Available: Buy if Possible
		var difference = totalbottlesneeded - refContainers.bottle
		if difference > 0:
			if refVats[fluid].autobuybottles == true:
				if globals.resources.gold >= difference * containerdict.bottle.cost:
					refContainers.bottle = totalbottlesneeded
				else:
					difference = floor(globals.resources.gold/containerdict.bottle.cost)
					refContainers.bottle += difference
					text = "\n[color=red]There was a shortage of available bottles for " + fluid + " as there was not enough gold to buy the remaining "+ str(totalbottlesneeded - difference) +" bottles needed."
					totalbottlesneeded = refContainers.bottle
				globals.resources.gold -= difference * containerdict.bottle.cost
				bottlespurchased += difference
			else:
				text += "\n[color=red]There was a shortage of available bottles for " + fluid + ". You have " + str(refContainers.bottle) + " bottles and need " + str(difference) + " more.[/color]\n[color=aqua]Hint: This can be avoided by enabling your Auto-Buy Bottles vat setting. As long as you have the gold, you will be able to buy.[/color] "
				#text += "\n[color=red]There was a shortage of available bottles. Your slaves were only able to bottle " + str(refContainers.bottle) + " " + fluid + " today. There are still " + str(totalbottlesneeded - refContainers.bottle) + " waiting to be bottled.[/color]\n[color=aqua]Hint: This can be avoided by setting your Auto-Buy Bottles setting to a higher number than needed or to 0 for unlimited purchases. As long as you have the gold, you will be able to buy. "
				totalbottlesneeded = refContainers.bottle
			
		#Begin Bottling
		var energycost = refVats[fluid].basebottlingenergy - globals.resources.farmexpanded.bottler.level
		if totalbottlesneeded > 0:
			#Build Bottlers Array (Farmhands + Milkmaids that aren't exhausted)
			var bottlers = []
			for job in bottlerJobs:
				for worker in workersDict[job]:
					if worker.energy >= energycost:
						bottlers.append(worker)
			#Check for Bottlers
			var bottlerskillmod = 0
			if bottlers.empty():
				text += "\n[color=red]There were no workers in the farm assigned to bottling or with the energy left to successfully run the bottler today. No " + fluid + " were bottled for sales or refinement. [/color] "
			else:
				var perworker = ceil(float(totalbottlesneeded) / bottlers.size())
				for worker in bottlers:
					if worker.jobskills.has('bottler'):
						worker.jobskills['bottler'] = 0
					var workerEnergyCost = energycost*(1 - worker.jobskills.bottler*.01)
					var goalMake = min(totalbottlesneeded, perworker)
					var canMake = goalMake if workerEnergyCost == 0 else floor(worker.energy / workerEnergyCost)
					if canMake >= goalMake:
						text += worker.dictionary("\n[color=aqua]$name[/color] spent [color=red]" + str(ceil(workerEnergyCost*goalMake)) + " Energy[/color] to create [color=green]" + str(goalMake) + " Bottles of " + fluid + "[/color] today. ")
					else:
						text += worker.dictionary("\n[color=aqua]$name[/color] spent [color=red]" + str(ceil(workerEnergyCost*canMake)) + " Energy[/color] to create [color=green]" + str(canMake) + " Bottles of " + fluid + "[/color] today. [color=red]$He produced less than $his share due to $his exhaustion, leaving " + str(goalMake - canMake) + " incomplete bottles out of $his portion.[/color] ")
						goalMake = canMake
					bottlesproduced += goalMake
					totalbottlesneeded -= goalMake
					worker.energy -= ceil(workerEnergyCost*goalMake)
					worker.add_jobskill('bottler')
				#Check Deficit & Extra Work
				if totalbottlesneeded > 0:
					for worker in bottlers:
						var workerEnergyCost = energycost*(1 - worker.jobskills.bottler*.01)
						if worker.energy < workerEnergyCost:
							continue
						if rand_range(0,100) <= round((worker.obed + worker.loyal)/2) + worker.energy:
							var extrabottles = totalbottlesneeded if workerEnergyCost == 0 else min(floor(worker.energy / workerEnergyCost), totalbottlesneeded)
							worker.energy -= ceil(extrabottles * workerEnergyCost)
							bottlesproduced += extrabottles
							totalbottlesneeded -= extrabottles
							text += worker.dictionary("\n[color=aqua]$name[/color] put in extra work today and spent an additional [color=red]" + str(ceil(extrabottles * workerEnergyCost)) + " Energy[/color] to produce an extra [color=green]" + str(extrabottles) + " bottles of " + fluid + "[/color] to make up for the slack left by the other workers. ")

		#Sort Produced Bottles (Always Refine then Sell)
		if bottlesproduced > 0:
			text += "\n[color=yellow]In all, [color=lime]" + str(bottlesproduced) + " bottles[/color] of [color=aqua]" + fluid + "[/color] were successfully produced today. These were prioritized to have any designated be [color=aqua]refined[/color] for your use with any remainder being added to the [color=aqua]sales stockpile[/color].[/color]\n"
			globals.resources.farmexpanded.bottler.totalproduced += bottlesproduced
			difference = round(bottlesproduced/2)
			if refVats[fluid].bottle2refine <= bottlesproduced:
#				refVats[fluid].refine += refVats[fluid].bottle2refine
				globals.itemdict['bottled'+fluid].amount += refVats[fluid].bottle2refine
				bottlesproduced -= refVats[fluid].bottle2refine
				refVats[fluid].bottle2refine = 0
				refVats[fluid].sell += bottlesproduced
				refVats[fluid].bottle2sell -= bottlesproduced
			else:
#				refVats[fluid].refine += bottlesproduced
				globals.itemdict['bottled'+fluid].amount += bottlesproduced
				refVats[fluid].bottle2refine -= bottlesproduced
		
		#Add Refined Bottles
#		globals.itemdict['bottled'+fluid].amount += refVats[fluid].refine
#		refVats[fluid].refine = 0
		
		#Resolve Food to Cook (Flesh Out Later)
		if refVats[fluid].food > 0:
			var chef
			if !workersDict.cooking.empty():
				chef = workersDict.cooking.front()
			if chef != null:
				if !chef.jobskills.has('cook'):
					chef.jobskills['cook'] = 0
				if rand_range(0,100) <= chef.jobskills.cook + (chef.wit/2):
					globals.resources.food += refVats[fluid].food * 3
					text += chef.dictionary("\nYour cook, [color=aqua]$name[/color], had a great day and was able to turn " + str(refVats[fluid].food) + " units of " + fluid + " into " + str(refVats[fluid].food*3) + " food today. ")
				else:
					globals.resources.food += refVats[fluid].food * 2
					text += chef.dictionary("\nYour cook, [color=aqua]$name[/color], was only able to turn " + str(refVats[fluid].food) + " units of " + fluid + " into " + str(refVats[fluid].food*2) + " food today. ")
			else:
				if rand_range(0,100) <= globals.expansionsettings.foodconvertchance:
					globals.resources.food += refVats[fluid].food
					text += "\nYour slaves converted " + str(refVats[fluid].food) + " units of " + fluid + " into food today. "
				else:
					globals.resources.food += round(refVats[fluid].food*.5)
					text += "\n[color=red]Your slaves tried to convert " + str(refVats[fluid].food) + " units of " + fluid + " into food today but spoiled half of it in the process.[/color] "
			refVats[fluid].food = 0
		
	#Wrap-Up Text
	if bottlespurchased > 0:
		text += "\nToday, your farm manager automatically purchased [color=aqua]" + str(bottlespurchased) + " Bottles[/color] for [color=aqua]" + str(bottlespurchased * containerdict.bottle.cost) + "[/color] to fulfill the outstanding requests to bottle the fluids for refinement or sales. "		
	return text


#Sell Non-Milk
func sellFluids(workersDict):
	var text = ""
	if workersDict.milkmerchant.empty() && merchantcounter == 0:
		return text

	for fluid in ['semen','lube','piss']:
		if refVats[fluid].sell == 0:
			continue
		merchantcounter += workersDict.milkmerchant.size()
		var remainingSell = refVats[fluid].sell
		while merchantcounter > 0 && remainingSell > 0:
			remainingSell -= round(rand_range(1, remainingSell))
			merchantcounter -= 1
		var sellresult = refVats[fluid].sell - remainingSell
		refVats[fluid].sell = remainingSell
		var gold = round(sellresult * globals.itemdict['bottled'+fluid].cost * rand_range(.5,1.5))
		text += "\nYour merchants were able to sell [color=green]" +str(sellresult)+ " bottles of "+fluid.capitalize()+" [/color] today for [color=green]" +str(gold)+ " gold[/color]. "
		globals.resources.gold += gold
	return text


var genericLocations = ["none","any"]
func sellMilk(workersDict):
	var milkforsale = refVats.milk.sell
	var bottlesperperson = 0
	var townmarkets = globals.expandedtowns.duplicate()
	var text = ""

	if workersDict.milkmerchant.empty():
		text += "\n\n[color=red]There are no [color=aqua]Milk Merchants[/color] assigned. No fluids can be sold.[/color]\n"
	else:
		if milkforsale > 0:
			bottlesperperson = milkforsale / workersDict.milkmerchant.size()
			for milkmerchant in workersDict.milkmerchant:
				#Location Change
				var location = milkmerchant.jobsexpanded.location
				if location in genericLocations || !townmarkets.has(location):
					if !townmarkets.empty():
						location = globals.randomitemfromarray(townmarkets)
					else:
						text += milkmerchant.dictionary("[color=aqua]$name[/color] wasn't able to go and sell milk today as all the city markets were being sold to by your other merchants.\n")
						continue
				#Selling to the Town
				townmarkets.remove(location)
				text += milkMarket(milkmerchant, location, bottlesperperson)
		else:
			text += "\n\n[color=red]All of the available milk bottles were reserved for mansion use, so there were none available for the milk merchants to sell today.[/color]\n"
	return text


# args:
#	bottles =  totalbottles
func milkMarket(person, town, bottles):
	var text = ""
	var profit = 0
	var bottlessold = 0
	var reaction = {good = 0, bad = 0, neutral = 0}
	var roll = 0
	
	#Invalid Checks
	if !town in globals.expandedtowns || person == null:
		return ""
	
	if bottles == 0:
		return person.dictionary("\n[color=aqua]$name[/color] had no bottles of Milk to take to [color=aqua]" + str(town).capitalize() + "[/color], so $he did not go today.\n")
	var refExpandedTown = globals.state.townsexpanded[town]
	var value = round(refExpandedTown.milkvalue)
	var interest = round(refExpandedTown.milkinterest)
	
	text += "\n[color=aqua]$name[/color] took [color=aqua]" + str(bottles) + "[/color] of Milk to [color=aqua]" + str(town).capitalize() + "[/color]. "
	
	#Sale = Bottles > Interest * 2
	if bottles >= interest * 2:
		text += "$He realized that $he had far more bottles than $he needed, so he chose to sell them for half-price to try and garner more interest in your slave's bottled milk. "
		interest += round(interest * rand_range(person.wit/2, person.wit) * .01)
		value = round(value*.5)
	#Price Increase = Bottles < Interest & Wit Check
	elif bottles <= interest && rand_range(0,100) - (interest - bottles)*2 <= person.wit:
		text += "$He realized that $he had far more customers than bottles, so $he cleverly raised the price per bottle for the day. "
		value += round((interest - bottles) * .25)
	
	#Increase Job Skills
	if !person.jobskills.has('milkmerchant'):
		person.jobskills['milkmerchant'] = 0
	person.add_jobskill('milkmerchant', 1)
	
	while bottles > 0:
		if interest <= 0:
			break
		profit += value
		bottlessold += 1
		roll = rand_range(0,100)
		if roll >= 95:
			refExpandedTown.milkinterest -= .1
			reaction.bad += 1
		elif roll <= person.charm + person.jobskills.milkmerchant:
			refExpandedTown.milkinterest += .2
			reaction.good += 1
		else:
			refExpandedTown.milkinterest += .1
			reaction.neutral += 1
		bottles -= 1
		interest -= 1
	
	#End Text (Town Reaction)
	text += "\n$He ended up selling [color=green]"+str(bottlessold)+"[/color] bottles to [color=green]" + str(reaction.good + reaction.neutral + reaction.bad) + "[/color] people in [color=aqua]" + str(town).capitalize() + "[/color]. Out of those people, "
	if reaction.good > 0:
		text += "[color=green]" + str(reaction.good) + "[/color] seemed to really [color=green]enjoy[/color] the milk having been from sentient women"
	if reaction.bad > 0:
		if reaction.good > 0 && reaction.neutral > 0:
			text += ", "
		elif reaction.good > 0:
			text += " and "
		text += "[color=red]" + str(reaction.bad) + "[/color] seemed to [color=red]dislike[/color] either the taste or idea of drinking the breast milk of sentient women"
	if reaction.neutral > 0:
		if reaction.good > 0 && reaction.bad > 0:
			text += ", and "
		elif reaction.good > 0 || reaction.bad > 0:
			text += " and "
		text += "[color=aqua]" + str(reaction.neutral) + "[/color] didn't seem to mind the taste or idea of the milk having been from sentient women"
	text += ".\n"
	
	#Reputation Gain
	if reaction.good + reaction.neutral > bottlessold*.75:
		text += "[color=aqua]" + str(town).capitalize() + "[/color] seemed to have a good reaction to your milk and your reputation has increased slightly.\n"
		globals.state.reputation[town] += round(bottlessold*.1)
	
	#Price Increase
	if interest > 0:
		roll = rand_range(0,100)
		if roll - (interest*2) <= person.jobskills.milkmerchant + person.wit:
			refExpandedTown.milkvalue += .2
		else:
			refExpandedTown.milkvalue += .1
	
	#Don't Undersell Check
	if profit <= bottlessold * containerdict.bottle.cost:
		profit = bottlessold * (containerdict.bottle.cost + 1)
	
	text += "$He made a total profit of [color=aqua]" +str(profit)+ " Gold[/color] today. "
	
	globals.resources.gold += profit
	globals.resources.farmexpanded.vats.milk.sell -= bottlessold
	
	return person.dictionary(text)


# takes a reference to a containerdict entry, a worker carrying a fluid, and the total fluid gathered
# returns the remaining amount of fluid
func calcUnspilled(refContainer, worker, totalFluid):
	var chances = spillchances[refContainer.spillchance]
	if worker == null || chances.max <= 0:
		return totalFluid
	var trips = ceil(totalFluid / refContainer.size)
	var workerMod = worker.sagi*2
	while trips > 0:
		if rand_range(0,100) <= rand_range(chances.min, chances.max) - workerMod:
			totalFluid -= round(refContainer.size * rand_range(.1,.5))
		trips -= 1
	return totalFluid


func setFate(person, type):
	var text = ""
	if person.farmexpanded[type].opinion.size() >= person.farmexpanded[type].resistance:
		var accepted = person.farmexpanded[type].opinion.count('accepted')
		var obeyed = person.farmexpanded[type].opinion.count('obeyed')
		var forced = person.farmexpanded[type].opinion.count('forced')
		
		if accepted >= obeyed && accepted >= forced:
			person.farmexpanded[type].fate = 'accepted'
			text += "[color=aqua]$name[/color] [color=green]accepted[/color] this as part of $his future. "
		elif obeyed >= accepted && obeyed >= forced:
			person.farmexpanded[type].fate = 'obeyed'
			text += "[color=aqua]$name[/color] realized that $he will have to [color=aqua]obey[/color] and let this happen to $him as long as you'd like. "
		else:
			person.farmexpanded[type].fate = 'broken'
			text += "[color=aqua]$name[/color] [color=red]broke down[/color] after realizing that there is nothing that $he could do to stop this from happening whenever you'd like. "
		text += "You shouldn't encounter any future resistance from $him any longer.\n"
	return person.dictionary(text)


func chooseworker(type, workers):
	if workers.empty():
		return null
	var variable = -999
	var currentperson = null
	
	if settings[type] == 'equal':
		if refWorkerCycles[type].empty() || refWorkerCycles[type].back() >= workers.size():
			refWorkerCycles[type] = range(workers.size())
			refWorkerCycles[type].shuffle()
		return workers[refWorkerCycles[type].pop_back()]
	elif settings[type] == 'energy':
		for worker in workers:
			if worker.energy > variable:
				currentperson = worker
				variable = worker.energy
	elif settings[type] == 'skill':
		for worker in workers:
			if worker.jobskill.get(type,0) > variable:
				currentperson = worker
				variable = worker.jobskill.get(type,0)
	return currentperson

#---Milk Extraction Functions

var containerefficiency = {
	bucketspillchance = 50,
	bucketspillpercent = 50,
	pailspillchance = 40,
	pailspillpercent = 40,
	jugspillchance = 25,
	jugspillpercent = 25,
	canisterspillchance = 5,
	canisterspillpercent = 5,
}

func buyContainers(type):
	var text = ""
	if globals.resources.farmexpanded[type] == -1:
		globals.resources.farmexpanded[type] = 0
		text = str(type.capitalize()) + " is now unlocked. "
	globals.resources.farmexpanded[type] += 1
	text += str(type.capitalize()) + " purchased. [color=aqua]" + str(globals.resources.farmexpanded[type]) + " [/color] available. "
	return text

func assignContainer(type):
	if globals.resources.farmexpanded[type] > 0:
		#Replace Old Container
		if person.farmexpanded.container != 'bucket':
			globals.resources.farmexpanded[person.farmexpanded.container] += 1
		
		#Assign New Container
		if type != 'bucket':
			globals.resources.farmexpanded[type] -= 1
		person.farmexpanded.container = type
	else:
		print("Not enough " + str(type) + " available. ")
	return

func milkingContainment(person, value):
	var text = ""
	if person == null || value <= 0:
		print("Invalid Milk Container")
		return
	#Determine Container Type
	var container = person.farmexpanded.container
	if container == 'default':
		container = 'bucket'
	var spillchance = containerefficiency[container + "spillchance"]
	var spillpercent = containerefficiency[container + "spillpercent"]
	#Spill Chance
	var milkamt = value
	if rand_range(0,100) <= spillchance:
		milkamt = round(rand_range(value*(spillpercent*.01), value))
	return milkamt

#---Stole from Mansion.gd
func createPersonURL(person):
	if person == null:
		return "[color=yellow]Unassigned[/color]"
	if person.away.duration != 0:
		return "[color=aqua]" + person.name_short() + "[/color] [color=yellow](away)[/color]"
	return "[color=aqua][url=id" + person.id + "]" + person.name_short() + "[/url][/color]"

