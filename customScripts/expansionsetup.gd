### <CustomFile> ###

###---Contains Functions that will typically only run once per person to Expand them---###

#---Core Expansion Setup Functions---#
func expandGame():
	#globals.expansionsetup.setIdentity(person)
	
	#---Person Expanded
	for person in globals.slaves + globals.state.allnpcs:
		if person == null:
			continue
		#Origins Fix
		if person.origins == 'atypical':
			person.origins = 'commoner'
		#Sex Expanded
		if person.sexexpanded == null:
			person.sexexpanded = {pliability = 0,elasticity = 0}
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
		#Permanent NPC Reputations
		if !person.npcexpanded.has('reputation'):
			if person.npcexpanded.citizen == true:
				person.npcexpanded['reputation'] = round(rand_range(1,5))
			else:
				person.npcexpanded['reputation'] = round(rand_range(-1,-5))
# Unneeded?
#		#NPCs Expanded
#		if person.npcexpanded == null:
#			person.npcexpanded = {mansionbred = false,citizen = true,timesmet = 0,timesfought = 0,timesrescued = 0,timesraped = 0}		
#		#Farm Expanded
#		if person.farmexpanded == null:
#			person.farmexpanded = {production = 'default',extraction='default',autopump=false,restraints='free',sleeplocation='default',worklocation='default',bedding='dirt',objects = []}

	#---Mansion Expanded	
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
	#Nursery to Crystal Conversion
	if globals.state.mansionupgrades.mansionnursery > 1:
		if globals.state.mansionupgrades.mansionnursery == 3:
			globals.state.mansionupgrades.dimensionalcrystal == 2
			globals.state.mansionupgrades.mansionnursery == 1
		else:
			globals.state.mansionupgrades.dimensionalcrystal == 1
			globals.state.mansionupgrades.mansionnursery == 1
	
	#Dim Crystal
	if !globals.state.thecrystal.has('empoweredvirginity'):
		globals.state.thecrystal['empoweredvirginity'] = false
	
	#Sidequests
	if !globals.state.sidequests.has('dimcrystal'):
		globals.state.sidequests['dimcrystal'] = 0
		
	#Crystal to Abilities Conversion - TBK Remove?
#	if globals.state.mansionupgrades.dimensionalcrystal >= 1:
#		globals.state.thecrystal.abilities.append('pregnancyspeed')
	
	
	
	#---Farm Expanded
	#Resources
	if !globals.resources.farmexpanded.has('worker_cycle'):
		globals.resources.farmexpanded['worker_cycle'] = []
	if !globals.resources.farmexpanded.has('work_type'):
		globals.resources.farmexpanded['work_type'] = ""
	#v1.6a
	if typeof(globals.resources.farmexpanded.worker_cycle) != TYPE_DICTIONARY || globals.resources.farmexpanded.worker_cycle.has('herder'):
		globals.resources.farmexpanded.worker_cycle = {'farmhand':[], 'milkmaid':[], 'stud':[]}
		globals.resources.farmexpanded.work_type = ''
	#Commented Out as throws up errors
#	if !globals.state.has('farmexpanded'):
#		globals.state['farmexpanded'] = {aphrodisiacs = 0, production = "food", extraction='hand', totalcontainers = {bucket = -1, pail = -1, jug = -1, canister = -1}, autopump=false, restraints=[], zones = {sleeplocations = ['field'], worklocations = ['field'], furnishings = ['dirt']}, objects = []}
#	if !globals.state.farmexpanded.has('totalcontainers'):
#		globals.state.farmexpanded['totalcontainers'] = {bucket = -1, pail = -1, jug = -1, canister = -1}
#	if !globals.state.farmexpanded.has('aphrodisiacs'):
#		globals.state.farmexpanded['aphrodisiacs'] = 0
	
	#---Towns Expanded
	#Reputations
	if !globals.state.reputation.has('shaliq'):
		globals.state.reputation['shaliq'] = 0
	if !globals.state.reputation.has('umbra'):
		globals.state.reputation['umbra'] = 0
	#Town Expansion
	for towns in ['wimborn','frostford','gorn','amberguard']:
		if !globals.state.townsexpanded[towns].has('dailyreport'):
			globals.state.townsexpanded[towns]['dailyreport'] = {shopping = 0, crimeattempted = 0, crimeprevented = 0, crimesucceeded = 0}
	for town in globals.expansion.citiesarray:
		if !globals.state.townsexpanded[town].dailyreport.has('text'):
			globals.state.townsexpanded[town].dailyreport['text'] = ""
	for town in globals.expandedtowns:
		if !globals.state.townsexpanded[town].has('milkinterest'):
			globals.state.townsexpanded[town]['milkinterest'] = 5
		if !globals.state.townsexpanded[town].has('townhall'):
			globals.state.townsexpanded[town]['townhall'] = {law_change_cost = 5, fines = [], autopay_fines = false,}
		if !globals.state.townsexpanded[town].has('laws'):
			globals.state.townsexpanded[town]['laws'] = {public_nudity = false,}
	
	#---Fixing Old Issues; Possibly Unneeded
	#NPC Array Change
	if !globals.state.npclastlocation.empty():
		#offscreennpcs = [person.id, location.code, encounterchance, action, reputation, status]
		for npcarray in globals.state.npclastlocation.duplicate():
			var npc = globals.state.findnpc(npcarray[1])
			if npc == null:
				continue
	
			var id = npcarray[1]
			var location = npcarray[0]
			var encounterchance = npcarray[2]
			var action = npc.npcexpanded.dailyaction
			if action == "":
				action = "resting"
			var reputation = 0
			var status = ""
			if npc.npcexpanded.citizen == true:
				reputation = round(rand_range(1,5)) + globals.originsarray.find(npc.origins)
				status = 'citizen'
			else:
				reputation = -round(rand_range(1,5) + globals.originsarray.find(npc.origins)*rand_range(-1, 1))
				status = 'criminal'
			globals.state.offscreennpcs.append([id,location,encounterchance,action,reputation,status])
			globals.state.npclastlocation.erase(npcarray)
		globals.state.npclastlocation.clear()
	#Restoring Old Reputations
	for npc in globals.state.offscreennpcs:
		var person = globals.state.findnpc(npc[0])
		person.npcexpanded.reputation = npc[4]
	
	#End Update
	globals.state.expansionversion = globals.expansionsettings.modversion
	
	#Force Mass Person Expansion
	for person in globals.slaves + globals.state.allnpcs + globals.state.babylist:
		if person.expanded == false:
			globals.expansionsetup.expandPerson(person)
#		if float(person.expansionversion) < float(globals.expansionsettings.modversion): #Old Method#
		if str(person.expansionversion) != str(globals.expansionsettings.modversion):
			globals.backwardscompatibility.backwardsCompatibility(person)
		globals.expansion.updatePerson(person)
		if person.race == "Dragonkin" && person.scalecolor == '':
			person.scalecolor = globals.randomfromarray(globals.races["Dragonkin"].scalecolor)
		if person.race == "Harpy" && person.feathercolor == '':
			person.feathercolor = globals.randomfromarray(globals.races["Harpy"].feathercolor)
		if globals.state.relativesdata.has(person.id):
			globals.state.relativesdata[person.id].name = person.name_long()
	for i in globals.guildslaves:
		for person in globals.guildslaves[i]:
			if person.expanded == false:
				globals.expansionsetup.expandPerson(person)
#			if float(person.expansionversion) < float(globals.expansionsettings.modversion):
			if str(person.expansionversion) != str(globals.expansionsettings.modversion):
				globals.backwardscompatibility.backwardsCompatibility(person)
			globals.expansion.updatePerson(person)
			if person.race == "Dragonkin" && person.scalecolor == '':
				person.scalecolor = globals.randomfromarray(globals.races["Dragonkin"].scalecolor)
			if person.race == "Harpy" && person.feathercolor == '':
				person.feathercolor = globals.randomfromarray(globals.races["Harpy"].feathercolor)

			if globals.state.relativesdata.has(person.id):
				globals.state.relativesdata[person.id].name = person.name_long()

	#---BugFixing & Cleanup
	#erase NPCs with duplicate ids to slaves
	for i in globals.state.allnpcs.duplicate():
		for j in globals.slaves:
			if str(j.id) == str(i.id):
				globals.state.allnpcs.erase(i)
				break
	#fix slaves with duplicate ids
	var idx1 = globals.slaves.size() - 1
	var idx2
	while idx1 > 0:
		idx2 = idx1 - 1
		while idx2 >= 0:
			if str(globals.slaves[idx1].id) == str(globals.slaves[idx2].id):
				globals.slaves[idx1].id = str(globals.state.slavecounter)
				globals.state.slavecounter += 1
				break
			idx2 -= 1
		idx1 -= 1
	
	#v1.8 prolly
	#add weapon scaling attributes to all weapons
	for item in globals.state.unstackables.values():
		var refEffect = globals.itemdict[item.code].effect
		var newEffects = refEffect.duplicate(true)
		for j in item.effects:
			var isPresent = false
			for k in refEffect:
				if j.effect == k.effect && j.get('id') == k.get('id'):
					isPresent = true
					break
			if !isPresent:
				newEffects.append(j)
		item.effects = newEffects

func expandPerson(person):
	var sexvag = int(round(person.metrics.vag/10))
	var sexass = int(round(person.metrics.anal/10))
	var modifier = 0
	if person.vagina == 'normal' && person.vagvirgin == false:
		person.vagina = globals.vagsizearray[randi() % (globals.vagsizearray.size()-2)]
		while sexvag > 0:
			if rand_range(0,1) < .1:
				person.vagina = globals.vagsizearray[globals.vagsizearray.find(person.vagina)+1]
			sexvag -= 1
	if person.vagina != "none" && person.lubrication == -1:
		setLubrication(person)
	if person.asshole == 'normal':
		person.asshole = globals.assholesizearray[randi() % (globals.assholesizearray.size()-2)]
		while sexass > 0:
			if rand_range(0,1) < .1:
				person.asshole = globals.assholesizearray[globals.assholesizearray.find(person.asshole)+1]
			sexass -= 1
	if person.lips == 'none':
		#Add Racial Increases Later
		person.lips = globals.lipssizearray[randi() % (globals.lipssizearray.size()-3)]
		if rand_range(0,1) < .25:
			person.lips = globals.lipssizearray[globals.lipssizearray.find(person.lips)+1]
	#Non-Player Checks
	if true: # this condition is never false:   if person != globals.player:
		var origins = str(person.origins)
		#Dignity will change in future update
		var persondignitymin = globals.expansion.dignitymin[origins]
		var persondignitymax = globals.expansion.dignitymax[origins]
		person.dignity = round(rand_range(persondignitymin,persondignitymax))
		setVice(person)
		setDemeanor(person)
		setSexuality(person)
		setDesiredOffspring(person)
		#---Readd when Vices/Personalities are Readded
		#getPersonality(person)
		
		#Check Relation Data and Add if Non-Existant
		if !globals.state.relativesdata.has(person.id):
			globals.createrelativesdata(person)
	#Sets Sexuality for Existing Players/Starting Slave
	# this condition cannot be true when creating a new progress, only when loading a non-expanded progress, the day count is useless
	elif person == globals.player && globals.resources.day >= 1 || person.unique == 'startslave' && globals.resources.day >= 1:
		person.sexuality = globals.randomitemfromarray(['straight','mostlystraight','rarelygay'])
	# this condition is almost never checked but never true when checked
	#elif person == globals.player:
	#	person.sexuality = 'mostlystraight'
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
func setVice(person):
	var temparray = globals.expansion.vicearray.duplicate()
	if person.mind.vice == 'none' && person.mind.vice_removed == false:
		person.mind.vice = str(globals.randomitemfromarray(temparray))

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
		person.sexuality = globals.randomitemfromarray(['rarelystraight','mostlygay','gay'])
		person.trait_remove('Homosexual')
	elif person.traits.has('Bisexual'):
		person.sexuality = globals.randomitemfromarray(['rarelygay','bi','rarelystraight'])
		person.trait_remove('Bisexual')
	else:
		person.sexuality = globals.randomitemfromarray(globals.kinseyscale)

func setDesiredOffspring(person):
	#Maximum of 10 + Siblings
	var number = round(rand_range(-2,4))
	#Age
	if person.age == "child":
		number += round(rand_range(-2,1))
	elif person.age == "teen":
		number += round(rand_range(-2,3))
	elif person.age == "adult":
		number += round(rand_range(-3,4))
	#Races
	if person.race.find("Beastkin") > 0 || person.race.find("Goblin") > 0:
		number += round(rand_range(0,2))
	#Traits
	if person.traits.has("Fertile"):
		number += round(rand_range(1,3))
	elif person.traits.has("Infertile"):
		number += round(rand_range(-3,-1))
	#Add Some for Siblings
	var persondata
	if globals.state.relativesdata.has(person.id):
		persondata = globals.state.relativesdata[person.id]
	else:
		globals.createrelativesdata(person)
		persondata = globals.state.relativesdata[person.id]
	for i in persondata:
		number += rand_range(-.5,.5)
	number = clamp(round(number), 0, 12)
	#Assign Breeding Fetish
	if number > 0:
		person.fetish.pregnancy = globals.fetishopinion[clamp(2 + round(number/3), 2, 6)]
	else:
		person.fetish.pregnancy = globals.fetishopinion[round(rand_range(0,1))]
	person.pregexp.desiredoffspring = number

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
				person.add_trait(i)
				person.traitstorage.erase(trait)
				hasvirility = true
			if trait.tags.has('fertility-trait') && trait.tags.has('eggstrtrait'):
				person.add_trait(i)
				person.traitstorage.erase(trait)
				haseggstr = true
			if trait.tags.has('pliabilitytrait'):
				person.add_trait(i)
				person.traitstorage.erase(trait)
				haspliability == true
			if trait.tags.has('elasticitytrait'):
				person.add_trait(i)
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
				person.add_trait(i)
				person.traitstorage.erase(trait)
				hasregentrait = true
			if trait.tags.has('lactation-trait') && trait.tags.has('storagetrait'):
				person.add_trait(i)
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
				var choices = []
				if hasregentrait == false:
					choices.append('regen')
				if hasstoragetrait == false:
					choices.append('storage')
				variable = rand_range(0,1)
				var choice = globals.randomitemfromarray(choices)
				if choice == 'regen' && variable > .5:
					variable = rand_range(0,1)
					if variable > .8:
						person.add_trait("Milk Flow 2")
					elif variable < .2:
						person.add_trait("Weak Milk Flow")
					else:
						person.add_trait("Milk Flow 1")
				elif choice == 'storage' && variable > .5:
					variable = rand_range(0,1)
					if variable > .8:
						person.add_trait("Milk Storage 2")
					elif variable < .2:
						person.add_trait("Small Milk Glands")
					else:
						person.add_trait("Milk Storage 1")
				traitchance -= 1

#ralph4
func cleargenes(person):
	for race in person.genealogy:
		person.genealogy[race] = 0
#/ralph4

