
###---Added by Expansion---### Deviate
var animal_races_array = ['bunny','dog','cow','cat','fox','horse','hyena','raccoon','mouse','squirrel','otter','bird',]
var humanoid_races_array = ['Human','Elf','Dark Elf','Tribal Elf','Orc','Ogre','Giant','Gnome','Goblin','Kobold','Demon','Dragonkin']
var uncommon_races_array = ['Fairy','Seraph','Dryad','Lamia','Harpy','Arachna','Nereid','Scylla','Lizardfolk','Avali']
var beast_races_array = ['Centaur','Taurus','Gnoll','Beastkin Cat','Beastkin Fox','Beastkin Wolf','Beastkin Bunny','Beastkin Tanuki','Halfkin Cat','Halfkin Fox','Halfkin Wolf','Halfkin Bunny','Halfkin Tanuki','Beastkin Mouse','Halfkin Mouse','Beastkin Squirrel','Halfkin Squirrel','Beastkin Otter','Halfkin Otter','Beastkin Bird','Halfkin Bird',]
var magic_races_array = ['Slime']
var races_beastfree_darkelf_free = ['Human','Elf','Dark Elf','Orc','Ogre','Giant','Gnome','Goblin','Demon','Dragonkin','Kobold','Lizardfolk','Fairy','Seraph','Dryad','Lamia','Harpy','Arachna','Nereid','Scylla','Slime','Avali']
var genealogies = ['human','gnome','elf','tribal_elf','dark_elf','orc','ogre','giant','goblin','kobold','dragonkin','lizardfolk','dryad','arachna','lamia','fairy','harpy','seraph','demon','nereid','scylla','slime','bunny','dog','cow','cat','fox','horse','hyena','raccoon','mouse','squirrel','otter','bird','avali']
var genealogies_beastfree = ['human','gnome','elf','tribal_elf','dark_elf','orc','ogre','giant','goblin','kobold','dragonkin','lizardfolk','dryad','arachna','lamia','fairy','harpy','seraph','demon','nereid','scylla','slime','avali']
var genealogies_beastkin_only = ['bunny','dog','cat','fox','raccoon','mouse','squirrel','otter','bird'] #ralphB - for breeding race consolidation - needs to include all races to be consolidated
###---End Expansion---###

###---Added by Expansion---### centerflag982 - dickgirls can generate in world
func getrandomsex(person):
	if globals.rules.male_chance > 0 && rand_range(0, 100) < globals.rules.male_chance:
		person.sex = 'male'
	elif rand_range(0, 100) < globals.rules.futa_chance && globals.rules.futa == true:
		person.sex = 'futanari'
	elif rand_range(0, 100) < globals.rules.dickgirl_chance && globals.rules.dickgirl == true:
		person.sex = 'dickgirl'
	else:
		person.sex = 'female'

###---Added by Expansion---### add arg unique
func newslave(race, age, sex, origins = 'slave', unique = null):
	var temp
	var temp2
	var person = globals.person.new()
	if race == 'randomcommon':
		race = globals.getracebygroup("starting")
	elif race == 'randomany':
		race = globals.getracebygroup("active")
	person.race = race
	person.age = getage(age)
	person.mindage = person.age
	person.sex = sex
	if person.sex == 'random': getrandomsex(person)
	for i in ['cour_base','conf_base','wit_base','charm_base']:
		person.stats[i] = rand_range(35,65)
	person.id = str(globals.state.slavecounter)
	globals.state.slavecounter += 1
	person.unique = unique ###---Added by Expansion---###
	changerace(person, 'Human')
	changerace(person)
	person.work = 'rest'
	person.sleep = 'communal'
	person.sexuals.actions.kiss = 0
	person.sexuals.actions.massage = 0
	globals.assets.getsexfeatures(person)
	if person.race.find('Halfkin') >= 0 || (person.race.find('Beastkin') >= 0 && globals.rules.furry == false): #ralphD note - gets overridden for new babies
		person.race = person.race.replace('Beastkin', 'Halfkin')
		person.bodyshape = 'humanoid'
		person.skincov = 'none'
		person.arms = 'normal'
		person.legs = 'normal'
		if rand_range(0,1) > 0.4:
			person.eyeshape = 'normal'
	get_caste(person, origins)
	for i in person.sexuals.unlocks:
		var category = globals.sexscenes.categories[i]
		for ii in category.actions:
			person.sexuals.actions[ii] = 0
	person.memory = person.origins
	person.masternoun = ''
	if randf() < variables.specializationchance/100.0:
		globals.currentslave = person
		var possible = []
		for i in globals.specarray:
			if globals.evaluate(globals.jobs.specs[i].reqs.replacen("person.consent == true","true").replacen("person.loyal >= 50","true")) == true:
				possible.append(i)
		if possible.size() > 0:
			person.spec = possible[randi()%possible.size()]
			if person.spec == 'bodyguard':
				person.add_effect(globals.effectdict.bodyguardeffect)
	if person.age == 'child' && randf() < 0.1:
		person.vagvirgin = false
	elif person.age == 'teen' && randf() < 0.3:
		person.vagvirgin = false
	elif person.age == 'adult' && randf() < 0.65:
		person.vagvirgin = false
	
	###---Added by Expansion---### Races Expanded
	set_genealogy(person)
	setRaceDisplay(person)
#	set_race_secondary(person)
#	if globals.expansionsettings.racialstatbonuses == true:
#		globals.expansionsetup.setRaceBonus(person, true)
	###---End Expansion---###
	
	###---Added by Array---### Person Expanded
	globals.expansionsetup.expandPerson(person)
	###---End Expansion---###
	
	###---Added by Expansion---### Pregnancy Expanded
	person.preg.fertility = rand_range(0,30)
	set_ovulation(person)
	#Delayed per Ank's Notes
	if globals.rules.randomcustomportraits == true:
		randomportrait(person)
	person.health = 1000
	###---End Expansion---###
	globals.traceFile('newslave')
	
	return person

func changerace(person, race = null):
	var races = globals.races
	var personrace
	if race == null:
		personrace = person.race.replace('Halfkin','Beastkin')
	else:
		personrace = race
	for i in races[personrace]:
		if i in ['description', 'details']:
			continue
		if i in ['marketup', 'marketdown']: #ralph5
			continue #ralph5
		if typeof(races[personrace][i]) == TYPE_ARRAY:
			person[i] = globals.randomfromarray(races[personrace][i])
		elif typeof(races[personrace][i]) == TYPE_DICTIONARY:
			if person.get(i) == null:
				continue
			for k in (races[personrace][i]):
				person[i][k] = races[personrace][i][k]
		else:
			if person.get(i) != null:
				person[i] = races[personrace][i]

