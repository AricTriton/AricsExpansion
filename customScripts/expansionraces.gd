### <CustomFile> ###

extends Node

var namefile = load("res://files/scripts/characters/names.gd").new()
var names = namefile.names

###---Category: Hybrid Support
func checkHybrid(mom,dad):
	var hybrids = globals.state[hybridraces]
	var momrace = mom
	var dadrace = dad
	var racename
	var exists = false
	if dad == mom:
		exists = true
		return exists
	else:
		dadrace = removeHybridName(dadrace)
		momrace = removeHybridName(momrace)
		if momrace in ['Human']:
			racename = str(dadrace) + "-ish " + str(momrace) + " Halfblood"
			if racename in hybrids:
				exists = true
		elif dadrace in ['Human']:
			racename = str(momrace) + "-ish " + str(dadrace) + " Halfblood"
			if racename in hybrids:
				exists = true
		else:
			if str(str(dadrace) + "-ish " + str(momrace)  + " Hybrid") in hybrids:
				exists = true
			elif str(momrace) + "-ish " + str(dadrace) + " Hybrid" in hybrids:
				exists = true
	return exists

func removeHybridName(race):
	var hybrids = globals.state.hybridraces
	if race in hybrids:
		race = race.replace(' Halfblood','')
		race = race.replace(' Hybrid','')
		race = race.replace('ish','')
	return race