###---Added by Expansion---### Deviate Concept Tweaked
func setRaceBonus(person, increasestats):
	if globals.useRalphsTweaks:
		setRaceBonus_Ralph(person, increasestats)
		return
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

	#ralph4 - fix unique npc genealogies #ralphD - replicated code here to fix uniques even for players without the good taste to enable ralphs.  Revel in my benevolence plebs ;]
	if person.unique != null:
		if person.unique == 'Melissa':
			cleargenes(person)
			person.genealogy.human = 100
		elif person.unique == 'Cali':
			cleargenes(person)
			person.genealogy.dog = 70
			person.genealogy.human = 30
		elif person.unique in ['Emily','Tisha']:
			cleargenes(person)
			person.genealogy.human = 84
			person.genealogy.gnome = 2
			person.genealogy.elf = 2
			person.genealogy.fairy = 2
			person.genealogy.bunny = 2
			person.genealogy.raccoon = 2
			person.genealogy.fox = 2
			person.genealogy.cat = 2
			person.genealogy.dog = 2
		elif person.unique == 'Chloe':
			cleargenes(person)
			person.genealogy.gnome = 96
			person.genealogy.fairy = 4
		elif person.unique == 'Yris':
			cleargenes(person)
			person.genealogy.cat = 70
			person.genealogy.human = 30
		elif person.unique == 'Maple':
			cleargenes(person)
			person.genealogy.fairy = 100
		elif person.unique == 'Ayneris':
			cleargenes(person)
			person.genealogy.elf = 100
		elif person.unique == 'Ayda':	
			cleargenes(person)
			person.genealogy.tribal_elf = 100			
		elif person.unique == 'Zoe':
			cleargenes(person)
			person.genealogy.dog = 100
	#/ralph4 /ralphD		
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
	
	#Dryad
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
		if bonus_strength != 0:
			person.stats.str_mod += round(bonus_strength)
			somethingchanged = true
		if bonus_agility != 0:
			person.stats.agi_mod += round(bonus_agility)
			somethingchanged = true
		if bonus_magic != 0:
			person.stats.maf_mod += round(bonus_magic)
			somethingchanged = true
		if bonus_endurance != 0:
			person.stats.end_mod += round(bonus_endurance)
			somethingchanged = true
		if bonus_courage != 0:
			person.stats.cour_racial += round(bonus_courage)
			somethingchanged = true
		if bonus_confidence != 0:
			person.stats.conf_racial += round(bonus_confidence)
			somethingchanged = true
		if bonus_wit != 0:
			person.stats.wit_racial += round(bonus_wit)
			somethingchanged = true
		if bonus_charm != 0:
			person.stats.charm_racial += round(bonus_charm)
			somethingchanged = true
		if bonus_beauty != 0:
			person.beautybase += round(bonus_beauty)
			somethingchanged = true
		if bonus_fertility != 0:
			person.preg.bonus_fertility += round(bonus_fertility)
			somethingchanged = true
		if somethingchanged == true:
			person.npcexpanded.racialbonusesapplied = true
	else:
		if bonus_strength != 0:
			person.stats.str_mod -= round(bonus_strength)
			somethingchanged = true
		if bonus_agility != 0:
			person.stats.agi_mod -= round(bonus_agility)
			somethingchanged = true
		if bonus_magic != 0:
			person.stats.maf_mod -= round(bonus_magic)
			somethingchanged = true
		if bonus_endurance != 0:
			person.stats.end_mod -= round(bonus_endurance)
			somethingchanged = true
		if bonus_courage != 0:
			person.stats.cour_racial -= round(bonus_courage)
			somethingchanged = true
		if bonus_confidence != 0:
			person.stats.conf_racial -= round(bonus_confidence)
			somethingchanged = true
		if bonus_wit != 0:
			person.stats.wit_racial -= round(bonus_wit)
			somethingchanged = true
		if bonus_charm != 0:
			person.stats.charm_racial -= round(bonus_charm)
			somethingchanged = true
		if bonus_beauty != 0:
			person.beautybase -= round(bonus_beauty)
			somethingchanged = true
		if bonus_fertility != 0:
			person.preg.bonus_fertility -= round(bonus_fertility)
			somethingchanged = true
		
		if somethingchanged == true:
			person.npcexpanded.racialbonusesapplied = false
	

###---Added by Expansion---### Deviate Concept Tweaked ###Ralphomod### tweaked further
func setRaceBonus_Ralph(person, increasestats):
	var count_races = 0
	var hybridtype = "" #set person.race_display at bottom and make sure to assign hybridtype for every unique combo below
	#var somethingtoremoveshortstack
	var thisrace = 'human'
	var bonus_strength = 0
	var bonus_agility = 0
	var bonus_magic = 0
	var bonus_endurance = 0
	var bonus_strength_max = 0
	var bonus_agility_max = 0
	var bonus_magic_max = 0
	var bonus_endurance_max = 0
	var bonus_courage = 0
	var bonus_confidence = 0
	var bonus_wit = 0
	var bonus_charm = 0
	var bonus_courage_racial = 0
	var bonus_confidence_racial = 0
	var bonus_wit_racial = 0
	var bonus_charm_racial = 0
	var bonus_beauty = 0
	var bonus_fertility = 0
	var bonus_titssize = 0
	var bonus_penissize = 0
	var bonus_vagsize = 0
	var bonus_ballssize = 0
	var bonus_asssize = 0
	var bonus_height = 0
	var bonus_elasticity = 0
	var bonus_pliability = 0
	var bonus_lewdness = 0
	#as coded now, the following incur a chance of losing the original slave's stats if different than these defaults
	var bonus_catpenis = false
	var bonus_dogpenis = false
	var bonus_horsepenis = false
	var bonus_lizardpenis = false
	var bonus_rodentpenis = false
	var bonus_birdpenis = false
	var bonus_skincov = 'none'
	var bonus_skin = 'fair' #unless a variable is implemented to store previous person.skin, a reset applied to person.skin will only result in 'fair'
	var bonus_eyesclera = 'normal'
	var bonus_horns = 'none'
	var bonus_tail = 'none'
	var bonus_wings = 'none'
	var bonus_furcolor = 'none'
	var bonus_scalecolor = 'none'
	var bonus_eyecolor = 'none'
	var bonus_ears = 'human'
	var bonus_bodyshape = 'humanoid'
	var fire = 0
	var wind = 0
	var water = 0
	var earth = 0	
	var nature = 0
	var corruption = 0

	var addstats = increasestats
	
	if person == null:
		print("Invalid Person for Setting Racial Bonus")
		return
	
	#ralph4 - fix unique npc genealogies
	if person.unique != null:
		if person.unique == 'Melissa':
			cleargenes(person)
			person.genealogy.human = 100
		elif person.unique == 'Cali':
			cleargenes(person)
			person.genealogy.dog = 70
			person.genealogy.human = 30
		elif person.unique in ['Emily','Tisha']:
			cleargenes(person)
			person.genealogy.human = 84
			person.genealogy.gnome = 2
			person.genealogy.elf = 2
			person.genealogy.fairy = 2
			person.genealogy.bunny = 2
			person.genealogy.raccoon = 2
			person.genealogy.fox = 2
			person.genealogy.cat = 2
			person.genealogy.dog = 2
		elif person.unique == 'Chloe':
			cleargenes(person)
			person.genealogy.gnome = 96
			person.genealogy.fairy = 4
		elif person.unique == 'Yris':
			cleargenes(person)
			person.genealogy.cat = 70
			person.genealogy.human = 30
		elif person.unique == 'Maple':
			cleargenes(person)
			person.genealogy.fairy = 100
		elif person.unique == 'Ayneris':
			cleargenes(person)
			person.genealogy.elf = 100
		elif person.unique == 'Ayda':	
			cleargenes(person)
			person.genealogy.tribal_elf = 100			
		elif person.unique == 'Zoe':
			cleargenes(person)
			person.genealogy.dog = 100
	#/ralph4
	
	#Ralph - 
	#testing results: player only has this function run on it when generated and before person.unique is set: end result stat_mod's at random. Fix: new playercleartraits() that zero's out stat_mod's
	#work around - Starting Slave was having stats set per >50% code below instead of ==100% for seraph race
	#person.level += 10 #test
	person.stats.str_mod = 0	
	person.stats.agi_mod = 0
	person.stats.maf_mod = 0
	person.stats.end_mod = 0
	person.stats.str_max = globals.races[person.race.replace('Halfkin', 'Beastkin')].stats[globals.maxstatdict["sstr"]]
	person.stats.agi_max = globals.races[person.race.replace('Halfkin', 'Beastkin')].stats[globals.maxstatdict["sagi"]]
	person.stats.maf_max = globals.races[person.race.replace('Halfkin', 'Beastkin')].stats[globals.maxstatdict["smaf"]]
	person.stats.end_max = globals.races[person.race.replace('Halfkin', 'Beastkin')].stats[globals.maxstatdict["send"]]
	#person.stats.str_base = 0	
	#person.stats.agi_base = 0
	#person.stats.maf_base = 0
	#person.stats.end_base = 0
	person.stats.cour_racial = 0
	person.stats.conf_racial = 0
	person.stats.wit_racial = 0
	person.stats.charm_racial = 0
	#for i in person.traits: #added to reapply traits (eg. 'Robust' endurance bonus was removed by the above)
	#	
	#	person.trait_remove(trait)
	#	person.add_trait(trait)
	if person.traits.has('Weak'):
		person.stats.str_mod += globals.origins.traitlist["Weak"].effect.str_mod
		person.stats.str_max += globals.origins.traitlist["Weak"].effect.str_max
	if person.traits.has('Strong'):
		person.stats.str_mod += globals.origins.traitlist["Strong"].effect.str_mod
		person.stats.str_max += globals.origins.traitlist["Strong"].effect.str_max
	if person.traits.has('Clumsy'):
		person.stats.agi_mod += globals.origins.traitlist["Clumsy"].effect.agi_mod
		person.stats.agi_max += globals.origins.traitlist["Clumsy"].effect.agi_max
	if person.traits.has('Quick'):
		person.stats.agi_mod += globals.origins.traitlist["Quick"].effect.agi_mod
		person.stats.agi_max += globals.origins.traitlist["Quick"].effect.agi_max
	if person.traits.has('Magic Deaf'):
		person.stats.maf_mod += globals.origins.traitlist["Magic Deaf"].effect.maf_mod
		person.stats.maf_max += globals.origins.traitlist["Magic Deaf"].effect.maf_max
	if person.traits.has('Responsive'):
		person.stats.maf_mod += globals.origins.traitlist["Responsive"].effect.maf_mod
		person.stats.maf_max += globals.origins.traitlist["Responsive"].effect.maf_max
	if person.traits.has('Frail'):
		person.stats.end_mod += globals.origins.traitlist["Frail"].effect.end_mod
		person.stats.end_max += globals.origins.traitlist["Frail"].effect.end_max
	if person.traits.has('Robust'):
		person.stats.end_mod += globals.origins.traitlist["Robust"].effect.end_mod
		person.stats.end_max += globals.origins.traitlist["Robust"].effect.end_max
	#/ralph
	
	var racedict = {'human':'Human', 'gnome':'Gnome', 'elf':'Elf', 'tribal_elf':'Tribal Elf', 'dark_elf':'Dark Elf', 'orc':'Orc', 'goblin':'Goblin', 'dragonkin':'Dragonkin', 'dryad':'Dryad', 'arachna':'Arachna', 'lamia':'Lamia', 'fairy':'Fairy', 'harpy':'Harpy', 'seraph':'Seraph', 'demon':'Demon', 'nereid':'Nereid', 'scylla':'Scylla', 'slime':'Slime', 'bunny':'Beastkin Bunny', 'dog':'Beastkin Wolf', 'cow':'Taurus', 'cat':'Beastkin Cat', 'fox':'Beastkin Fox', 'horse':'Centaur', 'raccoon':'Beastkin Tanuki', 'hyena':'Gnoll', 'ogre':'Ogre', 'giant':'Giant', 'lizardfolk':'Lizardfolk', 'kobold':'Kobold', 'avali':'Avali', 'mouse':'Beastkin Mouse', 'squirrel':'Beastkin Squirrel', 'otter':'Beastkin Otter', 'bird':'Beastkin Bird'}

	#Count the person's races - used in Human >50% Hybrids bonus stat calcs
	for race in person.genealogy:
		if person.genealogy[race] > 0:
			count_races += 1
			fire += globals.races[racedict[race]].elementalmod.fire*float(person.genealogy[race])/10000
			wind += globals.races[racedict[race]].elementalmod.wind*float(person.genealogy[race])/10000
			water += globals.races[racedict[race]].elementalmod.water*float(person.genealogy[race])/10000
			earth += globals.races[racedict[race]].elementalmod.earth*float(person.genealogy[race])/10000
			nature += globals.races[racedict[race]].elementalmod.nature*float(person.genealogy[race])/10000
			corruption += globals.races[racedict[race]].elementalmod.corruption*float(person.genealogy[race])/10000
	
	corruption -= (float(person.genealogy.slime))/100
	
	var elements = {'fire':fire, 'wind':wind, 'water':water, 'earth':earth}

	var currentelement = ""
	var secondelement = ""
	var highestpercent = 0
	var secondhighestpercent = 0

	for element in elements.keys():
		if elements[element] >= highestpercent:
			secondelement = currentelement
			currentelement = element
			secondhighestpercent = highestpercent
			highestpercent = elements[element]
		if highestpercent == secondhighestpercent && rand_range(0,100) <= 50:
			currentelement = secondelement

	
	#assign racial bonuses