# Numbers are the portion children get from their mother, father's portion will be 1 - mother's
# if one parent doesn't have a body part it will be fully based on the other parent, if neither has it should be set to smallest
var sizeDict = {
	"female":{"vagina":1,"tits":1,"asshole":1,"lips":1,"ass":1},
	"male":{"penis":0,"balls":0,"tits":0,"asshole":0,"lips":0,"ass":0},
	"futanari":{"vagina":0.5,"penis":0.5,"tits":0.5,"asshole":0.5,"lips":0.5,"ass":0.5},
	"dickgirl":{"penis":0.5,"balls":0.5,"tits":1,"asshole":1,"lips":1,"ass":1},
}
var sizeArrayDict
var sizeStringDict = {"tits":"titssize","ass":"asssize"}

#refs to globals.gd cannot be made until after init
func fillSizeArrayDict():
	sizeArrayDict = {
		"vagina": globals.vagsizearray, "tits": globals.titssizearray, "penis": globals.penissizearray, "balls": globals.penissizearray,
		"asshole": globals.assholesizearray, "lips": globals.lipssizearray, "ass": globals.asssizearray
	}

func setSizes(person,mother,father):
	#The key needs to not exist to not be added
	if globals.rules.futaballs:
		sizeDict.futanari.balls = 0.5
	else:
		sizeDict.futanari.erase("balls")
	for part in sizeDict[person.sex]:
		var motherModifier = 0
		var fatherModifier = 0
		var type = sizeStringDict.get(part,part)
		var sizeArray = sizeArrayDict[part]
		var randomMod = round(rand_range(-3 if part == "vagina" else -1,1))

		if part == "tits":
			motherModifier -= mother.pregexp.titssizebonus
			fatherModifier -= father.pregexp.titssizebonus

		var base
		if mother[type] == "none":
			base = sizeArray.find(father[type]) + fatherModifier
		elif father[type] == "none":
			base = sizeArray.find(mother[type]) + motherModifier
		else:
			var value = sizeDict[person.sex][part]
			base = (sizeArray.find(mother[type]) + motherModifier)*value + (sizeArray.find(father[type]) + fatherModifier)*(1.0-value)
		person[type] = sizeArray[clamp(round(base + randomMod), 0, sizeArray.size()-1)]
		#prints(part,value,person[type],sizeArray.find(person[type]),randomMod,sizeArray.find(mother[type]),sizeArray.find(father[type]))
	return person

###---Added by Expansion---### Added by Deviate - Hybrid Races
var body_array = ['skin','tail','ears','wings','horns','arms','legs','bodyshape','haircolor','eyecolor','eyeshape','eyesclera']
var racebound_body_array = ['ears','arms','legs','bodyshape'] #ralphD
var listMaxStats = ['str_max','agi_max','maf_max','end_max']

func newbaby(mother,father):
	var person = globals.newslave(mother.race, 'child' if globals.rules.children else 'teen', 'random', mother.origins)
	person.cleartraits()
	#var tacklearray = ['penis']
	#var temp

	#General
	person.state = 'fetus'
	person.surname = mother.surname

	#Body #ralphD - moved lower in function to fix a bug overriding body part assignments
		
	setSizes(person,mother,father)
	""" #Male Genitals
	###---Added by Expansion---### centerflag982 - added dickgirl check				
	if person.sex == 'male' || person.sex == 'dickgirl' || (person.sex == 'futanari' && globals.rules.futaballs == true):
		tacklearray.append('balls')
		
		if person.sex != 'futanari':
			person.vagina = 'none'
			person.preg.has_womb = false
	
		for i in tacklearray:
			temp = globals.penissizearray.find(father[i])+round(rand_range(-1,1))
			temp = clamp(temp, 0 ,globals.penissizearray.size()-1)
			person[i] = globals.penissizearray[temp]

		temp = globals.titssizearray.find(father.titssize)-father.pregexp.titssizebonus+round(rand_range(-1,1))
		person.titssize = globals.titssizearray[temp]
	###---End Expansion---###
	#Female Genitals
	if person.sex in ['female','futanari']:
		temp = globals.vagsizearray.find(mother.vagina)+round(rand_range(-3,1))
		temp = clamp(temp, 0, globals.vagsizearray.size()-1)
		person.vagina = globals.vagsizearray[temp]
		temp = globals.titssizearray.find(mother.titssize)-mother.pregexp.titssizebonus+round(rand_range(-1,1))
		person.titssize = globals.titssizearray[temp]

	#Asshole
	temp = round(globals.assholesizearray.find(mother.asshole)+globals.assholesizearray.find(father.asshole)*.5)+round(rand_range(-3,1))
	temp = clamp(temp, 0, globals.assholesizearray.size()-1)
	person.asshole = globals.assholesizearray[temp]
	
	#Lips
	temp = round(globals.lipssizearray.find(mother.lips)+globals.lipssizearray.find(father.lips)*.5)+round(rand_range(-1,1))
	temp = clamp(temp, 0, globals.lipssizearray.size()-1)
	person.lips = globals.lipssizearray[temp]
	
	#Ass
	temp = round(globals.asssizearray.find(mother.asssize)+globals.asssizearray.find(father.asssize)*.5)+round(rand_range(-1,1))
	temp = clamp(temp, 0, globals.asssizearray.size()-1)
	person.asssize = globals.asssizearray[temp] """

	#Dimensional Crystal
	if globals.state.mansionupgrades.dimensionalcrystal >= 2:
		var pStats = person.stats
		var temp
		for i in listMaxStats:
			temp = max(father.stats[i], mother.stats[i])
			if pStats[i] < temp:
				pStats[i] += round((temp - pStats[i]) *.6)

	#Bodyshape
	if person.race.find('Halfkin')>=0 && mother.race.find('Beastkin') >= 0 && father.race.find('Beastkin') < 0:
		person.bodyshape = 'humanoid'
	person.beautybase = max(father.beautybase, mother.beautybase) + rand_range(-2,5)

	var traitpool = father.traits + mother.traits
	var excluded = []
	for i in traitpool:
		if rand_range(0,100) > variables.traitinheritchance:
			continue
		var trait = globals.origins.trait(i)
		if trait.tags.has('expansiontrait'):
			if trait.tags.has('movetrait') || trait.tags.has('sexualitytrait'):
				continue
			#Increase if Same
			for expansiontraits in globals.expansion.subtraitlines:
				if trait.tags.has(expansiontraits) && !excluded.has(expansiontraits):
					var traitline = globals.expansion[expansiontraits]
					var matchrank = -1
					var newtraitrank
					for ii in traitpool:
						if i == ii && traitpool.count(i) == 1:
							continue
						var trait2 = globals.origins.trait(ii)
						if trait2 != null && trait2.tags.has(expansiontraits):
							matchrank = traitline.find(ii)
					if matchrank >= 0:
						if matchrank != traitline.find(i):
							newtraitrank = round( rand_range( traitline.find(i), matchrank)) + randi() % 2
						else:
							newtraitrank = round( matchrank + rand_range(1,2))
					else:
						newtraitrank = round( traitline.find(i) + rand_range(-1,1))
					var newtraitname = traitline[ clamp(newtraitrank, 0, traitline.size()-1) ]
					var newtrait = globals.origins.trait(newtraitname)
					if newtrait != null:
						excluded.append(expansiontraits)
						if newtrait.tags.has('lactation-trait'):
							person.traitstorage.append(newtraitname)
						else:
							person.add_trait(newtraitname)
		else:
			person.add_trait(i)
	
	if rand_range(0,100) <= variables.babynewtraitchance:
		if rand_range(0,100) <= 20 && globals.expansionsettings.unique_trait_generation: # 1 in 5 chance, requires Ralph Tweaks to be set on.
			person.add_trait(globals.origins.traits('unique').name)
		else:
			person.add_trait(globals.origins.traits('any').name)
	
	person.npcexpanded.mansionbred = true
	
	if globals.expansion.relatedCheck(mother,father) != "unrelated":
		mother.pregexp.incestbaby = true
	globals.expansion.setWantedPregnancy(mother)
	
	globals.connectrelatives(mother, person, 'mother')
	if int(father.id) != -1:
		globals.connectrelatives(father, person, 'father')
	
	#Genealogy
	build_genealogy(person, mother, father)
	#setRace(person,mother) #ralphD - moved call to inside setRaceDisplay() as is it was being overridden and partially duplicated
	setRaceDisplay(person)
	set_race_secondary(person)
	
