
###---Added by Expansion---### Deviate
var animal_races_array = ['bunny','dog','cow','cat','fox','horse','raccoon']
var humanoid_races_array = ['Human','Elf','Dark Elf','Tribal Elf','Orc','Gnome','Goblin','Demon','Dragonkin']
var uncommon_races_array = ['Fairy','Seraph','Dryad','Lamia','Harpy','Arachna','Nereid','Scylla']
var beast_races_array = ['Centaur','Taurus','Beastkin Cat','Beastkin Fox','Beastkin Wolf','Beastkin Bunny','Beastkin Tanuki','Halfkin Cat','Halfkin Fox','Halfkin Wolf','Halfkin Bunny','Halfkin Tanuki']
var magic_races_array = ['Slime']
var races_beastfree_darkelf_free = ['Human','Elf','Dark Elf','Orc','Gnome','Goblin','Demon','Dragonkin','Fairy','Seraph','Dryad','Lamia','Harpy','Arachna','Nereid','Scylla','Slime']
var genealogies = ['human','gnome','elf','tribal_elf','dark_elf','orc','goblin','dragonkin','dryad','arachna','lamia','fairy','harpy','seraph','demon','nereid','scylla','slime','bunny','dog','cow','cat','fox','horse','raccoon']
var genealogies_beastfree = ['human','gnome','elf','tribal_elf','dark_elf','orc','goblin','dragonkin','dryad','arachna','lamia','fairy','harpy','seraph','demon','nereid','scylla','slime',]
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
###---Added by Expansion---###
func newslave(race, age, sex, origins = 'slave'):
	var temp
	var temp2
	var person = globals.person.new()
	if race == 'randomcommon':
		race = globals.getracebygroup("starting")
	elif race == 'randomany':
		race = globals.randomfromarray(globals.allracesarray)
	person.race = race
	person.age = getage(age)
	person.mindage = person.age
	person.sex = sex
	if person.sex == 'random': getrandomsex(person)
	for i in ['cour_base','conf_base','wit_base','charm_base']:
		person.stats[i] = rand_range(35,65)
	person.id = str(globals.state.slavecounter)
	globals.state.slavecounter += 1
	changerace(person, 'Human')
	changerace(person)
	person.work = 'rest'
	person.sleep = 'communal'
	person.sexuals.actions.kiss = 0
	person.sexuals.actions.massage = 0
	globals.assets.getsexfeatures(person)
	if person.race.find('Halfkin') >= 0 || (person.race.find('Beastkin') >= 0 && globals.rules.furry == false):
		person.race = person.race.replace('Beastkin', 'Halfkin')
		person.bodyshape = 'humanoid'
		person.skincov = 'none'
		person.arms = 'normal'
		person.legs = 'normal'
		if rand_range(0,1) > 0.4:
			person.eyeshape = 'normal'
	if globals.rules.randomcustomportraits == true:
		randomportrait(person)
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
	person.health = 1000
	globals.expansionsetup.expandPerson(person)
	###---End Expansion---###
	
	###---Added by Expansion---### Pregnancy Expanded
	set_ovulation(person)
	###---End Expansion---###
	globals.traceFile('newslave')
	
	return person

func randomportrait(person):
	var array = []
	var racenames = person.race.split(" ")
	###---Added by Expansion---### Ank Bugfix v4
	var extensions = ["png","jpg","webp"]
	for i in globals.dir_contents(globals.setfolders.portraits):
		if !i.get_extension() in extensions:
			continue
	###---End Expansion---###
		for k in racenames:
			if i.findn(k) >= 0:
				array.append(i)
				continue
	if array.size() > 0:
		person.imageportait = array[randi()%array.size()]