#	if person.npcexpanded.racialbonusesapplied == false && addstats == true || person.npcexpanded.racialbonusesapplied == true && addstats == false:
	if person.genealogy.human > 0:
		thisrace = 'Human'
		if person.genealogy.human >= 100:
			bonus_strength += 1
			bonus_agility += 1
			bonus_magic += 1
			bonus_endurance += 1
			if person.sex in ['male']:	
				bonus_height += 1
		elif person.genealogy.human >= 50 && person.race == thisrace:
			bonus_strength += person.genealogy.human/110 + person.genealogy.human*pow(count_races,1.2)/1000 - 0.6 + fire
			bonus_agility += person.genealogy.human/110 + person.genealogy.human*pow(count_races,1.2)/1000 - 0.6 + wind
			bonus_magic += person.genealogy.human/110 + person.genealogy.human*pow(count_races,1.2)/1000 - 0.6 + water
			bonus_endurance += person.genealogy.human/110 + person.genealogy.human*pow(count_races,1.2)/1000 - 0.6 + earth
			if person.sex in ['male']:
				bonus_height += person.genealogy.human/100
		else:
			bonus_strength += person.genealogy.human/150
			bonus_agility += person.genealogy.human/150
			bonus_magic += person.genealogy.human/150
			bonus_endurance += person.genealogy.human/150
			if person.sex in ['male']:
				bonus_height += person.genealogy.human/100
			
	if person.genealogy.gnome > 0:
		thisrace = 'Gnome'
		if person.genealogy.gnome >= 100:
			bonus_agility += 1
			bonus_magic += 1
			bonus_endurance += 2
			bonus_wit += 20
			bonus_wit_racial += 2
			bonus_penissize -= 1
			bonus_vagsize -= 1
			bonus_ballssize -= 1
		elif person.genealogy.gnome >= 50 && person.race == thisrace:
			bonus_wit += person.genealogy.gnome/5
			bonus_wit_racial += person.genealogy.gnome/50
			bonus_magic += earth + (nature - 0.25)*4
			bonus_endurance += person.genealogy.gnome/50
			if person.genealogy.demon >= 40 && person.sex == 'male': #Imp
				hybridtype = 'Imp'
				bonus_agility += 2.5
				bonus_fertility += person.genealogy.demon/2.5
				bonus_penissize += 2
				bonus_ballssize += 1
				bonus_asssize -= 1
				bonus_pliability += 1
				bonus_elasticity += 2
				bonus_lewdness += person.genealogy.demon
				person.add_trait('Sex-crazed') #not reversible
				if person.tail == 'none':
					bonus_tail = 'demon'
				if person.skin in ['pale', 'fair', 'olive', 'tan', 'brown', 'dark', 'none']:
					bonus_skin = 'red'
				if person.horns == 'none':
					bonus_horns = 'short'
				if person.wings == 'none':
					bonus_wings = 'leather_red'
			else:
				bonus_agility += (person.genealogy.bunny + person.genealogy.harpy)/33 + (1 - corruption)*2
				bonus_endurance -= person.genealogy.harpy/33 + (1 - corruption)*2 #offset by any hollow bird bones
				bonus_vagsize -= person.genealogy.gnome/125
				bonus_penissize -= person.genealogy.gnome/125
				bonus_ballssize -= person.genealogy.gnome/125		
		else:
			bonus_endurance += person.genealogy.gnome/50
			bonus_wit += person.genealogy.gnome/5
			if person.genealogy.goblin >= 50 || person.genealogy.fairy >= 50 || person.genealogy.harpy >= 50: #no need to make 'em smaller if they're already a small race
				bonus_titssize -= 0
				bonus_penissize -= 0
				bonus_vagsize -= 0
				bonus_ballssize -= 0
				bonus_height -= 0
			elif person.genealogy.elf >= 50 || person.genealogy.tribal_elf >= 50 || person.genealogy.dark_elf >= 50:
				bonus_titssize -= person.genealogy.gnome/200 
				bonus_penissize -= person.genealogy.gnome/100
				bonus_vagsize -= person.genealogy.gnome/200
				bonus_ballssize -= person.genealogy.gnome/200
				bonus_height -= person.genealogy.gnome/40
			else:	
				bonus_titssize -= person.genealogy.gnome/50 
				bonus_penissize -= person.genealogy.gnome/25
				bonus_vagsize -= person.genealogy.gnome/50
				bonus_ballssize -= person.genealogy.gnome/50
				bonus_height -= person.genealogy.gnome/20				
			
	#Long-Ears
	#Elf   
	if person.genealogy.elf > 0:
		thisrace = 'Elf'
		if person.genealogy.elf >= 100:
			bonus_agility += 2
			bonus_magic += 2
			bonus_beauty += 10
			bonus_fertility -= 10
			bonus_charm += 10
			bonus_charm_racial += 1
			bonus_titssize -= 1
			bonus_penissize -= 1
			bonus_asssize -= 1
		elif person.genealogy.elf >= 50 && person.race == thisrace:
			if person.genealogy.dryad >= 40: #Hulderfolk
				if person.sex == 'male':
					hybridtype = 'Huldrekall'
					bonus_strength += 0.5
					bonus_agility += 2.5
					bonus_endurance += 0.5
					bonus_beauty -= 40
					bonus_charm -= 10
					bonus_charm_racial -= 1
				else:
					hybridtype = 'Nymph'
					bonus_agility += 0.5
					bonus_magic += 1.5
					bonus_beauty += 30
					bonus_charm += 10
			elif water >= 0.4 && person.sex != 'male': #Siren
				hybridtype = 'Siren'
				bonus_beauty += 30
				bonus_charm += 20
				bonus_charm_racial += 2
				person.trait_remove('Mute')
				person.add_trait('Pretty Voice')
			else:
				bonus_strength += (corruption - 0.25)*4 + fire
				bonus_agility += person.genealogy.elf/50 + (nature - 0.5)*4 - (corruption - 0.25)*4
				bonus_magic += wind*4 + water
				bonus_endurance += earth
				bonus_beauty += person.genealogy.elf/10
				bonus_charm += person.genealogy.elf/10
				bonus_charm_racial += person.genealogy.elf/100
				bonus_fertility -= person.genealogy.elf/10
				bonus_titssize -= person.genealogy.elf/120 
				bonus_penissize -= person.genealogy.elf/120
				bonus_asssize -= person.genealogy.elf/120
		else:
			bonus_agility += person.genealogy.elf/50
			bonus_beauty += person.genealogy.elf/10
			bonus_fertility -= person.genealogy.elf/10
			bonus_charm += person.genealogy.elf/10
			bonus_charm_racial += person.genealogy.elf/100
			bonus_asssize -= person.genealogy.elf/50
			if person.genealogy.fairy >= 50 || person.genealogy.goblin >= 50 || person.genealogy.gnome >= 50 || person.genealogy.tribal_elf || person.genealogy.dark_elf >= 50: #no need to make 'em smaller if they're already a small race
				bonus_titssize -= 0
				bonus_penissize -= 0
			else:	
				bonus_titssize -= person.genealogy.elf/50 
				bonus_penissize -= person.genealogy.elf/50
	
	#Dark Elf
	if person.genealogy.dark_elf > 0:
		thisrace = 'Dark Elf'
		if person.genealogy.dark_elf >= 100:
			bonus_strength += 1
			bonus_agility += 1
			bonus_magic += 2
			bonus_beauty += 10
			bonus_fertility -= 15
			bonus_wit += 10
			bonus_wit_racial += 1
			bonus_penissize -= 1	
		elif person.genealogy.dark_elf >= 50 && person.race == thisrace:
			if water >= 0.4 && person.sex != 'male': #undine
				hybridtype = 'Undine'	
				bonus_strength += 0.5
				bonus_magic += 1.5
				bonus_endurance += 0.5
				bonus_beauty += 10
				bonus_titssize += 1
				if person.skincov == 'none':
					bonus_skincov = 'scales'
				person.add_trait('Soaker') #not reversible
				if !person.skin in ['pale blue', 'blue', 'purple']:
					bonus_skin = 'blue'
			elif person.genealogy.dryad >= 40: #Hulderfolk
				if person.sex == 'male':
					hybridtype = 'Huldrekall'
					bonus_strength += 0.5
					bonus_agility += 0.5
					bonus_magic += 1.5
					bonus_beauty -= 40
					bonus_charm -= 10
					bonus_charm_racial -= 1
				else:
					hybridtype = 'Nymph'
					bonus_agility += 0.5
					bonus_magic += 1.5
					bonus_beauty += 30
					bonus_charm += 10
					bonus_charm_racial += 1
			else:
				bonus_strength += fire*4*(.75 + nature) - (corruption - 0.5)*2 - 0.1
				bonus_agility += person.genealogy.dark_elf/100 + wind*4*(0.75 + nature) - (corruption - 0.5)*2 - 0.1
				bonus_magic += person.genealogy.dark_elf/100 + water*5*(0.75 + nature) - (corruption - 0.5)*2 - 0.1
				bonus_endurance += earth*4*(0.75 + nature) - (corruption - 0.5)*2 - 0.1
				bonus_beauty += person.genealogy.dark_elf/6.667 - corruption*10
				bonus_fertility -= person.genealogy.dark_elf/10 + corruption*10
				bonus_wit += person.genealogy.dark_elf/10
				bonus_wit_racial += person.genealogy.dark_elf/100
				bonus_charm -= (corruption - 0.5)*40
				bonus_titssize -= person.genealogy.dark_elf/200
				bonus_penissize -= person.genealogy.dark_elf/150
		else:
			bonus_agility += person.genealogy.dark_elf/100
			bonus_magic += person.genealogy.dark_elf/100
			bonus_beauty += person.genealogy.dark_elf/10
			bonus_fertility -= person.genealogy.dark_elf/10
			bonus_wit += person.genealogy.dark_elf/10
			if person.genealogy.fairy >= 50 || person.genealogy.goblin >= 50 || person.genealogy.gnome >= 50 || person.genealogy.elf >= 50 || person.genealogy.tribal_elf >= 50: #no need to make 'em smaller if they're already a small race
				bonus_titssize -= 0
				bonus_penissize -= 0
			else:	
				bonus_titssize -= person.genealogy.dark_elf/150
				bonus_penissize -= person.genealogy.dark_elf/75

	#Tribal Elf   
	if person.genealogy.tribal_elf > 0:
		thisrace = 'Tribal Elf'
		if person.genealogy.tribal_elf >= 100:
			bonus_strength += 1
			bonus_agility += 2
			bonus_endurance += 1
			bonus_beauty += 10
			bonus_fertility -= 10
			bonus_confidence += 20
			bonus_penissize -= 1
		elif person.genealogy.tribal_elf >= 50 && person.race == thisrace:
			bonus_confidence += person.genealogy.tribal_elf/5
			if fire >= 0.4: #ifrit
				hybridtype = 'Ifrit'	
				bonus_strength += 2.5
				bonus_agility += 0.5
				bonus_magic -= 2
				if person.horns == 'none':
					bonus_horns = 'curved'
				if person.tail == 'none':
					bonus_tail = 'demon'
				if !person.skin in ['black', 'dark', 'tan']:
					bonus_skin = 'red'
			elif person.genealogy.dryad >= 40: #Hulderfolk
				if person.sex == 'male':
					hybridtype = 'Huldrekall'
					bonus_strength += 1.5
					bonus_agility += 1.5
					bonus_endurance += 0.5
					bonus_beauty -= 40
					bonus_charm -= 10
					bonus_charm_racial -= 1
				else:
					hybridtype = 'Nymph'
					bonus_agility += 0.5
					bonus_magic += 1.5
					bonus_beauty += 30
					bonus_charm += 10
					bonus_charm_racial += 1
			else:
				bonus_strength += fire*4 - (corruption - 0.25)*6 #(.86*.25+.14*.25)*4 = 1 - (.25*64+.5*.25+11)/100-.25*6 = 0   = 1 + 0 + .14
				bonus_agility += person.genealogy.tribal_elf/50 + (nature - 0.75)*5.333 + wind #(.53*.75+.36*.5+.04*1) = 1.06-.71
				bonus_magic += (corruption - 0.25)*6 + water
				bonus_endurance += earth #.0425 + .17
				bonus_beauty += person.genealogy.tribal_elf/10
				bonus_fertility -= person.genealogy.tribal_elf/10
				bonus_titssize -= person.genealogy.tribal_elf/200
				bonus_penissize -= person.genealogy.tribal_elf/150
				bonus_asssize -= person.genealogy.tribal_elf/200
		else:
			bonus_agility += person.genealogy.tribal_elf/50
			bonus_beauty += person.genealogy.tribal_elf/10
			bonus_fertility -= person.genealogy.tribal_elf/10
			bonus_confidence += person.genealogy.tribal_elf/5
			bonus_confidence_racial += person.genealogy.tribal_elf/50
			bonus_asssize -= person.genealogy.tribal_elf/100
			if person.genealogy.fairy >= 50 || person.genealogy.goblin >= 50 || person.genealogy.gnome >= 50 || person.genealogy.elf >= 50: #no need to make 'em smaller if they're already a small race
				bonus_titssize -= 0
				bonus_penissize -= 0
			else:	
				bonus_titssize -= person.genealogy.tribal_elf/150
				bonus_penissize -= person.genealogy.tribal_elf/75

	#Greenskins 
	#Orcs
	#\n\nBreeding Note: Orcs are a lucrative side business for many breeders in the guild. Pure blood's are preferred by many a warlord and make stolid infantrymen, but it is a well known phenomena for orcish warbands to raid villages with little other motivation than to carry off attractive females of other species to mate with, unfortunately diluting their warrior heritage. The guild's secret to avid intraspecies copulation is to throw just a little elf into the mix.
	#\n\nBreeding Note: Breeding orcs presents a lucrative opportunity for breeders in the guild. Pure bloods make stolid soldiers, but it is a well known phenomena for orcish warbands to raid villages with little other motivation than to carry off attractive females of other species to mate with, unfortunately diluting their warrior heritage. The guild's secret to avid intraspecies copulation is to throw just a little elf into the mix.
	if person.genealogy.orc > 0:
		thisrace = 'Orc'
		if person.genealogy.orc >= 100:
			bonus_strength += 2
			bonus_endurance += 2
			bonus_beauty -= 10
			bonus_courage += 10
			bonus_courage_racial += 1
			bonus_vagsize += 1
			bonus_height += 1
		elif person.genealogy.orc >= 50 && person.race == thisrace:
			var ElvishBlood = (person.genealogy.elf + person.genealogy.tribal_elf)/15
			bonus_beauty += ElvishBlood
			bonus_beauty -= person.genealogy.orc/10 + (corruption - .75)*40
			bonus_courage += person.genealogy.orc/10
			bonus_courage_racial += person.genealogy.orc/100
			bonus_vagsize += 1
			if (person.genealogy.lamia + person.genealogy.dragonkin + person.genealogy.arachna/2) >= 40: #lizardman
				hybridtype = 'Lizardman'
				bonus_skincov = 'scales'
				bonus_tail = 'snake tail'
				bonus_strength += person.genealogy.orc/50 + person.genealogy.lamia/80 + person.genealogy.dragonkin/50
				bonus_agility += person.genealogy.dragonkin/80 + person.genealogy.lamia/40
				bonus_magic += person.genealogy.dragonkin/40 + person.genealogy.lamia/20
				bonus_endurance += person.genealogy.orc/100 + person.genealogy.dragonkin/40 + person.genealogy.lamia/40
			elif earth >= 0.25: #troll - The combination of accelerated orcish wound recovery and a massive constitution led this hybrid to be dubbed Troll.
				hybridtype = 'Troll'
				bonus_endurance += 3.5
				bonus_beauty -= corruption*10
				bonus_asssize += 1
				bonus_vagsize += 2
				bonus_height += 2
			else:
				bonus_strength += person.genealogy.orc/100 + fire*4 + (corruption - 0.75)*4
				bonus_agility += (.75 - corruption)*4
				bonus_endurance += person.genealogy.orc/100 + (nature - 0.25)*3.84
				bonus_height += person.genealogy.orc/100
		else:
			bonus_strength += person.genealogy.orc/100
			bonus_endurance += person.genealogy.orc/100
			bonus_beauty -= person.genealogy.orc/10
			bonus_courage += person.genealogy.orc/10
			bonus_courage_racial += person.genealogy.orc/100
			bonus_height += person.genealogy.orc/40
			if person.genealogy.dog >= 50 || person.genealogy.demon >= 50 || person.genealogy.horse >= 50 || person.genealogy.cow >= 50 || person.genealogy.dragonkin >= 50: #no need to make it bigger if they're already a hung race
				bonus_penissize += 0
			else:	
				bonus_penissize += person.genealogy.orc/50

	#Goblin
	#\n\nBreeding Note: Goblins are frequently underestimated, often to the mortal peril of their detractors. Though any relation to elves is pure speculation, breeders of the guild have noted marked compatibility. Additionally, goblin blood is often mutanagenic and in certain combinations offspring barely resembles their progenitors. 
	#It's rumored that long ago goblins were made to breed with orcs to quickly produce armies of hobgoblins, powerful from birth but much like mules in that they were seldom capable of siring offspring of their own.
	if person.genealogy.goblin > 0:
		thisrace = 'Goblin'
		if person.genealogy.goblin >= 100:
			bonus_strength += 2
			bonus_agility += 1
			bonus_magic += 1
			bonus_fertility += 50
			bonus_titssize -= 1 
			bonus_penissize -= 1
			bonus_pliability += 2
			bonus_lewdness += 10
			bonus_beauty -= 20
		elif person.genealogy.goblin >= 50 && person.race == thisrace:
			if person.skin in ['pale', 'fair', 'olive', 'tan', 'brown', 'dark']:
				bonus_skin = 'green'
			bonus_beauty += (0.75 - corruption)*50 - person.genealogy.goblin/5
			bonus_titssize -= person.genealogy.goblin/100 
			bonus_penissize += person.genealogy.orc/40
			bonus_pliability += person.genealogy.goblin/50
			bonus_lewdness += person.genealogy.goblin/10
			bonus_fertility += nature*50
			bonus_height += (100 - person.genealogy.goblin - person.genealogy.fairy - person.genealogy.gnome)/20
			if person.genealogy.fairy >= 40: #gremlin
				hybridtype = 'Gremlin'
				bonus_agility += 1.5
				bonus_magic += 0.5
				bonus_endurance -= 1
				bonus_beauty -= 10
				bonus_fertility += nature*25 #extra
				bonus_wit += 10
				bonus_charm -= 15
				bonus_height -= bonus_height #any added by tall races still happens below
				bonus_titssize -= 1 
				bonus_penissize -= 1
				bonus_elasticity += 2
				bonus_lewdness += 20
				person.add_trait('Scoundrel') #not reversible
			elif person.genealogy.goblin >= 70 && person.genealogy.tribal_elf >= 20: #red cap
				hybridtype = 'Redcap'
				bonus_strength += 2.5
				bonus_agility += 0.5
				bonus_wit += 10
				bonus_charm -= 10
				bonus_height += 1.4
				person.add_trait('Nimble') #not reversible
			elif person.genealogy.orc > 0 && (person.genealogy.lamia + person.genealogy.arachna + person.genealogy.slime) > 0: #Hobgoblin: It's said that long ago in times of war goblins could be made to breed with orcs to quickly produce armies of hobgoblins. The hobs could be quite powerful but much like mules in that they seldom sired offspring of their own
				hybridtype = 'Hobgoblin'
				bonus_strength += person.genealogy.orc*(person.genealogy.lamia + person.genealogy.arachna + person.genealogy.slime)/150
				bonus_wit -= 20
				bonus_charm -= 20
				bonus_beauty -= 20
				person.trait_remove('Fertile') #non-reversible
				person.add_trait('Infertile') #non-reversible
				bonus_fertility -= 100 + person.genealogy.orc*3
				if person.eyesclera == 'normal':
					bonus_eyesclera = 'black'
				bonus_height += person.genealogy.orc/20
			else:
				bonus_strength += person.genealogy.goblin/100 + earth*1.333 - (0.75 - corruption)*5
				bonus_agility += person.genealogy.goblin/100 + (0.75 - corruption)*5
		else:
			bonus_strength += person.genealogy.goblin/100
			bonus_agility += person.genealogy.goblin/100
			bonus_beauty -= person.genealogy.goblin/5
			bonus_pliability += person.genealogy.goblin/50
			bonus_lewdness += person.genealogy.goblin/10
			if person.genealogy.gnome >= 50 || person.genealogy.fairy >= 50 || person.genealogy.harpy >= 50: #no need to make 'em smaller if they're already a small race
				bonus_titssize -= 0
				bonus_penissize -= 0
				bonus_height -= 0
			elif person.genealogy.elf >= 50 || person.genealogy.tribal_elf >= 50:
				bonus_titssize -= person.genealogy.goblin/100 
				bonus_penissize -= person.genealogy.goblin/100
				bonus_height -= person.genealogy.goblin/50
			else:	
				bonus_titssize -= person.genealogy.goblin/50 
				bonus_penissize -= person.genealogy.goblin/50
				bonus_height -= person.genealogy.goblin/25

	#Dryad    
	if person.genealogy.dryad > 0:
		thisrace = 'Dryad'
		if person.genealogy.dryad >= 100:
			bonus_strength += 1
			bonus_magic += 2
			bonus_endurance += 1
		elif person.genealogy.dryad >= 50 && person.race == thisrace:
			if water >= 0.35 && person.sex in ['female', 'futanari']: #Naiad
				hybridtype = 'Naiad'
				bonus_agility += 2.5
				bonus_charm += 10
				bonus_beauty += 15
				bonus_vagsize -= 1
				bonus_pliability += 2
				bonus_lewdness += 25
				person.skincov = 'none' #can't be rolled back like bonus_ stats, but can't have Naiads looking like Dryads right?
				person.eyesclera = 'normal' #can't be rolled back like bonus_ stats, but can't have Naiads looking like Dryads right?
			elif person.genealogy.gnome*person.genealogy.cow >= 400: #Ent
				hybridtype = 'Ent'
				bonus_strength += 1.5
				bonus_endurance += 1.5
				bonus_penissize += 2 #george of the jungle was warned
				bonus_ballssize += 2
				bonus_vagsize += 3
				bonus_titssize += 5
				bonus_height += 2
				bonus_skincov = 'plants'
				bonus_skin = 'brown'
				person.add_trait('Sturdy') #not reversible
			elif fire >= 0.3:
				bonus_strength += (water)*4 + (1 + fire)*(1 + corruption)*1.75
				bonus_magic += person.genealogy.dryad/100 + (earth - 0.25)*4 - (1 + fire)*(1 + corruption)
				bonus_endurance += person.genealogy.dryad/100 + (nature - 1)*4 - (1 + fire)*(1 + corruption)
			elif corruption >= 0.37: #Spriggan
				hybridtype = 'Spriggan'
				bonus_strength += 2.5
				bonus_endurance += 0.5
				bonus_charm -= 20
				bonus_beauty -= 20
				if person.skincov == 'none':
					bonus_skincov = 'plants'
				if person.skin != 'green':
					bonus_skin = 'brown'
			else:
				bonus_strength += (water)*4 + (1 + fire)*(1 + corruption)*1.75
				bonus_magic += person.genealogy.dryad/100 + (earth - 0.25)*4 - (1 + fire)*(1 + corruption)
				bonus_endurance += person.genealogy.dryad/100 + (nature - 1)*4 - (1 + fire)*(1 + corruption)
		else:
			bonus_magic += person.genealogy.dryad/100
			bonus_endurance += person.genealogy.dryad/100

	#Aquatic
	#Nereid    
	if person.genealogy.nereid > 0:
		thisrace = 'Nereid'
		if person.genealogy.nereid >= 100:
			bonus_strength += 1
			bonus_magic += 3
			bonus_beauty += 20
			bonus_courage -= 10
			bonus_courage_racial -= 1
			bonus_charm += 10
			bonus_charm_racial += 1
			if person.sex != 'male':
				bonus_height += 1
		elif person.genealogy.nereid >= 50 && person.race == thisrace: 
			if nature >= 0.7 && person.sex in ['female']: #Ciguapa
				hybridtype = 'Ciguapa'
				bonus_strength += 1.5
				bonus_magic += 1.5
				bonus_beauty += 25
				bonus_wit += 10
				bonus_charm += 20
				person.trait_remove('Pretty Voice')
				person.add_trait('Mute')
				person.trait_remove('Masochist')
				person.add_trait('Sadist')
				if person.tail == 'fish':
					person.tail = 'none' #not reversible, but can't have this Dominican folkbabe with a fish tail
			elif person.genealogy.arachna >= 40 && person.sex in ['male']: #Lobsterman
				hybridtype = 'Lobsterman'
				bonus_strength += 0.5
				bonus_endurance += 2.5
				bonus_magic -= 1
				bonus_beauty -= 10
				bonus_courage += 10
				bonus_charm -= 10
				bonus_height += 1
				person.add_trait('Sturdy') #not reversible
				if !person.tail in ['fish', 'none']: 
					bonus_tail = 'fish' #not reversible for other tail types, but can't have Lobster with a cat tail or something
				bonus_skincov = 'scales'
				if !person.skin in ['blue', 'brown', 'dark', 'green', 'teal', 'black']:
					bonus_skin = 'red'
				#person.mods['augmentfur'] = 'augmentfur' #not reversible as applied - just adding to stack up some armor
				#person.add_effect(globals.effectdict.augmentfur) 
				#person.mods['augmentscales'] = 'augmentscales' #not reversible as applied
				#person.add_effect(globals.effectdict.augmentscales) 
			elif person.genealogy.dragonkin >= 40: #Battle Toad 
				hybridtype = 'Toadkin'
				bonus_strength += 2.5
				bonus_agility += 0.5
				bonus_magic -= 0.5
				bonus_pliability += 1
				person.tail = 'none' #not reversible as applied
				if person.traits.has('Natural Beauty'):
					person.trait_remove('Natural Beauty') #not reversible
				person.add_trait('Blemished') #not reversible
				person.mods['augmenttongue'] = 'augmenttongue' #not reversible as applied	
				if person.sex == 'male':
					bonus_courage += 25
				if !person.skin in ['green', 'jelly', 'teal']:
					bonus_skin = 'green'
			elif person.genealogy.lamia >= 40: #Frog 
				hybridtype = 'Frogkin'
				bonus_strength += 0.5
				bonus_agility += 1.5
				bonus_pliability += 1
				person.tail = 'none' #not reversible as applied
				person.mods['augmenttongue'] = 'augmenttongue' #not reversible as applied
				if !person.skin in ['green', 'jelly', 'teal']:
					bonus_skin = 'jelly'
			elif corruption >= 0.6: #Kappa
				hybridtype = 'Kappa'
				bonus_agility += 2.5
				bonus_beauty -= 10
				bonus_height -= 2
				bonus_lewdness += 25
				bonus_penissize -= 1
				bonus_ballssize -= 1
				bonus_asssize -= 1
				bonus_titssize -= 2
				bonus_vagsize -= 1
				person.tail = 'none' #not reversible
				if person.skincov == 'none':
					bonus_skincov = 'scales'
				if !person.skin in ['blue', 'brown', 'green', 'teal']:
					bonus_skin = 'green'	
			else:
				var reptilian = (person.genealogy.dragonkin + person.genealogy.lamia)/100 #Breeding with reptilian species results in offspring more accostomed to the land
				bonus_strength += water + reptilian*2.5
				bonus_agility += reptilian*2
				bonus_magic += person.genealogy.nereid/50 - abs(nature - 0.5)*4 + (corruption - 0.5)*4 #mana corruption; incompatible with land based nature magic
				bonus_endurance += reptilian*2 + (0.5 - corruption)*4
				bonus_beauty += person.genealogy.nereid/4 - corruption*10
				bonus_courage -= person.genealogy.nereid/10 #Nereid avoid sailors and contact in general
				bonus_courage_racial -= person.genealogy.nereid/100
				bonus_charm += person.genealogy.nereid/10
				bonus_charm_racial += person.genealogy.nereid/100
				if person.sex != 'male':
					bonus_height += person.genealogy.nereid/100
		else:
			bonus_magic += person.genealogy.nereid/50
			bonus_beauty += person.genealogy.nereid/5
			bonus_courage -= person.genealogy.nereid/10
			bonus_courage_racial -= person.genealogy.nereid/100
			bonus_charm += person.genealogy.nereid/10
			bonus_charm_racial += person.genealogy.nereid/100
			if person.sex != 'male':
				bonus_height += person.genealogy.nereid/100
	
	#Scylla     
	if person.genealogy.scylla > 0: # && person.unique != 'player': #Ralph2 - workaround for bug where Player received Scylla pure-blood bonuses
		thisrace = 'Scylla'
		if person.genealogy.scylla >= 100:
			bonus_strength += 1
			bonus_agility += 1
			bonus_magic += 2
			bonus_confidence += 20
			bonus_confidence_racial += 2
		elif person.genealogy.scylla >= 50 && person.race == thisrace:
			if person.genealogy.dryad >= 40 && person.sex != 'male': #Alraune
				hybridtype = 'Alraune'
				bonus_magic += 1.5
				bonus_endurance += 0.5
				bonus_charm += 20
				bonus_skincov = 'plants'
				person.add_trait('Small Eater') #not reversible
				if person.traits.has('Spoiled'):
					person.trait_remove('Spoiled') #not reversible
				else:
					person.add_trait('Ascetic') #not reversible
				if person.genealogy.dryad % 2 != 0 && person.skin in ['pale', 'fair', 'olive', 'tan', 'brown', 'dark', 'none']:
					bonus_skin = 'green'
			elif corruption >= 0.85 && person.sex != 'female': #Tentacle
				hybridtype = 'Tentacle'
				bonus_endurance += 1.5
				if person.traits.has('Natural Beauty'):
					person.trait_remove('Natural Beauty') #not reversible
				person.add_trait('Sex-crazed') #not reversible
				person.add_trait('Blemished') #not reversible
				bonus_lewdness += 25
				bonus_tail = 'tentacles'
				if person.skin in ['pale', 'fair', 'olive', 'tan', 'brown', 'dark', 'none']:
					bonus_skin = 'pink'
			else:
				bonus_strength += (corruption - 0.75)*16
				bonus_agility += person.genealogy.scylla/100 + person.genealogy.arachna/30 + person.genealogy.horse/60 #Octovigor!
				bonus_magic += person.genealogy.scylla/100 + water*1.5 - (corruption - 0.75)*5.333
				bonus_endurance += nature*1.95 + person.genealogy.arachna/60 + person.genealogy.horse/120
				bonus_fertility += person.genealogy.harpy/2 #get on the egg train CHOOO CHOOOOOO!
				bonus_confidence += person.genealogy.scylla/5 + (corruption - 0.75)*50
		else:
			bonus_agility += person.genealogy.scylla/100
			bonus_magic += person.genealogy.scylla/100
			bonus_confidence += person.genealogy.scylla/5
			bonus_confidence_racial += person.genealogy.scylla/50
	
	#Aerials
	#Fairy
	#\n\nBreeding Note: Properly trained Fae make fine assistants, but are typically unsuited to combat being weak of arm and frail of constitution aside from their stature. These shortcomings can be mitigated to some degree  however through crossbreeding with other winged races for enhanced aerodynamics or with hardier specimens of similar stature.
	if person.genealogy.fairy > 0:
		thisrace = 'Fairy'
		if person.genealogy.fairy >= 100:
			bonus_agility += 2
			bonus_magic += 2
			bonus_charm += 10
			bonus_charm_racial += 1
			bonus_titssize -= 1
			bonus_penissize -= 1
			bonus_asssize -= 1
			bonus_pliability += 1
			if person.sex in ['female', 'futanari']:
				bonus_lewdness += 10
		elif person.genealogy.fairy >= 50 && person.race == thisrace:
			bonus_pliability += person.genealogy.fairy/100
			bonus_titssize -= person.genealogy.fairy/100
			bonus_penissize -= person.genealogy.fairy/150
			bonus_asssize -= person.genealogy.fairy/100
			if person.sex in ['female', 'futanari']:
				bonus_lewdness += person.genealogy.fairy/10
			if wind >= 0.82: #sylph
				hybridtype = 'Sylph'
				bonus_agility += 2.5
				bonus_wings = 'insect'
			#elif water >= 0.3 && corruption >= 0.3: #Winter Fae / Unseelie
			#	hybridtype = 'Unseelie'
			#	if person.skin in ['olive', 'tan', 'brown', 'dark', 'none', 'red']:
			#		bonus_skin = 'pale_blue'
			#elif fire >= 0.3 && corruption < 0.35: #Summer Fae / Seelie
			#	hybridtype = 'Seelie'
			#	if person.skin in ['pale', 'fair', 'blue', 'pale_blue', 'teal', 'none']:
			#		bonus_skin = 'yellow'
			else:
				var wingedones = (person.genealogy.harpy + person.genealogy.seraph + person.genealogy.dragonkin + person.genealogy.demon)/100
				bonus_strength += corruption*4
				bonus_agility += (wind - 0.25)*2 + wingedones*2 #enhanced aerodynamics
				bonus_magic += person.genealogy.fairy/50 + (nature - 1) - corruption*4
				bonus_endurance += corruption*4
				bonus_charm += person.genealogy.fairy/10
		else:
			bonus_magic += person.genealogy.fairy/50
			bonus_charm += person.genealogy.fairy/10
			bonus_charm += person.genealogy.fairy/100
			if person.sex in ['female', 'futanari']:
				bonus_lewdness += person.genealogy.fairy/10
			if person.genealogy.gnome >= 50 || person.genealogy.goblin >= 50 || person.genealogy.harpy >= 50: #no need to make 'em smaller if they're already a small race
				bonus_titssize -= 0
				bonus_penissize -= 0
				bonus_height -= 0
			elif person.genealogy.elf >= 50 || person.genealogy.tribal_elf >= 50:
				bonus_titssize -= person.genealogy.fairy/50
				bonus_penissize -= person.genealogy.fairy/50
				bonus_height -= person.genealogy.fairy/40
			else:
				bonus_titssize -= person.genealogy.fairy/25
				bonus_penissize -= person.genealogy.fairy/25
				bonus_height -= person.genealogy.fairy/20

	#Harpy   
	#\n\nBreeding Note: Most study into Harpy breeding has been focused on enhanced physical characteristics. The most successful attempts have involved combining the mutanagenic effects of Demon heritage and one or more predatory beastkin species.
	if person.genealogy.harpy > 0:
		thisrace = 'Harpy'
		if person.genealogy.harpy >= 100:
			bonus_strength += 1
			bonus_agility += 2
			bonus_magic += 1
			bonus_fertility += 20
			bonus_courage += 25
			bonus_courage_racial += 2
			bonus_height -= 1
			if person.sex in ['female', 'futanari']:
				bonus_lewdness += 10
		elif person.genealogy.harpy >= 50 && person.race == thisrace:
			if earth >= 0.3: #Gargoyle - gotta be fans of the show out there
				hybridtype = 'Gargoyle'
				bonus_strength += 1.5
				bonus_endurance += 2.5
				bonus_titssize -= 1
				if !person.wings in ['leather_red']:
					bonus_wings = 'leather_black'
				if person.tail == 'none':
					bonus_tail = 'dragon'
				if person.horns == 'none':
					bonus_horns = 'short'
				if person.skin in ['pale', 'fair', 'olive', 'tan', 'brown', 'dark', 'none']:
					bonus_skin = 'pale_blue'
			else:
				var predatoryraces = (person.genealogy.cat + person.genealogy.fox + person.genealogy.dog)/100
				bonus_strength += predatoryraces*4 + (corruption - 0.75)*4
				bonus_agility += person.genealogy.harpy/50 + predatoryraces*3
				bonus_magic += wind + (nature - 0.5)*4 + (0.75 - corruption)*4
				bonus_fertility += person.genealogy.harpy/5 #get on the egg train CHOOO CHOOOOOO!
				bonus_courage += person.genealogy.harpy/4
				if person.sex in ['female', 'futanari']:
					bonus_lewdness += person.genealogy.harpy/10
		else:
			bonus_agility += person.genealogy.harpy/50
			bonus_courage += person.genealogy.harpy/4
			bonus_courage_racial += person.genealogy.harpy/50
			if person.sex in ['female', 'futanari']:
				bonus_lewdness += person.genealogy.harpy/10
			if person.genealogy.gnome >= 50 || person.genealogy.goblin >= 50 || person.genealogy.fairy >= 50: #no need to make 'em smaller if they're already a small race
				bonus_titssize -= 0
				bonus_penissize -= 0
			elif person.genealogy.elf >= 50 || person.genealogy.tribal_elf >= 50 || person.genealogy.dark_elf >= 50:
				bonus_titssize -= person.genealogy.harpy/50
				bonus_penissize -= person.genealogy.harpy/50
			else:
				bonus_titssize -= person.genealogy.harpy/25
				bonus_penissize -= person.genealogy.harpy/25
				bonus_height -= person.genealogy.harpy/50
	
	#Seraph   
	#\n\nBreeding Note: Specimens are still somewhat rare so results have not been corroberated, but one breeder has noted that the minds of Seraph dominant hybrids are heavily influenced by the instincts of their minority ancestors. Additionally, he notes that Seraph suffer a sensitivity to mana corrupted blood similar to Dark Elves.
	#The minds of Seraph dominant hybrids are heavily influenced by secondary ancestry. Seraph-demon hybrids suffer from some form of mana corruption, but strangely gnomish blood barely manifests itself although similarly corrupted. This anomaly has been studied by one particularly curious mage breeder, but to date no one has presented a plausible hypothesis as to why this might be.
	if person.genealogy.seraph > 0:
		thisrace = 'Seraph'
		if person.genealogy.seraph >= 100:
			bonus_strength += 1
			bonus_agility += 1
			bonus_magic += 2
			bonus_beauty += 25
			person.trait_remove('Pervert') #not reversible
			person.trait_remove('Deviant') #not reversible
			person.trait_remove('Fickle') #not reversible
			person.add_trait('Prude') #not reversible
		elif person.genealogy.seraph >= 50 && person.race == thisrace:
			if corruption < 0.1:
				person.trait_remove('Pervert') #not reversible
				person.trait_remove('Deviant') #not reversible
				person.trait_remove('Fickle') #not reversible
				person.add_trait('Prude') #not reversible
			if corruption >= 0.4:
				hybridtype = 'Nephilim'
				person.wings = 'none'
				bonus_strength += 1.5
				bonus_endurance += 1.5
				bonus_beauty += (1 - corruption)*person.genealogy.seraph/4
			#elif :
			#	hybridtype = 'Fravashi'
			#	add bodyguard specialty
			#elif nature >= 0.2 && ?:
			#	hybridtype = 'Ishim'	
			else:	
				bonus_strength += (fire - 0.5)*4
				bonus_agility += person.genealogy.seraph/100 + (wind - 0.25)*4
				bonus_magic += person.genealogy.seraph/50 + nature*3 
				bonus_beauty += person.genealogy.seraph/4
				#doublecheck
				bonus_fertility += (person.genealogy.cow + person.genealogy.bunny*2 + person.genealogy.arachna/2)*(nature*2 - corruption*2)
				bonus_courage += (person.genealogy.dog/2 - person.genealogy.bunny/2 + person.genealogy.horse/2 - person.genealogy.nereid/2)*(nature*2 - corruption*2)
				bonus_confidence += (person.genealogy.lamia/2 + person.genealogy.scylla/2)*(nature*2 - corruption*2)
				bonus_wit += (person.genealogy.fox/2 + person.genealogy.raccoon/2)*(nature*2 - corruption*2)
				bonus_charm += (person.genealogy.cat/2 + person.genealogy.fox/2 + person.genealogy.nereid/2)*(nature*2 - corruption*2)
				if person.genealogy.demon*nature >= 4:
					bonus_eyesclera = 'glowing'
					bonus_strength += (fire - 0.5)*4
					bonus_agility += (wind - 0.5)*12
					bonus_magic += nature*corruption*25 - nature*3
				elif person.genealogy.demon >= 30:
					bonus_eyesclera = 'black'
					bonus_lewdness += person.genealogy.demon
					if person.tail == 'none':
						bonus_tail = 'demon'
					if person.sex != 'male':
						if person.traits.has('Clever'):
							person.trait_remove('Clever') #not reversible
						person.add_trait('Ditzy') #not reversible
						bonus_beauty -= 30
					else:
						if person.traits.has('Prude'):
							person.trait_remove('Prude') #not reversible
						person.add_trait('Pervert') #not reversible
		else:
			bonus_magic += person.genealogy.seraph/50
			bonus_beauty += person.genealogy.seraph/4
	
	#Demon    
	##\n\nBreeding Note: Similar to Goblins, demonic progeny are often subject to mutation. Though there is much debate as to the source, Demon mana is clearly tainted and when invested in Demon dominant hybrids often causes them to take on animalistic physical traits from their secondary ancestry. Additionally, one breeder with Seraph stock claims mating them with Demons has an atavistic effect and appears to potentially amplify these traits.
	#The corrupted mana invested in Demon dominant hybrids often cause them to take on animalistic traits from secondary ancestry. Curiously, secondary seraph ancestry has an atavistic effect and potentially amplifying the effect.
	if person.genealogy.demon > 0:
		thisrace = 'Demon'
		if person.genealogy.demon >= 100:
			bonus_strength += 2
			bonus_agility += 1
			bonus_magic += 1
			bonus_charm += 25
			bonus_charm_racial += 2
			if person.sex == 'male':
				bonus_lewdness += 5
				bonus_charm -= 5
		elif person.genealogy.demon >= 50 && person.race == thisrace:
			if person.genealogy.bunny >= 40: #Succubus/Incubus
				if person.sex == 'male':
					hybridtype = 'Incubus'
					bonus_magic += 1.5
					bonus_endurance += 0.5
					bonus_beauty += 10
					person.add_trait('Pliable') #not reversible
					bonus_lewdness += person.genealogy.demon
					bonus_penissize += 1
					bonus_ballssize += 1
					bonus_pliability += 2
				else:
					hybridtype = 'Succubus'
					bonus_magic += 1.5
					bonus_agility += 0.5
					bonus_beauty += 10
					person.add_trait('Pliable') #not reversible
					bonus_lewdness += person.genealogy.demon
					bonus_titssize += .5
					bonus_pliability += 2
					bonus_elasticity += 1
			elif water >= 0.4 && person.sex in ['female', 'futanari']: #Rusalka - more commonly described as a water succubus though more vengeful and less expressly horny
				hybridtype = 'Rusalka'
				bonus_magic += 1.5
				bonus_strength += 0.5
				bonus_charm += 20
				bonus_beauty += 15
				bonus_lewdness += 10
				person.trait_remove('Masochist') #not reversible
				person.add_trait('Sadist') #not reversible
			#elif corruption >= 0.95 && nature >= 0.45:
				#hybridtype = 'Devourer'
				#bonus_eyesclera = 'red'
				#bonus_charm -= person.genealogy.demon/4
				#bonus_strength += 1.5
				#bonus_agility += 1.5
			elif person.genealogy.seraph >= 40: #fix person.shade to match seraph later
				bonus_charm -= 10
				bonus_eyesclera = 'black'
				person.horns = 'none'
				person.tail = 'none'
				person.trait_remove('Pervert') #not reversible
				person.trait_remove('Deviant') #not reversible
				person.trait_remove('Fickle') #not reversible
				person.add_trait('Prude') #not reversible
				if person.sex != 'male':
					hybridtype = 'Suckubus'
					bonus_titssize += .5
					bonus_pliability += 2
					bonus_elasticity += 1
					bonus_wings = 'feathered_white'
					person.add_trait('Clingy') #not reversible
					person.trait_remove('Mute') #not reversible
					person.add_trait('Foul Mouth') #not reversible	
				else:
					hybridtype = 'Incubore'
					bonus_penissize += 1
					bonus_ballssize += 1
					bonus_wings = 'feathered_black'
					person.add_trait('Monogamous') #not reversible
					person.add_trait('Passive') #not reversible
			else:
				bonus_strength += person.genealogy.demon/100 + (person.genealogy.dog/100 + person.genealogy.cat/100 + person.genealogy.arachna/100 + person.genealogy.cow/100 + person.genealogy.dragonkin/50)*(1+nature)*(1+nature)*corruption #max dragonkin ~1.4 +.5 + 1 ~= 3 ; arachna 50% = .6835 + .5 + .5
				bonus_agility += (fire - 0.375)*3.95 + (person.genealogy.cat/100 + person.genealogy.fox/50 + person.genealogy.horse/100 + person.genealogy.lamia/100 + person.genealogy.dog/100)*(1+nature)*(1+nature)*corruption #max dragonkin 2
				bonus_magic += person.genealogy.demon/100 - (1 - corruption)*2 + (1 - (1+nature)*(1+nature)*corruption) #up to 2.25 with 50% goblin ; arachna .25 + 1.367
				bonus_endurance += (person.genealogy.cow/100 + person.genealogy.horse/100 + person.genealogy.arachna/100)*(1+nature)*(1+nature)*corruption #max arachna 50% = .6835 + .5
				bonus_charm += person.genealogy.demon/4
		else:
			bonus_strength += person.genealogy.demon/100
			bonus_magic += person.genealogy.demon/100
			bonus_charm += person.genealogy.demon/4
			bonus_charm_racial += person.genealogy.demon/50
			if person.genealogy.dog >= 50 || person.genealogy.demon >= 50 || person.genealogy.horse >= 50 || person.genealogy.cow >= 50 || person.genealogy.dragonkin >= 50: #no need to make it bigger if they're already a hung race	
				bonus_penissize += 0
			else:	
				bonus_penissize += person.genealogy.demon/100
				
	#Monstrous
	#Dragonkin    
	#\n\nBreeding Note: The creation of new Dragonkin is the pinnacle of modern magic. Previously research subjects were only very rarely obtained, but now breeders on the cutting edge of racial husbandry within the guild are rushing to discover what potential might be manifest in Dragonkin hybrids. It is truly an exciting time to be a mage!
	if person.genealogy.dragonkin > 0:
		thisrace = 'Dragonkin'
		if person.genealogy.dragonkin >= 100:
			bonus_strength += 2
			bonus_agility += 1
			bonus_magic += 1
			bonus_courage += 10
			bonus_courage_racial += 1
			if person.traits.has('Ascetic'):
				person.trait_remove('Ascetic')
			else:
				person.add_trait('Spoiled')
			if person.sex in ['male']:
				bonus_height += 1
		elif person.genealogy.dragonkin >= 50 && person.race == thisrace:
			if person.genealogy.lamia >= 40: #Salamander
				hybridtype = 'Salamander'
				bonus_agility += 0.5
				bonus_magic += 2.5
				if person.tail == 'none':
					bonus_tail = 'dragon'
				if person.skin in ['pale', 'fair', 'none', 'green', 'teal']:
					bonus_skin = 'red'
			elif person.genealogy.demon >= 20 && (person.genealogy.demon + person.genealogy.dragonkin) >= 90: #Tiefling
				hybridtype = 'Tiefling'
				bonus_endurance -= 1
				bonus_charm += 15
				bonus_eyesclera = person.eyecolor
				person.skincov = 'none' #not reversible
				if person.skin in ['pale', 'fair', 'olive', 'tan', 'brown', 'dark', 'none']:
					bonus_skin = 'red'
				if person.tail == 'none':
					bonus_tail = 'dragon'
				if person.horns == 'none':
					bonus_horns = 'curved'
				if person.genealogy.demon < 35:
					bonus_strength += 1.5
					bonus_agility += 0.5
					bonus_magic -= 2
					if person.traits.has('Responsive'):
						person.trait_remove('Responsive')
					else:
						person.add_trait('Magic Deaf')
					if person.skin == 'red':
						bonus_wings = 'leather_red'
					else:
						bonus_wings = 'leather_black'
				else:
					bonus_agility += 0.5
					bonus_magic += 1.5
					person.wings = 'none' #not reversible
			elif water >= 0.4: #Sharkkin
				hybridtype = 'Sharkkin'
				bonus_strength += 1.5
				bonus_agility += 1.5
				bonus_magic -= 1
				bonus_titssize -= 1
				bonus_skincov = 'scales'
				person.wings = 'none' #not reversible
				person.horns = 'none' #non-reversible
				bonus_tail = 'fish'
				if person.eyesclera == 'normal':
					bonus_eyesclera = 'black'
				if person.skin in ['pale', 'fair', 'olive', 'tan', 'brown', 'dark', 'teal']:
					bonus_skin = 'gray'
			else:
				bonus_strength += person.genealogy.dragonkin/50
				bonus_agility += fire
				bonus_magic += (corruption - 0.75)*16 #range: -4 to 2
				bonus_endurance += (nature - 0.5)*4 - (corruption - 0.5)*8 	#min 1 - 3 = -2 ; max fairy or dryad -> .25*8 - (.375-.5)*8 = 1 + 1 = 2
				bonus_fertility += person.genealogy.harpy/2 #get on the egg train CHOOO CHOOOOOO!
				if person.sex in ['male']:
					bonus_height += person.genealogy.dragonkin/100
				else:
					bonus_strength -= 1
					bonus_agility += 1
				if corruption >= 0.75 && person.traits.has('Ascetic'):
					person.trait_remove('Ascetic')
				elif corruption >= 0.75:
					person.add_trait('Spoiled')					
		else:
			bonus_strength += person.genealogy.dragonkin/50
			bonus_courage += person.genealogy.dragonkin/10
			bonus_courage_racial += person.genealogy.dragonkin/100
			if person.sex in ['male']:
				bonus_height += person.genealogy.dragonkin/100
			if person.genealogy.dog >= 50 || person.genealogy.demon >= 50 || person.genealogy.horse >= 50 || person.genealogy.cow >= 50 || person.genealogy.orc >= 50: #no need to make it bigger if they're already a hung race
				bonus_penissize += 0
			else:	
				bonus_penissize += person.genealogy.dragonkin/75

	#Arachna
	#\n\nBreeding Note: Arachna have not displayed any synergies with other races to date and seem to make poor hybrids, but few breeders have had the opportunity to mate Arachna with more exotic species so more experimentation is needed.
	if person.genealogy.arachna > 0:
		thisrace = 'Arachna'
		if person.genealogy.arachna >= 100:
			bonus_strength += 1
			bonus_agility += 1
			bonus_magic += 1
			bonus_endurance += 1 #do you have any idea how much stamina it takes to build a complete spider web?   Well?   Huh?   Do ya?
			if person.sex != 'male':
				bonus_height += 1.4
			else:
				bonus_height -= 1.4
		elif person.genealogy.arachna >= 50 && person.race == thisrace:
			bonus_beauty -= person.genealogy.scylla/2.5 #Octovigor! not pretty babies though...
			bonus_fertility += person.genealogy.harpy/2 #get on the egg train CHOOO CHOOOOOO!
			if water >= 0.4: #Crabkin
				hybridtype = 'Crabkin'
				bonus_strength += 1.5
				bonus_endurance += 1.5
				bonus_courage += 10
				person.tail = 'none' #not reversible
				person.add_trait('Sturdy') #not reversible
				if person.sex in ['male']:
					bonus_height += (100 - person.genealogy.arachna)/50
				if person.skin in ['pale', 'fair', 'olive', 'tan', 'brown', 'dark', 'none']:
					bonus_skin = 'orange'
				#if person.skincov == 'none':
				#	bonus_skincov = 'scales'
			elif person.genealogy.fairy >= 40:
				hybridtype = 'Bee'
				bonus_magic += 1.5
				bonus_endurance += 0.5
				bonus_eyesclera = 'black'
				bonus_height -= 2
				person.add_trait('Clingy') #not reversible
				if person.sex != 'male':
					person.add_trait('Hard Worker') #not reversible
			#elif person.genealogy.lamia >= 40: #Centipede
			#	hybridtype = 'Centipede'
			#	bonus_agility += 2.5
			#	bonus_endurance += 2.5
			#	person.tail = 'none' #not reversible
			else: #50%gobo .27,1,2,1.24; harpy .4,3.5,0,0; fairy 2.3,.4,3,0; seraph 2.27,0,0,0
				bonus_strength += person.genealogy.arachna/77 - (corruption - 0.7)*5 #0.65 to 1.3  +  -1.05 to 1.95  fairy 2.6
				bonus_agility += (wind - 0.125)*5 + (corruption - 0.75)*4 #wind 0 to 1.875 corruption -1.5 to 0.5    fairy 
				bonus_magic += (nature - 0.5)*8 #- to 2
				bonus_endurance += person.genealogy.arachna/100 + (earth - 0.5)*5.9 #0.5 to 1   +   -1.475 to 1.475
				if person.sex in ['female']:
					bonus_height += person.genealogy.arachna/100
				if person.sex in ['male']:
					bonus_height -= person.genealogy.arachna/100
		else:
			bonus_strength += person.genealogy.arachna/100
			bonus_endurance += person.genealogy.arachna/100
			if person.sex != 'male':
				bonus_height += 1.4*person.genealogy.arachna/100
			else:
				bonus_height -= 1.4*person.genealogy.arachna/100
	
	#Lamia     
	#\n\nBreeding Note: Though little organized study of Lamia crossbreeding has occured, it has been confirmed that the species is compatable with humanoids. Some breeders speculate that several unique mutations of Lamia are the source of various folklore and myths regarding intelligent monsters whose common physical attribute is the single foot or tail as opposed to a bipedal hindquarters.
	if person.genealogy.lamia > 0:
		thisrace = 'Lamia'
		if person.genealogy.lamia >= 100:
			bonus_strength += 1
			bonus_agility += 1
			bonus_magic += 1
			bonus_endurance += 1
			bonus_confidence += 25
			bonus_confidence_racial += 2
			bonus_elasticity += 2
			bonus_pliability += 1
			bonus_vagsize -= 1
		elif person.genealogy.lamia >= 50 && person.race == thisrace:
			bonus_fertility += person.genealogy.harpy/2 #get on the egg train CHOOO CHOOOOOO!
			bonus_vagsize -= person.genealogy.lamia/100
			if person.genealogy.slime >= 20: #slug
				hybridtype = 'Slugkin'
				bonus_strength += 0.5
				bonus_endurance += 0.5
				bonus_wit -= 10
				person.add_trait('Soaker') #not reversible
				bonus_elasticity += 2
				bonus_pliability += 3
				bonus_asssize += 2
				bonus_titssize += 1
				person.skincov = 'none' #not reversible
				if !person.skin in ['blue', 'pale blue', 'green', 'pale', 'fair', 'tan', 'teal', 'jelly', 'purple', 'red', 'orange', 'yellow', 'none']:
					bonus_skin = 'jelly'
			elif person.genealogy.nereid >= 40: #merfolk - $He appears to be Merfolk, a subspecies of Lamia that differs from the legends in that it is actually as comfortable on land as in the sea, its tail fins providing surprisingly little impediment to serpentine terrestrial locomotion. 
				hybridtype = 'Merfolk'
				bonus_strength += 0.5
				bonus_magic += 2.5
				bonus_tail = 'fish'
			#elif person.genealogy.dark_elf >= 40: #Naga - $He appears to be a Naga, a reclusive cobra-hooded subterranian subspecies of Lamia of which little is known. 
				#hybridtype = 'Naga'
				#bonus_strength += 0.5
				#bonus_magic += 1.5
				#bonus_courage += 10
				#bonus_elasticity += person.genealogy.lamia/50
				#bonus_pliability += person.genealogy.lamia/100
				#bonus_skincov = 'scales'
			else:
				bonus_strength += fire*4 - (corruption - 0.5)*4 + person.genealogy.dragonkin/50 + person.genealogy.cat/100 + person.genealogy.dog/100 + person.genealogy.arachna/100
				bonus_agility += person.genealogy.lamia/100 - (corruption - 0.5)*4 + person.genealogy.harpy/50 + person.genealogy.cat/100 + person.genealogy.dog/100 + person.genealogy.fox/50
				bonus_magic += person.genealogy.lamia/100 + (water - 0.5)*4 + (nature -0.5)*4 + (corruption - 0.5)*8
				bonus_endurance += (earth - 0.25)*4 + person.genealogy.arachna/100
				bonus_confidence += person.genealogy.lamia/4
				bonus_confidence_racial += person.genealogy.lamia/50
				bonus_elasticity += person.genealogy.lamia/50
				bonus_pliability += person.genealogy.lamia/100
		else:
			bonus_strength += person.genealogy.lamia/100
			bonus_magic += person.genealogy.lamia/100
			bonus_confidence += person.genealogy.lamia/4
			bonus_confidence_racial += person.genealogy.lamia/50
			bonus_elasticity += person.genealogy.lamia/25
			bonus_pliability += person.genealogy.lamia/50
			bonus_vagsize -= person.genealogy.lamia/50