#	if globals.expansionsettings.racialstatbonuses == true:
#		globals.expansionsetup.setRaceBonus(person, true)

	#Body #ralphD - moved from higher in the function b/c body part assignments based on parents were overridden in setRaceDisplay() as called a few line up from here
	if globals.expansionsettings.use_ralphs_tweaks == false: #ralphD - centerflag982's system for base Aric's
		for i in body_array:
			###---Added by Expansion---### centerflag982 - dickgirls take after their mothers
			if person.sex == 'female' || person.sex == 'dickgirl':
				person[i] = mother[i] if rand_range(0,10) < 7 else father[i]
			###---End Expansion---###
			else:
				person[i] = father[i] if rand_range(0,10) < 7 else mother[i]
	else: #ralphD - ralph's system for ralphs (more random inheritance mostly; placeholder before hybrid system revamp)
		for i in body_array:
			if mother.race == father.race:
				person[i] = mother[i] if rand_range(0,10) < 5 else father[i]
			elif i in racebound_body_array: #&& !globals.races[person.race].i.empty(): #ralphD - not working
				#print("Ralph's found "+str(person.name)+" has racebound feature: "+str(i))
				#print("Ralph's found racebound feature: "+str(i)+".  Race version is: "+str(globals.races[person.race][i])+"    Mother's: "+str(mother[i])+"  Father's: "+str(father[i]))
				#print("Ralph TTTEEEST:  globals.races[person.race][i]: "+str(globals.races[person.race][i]))
				if person.race == mother.race:
					person[i] = mother[i]
				elif person.race == father.race:
					person[i] = father[i]
				elif rand_range(0,1) > 0.5:
					person[i] = mother[i]
				else:
					person[i] = father[i]
			else:
				person[i] = mother[i] if rand_range(0,10) < 5 else father[i]
	#/ralphD	

	
	#Ovulation
	person.preg.baby_type == ''
	set_ovulation(person)

	# Only want to run once even if twins/triplets/...
	if !mother.preg.is_preg:
		mother.metrics.preg += 1
		if globals.state.perfectinfo == true && globals.state.mansionupgrades.dimensionalcrystal >= 3:
			mother.knowledge.append('currentpregnancy')
	globals.state.babylist.append(person)
	
	# Random portrait again, since primary race may have changed in setRaceDisplay
	if globals.rules.randomcustomportraits == true:
		randomportrait(person)

	globals.traceFile('newbaby')
	
	return person
###---End of Expansion---###



###---Added by Expansion---### Added by Deviate - Hybrid Races
func clearGenealogies(person):
	for gens in genealogies:
		person.genealogy[gens] = 0
	return

