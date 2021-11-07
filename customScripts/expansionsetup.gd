### <CustomFile> ###

###---Contains Functions that will typically only run once per person to Expand them---###

#---Core Expansion Setup Functions---#
func expandGame():
	#globals.expansionsetup.setIdentity(person)
	if globals.state.expansionversion < globals.expansionsettings.modversion:
		#v.05
		#Set up Crystal
		if !globals.state.mansionupgrades.has('dimensionalcrystal'):
			globals.state.mansionupgrades['dimensionalcrystal'] = 0
		
		#Nursery to Crystal Conversion
		if globals.state.mansionupgrades.mansionnursery > 1:
			if globals.state.mansionupgrades.mansionnursery == 3:
				globals.state.mansionupgrades.dimensionalcrystal == 2
				globals.state.mansionupgrades.mansionnursery == 1
			else:
				globals.state.mansionupgrades.dimensionalcrystal == 1
				globals.state.mansionupgrades.mansionnursery == 1
		
		#Crystal to Abilities Conversion
		if globals.state.mansionupgrades.dimensionalcrystal >= 1:
			globals.state.thecrystal.abilities.append('pregnancyspeed')
		
		#Sex Expanded
		for person in globals.slaves:
			if person.sexexpanded == null:
				person.sexexpanded = {pliability = 0,elasticity = 0}
	#v.06
		#Person Expansions
		for person in globals.slaves + globals.state.allnpcs:
			if person == null:
				continue
#			#NPCs Expanded
#			if person.npcexpanded == null:
#				person.npcexpanded = {mansionbred = false,citizen = true,timesmet = 0,timesfought = 0,timesrescued = 0,timesraped = 0}
#			
#			#Farm Expanded
#			if person.farmexpanded == null:
#				person.farmexpanded = {production = 'default',extraction='default',autopump=false,restraints='free',sleeplocation='default',worklocation='default',bedding='dirt',objects = []}
#			
			#Pregnancy Expanded
			for i in ['gestationspeed','babysize','titssizebonus','incestbaby']:
				if !person.pregexp.has(i):
					if i in ['babysize','titssizebonus']:
						person.pregexp[i] = 0
					elif i == 'gestationspeed':
						person.pregexp[i] = 1
					elif i == 'incestbaby':
						person.pregexp[i] = false

			#Lactating Expanded
			for i in ['milkedtoday','daysunmilked','milkmax','milkstorage','titssizebonus','pressure','leaking']:
				if !person.lactating.has(i):
					if i == 'milkedtoday':
						person.lactating[i] = false
					else:
						person.lactating[i] = 0
			
			#Mind Expanded
			for i in ['identity','id','ego','thoughts','secrets','secretslog','status','treatment']:
				if !person.mind.has(i):
					if i in ['identity','secretslog','status','demeanor']:
						person.mind[i] = ""
					elif i in ['id','ego']:
						person.mind[i] = ['self']
					elif i in ['thoughts','secrets','treatment']:
						person.mind[i] = []
		
		#Town Expansion Addition
		for towns in ['wimborn','frostford','gorn','amberguard']:
			if !globals.state.townsexpanded[towns].has('dailyreport'):
				globals.state.townsexpanded[towns]['dailyreport'] = {shopping = 0, crimeattempted = 0, crimeprevented = 0, crimesucceeded = 0}
	#v.07
		#NPC Array Change
		if !globals.state.npclastlocation.empty():
			#offscreennpcs = [person.id, location.code, encounterchance, action, reputation, status]
			for npcarray in globals.state.npclastlocation:
				var newarray = []
				var npc = globals.state.findnpc(npcarray[1])
				if npc == null:
					continue
		
				var id = npcarray[1]
				newarray.append(id)
				var location = npcarray[0]
				newarray.append(location)
				var encounterchance = npcarray[2]
				newarray.append(encounterchance)
				var action = npc.npcexpanded.dailyaction
				if action == "":
					action = "resting"
				newarray.append(action)
				var reputation = 0
				var status = ""
				if npc.npcexpanded.citizen == true:
					reputation = round(rand_range(1,5)) + globals.originsarray.find(npc.origins)
					status = 'citizen'
				else:
					reputation = -round(rand_range(1,5) + rand_range(-globals.originsarray.find(npc.origins), globals.originsarray.find(npc.origins)))
					status = 'criminal'
				newarray.append(action)
				newarray.append(status)
				globals.state.npclastlocation.erase(npcarray)
				globals.state.offscreennpcs.append(newarray)
		globals.state.npclastlocation.clear()
	
	#v.07.1
		for town in globals.expansion.citiesarray:
			if !globals.state.townsexpanded[town].dailyreport.has('text'):
				globals.state.townsexpanded[town].dailyreport['text'] = ""
		
		#Permanent NPC Reputations
		for person in globals.slaves + globals.state.allnpcs:
			if person == null:
				continue
			if !person.npcexpanded.has('reputation'):
				if person.npcexpanded.citizen == true:
					person.npcexpanded['reputation'] = round(rand_range(1,5))
				else:
					person.npcexpanded['reputation'] = round(rand_range(-1,-5))
		
		#Restoring old reputations
		for npc in globals.state.offscreennpcs:
			var person = globals.state.findnpc(npc[0])
			person.npcexpanded.reputation = npc[4]
	
	#v.0.81
	for person in globals.slaves + globals.state.allnpcs:
		if person == null:
			continue
		if person.origins == 'atypical':
			person.origins = 'commoner'
	
	#v.9
	
	#New Mansion Upgrades
	if !globals.state.mansionupgrades.has('dimensionalcrystal'):
		globals.state.mansionupgrades['dimensionalcrystal'] = 0
	if !globals.state.mansionupgrades.has('vatspace'):
		globals.state.mansionupgrades['vatspace'] = 0
	if !globals.state.mansionupgrades.has('vatmilk'):
		globals.state.mansionupgrades['vatmilk'] = 0
	if !globals.state.mansionupgrades.has('vatsemen'):
		globals.state.mansionupgrades['vatsemen'] = 0
	if !globals.state.mansionupgrades.has('vatlube'):
		globals.state.mansionupgrades['vatlube'] = 0
	if !globals.state.mansionupgrades.has('vatpiss'):
		globals.state.mansionupgrades['vatpiss'] = 0
	if !globals.state.mansionupgrades.has('bottler'):
		globals.state.mansionupgrades['bottler'] = 0
	
	#Commented Out as throws up errors