func createHybrid(mom,dad):
	var races = globals.races
	var hybrids = globals.state.hybridraces
	var momrace
	var dadrace
	var newhybridname
	var newskin = []
	var neweyecolor = []
	var newhaircolor = []
	var newsurname
	var newdescription = "Hybrids are often either killed, sold off, or hidden due to their 'weakened bloodlines'. They often look so much like their parent races that they are unnoticable until you have already seen one. "
	var newpricemod = 1
	var newwimbornrace = true
	var newgornrace = true
	var newfrostfordrace = true
	var newbanditrace = true
	var newuncivilized = false
	var newsebastian = false
	var newshade
	var hybriddna = []
	var str_max 
	var agi_max
	var maf_max
	var end_max
	#Get Dad/Mom's Races
	if dad in globals.races:
		dadrace = globals.races.dad
	else:
		dadrace = globals.state.hybrids.races.dad
	if mom in globals.races:
		momrace = globals.races.mom
	else:
		momrace = globals.state.hybrids.races.mom
	#PENDING!!! Check Mom/Dad Race for Hybrid, add DNA % uf so, then calculate the stronger race. If the race combo doesn't exist, make one with the strongest in hybriddna[0].
	#This means that there can be a "Gnomish Elf" and an "Elvish Gnome" (with "Dictionary Change" for the ish). Higher chance of gaining traits from the first.
	
	#Name the New Race
	dad = removeHybridName(dad)
	mom = removeHybridName(mom)
	if mom in ['Human']:
		newhybridname = str(dadrace) + "-ish " + str(mom) + " Halfblood"
	elif dad in ['Human']:
		newhybridname= str(momrace) + "-ish " + str(dad) + " Halfblood"
	else:
		newhybridname = str(dadrace) + "-ish " + str(mom) + " Hybrid"
	#Skin
	for i in dadrace.skin:
		if rand_range(0,1) >= .4:
			newskin.append(i)
	for i in momrace.skin:
		if rand_range(0,1) >= .4:
			newskin.append(i)
	if newskin.size == 0:
		for i in dadrace.skin:
			if rand_range(0,1) >= .25:
				newskin.append(i)
		for i in momrace.skin:
			if rand_range(0,1) >= .25:
				newskin.append(i)
	#Eye Color
	for i in dadrace.eyecolor:
		if rand_range(0,1) >= .4:
			neweyecolor.append(i)
	for i in momrace.eyecolor:
		if rand_range(0,1) >= .4:
			neweyecolor.append(i)
	if neweyecolor.size == 0:
		for i in dadrace.eyecolor:
			if rand_range(0,1) >= .25:
				neweyecolor.append(i)
		for i in momrace.eyecolor:
			if rand_range(0,1) >= .25:
				neweyecolor.append(i)
	#Hair Color
	for i in dadrace.haircolor:
		if rand_range(0,1) >= .4:
			newhaircolor.append(i)
	for i in momrace.haircolor:
		if rand_range(0,1) >= .4:
			newhaircolor.append(i)
	if newhaircolor.size == 0:
		for i in dadrace.haircolor:
			if rand_range(0,1) >= .25:
				newhaircolor.append(i)
		for i in momrace.haircolor:
			if rand_range(0,1) >= .25:
				newhaircolor.append(i)
	#Surname (Whole Lists for Ease)
	if rand_range(0,1) > .6:
		newsurname = dadrace.surname
	else:
		newsurname = momrace.surname
	#Price Mod
	newpricemod = ((dadrace.pricemod+momrace.pricemod)/2)-rand_range(-.5,.5)
	#Racial Additions
	if dadrace.wimbornrace == true && momrace.wimbornrace == true:
		newwimbornrace = true
	elif dadrace.wimbornrace == true || momrace.wimbornrace == true:
		if rand_range(0,1) > .5:
			newwimbornrace = true
		else:
			newwimbornrace = false
	if dadrace.gornrace == true && momrace.gornrace == true:
		newgornrace = true
	elif dadrace.gornrace == true || momrace.gornrace == true:
		if rand_range(0,1) > .5:
			newgornrace = true
		else:
			newgornrace = false
	if dadrace.frostfordrace == true && momrace.frostfordrace == true:
		newfrostfordrace = true
	elif dadrace.frostfordrace == true || momrace.frostfordrace == true:
		if rand_range(0,1) > .5:
			newfrostfordrace = true
		else:
			newfrostfordrace = false
	#Bandit Race
	if dadrace.banditrace == true && momrace.banditrace == true:
		newbanditrace = true
	elif dadrace.banditrace == true || momrace.banditrace == true:
		if rand_range(0,1) > .4:
			newbanditrace = true
		else:
			newbanditrace = false
	#Uncivilized
	if dadrace.uncivilized == true && momrace.uncivilized == true:
		newuncivilized = true
	elif dadrace.uncivilized == true || momrace.uncivilized == true:
		if rand_range(0,1) > .25:
			newuncivilized = true
		else:
			newuncivilized = false
	if dadrace.sebastian == true && momrace.sebastian == true:
		newsebastian = true
	elif dadrace.sebastian == true || momrace.sebastian == true:
		if rand_range(0,1) > .5:
			newsebastian = true
		else:
			newsebastian = false
	#Shade
	if rand_range(0,1) > .6:
		newshade = dadrace.shade
	else:
		newshade = momrace.shade
	#Stats
	str_max = round(((dadrace.str_max+momrace.str_max)/2)+rand_range(-1,1))
	agi_max = round(((dadrace.agi_max+momrace.agi_max)/2)+rand_range(-1,1))
	maf_max = round(((dadrace.maf_max+momrace.maf_max)/2)+rand_range(-1,1))
	end_max = round(((dadrace.end_max+momrace.end_max)/2)+rand_range(-1,1))
	var stats = {str_max=str_max, agi_max=agi_max, maf_max=maf_max, end_max=end_max}
	#Goes last to snag the Stat Details
	var details = str(globals.capitalize(newhybridname)) + "'s are as varied as they come and tend to have all of the strengths and weaknesses of " + str(dad) + "s " + str(mom) + "s.\n\n[color=yellow]Stat potential: Strength - " + str(stats.str_max) + " , Agility - " + str(stats.agi_max) + ", Magic - " + str(stats.maf_max) + ", Endurance - " + str(stats.end_max) + " [/color]"
	
	var newhybrid = {
		newhybridname = {
			skin = newskin,
			eyecolor = neweyecolor,
			haircolor = newhaircolor,
			surname = newsurname,
			description = newdescription,
			details = details,
			pricemod = newpricemod,
			startingrace = false,
			wimbornrace = newwimbornrace,
			gornrace = newgornrace,
			frostfordrace = newfrostfordrace,
			banditrace = newbanditrace,
			uncivilized = newuncivilized,
			sebastian = newsebastian,
			shade = newshade,
			stats = stats
			
			},
	}
	
	hybrids[newhybrid]
	return newhybridname


var hybridraces = {
Human = {
	skin = ['pale', 'fair', 'olive', 'tan'],
	eyecolor = ['blue', 'green', 'brown', 'hazel', 'black', 'gray'],
	haircolor = ['blond', 'red', 'auburn', 'brown', 'black'],
	surname = names.humansurname,
	description = "Humans are a highly successful militaristic people whose members can be found throughout much of the world, their presence often receiving a mixed reception. Slavery is a common part of human society, viewed as a civilized form of alternative punishment, with many laws and businesses based around the concept. Because of this slave driven culture, you have found that humans tend to be the most widely accessible residents, servants, and slaves.",
	details = "[color=aqua]Racial trait: +50% Fear and Obedience during meet interactions.[/color]\n\n[color=yellow]Stat potential: Strength - 5, Agility - 3, Magic - 2, Endurance - 4 [/color]",
	pricemod = 1,
	startingrace = true,
	wimbornrace = true,
	gornrace = true,
	frostfordrace = true,
	banditrace = true,
	uncivilized = false,
	sebastian = false,
	shade = {male = "res://files/buttons/inventory/shades/Human_M.png", female = "res://files/buttons/inventory/shades/Human_F.png"},
	stats = {str_max = 5, 
	agi_max = 3, 
	maf_max = 2, 
	end_max = 4}
},
}