#Tweaked by Aric
func set_genealogy(person):
	var remaining_percent = 100
	var random_number = 0
	var genealogy = ''
	var newrace = ''
	
	if person == null:
		return
	
	if person.race == null:
		person.race = raceLottery(person)
	if person.race == '':
		print('No Race is Assignable in constructor.set_genealogy for ' + str(person.full_name))
		return
	
	#Set Primary Race's Type
	if person.race in animal_races_array:
		person.race_type = 0
	elif person.race in humanoid_races_array:
		person.race_type = 1
	elif person.race in uncommon_races_array:
		person.race_type = 2
	elif person.race in beast_races_array:
		person.race_type = 3
	elif person.race in magic_races_array:
		person.race_type = 4
	
	#Set Primary Race #ralphE
	if (globals.expansionsettings.player_secondaryracepercent == 0 && person.unique == 'player') || (globals.expansionsettings.startslave_secondaryracepercent == 0 && person.unique == 'startslave'):
		random_number = allot_percentage('purebreed')
	#/ralphE
	elif (globals.rules.furry == false || person.race.find('Halfkin') < 0) && (person.unique != null || person.race in magic_races_array || rand_range(0,100) <= globals.expansionsettings.randompurebreedchance || (person.race in uncommon_races_array && rand_range(0,100) <= globals.expansionsettings.randompurebreedchanceuncommon)):
		random_number = allot_percentage('purebreed')
	elif person.race.find('Halfkin') >= 0 || rand_range(0,100) <= globals.expansionsettings.randommixedbreedchance:
		random_number = allot_percentage('primary_mixed')
	else:
		random_number = allot_percentage('primary')
	
	#ralphE
	if person.unique == 'player' && globals.expansionsettings.player_secondaryracepercent <= 50 && globals.expansionsettings.player_secondaryracepercent > 0 && globals.expansionsettings.player_secondaryrace in globals.expansion.genealogies:
		genealogy = genealogy_decoder(person.race)
		person.genealogy[genealogy] += 100 - globals.expansionsettings.player_secondaryracepercent
		genealogy = globals.expansionsettings.player_secondaryrace
		person.genealogy[genealogy] += globals.expansionsettings.player_secondaryracepercent
		remaining_percent = 0
	elif person.unique == 'startslave' && globals.expansionsettings.startslave_secondaryracepercent <= 50 && globals.expansionsettings.startslave_secondaryracepercent > 0 && globals.expansionsettings.startslave_secondaryrace in globals.expansion.genealogies:
		genealogy = genealogy_decoder(person.race)
		person.genealogy[genealogy] += 100 - globals.expansionsettings.startslave_secondaryracepercent
		genealogy = globals.expansionsettings.startslave_secondaryrace
		person.genealogy[genealogy] += globals.expansionsettings.startslave_secondaryracepercent
		remaining_percent = 0
	elif person.unique in ['player','startslave'] && globals.rules.furry && person.race.find('Halfkin') >= 0:
		genealogy = genealogy_decoder(person.race)
		person.genealogy[genealogy] = 69
		person.genealogy['human'] = 31
		remaining_percent = 0
	else: #ralphE - note - below code is unchanged except for indents
		random_number = clamp(random_number, 30, remaining_percent)
		remaining_percent -= random_number
	
		genealogy = genealogy_decoder(person.race)
		person.genealogy[genealogy] += random_number
	
		#Allot Secondary
		if remaining_percent > 0:
			#Set Second Race
			newrace = raceLottery(person)
			person.race_secondary = newrace
			#Set Percentage
			random_number = allot_percentage('secondary')
			random_number = clamp(random_number, 10, remaining_percent)
			#Reduce Random Genes < 10
			if remaining_percent - random_number < 0 || remaining_percent - random_number < globals.expansionsettings.genealogy_equalizer:
				random_number = remaining_percent
			remaining_percent -= random_number
			#Add to Genealogy
			genealogy = genealogy_decoder(newrace)
			person.genealogy[genealogy] += random_number
		else:
			person.race_secondary = 'Full Blooded'
	#/ralphE
	#Fill in Remaining Percentages
	while remaining_percent > 0:
		#Set Minor Races
		newrace = raceLottery(person)
		#Set Percentage
		random_number = allot_percentage('minor')
		random_number = clamp(random_number, 10, remaining_percent)
		#Reduce Random Genes < 10
		if remaining_percent - random_number < 0 || remaining_percent - random_number < globals.expansionsettings.genealogy_equalizer:
			random_number = remaining_percent
		remaining_percent -= random_number
		#Add to Genealogy
		genealogy = genealogy_decoder(newrace)
		person.genealogy[genealogy] += random_number
	
	var totalgenealogy = 0
	for race in genealogies:
		if person.genealogy[race] > 0:
			totalgenealogy += person.genealogy[race]
	while totalgenealogy != 100:
		totalgenealogy = build_genealogy_equalize(person, totalgenealogy)
	
	#Sibling Match Relatives
	if person.npcexpanded.mansionbred == false && globals.state.relativesdata.has(person.id):
		var relativesdata = globals.state.relativesdata
		var entry = relativesdata[person.id]
		var matched_sibling = false
		for i in entry.siblings + entry.halfsiblings:
			var entry2 = relativesdata[i]
			#if int(entry.father) == int(entry2.father) || int(entry.mother) == int(entry2.mother):
			var tempPerson2 = globals.state.findslave(entry2.id)
			if tempPerson2 == null:
				continue
			for shared_gene in tempPerson2.genealogy:
				person.genealogy[shared_gene] = tempPerson2.genealogy[shared_gene]
				matched_sibling = true
				break
	
	globals.traceFile('setgenealogy')

#Added by Aric
func allot_percentage(type):
	var random_number = 0
	
	#['purebreed','primary','primary_mixed','secondary','minor']
	if type == 'purebreed':
		random_number = 100
	elif type == 'primary':
		random_number = round(rand_range(70,100))
	elif type == 'primary_mixed':
		random_number = round(rand_range(50,69))
	elif type == 'secondary':
		random_number = round(rand_range(15,50))
	elif type == 'minor':
		random_number = round(rand_range(10,29))
	else:
		random_number = round(rand_range(1,100))
	
	return random_number

#Added by Aric
func genealogy_decoder(chosenrace):
	#Plain Text Races are the same race name as they are genealogy name
	var path = ''
	
	if chosenrace == '':
		print('No Race Available to Decode Genealogy')
		return path
	
	#Remove any Halfkin/Beastkin so Mixed Races don't Glitch
	if chosenrace.find('Halfkin') >= 0:
		chosenrace = chosenrace.replace('Halfkin ','')
	if chosenrace.find('Beastkin') >= 0:
		chosenrace = chosenrace.replace('Beastkin ','')
	
	if chosenrace in races_beastfree_darkelf_free:
		path = str(globals.decapitalize(chosenrace))
	elif chosenrace == 'Dark Elf':
		path = 'dark_elf'
	elif chosenrace == 'Tribal Elf':
		path = 'tribal_elf'
	elif chosenrace == 'Centaur':
		path = 'horse'
	elif chosenrace == 'Taurus':
		path = 'cow'
	elif chosenrace == 'Gnoll':
		path = 'hyena'
	elif chosenrace == 'Wolf':
		path = 'dog'
	elif chosenrace == 'Cat':
		path = 'cat'
	elif chosenrace == 'Fox':
		path = 'fox'
	elif chosenrace == 'Bunny':
		path = 'bunny'
	elif chosenrace == 'Tanuki':
		path = 'raccoon'
	elif chosenrace == 'Mouse':
		path = 'mouse'
	elif chosenrace == 'Squirrel':
		path = 'squirrel'
	elif chosenrace == 'Otter':
		path = 'otter'
	elif chosenrace == 'Bird':
		path = 'bird'
	
	return path