#	if !globals.state.has('farmexpanded'):
#	globals.state['farmexpanded'] = {aphrodisiacs = 0, production = "food", extraction='hand', totalcontainers = {bucket = -1, pail = -1, jug = -1, canister = -1}, autopump=false, restraints=[], zones = {sleeplocations = ['field'], worklocations = ['field'], furnishings = ['dirt']}, objects = []}
	
#	if !globals.state.farmexpanded.has('totalcontainers'):
#		globals.state.farmexpanded['totalcontainers'] = {bucket = -1, pail = -1, jug = -1, canister = -1}
#	if !globals.state.farmexpanded.has('aphrodisiacs'):
#		globals.state.farmexpanded['aphrodisiacs'] = 0
	
	for town in globals.expandedtowns:
		if !globals.state.townsexpanded[town].has('milkinterest'):
			globals.state.townsexpanded[town]['milkinterest'] = 5
	
	#Reputations
	if !globals.state.reputation.has('shaliq'):
		globals.state.reputation['shaliq'] = 0
	if !globals.state.reputation.has('umbra'):
		globals.state.reputation['umbra'] = 0
	
	#End Update
	globals.state.expansionversion = globals.expansionsettings.modversion
	
	#Force Mass Person Expansion
	for person in globals.slaves + globals.state.allnpcs + globals.state.babylist:
		if person.expanded == false:
			globals.expansionsetup.expandPerson(person)
		if person.expansionversion < globals.expansionsettings.modversion:
			globals.backwardscompatibility.backwardsCompatibility(person)
		globals.expansion.updatePerson(person)
	
	for i in globals.guildslaves:
		for person in globals.guildslaves[i]:
			if person.expanded == false:
				globals.expansionsetup.expandPerson(person)
			if person.expansionversion < globals.expansionsettings.modversion:
				globals.backwardscompatibility.backwardsCompatibility(person)
			globals.expansion.updatePerson(person)