###---Added by Expansion---### Added by Deviate - Hybrid Races
func newbaby(mother,father):
	var person = globals.newslave(mother.race, 'child', 'female', mother.origins)
	var body_array = ['skin','tail','ears','wings','horns','arms','legs','bodyshape','haircolor','eyecolor','eyeshape','eyesclera']
	var tacklearray = ['penis']
	var temp

	#Prep
	person.race = ''
	person.age = ''
	person.sex = ''

	#General
	person.state = 'fetus'
	person.surname = mother.surname
	
	#Sex
	if globals.rules.male_chance > 0 && rand_range(0, 100) < globals.rules.male_chance:
		person.sex = 'male'
	elif rand_range(0, 100) < globals.rules.futa_chance && globals.rules.futa == true:
		person.sex = 'futanari'
	###---Added by Expansion---### centerflag982 - dickgirls can generate
	elif rand_range(0, 100) < globals.rules.dickgirl_chance && globals.rules.dickgirl == true:
		person.sex = 'dickgirl'
	###---End Expansion---###
	else:
		person.sex = 'female'

	#Age
	if globals.rules.children == true:
		person.age = 'child'
	else: 
		person.age = 'teen'

	#Body
	for i in body_array:
		###---Added by Expansion---### centerflag982 - dickgirls take after their mothers
		if person.sex == 'female' || person.sex == 'dickgirl':
			if rand_range(0,10) > 3:
				person[i] = mother[i]
			else:
				person[i] = father[i]
		###---End Expansion---###
		else:
			if rand_range(0,10) > 3:
				person[i] = father[i]
			else:
				person[i] = mother[i]
	
	#Male Genitals
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
	person.asssize = globals.asssizearray[temp]

	#Dimensional Crystal
	if globals.state.mansionupgrades.dimensionalcrystal >= 2:
		var str_max
		var agi_max
		var maf_max
		var end_max
		if father.stats.str_max >= mother.stats.str_max && father != null:
			str_max = father.stats.str_max
		else:
			str_max = mother.stats.str_max
		if father.stats.agi_max >= mother.stats.agi_max && father != null:
			agi_max = father.stats.agi_max
		else:
			agi_max = mother.stats.agi_max
		if father.stats.maf_max >= mother.stats.maf_max && father != null:
			maf_max = father.stats.maf_max
		else:
			maf_max = mother.stats.maf_max
		if father.stats.end_max >= mother.stats.end_max && father != null:
			end_max = father.stats.end_max
		else:
			end_max = mother.stats.end_max
		if person.stats.str_max < str_max:
			person.stats.str_max += round((str_max-person.stats.str_max)*.6)
		if person.stats.agi_max < agi_max:
			person.stats.agi_max += round((agi_max-person.stats.agi_max)*.6)
		if person.stats.maf_max < maf_max:
			person.stats.maf_max += round((maf_max-person.stats.maf_max)*.6)
		if person.stats.end_max < end_max:
			person.stats.end_max += round((end_max-person.stats.end_max)*.6)

	#Bodyshape
	if person.race.find('Halfkin')>=0 && mother.race.find('Beastkin') >= 0 && father.race.find('Beastkin') < 0:
		person.bodyshape = 'humanoid'
	if father.beautybase > mother.beautybase:
		person.beautybase = father.beautybase + rand_range(-2,5)
	else:
		person.beautybase = mother.beautybase + rand_range(-2,5)
	person.cleartraits()

	var traitpool = father.traits + mother.traits
	for i in traitpool:
		if rand_range(0,100) > variables.traitinheritchance:
			continue
		var trait = globals.origins.trait(i)
		if trait.tags.has('expansiontrait'):
			if trait.tags.has('movetrait') || trait.tags.has('sexualitytrait'):
				continue
			#Increase if Same
			for expansiontraits in globals.expansion.subtraitlines:
				if trait.tags.has(expansiontraits):
					var traitline = globals.expansion[expansiontraits]
					var matchrank = -1
					var newtraitrank
					for ii in traitpool:
						if i == ii && traitpool.count(i) == 1:
							continue
						var trait2 = globals.origins.trait(ii)
						if trait2 != null && trait2.tags.has(traitline):
							matchrank = traitline.find(ii)
					if matchrank >= 0:
						if matchrank > traitline.find(i):
							if rand_range(0,100) <= 50:
								newtraitrank = round( rand_range( traitline.find(i), matchrank)) + 1
							else:
								newtraitrank = round( rand_range( traitline.find(i), matchrank))
						elif matchrank > traitline.find(i):
							if rand_range(0,100) <= 50:
								newtraitrank = round( rand_range( matchrank, traitline.find(i))) + 1
							else:
								newtraitrank = round( rand_range( matchrank, traitline.find(i)))
						else:
							newtraitrank = round( rand_range( matchrank+1, matchrank+2))
					else:
						newtraitrank = round( traitline.find(i) + rand_range(-1,1))
					var newtraitname = traitline[ clamp(newtraitrank, 0, traitline.size()-1) ]
					var newtrait = globals.origins.trait(newtraitname)
					if newtrait != null:
						if newtrait.tags.has('lactation-trait'):
							person.traitstorage.append(newtraitname)
						else:
							person.add_trait(newtraitname)
		else:
			person.add_trait(i)
	
	if rand_range(0,100) <= variables.babynewtraitchance:
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
	setRace(person)
	setRaceDisplay(person)
	set_race_secondary(person)
	