func decodeGenealogytoRace(race):
	#Plain Text Races are the same race name as they are genealogy name
	var text = ''
	
	if race == '':
#		print('No Genealogy Available to turn to Race')
		return text
	
	if race == 'dark_elf':
		text = 'Dark Elf'
	elif race == 'tribal_elf':
		text = 'Tribal Elf'
	elif race in animal_races_array:
		if race == 'horse':
			text = 'Centaur'
		elif race == 'cow':
			text = 'Taurus'
		elif race == 'hyena':
			text = 'Gnoll'
		elif race == 'dog':
			text = 'Wolf'
		elif race == 'raccoon':
			text = 'Tanuki'
		else:
			text = race.capitalize()
	else:
		text = race.capitalize()
	return text

#Added by Aric
func raceLottery(person):
	var raceoptions = []
	var temprace = ''
	var sametypeweight = 0
	
	if person == null:
		print('No Person to assign raceLottery. Assigning Human')
		return 'Human'
	
	for i in humanoid_races_array:
		temprace = genealogy_decoder(i)
		if person.genealogy[temprace] == 0 && rand_range(0,100) <= globals.expansionsettings.secondaryhumanoidracialchance + sametypeweight:
			raceoptions.append(i)
		elif person.genealogy[temprace] > 0:
			sametypeweight += round(person.genealogy[temprace]/2)
	sametypeweight = 0
	for i in uncommon_races_array:
		temprace = genealogy_decoder(i)
		if person.genealogy[temprace] == 0 && rand_range(0,100) <= globals.expansionsettings.secondaryuncommonracialchance + sametypeweight:
			raceoptions.append(i)
		elif person.genealogy[temprace] > 0:
			sametypeweight += round(person.genealogy[temprace]/globals.expansionsettings.same_type_weight)
	sametypeweight = 0
	for i in beast_races_array:
		temprace = genealogy_decoder(i)
		if person.genealogy[temprace] == 0 && rand_range(0,100) <= globals.expansionsettings.secondarybeastracialchance + sametypeweight:
			raceoptions.append(i)
		elif person.genealogy[temprace] > 0:
			sametypeweight += round(person.genealogy[temprace]/2)
	if raceoptions.size() == 0:
		for i in humanoid_races_array:
			temprace = genealogy_decoder(i)
			if person.genealogy[temprace] == 0:
				raceoptions.append(i)
	
	var rolledrace = globals.randomitemfromarray(raceoptions)
	
	globals.traceFile('racelottery')
	return rolledrace

#Tweaked by Aric
func build_genealogy(person, mother, father):
	var percent = 0
	#ralph9 add randomness to babies genes from toxicity of parents; high toxicity -> more chance for variance in which genes are passed
	#var remainder
	for race in genealogies:
		#ralph8 add a tiny bit of randomization and fix 99% and 100% parents never yielding pureblood child
		if rand_range(0,100) >= 50: 
			person.genealogy[race] = round((mother.genealogy[race] + father.genealogy[race]) * .49999999)
			percent += person.genealogy[race]
		else:
			person.genealogy[race] = round((mother.genealogy[race] + father.genealogy[race]) * .5)
			percent += person.genealogy[race]
		#/ralph8
	while percent != 100:
		percent = build_genealogy_equalize(person, percent)
	#/ralph9
	#ralphB - optional consolidation of beastkin/halfkin races on breeding (offspring will have only one beastkin/halfkin type race with total % that would have been split b/n different beastkin/halfkin races)
	if globals.useRalphsTweaks && globals.expansionsettings.consolidatebeastDNA:
		var total_beastkin_race_percent = 0
		var babys_beastkin_races = []
		var selected_race = "human"
		var highest_beastkin_race_percent = 0
		for race in genealogies:
			if race in genealogies_beastkin_only:
				babys_beastkin_races.append(race)
				total_beastkin_race_percent += person.genealogy[race]
				if person.genealogy[race] > highest_beastkin_race_percent:
					selected_race = race
					highest_beastkin_race_percent = person.genealogy[race]
		if babys_beastkin_races.size() > 1:
			for race in babys_beastkin_races:
				if person.genealogy[race] > rand_range(0,total_beastkin_race_percent):
					selected_race = race
			for race in babys_beastkin_races:
				if race == selected_race:
					person.genealogy[race] = total_beastkin_race_percent
				else:
					person.genealogy[race] = 0
	#/ralphB
	globals.traceFile('build genealogy')

#Tweaked by Aric
func build_genealogy_equalize(person, percent):
	#Fix for Negative Genealogies by Ankmairdor
	var newVal 
	for race in genealogies:
	  newVal = clamp(person.genealogy[race], 0, 100)
	  percent += newVal - person.genealogy[race]
	  person.genealogy[race] = newVal
	
	var lpercent = percent
	var random_number = 0

	if percent > 100:
		for race in genealogies:
			if lpercent > 100 && person.genealogy[race] > 0:
				random_number = round(rand_range(1, lpercent-100))
				random_number = clamp(random_number, 0, person.genealogy[race])
				person.genealogy[race] -= random_number
				lpercent -= random_number
				if lpercent <= 100:
					break
	elif percent < 100:
		for race in genealogies:
			if lpercent < 100 && person.genealogy[race] > 0:
				random_number = round(rand_range(1, 100-lpercent))
				random_number = clamp(random_number, 0, 100-person.genealogy[race])
				person.genealogy[race] += random_number
				lpercent += random_number
				if lpercent >= 100:
					break
	
	globals.traceFile('build genealogy equalize')
	
	return lpercent