func expandPerson(person):
	var sexvag = int(round(person.metrics.vag/10))
	var sexass = int(round(person.metrics.anal/10))
	var modifier = 0
	if person.vagina == 'normal' && person.vagvirgin == false:
		person.vagina = globals.vagsizearray[rand_range(0,globals.vagsizearray.size()-2)]
		while sexvag > 0:
			if rand_range(0,1) < .1:
				person.vagina = globals.vagsizearray[globals.vagsizearray.find(person.vagina)+1]
			sexvag -= 1
	if person.vagina != "none" && person.lubrication == -1:
		setLubrication(person)
	if person.asshole == 'normal':
		person.asshole = globals.assholesizearray[rand_range(0,globals.assholesizearray.size()-2)]
		while sexass > 0:
			if rand_range(0,1) < .1:
				person.asshole = globals.assholesizearray[globals.assholesizearray.find(person.asshole)+1]
			sexass -= 1
	if person.lips == 'none':
		#Add Racial Increases Later
		person.lips = globals.lipssizearray[rand_range(0,globals.lipssizearray.size()-3)]
		if rand_range(0,1) < .25:
			person.lips = globals.lipssizearray[globals.lipssizearray.find(person.lips)+1]
	#Non-Player Checks
	if person != globals.player:
		var origins = str(person.origins)
		#Dignity will change in future update
		var persondignitymin = globals.expansion.dignitymin[origins]
		var persondignitymax = globals.expansion.dignitymax[origins]
		person.dignity = round(rand_range(persondignitymin,persondignitymax))
		#---Readd when Flaws/Personalities are Readded
		setFlaw(person)
		setDemeanor(person)
		setSexuality(person)
		setDesiredOffspring(person)
		#getPersonality(person)
		
		#Check Relation Data and Add if Non-Existant
		if !globals.state.relativesdata.has(person.id):
			globals.createrelativesdata(person)
	#Sets Sexuality for Existing Players/Starting Slave
	elif person == globals.player && globals.resources.day >= 1 || person.unique == 'startslave' && globals.resources.day >= 1:
		person.sexuality = str(globals.randomitemfromarray(['straight','mostlystraight','rarelygay']))
	elif person == globals.player:
		person.sexuality = 'mostlystraight'
	setExpansionTraits(person)
	if person.lactation == true:
		setLactation(person)
	
	#Farm Statistics
	var extractions = ['extractmilk','extractcum','extractpiss']
	for i in extractions:
		if person.farmexpanded[i].resistance == -1:
			person.farmexpanded[i].resistance = round(rand_range(person.dignity * 0.25 , person.dignity * 1))
	
	#Sets Id/Ego for Everyone
	#setIdentity(person) Currently Crashing Game
	person.expanded = true
	globals.expansion.updatePerson(person)

#"Set" functions are intended to run Once per person for the initial setup
func setFlaw(person):
	var temparray = globals.expansion.flawarray.duplicate()
	if person.mind.flaw == 'none' && person.mind.flawless == false:
		person.mind.flaw = str(globals.randomitemfromarray(temparray))

func setDemeanor(person):
	#Changing into Personality/Identity in Future Update
	var temparray = globals.expansion.demeanorarray.duplicate()
	if person.mind.demeanor == 'none':
		if person.race.find('Beastkin') > 0 || person.race.find('Halfkin') > 0:
			temparray.append('excitable')
			temparray.append('excitable')
			temparray.append('excitable')
		if person.conf >= 75:
			temparray.append('open')
			temparray.append('open')
			temparray.append('excitable')
		elif person.conf <= 25:
			temparray.append('shy')
			temparray.append('shy')
			temparray.append('meek')
		person.mind.demeanor = str(globals.randomitemfromarray(temparray))

func setSexuality(person):
	if person.traits.has('Homosexual'):
		person.sexuality = str(globals.randomitemfromarray(['rarelystraight','mostlygay','gay']))
		person.trait_remove('Homosexual')
	elif person.traits.has('Bisexual'):
		person.sexuality = str(globals.randomitemfromarray(['rarelygay','bi','rarelystraight']))
		person.trait_remove('Bisexual')
	else:
		person.sexuality = str(globals.randomitemfromarray(globals.kinseyscale))

func setDesiredOffspring(person):
	#Maximum of 10 + Siblings
	var number = round(rand_range(0,4))
	if person.race.find("Beastkin") > 0:
		number += round(rand_range(0,2))
	#Add for Siblings
	var persondata
	if globals.state.relativesdata.has(person.id):
		persondata = globals.state.relativesdata[person.id]
	else:
		globals.createrelativesdata(person)
		persondata = globals.state.relativesdata[person.id]
	for i in persondata:
		number += rand_range(.05,.15)
	person.pregexp.desiredoffspring = round(number)

func setLubrication(person):
	person.lubrication = round(rand_range(1,4))
	if rand_range(0,100) <= globals.expansionsettings.vaginalwetnesstraitchance:
		person.add_trait('Soaker')