#	if globals.expansionsettings.racialstatbonuses == true:
#		globals.expansionsetup.setRaceBonus(person, true)
	
	#Ovulation
	set_ovulation(person)

	if globals.state.perfectinfo == true && globals.state.mansionupgrades.dimensionalcrystal >= 3:
		mother.metrics.preg += 1
		mother.knowledge.append('currentpregnancy')
	globals.state.babylist.append(person)
	
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
	
	#Set Primary Race
	if person == globals.player || person.unique != null || person.race in magic_races_array || rand_range(0,100) <= globals.expansionsettings.randompurebreedchance:
		random_number = allot_percentage('purebreed')
	elif person.race.find('Halfkin') >= 0 || rand_range(0,100) <= globals.expansionsettings.randommixedbreedchance:
		random_number = allot_percentage('primary_mixed')
	else:
		random_number = allot_percentage('primary')

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
		var entry2
		var samedad = false
		var samemom = false
		var matched_sibling = false
		if !entry.siblings.empty():
			for i in entry.siblings:
				entry2 = relativesdata[i]
				for f in ['father']:
					if int(entry[f]) == int(entry2[f]):
						samedad = true
				for m in ['mother']:
					if int(entry[m]) == int(entry2[m]):
						samemom = true
				if samedad == true && samemom == true || samedad == false && samemom == true || samedad == true && samemom == false:
					var tempPerson2 = globals.state.findslave(entry2.id)
					if tempPerson2 == null:
						continue
					for shared_gene in tempPerson2.genealogy:
						person.genealogy[shared_gene] = tempPerson2.genealogy[shared_gene]
						matched_sibling = true
						break
	
	globals.traceFile('setgenealogy')
	
	return

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
			sametypeweight += round(person.genealogy[temprace]/2)
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
	
	for race in genealogies:
		person.genealogy[race] = round((mother.genealogy[race] + father.genealogy[race]) * .5)
		percent += person.genealogy[race]
	
	while percent != 100:
		percent = build_genealogy_equalize(person, percent)
	globals.traceFile('build genealogy')
	return

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

func setRace(person):
	var currentrace = ""
	var highestpercent = 0
	
	#Pick Highest Genetics
	for race in genealogies:
		if person.genealogy[race] >= highestpercent:
			currentrace = race
			highestpercent = person.genealogy[race]
	
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
		if person.genealogy.horse >= 50:
			person.race = 'Centaur'
		elif person.genealogy.cow >= 50:
			person.race = 'Taurus'
		else:
			#Beastkin/Halfkin Decoder
			if highestpercent >= 70:
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
			person.race = caprace
	else:
		person.race_type = 1
		person.race = "Human"
		print('No Race Found for ' + str(person.full_name) + '. Assigned Human ')
	
	globals.traceFile('Constructor.pickRace Completed')
	return