func setRace(person,raceselected,highestpercent): #ralphD - consolidated to function within setRaceDisplay()
	var currentrace = raceselected #ralphD
	#var highestpercent = 0 #ralphD
	
	#Pick Highest Genetics #ralphD - note this was being overridden in setRaceDisplay() and is now redundant
	#for race in genealogies:
	#	if person.genealogy[race] > highestpercent:
	#		currentrace = race
	#		highestpercent = person.genealogy[race]
	#	elif person.genealogy[race] == highestpercent && mother.race == race:
	#		currentrace = race
	
	#Assign Race Type/Race
	var caprace = currentrace.capitalize()
	if caprace in humanoid_races_array:
		person.race_type = 1
		if currentrace == "Dark_elf":
			person.race = "Dark Elf"
		elif currentrace == "Tribal_elf":
			person.race = "Tribal Elf"
		else:
			person.race = caprace
	elif caprace in uncommon_races_array:
		person.race_type = 2
		person.race = caprace
	elif caprace in magic_races_array:
		person.race_type = 4
		person.race = caprace
	elif currentrace in animal_races_array:
		person.race_type = 3
		if currentrace == "horse":
			person.race = 'Centaur'
		elif currentrace == "cow":
			person.race = 'Taurus'
		elif currentrace == "hyena":
			person.race = 'Gnoll'
		else:
			#Beastkin/Halfkin Decoder
			if highestpercent >= 70 && globals.rules.furry: #ralphE - changed so that with furries disabled, you get Halfkin instead of Beastkin
				caprace = 'Beastkin '
			else:
				caprace = 'Halfkin '
			#Race Decoder
			if currentrace == 'bunny':
				caprace += 'Bunny'
			elif currentrace == 'dog':
				caprace += 'Wolf'
			elif currentrace == 'cat':
				caprace += 'Cat'
			elif currentrace == 'fox':
				caprace += 'Fox'
			elif currentrace == 'raccoon':
				caprace += 'Tanuki'
			elif currentrace == 'mouse':
				caprace += 'Mouse'
			elif currentrace == 'squirrel':
				caprace += 'Squirrel'
			elif currentrace == 'otter':
				caprace += 'Otter'
			elif currentrace == 'bird':
				caprace += 'Bird'

			person.race = caprace
	else:
		person.race_type = 1
		person.race = "Human"
		print('No Race Found for ' + str(person.full_name) + '. Assigned Human ')
	
	globals.traceFile('Constructor.pickRace Completed')

func setRaceDisplay(person): #ralphD - reworked to fix bugs
	var text = ""
	var primaryrace = ""
	var primaryracepercent = 0
	var secondaryrace = ""
	var secondaryracepercent = 0
	var racetiestobreak = [] #ralphD
	
	#Sort Races
	for race in genealogies:
		if person.genealogy[race] > 0 && person.genealogy[race] >= primaryracepercent:
			#Push Primary to Secondary if Greater
			if person.genealogy[race] > primaryracepercent:
				secondaryrace = primaryrace
				secondaryracepercent = primaryracepercent
				primaryrace = race
				primaryracepercent = person.genealogy[race]
				racetiestobreak = []
			#ralphD
			elif person.genealogy[race] == primaryracepercent:
				racetiestobreak.append(race)
				if !racetiestobreak.has(primaryrace) && primaryrace != "":
					racetiestobreak.append(primaryrace)
			#/ralphD
			primaryrace = race
			primaryracepercent = person.genealogy[race]
		elif person.genealogy[race] > 0 && person.genealogy[race] >= secondaryracepercent:
			secondaryrace = race
			secondaryracepercent = person.genealogy[race]
	#Final Sort
	if secondaryracepercent > primaryracepercent:
		var resortrace = primaryrace
		var resortpercent = primaryracepercent
		primaryrace = secondaryrace
		primaryracepercent = secondaryracepercent
		secondaryrace = resortrace
		secondaryracepercent = resortpercent

	#Randomize Ties (eg. 50/50 or even 25/25/25/25 race hybrids)  #ralphD
	if racetiestobreak.size() > 1:
		primaryrace = globals.randomfromarray(racetiestobreak)
		racetiestobreak.erase(primaryrace)
		secondaryrace = globals.randomfromarray(racetiestobreak)
		secondaryracepercent = primaryracepercent
	
	setRace(person,primaryrace,primaryracepercent)
	#/ralphD
	
	#Decode Races
	primaryrace = decodeGenealogytoRace(primaryrace)
	if secondaryrace != null:
		secondaryrace = decodeGenealogytoRace(secondaryrace)
	
	#Set Display
	if primaryracepercent >= 100:
		text = 'Fullblooded '
	elif primaryracepercent >= 70:
		text = 'Primarily '
	elif primaryracepercent >= 50:
		text = 'Half '
	else:
		text = 'Mixed '
	text += primaryrace
	
	if secondaryracepercent > 0 && secondaryrace != null:
		if secondaryracepercent >= 100:
			text += ' | Fullblooded ' + secondaryrace + ' Freak of Nature'
		elif secondaryracepercent >= 70:
			text += ' | Mostly ' + secondaryrace + ' Freak of Nature'
		elif primaryracepercent >= 50 && secondaryracepercent >= 40: #ralph3
			text += ' | Half ' + secondaryrace + ''
		elif primaryracepercent >= 50: #ralph3
			text += ' | Part ' + secondaryrace + '' #ralph3
		else:
			text += ' with ' + secondaryrace + ' features'
	
	if primaryracepercent < 30 && secondaryracepercent < 30:
		text = 'A Total Mutt'
	
	person.race_display = text