func setExpansionTraits(person):
	var hasvirility = false
	var haseggstr = false
	var haspliability = false
	var haselasticity = false
	var traitchance = 0
	var variable = 0
	for i in person.traits:
		#Check for Existing Traits
		var trait = globals.origins.trait(i)
		if trait.tags.has('fertility-trait') && trait.tags.has('virilitytrait'):
			hasvirility = true
		if trait.tags.has('fertility-trait') && trait.tags.has('eggstrtrait'):
			haseggstr = true
		if trait.tags.has('pliabilitytrait'):
			haspliability == true
		if trait.tags.has('elasticitytrait'):
			haselasticity = true
	if hasvirility == false || haseggstr == false:
		#Check Trait Storage
		for i in person.traitstorage:
			var trait = globals.origins.trait(i)
			if trait.tags.has('fertility-trait') && trait.tags.has('virilitytrait'):
				person.add_trait(trait)
				person.traitstorage.erase(trait)
				hasvirility = true
			if trait.tags.has('fertility-trait') && trait.tags.has('eggstrtrait'):
				person.add_trait(trait)
				person.traitstorage.erase(trait)
				haseggstr = true
			if trait.tags.has('pliabilitytrait'):
				person.add_trait(trait)
				person.traitstorage.erase(trait)
				haspliability == true
			if trait.tags.has('elasticitytrait'):
				person.add_trait(trait)
				person.traitstorage.erase(trait)
				haselasticity = true
		if hasvirility == false:
			traitchance += rand_range(0,1)
		if haseggstr == false:
			traitchance += rand_range(0,1)
		if haspliability == false:
			traitchance += rand_range(0,1)
		if haselasticity == false:
			traitchance += rand_range(0,1)
	#Add new traits
	if traitchance > 0:
		traitchance += rand_range(-1,1)
		traitchance = round(traitchance)
		if traitchance >= 1:
			var choices = []
			while traitchance > 0:
				choices.clear()
				if hasvirility == false && person.penis != "none":
					choices.append('virility')
				if haseggstr == false && person.preg.has_womb == true:
					choices.append('eggstr')
				if haspliability == false:
					choices.append('pliability')
				if haselasticity == false:
					choices.append('elasticity')
				variable = rand_range(0,1)
				var choice = globals.randomitemfromarray(choices)
				
				if choice == 'virility' && variable >= .5:
					variable = rand_range(0,1)
					if variable > .8:
						person.add_trait("Virility 2")
					elif variable < .2:
						person.add_trait("Weak Virility")
					else:
						person.add_trait("Virility 1")
				elif choice == 'eggstr' && variable >= .5:
					variable = rand_range(0,1)
					if variable > .8:
						person.add_trait("Egg Strength 2")
					elif variable < .2:
						person.add_trait("Impenetrable Eggs")
					else:
						person.add_trait("Egg Strength 1")
				elif choice == 'pliability' && variable >= .5:
					variable = rand_range(0,1)
					if variable > .8:
						person.add_trait("Pliability 2")
					elif variable < .2:
						person.add_trait("Rigid Pliability")
					else:
						person.add_trait("Pliability 1")
				elif choice == 'elasticity' && variable >= .5:
					variable = rand_range(0,1)
					if variable > .8:
						person.add_trait("Elasticity 2")
					elif variable < .2:
						person.add_trait("Rigid Elasticity")
					else:
						person.add_trait("Elasticity 1")
				traitchance -= 1

#Runs once per person when they are first detected to be Lactating to check for and potentially add Traits
func setLactation(person):
	var hasregentrait = false
	var hasstoragetrait = false
	var traitchance = 0
	var variable = 0

#	if person.traits.has("Lactating") == false:
#		person.add_trait("Lactating")
#		person.existingtraitlines.append('lactation')
	#Set Lactation Traitline
	for i in person.traits:
		#Set Lactation Regen/Flow Traitline
		var trait = globals.origins.trait(i)
		if trait.tags.has('lactation-trait') && trait.tags.has('regentrait'):
			hasregentrait = true
		if trait.tags.has('lactation-trait') && trait.tags.has('storagetrait'):
			hasstoragetrait = true
	if hasregentrait == false || hasstoragetrait == false:
		for i in person.traitstorage:
			var trait = globals.origins.trait(i)
			if trait.tags.has('lactation-trait') && trait.tags.has('regentrait'):
				person.add_trait(trait)
				person.traitstorage.erase(trait)
				hasregentrait = true
			if trait.tags.has('lactation-trait') && trait.tags.has('storagetrait'):
				person.add_trait(trait)
				person.traitstorage.erase(trait)
				hasstoragetrait = true
		if hasregentrait == false:
			traitchance += rand_range(0,1)
		if hasstoragetrait == false:
			traitchance += rand_range(0,1)
	traitchance = round(traitchance)
	if traitchance > 0:
		traitchance += rand_range(-1,1)
		traitchance = round(traitchance)
		if traitchance >= 1:
			while traitchance > 0:
				variable = rand_range(0,1)
				if hasregentrait == false && variable > .5:
					variable = rand_range(0,1)
					if variable > .8:
						person.add_trait("Milk Flow 2")
					elif variable < .2:
						person.add_trait("Weak Milk Flow")
					else:
						person.add_trait("Milk Flow 1")
				elif hasstoragetrait == false && variable > .5:
					variable = rand_range(0,1)
					if variable > .8:
						person.add_trait("Milk Glands 2")
					elif variable < .2:
						person.add_trait("Small Milk Glands")
					else:
						person.add_trait("Milk Glands 1")
				traitchance -= 1

###---Added by Expansion---### Deviate Concept Tweaked
func setRaceBonus(person, increasestats):
	var bonus_strength = 0
	var bonus_agility = 0
	var bonus_magic = 0
	var bonus_endurance = 0
	var bonus_courage = 0
	var bonus_confidence = 0
	var bonus_wit = 0
	var bonus_charm = 0
	var bonus_beauty = 0
	var bonus_fertility = 0
	
	var addstats = increasestats
	
	if person == null:
		print("Invalid Person for Setting Racial Bonus")
		return
	
	###ANK'S FIX? This + Dictionary?