func setRaceDisplay(person):
	var text = ""
	var primaryrace = ""
	var primaryracepercent = 0
	var secondaryrace = ""
	var secondaryracepercent = 0
	
	#Sort Races
	for race in genealogies:
		if person.genealogy[race] > 0 && person.genealogy[race] >= primaryracepercent:
			#Push Primary to Secondary if Greater
			if primaryracepercent > secondaryracepercent:
				secondaryrace = primaryrace
				secondaryracepercent = primaryracepercent
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
		elif primaryracepercent >= 50:
			text += ' | Half ' + secondaryrace + ''
		else:
			text += ' with ' + secondaryrace + ' features'
	
	if primaryracepercent < 30 && secondaryracepercent < 30:
		text = 'A Total Mutt'
	
	person.race_display = text
	return

#Tweaked by Aric - Only used by newbaby now
func set_race_secondary(person):
	var race_secondary = ''
	var race_secondary_percent = 0
	
	var plaintext_races = ['human','elf','orc','gnome','goblin','demon','dragonkin','fairy','seraph','dryad','lamia','harpy','arachna','nereid','scylla']
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
		race_secondary = 'Halfkin Fox'
		race_secondary_percent = person.genealogy.raccoon

	if race_secondary == '':
		person.race_secondary = 'Full Blooded'
	else:
		person.race_secondary = race_secondary
	
	globals.traceFile('set race secondary')
	
	return

#Tweaked by Aric
func setBabyType(person):
	if person.preg.has_womb == false || person.race_type == 4:
		person.preg.baby_type = 'none'
	elif person.race in ['Dragonkin','Lamia','Harpy','Arachna','Scylla']:
		person.preg.baby_type = 'egg'
	else:
		person.preg.baby_type = 'birth'
	
	globals.traceFile('setbabytype')
	return

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
	return

#Added by Aric
func setRandomOvulationDay(person):
	if person.preg.ovulation_type == 0:
		set_ovulation(person)
	
	if person.preg.ovulation_stage == 0 || person.preg.ovulation_day == 0:
		if person.preg.ovulation_stage == 0:
			person.preg.ovulation_stage = round(rand_range(1,2))
	
		if person.preg.ovulation_day == 0:
			if person.preg.ovulation_type == 1:
				if person.preg.ovulation_stage == 1:
					person.preg.ovulation_day = round(rand_range(1, globals.expansionsettings.livebirthcycle * globals.expansionsettings.fertileduringcycle))
				else:
					person.preg.ovulation_day = round(rand_range(globals.expansionsettings.livebirthcycle * globals.expansionsettings.fertileduringcycle, globals.expansionsettings.livebirthcycle))
			else:
				if person.preg.ovulation_stage == 1:
					person.preg.ovulation_day = round(rand_range(1, globals.expansionsettings.eggcycle * globals.expansionsettings.fertileduringcycle))
				else:
					person.preg.ovulation_day = round(rand_range(globals.expansionsettings.eggcycle * globals.expansionsettings.fertileduringcycle, globals.expansionsettings.eggcycle))
	
	globals.traceFile('set random ovulation day')
	return

func forceFullblooded(person):
	if person == null:
		return
	
	var onlyrace = genealogy_decoder(person.race)
	
	for race in genealogies:
		if race == onlyrace:
			person.genealogy[race] = 100
		elif person.genealogy[race] > 0:
			person.genealogy[race] = 0
	return


#Depreciated - Pending Removal
func set_race_by_genealogy(person):
	var race = ""
	var genealogy

	var racetype1 = ['human','elf','dark_elf','tribal_elf','orc','gnome','goblin','demon','dragonkin']
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
	
	return

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
	
		#Halfkin
		elif person.genealogy.horse >= 50:
			person.race_display = 'Halfkin Centaur'
		elif person.genealogy.cow >= 50:
			person.race_display = 'Halfkin Taurus'
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
	
	#Mixed Blooded
	if founddisplay == false:
		person.race_display = 'Mixed'
	
	globals.traceFile('setracedisplay')
	
	return
###---End Expansion---###