#Tweaked by Aric - Only used by newbaby now
func set_race_secondary(person):
	var race_secondary = ''
	var race_secondary_percent = 0
	
	var plaintext_races = ['human','elf','orc','ogre','giant','gnome','goblin','kobold','demon','dragonkin','lizardfolk','fairy','seraph','dryad','lamia','harpy','arachna','nereid','scylla','avali']
	var mainrace = person.race
	
	#Remove any Halfkin/Beastkin so Mixed Races don't Glitch
	if mainrace.find('Halfkin') >= 0:
		mainrace = mainrace.replace('Halfkin ','')
	if mainrace.find('Beastkin') >= 0:
		mainrace = mainrace.replace('Beastkin ','')
	if mainrace.find('Half') >= 0:
		mainrace = mainrace.replace('Half ','')
	if mainrace.find(' | ') >= 0:
		mainrace = mainrace.replace(' | ','')
	
	for i in plaintext_races:
		if mainrace != i.capitalize() && person.genealogy[i] > 0 && person.genealogy[i] > race_secondary_percent:
			race_secondary = i.capitalize()
			race_secondary_percent = person.genealogy[i]
	if person.race != 'Dark Elf' && person.genealogy.dark_elf > 0 && person.genealogy.dark_elf > race_secondary_percent:
		race_secondary = 'Dark Elf'
		race_secondary_percent = person.genealogy.dark_elf
	if person.race != 'Tribal Elf' && person.genealogy.tribal_elf > 0 && person.genealogy.tribal_elf > race_secondary_percent:
		race_secondary = 'Tribal Elf'
		race_secondary_percent = person.genealogy.tribal_elf
	
	if person.race != 'Beastkin Bunny' && person.race != 'Halfkin Bunny' && person.genealogy.bunny > race_secondary_percent && person.genealogy.bunny > 0:
		race_secondary = 'Halfkin Bunny'
		race_secondary_percent = person.genealogy.bunny
	
	if person.race != 'Beastkin Wolf' && person.race != 'Halfkin Wolf' && person.genealogy.dog > race_secondary_percent && person.genealogy.dog > 0:
		race_secondary = 'Halfkin Wolf'
		race_secondary_percent = person.genealogy.dog
	
	if person.race != 'Taurus' && person.race != 'Halfkin Taurus' && person.genealogy.cow > race_secondary_percent && person.genealogy.cow > 0:
		race_secondary = 'Halfkin Taurus'
		race_secondary_percent = person.genealogy.cow
		
	if person.race != 'Gnoll' && person.race != 'Halfkin Gnoll' && person.genealogy.hyena > race_secondary_percent && person.genealogy.hyena > 0:
		race_secondary = 'Halfkin Gnoll'
		race_secondary_percent = person.genealogy.hyena
	
	if person.race != 'Beastkin Cat' && person.race != 'Halfkin Cat' && person.genealogy.cat > race_secondary_percent && person.genealogy.cat > 0:
		race_secondary = 'Halfkin Cat'
		race_secondary_percent = person.genealogy.cat
	
	if person.race != 'Beastkin Fox' && person.race != 'Halfkin Fox' && person.genealogy.fox > race_secondary_percent && person.genealogy.fox > 0:
		race_secondary = 'Halfkin Fox'
		race_secondary_percent = person.genealogy.fox
	
	if person.race != 'Centaur' && person.race != 'Halfkin Centaur' && person.genealogy.horse > race_secondary_percent && person.genealogy.horse > 0:
		race_secondary = 'Halfkin Centaur'
		race_secondary_percent = person.genealogy.horse
	
	if person.race != 'Beastkin Tanuki' && person.race != 'Halfkin Tanuki' && person.genealogy.raccoon > race_secondary_percent && person.genealogy.raccoon > 0:
		race_secondary = 'Halfkin Tanuki'
		race_secondary_percent = person.genealogy.raccoon

	if person.race != 'Beastkin Mouse' && person.race != 'Halfkin Mouse' && person.genealogy.mouse > race_secondary_percent && person.genealogy.mouse > 0:
		race_secondary = 'Halfkin Mouse'
		race_secondary_percent = person.genealogy.mouse

	if person.race != 'Beastkin Squirrel' && person.race != 'Halfkin Squirrel' && person.genealogy.squirrel > race_secondary_percent && person.genealogy.squirrel > 0:
		race_secondary = 'Halfkin Squirrel'
		race_secondary_percent = person.genealogy.squirrel

	if person.race != 'Beastkin Otter' && person.race != 'Halfkin Otter' && person.genealogy.otter > race_secondary_percent && person.genealogy.otter > 0:
		race_secondary = 'Halfkin Otter'
		race_secondary_percent = person.genealogy.otter

	if person.race != 'Beastkin Bird' && person.race != 'Halfkin Bird' && person.genealogy.bird > race_secondary_percent && person.genealogy.bird > 0:
		race_secondary = 'Halfkin Bird'
		race_secondary_percent = person.genealogy.bird

	if race_secondary == '':
		person.race_secondary = 'Full Blooded'
	else:
		person.race_secondary = race_secondary
	
	globals.traceFile('set race secondary')

#Tweaked by Aric
func setBabyType(person):
	if person.preg.has_womb == false || person.race_type == 4:
		person.preg.baby_type = 'none'
	elif person.race in ['Dragonkin','Lamia','Harpy','Arachna','Scylla','Kobold','Lizardfolk','Beastkin Bird','Avali',]:
		person.preg.baby_type = 'egg'
	else:
		person.preg.baby_type = 'birth'
	
	globals.traceFile('setbabytype')

#Tweaked by Aric
func set_ovulation(person):
	globals.traceFile('set ovulation start')
	if person.preg.baby_type == '':
		setBabyType(person)
	
	if person.preg.baby_type == 'birth':
		person.preg.ovulation_type = 1
	elif person.preg.baby_type == 'egg':
		person.preg.ovulation_type = 2
	else:
		person.preg.ovulation_type = -1
		person.preg.ovulation_stage = -1
		person.preg.ovulation_day = -1
	
	setRandomOvulationDay(person)
	globals.traceFile('set ovulation finish')

#Added by Aric
func setRandomOvulationDay(person):
	if person.preg.ovulation_type == 0:
		set_ovulation(person)
	
	if person.preg.ovulation_stage == 0 :
		if person.preg.ovulation_stage == 0:
			person.preg.ovulation_stage = round(rand_range(1,2))
		var maxCycle = globals.expansionsettings.livebirthcycle if person.preg.ovulation_type == 1 else globals.expansionsettings.eggcycle
		person.preg.ovulation_day = randi() % int(maxCycle) + 1
		if person.preg.ovulation_day < floor(maxCycle * globals.expansionsettings.fertileduringcycle):
			person.preg.ovulation_stage = 1
		else:
			person.preg.ovulation_stage = 2
	
	globals.traceFile('set random ovulation day')

func forceFullblooded(person):
	if person == null || person.race.find("Halfkin") >= 0:
		return
	
	var onlyrace = genealogy_decoder(person.race)
	
	for race in genealogies:
		if race == onlyrace:
			person.genealogy[race] = 100
		elif person.genealogy[race] > 0:
			person.genealogy[race] = 0