#Cat
	if person.genealogy.cat > 0:
		if person.genealogy.cat >= 100:
			bonus_strength += 2
			bonus_agility += 2
			bonus_charm += 15
			bonus_charm_racial += 1
			if person.sex in ['male', 'futanari']:
				bonus_catpenis = true
			if person.sex in ['female', 'futanari']:
				bonus_height -= 1		
		elif person.genealogy.cat >= 50 && person.race in ['Beastkin Cat', 'Halfkin Cat']:
			if person.sex in ['male', 'futanari']:
				bonus_catpenis = true
			if (person.genealogy.lamia + person.genealogy.dragonkin) >= 40: #Manticore - It should be noted that this hybrid is not to be confused with the rare monster of the same name.  In point of fact, the cat-lamia hybrid's tail is simply reptilian.
				hybridtype = 'Manticore'
				bonus_strength += 0.5
				bonus_agility += 1.5
				bonus_endurance += 0.5
				bonus_height += 1
				bonus_tail = 'dragon'
				bonus_catpenis = false
			elif corruption >= 0.52 && person.sex in ['female', 'futanari']: #Nekomata
				hybridtype = 'Nekomata'
				bonus_strength += 1.5
				bonus_agility += 1.5
				#person.add_trait('Nimble') #not reversible
			else:
				bonus_strength += person.genealogy.cat/100 + (corruption - 0.25)*4 	#50% 0.5 + 2.5 (+3.5gob; 0 fairy)
				bonus_agility += person.genealogy.cat/100 + wind*4 					#50% max wind-> 0.5 + 2.5 (+1gob; +2.5 fairy)
				bonus_endurance += (nature - 0.5)*8 - (corruption - 0.25)*4 		#50% 2 + 2.5 (-0.5gob; +2.5 fairy)
				bonus_charm += person.genealogy.cat/6.66
				bonus_charm_racial += person.genealogy.cat/100
		else:
			bonus_strength += person.genealogy.cat/100
			bonus_agility += person.genealogy.cat/100
			bonus_charm += person.genealogy.cat/6.66
			bonus_charm_racial += person.genealogy.cat/100
			if person.sex in ['female', 'futanari']:
				bonus_height -= person.genealogy.cat/100
	
	#Wolf
	if person.genealogy.dog > 0:
		if person.genealogy.dog >= 100:
			bonus_strength += 2
			bonus_agility += 1
			bonus_endurance += 1
			bonus_courage += 10
			bonus_courage_racial += 1
			if person.sex in ['male']:
				bonus_height += 1
				bonus_dogpenis = true
		elif person.genealogy.dog >= 50 && person.race in ['Beastkin Wolf', 'Halfkin Wolf']:
			bonus_strength += person.genealogy.dog/100 + fire*4
			bonus_agility += person.genealogy.dog/100 - (corruption - 0.25)*4
			bonus_endurance += (nature - 0.5)*4 + (corruption - 0.25)*4
			bonus_courage += person.genealogy.dog/10
			bonus_courage_racial += person.genealogy.dog/100
			if person.sex in ['male']:
				bonus_height += person.genealogy.dog/100
				bonus_dogpenis = true
			if corruption >= 0.6:
				hybridtype = 'Werewolf'
				bonus_strength += 0.5
				bonus_endurance += 0.5
				bonus_skincov = 'full_body_fur'
				if person.furcolor == 'none':
					bonus_furcolor = 'gray'
			elif person.genealogy.demon >= 40: #Hellhound - Lupus Infernus
				hybridtype = 'Infernus'
				bonus_strength += 1.45
				bonus_endurance += 0.5
				bonus_skincov = 'full_body_fur'
				bonus_furcolor = 'black'
				bonus_eyesclera = 'red'
			elif corruption < 0.2:
				hybridtype = 'Dog'
			else:
				if person.genealogy.orc >= 50 || person.genealogy.demon >= 50 || person.genealogy.horse >= 50 || person.genealogy.cow >= 50 || person.genealogy.dragonkin >= 50: #no need to make it bigger if they're already a hung race			
					bonus_penissize += 0
				else:	
					bonus_penissize += person.genealogy.dog/75
		else:
			bonus_strength += person.genealogy.dog/100
			bonus_agility += person.genealogy.dog/100
			bonus_courage += person.genealogy.dog/10
			bonus_courage_racial += person.genealogy.dog/100
			if person.genealogy.orc >= 50 || person.genealogy.demon >= 50 || person.genealogy.horse >= 50 || person.genealogy.cow >= 50 || person.genealogy.dragonkin >= 50: #no need to make it bigger if they're already a hung race			
				bonus_penissize += 0
			else:	
				bonus_penissize += person.genealogy.dog/75
				
	#Fox
	if person.genealogy.fox > 0:
		if person.genealogy.fox >= 100:
			bonus_agility += 2
			bonus_magic += 2
			bonus_beauty += 5
			bonus_wit += 20
			bonus_wit_racial += 2
			bonus_charm += 20
			bonus_charm_racial += 2
			bonus_dogpenis = true
		elif person.genealogy.fox >= 50 && person.race in ['Beastkin Fox', 'Halfkin Fox']:
			bonus_beauty += person.genealogy.fox/20
			bonus_wit += person.genealogy.fox/5
			bonus_charm += person.genealogy.fox/5
			bonus_wit_racial += person.genealogy.fox/50
			bonus_charm_racial += person.genealogy.fox/50
			if (person.genealogy.seraph >= 20 && person.genealogy.fox >= 70) || (fire >= 0.3 && wind >= 0.2): #Kitsune - $He appears to be a normal foxkin, but exhibits heightened magical aptitude and many claim that the shadows they cast have multiple tails.
				hybridtype = 'Kitsune'
				bonus_agility += 1.5
				bonus_magic += 2.5
				bonus_beauty += 5
			else:
				bonus_strength += (0.75 - nature)*7.9
				bonus_agility += person.genealogy.fox/50 + (nature - 0.5)*4
				bonus_magic += fire*4 + (nature - 0.75)*8 + abs(corruption - 0.25)*3.9 # 0.5 to 2.5 fromfire -3 to 1 fromnature; max1.5fromcorrupt
		else:
			bonus_agility += person.genealogy.fox/50
			bonus_beauty += person.genealogy.fox/20
			bonus_wit += person.genealogy.fox/5
			bonus_charm += person.genealogy.fox/5
			bonus_wit_racial += person.genealogy.fox/50
			bonus_charm_racial += person.genealogy.fox/50

	#Tanuki
	if person.genealogy.raccoon > 0: #Tanuki are generally compatible with any non-beast race that might be thought of as a guardian of the forest.
		if person.genealogy.raccoon >= 100:
			bonus_agility += 1
			bonus_magic += 2
			bonus_endurance += 1
			bonus_wit += 20
			bonus_wit_racial += 2
			bonus_ballssize += 3
		elif person.genealogy.raccoon >= 50 && person.race in ['Beastkin Tanuki', 'Halfkin Tanuki']:
			if corruption >= 0.6:
				hybridtype = 'Werebear'
				bonus_strength += 1.5
				bonus_endurance += 2.5
				bonus_skincov = 'full_body_fur'
				if person.furcolor == 'none':
					bonus_furcolor = 'brown'
				bonus_height += 3
				bonus_ballssize += person.genealogy.raccoon/33
			else:
				var forestprotector = (person.genealogy.elf + person.genealogy.tribal_elf + person.genealogy.fox/2)/100
				bonus_strength += forestprotector*(1 + nature)
				bonus_agility += wind*4
				bonus_magic += person.genealogy.raccoon/50 + forestprotector*(1 + nature)*2 - (corruption - 0.25)*4
				bonus_endurance += forestprotector*(1 + nature) + (corruption - 0.25)*4
				bonus_wit += person.genealogy.raccoon/5
				bonus_wit_racial += person.genealogy.raccoon/50
				bonus_ballssize += person.genealogy.raccoon/33
		else:
			bonus_magic += person.genealogy.raccoon/50
			bonus_wit += person.genealogy.raccoon/5
			bonus_wit_racial += person.genealogy.raccoon/50
			bonus_ballssize += person.genealogy.raccoon/20
	
	#Centaur
	#\n\nBreeding Note: Centaur make poor spellcasters, but are potent as warriors. While they are commonly used as the minority race in hybrids to enhance various male attributes, Centaur dominant hybrids exhibit few synergies with other races aside from Taurus which serve to enhance the endurance of the offspring.
	if person.genealogy.horse > 0:
		thisrace = 'Centaur'
		if person.genealogy.horse >= 100:
			bonus_strength += 1
			bonus_agility += 1
			bonus_endurance += 2
			bonus_courage += 20
			bonus_courage_racial += 2
			bonus_penissize += 1
			bonus_ballssize += 1
			bonus_vagsize += 2
			bonus_asssize += 1
			if person.sex in ['male']:
				bonus_height += 1
				bonus_horsepenis = true
		elif person.genealogy.horse >= 50 && person.race == thisrace:
			bonus_courage += person.genealogy.horse/5
			bonus_courage_racial += person.genealogy.horse/50
			bonus_penissize += person.genealogy.horse/100
			bonus_ballssize += person.genealogy.horse/100
			bonus_vagsize += person.genealogy.horse/50
			bonus_asssize += person.genealogy.horse/150
			if person.sex in ['male']:
				bonus_height += person.genealogy.horse/100
				bonus_horsepenis = true
			if water >= 0.4 && person.sex in ['male']: #Kelpie
				hybridtype = 'Kelpie'
				bonus_strength += 0.5
				bonus_agility += 0.5
				bonus_magic += 1.5
				bonus_endurance += 0.5
				person.skincov = 'none' #not reversible
				if !person.tail in ['fish', 'horse']:
					bonus_tail = 'horse'
				if !person.skin in ['blue', 'pale blue', 'green', 'brown', 'teal', 'jelly', 'purple']:
					bonus_skin = 'black'
			elif corruption >= 0.7:
				hybridtype = 'Bicorn'
				bonus_strength += 1.5
				bonus_agility += 0.5
				bonus_endurance += 1.5
				bonus_horns = 'curved'
			elif corruption < 0.3:
				hybridtype = 'Pegasus'
				bonus_agility += 1.5
				bonus_magic += 2.5
				if person.skin in ['black', 'dark']:
					bonus_wings = 'feathered_black'
				elif person.skin in ['brown', 'tan', 'olive']:
					bonus_wings = 'feathered_brown'
				else:
					bonus_wings = 'feathered_white'
			else:
				var shortstackraces = person.genealogy.goblin + person.genealogy.gnome + person.genealogy.fairy
				bonus_strength += earth*4 + (corruption - 0.5)*4 + (nature - 0.5)*(person.genealogy.orc + person.genealogy.arachna + person.genealogy.dragonkin)/12.5
				bonus_agility += person.genealogy.horse/100 + (nature - 0.5)*(person.genealogy.elf + person.genealogy.tribal_elf + person.genealogy.scylla + person.genealogy.cat/2 + person.genealogy.dog/2 + person.genealogy.fox/2 + person.genealogy.bunny/2 + + person.genealogy.raccoon/4)/12.5
				bonus_magic += (0.5 - corruption)*12
				bonus_endurance += person.genealogy.horse/100 + (corruption - 0.5)*4 + (nature - 0.5)*(person.genealogy.orc + person.genealogy.arachna + person.genealogy.cow)/12.5
				bonus_strength -= shortstackraces/50
				bonus_agility -= shortstackraces/50
				bonus_endurance -= shortstackraces/50
		else:
			bonus_agility += person.genealogy.horse/100
			bonus_endurance += person.genealogy.horse/100
			bonus_courage += person.genealogy.horse/5
			bonus_courage_racial += person.genealogy.horse/50
			bonus_ballssize += person.genealogy.horse/50
			bonus_vagsize += person.genealogy.horse/100
			bonus_asssize += person.genealogy.horse/150
			if person.genealogy.dog >= 50 || person.genealogy.demon >= 50 || person.genealogy.orc >= 50 || person.genealogy.cow >= 50 || person.genealogy.dragonkin >= 50: #no need to make it bigger if they're already a hung race
				bonus_penissize += 0
			else:	
				bonus_penissize += person.genealogy.horse/34
				
	#Taurus    
	if person.genealogy.cow > 0:
		thisrace = 'Taurus'
		if person.genealogy.cow >= 100:
			bonus_strength += 2
			bonus_agility += 1
			bonus_endurance += 1
			bonus_fertility += 20
			bonus_titssize += 2
			bonus_ballssize += 1
			if person.sex in ['male']:
				bonus_height += 1
			else:
				bonus_asssize += person.genealogy.cow/100
		elif person.genealogy.cow >= 50 && person.race == thisrace:
			bonus_strength += person.genealogy.cow/100 + earth*.25
			bonus_endurance += person.genealogy.cow/100 + (nature - 0.25)*4
			bonus_fertility += person.genealogy.cow/5
			bonus_titssize += person.genealogy.cow/80
			bonus_ballssize += person.genealogy.cow/100
			bonus_asssize += person.genealogy.cow/100
			if person.sex in ['male']:
				bonus_height += person.genealogy.cow/150
				if person.genealogy.horse >= 25:
					bonus_horsepenis = true
			if person.genealogy.horse >= 15 && person.genealogy.orc >= 15: #minotaur
				hybridtype = 'Minotaur'
				bonus_strength += (person.genealogy.horse + person.genealogy.orc)/50
				bonus_endurance += (person.genealogy.horse + person.genealogy.orc)/50
				bonus_skincov = 'full_body_fur'				
				if person.sex in ['male']:
					bonus_horsepenis = true
					bonus_penissize += person.genealogy.horse/20 + person.genealogy.orc/30
					bonus_ballssize += person.genealogy.cow/100 + person.genealogy.horse/100
					bonus_height += person.genealogy.horse*person.genealogy.orc/250
				else:
					bonus_height += person.genealogy.horse*person.genealogy.orc/500
				if (person.genealogy.orc - person.genealogy.horse) > 10:
					bonus_furcolor = 'green'
				elif (person.genealogy.horse - person.genealogy.orc) > 10:
					bonus_furcolor = 'white'
				elif (person.genealogy.orc - person.genealogy.horse) > 5:
					bonus_furcolor = 'black'
				elif (person.genealogy.horse - person.genealogy.orc) > 5:
					bonus_furcolor = 'gray'
				else:
					bonus_furcolor = 'brown'
			#elif person.sex != 'male' && ????? #juggernaut
			#	hybridtype = 'Juggernaut'
			#	bonus_titssize += ????
			else: #predator vs prey genealogy determines aggressive potential vs docile sturdiness
				var _predatorstrength = abs(corruption - 0.5)*16
				var _preystrength = abs(corruption - 0.5)*8
				if corruption > 0.5:
					var _temp = _predatorstrength
					_predatorstrength = _preystrength
					_preystrength = _temp
				bonus_strength += _predatorstrength*(person.genealogy.cat/100 + person.genealogy.dog/100 + person.genealogy.fox/100 + person.genealogy.arachna/100 + person.genealogy.lamia/100 + person.genealogy.harpy/100 + person.genealogy.dragonkin/100) - _preystrength*(person.genealogy.bunny/100 + person.genealogy.horse/100)
				bonus_endurance += _predatorstrength*(person.genealogy.bunny/100 + person.genealogy.horse/100) - _preystrength*(person.genealogy.cat/100 + person.genealogy.dog/100 + person.genealogy.fox/100 + person.genealogy.arachna/100 + person.genealogy.lamia/100 + person.genealogy.harpy/100 + person.genealogy.dragonkin/100)
		else:
			bonus_strength += person.genealogy.cow/100
			bonus_endurance += person.genealogy.cow/100
			bonus_fertility += person.genealogy.cow/5
			bonus_ballssize += person.genealogy.cow/50
			bonus_asssize += person.genealogy.cow/100
			if person.genealogy.seraph >= 50 || person.genealogy.demon >= 50 || person.genealogy.horse >= 50 || person.genealogy.cow >= 50 || person.genealogy.orc >= 50: #no need to make it bigger if they're already a hung race
				bonus_titssize += 0
			else:	
				bonus_titssize += person.genealogy.cow/40
			if person.genealogy.dog >= 50 || person.genealogy.demon >= 50 || person.genealogy.horse >= 50 || person.genealogy.orc >= 50 || person.genealogy.dragonkin >= 50: #no need to make it bigger if they're already a hung race
				bonus_penissize += 0
			else:	
				bonus_penissize += person.genealogy.cow/50

	#Slime     
	if person.genealogy.slime > 0:
		thisrace = 'Slime'
		if person.genealogy.slime >= 100:
			bonus_strength += 1
			bonus_agility += 1
			bonus_magic += 1
			bonus_endurance += 1
			bonus_elasticity += 3
			bonus_pliability += 2
			bonus_vagsize -= 1
			person.add_trait('Soaker') #not reversible
		elif person.genealogy.slime >= 50 && person.race == thisrace: #needs rework if slimes become able to interbreed with other races - for now, never used
			bonus_strength += person.genealogy.slime/100
			bonus_agility += person.genealogy.scylla/100 + person.genealogy.horse/100 + person.genealogy.arachna/100
			bonus_magic += person.genealogy.slime/100 + person.genealogy.nereid/100
			bonus_endurance += person.genealogy.slime/100 + person.genealogy.nereid/100 + person.genealogy.scylla/100
			bonus_elasticity += person.genealogy.slime/33
			bonus_pliability += person.genealogy.slime/50
			bonus_ballssize += bonus_ballssize
			bonus_vagsize -= person.genealogy.slime/100
			person.add_trait('Soaker') #not reversible
			if person.genealogy.cat >= 25:
				bonus_catpenis = true
			if (person.genealogy.dog + person.genealogy.fox) >= 25:
				bonus_dogpenis = true
			if (person.genealogy.horse + person.genealogy.cow) >= 25:
				bonus_horsepenis = true		
		else: #needs rework if slimes become able to interbreed with other races - for now, never used
			bonus_strength += person.genealogy.slime/100
			bonus_magic += person.genealogy.slime/100
			bonus_endurance += person.genealogy.slime/100
			bonus_elasticity += person.genealogy.slime/25
			bonus_pliability += person.genealogy.slime/25
			if person.genealogy.slime >= 35:
				person.add_trait('Soaker') #not reversible
				bonus_ballssize += bonus_ballssize
				
	#Bunny     #max stats 3533 14 W11/14 M7/8.5	#Bunnies are lovers, not fighters.  The only attribute they excel in is their agility which they only use for two things: running and... well you can probably guess; however bunnies and rabbit dominant hybrids in particular remain extremely popular as they often exhibit exaggerated sexual characteristics depending on what they've been bred with of course.
	if person.genealogy.bunny > 0:
		if person.genealogy.bunny >= 100:
			bonus_agility += 2
			bonus_endurance += 2
			bonus_fertility += 50
			bonus_courage -= 10
			bonus_courage_racial -= 1
			bonus_ballssize += 1
			bonus_pliability += 1
			bonus_lewdness += 25
		elif person.genealogy.bunny >= 50 && person.race in ['Beastkin Bunny', 'Halfkin Bunny']:
			bonus_strength += (nature + 0.25)*bonus_strength
			bonus_agility += person.genealogy.bunny/50 + (nature + 0.25)*bonus_agility #50% max 1 + 1+1 = 3 Agil++race
			bonus_magic += (nature + 0.25)*bonus_magic
			bonus_endurance += (earth - 0.25)*4 + (nature + 0.25)*bonus_endurance #50% max 2 + 1+1 = 4 gnome
			bonus_beauty += bonus_beauty
			bonus_fertility += person.genealogy.bunny/2 + (corruption - 0.25)*bonus_fertility
			bonus_courage -= person.genealogy.bunny/10
			bonus_courage_racial -= person.genealogy.bunny/100
			bonus_ballssize += (corruption - 0.25)*bonus_ballssize + person.genealogy.bunny/100
			bonus_titssize += (corruption - 0.25)*bonus_titssize
			bonus_penissize += (corruption - 0.25)*bonus_penissize
			bonus_asssize += (corruption - 0.25)*bonus_asssize
			bonus_elasticity += (corruption - 0.25)*bonus_elasticity
			bonus_pliability += (corruption - 0.25)*bonus_pliability + person.genealogy.bunny/100
			bonus_lewdness += (corruption - 0.25)*bonus_lewdness + person.genealogy.bunny/4
		else:
			bonus_agility += person.genealogy.bunny/50
			bonus_fertility += person.genealogy.bunny/2
			bonus_courage -= person.genealogy.bunny/10
			bonus_courage_racial -= person.genealogy.bunny/100
			bonus_ballssize += person.genealogy.bunny/50
			bonus_pliability += person.genealogy.bunny/50
			bonus_lewdness += person.genealogy.bunny/4

	#-- NEW RACES
	#Ogres
	#\n\nBreeding Note: 
	#\n\nBreeding Note: 
	if person.genealogy.ogre > 0:
		thisrace = 'Ogre'
		if person.genealogy.ogre >= 100:
			bonus_strength += 2
			bonus_endurance += 2
			bonus_wit -= 10
			bonus_wit_racial -= 1
			bonus_beauty -= 10
			if person.sex in ['male']:
				bonus_penissize += 2
				bonus_ballssize += 2
			else:
				bonus_vagsize += 1
				bonus_titssize += 1
			bonus_height += 2
		elif person.genealogy.ogre >= 50 && person.race == thisrace:
			bonus_strength += person.genealogy.ogre/50
			bonus_endurance += person.genealogy.ogre/50
			bonus_wit -= person.genealogy.ogre/10
			bonus_wit_racial -= person.genealogy.ogre/100
			bonus_beauty -= person.genealogy.ogre/10
			if person.sex in ['male']:
				bonus_penissize += person.genealogy.ogre/50
				bonus_ballssize += person.genealogy.ogre/50
			else:
				bonus_vagsize += person.genealogy.ogre/100
				bonus_titssize += person.genealogy.ogre/100
			bonus_height += person.genealogy.ogre/50
		else:
			bonus_strength += person.genealogy.ogre/50
			bonus_endurance += person.genealogy.ogre/100
			bonus_wit -= person.genealogy.ogre/10
			bonus_wit_racial -= person.genealogy.ogre/50
			bonus_beauty -= person.genealogy.ogre/10
			if person.sex in ['male']:
				bonus_penissize += person.genealogy.ogre/50
				bonus_ballssize += person.genealogy.ogre/50
			else:
				bonus_vagsize += person.genealogy.ogre/100
				bonus_titssize += person.genealogy.ogre/100
			bonus_height += person.genealogy.ogre/50
			
	#Giants
	#\n\nBreeding Note: 
	#\n\nBreeding Note: 
	if person.genealogy.giant > 0:
		thisrace = 'Giant'
		if person.genealogy.giant >= 100:
			bonus_strength += 3
			bonus_endurance += 2
			bonus_courage += 20
			bonus_courage_racial += 2
			if person.sex in ['male']:
				bonus_penissize += 4
				bonus_ballssize += 4
			else:
				bonus_vagsize += 3
				bonus_titssize += 3
			bonus_height += 4
		elif person.genealogy.giant >= 50 && person.race == thisrace:
			bonus_strength += person.genealogy.giant/33
			bonus_endurance += person.genealogy.giant/50
			bonus_courage += person.genealogy.giant/5
			bonus_courage_racial += person.genealogy.giant/50
			if person.sex in ['male']:
				bonus_penissize += person.genealogy.giant/25
				bonus_ballssize += person.genealogy.giant/25
			else:
				bonus_vagsize += person.genealogy.giant/33
				bonus_titssize += person.genealogy.giant/33
			bonus_height += person.genealogy.giant/25
		else:
			bonus_strength += person.genealogy.giant/50
			bonus_endurance += person.genealogy.giant/100
			bonus_courage += person.genealogy.giant/10
			if person.sex in ['male']:
				bonus_penissize += person.genealogy.giant/33
				bonus_ballssize += person.genealogy.giant/33
			else:
				bonus_vagsize += person.genealogy.giant/50
				bonus_titssize += person.genealogy.giant/50
			bonus_height += person.genealogy.giant/33

	#Kobold - Capitulize
	#\n\nBreeding Note: 
	#
	if person.genealogy.kobold > 0:
		thisrace = 'Kobold'
		if person.genealogy.kobold >= 100:
			bonus_skin = 'none'
			bonus_strength += 1
			bonus_agility += 2
			bonus_magic += 1
			bonus_fertility += 33
			bonus_titssize -= 1 
			bonus_penissize -= 1
			bonus_lewdness += 10
			bonus_confidence -= 10
			bonus_confidence_racial -= 1
			bonus_charm += 10
			bonus_charm_racial += 1
			if person.sex in ['male', 'futanari']:
				bonus_lizardpenis = true
		elif person.genealogy.kobold >= 50 && person.race == thisrace:
			bonus_skin = 'none'
			bonus_titssize -= person.genealogy.kobold/50 
			bonus_lewdness += person.genealogy.kobold/10
			bonus_penissize -= person.genealogy.kobold/100
			bonus_confidence -= person.genealogy.kobold/10
			bonus_confidence_racial -= person.genealogy.kobold/100
			bonus_charm += person.genealogy.kobold/10
			bonus_charm_racial += person.genealogy.kobold/100
			bonus_fertility += nature*33
			bonus_fertility += person.genealogy.harpy/2 #get on the egg train CHOOO CHOOOOOO!
			bonus_endurance += earth*3
			bonus_strength += fire*3 + person.genealogy.kobold/100
			bonus_agility += wind*3 + person.genealogy.kobold/50
			bonus_magic += water*3 + person.genealogy.kobold/100
		else:
			bonus_agility += person.genealogy.kobold/50
			bonus_magic += person.genealogy.kobold/100
			bonus_titssize -= person.genealogy.kobold/50 
			bonus_penissize -= person.genealogy.kobold/100
			bonus_height -= person.genealogy.kobold/25
			bonus_confidence -= person.genealogy.kobold/10
			bonus_confidence_racial -= person.genealogy.kobold/100
			bonus_charm += person.genealogy.kobold/10
			bonus_charm_racial += person.genealogy.kobold/100
			bonus_fertility += nature*33
			
	#Lizardfolk - Capitulize
	if person.genealogy.lizardfolk > 0:
		thisrace = 'Lizardfolk'
		if person.genealogy.lizardfolk >= 100:
			bonus_strength += 1
			bonus_agility += 1
			bonus_endurance += 2
			bonus_courage += 10
			bonus_courage_racial += 1
			if person.sex in ['male', 'futanari']:
				bonus_height += 1
				bonus_strength += 1
			if person.sex in ['female']:
				bonus_magic += 1
		elif person.genealogy.lizardfolk >= 50 && person.race == thisrace:
			bonus_strength += person.genealogy.lizardfolk/100
			bonus_endurance += person.genealogy.lizardfolk/50
			bonus_fertility += person.genealogy.harpy/2 #get on the egg train CHOOO CHOOOOOO!
			if person.sex in ['male', 'futanari']:
				bonus_height += person.genealogy.lizardfolk/100
				bonus_strength += person.genealogy.lizardfolk/100
			if person.sex in ['female']:
				bonus_magic += person.genealogy.lizardfolk/100
		else:
			bonus_strength += person.genealogy.lizardfolk/100
			bonus_endurance += person.genealogy.lizardfolk/50
			bonus_agility += person.genealogy.lizardfolk/100
			if person.sex in ['female']:
				bonus_magic += person.genealogy.lizardfolk/100
				
	#Mouse - Capitulize
	if person.genealogy.mouse > 0:
		if person.genealogy.mouse >= 100:
			bonus_magic += 2
			bonus_agility += 2
			bonus_wit += 20
			bonus_wit_racial += 2
			bonus_courage -= 10
			bonus_courage_racial -= 1
			if person.sex in ['male', 'futanari']:
				bonus_penissize -= 1
		elif person.genealogy.mouse >= 50 && person.race in ['Beastkin Mouse', 'Halfkin Mouse']:
			bonus_wit += person.genealogy.mouse/5
			bonus_wit_racial += person.genealogy.mouse/50
			bonus_courage -= person.genealogy.mouse/10
			bonus_courage_racial -= person.genealogy.mouse/100
			if person.sex in ['male', 'futanari']:
				bonus_penissize -= person.genealogy.mouse/100
			#Guardian Spirit
			if nature >= 0.6:
				hybridtype = 'Guardian Spirit'
				person.add_trait("Sturdy")
				person.trait_remove("Frail")
				bonus_endurance += 4
				bonus_endurance_max += 4
				bonus_skincov = 'full_body_fur'
				bonus_furcolor = 'guardian white'
				bonus_ears = 'long_pointy_furry'
			bonus_magic += person.genealogy.mouse/50
			bonus_agility += person.genealogy.mouse/50
			bonus_wit += person.genealogy.mouse/5
			bonus_wit_racial += person.genealogy.mouse/50
			bonus_courage -= person.genealogy.mouse/10
			bonus_courage_racial -= person.genealogy.mouse/100
			bonus_penissize -= person.genealogy.mouse/100
		else:
			bonus_magic += person.genealogy.mouse/50
			bonus_agility += person.genealogy.mouse/50
			bonus_wit += person.genealogy.mouse/5
			bonus_wit_racial += person.genealogy.mouse/50
			bonus_courage -= person.genealogy.mouse/10
			bonus_courage_racial -= person.genealogy.mouse/100
			bonus_penissize -= person.genealogy.mouse/100

	#Squirrel - Capitulize, gotta set these up more
	if person.genealogy.squirrel > 0: #
		if person.genealogy.squirrel >= 100:
			bonus_strength += 1
			bonus_agility += 2
			bonus_endurance += 1
			bonus_confidence -= 10
			bonus_confidence_racial -= 1
			bonus_charm += 10
			bonus_charm_racial += 1
			if person.sex in ['male', 'futanari']:
				bonus_penissize -= 1
		elif person.genealogy.squirrel >= 50 && person.race in ['Beastkin Squirrel', 'Halfkin Squirrel']:
			bonus_strength += person.genealogy.squirrel/100
			bonus_agility += person.genealogy.squirrel/50
			bonus_endurance += person.genealogy.squirrel/100
			bonus_confidence -= person.genealogy.squirrel/10
			bonus_confidence_racial -= person.genealogy.squirrel/100
			bonus_charm += person.genealogy.squirrel/10
			bonus_charm_racial += person.genealogy.squirrel/100
			if person.sex in ['male', 'futanari']:
				bonus_penissize -= person.genealogy.squirrel/100
		else:
			bonus_strength += person.genealogy.squirrel/100
			bonus_agility += person.genealogy.squirrel/50
			bonus_endurance += person.genealogy.squirrel/100
			bonus_confidence -= person.genealogy.squirrel/10
			bonus_confidence_racial -= person.genealogy.squirrel/100
			bonus_charm += person.genealogy.squirrel/10
			bonus_charm_racial += person.genealogy.squirrel/100

	#Otter - Capitulize, gotta set these up more
	if person.genealogy.otter > 0: #
		if person.genealogy.otter >= 100:
			bonus_endurance += 2
			bonus_confidence += 10
			bonus_courage += 10
			bonus_confidence_racial += 1
			bonus_courage_racial += 1
		elif person.genealogy.otter >= 50 && person.race in ['Beastkin Otter', 'Halfkin Otter']:
			bonus_endurance += person.genealogy.otter/50
			bonus_confidence_racial += person.genealogy.otter/100
			bonus_courage_racial += person.genealogy.otter/100
		else:
			bonus_endurance += person.genealogy.otter/50
			bonus_confidence += person.genealogy.otter/10
			bonus_courage += person.genealogy.otter/10
			bonus_confidence_racial += person.genealogy.otter/100
			bonus_courage_racial += person.genealogy.otter/100


	#Bird - Capitulize, gotta set these up more
	if person.genealogy.bird > 0: #
		if person.genealogy.bird >= 100:
			bonus_agility += 2
			bonus_endurance += 2
			bonus_confidence += 10
			bonus_confidence_racial += 1
		elif person.genealogy.bird >= 50 && person.race in ['Beastkin Bird', 'Halfkin Bird']:
			bonus_agility += person.genealogy.bird/50
			bonus_endurance += person.genealogy.bird/50
			bonus_confidence += person.genealogy.bird/10
			bonus_confidence_racial += person.genealogy.bird/100
		else:
			bonus_agility += person.genealogy.bird/50
			bonus_endurance += person.genealogy.bird/50

	#Gnoll - Capitulize, gotta set these up more
	if person.genealogy.hyena > 0: #
		if person.genealogy.hyena >= 100:
			bonus_strength += 2
			bonus_endurance += 1
			bonus_agility += 1
			bonus_confidence += 10
			bonus_confidence_racial += 1
			bonus_courage += 10
			bonus_courage_racial = 1
			if person.sex in ['male', 'futanari']:
				bonus_penissize += 1
			else:
				bonus_titssize += 1
		elif person.genealogy.hyena >= 50 && person.race in ['Gnoll']:
			bonus_strength += person.genealogy.hyena/50
		else:
			bonus_strength += person.genealogy.hyena/50

	#Avali - Capitulize, gotta set these up more
	if person.genealogy.avali > 0: #
		if person.genealogy.avali >= 100:
			bonus_magic += 2
			bonus_agility += 2
			bonus_wit += 20
			bonus_wit_racial += 2
			if person.sex in ['male', 'futanari']:
				bonus_penissize -= 1
		elif person.genealogy.avali >= 50 && person.race in ['Avali', 'Avali']:
			bonus_magic += person.genealogy.avali/50
			bonus_agility += person.genealogy.avali/50
			bonus_wit += person.genealogy.avali/5
			bonus_wit_racial += person.genealogy.avali/50
			if person.sex in ['male', 'futanari']:
				bonus_birdpenis = true
		else:
			bonus_magic += person.genealogy.avali/50
			bonus_agility += person.genealogy.avali/50

	
	if person.sex == 'male': #little boys born with big asses... workaround
		person.asssize = globals.asssizearray[clamp(globals.asssizearray.find(person.asssize) - 1, 0, globals.asssizearray.size()-1)]
	var somethingchanged = false
	if addstats == true:
		if bonus_strength != 0:
			person.stats.str_mod += round(bonus_strength)
			somethingchanged = true
		if bonus_agility != 0:
			person.stats.agi_mod += round(bonus_agility)
			somethingchanged = true
		if bonus_magic != 0:
			person.stats.maf_mod += round(bonus_magic)
			somethingchanged = true
		if bonus_endurance != 0:
			person.stats.end_mod += round(bonus_endurance)
			somethingchanged = true
		if bonus_strength_max != 0:
			person.stats.str_max += round(bonus_strength_max)
			somethingchanged = true
		if bonus_agility_max != 0:
			person.stats.agi_max += round(bonus_agility_max)
			somethingchanged = true
		if bonus_magic_max != 0:
			person.stats.maf_max += round(bonus_magic_max)
			somethingchanged = true
		if bonus_endurance_max != 0:
			person.stats.end_max += round(bonus_endurance_max)
			somethingchanged = true
		if bonus_courage != 0:
			person.stats.cour_racial += round(bonus_courage)
			somethingchanged = true
		if bonus_confidence != 0:
			person.stats.conf_racial += round(bonus_confidence)
			somethingchanged = true
		if bonus_wit != 0:
			person.stats.wit_racial += round(bonus_wit)
			somethingchanged = true
		if bonus_charm != 0:
			person.stats.charm_racial += round(bonus_charm)
			somethingchanged = true
		if bonus_courage_racial != 0:
			person.stats.cour_racial += round(bonus_courage_racial)
			somethingchanged = true
		if bonus_confidence_racial != 0:
			person.stats.conf_racial += round(bonus_confidence_racial)
			somethingchanged = true
		if bonus_wit_racial != 0:
			person.stats.wit_racial += round(bonus_wit_racial)
			somethingchanged = true
		if bonus_charm_racial != 0:
			person.stats.charm_racial += round(bonus_charm_racial)
			somethingchanged = true
		if bonus_beauty != 0:
			person.beautybase += round(bonus_beauty)
			somethingchanged = true
		if bonus_fertility != 0:
			person.preg.bonus_fertility += round(bonus_fertility)
			somethingchanged = true
		if bonus_titssize != 0 && person.unique == null && person.sex in ['female', 'futanari']:
			person.titssize = globals.titssizearray[clamp(globals.titssizearray.find(person.titssize) + round(bonus_titssize), 0, globals.titssizearray.size()-1)]
			somethingchanged = true
		if bonus_penissize != 0 && person.unique == null && person.sex in ['male', 'futanari']:
			person.penis = globals.penissizearray[clamp(globals.penissizearray.find(person.penis) + round(bonus_penissize), 0, globals.penissizearray.size()-1)]
			somethingchanged = true
		if bonus_ballssize != 0 && person.unique == null && (person.sex in ['male'] || (person.sex in ['futanari'] && globals.rules.futaballs == true)):
			person.balls = globals.penissizearray[clamp(globals.penissizearray.find(person.balls) + round(bonus_ballssize), 0, globals.penissizearray.size()-1)]
			somethingchanged = true	
		if bonus_vagsize != 0 && person.unique == null && person.sex in ['female', 'futanari']:
			person.vagina = globals.vagsizearray[clamp(globals.vagsizearray.find(person.vagina) + round(bonus_vagsize), 0, globals.vagsizearray.size()-1)]
			somethingchanged = true	
		if bonus_height != 0 && person.unique == null:
			person.height = globals.heightarray[clamp(globals.heightarray.find(person.height) + round(bonus_height), 0, globals.heightarray.size()-1)]
			somethingchanged = true
		if bonus_asssize != 0 && person.unique == null && person.sex in ['female', 'futanari']:
			person.asssize = globals.asssizearray[clamp(globals.asssizearray.find(person.asssize) + round(bonus_asssize), 0, globals.asssizearray.size()-1)]
			somethingchanged = true
		if person.unique == null && person.sex in ['male', 'futanari']:
			if bonus_catpenis:
				person.penistype = 'feline'
				somethingchanged = true
			if bonus_dogpenis:
				person.penistype = 'canine'
				somethingchanged = true
			if bonus_horsepenis:
				person.penistype = 'equine'
				somethingchanged = true
			if bonus_lizardpenis:
				person.penistype = 'reptilian'
				somethingchanged = true
			if bonus_rodentpenis:
				person.penistype = 'rodent'
				somethingchanged = true
			if bonus_birdpenis:
				person.penistype = 'bird'
				somethingchanged = true
		if bonus_skincov != 'none' && person.unique == null:
			person.skincov = bonus_skincov
			somethingchanged = true
		if bonus_skin != 'fair' && person.unique == null:
			person.skin = bonus_skin
			somethingchanged = true
		if bonus_ears != 'human' && person.unique == null:
			person.ears = bonus_ears
			somethingchanged = true
		if bonus_eyesclera != 'normal' && person.unique == null:
			person.eyesclera = bonus_eyesclera
			somethingchanged = true
		if bonus_horns != 'none' && person.unique == null:
			person.horns = bonus_horns
			somethingchanged = true
		if bonus_tail != 'none' && person.unique == null:
			person.tail = bonus_tail
			somethingchanged = true
		if bonus_wings != 'none' && person.unique == null:
			person.wings = bonus_wings
			somethingchanged = true
		if bonus_furcolor != 'none' && person.unique == null:
			person.furcolor = bonus_furcolor
			somethingchanged = true
		if bonus_scalecolor != 'none' && person.unique == null:
			person.scalecolor = bonus_scalecolor
			somethingchanged = true
		if bonus_eyecolor != 'none' && person.unique == null:
			person.eyecolor = bonus_eyecolor
			somethingchanged = true
		if bonus_bodyshape != 'humanoid' && person.unique == null:
			person.bodyshape = bonus_bodyshape
			somethingchanged = true
		if bonus_lewdness != 0 && person.unique == null:
			person.lewdness += round(bonus_lewdness)
			somethingchanged = true
		if bonus_pliability != 0:
			person.sexexpanded.pliability += bonus_pliability
			somethingchanged = true
		if bonus_elasticity != 0:
			person.sexexpanded.elasticity += bonus_elasticity
			somethingchanged = true		
		if hybridtype != "":
			person.race_display = hybridtype
			somethingchanged = true
			
		if somethingchanged == true:
			person.npcexpanded.racialbonusesapplied = true
	else:
		if bonus_strength != 0:
			person.stats.str_mod -= round(bonus_strength)
			somethingchanged = true
		if bonus_agility != 0:
			person.stats.agi_mod -= round(bonus_agility)
			somethingchanged = true
		if bonus_magic != 0:
			person.stats.maf_mod -= round(bonus_magic)
			somethingchanged = true
		if bonus_endurance != 0:
			person.stats.end_mod -= round(bonus_endurance)
			somethingchanged = true
		if bonus_strength_max != 0: # Capitulize
			person.stats.str_max -= round(bonus_strength_max)
			somethingchanged = true
		if bonus_agility_max != 0:
			person.stats.agi_max -= round(bonus_agility_max)
			somethingchanged = true
		if bonus_magic_max != 0:
			person.stats.maf_max -= round(bonus_magic_max)
			somethingchanged = true
		if bonus_endurance_max != 0:
			person.stats.end_max -= round(bonus_endurance_max)
			somethingchanged = true # /Capitulize
		if bonus_courage != 0:
			person.stats.cour_racial -= round(bonus_courage)
			somethingchanged = true
		if bonus_confidence != 0:
			person.stats.conf_racial -= round(bonus_confidence)
			somethingchanged = true
		if bonus_wit != 0:
			person.stats.wit_racial -= round(bonus_wit)
			somethingchanged = true
		if bonus_charm != 0:
			person.stats.charm_racial -= round(bonus_charm)
			somethingchanged = true
		if bonus_courage_racial != 0:
			person.stats.cour_racial -= round(bonus_courage_racial)
			somethingchanged = true
		if bonus_confidence_racial != 0:
			person.stats.conf_racial -= round(bonus_confidence_racial)
			somethingchanged = true
		if bonus_wit_racial != 0:
			person.stats.wit_racial -= round(bonus_wit_racial)
			somethingchanged = true
		if bonus_charm_racial != 0:
			person.stats.charm_racial -= round(bonus_charm_racial)
			somethingchanged = true
		if bonus_beauty != 0:
			person.beautybase -= round(bonus_beauty)
			somethingchanged = true
		if bonus_fertility != 0:
			person.preg.bonus_fertility -= round(bonus_fertility)
			somethingchanged = true
		if bonus_titssize != 0 && person.unique == null && person.sex in ['female', 'futanari']:
			person.titssize = globals.titssizearray[clamp(globals.titssizearray.find(person.titssize) - round(bonus_titssize), 0, globals.titssizearray.size()-1)]
			somethingchanged = true
		if bonus_penissize != 0 && person.unique == null && person.sex in ['male', 'futanari']:
			person.penis = globals.penissizearray[clamp(globals.penissizearray.find(person.penis) - round(bonus_penissize), 0, globals.penissizearray.size()-1)]
			somethingchanged = true
		if bonus_ballssize != 0 && person.unique == null && (person.sex in ['male'] || (person.sex in ['futanari'] && globals.rules.futaballs == true)):
			person.balls = globals.penissizearray[clamp(globals.penissizearray.find(person.balls) - round(bonus_ballssize), 0, globals.penissizearray.size()-1)]
			somethingchanged = true	
		if bonus_vagsize != 0 && person.unique == null && person.sex in ['female', 'futanari']:
			person.vagina = globals.vagsizearray[clamp(globals.vagsizearray.find(person.vagina) - round(bonus_vagsize), 0, globals.vagsizearray.size()-1)]
			somethingchanged = true			
		if bonus_height != 0 && person.unique == null:
			person.height = globals.heightarray[clamp(globals.heightarray.find(person.height) - round(bonus_height), 0, globals.heightarray.size()-1)]
			somethingchanged = true
		if bonus_asssize != 0 && person.unique == null && person.sex in ['female', 'futanari']:
			person.asssize = globals.asssizearray[clamp(globals.asssizearray.find(person.asssize) - round(bonus_asssize), 0, globals.asssizearray.size()-1)]
			somethingchanged = true
		if person.unique == null && person.sex in ['male', 'futanari']:
			if bonus_catpenis || bonus_dogpenis || bonus_horsepenis:
				person.penistype = 'human'
				somethingchanged = true
		if bonus_skincov != 'none' && person.unique == null: #only bonus_skincov applied to races that normally have 'none'
			person.skincov = 'none'
			somethingchanged = true
		if bonus_skin != 'fair' && person.unique == null: #future - assign variable so original skin color could be saved/restored
			person.skin = 'fair'
			somethingchanged = true
		if bonus_ears != 'human' && person.unique == null:
			person.ears = 'human'
			somethingchanged = true
		if bonus_eyesclera != 'normal' && person.unique == null: #only bonus_eyesclera applied to races that normally have 'normal'
			person.eyesclera = 'normal'
			somethingchanged = true
		if bonus_horns != 'none' && person.unique == null:
			person.horns = 'none'
			somethingchanged = true
		if bonus_tail != 'none' && person.unique == null:
			person.tail = 'none'
			somethingchanged = true
		if bonus_wings != 'none' && person.unique == null:
			person.wings = 'none'
			somethingchanged = true
		if bonus_furcolor != 'none' && person.unique == null: #only bonus_furcolor applied to races that normally have 'none' and have added skincov = 'full_body_fur'
			person.furcolor = 'none'
			somethingchanged = true
		if bonus_scalecolor != 'none' && person.unique == null: #only bonus_scalecolor applied to races that normally have 'none' and have added skincov = 'fullscales' # /Capitulize
			person.scalecolor = 'none'
			somethingchanged = true
		if bonus_eyecolor != 'none' && person.unique == null: #changing eyecolors depending
			person.eyecolor = 'none'
			somethingchanged = true
		if bonus_bodyshape != 'humanoid' && person.unique == null: 
			person.bodyshape = 'humanoid'
			somethingchanged = true
		if bonus_lewdness != 0 && person.unique == null:
			person.lewdness -= round(bonus_lewdness)
			somethingchanged = true
		if bonus_pliability != 0:
			person.sexexpanded.pliability -= bonus_pliability
			somethingchanged = true
		if bonus_elasticity != 0:
			person.sexexpanded.elasticity -= bonus_elasticity
			somethingchanged = true	
		if hybridtype != "":
			person.race_display = person.race #hybrid info can be lost if setracebonus(person,-1) is called, but as of version 9.7, this should only be via slime conversion
			somethingchanged = true
			
		if somethingchanged == true:
			person.npcexpanded.racialbonusesapplied = true
	###/end Ralphomod
	
#func AddSSRecipe