#	for race in genealogy:
#		if genealogy[race] > 0:
#			descript += race.replace('_',' ').capitalize() + " : " + str(genealogy[race]) + "%\n"
	###
	
#	if person.npcexpanded.racialbonusesapplied == false && addstats == true || person.npcexpanded.racialbonusesapplied == true && addstats == false:
	if person.genealogy.human > 0:
		if person.genealogy.human >= 100:
			bonus_strength += .6
			bonus_agility += .6
			bonus_magic += .6
			bonus_endurance += 1.8
		elif person.genealogy.human >= 70:
			bonus_strength += .4
			bonus_agility += .4
			bonus_magic += .4
			bonus_endurance += 1.4
		elif person.genealogy.human >= 50:
			bonus_strength += .4
			bonus_agility += .4
			bonus_magic += .4
			bonus_endurance += .6
		elif person.genealogy.human >= 30:
			bonus_strength += .2
			bonus_agility += .2
			bonus_magic += .2
			bonus_endurance += .4
		else:
			bonus_strength += .1
			bonus_agility += .1
			bonus_magic += .1
			bonus_endurance += .2
	
	if person.genealogy.gnome > 0:
		if person.genealogy.gnome >= 100:
			bonus_wit += 20
			bonus_magic += 1
			bonus_endurance += 2
		elif person.genealogy.gnome >= 70:
			bonus_wit += 20
			bonus_magic += 1
			bonus_endurance += 1
		elif person.genealogy.gnome >= 50:
			bonus_wit += 15
			bonus_magic += 1
			bonus_endurance += .4
		elif person.genealogy.gnome >= 30:
			bonus_wit += 10
			bonus_magic += .4
			bonus_endurance += .2
		else:
			bonus_wit += 5
			bonus_magic += .2
			bonus_endurance += .2
	
	#Long-Ears
	#Elf 
	if person.genealogy.elf > 0:
		if person.genealogy.elf >= 100:
			bonus_agility += 3
			bonus_charm += 10
		elif person.genealogy.elf >= 70:
			bonus_agility += 2
			bonus_charm += 10
		elif person.genealogy.elf >= 50:
			bonus_agility += 1
			bonus_charm += 5
		elif person.genealogy.elf >= 30:
			bonus_agility += 1
		else:
			bonus_agility += .4
	
	#Dark Elf
	if person.genealogy.dark_elf > 0:
		if person.genealogy.dark_elf >= 100:
			bonus_magic += 1
			bonus_agility += 2
			bonus_wit += 10
		elif person.genealogy.dark_elf >= 70:
			bonus_magic += 1
			bonus_agility += 1
			bonus_wit += 10
		elif person.genealogy.dark_elf >= 50:
			bonus_magic += 1
			bonus_agility += .4
			bonus_wit += 5
		elif person.genealogy.dark_elf >= 30:
			bonus_magic += 1
			bonus_agility += .2
		else:
			bonus_magic += .2
			bonus_agility += .2
	
	#Tribal Elf
	if person.genealogy.tribal_elf > 0:
		if person.genealogy.tribal_elf >= 100:
			bonus_confidence += 20
			bonus_strength += 1
			bonus_agility += 2
		elif person.genealogy.tribal_elf >= 70:
			bonus_confidence += 20
			bonus_strength += 1
			bonus_agility += 1
		elif person.genealogy.tribal_elf >= 50:
			bonus_confidence += 15
			bonus_strength += 1
			bonus_agility += .4
		elif person.genealogy.tribal_elf >= 30:
			bonus_confidence += 10
			bonus_strength += .4
			bonus_agility += .2
		else:
			bonus_confidence += 5
			bonus_strength += .2
			bonus_agility += .2
	
	#Greenskins 
	#Orcs
	if person.genealogy.orc > 0:
		if person.genealogy.orc >= 100:
			bonus_strength += 3
			bonus_courage += 10
		if person.genealogy.orc >= 70:
			bonus_strength += 2
			bonus_courage += 10
		elif person.genealogy.orc >= 70:
			bonus_strength += 2
			bonus_courage += 10
		elif person.genealogy.orc >= 50:
			bonus_strength += 1.4
			bonus_courage += 5
		elif person.genealogy.orc >= 30:
			bonus_strength += 1
		else:
			bonus_strength += .4
	
	#Goblin 
	if person.genealogy.goblin > 0:
		if person.genealogy.goblin >= 100:
			bonus_fertility += 40
			bonus_agility += 1
			bonus_strength += 1
		elif person.genealogy.goblin >= 70:
			bonus_fertility += 30
			bonus_agility += 1
			bonus_strength += .4
		elif person.genealogy.goblin >= 50:
			bonus_fertility += 25
			bonus_agility += 1
			bonus_strength += .4
		elif person.genealogy.goblin >= 30:
			bonus_fertility += 20
			bonus_agility += .4
			bonus_strength += .2
		else:
			bonus_fertility += 10
			bonus_agility += .2
			bonus_strength += .1
	
	#Aquatic
	#Nereid 
	if person.genealogy.nereid > 0:
		if person.genealogy.nereid >= 100:
			bonus_beauty += 25
			bonus_charm += 15
			bonus_magic += 2
		elif person.genealogy.nereid >= 70:
			bonus_beauty += 20
			bonus_charm += 15
			bonus_magic += 1
		elif person.genealogy.nereid >= 50:
			bonus_beauty += 15
			bonus_charm += 10
			bonus_magic += .4
		elif person.genealogy.nereid >= 30:
			bonus_beauty += 10
			bonus_charm += 5
			bonus_magic += .2
		else:
			bonus_beauty += 5
			bonus_charm += 5
			bonus_magic += .2
	
	#Scylla 
	if person.genealogy.scylla > 0:
		if person.genealogy.scylla >= 100:
			bonus_confidence += 20
			bonus_magic += 2
			bonus_agility += 1
		elif person.genealogy.scylla >= 70:
			bonus_confidence += 20
			bonus_magic += 1
			bonus_agility += 1
		elif person.genealogy.scylla >= 50:
			bonus_confidence += 20
			bonus_magic += 1
			bonus_agility += 1
		elif person.genealogy.scylla >= 30:
			bonus_confidence += 15
			bonus_magic += 1
			bonus_agility += .4
		else:
			bonus_magic += .2
			bonus_agility += .2
	
	#Aerials
	#Fairy
	if person.genealogy.fairy > 0:
		if person.genealogy.fairy >= 100:
			bonus_magic += 3
			bonus_charm += 10
		elif person.genealogy.fairy >= 70:
			bonus_magic += 2
			bonus_charm += 10
		elif person.genealogy.fairy >= 50:
			bonus_magic += 1.4
			bonus_charm += 5
		elif person.genealogy.fairy >= 30:
			bonus_magic += 1
		else:
			bonus_magic += .4
	
	#Harpy
	if person.genealogy.harpy > 0:
		if person.genealogy.harpy >= 100:
			bonus_courage += 25
			bonus_agility += 1
			bonus_magic += 2
		elif person.genealogy.harpy >= 70:
			bonus_courage += 20
			bonus_agility += 1
			bonus_magic += 1
		elif person.genealogy.harpy >= 50:
			bonus_courage += 15
			bonus_agility += 1
			bonus_magic += .4
		elif person.genealogy.harpy >= 30:
			bonus_courage += 10
			bonus_agility += .4
			bonus_magic += .2
		else:
			bonus_agility += .2
			bonus_magic += .2
	
	#Seraph
	if person.genealogy.seraph > 0:
		if person.genealogy.seraph >= 100:
			bonus_beauty += 30
			bonus_magic += 2
			bonus_endurance += 1
		elif person.genealogy.seraph >= 70:
			bonus_beauty += 25
			bonus_magic += 1
			bonus_endurance += 1
		elif person.genealogy.seraph >= 50:
			bonus_beauty += 20
			bonus_magic += 1
			bonus_endurance += .4
		elif person.genealogy.seraph >= 30:
			bonus_beauty += 15
			bonus_magic += .4
			bonus_endurance += .2
		else:
			bonus_beauty += 10
			bonus_magic += .2
			bonus_endurance += .2
	
	#Demon
	if person.genealogy.demon > 0:
		if person.genealogy.demon >= 100:
			bonus_charm += 25
			bonus_strength += 1
			bonus_magic += 2
		elif person.genealogy.demon >= 70:
			bonus_charm += 20
			bonus_strength += 1
			bonus_magic += 1
		elif person.genealogy.demon >= 50:
			bonus_charm += 15
			bonus_strength += .4
			bonus_magic += 1
		elif person.genealogy.demon >= 30:
			bonus_charm += 10
			bonus_strength += .2
			bonus_magic += .4
		else:
			bonus_charm += 4
			bonus_strength += .2
			bonus_magic += .2
	
	#Monstrous
	#Dragonkin
	if person.genealogy.dragonkin > 0:
		if person.genealogy.dragonkin >= 100:
			bonus_strength += 1.6
			bonus_magic += 1
			bonus_endurance += 1
		elif person.genealogy.dragonkin >= 70:
			bonus_strength += 1.4
			bonus_magic += 0.4
			bonus_endurance += 1
		elif person.genealogy.dragonkin >= 50:
			bonus_strength += 1
			bonus_magic += 0.2
			bonus_endurance += 1
		elif person.genealogy.dragonkin >= 30:
			bonus_strength += 1
			bonus_magic += 0.2
			bonus_endurance += .4
		else:
			bonus_strength += .4
			bonus_magic += 0.2
			bonus_endurance += .2
	
	#Arachna
	if person.genealogy.arachna > 0:
		if person.genealogy.arachna >= 100:
			bonus_strength += 2
			bonus_agility += 1.6
		elif person.genealogy.arachna >= 70:
			bonus_strength += 1
			bonus_agility += 1.4
		elif person.genealogy.arachna >= 50:
			bonus_strength += 1
			bonus_agility += 1
		elif person.genealogy.arachna >= 30:
			bonus_strength += .4
			bonus_agility += 1
		else:
			bonus_strength += .2
			bonus_agility += .4
	
	#Lamia 
	if person.genealogy.lamia > 0:
		if person.genealogy.lamia >= 100:
			bonus_confidence += 25
			bonus_strength += 2
			bonus_magic += 1
		elif person.genealogy.lamia >= 70:
			bonus_confidence += 20
			bonus_strength += 1
			bonus_magic += 1
		elif person.genealogy.lamia >= 50:
			bonus_confidence += 15
			bonus_strength += 1
			bonus_magic += .4
		elif person.genealogy.lamia >= 30:
			bonus_confidence += 10
			bonus_strength += .6
			bonus_magic += .2
		else:
			bonus_strength += .4
			bonus_magic += .2
	
	if person.genealogy.dryad > 0:
		if person.genealogy.dryad >= 100:
			bonus_strength += 2
			bonus_magic += 1
			bonus_endurance += 1
		elif person.genealogy.dryad >= 70:
			bonus_strength += .6
			bonus_magic += 1
			bonus_endurance += 1
		elif person.genealogy.dryad >= 50:
			bonus_strength += .4
			bonus_magic += 1
			bonus_endurance += .6
		elif person.genealogy.dryad >= 30:
			bonus_strength += .2
			bonus_magic += .6
			bonus_endurance += .4
		else:
			bonus_strength += .2
			bonus_magic += .4
			bonus_endurance += .2
	
	#Slime
	if person.genealogy.slime > 0:
		if person.genealogy.slime >= 100:
			bonus_strength += 1
			bonus_agility += 1
			bonus_magic += 1
			bonus_endurance += 2
		elif person.genealogy.slime >= 70:
			bonus_strength += 1
			bonus_agility += .6
			bonus_magic += .6
			bonus_endurance += 2
		elif person.genealogy.slime >= 50:
			bonus_strength += 1
			bonus_agility += .4
			bonus_magic += .4
			bonus_endurance += 1.6
		elif person.genealogy.slime >= 30:
			bonus_strength += .6
			bonus_agility += .2
			bonus_magic += .2
			bonus_endurance += 1
		else:
			bonus_strength += .2
			bonus_agility += .2
			bonus_magic += .2
			bonus_endurance += .4
	
	#Cat 
	if person.genealogy.cat > 0:
		if person.genealogy.cat >= 100:
			bonus_charm += 15
			bonus_agility += 2
			bonus_endurance += 1
		elif person.genealogy.cat >= 70:
			bonus_charm += 15
			bonus_agility += 1.4
			bonus_endurance += 1
		elif person.genealogy.cat >= 50:
			bonus_charm += 10
			bonus_agility += 1
			bonus_endurance += .4
		elif person.genealogy.cat >= 30:
			bonus_charm += 5
			bonus_agility += .6
			bonus_endurance += .2
		else:
			bonus_agility += .4
			bonus_endurance += .2
	
	#Wolf 
	if person.genealogy.dog > 0:
		if person.genealogy.dog >= 100:
			bonus_courage += 10
			bonus_strength += 1
			bonus_agility += 2
		elif person.genealogy.dog >= 70:
			bonus_courage += 10
			bonus_strength += 1
			bonus_agility += 1
		elif person.genealogy.dog >= 50:
			bonus_courage += 5
			bonus_strength += 1
			bonus_agility += .4
		elif person.genealogy.dog >= 30:
			bonus_strength += .6
			bonus_agility += .2
		else:
			bonus_strength += .4
			bonus_agility += .2
	
	#Bunny
	if person.genealogy.bunny > 0:
		if person.genealogy.bunny >= 100:
			bonus_fertility += 30
			bonus_agility += 3
		elif person.genealogy.bunny >= 70:
			bonus_fertility += 30
			bonus_agility += 2
		elif person.genealogy.bunny >= 50:
			bonus_fertility += 25
			bonus_agility += 2
		elif person.genealogy.bunny >= 30:
			bonus_fertility += 20
			bonus_agility += 1
		else:
			bonus_fertility += 10
			bonus_agility += .4
	
	#Fox
	if person.genealogy.fox > 0:
		if person.genealogy.fox >= 100:
			bonus_charm += 20
			bonus_wit += 20
			bonus_agility += 2
		elif person.genealogy.fox >= 70:
			bonus_charm += 20
			bonus_wit += 20
			bonus_agility += 1
		elif person.genealogy.fox >= 50:
			bonus_charm += 15
			bonus_wit += 15
			bonus_agility += 1
		elif person.genealogy.fox >= 30:
			bonus_charm += 10
			bonus_wit += 10
			bonus_agility += .6
		else:
			bonus_charm += 5
			bonus_wit += 5
			bonus_agility += .2
	
	#Tanuki
	if person.genealogy.raccoon > 0:
		if person.genealogy.raccoon >= 100:
			bonus_wit += 20
			bonus_agility += 2
			bonus_magic += 1
		elif person.genealogy.raccoon >= 70:
			bonus_wit += 20
			bonus_agility += 1
			bonus_magic += 1
		elif person.genealogy.raccoon >= 50:
			bonus_wit += 15
			bonus_agility += 1
			bonus_magic += .6
		elif person.genealogy.raccoon >= 30:
			bonus_wit += 10
			bonus_agility += .4
			bonus_magic += .2
		else:
			bonus_agility += .2
			bonus_magic += .2
	
	#Centaur
	if person.genealogy.horse > 0:
		if person.genealogy.horse >= 100:
			bonus_courage += 20
			bonus_strength += 1
			bonus_endurance += 2
		elif person.genealogy.horse >= 70:
			bonus_courage += 20
			bonus_strength += 1
			bonus_endurance += 1
		elif person.genealogy.horse >= 50:
			bonus_courage += 15
			bonus_strength += 1
			bonus_endurance += .6
		elif person.genealogy.horse >= 30:
			bonus_courage += 10
			bonus_strength += .6
			bonus_endurance += .4
		else:
			bonus_strength += .4
			bonus_endurance += .2
	
	#Taurus 
	if person.genealogy.cow > 0:
		if person.genealogy.cow >= 100:
			bonus_fertility += 20
			bonus_endurance += 3
		elif person.genealogy.cow >= 70:
			bonus_fertility += 20
			bonus_endurance += 2
		elif person.genealogy.cow >= 50:
			bonus_fertility += 15
			bonus_endurance += 1.6
		elif person.genealogy.cow >= 30:
			bonus_fertility += 10
			bonus_endurance += 1
		else:
			bonus_endurance += .4
	
	var somethingchanged = false
	if addstats == true:
		if bonus_strength > 0:
			person.stats.str_mod += round(bonus_strength)
			somethingchanged = true
		if bonus_agility > 0:
			person.stats.agi_mod += round(bonus_agility)
			somethingchanged = true
		if bonus_magic > 0:
			person.stats.maf_mod += round(bonus_magic)
			somethingchanged = true
		if bonus_endurance > 0:
			person.stats.end_mod += round(bonus_endurance)
			somethingchanged = true
		if bonus_courage > 0:
			person.stats.cour_racial += round(bonus_courage)
			somethingchanged = true
		if bonus_confidence > 0:
			person.stats.conf_racial += round(bonus_confidence)
			somethingchanged = true
		if bonus_wit > 0:
			person.stats.wit_racial += round(bonus_wit)
			somethingchanged = true
		if bonus_charm > 0:
			person.stats.charm_racial += round(bonus_charm)
			somethingchanged = true
		if bonus_beauty > 0:
			person.beautybase += round(bonus_beauty)
			somethingchanged = true
		if bonus_fertility > 0:
			person.preg.bonus_fertility += round(bonus_fertility)
			somethingchanged = true
		if somethingchanged == true:
			person.npcexpanded.racialbonusesapplied = true
	else:
		if bonus_strength > 0:
			person.stats.str_mod -= round(bonus_strength)
			somethingchanged = true
		if bonus_agility > 0:
			person.stats.agi_mod -= round(bonus_agility)
			somethingchanged = true
		if bonus_magic > 0:
			person.stats.maf_mod -= round(bonus_magic)
			somethingchanged = true
		if bonus_endurance > 0:
			person.stats.end_mod -= round(bonus_endurance)
			somethingchanged = true
		if bonus_courage > 0:
			person.stats.cour_racial -= round(bonus_courage)
			somethingchanged = true
		if bonus_confidence > 0:
			person.stats.conf_racial -= round(bonus_confidence)
			somethingchanged = true
		if bonus_wit > 0:
			person.stats.wit_racial -= round(bonus_wit)
			somethingchanged = true
		if bonus_charm > 0:
			person.stats.charm_racial -= round(bonus_charm)
			somethingchanged = true
		if bonus_beauty > 0:
			person.beautybase -= round(bonus_beauty)
			somethingchanged = true
		if bonus_fertility > 0:
			person.preg.bonus_fertility -= round(bonus_fertility)
			somethingchanged = true
		
		if somethingchanged == true:
			person.npcexpanded.racialbonusesapplied = false
	