#Depreciated - Pending Removal
func set_race_by_genealogy(person):
	var race = ""
	var genealogy

	var racetype1 = ['human','elf','dark_elf','tribal_elf','orc','ogre','giant','gnome','goblin','kobold','demon','dragonkin','lizardfolk','avali']
	var racetype2 = ['fairy','seraph','dryad','lamia','harpy','arachna','nereid','scylla']
	
	#Humanoids (1)
	for i in racetype1:
		if person.genealogy[i] >= 50:
			race = i.capitalize()
			person.race_type = 1
	if person.genealogy.dark_elf >= 50:
		race = "Dark Elf"
		person.race_type = 1
	if person.genealogy.tribal_elf >= 50:
		race = "Tribal Elf"
		person.race_type = 1
	
	#Uncommons (2)
	for i in racetype2:
		if person.genealogy[i] >= 50:
			race = i.capitalize()
			person.race_type = 2

	#Beasts (0,3)
	if person.genealogy.horse >= 50:
		race = 'Centaur'
		person.race_type = 3
	elif person.genealogy.cow >= 50:
		race = 'Taurus'
		person.race_type = 3
	elif person.genealogy.hyena >= 50:
		race = 'Gnoll'
		person.race_type = 3
	#Beastkin
	elif person.genealogy.bunny >= 70:
		race = 'Beastkin Bunny'
		person.race_type = 3
	elif person.genealogy.dog >= 70:
		race = 'Beastkin Wolf'
		person.race_type = 3
	elif person.genealogy.cat >= 70:
		race = 'Beastkin Cat'
		person.race_type = 3
	elif person.genealogy.fox >= 70:
		race = 'Beastkin Fox'
		person.race_type = 3
	elif person.genealogy.raccoon >= 70:
		race = 'Beastkin Tanuki'
		person.race_type = 3
	elif person.genealogy.mouse >= 70:
		race = 'Beastkin Mouse'
		person.race_type = 3
	elif person.genealogy.squirrel >= 70:
		race = 'Beastkin Squirrel'
		person.race_type = 3
	elif person.genealogy.otter >= 70:
		race = 'Beastkin Otter'
		person.race_type = 3
	elif person.genealogy.bird >= 70:
		race = 'Beastkin Bird'
		person.race_type = 3
	if race in ['','Human']:
		#Halfkin
		if person.genealogy.bunny >= 30:
			race = 'Halfkin Bunny'
			person.race_type = 3
		elif person.genealogy.dog >= 30:
			race = 'Halfkin Wolf'
			person.race_type = 3
		elif person.genealogy.cat >= 30:
			race = 'Halfkin Cat'
			person.race_type = 3
		elif person.genealogy.fox >= 30:
			race = 'Halfkin Fox'
			person.race_type = 3
		elif person.genealogy.raccoon >= 30:
			race = 'Halfkin Tanuki'
			person.race_type = 3
		elif person.genealogy.mouse >= 30:
			race = 'Halfkin Mouse'
			person.race_type = 3
		elif person.genealogy.squirrel >= 30:
			race = 'Halfkin Squirrel'
			person.race_type = 3
		elif person.genealogy.otter >= 30:
			race = 'Halfkin Otter'
			person.race_type = 3
		elif person.genealogy.bird >= 30:
			race = 'Halfkin Bird'
			person.race_type = 3
	
	#Magic (4)
	if person.genealogy.slime >= 30:
		race = 'Slime'
		person.race_type = 4
	
	#Default Human
	if race == '':
		race = 'Human'
		person.race_type = 1
	
	person.race = race
	
	globals.traceFile('set race by genealogy')

#Tweaked by Aric
func set_race_display(person):
	var founddisplay = false
	#Uncommon & Magic Races
	if person.race in ['Fairy','Seraph','Dryad','Lamia','Harpy','Arachna','Nereid','Scylla','Slime']:
		person.race_display = person.race
	
	#Full Blooded
	for i in genealogies_beastfree:
		if person.genealogy[i] >= 70:
			person.race_display = person.race
			founddisplay = true
			break
	
	#Half Blooded
	if founddisplay == false:
		for i in genealogies_beastfree:
			if person.genealogy[i] >= 50 && founddisplay == false:
				person.race_display = "Half " + person.race
				founddisplay = true
			elif person.genealogy[i] >= 50:
				person.race_display += " | Half " + person.race
	
	#Beasts
	if founddisplay == false:
		#Beastkin
		if person.genealogy.horse >= 70:
			person.race_display = 'Centaur'
		elif person.genealogy.cow >= 70:
			person.race_display = 'Taurus'
		elif person.genealogy.hyena >= 70:
			person.race_display = 'Gnoll'
		elif person.genealogy.bunny >= 70:
			person.race_display = 'Beastkin Bunny'
		elif person.genealogy.dog >= 70:
			person.race_display = 'Beastkin Wolf'
		elif person.genealogy.cat >= 70:
			person.race_display = 'Beastkin Cat'
		elif person.genealogy.fox >= 70:
			person.race_display = 'Beastkin Fox'
		elif person.genealogy.raccoon >= 70:
			person.race_display = 'Beastkin Tanuki'
		elif person.genealogy.mouse >= 70:
			person.race_display = 'Beastkin Mouse'
		elif person.genealogy.squirrel >= 70:
			person.race_display = 'Beastkin Squirrel'
		elif person.genealogy.otter >= 70:
			person.race_display = 'Beastkin Otter'
		elif person.genealogy.bird >= 70:
			person.race_display = 'Beastkin Bird'
	
		#Halfkin
		elif person.genealogy.horse >= 50:
			person.race_display = 'Halfkin Centaur'
		elif person.genealogy.cow >= 50:
			person.race_display = 'Halfkin Taurus'
		elif person.genealogy.hyena >= 50:
			person.race_display = 'Halfkin Gnoll'
		elif person.genealogy.bunny >= 50:
			person.race_display = 'Halfkin Bunny'
		elif person.genealogy.dog >= 50:
			person.race_display = 'Halfkin Wolf'
		elif person.genealogy.cat >= 50:
			person.race_display = 'Halfkin Cat'
		elif person.genealogy.fox >= 50:
			person.race_display = 'Halfkin Fox'
		elif person.genealogy.raccoon >= 50:
			person.race_display = 'Halfkin Tanuki'
		elif person.genealogy.mouse >= 50:
			person.race_display = 'Halfkin Mouse'
		elif person.genealogy.squirrel >= 50:
			person.race_display = 'Halfkin Squirrel'
		elif person.genealogy.otter >= 50:
			person.race_display = 'Halfkin Otter'
		elif person.genealogy.bird >= 50:
			person.race_display = 'Halfkin Bird'
	
	#Mixed Blooded
	if founddisplay == false:
		person.race_display = 'Mixed'
	
	globals.traceFile('setracedisplay')
###---End Expansion---###
