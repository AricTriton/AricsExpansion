### <CustomFile> ###

###Contains a variety of functions for my mod, AricsExpansion

var person

#---Category: Better NPCs---#
#Chances each action will Proc (if available)
#These chances can be lowered to keep NPCs in a certain State for longer (Slower Gameplay)
var npcactions = {
	workchance = 75,
	npctravelchance = 25,
	defeated = 100,
	raped = 100,
	childbirth = 100,
	recover = 100,
	escapechance = 75,
	hidechance = 75,
	stophiding = 75,
	hunger = 75,
	plancrime = 25,
	robfoodchance = 35,
}

#Used to Store New Fetishes until Implimented
var incompletefetishes = []

#The chance that enemies will be related (if the same race)
var npcrelatedchance = 75
#Chance that Enemies will be the Parent if possible
var parentchance = 85
#Chance that NPCs get stronger when re-encountered
var npclevelupchance = 65

#Chance that NPCs are re-encountered. They gain 1-5% each time they aren't.
var enemyreencounterchancerelease = 5
var enemyreencounterchanceescape = 10
#The potential variation when they are first released. This is randomly -/+, so never set lower than the lowest above variables
var enemyreencountermodifier = 5
#Chance to finish in raped enemies
var chanceimpregnatebaddies = 75
#Chance for enemies to orgasm despite themselves (5*days since last fucked added to this)
var rapedorgasmchance = 65

#---Finding Enemies
#This adds a base modifier to finding an NPC (100 will always return existing NPCs)
var npctrackbonus = 0
#The ID of a specific enemy (if any) to track specific relatives
var trackednpcid = -1

var citiesarray = ['wimborn','gorn','frostford','amberguard']
#Move Shaliq and Umbra later after full backward compatibility
var outskirtsarray = ['wimbornoutskirts','forest','prairie','gornoutskirts','amberguardforest','frostfordoutskirts','shaliq','umbra']
var wildernessarray = ['sea','prairie','elvenforest','grove','marsh','mountains','mountaincave']

#---Category: Lactation---#
var basemilkvalue = 10
#Change to increase breast size if Storage > milkmax
var chancelactationincreasetits = 50
#Chance to stop lactating if unmilked
var chancelactationstops = 5
#Amount that turns into Pressure if left naturally
var milkregenperday = .1

#---Category: Secrets---#
#Chance that they will tell you about Secrets
var secretsharechance = 50


var dignitymin = {'slave' : 5, 'poor' : 6, 'commoner' : 7, 'rich' : 8, 'atypical' : 9, 'noble' : 10}
var dignitymax = {'slave' : 15, 'poor' : 18, 'commoner' : 21, 'rich' : 24, 'atypical' : 27, 'noble' : 30}

#Traitline Arrays
var maintraitlines = ['lactation-trait','fertility-trait']
var subtraitlines = ['storagetrait','regentrait','virilitytrait','eggstrtrait','pliabilitytrait','elasticitytrait']
var mentaltraitarray = ['Ditzy']
var storagetrait = ['Small Milk Glands','Milk Storage 1','Milk Storage 2','Milk Storage 3','Milk Storage 4','Milk Storage 5']
var regentrait = ['Weak Milk Flow','Milk Flow 1','Milk Flow 2','Milk Flow 3','Milk Flow 4','Milk Flow 5']
var virilitytrait = ['Weak Virility','Virility 1','Virility 2','Virility 3','Virility 4','Virility 5']
var eggstrtrait = ['Impenetrable Eggs','Egg Strength 1','Egg Strength 2','Egg Strength 3','Egg Strength 4','Egg Strength 5']
var pliabilitytrait = ['Rigid Pliability','Pliability 1','Pliability 2','Pliability 3','Pliability 4','Pliability 5']
var elasticitytrait = ['Rigid Elasticity','Elasticity 1','Elasticity 2','Elasticity 3','Elasticity 4','Elasticity 5']

#Other Arrays
var moodarray = ['sad','angry','scared','indifferent','obediant','horny','respectful','happy','playful']
#var moodarray = ['sad','sad','sad','neutral','neutral','neutral','happy','happy','happy'] #Explicit Moods (Forced by Events): Crying, Angry, Horny
var demeanorarray = ['meek','shy','reserved','open','excitable']

#Flaws
var vicearray = ['lust','envy','pride','wrath','greed','sloth','gluttony']
var vicedict = {
	lust = "\n\n[color=lime]Vice Discovered![/color]\n$His greatest [color=aqua]vice[/color] is [color=red]Lust[/color]. $His sexuality is far higher than that of the average person and $he enjoys sex more than almost anything else. \n[color=#d1b970]Job Bonus:[/color] $He will be satisfied by [color=aqua]Prostitution[/color], [color=aqua]Escort[/color], and [color=aqua]Fucktoy[/color] jobs. $He will not experience any [color=red]Vice Luxury Penalties[/color] while in those positions. \n[color=#d1b970]Consent Bonus:[/color] $He is more likely to give [color=aqua]Sexual Consent[/color]. \n[color=green]Fucking Bonus:[/color] [color=green]+10 Luxury[/color] if $he was fucked today, whether from $his job or directly by $his master. Recieves [color=green]10 Percent[/color] of $his [color=aqua]Lewdness[/color] as bonus [color=aqua]Luxury[/color] daily. Every day $he isn't fucked reduces the total by [color=red]-3 Luxury[/color] to a maximum penalty of [color=aqua]-20 Luxury[/color] after [color=aqua]6 sexless days[/color].\n[color=#d1b970]Rule Penalty:[/color] Receive [color=red]-5 Luxury[/color] if not fucked that day and ordered not to [color=aqua]masturbate[/color]. ",
	pride = "\n\n[color=lime]Vice Discovered![/color]\n$His greatest [color=aqua]vice[/color] is [color=red]Pride[/color]. $He is incredibly focused on $his own appearance and will feel disheartened if not allowed to maintain $his standards of presentability.\n[color=#d1b970]Job Bonus:[/color] $He will be satisfied by [color=aqua]Headgirl[/color], [color=aqua]Farm Manager[/color], and [color=aqua]Jailor[/color] jobs. $He will not experience any [color=red]Vice Luxury Penalties[/color] while in those positions. $He will additionally gain [color=green]+10 Luxury[/color] while in one of those positions.\n[color=#d1b970]Rule Bonus:[/color] Gain [color=green]+5 Luxury[/color] if $he is allowed [color=aqua]Cosmetics[/color] (using [color=red]1 Additional Supply[/color]) or a [color=aqua]Personal Bath[/color]. $He will lose [color=red]-10 Luxury[/color] if they are not allowed and not in a [color=aqua]satisfying[/color] job. ",
	greed = "\n\n[color=lime]Vice Discovered![/color]\n$His greatest [color=aqua]vice[/color] is [color=red]Greed[/color]. $He is exceptionally materialistic and enjoys having the freedom to spend $his own money.\n[color=#d1b970]Job Bonus:[/color] $He will be satisfied by [color=aqua]Merchant[/color] and [color=aqua]Milk Merchant[/color] jobs. $He will not experience any [color=red]Vice Luxury Penalties[/color] while in those positions. $He will additionally gain [color=green]+10 Luxury[/color] while in one of those positions.\n[color=#d1b970]Rule Bonus:[/color] $He will gain [color=green]+10 Luxury[/color] (using [color=red]5 additional Gold[/color]) while allowed [color=aqua]Pocket Money[/color]. Otherwise, $he will lose [color=red]-10 Luxury[/color] if $he is not in a [color=aqua]satisfying[/color] job. ",
	sloth = "\n\n[color=lime]Vice Discovered![/color]\n$His greatest [color=aqua]vice[/color] is [color=red]Sloth[/color]. $He enjoys rest, relaxation, and is very sensitive to stress.\n[color=#d1b970]Job Bonus:[/color] $He will be satisfied by [color=aqua]Rest[/color] and [color=aqua]Housepet[/color] jobs. $He will not experience any [color=red]Vice Luxury Penalties[/color] while in those positions. $He will additionally gain [color=green]+5 Luxury[/color] while in one of those positions.\n[color=#d1b970]Rule Bonus:[/color] $He will gain [color=green]+5 Luxury[/color] while allowed a [color=aqua]Personal Bath[/color].\n[color=aqua]Relaxation Bonus:[/color] $He will gain [color=green]+10 Luxury[/color] if $he has full [color=aqua]Energy[/color] by the end of the day. $He will also gain  Otherwise, $he will lose [color=red]-5 Luxury[/color] if $he has below [color=aqua]25 Percent[/color] [color=aqua]Energy[/color] and/or over [color=red]over 75%[/color] of $his maximum [color=aqua]Stress[/color]. ",
	gluttony = "\n\n[color=lime]Vice Discovered![/color]\n$His greatest [color=aqua]vice[/color] is [color=red]Gluttony[/color]. $His greatest pleasure is in good food and drink.\n[color=#d1b970]Job Bonus:[/color] $He will be satisfied by the [color=aqua]Cook[/color] job. $He will not experience any [color=red]Vice Luxury Penalties[/color] while in those positions. $He will additionally gain [color=green]+10 Luxury[/color] while in one of those positions.\n[color=#d1b970]Date Bonus:[/color] Food and Drink Interactions will always give the [color=green]best results[/color] on [color=aqua]Dates[/color].\n[color=#d1b970]Rule Bonus:[/color] $He will gain [color=green]+10 Luxury[/color] while allowed [color=aqua]Better Food[/color] (using [color=red]3 additional Food[/color]). Otherwise, $he will lose [color=red]-10 Luxury[/color] if $he is not in a [color=aqua]satisfying[/color] job. ",
	wrath = "\n\n[color=lime]Vice Discovered![/color]\n$His greatest [color=aqua]vice[/color] is [color=red]Wrath[/color]. $He loves the passion of battle and the thrill of combat. However, $he is an oddity among other [color=aqua]Vices[/color] in that $he holds no expectations on you unless you have promised $him a good fight.\n[color=#d1b970]Consent Bonus:[/color] $He is more likely to give [color=aqua]Consent to Fight Alongside You[/color]. However, $he will expect to be granted a good fight regularly once $his consent has been given.\n[color=#d1b970]Job Bonus:[/color] $He will be satisfied by the [color=aqua]Guardian[/color], [color=aqua]Slave-Catcher[/color], [color=aqua]Trainer[/color], and [color=aqua]Trainee[/color] jobs. $He will not experience any [color=red]Vice Luxury Penalties[/color] while in those positions. $He will additionally gain [color=green]+5 Luxury[/color] while in one of those positions.\n[color=#d1b970]Combat Bonus:[/color] $He will gain or lose [color=aqua]Luxury[/color] equal to $his total [color=aqua]Wins[/color] minus the number of days $he has been [color=aqua]Owned[/color] by you to a maximum bonus or penalty of [color=aqua]20[/color]. ",
	envy = "\n\n[color=lime]Vice Discovered![/color]\n$His greatest [color=aqua]vice[/color] is [color=red]Envy[/color]. $He cannot help but compare $himself and $his living conditions to whoever $he considers to be the current favorite slave of the mansion.\n[color=#d1b970]Favored Slave Bonus:[/color] If $he is considered the [color=aqua]favored slave[/color], $he will receive a flat [color=green]+20 Luxury[/color] and ignore all remaining [color=aqua]vice[/color] factors.\n[color=#d1b970]Job Bonus:[/color] $He will be satisfied by the [color=aqua]Headgirl[/color], [color=aqua]Farm Manager[/color], and [color=aqua]Jailer[/color] jobs. $He will not experience any [color=red]Vice Luxury Penalties[/color] while in those positions. $He will additionally gain [color=green]+5 Luxury[/color] while in one of those positions.\n[color=#d1b970]Favored Slave Comparison:[/color] $He will compare $himself with your favored slave on the following factors and gain [color=green]+5 Luxury[/color] if successful or [color=red]-5 Luxury[/color] if not. $He will see if the favored slave is sleeping in [color=aqua]Your Bed[/color] or a [color=aqua]Personal Room[/color] and be envious if $he is not. $He will be envious if $he has [color=aqua]consented[/color] to [color=aqua]sex with you[/color] and the favored slave slept with you more recently than $he has. $He will be envious if the favored slave has [color=aqua]50 Percent[/color] less stress than $he does. Finally, $he will be envious if the favored slave has a higher [color=aqua]Grade[/color] than $he does. $He will receive a maximum [color=aqua]Bonus[/color] or [color=aqua]Penalty[/color] of 20. ",
	none = "\n\n[color=lime]Vice Discovered![/color]\n$He is either in the minority of people who truly have no vice or it has been removed.",
}

var libidoarray = ['prudish','low','average','seductive','nympho']

var mansionjobs = ['rest','forage','hunt','cooking','library','nurse','maid','headgirl','cooking','jailer','labassist']
var townjobs

var identitydict = {
	normal = "I am just normal, everyday me. ",
	husk = "I am blank. I am nothing. My body is nothing. My mind is nothing. ",
	lover = "I am my $master's lover. I love to be there for $master. ",
	lonely = "I am so alone. No one will ever want me or love me. ",
	servant = "I am an obediant servant. I am happy to serve and am treated well. ",
	goodslave = "I am a slave. I need no will of my own, I follow my $master's will. ",
	brokenslave = "I am just a slave. I was forced into this but can never escape. This is my life now. ",
	feral = "I am a feral beast. I am as my ancestors were. ",
	pet = "I am my $master's good pet. I live to make others happy. ",
	livestock = "I am livestock. I exist to bred, milked, and bred again. Why would I need anything else? ",
	nympho = "I am a sexual creation. I love sex and there is nothing better in the world. ",
	fucktoy = "I am just holes to be fucked by others. ",
	eyecandy = "I am beautiful. Nothing matters except others seeing my beauty and me staying beautiful. ",
	hideous = "I am hidious. I am disgusting and no one should have to look at me. ",
	naive = "I am often confused. There is just so much I don't know! I don't know what to think. ",
	curious = "There is so much I don't know about the world. I love learning about it! ",
	jaded = "I have seen it all and done it all. Nothing is left out there to surprise me. ",
	smart = "I know what I'm talking about. People would do well to listen to me. ",
	idiot = "I'm so stupid. I feel like I never know what is going on. ",
	charming = "I am funny and charming. I can fit in anywhere and get along with anyone. ",
	awkward = "I am so gangly and awkward. I feel so out of place constantly. ",
	bold = "I can handle anything that comes at me. I've got this. Bring it on. ",
	cowardly = "I am just a coward. I'm not brave like everyone else, I just am too scared of getting hurt! "
}

#DimCrystal
var dimcrystal_abilities_array = ['attunement','pregnancyspeed','empowervirginity','secondwind','immortality','sacrifice',]

func updatePerson(person):
	#Contains the codes to update 1 person specifically during the game
	#Called from Sex, Interaction, Talk, or End of Day
	#Checks Expanded, Nudity, Swollen Belly, Cum Drip, etc
	var text = ""
	var state = "enslaved"
	var moodmod = 0
	var moodwanted = 'any'

#	#Expand Game if needed: Handled in Load now
#	if globals.state.expansionversion < globals.expansionsettings.modversion:
#		globals.expansionsetup.expandGame()

	globals.state.perfectinfo = globals.expansionsettings.perfectinfo

	#Auto-Combat Consent Trigger
	if person.consentexp.party == false:
		if globals.expansionsettings.uniqueslavesautopartyconsent == true && person.unique != null || person.unique in ['startslave','Cali']:
			person.consentexp.party = true

	#Update Traitlines
	updateSexuality(person)
	updateSexualityImage(person)
	
	updateFertility(person)

	#Update Body
	updateCumProd(person)
	if person.vagina != "none" && person.lubrication == -1:
		#Here as well as Expanded as Vaginas can be added mid-game via Labratory
		globals.expansionsetup.setLubrication(person)

	#Update Fetishes
	setFetishes(person)
	if person.consentexp.incest == true:
		setFetishConsent(person,'incest')
	
	#---Trait Alteration
	setTraitsperFetish(person)

	#---Check for Restraints
	var restrained = "none"
	#Farm Restraints
	if person.sleep == "farm" && person.farmexpanded.restrained == true:
		restrained = 'farmrestraints'
	#HandCuffs item
	for i in person.gear.values():
		if i != null && globals.state.unstackables.has(i):
			var tempitem = globals.state.unstackables[i]
			if tempitem.code in ['acchandcuffs']:
				restrained = "cuffed"
	#Apply Restraints
	person.restrained = restrained

	#Swollen Calculation
	text += str(getSwollen(person))
	text += str(getMovement(person))

	#Change Mood
	var newmood = updateMood(person,moodmod,moodwanted)
	if person.mood != newmood:
		text += "$name is now feeling " + str(newmood)
		person.mood = newmood

#	#Update Relatives Data (Current Name, Current State) (READD Later when functionality)
#	globals.state.relativesdata[person.id].name = person.name_long()
#	if state == "normal":
#		if globals.state.relativesdata[person.id].state != "enslaved":
#			globals.state.relativesdata[person.id].state = "enslaved"
#	else:
#		globals.state.relativesdata[person.id].state = state

#Racial Bonus - True applies, False removes
	if person.npcexpanded.racialbonusesapplied == false && globals.expansionsettings.racialstatbonuses == true:
		globals.expansionsetup.setRaceBonus(person, true)
	elif person.npcexpanded.racialbonusesapplied == true && globals.expansionsettings.racialstatbonuses == false:
		globals.expansionsetup.setRaceBonus(person, false)

	#Change Pic (if Preg or Naked)
	updateBodyImage(person)
	return text

	#Diet Expanded
#	if person.diet == null:
#		person.diet = {dailyneed = 0, hunger = 0, nourishment = {food = 100, milk = 30, cum = 15, piss = 0, blood = 0}}

func updateSexuality(person,shift=0):
	#Update Sexuality (If Needed)
	if shift != 0:
		var num = globals.kinseyscale.find(person.sexuality)
		var resist = 0
		if num in [0,globals.kinseyscale.size()]:
			resist = 10
		elif num in [1,(globals.kinseyscale.size()-1)]:
			resist = 5
		else:
			resist = 2.5
		if shift < 0:
			shift -= shift
		if rand_range(0,10) + shift >= resist:
			person.sexuality = globals.kinseyscale[globals.kinseyscale.find(person.sexuality)+shift]

	#Remove all Sexuality Traits
	for my_traits in person.traits:
		var trait = globals.origins.trait(my_traits)
		if trait.tags.has("sexualitytrait"):
			person.trait_remove(my_traits)
	return

###Old Function Pre-Images. Keeping for Reference | Remove Soon###
func updateSexualityOld(person,shift=0):
	#Update Sexuality (If Needed)
	if shift != 0:
		var num = globals.kinseyscale.find(person.sexuality)
		var resist = 0
		if num in [0,globals.kinseyscale.size()]:
			resist = 10
		elif num in [1,(globals.kinseyscale.size()-1)]:
			resist = 5
		else:
			resist = 2.5
		if shift < 0:
			shift -= shift
		if rand_range(0,10) + shift >= resist:
			person.sexuality = globals.kinseyscale[globals.kinseyscale.find(person.sexuality)+shift]

	#Add Sexuality Trait
	if person.knowledge.has('sexuality'):
		if person.sexuality == 'straight':
			if !person.traits.has("Sexuality: Fully Straight"):
				person.add_trait("Sexuality: Fully Straight")
			#Remove Existing Traits
			for i in person.traits:
				#Check for Existing Traits
				var trait = globals.origins.trait(i)
				if i != ("Sexuality: Fully Straight"):
					if trait.tags.has('sexualitytrait'):
						person.trait_remove(i)
		elif person.sexuality == 'mostlystraight':
			if !person.traits.has("Sexuality: Mostly Straight"):
				person.add_trait("Sexuality: Mostly Straight")
			#Remove Existing Traits
			for i in person.traits:
				#Check for Existing Traits
				var trait = globals.origins.trait(i)
				if i != ("Sexuality: Mostly Straight"):
					if trait.tags.has('sexualitytrait'):
						person.trait_remove(i)
		elif person.sexuality == 'rarelygay':
			if !person.traits.has("Sexuality: Occassionally Gay"):
				person.add_trait("Sexuality: Occassionally Gay")
			#Remove Existing Traits
			for i in person.traits:
				#Check for Existing Traits
				var trait = globals.origins.trait(i)
				if i != ("Sexuality: Occassionally Gay"):
					if trait.tags.has('sexualitytrait'):
						person.trait_remove(i)
		elif person.sexuality == 'bi':
			if !person.traits.has("Sexuality: Truly Bisexual"):
				person.add_trait("Sexuality: Truly Bisexual")
			#Remove Existing Traits
			for i in person.traits:
				#Check for Existing Traits
				var trait = globals.origins.trait(i)
				if i != ("Sexuality: Truly Bisexual"):
					if trait.tags.has('sexualitytrait'):
						person.trait_remove(i)
		elif person.sexuality == 'rarelystraight':
			if !person.traits.has("Sexuality: Occassionally Straight"):
				person.add_trait("Sexuality: Occassionally Straight")
			#Remove Existing Traits
			for i in person.traits:
				#Check for Existing Traits
				var trait = globals.origins.trait(i)
				if i != ("Sexuality: Occassionally Straight"):
					if trait.tags.has('sexualitytrait'):
						person.trait_remove(i)
		elif person.sexuality == 'mostlygay':
			if !person.traits.has("Sexuality: Mostly Gay"):
				person.add_trait("Sexuality: Mostly Gay")
			#Remove Existing Traits
			for i in person.traits:
				#Check for Existing Traits
				var trait = globals.origins.trait(i)
				if i != ("Sexuality: Mostly Gay"):
					if trait.tags.has('sexualitytrait'):
						person.trait_remove(i)
		elif person.sexuality == 'gay':
			if !person.traits.has("Sexuality: Fully Gay"):
				person.add_trait("Sexuality: Fully Gay")
			#Remove Existing Traits
			for i in person.traits:
				#Check for Existing Traits
				var trait = globals.origins.trait(i)
				if i != ("Sexuality: Fully Gay"):
					if trait.tags.has('sexualitytrait'):
						person.trait_remove(i)
	else:
		for i in person.traits:
			#Check for Existing Traits
			var trait = globals.origins.trait(i)
			if trait.tags.has('sexualitytrait'):
				person.trait_remove(i)
	
	#Update Bisexual/Homosexual Traits
	if globals.kinseyscale.find(person.sexuality) >= 5:
		if !person.traits.has('Homosexual'):
			person.add_trait('Homosexual')
			if person.traits.has('Bisexual'):
				person.trait_remove('Bisexual')
	elif globals.kinseyscale.find(person.sexuality) >= 2 && globals.kinseyscale.find(person.sexuality) <= 4:
		if !person.traits.has('Bisexual'):
			person.add_trait('Bisexual')
			if person.traits.has('Homosexual'):
				person.trait_remove('Homosexual')
	else:
		for i in ['Homosexual','Bisexual']:
			if person.traits.has(i):
				person.trait_remove(i)
	return
###Old Function End###

func setFetishConsent(person,fetish):
	if globals.fetishopinion.find(person.fetish[fetish]) <= globals.fetishopinion.size()-4:
		person.fetish[fetish] = globals.fetishopinion[globals.fetishopinion.size()-3]

func updateCumProd(person):
	var number = 0
	if person.balls != "none" && person.balls != null:
		number = globals.penissizearray.find(person.balls)
		person.pregexp.cumprod = number+1
	elif person.sex == 'futanari' && globals.rules.futaballs == false:
		person.pregexp.cumprod = round(globals.expansionsettings.futacumproductionamt)

func updateMood(person,modifier=0,wanted='any'):
	var mood = person.mood

	if modifier != 0:
		person.moodnum += modifier
	var moodnum = person.moodnum
	var mind = person.mind

	if moodnum > 0:
		#Positive Moods
		if wanted != 'any' && wanted in ['happy','respectful','horny','playful']:
			mood = wanted
		else:
			if rand_range(0,1) > .5:
				if person.lust >= person.loyal || mind.lewd + (person.lust*.1) >= (mind.respect+mind.humiliation)*.5:
					mood = 'horny'
				else:
					mood = 'respectful'
			else:
				var playful = 0
				if person.age in ['teen','child'] || person.mindage == 'child':
					playful += 1
				if person.stress < 50:
					playful += 1
				if person.race.find('Beastkin') >= 0 || person.race.find('Halfkin') >= 0 || person.bodyshape == 'shortstack':
					playful += 1
				if playful > rand_range(0,3):
					mood = 'playful'
				else:
					mood = 'happy'

	elif moodnum < 0:
		#Negative Moods
		if wanted != 'any' && wanted in ['sad','angry','scared']:
			mood = wanted
		else:
			if rand_range(0,1) > .5:
				var scared = 0
				if mood == 'scared':
					scared += 2
				if person.height in ['tiny','petite']:
					scared += 1
				if person.age == 'child' || person.mindage == 'child':
					scared += 1
				if person.bodyshape == 'shortstack':
					scared += 1
				if person.fear+(scared*10) >= person.metrics.ownership+(person.cour*.1):
					mood = 'scared'
				else:
					mood = 'sad'
			else:
				var angry = 0
				if mood == 'angry':
					angry += 2
				if person.mind.flaw == 'wrath':
					angry += 1
				if person.stress > 80:
					angry += 1
				if mind.humiliation >= ((mind.respect+mind.lewd)*.5):
					angry += 1
				if angry > rand_range(0,3):
					mood = 'angry'
				else:
					mood = 'sad'
	else:
		#Neutral Moods
		if wanted != 'any' && wanted in ['indifferent','obediant','calm']:
			mood = wanted
		else:
			if person.obed >= rand_range(0,50) + 50:
				mood = 'obediant'
			elif rand_range(0,1) > 0:
				mood = 'indifferent'
			else:
				mood = 'calm'
	return mood

#---Setting the Stats---###

#"Check" functions are intended to run often to (during UpdatePerson) to see if a Get is needed
#"Get" functions are intended to run Often to update the Stats
#"Daily" functions are intended to run once per Day

#---Fetishes | How to refer to Fetishes || Add Self.Dict
var fetishDescriptions = {
	incest = "incest",
	lactation = "lactating",
	drinkmilk = "drinking a sentient woman's $milk",
	bemilked = "having your $breasts milked",
	milking = "milking someone else's $breasts",
	exhibitionism = "being $naked in public",
	drinkcum = "drinking $cum",
	wearcum = "having $cum on your body",
	wearcumface = "having $cum on your face",
	creampiemouth = "having a mouth filled with $cum",
	creampiepussy = "having a $pussy filled with $cum",
	creampieass = "having an $ass filled with $cum",
	pregnancy = "$impregnated",
	oviposition = "being filled with eggs",
	drinkpiss = "drinking piss",
	wearpiss = "having piss on your body",
	pissing = "pissing on someone else",
	otherspissing = "seeing others pissing",
	bondage = "being $bound",
	dominance = "being in control",
	submission = "giving up control",
	sadism = "inflicting pain",
	masochism = "feeling pain",
	transformation = "having your body changed",
}

func getFetishDescription(value):
	var text = fetishDescriptions.get(value)
	if text != null:
#		text = text.split('|',true)
#		text = text[rand_range(0,text.size())]
		text = text.replace('$cum', nameCum())
		text = text.replace('$breasts', nameTits())
		text = text.replace('$naked', nameNaked())
		text = text.replace('$pussy', namePussy())
		text = text.replace('$ass', nameAsshole())
		text = text.replace('$impregnated', nameBeingBred())
		text = text.replace('$bound', nameBound())
		text = text.replace('$milk', 'milk')
	else:
		text = "[color=red]Error at getting description for " + value + "[/color]. "
	return text

func setFetishes(person):
	#Sets Fetishes
	var fetishdict = person.fetish
	var temp
	for i in globals.fetishesarray:
		if !fetishdict.has(i):
			fetishdict[i] = "none"
		if fetishdict[i] == "none" || fetishdict[i] == null:
			temp = rand_range(0,globals.fetishopinion.size()-2)
			#Racial Additions
			if person.findRace(['Taurus']) && (str(i) == 'lactation' || str(i) == 'bemilked'):
				temp += round(rand_range(0,2))
			elif person.findRace(['Goblin','Bunny']) && str(i) == 'pregnancy':
				temp += round(rand_range(0,2))
			elif person.findRace(['Cat']) && str(i) in ['drinkcum','drinkmilk']:
				temp += round(rand_range(0,2))

			fetishdict[i] = globals.getfromarray(globals.fetishopinion,temp)

	#Incest Consent: Prompts her conversation to ask about adding or removing Incest
	if !person.dailyevents.has('incestconsentchecked'):
		if person.consentexp.incest == false && globals.fetishopinion.find(fetishdict.incest) >= globals.fetishopinion.size()-3 && rand_range(0,1) >= .75:
			person.dailytalk.append('incestconsentgiven')
			person.dailyevents.append('incestconsentchecked')
		elif person.consentexp.incest == true && fetishdict.incest == "taboo" && rand_range(0,1) >= .5:
			person.dailytalk.append('consentincestremoved')
			person.dailyevents.append('incestconsentchecked')
		else:
			person.dailyevents.append('incestconsentchecked')

func checkCapacity(person, size):
	var capacity = 0
	if size == 'tiny':
		capacity = round(person.send/2 + 1)
	elif size == 'tight':
		capacity = round(person.send/2 + 3)
	elif size == 'average':
		capacity = round(person.send/2 + 5)
	elif size == 'loose':
		capacity = round(person.send/2 + 7)
	elif size == 'gaping':
		capacity = round(person.send/2 + 9)
	if capacity < 1:
		capacity = 0
	return capacity

#Traitline Checks
func checkTraitline(person):
	var text = ""
	var variable = 0
	#Add/Remove Lactation Trait-Line
	if person.lactation == true || person.lactation.hyperlactation == true:
		if person.existingtraitlines.has('lactation') == false:
			globals.expansionsetup.setLactation(person)
	else:
		if person.traits.has("Lactating"):
			person.trait_remove("Lactating")
			person.existingtraitlines.erase('lactation')
		for i in person.traits:
			var trait = globals.origins.trait(i)
			if trait.tags.has('lactation-trait'):
				person.traitstorage.append(trait)
				person.trait_remove(trait)

func updateFertility(person):
	for traitname in person.traits:
		var trait = globals.origins.trait(traitname)
		var clamper = 0
		#Set Pliability
		if trait.tags.has('pliabilitytrait'):
			clamper = pliabilitytrait.find(traitname)
			clamper = clamp(clamper,0,pliabilitytrait.size()-1)
			person.sexexpanded.pliability = clamper
		#Set Elasticity
		if trait.tags.has('elasticitytrait'):
			clamper = elasticitytrait.find(traitname)
			clamper = clamp(clamper,0,elasticitytrait.size()-1)
			person.sexexpanded.elasticity = clamper
		#Set Virility Traitline
		if trait.tags.has('fertility-trait') && trait.tags.has('virilitytrait'):
			if trait.tags.has('rank5'):
				person.pregexp.virility = 5
			elif trait.tags.has('rank4'):
				person.pregexp.virility = 4
			elif trait.tags.has('rank3'):
				person.pregexp.virility = 3
			elif trait.tags.has('rank2'):
				person.pregexp.virility = 2
			elif trait.tags.has('rank1'):
				person.pregexp.virility = 1.5
			elif trait.tags.has('negative-trait'):
				person.pregexp.virility = .5
		#Set Egg Strength Traitline
		if trait.tags.has('fertility-trait') && trait.tags.has('eggstrtrait'):
			if trait.tags.has('rank5'):
				person.pregexp.eggstr = 2
			elif trait.tags.has('rank4'):
				person.pregexp.eggstr = 1.8
			elif trait.tags.has('rank3'):
				person.pregexp.eggstr = 1.6
			elif trait.tags.has('rank2'):
				person.pregexp.eggstr = 1.4
			elif trait.tags.has('rank1'):
				person.pregexp.eggstr = 1.2
			elif trait.tags.has('negative-trait'):
				person.pregexp.eggstr = .5

#Ranks Up a specified Traits Abilities
func updateTraitline(person,traitline,number=1):
	#Increases/Decreases a Traitline
	var traitnumber = 0
	var found = false
	var rank
	var newtrait
	if globals.expansion[traitline] == null:
		return
	else:
		traitline = globals.expansion[traitline]
	for i in person.traits:
		var trait = globals.origins.trait(i)
		if trait.tags.has(traitline):
			found = true
			rank = traitline.find(i)+number
			rank = clamp(rank,0,5)
			newtrait = traitline[rank]
			person.add_trait(newtrait)
			person.trait_remove(i)
	#If Non-Existant, Add
	if found == false:
		rank = clamp(number,0,5)
		if number <= 0:
			newtrait = traitline[0]
		else:
			newtrait = traitline[rank]
		person.add_trait(newtrait)

#Checks for Relation for Incest Checks
func relatedCheck(person, person2):
#Assign IDs if none
	if person.id == null:
		person.id = int(globals.state.slavecounter)
		globals.state.slavecounter += 1
	if person2.id == null:
		person2.id = int(globals.state.slavecounter)
		globals.state.slavecounter += 1
#Pull Relative Data to be called
	if !globals.state.relativesdata.has(person.id):
		globals.createrelativesdata(person)
	var persondata = globals.state.relativesdata[person.id]
	if !globals.state.relativesdata.has(person2.id):
		globals.createrelativesdata(person2)
	var person2data = globals.state.relativesdata[person2.id]
	if persondata == null || person2data == null:
		return 'unrelated'
#Check Relatives
	for i in ['mother','father']:
		#Meaning that Person 1 is the Child of Person 2
		if str(person2data[i]) == str(persondata.id):
			return 'son' if person2.sex == 'male' else 'daughter'
		#Person 1 is the Parent of Person 2
		if str(persondata[i]) == str(person2data.id):
			return i
	if persondata.siblings.has(person2data.id) || persondata.halfsiblings.has(person2data.id):
		return 'brother' if person2.sex == 'male' else 'sister'
	return 'unrelated'

func setFamily(person,person2):
	#Person 2 joins Person 1's family
	var persondata
	var person2data
	var tempperson
	var temppersondata
	var sharedrelative
	var isparent = false
	var parents
	var bonusmin = 0
	var bonusmax = 0
	var relationlottery = 0
	var agearray = ['child','teen','adult']
	if person == null || person2 == null:
		return
	#Give ids if needed
	if person.id == null:
		person.id = int(globals.state.slavecounter)
		globals.state.slavecounter += 1
	if person2.id == null:
		person2.id = int(globals.state.slavecounter)
		globals.state.slavecounter += 1
	#Pull Relative Data to be called
	if !globals.state.relativesdata.has(person.id):
		globals.createrelativesdata(person)
	persondata = globals.state.relativesdata[person.id]
	if !globals.state.relativesdata.has(person2.id):
		globals.createrelativesdata(person2)
	person2data = globals.state.relativesdata[person2.id]
	#Age Difference
	if agearray.find(person.age) > agearray.find(person2.age) && rand_range(0,100) <= parentchance:
		#Parent
		if person.sex in ['female','futanari'] && str(person2data.mother) == str(-1):
			globals.connectrelatives(person, person2, 'mother')
			bonusmin = -200
			bonusmax = 900
			isparent = true
		elif person.sex in ['male','futanari','dickgirl'] && str(person2data.father) == str(-1):
			globals.connectrelatives(person, person2, 'father')
			bonusmin = -200
			bonusmax = 900
			isparent = true
	if isparent == true:
		#Name them
		if !persondata.children.empty():
			for i in persondata.children:
				tempperson = globals.state.findslave(i)
				if tempperson == null:
					continue
				temppersondata = globals.state.relativesdata[i]
				if str(temppersondata['father']) == str(person.id):
					parents = 'mother'
				elif str(temppersondata['mother']) == str(person.id):
					parents = 'father'
				if tempperson.surname != null && person.surname != null:
					if tempperson.surname != person.surname && str(temppersondata[parents]) == str(-1):
						tempperson.surname = person.surname
				else:
					if tempperson.surname != null:
						tempperson.surname = person.surname
				if str(person2data[parents]) != str(-1) && str(temppersondata[parents]) == str(-1):
					sharedrelative = globals.state.findslave(person2data[parents])
					globals.connectrelatives(sharedrelative, tempperson, parents)
					bonusmin = -200
					bonusmax = 900
					relationlottery = round(rand_range(bonusmin,bonusmax))
					globals.addrelations(tempperson, sharedrelative, relationlottery)
		#Siblings Instead
	else:
		globals.connectrelatives(person, person2, 'sibling')
		bonusmin = -200
		bonusmax = 900
		for parent in ['father','mother']:
			if str(person2data[parent]) == str(-1) && str(persondata[parent]) != str(-1):
				sharedrelative = globals.state.findslave(persondata[parent])
				globals.connectrelatives(sharedrelative, person2, parent)
				bonusmin = -200
				bonusmax = 900
				relationlottery = round(rand_range(bonusmin,bonusmax))
				globals.addrelations(person2, sharedrelative, relationlottery)
			elif str(person2data[parent]) != str(-1) && str(persondata[parent]) == str(-1):
				sharedrelative = globals.state.findslave(person2data[parent])
				globals.connectrelatives(sharedrelative, person, parent)
				bonusmin = -200
				bonusmax = 900
				relationlottery = round(rand_range(bonusmin,bonusmax))
				globals.addrelations(person, sharedrelative, relationlottery)

	#Rename 2 Primaries and Mother
	if str(persondata.father) != str(-1) && str(persondata.mother) != str(-1):
		tempperson = globals.state.findslave(persondata['father'])
		if tempperson != null:
			sharedrelative = globals.state.findslave(persondata['mother'])
			person.surname = tempperson.surname
			person2.surname = tempperson.surname
			sharedrelative.surname = tempperson.surname
		else:
			person2.surname = person.surname
			if sharedrelative != null:
				sharedrelative.surname = tempperson.surname
	elif str(persondata.father) != str(-1) && str(persondata.mother) == str(-1) || str(persondata.father) == str(-1) && str(persondata.mother) != str(-1):
		if str(persondata.father) == str(-1):
			tempperson = globals.state.findslave(persondata['mother'])
		else:
			tempperson = globals.state.findslave(persondata['father'])
		if tempperson != null:
			person.surname = tempperson.surname
			person2.surname = tempperson.surname
		else:
			person2.surname = person.surname
	else:
		person2.surname = person.surname

	#Share with Siblings
	if isparent == false:
		if !persondata.siblings.empty() || !person2data.siblings.empty():
			for i in persondata.siblings + person2data.siblings:
				if str(i) != str(person.id) && str(i) != str(person2.id):
					tempperson = globals.state.findslave(i)
					if tempperson == null:
						continue
					temppersondata = globals.state.relativesdata[str(i)]
					for parent in ['father','mother']:
						if str(persondata[parent]) != str(-1) && str(temppersondata[parent]) == str(-1):
							sharedrelative = globals.state.findslave(persondata[parent])
							globals.connectrelatives(sharedrelative, tempperson, parent)
							bonusmin = -200
							bonusmax = 900
							relationlottery = round(rand_range(bonusmin,bonusmax))
							globals.addrelations(tempperson, sharedrelative, relationlottery)
						if !tempperson in globals.slaves:
							tempperson.surname = person.surname
	else:
		if !person2data.siblings.empty():
			for i in person2data.siblings:
				if str(i) != str(person2.id):
					tempperson = globals.state.findslave(i)
					if tempperson == null:
						continue
					temppersondata = globals.state.relativesdata[str(i)]
					for parent in ['father','mother']:
						if str(person2data[parent]) != str(-1) && str(temppersondata[parent]) == str(-1):
							sharedrelative = globals.state.findslave(person2data[parent])
							globals.connectrelatives(sharedrelative, tempperson, parent)
							bonusmin = -200
							bonusmax = 900
							relationlottery = round(rand_range(bonusmin,bonusmax))
							globals.addrelations(tempperson, sharedrelative, relationlottery)
						if !tempperson in globals.slaves:
							tempperson.surname = person.surname

#-----Match Genes
var genealogies = ['human','gnome','elf','tribal_elf','dark_elf','orc','goblin','dragonkin','dryad','arachna','lamia','fairy','harpy','seraph','demon','nereid','scylla','slime','bunny','dog','cow','cat','fox','horse','raccoon']

func correctGenes(person):
	var persondata
	var percent = 0
	var father
	var mother
	var person2
	#Don't Change Previously Met NPCs
	for check_met_before in ['timesfought', 'timesrescued', 'timesescaped']:
		if person.npcexpanded[check_met_before] > 0:
			return
	if person in globals.slaves:
		return
	#Pull Relative Data | End if None Exists
	if globals.state.relativesdata.has(person.id):
		persondata = globals.state.relativesdata[person.id]
	else:
		return
	#Check if Both Parents, then first Sibling, then just one parent
	if str(persondata['father']) != str(-1) && str(persondata['mother']) != str(-1):
		father = globals.state.findslave(persondata['father'])
		mother = globals.state.findslave(persondata['mother'])
	if father != null && mother != null:
		for race in genealogies:
			person.genealogy[race] = round((mother.genealogy[race] + father.genealogy[race]) * .5)
			percent += person.genealogy[race]
	elif !persondata.siblings.empty():
		for trysibling in persondata.siblings:
			person2 = globals.state.findslave(trysibling)
			if person2 == null:
				continue
			for race in genealogies:
				person.genealogy[race] = person2.genealogy[race]
				percent += person.genealogy[race]
			break
	else:
		for parent in ['father','mother']:
			if str(persondata[parent]) != str(-1) && str(persondata[parent]) != null:
				for race in genealogies:
					person2 = globals.state.findslave(persondata[parent])
					if person2 == null:
						continue
					person.genealogy[race] = person2.genealogy[race]
					percent += person.genealogy[race]
				break
	
	if percent > 0:
		while percent != 100:
			percent = globals.constructor.build_genealogy_equalize(person, percent)
		globals.constructor.setRaceDisplay(person)

###---Conversations---###

#Called in main hub of talk only
func getLocation(person):
	var choices = []

	###
	if person.sleep == 'your':
		choices.append('You find [color=aqua]$name[/color] in your bedroom.')
		choices.append('You find [color=aqua]$name[/color] coming out of your bedroom.')
		choices.append('You summon [color=aqua]$name[/color] to your bedroom.')
		choices.append('You find [color=aqua]$name[/color] resting in your shared bedroom.')
	elif person.sleep == 'personal':
		choices.append('You find [color=aqua]$name[/color] in $his bedroom.')
		choices.append('You find [color=aqua]$name[/color] coming out of $his bedroom.')
		choices.append('You summon [color=aqua]$name[/color] to you from $his bedroom.')
		choices.append('You find [color=aqua]$name[/color] resting in $his private bedroom.')
	elif person.sleep == 'communal':
		choices.append('You find [color=aqua]$name[/color] in the barracks.')
		choices.append('You find [color=aqua]$name[/color] coming out of the barracks.')
		choices.append('You summon [color=aqua]$name[/color] to the entrance to the barracks.')
		choices.append('You find [color=aqua]$name[/color] resting in $his bunk in the barracks.')
	###Work Locations
	if person.work in mansionjobs:
		choices.append('You stop [color=aqua]$name[/color] in the middle of the mansion as $he prepares for $his daily work.')
		choices.append("You stop [color=aqua]$name[/color] in one of the mansion's hallways as $he prepares for $his daily work.")
		choices.append('You find [color=aqua]$name[/color] in the middle of the mansion as $he prepares for $his chores.')
		choices.append("You find [color=aqua]$name[/color] in one of the mansion's hallways as $he prepares for $his chores.")
	else:
		choices.append('You stop [color=aqua]$name[/color] outside as $he prepares for $his daily work.')
		choices.append("You stop [color=aqua]$name[/color] outside of the mansion as $he prepares for $his daily work.")
		choices.append('You find [color=aqua]$name[/color] outside as $he prepares for $his daily chores.')
		choices.append("You find [color=aqua]$name[/color] outside of the mansion as $he prepares for $his daily chores.")
	if person.sleep == 'jail':
		choices.clear()
		if person.restrained == "none":
			choices.append("You find [color=aqua]$name[/color] walking around $his cell.")
			choices.append("You find [color=aqua]$name[/color] leaning against the wall of $his cell.")
			choices.append("You find [color=aqua]$name[/color] sleeping in $his cell. You give $him a moment to get up.")
		elif person.restrained == "cuffed":
			choices.append("You find [color=aqua]$name[/color] walking around $his cell with $his hands cuffed behind $his back.")
			choices.append("You find [color=aqua]$name[/color] leaning against the wall of $his cell uncomfortably due to the handcuffs on $his wrists.")
			choices.append("You find [color=aqua]$name[/color] sleeping in $his cell. Watching $him get up is almost pitiful as $he struggles to $his feet without having use of $his hands.")
		elif person.restrained == "shackled":
			choices.append("You find [color=aqua]$name[/color] sitting in $his cell with $his legs shackled to the wall.")
			choices.append("You find [color=aqua]$name[/color] leaning against the wall of the cell $he is shackled to.")
			choices.append("You find [color=aqua]$name[/color] sleeping in $his cell. $He wakes up and shifts as best $he can with $his shackles to face you.")
		elif person.restrained == "fully":
			choices.append("You find [color=aqua]$name[/color] helplessly barred against $his cell's walls.")
			choices.append("You find [color=aqua]$name[/color] strapped against the wall of $his cell, unable to move.")
			choices.append("You find [color=aqua]$name[/color] sleeping in $his restraints against the wall of $his cell. You wake $him up and enjoy the minimal movement $he can make to wake up.")
		elif person.restrained == "fullyexposed":
			choices.append("You find [color=aqua]$name[/color] helplessly barred against $his cell's walls. $He is being held open so $his " + str(getGenitals(person)) + " are exposed for all to see.")
			choices.append("You find [color=aqua]$name[/color] strapped against the wall of $his cell, unable to move. $He is being held open so $his " + str(getGenitals(person)) + " are exposed for anyone in the cells to see.")
			choices.append("You find [color=aqua]$name[/color] sleeping in $his restraints against the wall of $his cell. You enoy watching $his exposed " + str(getGenitals(person)) + " twitch as $he groggily wakes up, barely able to move.")
	elif person.sleep == 'farm':
		if person.work == 'cow':
			choices.append("You find [color=aqua]$name[/color] in the farm. $His " + nameTits() + " are swollen and $his nipples are leaking as you walk up.")
			choices.append("You find [color=aqua]$name[/color] in the farm. $He is preparing to slide the pumps onto $his swollen nipples as you approach.")
			choices.append("You find [color=aqua]$name[/color] in the farm. $He is massaging $his swollen " + nameTits() + " and watching milk drip out of $his nipples with fascination.")
			choices.append("You find [color=aqua]$name[/color] in the farm. $He is sucking on $his " + nameTits() + ". $He sees you approach and releases it, accidentally spilling some milk out of $his drooling lips.")
		elif person.work == 'hen':
			choices.append("You find [color=aqua]$name[/color] in the farm. $He is rubbing $his swollen belly that is squirming with hatched life within.")
			choices.append("You find [color=aqua]$name[/color] in the farm. As you approach, you see the last tendril of a slug slide from $his stretched " + namePussy())
			choices.append("You find [color=aqua]$name[/color] in the farm. $He is on all fours pushing violently as something slides out of $him. You give $him a moment to catch $his breath, watching him rub $his sore, dripping " + namePussy()+ " and then approach.")
	elif person.work == 'farmmanager':
		choices.append("You find [color=aqua]$name[/color] in the farm, prepping the milking jugs, buckets, and pumps for the day's activities.")
		choices.append("You find [color=aqua]$name[/color] in the farm, scrubbing the milking jugs, buckets, and pumps from yesterday's activities.")
		choices.append("You find [color=aqua]$name[/color] in the farm, cleaning the stalls from the piss and shit of the cattle and hens.")
		choices.append("You find [color=aqua]$name[/color] in the farm. $He is drinking from a white bottle as you approach. $He stops and pulls the bottle away, leaving a small white ring around $his lips and chin.")
	return " " + globals.randomitemfromarray(choices)

#---Dialogue Expressions---#
func getIntro(person):
	#Add in Extra Effects (CumDrip, etc) after "." before "\n"
	#From here, it goes to expression.getIntro(person) + person.quirk("[color=yellow]-" +talk.getIntroDialogue(person)+ "[/color]")
	var text = "[color=aqua]$name[/color] " + str(getExpression(person))
	if rand_range(0,1) > .35:
		text += str(getMovementText(person))+ ".\n"
	else:
		text += ".\n"
	#Entrancement
	var effect = globals.effectdict.entranced.duplicate()
	if person.effects.has(effect.code):
		text += "\n$His eyes are "+ globals.randomitemfromarray(['dialated','slowly spinning','half-closed','drifting lazily','glazed over','unable to focus on anything','crossed slightly','listless','glowing faintly']) +" and $he is obviously [color=aqua]entranced[/color]. $He will accept the next thing $he is told as truth without question or argument.\n"
	return text

func getExpression(person):
	#Common usage is "[color=green]$name[/color] " + getExpression + " at you"
	var text = ""
	if person.mood == "happy":
		if person.restrained in ['cuffed','shackled']:
			text += globals.randomitemfromarray(['puts $his '+str(person.restrained)+' arms in front of him for you to inspect, then','shakes $his '+str(person.restrained)+'s good-naturedly, then'])
		text += globals.randomitemfromarray(['smiles','grins','gleams','smiles brightly','smiles eagerly','brightens up'])
	elif person.mood == "sad":
		text += globals.randomitemfromarray(['frowns','grimaces','droops and looks','pouts'])
	elif person.mood == "scared":
		text += globals.randomitemfromarray(['sobs','sniffs','coughs','cries','whines','whimpers'])
	elif person.mood == "angry":
		text += globals.randomitemfromarray(['grimaces','grits $his teeth','snarls','sneers','glares'])
	elif person.mood == "horny":
		text += globals.randomitemfromarray(['bites $his lip','licks $his lips','looks lustfully','blushes','breathily moans','looks invitingly'])
	elif person.mood == "playful":
		text += globals.randomitemfromarray(['smiles','grins','gleams','smiles playfully','bounces slightly from side to side and smiles','fidgets eagerly while smiling'])
	elif person.mood == "obediant":
		text += globals.randomitemfromarray(['bows $his head and looks up','meekly looks','submissively bows then looks','puts $his arms behind $his head then glances up'])
	else:
		text += globals.randomitemfromarray(['looks blankly','stares','looks blankly','neutrally glances']) #Change Neutral to use Demeanor
	text += globals.randomitemfromarray([' towards you',' at you'])
	return text

func getMovementText(person):
	var text = " while "
	if person.movement == "flying":
		text += globals.randomitemfromarray(['fluttering around','hovering around','buzzing in the air','flitting about','flying'])
	elif person.movement == "crawling":
		text += globals.randomitemfromarray(['crawling on $his knees','on $his hands and knees','on all fours','on the ground like an animal','degradingly crawling'])
	elif person.movement == "none":
		text += globals.randomitemfromarray(['unable to move','laying there','struggling to rise','unable to push $himself up','immobilized'])
	else:
		text += globals.randomitemfromarray(['standing','standing up','shifting from foot to foot','standing directly'])
	text += " " + globals.randomitemfromarray(['in front of you','before you'])
	return text

###Possibly Unneeded, for StartSlave Quest Quirking
func getStartSlave():
	for i in globals.slaves:
		if i.unique == 'startslave':
			return i
	return null

#---Random Generic Names for Body Parts
func nameTits():
	return globals.randomitemfromarray(['boobs','breasts','tits','boobs','breasts','tits','knockers','udders'])

func nameTitsMilking():
	return globals.randomitemfromarray(['nipples','nipples','boobs','breasts','tits','boobs','breasts','tits','knockers','udders'])

func namePenis():
	var array = ['penis','cock','member','dick','penis','cock','member','dick']
	if globals.expansionsettings.ihavebloodygoodtaste == true:
		array.append('todger')
		array.append('wick')
		array.append('johnson')
		array.append('willie')
		array.append('mighty flagpole')
#		array.append('prince charles')
#		array.append('mighty boosh')
		array.append('knob')
	return globals.randomitemfromarray(array)

func nameBalls():
	return globals.randomitemfromarray(['balls','balls','nuts','nutsack','testicles','ballsack'])

func namePussy():
	var array = ['pussy','pussy','twat','cunt','cunt','vagina']
	if globals.expansionsettings.ihavebloodygoodtaste == true:
		array.append('fanny')
		array.append('box')
#		array.append('the queens letterbox')
#		array.append('the secret to Elizabeths longevity')
		array.append('cunny')
		array.append('quim')
#		array.append('tardis')
	return globals.randomitemfromarray(array)

func nameAsshole():
	return globals.randomitemfromarray(['butt','bum','bumhole','asshole','ass','butthole','anus','sphincter'])

func nameAss():
	var array = ['ass','ass','butt','rump','behind','ass cheeks']
	if globals.expansionsettings.ihavebloodygoodtaste == true:
		array.append('derriere')
		array.append('bum')
		array.append('arse')
#		array.append('that which follows constantly')
	return globals.randomitemfromarray(array)

func nameNaked():
	return globals.randomitemfromarray(['completely naked','naked','nude','stripped','exposed','bared','immodestly exposed','revealed'])

func namePenisCumming():
	return globals.randomitemfromarray(['came','squirted','jizzed','creampied','filled up','popped inside'])

func nameCum():
	return globals.randomitemfromarray(['semen','cum','cum','jizz','spunk','cream'])

func nameBelly():
	return globals.randomitemfromarray(['belly','belly','stomach','gut','midriff','tummy'])

func nameKissing():
	var array = ['kissing','making out with','touching lips with','kissing','locking lips with']
	if globals.expansionsettings.ihavebloodygoodtaste == true:
		array.append('snogging')
	return globals.randomitemfromarray(array)

func nameCrying():
	var array = ['moaning','whining','complaining','crying','sniffling','sobbing','whimpering']
	if globals.expansionsettings.ihavebloodygoodtaste == true:
		array.append('whinging')
	return globals.randomitemfromarray(array)

func nameSex():
	var array = ['fuck','be fucked by','rail','have sex with','do','get nasty','do the deed','pound it out','knock boots']
	if globals.expansionsettings.ihavebloodygoodtaste == true:
		array.append('do it for Queen and country')
		array.append('lay there and think of England')
	return globals.randomitemfromarray(array)

func nameBound():
	return globals.randomitemfromarray(['bound','restrained','chained up','helplessly bound','restrained helplessly'])

func nameBred():
	return globals.randomitemfromarray(['bred','knocked up','impregnated','get pregnant','get impregnated','have a baby','have a '+globals.randomitemfromarray(['','swollen','big','huge','unbearable','incredible'])+' '+globals.randomitemfromarray(['','pregnant','protruding','pot','filled up'])+' '+nameBelly()])

func nameBreed():
	return globals.randomitemfromarray(['breed','knock up','impregnate'])

func nameBeBred():
	return globals.randomitemfromarray(['be bred','be knocked up','be impregnated','get pregnant','get impregnated','have a baby','have a '+globals.randomitemfromarray(['','swollen','big','huge','incredible'])+' '+globals.randomitemfromarray(['','pregnant','protruding','pot','filled up'])+' belly'])

func nameBeingBred():
	return globals.randomitemfromarray(['being bred','being knocked up','being impregnated','getting pregnant','getting impregnated','having a baby','having a '+globals.randomitemfromarray(['','swollen','big','huge','incredible'])+' '+globals.randomitemfromarray(['','pregnant','protruding','pot','pot','pot'])+' belly'])

func nameStretching():
	return globals.randomitemfromarray(['stretching','inflating','bloating','swelling','expanding','loosening'])

func nameStretched():
	return globals.randomitemfromarray(['stretched','inflated','bloated','swollen','expanded','filled','puffed up','ready to pop'])

func nameExecution():
	var array = ['You grab a piece of rope and wrap it around $his throat, pulling it tightly until $his legs stop kicking.','You whip out a blade and slice through $his neck, leaving $him to pull against the ropes binding $his hands as $he falls into the dirt. $His last few coughs spill $his $race blood onto the ground in front of you.','You stick your blade in $his gut and pull it to the side. $He looks on in complete, helpless shock as $his guts begin to slide out of $his stomach onto the ground in front of you all. $He looks up at you as the light starts to fade from $his eyes and slumps to the side.','You grab a blade from the battle and walk over to $him. You place it against $his neck.\n[color=yellow]-No...no, plea-[/color]\nYou decide not to let $him finish and watch $his head slide with still moving lips onto the ground in front of everyone.','You recall a little magical trick as you watch $him. You reach down, grab $his head, and infuse $his brain. $His head begins to turn bright red before, eventually, exploding off of $his shoulders.']
	if globals.expansionsettings.ihavebloodygoodtaste == true:
		array.append('You see the flag sticker on the captives clothing and sense $his patriotism. You begin to regale the doomed victim with tales all about what those damned rowdy colonists are getting up to. About the time that you begin to vividly describe them taking entire crates of tea and throwing them in the harbor, $he clutches $his heart in pain.\n\n$He weakly raises $his hand to $his head in a pitiful, though patriotic, salute.\n[color=yellow]-Tell me...they left...the Crumpets...[/color]\n\nYou shake your head firmly. $He sputters, gasps, and dies of shock.')
	return globals.randomitemfromarray(array)

func nameHelplessOrgasmPreface():
	return globals.randomitemfromarray(['$he ','$his body ','$he, despite $himself ','$his body helplessly ','$he uncontrollably ','$he tried to resist orgasming, but ','$he humiliatingly ','$he vulnerably ','$he lost control and '])

func nameHelplessOrgasm():
	return globals.randomitemfromarray(['came','orgasmed','came so hard that $he squirted','relentlessly orgasmed','moaned in orgasm','responded instinctually','gave in to $his animalistic urges','responded helplessly','grunted like a bitch in heat','squealed as $he orgasmed','gushed in esctasy','drenched $himself'])

func nameBrothelWorking():
	var array = ["waiting for clients.","sitting on a couch","talking to another whore.","sitting with $his legs spread open.","posing on the stage."] 
	var client_tasks = globals.randomitemfromarray(['leading $him to a room.','being led to a room by $him.','kissing $his neck.','and is fingering her openly.','kissing $him.','getting a blowjob from $him.','sucking $his nipples.'])
	var text = " with a " + globals.randomitemfromarray(['Human','Human','Human','Human','Human','Elf','Dark Elf','Tribal Elf','Orc','Gnome']) + " " + client_tasks + "."
	array.append(text)
	
	return globals.randomitemfromarray(array)

#Non-Generic Description Names for Body Parts
func getChest(person):
	var text = ""
	if person.titssize == "masculine":
		text = globals.randomitemfromarray(['chest','torso','pecs'])
	else:
		if rand_range(0,1) >= .25:
			text = str(person.titssize.capitalize()) + " "
		text += nameTits()
	return text

func getGenitals(person):
	var textPool = PoolStringArray()
	if person.penis != "none":
		textPool.append((str(person.penis) + " " + namePenis()) if bool(randi() % 2) else namePenis())
	if person.vagina != "none":
		textPool.append((str(person.vagina) + " " + namePussy()) if bool(randi() % 2) else namePussy())
	return textPool.join(" and ")

#---Descriptions---#

func getCheeksDescription(person):
	if person.lust >= 50:
		if person.lust >= 100:
			return "$His cheeks are heavily flushed and $he seems to be breathing very heavily. "
		elif person.lust >= 75:
			return "$His cheeks are flushed and rosy and $his breathing is slightly deeper than normal. "
		else:
			return "$His cheeks are very slightly flushed. "
	return ""

func getCumCoatedDescription(person,part):
	var text = ""
	#Cum on Face
	if person.cum.face > 0 && part == 'face':
		text += "\n$His " + globals.randomitemfromarray(['','',' ' +str(person.race)+ ' '])
		if person.cum.face >= 10:
			text += 'face is ' + globals.randomitemfromarray(['undiscernable underneath the ','completely coated in the ','unrecognizable in the ','concealed beneath ','hidden under ']) + "layers of "
		elif person.cum.face > 5:
			text += 'face is ' + globals.randomitemfromarray(['coated ','covered ','drenched ','dripping ','obviously marked ','soaked ','utterly sprayed ']) + globals.randomitemfromarray(['with ','in '])
		elif person.cum.face > 3:
			text += globals.randomitemfromarray(['face ','cheek ','chin ','nose ']) + ' is ' + globals.randomitemfromarray(['sprayed with ','coated in ','speckled with ','dripping in ','marked with ','stained with '])
		else:
			text += globals.randomitemfromarray(['face ','cheek ','chin ','nose ']) + globals.randomitemfromarray(['streaked with ','dotted with ','speckled with '])
		text += '[color=#E0D8C6]' + nameCum() + '[/color].\n'
	#Cum on Body
	if person.cum.body > 0 && part == 'body':
		text += "$His " + globals.randomitemfromarray(['','',' ' +str(person.race)+ ' ']) + str(getChest(person)) + ' are '
		if person.exposed.chest == true:
			if person.cum.body >= 10:
				text += globals.randomitemfromarray(['undiscernable underneath the ','completely coated in the ','unrecognizable in the ','concealed beneath ','hidden under ']) + "layers of "
			elif person.cum.body > 5:
				text += globals.randomitemfromarray(['coated ','covered ','drenched ','dripping ','obviously marked ','soaked ','utterly sprayed ']) + globals.randomitemfromarray(['with ','in '])
			elif person.cum.body > 3:
				text += globals.randomitemfromarray(['coated ','speckled ','dripping ','marked ','sprayed ','stained ']) + globals.randomitemfromarray(['with ','in '])
			else:
				text += globals.randomitemfromarray(['streaked with ','dotted with ','speckled with '])
			text += '[color=#E0D8C6]' + nameCum() + '[/color].\n'
		else:
			text += ' covered by clothing, but you see a series of ' + globals.randomitemfromarray(['wet','gloopy','moist','damp','dark']) + ' spots on $his clothing that seem to be sticking to $his ' + str(getChest(person)) + '. ' + globals.randomitemfromarray(['Maybe it is just water?','Could it be water?','Maybe they spilled milk?','What it could be?','Interesting...'])
	return text

func getSwollenDescription(person,short=false):
	#Swollen Belly Descriptions
	var text = ""
	var height = (globals.heightarrayexp.find(person.height)+1)*2
	getSwollen(person)
	if person.swollen > 0 && globals.expansionsettings.swollenenabled == true:
		text = "\n\n"

		#Swollen 5 is a Fully Pregnant Woman
		if person.swollen > height*2:
			if short == false:
				text += "$His " + nameBelly() + " is so " +globals.randomitemfromarray(['massive','monstrous','overwhelming','insane']) + " that it "

				if person.height in ['towering','tall']:
					text += " would drag the ground if not for $his height. "
				elif person.height in ['tiny','petite']:
					text += "looks like $his " + nameBelly() + " is about to burst open. It doesn't look like $he could be stretched out any more than $he is now. "
				else:
					text += "swallows $his entire body behind it, easily doubling $his size if not more. "
			else:
				if person.preg.duration > globals.state.pregduration * .8 && person.knowledge.has('currentpregnancy'):
					text += "[color=#F4A7D0]$His unborn child forces $his " + nameBelly() + " to protrude massively. $He will give birth soon, and it looks like $his body will give out if $he doesn't. [/color]"
				else:
					text += "[color=#E0D8C6]The impossible amount of [/color][color=aqua]" + nameCum() + "[/color][color=#E0D8C6] inside of $him has $his " + nameBelly() + " so swollen that $he looks like $he is about to give birth"
					if person.cum.ass > 0:
						text += ". $He keeps coughing up and occassionally drooling " + nameCum() + " that must have worked its way through $his " + nameAsshole() + " up to $his mouth.[/color]"
					else:
						text += ".[/color]"
		elif person.swollen >= height*1.5:
			if short == false:
				text += "$His " + nameBelly() + " is incredibly swollen and "
				if person.height in ['towering','tall']:
					text += "compliments $his large frame by rounding $him out. "
				elif person.height in ['tiny','petite']:
					text += "is triple $his body's size. You can't imagine how $he could move with a belly that massive on such a small frame. "
				else:
					text += "inflated. $He seems to be in constant discomfort. "
			else:
				if person.preg.duration > globals.state.pregduration * .6 && person.knowledge.has('currentpregnancy'):
					text += "[color=#F4A7D0]$His " + nameBelly() + " is swollen and heavy with child.[/color]"
				else:
					text += "[color=#E0D8C6]$He looks like $he is about to give birth just from the [/color][color=aqua]" + nameCum() + "[/color][color=#E0D8C6] inflating $his body. $His " + nameBelly() + " looks bloated like an inseminated balloon.[/color]"
		elif person.swollen >= height:
			if short == false:
				text += "$His " + nameBelly() + " is plump and swollen. It "
				if person.height in ['towering','tall']:
					text += "hangs demurely from $his large frame. "
				elif person.height in ['tiny','petite']:
					text += "has to be at least double $his normal size. $He seems to be struggling to move with the swollen " + nameBelly() + "."
				else:
					text += "is starting to look stretched and uncomfortable. "
			else:
				if person.preg.duration > globals.state.pregduration * .4 && person.knowledge.has('currentpregnancy'):
					text += "[color=#F4A7D0]$His advanced pregnancy is clearly evident by the prominent bulge in $his " + nameBelly() + ".[/color]"
				else:
					text += "[color=#E0D8C6]$His " + nameBelly() + " is swollen due to the [/color][color=aqua]" + nameCum() + "[/color][color=#E0D8C6] $he "+ globals.fastif(person == globals.player, 'are', 'is') +" retaining inside of $him.[/color]"
		elif person.swollen >= height*.5:
			if short == false:
				text += "$His " + nameBelly() + " is swollen. It "
				if person.height in ['towering','tall']:
					text += "pokes out nicely from $him. "
				elif person.height in ['tiny','petite']:
					text += "makes $his small form look pregnant."
				else:
					text += "looks like the bump is firm and tight. "
			else:
				if person.preg.duration > globals.state.pregduration * .2 && person.knowledge.has('currentpregnancy'):
					text += "[color=#F4A7D0]$His pregnancy is causing $his " + nameBelly() + " to protrude obviously.[/color]"
				else:
					text += "[color=#E0D8C6]$His " + nameBelly() + " is poking out from what must be an unnatural amount of [/color][color=aqua]" + nameCum() + "[/color][color=#E0D8C6] inside of $him.[/color]"
		else:
			if short == false:
				text += "$His " + nameBelly() + " is poking out slightly. It "
				if person.height in ['towering','tall']:
					text += "is almost unnoticable on $his tall build. "
				elif person.height in ['tiny','petite']:
					text += "is a cute little bubble hanging off $his front."
				else:
					text += "sticks out of $him rather adorably. "
			else:
				if person.preg.duration > 0 && person.knowledge.has('currentpregnancy'):
					text += "[color=#F4A7D0]$His unborn fetus causes $his " + nameBelly() + " to bulge slightly.[/color] "
				else:
					text += "[color=#E0D8C6]$His " + nameBelly() + " is slightly pronounced. You aren't exactly sure why.[/color] "
	return text

###---Inflation (Cum or Pregnancy) Functions---###
#Calculate Capacity
func getCapacity(person, hole):
	#Call with globals.expansion.getCapacity(person's identifier like person/i, identifier .vagina or .asshole)
	var capacity = globals.expansionsettings.baseholecapacity + (globals.vagsizearray.find(hole)-3) + round((person.lust - 50)*.05)
#	OLD FORMULA var capacity = round(1 + (globals.vagsizearray.find(size)*1.5) + person.send/2)
	return clamp(capacity, 0, globals.expansionsettings.baseholecapacity+6)

#Calculate Swollen
func getSwollen(person):
	var text = ""
	var vagcapacity = getCapacity(person, person.vagina)
	var asscapacity = getCapacity(person, person.asshole)
	var height = (globals.heightarrayexp.find(person.height)+1)*2
	var swollen = 0
	var number = 0
	#Average Pregnancy is Swollen = (globals.heightarrayexp.find(person.height+1)*2

	if globals.expansionsettings.swollenenabled == false:
		person.swollen = 0
		return "[color=red]Swollen Settings Disabled[/color]"

	#Backwards Compatibility
	if !person.pregexp.has('babysize'):
		person.pregexp['babysize'] = 0

	#Baby Swelling (Capped at Height)
	swollen += round(clamp(person.pregexp.babysize, 0, height))

	#Pussy Swelling
	if person.cum.pussy > vagcapacity:
		#Trigger Overload
		if person.cum.pussy > vagcapacity*1.25:
			text += cumOverload(person, 'vagina')
		number = (person.cum.pussy - vagcapacity)*.5-1
		swollen += 1 + floor(number / .5)
	#Ass Swelling
	if person.cum.ass > asscapacity:
		#Trigger Overload
		if person.cum.ass > asscapacity * 1.5:
			text += cumOverload(person, 'ass')
		number = (person.cum.ass - asscapacity)*.5-1
		swollen += 1 +floor(number / .5)

	swollen = clamp(swollen,0,height*5)
	person.swollen = swollen

	return text

func getMovement(person):
	#Affect Movement per Breast Size, Restrains, or Energy
	var titweight = (globals.titssizearray.find(person.titssize)-4) - (person.send/2)
	titweight = clamp(titweight, -1, 5)
	#Natural Carry Capacity
	var swollencarry = (person.sstr + person.send + 2) + round((globals.heightarrayexp.find(person.height)+1)/2)
	var weight = swollencarry - (person.swollen + titweight)
	weight = clamp(weight, -20, 20)

	if weight < 0 || person.restrained in ['shackled','fully','fullyexposed'] || person.energy-weight <= 0:
		if person.movement != 'none':
			#Essentially any but 'livestock','breeder','object'
#			if person.mind.identity.has('self')
#				person.moodnum -= round(rand_range(1,2))
#			if person.traits.has('Movement: Crawling'):
#				person.trait_remove('Movement: Crawling')
#			if person.traits.has('Movement: Flying'):
#				person.trait_remove('Movement: Flying')
#			if person.traits.has('Movement: Walking'):
#				person.trait_remove('Movement: Walking')
#			person.add_trait('Movement: Immobilized')
			person.movementreasons.clear()
			if titweight > 0:
				person.movementreasons.append('[color=red]\nIs not naturally Hardy enough to support $his oversized Tits.[/color] ')
			if weight < 0:
				if person.swollen > 0:
					person.movementreasons.append('[color=red]\nMay be Swollen and not Strong enough to stand up under the weight.[/color] ')
				else:
					person.movementreasons.append('[color=red]\nIs not Strong enough to stand up under the weight of $his oversized Tits.[/color] ')
			if person.restrained in ['shackled','fully','fullyexposed']:
				person.movementreasons.append('[color=red]\nIs currently restrained.[/color] ')
			if person.energy-weight < 0:
				person.movementreasons.append('[color=red]\nIs too tired, Energy is too low.[/color] ')
			person.movement = "none"
			return "$name is now [color=aqua]immobilized[/color]\n"
#		elif !person.traits.has('Movement: Immobilized'):
#			person.add_trait('Movement: Immobilized')
	elif weight < 3 || person.restrained in ['cuffed'] || person.energy-weight < 15 || person.rules.pet == true && rand_range(0,150) <= person.obed+person.loyal:
		if person.movement != 'crawl':
			#Essentially any but 'livestock','breeder','object'
#			if person.mind.identity.has('self'):
#				person.moodnum -= round(rand_range(1,2))
#			if person.traits.has('Movement: Immobilized'):
#				person.trait_remove('Movement: Immobilized')
#			if person.traits.has('Movement: Flying'):
#				person.trait_remove('Movement: Flying')
#			if person.traits.has('Movement: Walking'):
#				person.trait_remove('Movement: Walking')
#			person.add_trait('Movement: Crawling')
			person.movement = "crawl"
			person.movementreasons.clear()
			if titweight > 0:
				person.movementreasons.append('[color=red]\nIs not naturally Hardy enough to support $his oversized Tits.[/color] ')
			if weight < 3:
				if person.swollen > 0:
					person.movementreasons.append('[color=red]\nMay be Swollen and not Strong enough to stand up under the weight.[/color] ')
				else:
					person.movementreasons.append('[color=red]\nIs not Strong enough to stand up under the weight of $his oversized Tits.[/color] ')
			if person.restrained in ['cuffed']:
				person.movementreasons.append('[color=red]\nIs currently restrained.[/color] ')
			if person.energy-weight < 15:
				person.movementreasons.append('[color=red]\nIs too tired, Energy is too low.[/color] ')
			if person.rules.pet == true:
				person.movementreasons.append('[color=red]\nIs required to crawl per your orders.[/color] ')
			return "$name is now [color=aqua]crawling[/color]\n"
#		elif !person.traits.has('Movement: Crawling'):
#			person.add_trait('Movement: Crawling')
	elif person.wings != "none" && person.energy >= 50:
		if person.movement != "fly":
			person.moodnum += round(rand_range(1,2))
#			if person.traits.has('Movement: Immobilized'):
#				person.trait_remove('Movement: Immobilized')
#			if person.traits.has('Movement: Crawling'):
#				person.trait_remove('Movement: Crawling')
#			if person.traits.has('Movement: Walking'):
#				person.trait_remove('Movement: Walking')
#			person.add_trait('Movement: Flying')
			person.movement = "fly"
			person.movementreasons.clear()
			person.movementreasons.append('Is Flying as Energy is above 50 ')
			return "$name is now [color=aqua]flying[/color]\n"
#		elif !person.traits.has('Movement: Flying'):
#			person.add_trait('Movement: Flying')
	else:
		if person.movement != "walk":
			person.moodnum += round(rand_range(0,1))
#			if person.traits.has('Movement: Immobilized'):
#				person.trait_remove('Movement: Immobilized')
#			if person.traits.has('Movement: Crawling'):
#				person.trait_remove('Movement: Crawling')
#			if person.traits.has('Movement: Flying'):
#				person.trait_remove('Movement: Flying')
#			person.add_trait('Movement: Walking')
			person.movement = "walk"
			person.movementreasons.clear()
			if person.wings != "none":
				person.movementreasons.append('Is too tired to Fly right now. ')
			return "$name is now [color=aqua]walking[/color]\n"
#		else:
#			if !person.traits.has('Movement: Walking'):
#				person.add_trait('Movement: Walking')
	return ""

func getMovementIcon(person):
	var text
	#Update Movement
	getMovement(person)
	if person.sex == 'male':
		text = "man_"
	else:
		text = "woman_"
	if person.movement == 'none':
		text += "lay"
	else:
		text += str(person.movement)
	
	if int(person.exposed.chest) + int(person.exposed.genitals) + int(person.exposed.ass) >= 2:
		text += "_naked"
	else:
		text += "_clothed"
	
	if person.sex != "male":
		var trimester = getTrimester(person)
		getSwollen(person)
		if person.swollen > 0 || person.preg.duration > 0:
			text += "_pregnant"
			var height = (globals.heightarrayexp.find(person.height)+1)*2
			if person.swollen >= height*2 || trimester == 'third':
				text += "_3"
			elif person.swollen >= height || trimester == 'second':
				text += "_2"
			else:
				text += "_1"
	
	return text

var sexualityText = {
	'straight': "Straight",
	'gay': "Gay",
	'bi': "Bisexual",
	'mostlystraight': "primarily Straight",
	'mostlygay': "primarily Gay",
	'rarelystraight': "usually Gay, but occasionally Straight",
	'rarelygay': "usually Straight, but occasionally Gay",
}

func getSexuality(person):
	return sexualityText.get(person.sexuality, '')


func cumOverload(person, mode = ''):
	var text = ""
	var vagcapacity = getCapacity(person, person.vagina)
	var asscapacity = getCapacity(person, person.asshole)
	var vagdrip = 0
	var assdrip = 0
	if mode == 'vagina':
#		vagdrip = (vagcapacity * 2) - person.cum.pussy
#		person.cum.pussy = vagcapacity * 2
		if vagdrip > 10:
			text += person.dictionary("$name's embarrassment is palpable as every breath or movement $he takes forces "+nameCum()+ " to ")
		elif vagdrip >= 7:
			text += person.dictionary("$name is obviously embarrassed as "+nameCum()+ " starts to ")
		elif vagdrip >= 3:
			text += person.dictionary("$name's legs are streaked with "+nameCum()+ " as it begins to ")
		else:
			text += person.dictionary("Little streams of "+nameCum()+ " ")
		#Vagina Size Descriptor
		if person.vagina == 'tiny':
			text += "shoot like a jet out of her [color=green]tiny "+namePussy()+ "[/color] as she overflows with "+nameCum()+ "."
		elif person.vagina == 'tight':
			text += "squirt in little streams out of her [color=green]tight "+namePussy()+ "[/color] as she overflows with "+nameCum()+ "."
		elif person.vagina == 'average':
			text += "spray out of her [color=green]"+namePussy()+ "[/color] as she overflows with "+nameCum()+ "."
		elif person.vagina == 'loose':
			text += "slip out of her [color=green]loose "+namePussy()+ "[/color] as she overflows with "+nameCum()+ "."
		elif person.vagina == 'gaping':
			text += "slide straight out of her [color=green]gaping "+namePussy()+ "[/color] as she overflows with "+nameCum()+ "."
	elif mode == 'ass':
#		assdrip = (asscapacity * 5) - person.cum.ass
#		person.cum.ass = asscapacity * 5
		if assdrip >= 15:
			text += person.dictionary("$name's so flooded with " +nameCum()+ " that $he can't stop coughing it up, forcing it to ")
		elif assdrip >= 10:
			text += person.dictionary("$name's embarrassment is palpable as every breath or movement $he takes forces "+nameCum()+ " to ")
		elif assdrip >= 7:
			text += person.dictionary("$name is obviously embarrassed as "+nameCum()+ " starts to ")
		elif assdrip >= 3:
			text += person.dictionary("$name's legs are streaked with "+nameCum()+ " as it begins to ")
		else:
			text += person.dictionary("Little trails of "+nameCum()+ " ")
		#Ass Size Descriptor
		if person.asshole == 'tiny':
			text += "shoot like a jet out of her [color=green]tiny "+nameAsshole()+ "[/color] as she overflows with "+nameCum()+ "."
		elif person.asshole == 'tight':
			text += "squirt in little streams out of her [color=green]tight "+nameAsshole()+ "[/color] as she overflows with "+nameCum()+ "."
		elif person.asshole == 'average':
			text += "spray out of her [color=green]ass[/color] as she overflows with "+nameCum()+"."
		elif person.asshole == 'loose':
			text += "slip out of her [color=green]loose "+nameAsshole()+ "[/color] as she overflows with "+nameCum()+"."
		elif person.asshole == 'gaping':
			text += "slide straight out of her [color=green]gaping "+nameAsshole()+ "[/color] as she overflows with "+nameCum()+"."
	return text

###Combine Ass and Vag Overload, Turn into "Pushed on Stomach/Drain" convo when swollen
func vagOverload(person):
	var text = ''
	var overage = 0
	var vagcapacity = getCapacity(person, person.vagina)
#	overage = person.cum.pussy - vagcapacity
	text += 'While $he is standing with $his legs spread to shoulder-width, you notice '
	if person.cum.pussy - vagcapacity > 10:
#		person.cum.pussy -= round(rand_range(1,overage))
#		person.mind.humiliation += round(rand_range(1,overage))
		text += 'a bubbling noise, just before a waterfall of hot [color=#E0D8C6]'+nameCum()+ '[/color] starts violently draining out of $his '+namePussy()+ ' onto the floor. $He moans out an apology and immediately '
	elif person.cum.pussy - vagcapacity > 5:
#		person.cum.pussy -= round(rand_range(0,overage))
#		person.mind.humiliation += round(rand_range(0,overage))
		text += 'a wet gargling sound, just as a warm jet of [color=#E0D8C6]'+nameCum()+ '[/color] suddenly sprays out of $his '+namePussy()+ '. $He turns bright red and '
	elif person.cum.pussy - vagcapacity > 0:
#		person.cum.pussy -= round(rand_range(0,overage))
#		person.mind.humiliation += round(rand_range(0,overage))
		text += 'a glob of [color=#E0D8C6]'+nameCum()+ '[/color] sloppily slide out of $his '+namePussy()+ ' lips and splatter on the ground. $He blushes, straightens up immediately, and '
	else:
		text += 'a little [color=#E0D8C6]'+nameCum()+ '[/color] trickle out the side of $his '+namePussy()+ ' lips onto $his inner thigh. $He pretends like $he did not see it and '
	text += 'squeezes $his thighs together tightly to try to keep it all in. '
	return text

func assOverload(person):
	var text = ''
	var overage = 0
	var capacity = getCapacity(person, person.asshole)
#	overage = person.cum.ass - capacity
	text += 'While turned around, you see '
	if person.cum.ass - capacity > 10:
#		person.cum.ass -= round(rand_range(1,overage))
#		person.mind.humiliation += round(rand_range(1,overage))
		text += 'a river of hot [color=#E0D8C6]'+nameCum()+ '[/color] violently starts spewing out of $his '+nameAsshole()+ '. $He moans out an apology and immediately '
	elif person.cum.ass - capacity > 5:
#		person.cum.ass -= round(rand_range(1,overage))
#		person.mind.humiliation += round(rand_range(0,overage))
		text += 'a stream of warm [color=#E0D8C6]'+nameCum()+ '[/color] suddenly jet out of $his '+nameAsshole()+ '. $He turns bright red and '
	elif person.cum.ass - capacity > 0:
#		person.cum.ass -= round(rand_range(1,overage))
#		person.mind.humiliation += round(rand_range(0,overage))
		text += 'a glob of [color=#E0D8C6]'+nameCum()+ '[/color] sloppily drip out of $his '+nameAsshole()+ ' and splatter on the ground. $He straightens up immediately and '
	else:
		text += 'a little [color=#E0D8C6]'+nameCum()+ '[/color] trickle out from inside of $his '+nameAsshole()+ '. $He acts like $he does not notice and '
	text += 'turns back around to face you. '
	return text

###---End Cum Inflation and Explosion Functions---###

#---Category: Pregnancy---#
###---Added by Expansion---### Pregnancy Expanded || Deviate Added / Aric Tweaked
func ovulation_day(person):
	var expansion = globals.expansion
	var expansionsetup = globals.expansionsetup
	
	if person.preg.has_womb == false || person.race_type == 4:
		return
	
	if person.preg.ovulation_type <= 0 || person.preg.baby_type == '':
		globals.constructor.set_ovulation(person)
	
	if person.preg.is_preg == false:
		if person.preg.ovulation_stage == 0:
			globals.constructor.setRandomOvulationDay(person)
		#Ovulation System Disable Check
		if globals.expansionsettings.ovulationenabled == true:
			#Type 1 = Live Births, Type 2 = Egg Layer
			var maxCycle = globals.expansionsettings.livebirthcycle if person.preg.ovulation_type == 1 else globals.expansionsettings.eggcycle
			if person.preg.ovulation_day >= maxCycle:
				person.preg.ovulation_stage = 1
				person.preg.ovulation_day = 1
			else:
				if person.preg.ovulation_day >= floor(maxCycle * globals.expansionsettings.fertileduringcycle):
					person.preg.ovulation_stage = 2
				person.preg.ovulation_day += 1
		else:
			person.preg.ovulation_stage = 1
			person.preg.ovulation_day = 1
		
	#Semen Cleanser
	for i in person.preg.womb.duplicate():
		if i.day >= globals.expansionsettings.semenlifespan:
			person.preg.womb.erase(i)
		else:
			i.day += 1
			if person.cum.pussy >= 1:
				i.semen = i.semen * 1.2
				person.cum.pussy -= 1
	
	#globals.traceFile('ovulation day')

func fertilize_egg(mother, father_id, father_unique):
	var father
	
	###Get/Build Father
	if father_id != null && father_id != '-1' && !father_unique in ['','dog','horse']:
		father = globals.state.findslave(father_id)
		#If Father disappeared from the World
		if father == null:
			father = globals.newslave('randomany', 'adult', 'male')
			#Added per Ank's Notes
			father.race = globals.getracebygroup("starting")
			globals.constructor.set_genealogy(father)
	else:
		father = globals.newslave('randomany', 'adult', 'male')
		#Added per Ank's Notes
		father.race = globals.getracebygroup("starting")
		globals.constructor.set_genealogy(father)
		father.id = '-1'
		
		if father_unique != null:
			father.unique = father_unique
		
		globals.constructor.clearGenealogies(father)
		if father_unique == 'bunny':
			father.genealogy.bunny = 100
			father.race = 'Beastkin Bunny'
		elif father_unique == 'dog':
			father.genealogy.dog = 100
			father.race = 'Beastkin Wolf'
		elif father_unique == 'cow':
			father.genealogy.cow = 100
			father.race = 'Taurus'
		elif father_unique == 'cat':
			father.genealogy.cat = 100
			father.race = 'Beastkin Cat'
		elif father_unique == 'fox':
			father.genealogy.fox = 100
			father.race = 'Beastkin Fox'
		elif father_unique == 'horse':
			father.genealogy.horse = 100
			father.race = 'Centaur'
		elif father_unique == 'raccoon':
			father.genealogy.raccoon = 100
			father.race = 'Beastkin Tanuki'
		else:
			father.race = globals.getracebygroup("starting")
			globals.constructor.set_genealogy(father)
	
	#Consent/Wanted Pregnancy Check
	if father.id == globals.player.id:
		mother.pregexp.wantedpregnancy = mother.consentexp.pregnancy
	else:
		mother.pregexp.wantedpregnancy = mother.consentexp['breeder' if relatedCheck(mother,father) == "unrelated" else 'incestbreeder']

	var baby = globals.constructor.newbaby(mother, father)

	if baby != null && baby.id != null:
		baby.state == 'fetus'
		mother.preg.is_preg = true
		mother.preg.duration = 1
		mother.preg.baby = -1
		mother.preg.unborn_baby.append({id = baby.id})
		mother.preg.ovulation_stage = 0
		mother.preg.ovulation_day = -3
	#globals.traceFile('fertilize egg')

func nightly_womb(person):
	var text = ""
	if person.preg.duration > globals.state.pregduration:
		#Childbirth still checked/called in End of Day
		text = person.dictionary("[center][color=yellow]$name went into Labor![/color][/center]\n")

	person.preg.fertility = clamp(person.preg.fertility + 10 * (person.health / person.stats.health_max - 0.6) + 10 * (0.6 - person.stress / person.stats.stress_max), -20, 50)

	ovulation_day(person)
	if person.preg.has_womb == false || person.preg.is_preg == true || person.preg.ovulation_type <= 0 || person.preg.ovulation_stage != 1 || person.effects.has('contraceptive'):
		return text

	var bonus = 1.25 if globals.state.spec == "Breeder" else 1
	var fertility = round(5 + max(person.preg.fertility + person.preg.bonus_fertility, 0) * person.pregexp.eggstr)
	if person.traits.has("Fertile"):
		fertility *= 1.5
	elif person.traits.has("Infertile"):
		fertility *= 0.5
	
	fertility *= bonus
	var multiBabyLimitChance = 100 - globals.expansionsettings.multipleBabyChance
	for i in person.preg.womb:
		if bonus * round(i.semen) * i.virility > rand_range(0,100):
			i.day -= 1
			if fertility > rand_range(0,100):
				#if person.preg.baby_type == 'birth':
				fertilize_egg(person,i.id,i.unique)
				if rand_range(0,100) <= multiBabyLimitChance || person.preg.unborn_baby.size() > 3:
					break
	
	
	#globals.traceFile('nightly_womb')
	return text


func dailyPregnancy(person):
	if person == null:
		return ""

	var text = ""

	var pregdict = person.pregexp
#	var swelling
	if person.preg.is_preg:
		#Settings Variables
		var chancemorningsickness = globals.expansionsettings.chancemorningsickness
		var chancetitsgrow = globals.expansionsettings.chancetitsgrow

		#Set Traits PENDING
		var totalbabysize = 2*globals.heightarrayexp.find(person.height)+2

		var gestationspeed = 1
		#Set Race Bonus
		if person.race.find('Goblin') >= 0:
			gestationspeed += 1

		#Traits to Increase Gestation Speed (ADD THIS HERE)
			#gestationspeed += 1

		#Set Stats
		pregdict.gestationspeed = gestationspeed
		person.preg.duration = min(person.preg.duration + gestationspeed, globals.state.pregduration + 1)

		var gestation = min(float(person.preg.duration) / max(globals.state.pregduration, 1), 1.0)
		#Set Size Factors (for Swelling)
		pregdict.babysize = round(totalbabysize * pow(gestation, 2))

		#Trimester Events
		#First
		if person.preg.duration < floor(globals.state.pregduration/3):
			#Chance to Start Lactating
			if person.lactation == false:
				if person.preg.duration >= round(globals.state.pregduration* rand_range(1/6.0, 1/3.0)):
					person.lactation = true
					if !person.mind.secrets.has('currentpregnancy') && !person.knowledge.has('currentpregnancy'):
						getSecret(person,'currentpregnancy')

		#Second
		#elif person.preg.duration < floor(globals.state.pregduration/1.5):
		#	person.lactation = true
		#	#Realize Pregnant if haven't yet
		#	if !person.mind.secrets.has('currentpregnancy') && !person.knowledge.has('currentpregnancy'):
		#		getSecret(person,'currentpregnancy')
	
		#Second and Third
		else:
			person.lactation = true
			#Realize Pregnant if haven't yet
			if !person.mind.secrets.has('currentpregnancy') && !person.knowledge.has('currentpregnancy'):
				getSecret(person,'currentpregnancy')
			
		#Set Wanted Pregnancy
		if person.mind.secrets.has('currentpregnancy') || person.knowledge.has('currentpregnancy'):
			setWantedPregnancy(person)
		if person.pregexp.wantedpregnancy == true && !person.knowledge.has('currentpregnancywanted'):
			person.dailytalk.append('wantpregnancy')

		#Pregnancy Events
		#Morning sickness
		if rand_range(0,100) <= chancemorningsickness * (1-gestation * .8):
			var number = round(rand_range(1,person.preg.duration*1.5))
			number = clamp(number, 0, 100)
			person.energy -= number
			text += "$name spent the morning puking $his guts out into a bucket. $He lost [color=red]"+str(number)+" Energy[/color]"
			number = round(number/2)
			if globals.fetishopinion.find(person.fetish.pregnancy) >= 4 || pregdict.wantedpregnancy == true:
				person.lust += number
				text += ". $He is seems happy about the pregnancy, however, and you noticed a wet stain beneath $his "+str(getGenitals(person))+" when $he got up. $He gained [color=green]"+str(number)+" Lust[/color].\n"
			else:
				person.stress += number
				text += " and gained [color=red]"+str(number)+" Stress[/color].\n"
		#Grow Tits
		if rand_range(0,100) <= (chancetitsgrow * (1.0 - pregdict.get("titssizebonus",0)/3.0))*gestation:
			if globals.titssizearray.back() != person.titssize && (person.lactating.hyperlactation == true || globals.titssizearray.find(person.titssize) <= 5):
				text += "$name's "+str(getChest(person))+" started "+nameStretching()+" due to $his pregnancy. They are now nice and "
				person.titssize = globals.titssizearray[globals.titssizearray.find(person.titssize)+1]
				text += "[color=aqua]" +str(person.titssize)+"[/color]. "
				pregdict.titssizebonus = pregdict.get("titssizebonus",0) + 1

				var number = round(rand_range(1,person.preg.duration*1.5))
				number = clamp(number, 0, 100) / 2
				if globals.fetishopinion.find(person.fetish.pregnancy) >= 4 || pregdict.wantedpregnancy == true:
					person.lust += number
					text += "$He seemed to enjoy the new size of $his "+nameTits()+" immensely and got off on knowing what the pregnancy was doing to $him. $He gained [color=green]"+str(number)+" Lust[/color].\n"
				else:
					person.stress = number
					text += "$He seemed horrified by $his lack of control over $his own body as $he watched $his "+str(getChest(person))+" grow helplessly. $He gained [color=red]"+str(number)+" Stress[/color].\n"
			else:
				text += "$name's "+str(getChest(person))+" seemed to try to swell slightly but then shrunk back to the size it was before. You believe that $his "+str(getChest(person))+" is as large as it can get naturally. You may be able to expand it further by giving $him a [color=aqua]Hyperlactation Potion[/color].\n"
	else:
		#Shrink Tits
		if pregdict.get("titssizebonus",0) > 0:
			if globals.titssizearray.find(person.titssize) > 0:
				text += "$name's "+nameStretched()+" "+str(getChest(person))+" are starting to shrink back after $his pregnancy. They are now only "
				person.titssize = globals.titssizearray[globals.titssizearray.find(person.titssize)-1]
				text += "[color=aqua]" +str(person.titssize)+"[/color]. "
				pregdict.titssizebonus -= 1
		#Reset Pregnancy Stats
		person.knowledge.erase('currentpregnancy')
		person.knowledge.erase('currentpregnancywanted')
	return text



func dailyBioClock(person):
	#Builds the need to Reproduce. Maximum of 5 per day
	if person.preg.duration > 0 || person.preg.has_womb == false:
		#Resets when Pregnant or if no womb
		person.instinct.reproduce = 0
		return
	if person.age == "child":
		person.instinct.reproduce += round(rand_range(0,2))
	elif person.age == "teen":
		person.instinct.reproduce += round(rand_range(1,3))
	elif person.age == "adult":
		person.instinct.reproduce += round(rand_range(2,3))
	#Racial
	if person.race.find("Beastkin") >= 0 || person.race.find("Goblin") >= 0:
		person.instinct.reproduce += round(rand_range(1,2))
	#Traits (3-5)
	if person.traits.has("Fertile"):
		person.instinct.reproduce += round(rand_range(3,5))
	elif person.traits.has("Infertile"):
		person.instinct.reproduce -= round(rand_range(1,person.instinct.reproduce))

func getTrimester(person):
	if person.preg.duration >= floor(globals.state.pregduration/1.5):
		return "third"
	elif person.preg.duration >= floor(globals.state.pregduration/3):
		return "second"
	elif person.preg.duration > 0:
		return "first"
	else:
		return "none"

func setWantedPregnancy(mother):
	#Set Once per Pregnancy
	mother.pregexp.wantedpregnancy = mother.consentexp['incestbreeder' if mother.pregexp.incestbaby else 'pregnancy']
	#Final Random Chance to Want Baby
	if mother.pregexp.wantedpregnancy == false:
		if rand_range(0,100) <= ((mother.pregexp.desiredoffspring - mother.metrics.birth)*10) + mother.instinct.reproduce + globals.expansionsettings.wantedpregnancychance:
			mother.dailytalk.append('wantpregnancy')


#---Functions to Check the Current Mental Identity of a Person
func getIdentity(person):
	#Used to Check Prevailing Mindset in Convos and Scenes
	var currentmind
	if person.mind.id.size() > person.mind.ego.size():
		currentmind = person.mind.id
	elif person.mind.id.size() > person.mind.ego.size():
		currentmind = person.mind.ego
	else:
		currentmind = person.mind.id+person.mind.ego
	var currentidentity = globals.randomitemfromarray(currentmind)
	person.mind.identity = currentidentity
	return currentidentity

#---Daily Checks---#
func dailyCrystal():
	var text = ""
	var refCrystal = globals.state.thecrystal
	refCrystal.power = globals.state.mansionupgrades.dimensionalcrystal

	#Check for Researcher
	var researcher = getCrystalResearcher()
	
	#Check for Abilities
	var moreabilitiesexist = false
	var allabilities = globals.expansion.dimcrystal_abilities_array
	for abilitycheck in allabilities:
		if !refCrystal.abilities.has(abilitycheck):
			moreabilitiesexist = true
			break
	
	if researcher == null:
		if globals.expansionsettings.show_warning_if_missing_researcher == true && globals.state.sidequests.dimcrystal != 0 && moreabilitiesexist == true:
			text = "\n[center][color=red]No Researcher was assigned to study the [color=#E389B9]Dimensional Crystal[/color] today.[/color][/center]"
			if refCrystal.research > 0:
				text = "\n[center][color=red]Half of the actively completed Research was lost due to the absense of the Researcher[/color][/center]."
				refCrystal.research = round(refCrystal.research*.5)
		return text
	
	#Set Research if Unassisted
	if refCrystal.research <= 0:
		if researcher.smaf >= globals.state.mansionupgrades.dimensionalcrystal:
			refCrystal.research = round(rand_range(researcher.smaf, researcher.wit))
		else:
			text += researcher.dictionary("\n[center][color=red]Your [color=aqua]Crystal Researcher[/color], [color=aqua]$name[/color] comes over to you holding $his head. $He sadly reports $he was unable to even interact with the magical power within the [color=#E389B9]Crystal[/color] and was completely overwhelmed by its power. Either $he needs more [color=aqua]Magical Affinity[/color], you will need to [color=aqua]actively assist[/color] $him from within the [color=aqua]Crystal's panel[/color], or you may need to assign a new [color=aqua]Researcher[/color].[/color][/center]")
	
	#Crystal Time
	if globals.player.dailyevents.count('dimcrystaldarkened') > 0:
		refCrystal.mode = "dark"
		text += "\n[center][color=red]At exactly midnight, everyone in the Mansion woke up. Some found that their nose was bleeding, others reported their skin crawling, and still others claimed to have horrific nightmares of being eaten alive. A brief investigation found that the Dimensional Crystal has dark, shadowy veins running through it like deep cracks. The color seems to be a darker purple and the glow seen coming off the Crystal and people seem to have those same dark, shadowy tendrils. Everyone returned to their beds, though sleep came uneasily and was wrought with nightmares.[/color][/center]\n"
	elif refCrystal.lifeforce >= 0 && refCrystal.hunger <= 0 && refCrystal.mode == "dark":
		refCrystal.mode = "light"
		text += "\n[center][color=lime]At exactly midnight, everyone woke up in a blissful, body-shaking orgasm. Everyone rushed back to the Dimensional Crystal to find it glowing a pure, violet light with no trace of the shadowy tendrils running through it. Dreams were lovely and bright tonight.[/color][/center]\n"

	if refCrystal.mode == "dark":
		if refCrystal.hunger <= refCrystal.power:
			refCrystal.hunger += 1
		if refCrystal.lifeforce < 0 && rand_range(0,100) <= globals.expansionsettings.crystallifeforcerestorechance:
			refCrystal.lifeforce += 1
			refCrystal.hunger += 1
	else:
		#Strengthen the Crystal
		if refCrystal.hunger > 0:
			refCrystal.lifeforce -= refCrystal.hunger
			refCrystal.hunger = 0
		#Daily Regain
		if refCrystal.lifeforce <= globals.state.mansionupgrades.dimensionalcrystal:
			refCrystal.lifeforce += 1
		if rand_range(40,100) <= refCrystal.research && refCrystal.lifeforce < globals.state.mansionupgrades.dimensionalcrystal:
			refCrystal.lifeforce += 1
	
	if refCrystal.abilities.size() > 0 && !refCrystal.abilities.has('attunement'):
		if rand_range(50,100) <= refCrystal.research:
			text += "\n[center][color=yellow]The [color=#E389B9]Crystal[/color] grants you a Secret[/color][/center]\n"
			text += "You dream deeply. You are standing before the [color=#E389B9]Crystal[/color] in your Mansion and staring deeply into the flowing energy within it. As you watch, the energy begins to split and separate itself into understandable forms. You see the [color=aqua]Coloration[/color] of the [color=#E389B9]Crystal[/color]. You see the latent [color=aqua]Lifeforce[/color] inside it and the [color=red]Hunger[/color] consuming those trapped souls. You feel [color=green]Attuned[/color] to the [color=#E389B9]Crystal[/color]. "
			refCrystal.abilities.append('attunement')	
	
	if globals.state.mansionupgrades.dimensionalcrystal >= 1 && !refCrystal.abilities.has('pregnancyspeed'):
		if rand_range(35,100) <= refCrystal.research:
			text += "\n[center][color=yellow]The [color=#E389B9]Crystal[/color] grants you a Secret[/color][/center]\n"
			text += "You dream that you are the [color=#E389B9]Crystal[/color]. You feel life moving within your walls. Life grows. You love life. You are life. You see the growing sprouts and water them with words. They burst out of their seeds and grow mightily. You bask in their life.\nYou awaken and write down the words uttered in your dream. You have been granted the secret of [color=green]Altering Pregnancy Speeds[/color]. "
			refCrystal.abilities.append('pregnancyspeed')
	
	elif globals.state.mansionupgrades.dimensionalcrystal >= 1 && !refCrystal.abilities.has('empowervirginity'):
		if rand_range(40,100) <= refCrystal.research:
			text += "\n[center][color=yellow]The [color=#E389B9]Crystal[/color] grants you a Secret[/color][/center]\n"
			text += "You dream a dream of ephemeral beauty. You feel yourself in the body of another, feeling spry and treasured. You hold in your hand two flawless jewels. Inside of each radiates the octarine glow of mana, begging to be released. You feel yourself fall enamored with the pristine beauty of these orbs. They are perfect, untarnished, and untouched. You feel your singular focus embuing these objects with a deeper meaning, a deeper magic, as long as they remain untarnished simply on the premise of how fleeting they are. You pull back to feel the power these now only have when in perfect, pristine condition. You feel the power their loss will have, magic pouring out like a flood, these temporal seals are tarnished. Your crystaline mind retreats from the passing fancy, the sentient creature, and you now sense how to ask the [color=#E389B9]Crystal[/color] to actually fulfill it's fascination with real magic.\n\nYou awaken with a start. Apparently the only thing that can fascinate an indistructable, eternal artifact are things that are so temporary. You have been granted the secret of [color=#E389B9]Empowering Virginities[/color]. You may now ask the [color=#E389B9]Crystal[/color] to give a [color=green]stacking multiplier of 5x the normal mana produced[/color] at the end of a sexual encounter in the Mansion for [color=green]any virginities taken[/color], but losing [color=red]half of the mana normally produced[/color] when [color=red]they lose neither vaginal or anal virginities during sex[/color]. "
			refCrystal.abilities.append('empowervirginity')
	
	elif globals.state.mansionupgrades.dimensionalcrystal >= 2 && !refCrystal.abilities.has('secondwind'):
		if rand_range(50,100) <= refCrystal.research:
			text += "\n[center][color=yellow]The [color=#E389B9]Crystal[/color] grants you a Secret[/color][/center]\n"
			text += "You dream of standing in a great field of combat. You look down and see arrows, blades, and magic blasts have destroyed parts of your body. Despite it all, you feel a resurgence of energy within you. You have been hurt...but you will fight again. You MUST fight on. \n[color=lime]You have been granted the secret of [color=green]Second Wind[/color], allowing you personally to survive 1 fatal blow in combat daily.[/color] "
			refCrystal.abilities.append('secondwind')

	elif globals.state.mansionupgrades.dimensionalcrystal >= 3 && !refCrystal.abilities.has('immortality'):
		if rand_range(50,100) <= refCrystal.research:
			text += "\n[center][color=yellow]The [color=#E389B9]Crystal[/color] grants you a Secret[/color][/center]\n"
			text += "You dream that you are the [color=#E389B9]Crystal[/color]. You feel each soul living within the warmth of your glow. You see a shadowy, skeletal entity sneak within your glow and raise a long scythe above one of your beings. You mutter a series of words and sent a part of your essence to banish the entity.\nWhen you awaken, you write the words down. You have been granted the secret of [color=green]Immortality[/color]. "
			refCrystal.abilities.append('immortality')
	
	elif (refCrystal.mode == "dark" || refCrystal.lifeforce <= 0) && !refCrystal.abilities.has('sacrifice'):
		if rand_range(-25,100) <= refCrystal.research:
			text += "\n[center][color=yellow]The [color=#E389B9]Crystal[/color] grants you a Secret[/color][/center]\n"
			text += "You dream that you are famished. You look down and see your ribs poking through your skin. Hunger. You need hunger. You need LIFE! You sit in a corner and wait. A rat scurries into your view.\nLife. Life for you.\nYou rush forward and snap the creatures neck. You sink your teeth in and feel your hunger subside. "
			text += "\n\n[color=yellow]-Good. Good. You know hunger too. You know what it is to consume life.[/color]\nThe voice ripples through you and you see teeth. You look up into it's gaping maw and squeak. Your tail squishes back and forth in a panic and you try to move. But the tentacles around you body aren't going to let you escape. As you feel yourself approach the teeth, you feel your rat-like body crumple and you wake up. For better or worse, you now know two things. You know how you can feed the [color=#E389B9]Crystal[/color]. And now, you know you must."
			refCrystal.abilities.append('sacrifice')
	
	elif refCrystal.abilities.has('sacrifice') && !refCrystal.abilities.has('understandsacrifice'):
		if rand_range(0,100) <= refCrystal.research:
			text += "\n[center][color=yellow]The [color=#E389B9]Crystal[/color] grants you a Secret[/color][/center]\n"
			text += "You dream that you standing in front of the [color=#E389B9]Crystal[/color]. It extends a tendril and gently touches the body of a lifeless human beside you. The tendril extends into the body's mouth, slithers through her body, and stands the corpse up like a puppet on a string. It then violently rips its tendril out of the corpse's mouth. The human woman opens her eyes and screams herself back to life. "
			text += "You look in amazement as the woman turns to walk off. You look at the [color=#E389B9]Crystal[/color] and see cracks and veins start to appear in it's surface. You see a tendril reach out towards you.\nYou open your mouth to protest 'I am still alive!' and a loud bleating erupts from your lips. It reaches into your open mouth and extends through your body. You sense it draining every one of your levels to restore it's hunger, then finally take your lifeforce back into it. As your soul splits off from your body, you see the cracks and veins healing. "
			text += "You now understand how the sacrifices work. "
			refCrystal.abilities.append('understandsacrifice')
	
	refCrystal.research = 0

	return text

func getCrystalResearcher():
	var researcher
	for person in globals.slaves:
		if person.work == 'crystalresearcher':
			researcher = person
			break
	return researcher

func dailyUpdate(person):
	#Returns to go into Daily
	var alerttext = ""
	#Is put in Person.Log, which then goes into Person
	var personaltext = ""
	var worktext = ""
	var thoughtstext = ""
	#Replace with Above
	var text = ""
	var temptext = ""
	var moodchange = 0

	#Reset Daily Convos
	person.dailytalk.clear()

	updatePerson(person)
	#Header
	if person != globals.player:
		text += person.dictionary("[color=#d1b970][center]$name[/center][/color]\n")
	
	#Pregnancy Dailies
	temptext = dailyPregnancy(person)
	if temptext != null:
		text += temptext
	dailyBioClock(person)
	#Lactation Dailies
	temptext = dailyLactation(person)
	if temptext != "":
		text += temptext

	#Hole Stretching Notification and Reset
	if person.dailyevents.has('vagTorn') == true:
		text += "\n[center][color=red]Stretched Pussy[/color][/center]\n$name's " +namePussy()+ " was stretched out and seems to be sore still. $He was seen rubbing it several times today while " + nameCrying() + ". Sleeping should ease $his pain.\n"
	if person.dailyevents.has('assTorn') == true:
		text += "\n[center][color=red]Stretched Asshole[/color][/center]\n$name's " +nameAsshole()+ " was stretched out and seems to be sore still. $He was seen rubbing it several times today while " + nameCrying() + ". Sleeping should ease $his pain.\n"

	#Tightening Chance
	text += dailyTighten(person,'all')

	#Cum Drip (Will move to bath) || Expanded by Deviate
	var vagcapacity = getCapacity(person, person.vagina)
	var asscapacity = getCapacity(person, person.asshole)
	
	if person.cum.mouth > 0 && person.fetish.drinkcum in ['mindblowing','enjoyable','acceptable']:
		text += "\n$name had " +nameCum()+ " still in $his mouth and swallowed it. "
		person.cum.mouth = 0
	elif person.cum.mouth > 0:
		text += "\n$name had " +nameCum()+ " still in $his mouth and washed it out. "
		person.cum.mouth = 0
	
	#---Daily Baths
	#Player (Auto)
	if person == globals.player:
		var triggered_cum_cleaning = false
		for i in ['face', 'body', 'pussy', 'ass']:
			if person.cum[i] > 0:
				triggered_cum_cleaning = true
				person.cum[i] = 0
		if triggered_cum_cleaning == true:
			text += "\nYou still had " +nameCum()+ " on you, so you washed it all out while taking your daily bath. "
	#Bath (Cleans All)
	elif person.rules.personalbath == true:
		if person.cum.face > 0:
			text += "\n$name had " +nameCum()+ " on $his face from the day's activities and washed it off while bathing. "
			person.cum.face = 0
		if person.cum.body > 0:
			text += "\n$name had " +nameCum()+ " stuck to $his body and washed it off while bathing. "
			person.cum.body = 0
		if person.cum.ass > 0:
			text += "\n$name had " +nameCum()+ " still in $his " + nameAsshole() + " and washed it all out while bathing. "
			person.cum.ass = 0
		if person.cum.pussy > 0:
			text += "\n$name had " +nameCum()+ " still in $his " + namePussy() + " and washed it all out while bathing. "
			person.cum.pussy = 0
		#Semen Clearing for Fun Times
		for i in person.preg.womb:
			person.preg.womb.erase(i)
	#Chance to Clean
	else:
		if person.cum.face > 15:
			text += "\n$name had " +nameCum()+ " on $his face from the day's activities and washed it off. "
			person.cum.face = 0
		elif person.cum.face > 0 && person.fetish.wearcumface in ['mindblowing','enjoyable','acceptable']:
			text += "\n$name had " +nameCum()+ " on $his face from the day's activities. "
		elif person.cum.face > 0:
			text += "\n$name had " +nameCum()+ " on $his face from the day's activities and washed it off. "
			person.cum.face = 0
		
		if person.cum.body > 15:
			text += "\n$name had " +nameCum()+ " stuck to $his body and cleaned it off. "
			person.cum.body = 0
		elif person.cum.body > 0 && person.fetish.wearcum in ['mindblowing','enjoyable','acceptable']:
			text += "\n$name had " +nameCum()+ " stuck to $his body. "
		elif person.cum.body > 0:
			text += "\n$name had " +nameCum()+ " stuck to $his body and cleaned it off. "
			person.cum.body = 0

	person.cum.face = max(0, person.cum.face - .5)
	person.cum.body = max(0, person.cum.body - .5)

	if person.cum.ass > 0:
		if person.fetish.creampieass in ['mindblowing','enjoyable','acceptable']:
			if person.cum.ass > asscapacity * 2:
				text += "\n$name had " +nameCum()+ " still in $his asshole. Throughout the day some drained down $his thighs. "
				person.cum.ass -= person.cum.ass *.5
			elif person.cum.ass > asscapacity:
				text += "\n$name had " +nameCum()+ " still in $his asshole. Throughout the day some drained down $his thighs. "
				person.cum.ass -= person.cum.ass *.25
			else:
				text += "\n$name had " +nameCum()+ " still in $his asshole. "	
		else:
			if person.cum.ass > asscapacity * 2:
				text += "\n$name had " +nameCum()+ " still in $his asshole and washed out as much of it as $he could. "
				person.cum.ass -= person.cum.ass *.5
			elif person.cum.ass > asscapacity:
				text += "\n$name had " +nameCum()+ " still in $his asshole and washed out as much of it as $he could. "
				person.cum.ass -= person.cum.ass *.25
			else:
				text += "\n$name had " +nameCum()+ " still in $his asshole and washed it out. "
				person.cum.ass = 0

	person.cum.ass = max(0, person.cum.ass - .2)
	
	if person.cum.pussy > 0:
		if person.fetish.creampiepussy in ['mindblowing','enjoyable','acceptable']:
			if person.cum.pussy > vagcapacity * 2:
				text += "\n$name had " +nameCum()+ " still in $his pussy. Throughout the day some drained down $his thighs. "
				person.cum.pussy -= person.cum.pussy *.5	
			elif person.cum.pussy > vagcapacity:
				text += "\n$name had " +nameCum()+ " still in $his pussy. Throughout the day some drained down $his thighs. "
				person.cum.pussy -= person.cum.pussy *.25
			else:
				text += "\n$name had " +nameCum()+ " still in $his pussy. "
		elif (person.consentexp.pregnancy == true || person.consentexp.breeder == true || person.consentexp.incestbreeder == true) && person.preg.baby != null:
			if person.cum.pussy > vagcapacity * 2:
				text += "\n$name had " +nameCum()+ " still in $his pussy. $He left it inside hoping $he would get pregnant. Throughout the day some drained down $his thighs. "
				person.cum.pussy -= person.cum.pussy *.5
			elif person.cum.pussy > vagcapacity:
				text += "\n$name had " +nameCum()+ " still in $his pussy. $He left it inside hoping $he would get pregnant. Throughout the day some drained down $his thighs. "
				person.cum.pussy -= person.cum.pussy *.25
			else:
				text += "\n$name had " +nameCum()+ " still in $his pussy. $He left it inside hoping $he would get pregnant. "
		else:
			if person.cum.pussy > vagcapacity * 2:
				text += "\n$name had " +nameCum()+ " still in $his pussy and washed out as much of it as $he could. Throughout the day some drained down $his thighs. "
				person.cum.pussy -= person.cum.pussy *.5	
			elif person.cum.pussy > vagcapacity:
				text += "\n$name had " +nameCum()+ " still in $his pussy and washed out as much of it as $he could. Throughout the day some drained down $his thighs. "
				person.cum.pussy -= person.cum.pussy *.25
			else:
				text += "\n$name had " +nameCum()+ " still in $his pussy and washed it out. "
				person.cum.pussy = 0
	person.cum.pussy = max(0, person.cum.pussy - .2)

	#Consent Changes: Will Change to Giving Consent in Dialogue Only
	if person.consentexp.incest == false && person.fetish.incest in ['mindblowing','enjoyable']:
		text += "\n$name seems to be talking differently about $his thoughts on [color=aqua]Incest[/color]. $He doesn't seem to mind it anymore."
		person.consentexp.incest = true

	#---Clothing Status
	text += person.updateClothing()

	#Chance to Add/Remove Lisp or Mute due to oversized Lips
	if person.npcexpanded.temptraits.find('vocaltraitdelay') >= 0:
		person.npcexpanded.temptraits.remove('vocaltraitdelay')
	elif globals.lipssizearray.find(person.lips) >= 6:
		var delays = round(rand_range(0,3)) + globals.lipssizearray.find(person.lips)
		var liparray = globals.lipssizearray
		var lipincreasechance = globals.expansionsettings.lipstraitbasechance + (10*(liparray.find(person.lips)-6))
		#Check for Negative
		if person.traits.has('Mute') == false:
			if person.traits.has('Lisp') == false:
				if rand_range(0,100) <= lipincreasechance:
					person.add_trait('Lisp')
					person.npcexpanded.temptraits.append('Lisp')
					text += "\n$name has started talking with a [color=red]Lisp[/color] due to the unnaturally swollen size of $his lips."
			else:
				if rand_range(0,100) <= lipincreasechance*.5 || person.traits.has('Lisp') && person.npcexpanded.temptraits.has('lisp') && rand_range(0,100) <= lipincreasechance:
					person.add_trait('Mute')
					person.npcexpanded.temptraits.append('Mute')
					text += "\n$name is no longer able to speak due to $his massive lips. $He is now [color=red]Mute[/color]."
		elif person.npcexpanded.temptraits.has('Mute') && person.traits.has('Mute'):
			if rand_range(0,100) <= lipincreasechance:
				person.add_trait('Lisp')
				person.npcexpanded.temptraits.append('Lisp')
				person.trait_remove('Mute')
				person.npcexpanded.temptraits.remove('Mute')
				text += "\n$name seems to be able to audibly talk through $his massive lips again. $He is no longer [color=red]Mute[/color] and now merely speaks with a heavy [color=red]Lisp[/color]."
		elif person.npcexpanded.temptraits.has('Lisp') && person.traits.has('Lisp'):
			if rand_range(0,100) <= lipincreasechance:
				person.trait_remove('Lisp')
				person.npcexpanded.temptraits.remove('Lisp')
				text += "\n$name seems to be able to talk unhindered again. $He no longer seems to have a lisp."
		#Add a Delay Timer to keep from spamming
		while delays > 0:
			person.npcexpanded.temptraits.append('vocaltraitdelay')
			delays -= 1
	
	#Clamp Jobskills at 0-100
	var job = person.work
	for i in person.jobskills:
		person.jobskills[i] = clamp(person.jobskills[i], 0, 100)
#	Run "Job" (adding person.JobSkill.job if any), returning "Success", "Failure", or "None"
#	var workresult = dailyWork(person,job)

	#Increase or Decrease Job Skill
#	dailyJobSkill(person,job,workresult)

	###Night Phase###

	dailyFetish(person)

	#Check Milk Leak
	if person.lactation == true && person.lactating.milkedtoday == false && person.lactating.milkstorage > 0:
		getMilkLeak(person,50)
#		dailyMilking(person,'none',false)
	
	#Resets it for the next day
	person.lactating.milkedtoday = false

	#Reset the Tracked Events for Tomorrow
	person.dailyevents.clear()

	return person.dictionary(text)

#---Daily Stretching
func dailyTighten(person,hole='all'):
	var text = ""
	var ages = ['none','child','teen','adult']
	var age = ages.find(person.age)
	var ageinverted = (age-4)*-1
	var height = globals.heightarrayexp.find(person.height)
	var averagesize = 0
	var mod = 0
	var difference = 0
	var clamper = 0
	var number = 0

	#Tightening Mods: Race, Elasticity
	if person.findRace(['Goblin','Gnome','Fairy']):
		mod -= 1
	mod = mod - person.sexexpanded.elasticity - round(rand_range(-1,1))

	#Check Vagina
	if hole in ['all','vagina'] && person.vagina != "none":
		averagesize = age + round((1+height)*.5) + mod
		averagesize = clamp(averagesize, 1, 5)
		#Minimum is Average Size for Age
		if averagesize < globals.vagsizearray.find(person.vagina) && rand_range(0,100) <= globals.expansionsettings.vaginaltightenchance * ageinverted:
			difference = globals.vagsizearray.find(person.vagina) - averagesize
			#Tighten
			if rand_range(0,100) <= globals.vagsizearray.find(person.vagina) + (difference*10) + (ageinverted*5) + (person.sexexpanded.elasticity*20):
				clamper = globals.vagsizearray.find(person.vagina)-1
				number = clamp(clamper,0,globals.vagsizearray.size()-1)
				person.vagina = globals.vagsizearray[number]
				text += "[color=green]$name's " +namePussy()+ " naturally tightened today. It is now " + str(person.vagina) + ".[/color]\n"
	#Check Asshole
	if hole in ['all','asshole'] && person.asshole != "none" && rand_range(0,100) <= globals.expansionsettings.analtightenchance * ageinverted:
		averagesize = age + round((1+height)*.5) + mod
		averagesize = clamp(averagesize, 1, 5)
		#Minimum is Average Size for Age
		if averagesize < globals.assholesizearray.find(person.asshole):
			difference = globals.assholesizearray.find(person.asshole) - averagesize
			#Tighten
			if rand_range(0,100) <= globals.assholesizearray.find(person.asshole) + (difference*10) + (ageinverted*5) + (person.sexexpanded.elasticity*20):
				clamper = globals.assholesizearray.find(person.asshole)-1
				number = clamp(clamper,0,globals.assholesizearray.size()-1)
				person.asshole = globals.assholesizearray[number]
				text += "[color=green]$name's " +nameAsshole()+ " naturally tightened today. It is now " + str(person.asshole) + ".[/color]\n"
	return text


#---Category: Better NPCs---#
enum {NPC_ID, NPC_ZONE, NPC_REMEET, NPC_ACTION, NPC_REP, NPC_STATUS}

func dailyNPCs():

	#Reset Town Reports
	for towns in ['wimborn','frostford','gorn','amberguard']:
		#Backwards Compatibility
		if !globals.state.townsexpanded[towns].has('dailyreport'):
			globals.state.townsexpanded[towns]['dailyreport'] = {shopping = 0, crimeattempted = 0, crimeprevented = 0, crimesucceeded = 0}
		for report in ['shopping','crimeattempted','crimeprevented','crimesucceeded']:
			globals.state.townsexpanded[towns].dailyreport[report] = 0

	#offscreennpcs = [person.id, location.code, encounterchance, action, reputation, status]
	for npcs in globals.state.offscreennpcs:
		var npc = globals.state.findnpc(npcs[NPC_ID])
		#Null Check and Clear
		if npc == null:
			globals.state.offscreennpcs.erase(npcs)
			continue

		#Backwards Compatibility
		if !npc.diet.has('hunger'):
			npc.diet['hunger'] = 0
		if !npc.npcexpanded.possessions.has('food'):
			npc.npcexpanded.possessions['food'] = 0

		#Determine Pregnancy, Swelling, & Movement
		dailyPregnancy(npc)
		getSwollen(npc)
		getMovement(npc)

		#---Actions
		#Detained is Arrested and applied from the TownGuard.
		#Add Detained Punishments later
		if npcs[NPC_ACTION] == "detained":
			continue
		var canact = true
		var needgold = false
		#Can also be 'success','fail'
		var crime = 'none'

		#Variables
		var cities = citiesarray
		var outskirts = outskirtsarray
		var wilderness = wildernessarray
		var actions = npcactions
		var number = 0

		#---Actions Encounter Chance Reset
		if npcs[NPC_ACTION] == 'fleeing':
			npcs[NPC_REMEET] -= 25
		elif npcs[NPC_ACTION] == 'escaping':
			npcs[NPC_REMEET] += 10
		elif npcs[NPC_ACTION] == 'hiding':
			npcs[NPC_REMEET] += 25
		elif npcs[NPC_ACTION] == "resting":
			npcs[NPC_REMEET] += 5
		elif npcs[NPC_ACTION] == "shopping":
			npcs[NPC_REMEET] -= 25

		#---Reactionary Actions

		#Defeated (After Combat/Released)
		if npcs[NPC_ACTION] == "defeated" && rand_range(0,100) <= actions.defeated:
			npcs[NPC_ACTION] = "recover"
			canact = false
		#Raped
		if npcs[NPC_ACTION] == "raped" && rand_range(0,100) <= actions.raped:
			npc.lust -= round(rand_range(npc.lust/2,npc.lust))
			npcs[NPC_REMEET] -= 10
			npcs[NPC_ACTION] = "recover"
			canact = false
		#Pregnancy and Childbirth
		if npc.preg.duration >= globals.state.pregduration && rand_range(0,100) <= actions.childbirth:
			npcs[NPC_ACTION] = "childbirth"
			canact = false
		elif npcs[NPC_ACTION] == "childbirth":
			npcChildbirth(npc)
			npcs[NPC_REMEET] -= 10
			npcs[NPC_ACTION] = "recover"
			canact = false

		#Recovery (Can take several turns)
		if npcs[NPC_ACTION] == "recover":
			if rand_range(0,100) > actions.recover:
				canact = false
			else:
				npcs[NPC_REMEET] -= 10

		#---Escaping and Hiding (Escaping via Crime Fail, Combat Escape, or Slave Escape)
		if npcs[NPC_ACTION] == "fleeing":
			npcs[NPC_REMEET] += 25
			if rand_range(0,100) <= actions.escapechance:
				npcs[NPC_ACTION] = "escaping"
			canact = false
		elif npcs[NPC_ACTION] == "escaping":
			npcs[NPC_REMEET] -= 10
			if rand_range(0,100) <= actions.hidechance:
				npcs[NPC_ACTION] = "hiding"
			canact = false
		elif npcs[NPC_ACTION] == "hiding":
			if rand_range(0,100) > actions.stophiding:
				npcs[NPC_REMEET] -= 25
				canact = false

		if !canact:
			continue
		##############################################################################
		#Hunger Chain
		if npc.diet.hunger > 0 && actions.hunger:
			#Eat all their Food
			if npc.npcexpanded.possessions.food > 0:
				number = round(rand_range(1, npc.npcexpanded.possessions.food))
				npc.npcexpanded.possessions.food -= number
				npc.diet.hunger = round(0 - (number*.75))
				npcs[NPC_REMEET] -= 5
				npcs[NPC_ACTION] = "resting"

			#Buy Food
			elif npc.npcexpanded.possessions.gold > 0:
				#Citizens Shopping
				if npcs[NPC_REP] >= 0 && npc.npcexpanded.possessions.gold >= 2:
					if !npcs[NPC_ZONE] in cities:
						npcs[NPC_ZONE] = npcTravel(npcs[NPC_ZONE],'city')
					number = round(rand_range(2,npc.npcexpanded.possessions.gold))
					npc.npcexpanded.possessions.gold -= number
					npc.npcexpanded.possessions.food += round(number/2)
					npcs[NPC_REMEET] += 25
					npcs[NPC_REP] += 1
					npcs[NPC_ACTION] = "shopping"
				#Criminals Shopping (Double-Price for Bribes/Discretion)
				if npcs[NPC_REP] < 0 && npc.npcexpanded.possessions.gold >= 4:
					if !npcs[NPC_ZONE] in cities:
						npcs[NPC_ZONE] = npcTravel(npcs[NPC_ZONE],'city')
					number = round(rand_range(4,npc.npcexpanded.possessions.gold))
					npc.npcexpanded.possessions.gold -= number
					npc.npcexpanded.possessions.food += round(number/4)
					npcs[NPC_REMEET] += 25
					npcs[NPC_REP] += 1
					npcs[NPC_ACTION] = "shopping"
				#Work/Crime
				else:
					needgold = true
			else:
				needgold = true

		#Determine Work/Crime
		if needgold == true:
			#Citizen
			if npcs[NPC_REP] >= 0:
				if !npcs[NPC_ZONE] in cities:
					npcs[NPC_ZONE] = npcTravel(npcs[NPC_ZONE],'city')
				number = (globals.originsarray.find(npc.origins)+1)*2
				npc.npcexpanded.possessions.gold = round(rand_range(1,number))
				npcs[NPC_REP] += 1
				npcs[NPC_ACTION] = "working"
			#Criminal
			if npcs[NPC_REP] < 0:
				if !npcs[NPC_ZONE] in outskirts:
					npcs[NPC_ZONE] = globals.randomitemfromarray(outskirts)
				if npcs[NPC_ACTION] == 'plotting':
					npcs[NPC_ACTION] = 'plottedcrime'
				else:
					npcs[NPC_ACTION] = "crime"
		else:
			if npcs[NPC_REP] <= 0:
				if npcs[NPC_ACTION] == 'plotting':
					npcs[NPC_ACTION] = 'plottedcrime'
				elif rand_range(0,100) <= actions.plancrime + npc.wit:
					npcs[NPC_ACTION] = 'plotting'
					if rand_range(0,100) <= 25:
						npcs[NPC_ZONE] = npcTravel(npcs[NPC_ZONE],'wilderness')
					else:
						npcs[NPC_ZONE] = npcTravel(npcs[NPC_ZONE],'outskirts')
				else:
					npcs[NPC_ACTION] = 'roaming'
			else:
				if rand_range(0,100) <= actions.workchance:
					if !npcs[NPC_ZONE] in cities:
						npcs[NPC_ZONE] = npcTravel(npcs[NPC_ZONE],'city')
					number = (globals.originsarray.find(npc.origins)+1)*2
					npc.npcexpanded.possessions.gold = round(rand_range(1,number))
					npcs[NPC_REP] += 1
					npcs[NPC_ACTION] = "working"
				else:
					npcs[NPC_ACTION] = 'roaming'

		if npcs[NPC_ACTION] in ['plottedcrime','crime']:
			var crimedifficulty = 0
			if !npcs[NPC_ZONE] in outskirts + cities:
				npcs[NPC_ZONE] = npcTravel(npcs[NPC_ZONE],'outskirts')

			if npcs[NPC_ZONE] in cities:
				crimedifficulty += rand_range(0,50)
			else:
				crimedifficulty += rand_range(0,25)

			if npcs[NPC_ACTION] == 'plottedcrime':
				crimedifficulty = crimedifficulty/2

			if rand_range(0,100) >= crimedifficulty:
				#Got Gold
				number = round(rand_range(2,10))
				if npcs[NPC_ACTION] == 'plottedcrime':
					number += round(rand_range(5,10))
				if npcs[NPC_ZONE] in cities:
					number += round(rand_range(1,20))
				npc.npcexpanded.possessions.gold += number

				#Stopped to Rape
				if rand_range(50,100) >= npc.lust:
					npc.lust -= round(rand_range(npc.lust/2,npc.lust))
					crimedifficulty += rand_range(0,25)
					npcs[NPC_REP] -= 1

				#Got Away Clean
				if rand_range(0,100) >= crimedifficulty*(number/5):
					if rand_range(0,100) <= actions.robfoodchance:
						npc.npcexpanded.possessions.food += round(rand_range(1,5))
					crime = 'succeeded'
					npcs[NPC_REP] -= 1
					npcs[NPC_ACTION] = 'hiding'
				#Caught and Running
				else:
					crime = 'interrupted'
					npcs[NPC_REP] -= round(number/5)
					npcs[NPC_ACTION] = 'fleeing'

			#Crime Aborted
			else:
				crime = 'attempted'
				npcs[NPC_REP] -= 1
				npcs[NPC_ACTION] = 'escaping'

		#Random Travel
		if npcs[NPC_ACTION] == 'roaming' && rand_range(0,100) <= actions.npctravelchance:
			npcs[NPC_REP] += round(rand_range(-1,1))
			if npcs[NPC_REP] >= 0:
				npcs[NPC_ZONE] = npcTravel(npcs[NPC_ZONE],'outskirts')
			else:
				npcs[NPC_ZONE] = npcTravel(npcs[NPC_ZONE],'any')

		#Gain Daily Needs
		npc.diet.hunger += 1
		npc.lust += round(rand_range(0,10))

		if globals.state.perfectinfo == true:
			globals.state.relativesdata[str(npc.id)].state = npcs[NPC_ACTION]

		#Metrics for Reports
		#dailyreport = {shopping = 0, crimeattempted = 0, crimeprevented = 0, crimesucceeded = 0}
		var town
		if npcs[NPC_ZONE] in ['wimborn','wimbornoutskirts','shaliq']:
			town = globals.state.townsexpanded.wimborn
		elif npcs[NPC_ZONE] in ['gorn','gornoutskirts']:
			town = globals.state.townsexpanded.gorn
		elif npcs[NPC_ZONE] in ['frostford','frostfordoutskirts']:
			town = globals.state.townsexpanded.frostford
		elif npcs[NPC_ZONE] in ['amberguard','amberguardoutskirts']:
			town = globals.state.townsexpanded.amberguard
		else:
			continue

		if npcs[NPC_ACTION] == 'shopping':
			town.dailyreport.shopping += 1
		elif crime == "attempted":
			town.dailyreport.crimeattempted += 1
		elif crime == "interrupted":
			town.dailyreport.crimeprevented += 1
		elif crime == "succeeded":
			town.dailyreport.crimesucceeded += 1

	#----Old NPC Action Ideas Below This---#
#	var goodactions = ['shopping','working','guarding']
#	var neutralactions = ['hiding','hunting','roaming','defeated','resting','washing','birthing']
#	var badactions = ['murdering','kidnapping','raping','robbing','escaping','plotting']
#	var freeactions = badactions + neutralactions + goodactions
#	var punishmentactions = ['condemned','flogging','stocks','pillory','cage']

func npcTravel(npclocation, goal='any'):
	var cities = citiesarray
	var outskirts = outskirtsarray
	var wilderness = wildernessarray
	var location = npclocation
	var destination = ""

	if goal == "city":
		if location in ['wimbornoutskirts','frostfordoutskirts','gornoutskirts']:
			destination = location.replace('outskirts','')
		elif location == 'amberguardforest':
			destination = location.replace('forest','')
		else:
			destination = globals.randomitemfromarray(cities)
	elif goal == "outskirts":
		if location in ['wimborn','frostford','gorn']:
			destination = location + 'outskirts'
		elif location == 'amberguard':
			destination = location + 'forest'
		else:
			destination = globals.randomitemfromarray(outskirts)
	elif goal == "wilderness":
		destination = globals.randomitemfromarray(wilderness)
	else:
		var alllocations = cities + outskirts + wilderness
		destination = globals.randomitemfromarray(alllocations)
	return destination


func dailyTownGuard():
	###Overhaul This: Check each town for any NPCs around it, then if their activity, then capture
	var text = ""
	var alltext = ""
	var zones = globals.areas.database
	var location = ""
	var baddie
	#Town Guard hunting (trimming) the existing enemies

	for town in citiesarray:
		text = ""
		var guard_efficiency = globals.state.townsexpanded[town].guardskill + globals.expansionsettings.townguardefficiency
		for npcs in globals.state.offscreennpcs:
			var zonecode = npcs[NPC_ZONE]
			var zone = zones[zonecode]
			if zone == null:
				continue
			#Find the Relevant Guards
			if zone.tags.find("wimborn") >= 0:
				location = 'wimborn'
			elif zone.tags.find("frostford") >= 0:
				location = 'frostford'
			elif zone.tags.find("gorn") >= 0:
				location = 'gorn'
			elif zone.tags.find("amberguard") >= 0:
				location = 'amberguard'
			else:
				location = npcs[NPC_ZONE]

			if location != town || location == null:
				continue

			if globals.state.offscreennpcs.size() > globals.expansionsettings.minimum_npcs_to_detain && rand_range(0,100) - rand_range(0,globals.state.allnpcs.size() - globals.expansionsettings.minimum_npcs_to_detain) <= guard_efficiency + npcs[NPC_REMEET]:
				if npcs[NPC_REP] < 0 || npcs[NPC_ACTION] in ['fleeing','escaping','crime','plottedcrime','hiding']:
					npcs[NPC_ACTION] = 'detained'

					baddie = globals.state.findnpc(npcs[NPC_ID])
					if baddie == null:
						continue

					var source = globals.randomitemfromarray(['News','A report','Word']) + " " + globals.randomitemfromarray(['comes in','arrives','is delivered','is carried'])
					var capturers = globals.randomitemfromarray(['the vigilant town guard','the town guard','a local slaver','a former compatriot','a former lover','a former neighbor'])
					var reason = ""
					if baddie.origins in ['rich','atypical','nobility'] && rand_range(0,1) > .5|| baddie.npcexpanded.citizen == true:
						reason = globals.randomitemfromarray(['failing to file the correct form to petition the guard captain for a permit to form-file','attempted bribery','tax-dodging','tax-collector dodging','general dodginess','sodomy without a permit','unlawful acquistion of wealth','unlawful acquistion of wealth','failure to pay debts'])
					elif baddie.origins in ['slave','poor','commoner']:
						reason = globals.randomitemfromarray(['panhandling','robbery','highway robbery','misdemenours','poaching','loitering','violence','murder','murder most foul','rape','burglery'])
					else:
						reason = globals.randomitemfromarray(['being barbaric','inexcusable nonsense','inopportune flatuelance','rude gesturing'])
					text += "\n" + source + " from [color=aqua]" + location.capitalize() + "[/color]. [color=aqua]" + str(baddie.name_long()) + "[/color] has been brought to justice by the " + capturers + " for " + reason + ". "
					if baddie.sellprice(true) >= rand_range(50,100):
						if location == 'amberguard':
							text += baddie.dictionary("$He has been taken outside of the city and donated to local slavers on their way to ")
							location = globals.randomitemfromarray(['wimborn','gorn','frostford','umbra'])
							text += baddie.dictionary("[color=aqua]" + location.capitalize() + "[/color], where $he will begin $his life of penance as a slave.")
						else:
							text += baddie.dictionary("$He has been released into the custody of the local slave guild in exchange for a small donation to the good citizens of [color=aqua]" + location.capitalize() + "[/color].")
						if rand_range(0,100) >= 25:
							baddie.add_effect(globals.effectdict.captured)
						baddie.obed = rand_range(0,80)
						baddie.fromguild = true
						baddie.npcexpanded.enslavedby == capturers
						globals.state.allnpcs.erase(baddie)
						globals.state.offscreennpcs.erase(npcs)
						globals.guildslaves[location].append(baddie)
					elif rand_range(0,100) <= globals.expansionsettings.randomexecutions - (npcs[NPC_REP]*5) && globals.expansionsettings.brutalcontent == true:
						#Add Executions to All Towns eventually
						text += baddie.dictionary("$He has been scheduled for execution and sent to Wimborn for sentencing. $He will plague the good citizens of [color=aqua]" + location.capitalize() + "[/color] no more.")
						globals.state.offscreennpcs.erase(npcs)
						globals.state.townsexpanded.wimborn.pendingexecution.append(baddie.id)
					else:
						#if baddie.npcexpanded.citizen == true || rand_range(0,100) <= globals.expansionsettings.randomexecutions || globals.expansionsettings.brutalcontent == false:
						text += baddie.dictionary("$He has been set to the colonies to work off $his debt to the people of [color=aqua]" + location.capitalize() + "[/color] in indentured servitude until the price of $his contract is served in " + str(round(rand_range(5,50))) + " years.")
						globals.state.offscreennpcs.erase(npcs)
						globals.state.allnpcs.erase(baddie)
		if text != "":
			globals.state.townsexpanded[town].dailyreport.text = "\n\n[center][color=aqua]Daily Arrest Report[/color][/center]" + text + "\n"
			alltext += text
		else:
			globals.state.townsexpanded[town].dailyreport.text = ""
	if alltext != "":
		alltext = "\n[center][color=#d1b970]------Local Town Report------[/color][/center]\nThe local news has arrived from nearby towns.\n" + alltext + "\n\n"
	return alltext

func npcChildbirth(npc):
	var baby = globals.state.findbaby(npc.preg.baby)
	var text = ''

	#NPC Reset
	npc.metrics.birth += 1
	npc.preg.duration = 0
	npc.preg.fertility = 5
	npc.preg.baby = null
	npc.pregexp.babysize = 0

	#Miscarriage
	if baby == null:
		return

	#Baby Final Setup
	if globals.rules.children == false:
		baby.age = 'teen'
	else:
		baby.age = 'child'
	baby.name = globals.assets.getname(baby)
	baby.surname = npc.surname
	if baby.sex != 'male':
		baby.vagvirgin = true
	baby.assvirgin = true
	#Place Baby
	globals.state.allnpcs = baby
	npc.npcexpanded.possessions.noncombatants.append(baby.id)
	globals.state.relativesdata[baby.id].name = baby.name_long()
	globals.state.relativesdata[baby.id].state = 'normal'
	#Remove Old
	globals.state.babylist.erase(baby)
	baby = null
	#Add very low Baby/Mother die in childbirth chance with an "Encounter" event

func dailyTownEvents():
	var text = ""
	var d100 = 0
	var gold_lost = 0
	var rep_loss = 0
	for town in citiesarray:
		var currenttown = globals.state.townsexpanded[town]
		#Votes
		if currenttown.currentevents.has('vote_public_nudity'):
			currenttown.currentevents.erase('vote_public_nudity')
			d100 = round(rand_range(0,100))
			if d100 <= currenttown.nudity:
				currenttown.currentevents.append('public_nudity_success')
				currenttown.laws.public_nudity = true
				text += "\n\n[center]Council Vote![/center]\nThe town council of [color=aqua]" + town.capitalize() + "[/color] voted on a proposition to legalize Public Nudity today. This vote received enough support from the citizens of the town to pass! [color=aqua]Public nudity[/color] is now [color=lime]Legal[/color]."
			else:
				currenttown.currentevents.append('public_nudity_failure')
				text += "\n\n[center]Council Vote![/center]\nThe town council of [color=aqua]" + town.capitalize() + "[/color] voted on a proposition to legalize Public Nudity today. This vote did not receive enough support from the citizens of the town to pass. [color=aqua]Public nudity[/color] remains [color=red]Illegal[/color]."
			if globals.expansionsettings.perfectinfo == true:
				text += "\n[color=yellow]Perfect Info[/color] - [color=aqua]Public Nudity Success Chance[/color] of [color=aqua]" + str(currenttown.nudity) + "[/color]; Rolled [color=aqua]" + str(d100) + "[/color]\n"
		#Fines
		if !currenttown.townhall.fines.empty():
			if currenttown.townhall.autopay_fines == true:
				for fine in currenttown.townhall.fines:
					gold_lost -= int(fine[1])
					currenttown.townhall.fines.erase(fine)
			else:
				for fine in currenttown.townhall.fines:
					if int(fine[0]) >= globals.resources.day + 3:
						rep_loss = round(fine[1]/5)
						globals.state.reputation[town] -= rep_loss
						text += "\n[color=red]An outstanding fine in [color=aqua]" + town.capitalize() + "[/color] for [color=yellow]" + str(fine[1]) + "[/color] expired today due to non-payment. You lost [color=aqua]" + str(rep_loss) + " Reputation[/color] with the town due to this. "
						currenttown.townhall.fines.erase(fine)
			if gold_lost > 0:
				text += "\n\nYou spent a total of [color=yellow]" + str(gold_lost) + "[/color] paying off existing [color=red]fines[/color] today in [color=aqua]" + town.capitalize() + "[/color]. "
				globals.resources.gold -= gold_lost
		
	return text

func getTownReportText(senttown):
	#Expand to discuss Poverty Levels, Important NPCs, Events (Weddings? Graduations? Disappearances?)
	var town = globals.state.townsexpanded[senttown]
	var nonews = true
	var text = ""
	#Old Array, Keep for Outdoors? globals.randomitemfromarray(['the local newspaper stand','the town cryer','the daily town scroll','a local urchin'])
	text += "You approach " + globals.randomitemfromarray(['the front desk','a cute but bored looking receptionist','the bulletin board','the newspaper stand','a bored looking guard'])
	text += " to get the local news from yesterday. You learn that yesterday"
	if town.dailyreport.shopping > 0:
		text = " [color=aqua]" +str(town.dailyreport.shopping)+ "[/color] new traders and merchants came to town"
		nonews = false
	if town.dailyreport.crimeattempted > 0:
		if town.dailyreport.shopping > 0:
			text += ", "
		else:
			text += " "
		text = "[color=aqua]" +str(town.dailyreport.shopping)+ "[/color] criminals were thwarted by thwarted by the town guard before doing any damage"
		nonews = false
	if town.dailyreport.crimeprevented > 0:
		if town.dailyreport.shopping > 0 || town.dailyreport.crimeattempted > 0:
			text += ", "
		else:
			text += " "
		text = "[color=aqua]" +str(town.dailyreport.shopping)+ "[/color] criminals were stopped mid-crime by the town guard"
		nonews = false
	if town.dailyreport.crimesucceeded > 0:
		if town.dailyreport.shopping > 0 || town.dailyreport.crimeattempted > 0 || town.dailyreport.crimeprevented > 0:
			text += ", "
		else:
			text += " "
		text = "[color=aqua]" +str(town.dailyreport.shopping)+ "[/color] criminals escaped the law after doing their heinous deeds"
		nonews = false
	if nonews == true:
		text += " nothing of interest happened. "
	else:
		text += " and nothing else of note happened. "

	if !town.pendingexecution.empty():
		text += "There are also [color=aqua]" +str(town.pendingexecution.size())+ "[/color] people awaiting sentencing and execution in the town dungeon right now. "
	
	#Town Events
	if !town.currentevents.empty():
		if town.currentevents.has('public_nudity_success'):
			text += "\n\n[center]Council Vote![/center]\nThe Council voted on a proposition to legalize Public Nudity yesterday. This vote received enough support from the citizens of the town to pass! [color=aqua]Public nudity[/color] is now [color=lime]Legal[/color]."
		if town.currentevents.has('public_nudity_failure'):
			text += "\n\n[center]Council Vote![/center]\nThe Council voted on a proposition to legalize Public Nudity yesterday. This vote did not receive enough support from the citizens of the town to pass. [color=aqua]Public nudity[/color] remains [color=red]Illegal[/color]."
		town.currentevents.clear()
		
	if town.dailyreport.text != "":
		text += town.dailyreport.text
	return text

#Not Yet Implimented
func dailyThoughts(person):
	#Runs Daily (to be Added to). Determines Conversation Intros for the Day
	#Current Thought pulled from randomitemfromarray(person.mind.thoughts)
	var variable
	#thoughtTired
	person.mind.thoughts.clear()
	if person.energy <= 50:
		variable = round((50-person.energy)*.1)
		while variable > 0:
			person.mind.thoughts.append('tired')
			variable -=1
	#thoughtHorny
	if person.lust >= 50:
		variable = round((person.lust-50)*.1)
		while variable > 0:
			person.mind.thoughts.append('horny')
			variable -=1
	#thoughtHungry
#	if person.diet.hunger > 0:
#		variable = person.diet.hunger
#		while variable > 0:
#			person.mind.thoughts.append('hungry')
#			variable -=1
	#thoughtReproduce
	if person.preg.duration == 0 && person.pregexp.desiredoffspring > person.metrics.birth:
		person.mind.thoughts.append('reproduce')
	#thoughtPregnancy
	if person.preg.duration > 0:
		variable = round(person.preg.duration*.1)
		while variable > 0:
			person.mind.thoughts.append('pregnancy')
			variable -=1
	#thoughtLuxury (from Daily Events and Greed)
	#thought

	#Flaws
	if person.mind.flaw == 'sloth':
		person.mind.thoughts.append('tired')
	elif person.mind.flaw == 'gluttony':
		person.mind.thoughts.append('hungry')
	elif person.mind.flaw == 'lust':
		person.mind.thoughts.append('horny')


func dailyFetish(person):
	#Update and Possibly Increase Fetishes Daily
	for i in globals.fetishesarray:
		var numDailyFetish = person.dailyevents.count(i)
		var idxFetishOpinion = globals.fetishopinion.find( person.fetish[i])
		#Chance to Increase Fetish
		if idxFetishOpinion < globals.fetishopinion.size() - 1:
			if numDailyFetish + rand_range(0,2) >= idxFetishOpinion * 2:
				person.fetish[i] = globals.fetishopinion[ idxFetishOpinion + 1]
		#Chance to Lower Fetish (Changable Per Setting)
		elif globals.expansionsettings.fetishescanlower == true && idxFetishOpinion > 3 && person.away.duration != 0:
			if rand_range(0,1) <= .1 && numDailyFetish < idxFetishOpinion/3:
				person.fetish[i] = globals.fetishopinion[ idxFetishOpinion - 1]
		while numDailyFetish > 0:
			person.dailyevents.erase(i)
			numDailyFetish -= 1

func getSecret(person,discovery='none'):
	var share = false
	if discovery != 'none':
		#Create Fetish if there isn't one
		if !person.fetish.has(discovery):
			person.fetish[discovery] = globals.randomitemfromarray(globals.fetishopinion)
		if person.knowledge.has(discovery):
			return false
		#Check Fetish + Loyalty (max 13) vs Default 5
		if ((globals.fetishopinion.find(person.fetish[discovery])-3)*10) + person.loyal >= secretsharechance:
			setWantedPregnancy(person)
			person.dailytalk.append(discovery)
			person.mind.secrets.erase(discovery)
			share = true
		else:
			setWantedPregnancy(person)
			person.mind.secrets.append(discovery)
			person.dailytalk.erase(discovery)
			share = false
	return share


#---Category: Lactation---#
func dailyLactation(person):
	var text = ""
	var lact = person.lactating
	var regen = 0
	var milkstorage = 0
	var pressure = 0
	var traitmod = 0
	var traitrank = 0
	person.lactating.milkstorage = clamp(person.lactating.milkstorage, 0, 100)

	if globals.expansionsettings.lactationstops == true && person.lactating.hyperlactation == false:
		if lact.daysunmilked > 0 && person.preg.duration == 0 && rand_range(0,100) - lact.daysunmilked <= chancelactationstops:
			person.lactation = false
			person.lactating.duration = 0
			if person.knowledge.has('lactating'):
				text = "[center][color=red]$name's "+str(getChest(person))+" has gone unmilked for too long and $his lactation has dried up.[/color][/center]\n "
				person.knowledge.erase('lactating')

	if person.lactation == false:
		return text

	#Setup and Time Tracking
	if lact.duration == 0:
		globals.expansionsetup.setLactation(person)
	lact.duration += 1

	#Gain Lactation Fetish
	if rand_range(0,100) <= person.lactating.duration*globals.expansionsettings.lactationacceptancemultiplier:
		if person.fetish.lactation != globals.fetishopinion.back():
			person.fetish.lactation = globals.fetishopinion[globals.fetishopinion.find(person.fetish.lactation)+1]
			text += "$name seems to be more comfortable with lactating now. $He now feels that it is " + str(person.fetish.lactation) + " to be lactating."

	#Permanent Swelling
	if person.titssize == "masculine":
		#Always Swells Masculine into Flat so Regen/milkstorage is at least 1
		person.titssize = "flat"
		text += "$name's masculine chest swelled up and sprouted into two tiny little bumps. $His " +nameTits()+" are now flat."

	#Generate Milk: Normal Tits
	if person.lactating.hyperlactation == true:
		regen = (globals.titssizearray.find(person.titssize) * 2) + clamp(round(rand_range(person.lactating.duration * .2,person.lactating.duration * .4)), 1, 20)
	else:
		regen = globals.titssizearray.find(person.titssize) * 2
	milkstorage = globals.titssizearray.find(person.titssize) * 2
	#Generate Milk: Extra Tits
	if person.titsextradeveloped == true:
		regen += round(person.titsextra*.25)
		milkstorage += round(person.titsextra*.25)
	#Racial Modifiers
	if person.race.find('Taurus'):
		regen = round(regen*1.2)
		milkstorage = round(milkstorage*1.2)

	#Traits
	for i in person.traits:
	#Set Lactation Regen/Flow Traitline
		var trait = globals.origins.trait(i)
		if trait.tags.has('lactation-trait') && trait.tags.has('regentrait'):
			traitrank = regentrait.find(i)
			if traitrank == 0:
				traitmod = round(regen*.5)
				text += "[color=red]Milk regeneration hampered by Trait: " + str(i) + ".[/color]\n"
			elif traitrank > 0:
				traitrank = 1+(traitrank*.2)
				traitrank = clamp(traitrank, 1.2, 2)
				traitmod = round(regen*traitrank)
				text += "[color=green]Milk regeneration increased by Trait: " + str(i) + ".[/color]\n"
		if traitmod > 0:
			regen = traitmod
		traitmod = 0
		if trait.tags.has('lactation-trait') && trait.tags.has('storagetrait'):
			traitrank = storagetrait.find(i)
			if traitrank == 0:
				traitmod = round(milkstorage*.5)
				text += "[color=red]Milk gland capacity lessened by Trait: " + str(i) + ".[/color]\n"
			elif traitrank > 0:
				traitrank = 1 + (traitrank*.2)
				traitrank = clamp(traitrank, 1.2, 2)
				traitmod = round(milkstorage*traitrank)
				text += "[color=green]Milk gland capacity increased by Trait: " + str(i) + ".[/color]\n"
		if traitmod > 0:
			milkstorage = traitmod
		traitmod = 0

	#Apply to Person
	person.lactating.regen = regen
	person.lactating.milkstorage += regen
	person.lactating.milkmax = milkstorage
	text += "$name's "+str(getChest(person))+ " produced [color=aqua]"+str(regen)+" milk[/color] today. "

	#Pressure Stress and Swelling
	if lact.milkedtoday == false && lact.milkstorage >= 1:
		lact.daysunmilked += 1
		if lact.daysunmilked >= 1:
			text += "$name feels growing pressure in $his breasts as $he goes [color=red]unmilked[/color] for [color=aqua]"+ str(lact.daysunmilked) +" Days[/color]. "
		#Turn Default .25 of Storage into Pressure
		var transfer = round(lact.milkstorage * globals.expansionsettings.lacation_pressurepermilkstored)
		lact.pressure += transfer
		lact.milkstorage -= transfer
	
	#Hyperlactation
	if person.lactating.hyperlactation == true:
		pressure = person.lactating.milkstorage - person.lactating.milkmax
		pressure = clamp(pressure, -10, 10)
		if pressure > 0:
			#Chance at Swelling
			if globals.titssizearray.find(person.titssize)*3 < pressure && rand_range(0,100) <= chancelactationincreasetits + pressure:
				if globals.titssizearray.back() != person.titssize:
					text += "$name's "+ str(person.titssize) +" "+nameTits()+ " were so filled and full of pressure that $his body could only handle it by "+nameStretching()
					person.titssize = globals.titssizearray[globals.titssizearray.find(person.titssize)+1]
					var hpdamage = round(rand_range(pressure,pressure*2.5))
					text += " to "+ str(person.titssize) +".\nThis caused damage to $his health. [color=red]" +str(hpdamage)+ " Health Lost[color]"
					#Inflict Damage. They won't die from it though.
					if person.health - hpdamage <= 0:
						person.health = 1
						if person.energy - hpdamage >= 0:
							person.energy -= hpdamage
						else:
							person.energy = 0
						text += "Due to $his extremely poor health condition, $his energy has been drastically reduced as well by the incident.\n[color=red]" +str(hpdamage)+ "Energy Lost[color]\n"
					else:
						text += "\n"
						person.health -= hpdamage
			#Apply Pressure Stress
			if globals.fetishopinion.find(person.fetish.lactation) >= 3 || person.traits.has('Masochist'):
				person.lust += pressure
				text += "$name's " +nameTits()+ " are so "+nameStretched()+"that $he would normally feel incredibly stressed by it. Instead, $he is simply [color=green]turned on[/color] by the pain of $his swollen " +nameTits()+ ".\n$He gained [color=red]"+str(pressure)+ " Lust[/color]\n"
			elif globals.expansionsettings.lactationstressenabled == true:
				person.stress += pressure
				text += "$name's " +nameTits()+ " are so "+nameStretched()+" that $he constantly feels the pain from $his achy " +nameTits()+ ".\n$He gained [color=red]"+str(pressure)+ " Stress[/color]\n"
			person.lactating.pressure = pressure
	elif person.lactating.milkstorage > person.lactating.milkmax:
		person.lactating.milkstorage = person.lactating.milkmax

	#Keep the Secret (if Possible)
	if !person.knowledge.has('lactating') && !person.mind.secrets.has('lactating'):
		getSecret(person,'lactation')
		person.mind.secretslog = person.selfdictionary(text)
		text = ""

	#Headgirl Notice %

	return person.dictionary(text)

#Old System
func dailyMilking(person, extraction='', autopump = false):
	var text = ""
	var lact = person.lactating
	var regen = lact.regen
	var transfer = 0
	var cowquality = 0
	var extractionquality = 0
	var result
	var auto = autopump
	if extraction == 'none':
		lact.daysunmilked += 1
		if lact.daysunmilked >= 1:
			text += "$name feels growing pressure in $his breasts as $he goes [color=red]unmilked[/color] for [color=aqua]"+ str(lact.daysunmilked) +" Days[/color]. "
		#Turn .1 of Storage into Pressure
		transfer = round(lact.milkstorage * milkregenperday)
		lact.pressure += transfer
		lact.milkstorage -= transfer
		result = 0
	else:
		lact.milkedtoday = true
		lact.daysunmilked = 0
		
		#Gain Being Milked Fetish
		if rand_range(0,100) <= ((person.lactating.milkstorage*.25)+person.lactating.pressure) * globals.expansionsettings.beingmilkedacceptancemultiplier:
			if person.fetish.bemilked != globals.fetishopinion.back():
				person.fetish.bemilked = globals.fetishopinion[globals.fetishopinion.find(person.fetish.bemilked)+1]
				text += "$name seems to be more comfortable with lactating now. $He now feels that it is " + str(person.fetish.bemilked) + " to be lactating. "
		
		#Stress/Lust based on the Being Milked Fetish
		
		#Cow Quality
		if person.preg.duration > 0:
			cowquality = round(lact.milkstorage*1.5)
		else:
			cowquality = lact.milkstorage
		#Extraction Quality
		var farmmanager
		var efficiency
		for i in globals.slaves:
			if i.work == 'farmmanager':
				farmmanager = i
		if person.work == 'cow':
			if auto == false:
				#Determine Efficiency
				if farmmanager != null:
					if !farmmanager.jobskills.has("farmmanager"):
						farmmanager.jobskills['farmmanager'] = 1
					#Add Farm Manager Endurance Tracker
					efficiency = 1 + (farmmanager.jobskills.farmmanager*.01) + (farmmanager.conf*.01)+(farmmanager.wit*.01)
#					text += "\n" + farmmanager.dictionary("$name") + " managed to coax slightly better production out of " + person.dictionary("$name's " + str(getChest(person)) + ", recovering [color=green]" + str(regen) + " milk back into $his " + nameTits() + ".")
				else:
					efficiency = 0
#					text += "\n[color=red]There was no manager of the farm today, so $name merely sat there with $his "+getChest(person)+" "+nameSwelling()+".[/color]"
			else:
				#Determine Efficiency
				efficiency = farmmanager.wit + farmmanager.jobskills.farmmanager
				if rand_range(0,100) > efficiency:
					efficiency = ((farmmanager.wit + farmmanager.jobskills.farmmanager)*.01)
				else:
					efficiency = 1+((farmmanager.wit + farmmanager.jobskills.farmmanager)*.01)
			if extraction == 'hand':
				extractionquality = .5+efficiency
			elif extraction == 'basic':
				extractionquality = .75+efficiency
			elif extraction == 'masterwork':
				extractionquality = 1+efficiency
			elif extraction == 'magical':
				extractionquality = 2+efficiency

			result = (cowquality*extractionquality)
			var drained = lact.milkstorage - result
			lact.milkstorage = clamp(drained, 0 ,lact.milkmax)

	#Possibly add Farm Text to a separate location instead of returning it, so I can return a number?
	return result

func getMilkLeak(person,value=50):
	#Sends a Chance to cause Leaking (Working, Activities, Talking, etc)
	var leak = 0
	if rand_range(0,100) - person.lactating.pressure <= value:
		leak = round(rand_range(1,person.lactating.pressure))
		person.lactating.pressure -= leak
		person.lactating.milkstorage -= leak
		person.lactating.leaking = leak
	return leak

func sexWorkBonus(person):
	#Bonus Gold for Previous Experience, Sizes, and Lust
	var bonus = 0
	
	#Skill Bonus
	person.add_jobskill('sexworker', 1)
	if person.jobskills['sexworker'] > 1:
		bonus += round(person.jobskills['sexworker']*.2)
	
	#Lust Bonus
	if rand_range(0,100) <= person.lust:
		bonus += round(person.lust*.1)
	
	#Sexual Traits Bonus
	for trait in person.traits:
		if trait in ['Sex-crazed','Deviant','Slutty','Fickle','Pervert','Likes it rough','Enjoys Anal','Soaker']:
			bonus += round(rand_range(1,3))
	
	#Lip Size Bonus
	bonus += globals.lipssizearray.find(person.lips)-3
	#Tits Bonus
	if person.titssize != 'masculine':
		bonus += globals.titssizearray.find(person.titssize)-3
	#Oriface Bonus (Tighter Gives Higher Bonus)
	if person.vagina != "none":
		bonus += globals.vagsizearray.size() - globals.vagsizearray.find(person.vagina)
	if person.asshole != "none":
		bonus += globals.assholesizearray.size() - globals.assholesizearray.find(person.asshole)
	
	#Energy - Stress Modifier
	if person.energy - person.stress > 0:
		bonus = round(bonus * rand_range(1.1,3))
	
	return bonus

#---End Job Checks---#

#This occurs prior to most "Mansion" End of Day phases. Phase 2 is During, Phase 3 is After
#UNUSED
func eodPhase1():
	var text = ""
	#Modify Milk Mod Values
	globals.state.milkeconomy.currentvalue = globals.state.milkeconomy.futurevalue
	globals.state.milkeconomy.futurevalue = globals.state.milkeconomy.currentvalue + rand_range(-.5,.5)
	for person in globals.slaves:
		dailyUpdate(person)
		if person.away.duration == 0:
			#Expand them (Should only occur once per person and only on existing saves)
			if person.expanded == false:
				globals.expansionsetup.expandPerson(person)
			#Reset Dailies
			#Update their Traitlines (if needed)
			checkTraitline(person)

	return text

func getFarmFactors(person,factor):
	var result = person.farmexpanded[factor]
	if typeof(result) == TYPE_STRING && result == "default":
		result = globals.resources.farmexpanded[factor]
	return result

func altereddiet_bottlesavailable(person):
	var isfoodavailable = false
	if person.traits.has("Milk Drinker"):
		if globals.resources.milk > 0:
			isfoodavailable = true
	if person.traits.has("Cum Drinker"):
		if globals.resources.cum > 0:
			isfoodavailable = true
	if person.traits.has("Piss Drinker"):
		if globals.resources.piss > 0:
			isfoodavailable = true
	return isfoodavailable

func altereddiet_consumebottle(person):
	var text = ""
	if person.traits.has("Milk Drinker"):
		globals.resources.milk -= 1
		text = "$name drank a bottle of milk for $his dinner."

	if person.traits.has("Cum Drinker"):
		globals.resources.cum -= 1
		text = "$name drank a bottle of cum for $his dinner."
	if person.traits.has("Piss Drinker"):
		globals.resources.piss -= 1
		text = "$name drank a bottle of piss for $his dinner."
	return text

enum {IMAGE_DEFAULT, IMAGE_NAKED}
enum {LOW_STRESS, MID_STRESS, HIGH_STRESS, IMAGE_PREG}
var typeEnumToString = ['default','naked']

var dictUniqueImagePaths = {
	'Ayda': {
		IMAGE_DEFAULT: {
			HIGH_STRESS: 'res://files/images/ayda/aydanormal.png',
		},
		IMAGE_NAKED: {
			HIGH_STRESS: 'res://files/images/ayda/aydanaked.png',
		},
	},
	'Ayneris': {
		IMAGE_DEFAULT: {
			LOW_STRESS: 'res://files/images/ayneris/aynerisneutral.png',
			MID_STRESS: 'res://files/images/ayneris/aynerisangry.png',
			HIGH_STRESS: 'res://files/images/ayneris/aynerispissed.png',
			IMAGE_PREG: 'res://files/aric_expansion_images/characters/preg_uniques/aynerisneutralnaked_preggo.png',
		},
		IMAGE_NAKED: {
			LOW_STRESS: 'res://files/images/ayneris/aynerisneutralnaked.png',
			MID_STRESS: 'res://files/images/ayneris/aynerisangrynaked.png',
			HIGH_STRESS: 'res://files/images/ayneris/aynerispissednaked.png',
			IMAGE_PREG: 'res://files/aric_expansion_images/characters/preg_uniques/aynerisneutralnaked_preggo.png',
		},
	},
	'Cali': {
		IMAGE_DEFAULT: {
			LOW_STRESS: 'res://files/images/cali/calihappy.png',
			MID_STRESS: 'res://files/images/cali/calineutral.png',
			HIGH_STRESS: 'res://files/images/cali/calisad.png',
		},
		IMAGE_NAKED: {
			LOW_STRESS: 'res://files/images/cali/calinakedhappy.png',
			MID_STRESS: 'res://files/images/cali/calinakedneutral.png',
			HIGH_STRESS: 'res://files/images/cali/calinakedangry.png',
		},
	},
	'Chloe': {
		IMAGE_DEFAULT: {
			LOW_STRESS: 'res://files/images/chloe/chloehappy.png',
			MID_STRESS: 'res://files/images/chloe/chloeneutral.png',
			HIGH_STRESS: 'res://files/images/chloe/chloeshy2.png',
			IMAGE_PREG: 'res://files/aric_expansion_images/characters/preg_uniques/chloenaked_preggo.png',
		},
		IMAGE_NAKED: {
			LOW_STRESS: 'res://files/images/chloe/chloenakedhappy.png',
			MID_STRESS: 'res://files/images/chloe/chloenakedneutral.png',
			HIGH_STRESS: 'res://files/images/chloe/chloenakedshy.png',
			IMAGE_PREG: 'res://files/aric_expansion_images/characters/preg_uniques/chloenaked_preggo.png',
		},
	},
	'Emily': {
		IMAGE_DEFAULT: {
			LOW_STRESS: 'res://files/images/emily/emily2happy.png',
			MID_STRESS: 'res://files/images/emily/emily2neutral.png',
			HIGH_STRESS: 'res://files/images/emily/emily2worried.png',
			IMAGE_PREG: 'res://files/aric_expansion_images/characters/preg_uniques/emilyf_preg.png',
		},
		IMAGE_NAKED: {
			LOW_STRESS: 'res://files/images/emily/emilynakedhappy.png',
			HIGH_STRESS: 'res://files/images/emily/emilynakedneutral.png',
			IMAGE_PREG: 'res://files/aric_expansion_images/characters/preg_uniques/emilyf_preg.png',
		},
	},
	'Ivrana': {
		IMAGE_DEFAULT: {
			HIGH_STRESS: 'res://files/aric_expansion_images/characters/ivranaclothed.png',
			IMAGE_PREG: 'res://files/aric_expansion_images/characters/ivranapregnant.png',
		},
		IMAGE_NAKED: {
			HIGH_STRESS: 'res://files/aric_expansion_images/characters/ivrananaked.png',
			IMAGE_PREG: 'res://files/aric_expansion_images/characters/ivranapregnant.png',
		},
	},
	'Maple': {
		IMAGE_DEFAULT: {
			HIGH_STRESS: 'res://files/images/maple/maple.png',
		},
		IMAGE_NAKED: {
			HIGH_STRESS: 'res://files/images/maple/maplenaked.png',
		},
	},
	'Melissa': {
		IMAGE_DEFAULT: {
			LOW_STRESS: 'res://files/images/melissa/melissafriendly.png',
			MID_STRESS: 'res://files/images/melissa/melissaneutral.png',
			HIGH_STRESS: 'res://files/images/melissa/melissaworried.png',
		},
		IMAGE_NAKED: {
			LOW_STRESS: 'res://files/images/melissa/melissanakedfriendly.png',
			HIGH_STRESS: 'res://files/images/melissa/melissanakedneutral.png',
		},
	},
	'Tia': {
		IMAGE_DEFAULT: {
			MID_STRESS: 'res://files/aric_expansion_images/characters/New Tia/tianeutral.png',
			HIGH_STRESS: 'res://files/aric_expansion_images/characters/New Tia/tiasad.png',
			IMAGE_PREG: 'res://files/aric_expansion_images/characters/New Tia/tiapregnant.png',
		},
		IMAGE_NAKED: {
			MID_STRESS: 'res://files/aric_expansion_images/characters/New Tia/tianudeneutral.png',
			HIGH_STRESS: 'res://files/aric_expansion_images/characters/New Tia/tianudesad.png',
			IMAGE_PREG: 'res://files/aric_expansion_images/characters/New Tia/tiapregnant.png',
		},
	},
	'Tisha': {
		IMAGE_DEFAULT: {
			LOW_STRESS: 'res://files/images/tisha/tishahappy.png',
			MID_STRESS: 'res://files/images/tisha/tishaneutral.png',
			HIGH_STRESS: 'res://files/images/tisha/tishaangry.png',
			IMAGE_PREG: 'res://files/aric_expansion_images/characters/preg_uniques/tisha_preggo.png',
		},
		IMAGE_NAKED: {
			LOW_STRESS: 'res://files/images/tisha/tishanakedhappy.png',
			HIGH_STRESS: 'res://files/images/tisha/tishanakedneutral.png',
			IMAGE_PREG: 'res://files/aric_expansion_images/characters/preg_uniques/tisha_preggo.png',
		},
	},
	'Yris': {
		IMAGE_DEFAULT: {
			HIGH_STRESS: 'res://files/images/yris/yrisnormaldressed.png',
		},
		IMAGE_NAKED: {
			HIGH_STRESS: 'res://files/images/yris/yrisnormalnaked.png',
		},
	},
	'Zoe': {
		IMAGE_DEFAULT: {
			LOW_STRESS: 'res://files/images/zoe/zoehappy.png',
			MID_STRESS: 'res://files/images/zoe/zoeneutral.png',
			HIGH_STRESS: 'res://files/images/zoe/zoesad.png',
		},
		IMAGE_NAKED: {
			LOW_STRESS: 'res://files/images/zoe/zoehappynaked.png',
			MID_STRESS: 'res://files/images/zoe/zoeneutralnaked.png',
			HIGH_STRESS: 'res://files/images/zoe/zoesadnaked.png',
		},
	},
}

var typeToPath = {
	'default' : 'bodies',
	'preg' : 'bodiespreg',
	'naked' : 'bodiesnaked',
}

###---Change Slave Images---###
func updateBodyImage(person):
	###---Added by Expansion---### Added by Deviate, updated by Ank
	if dictUniqueImagePaths.has(person.unique) && person.imageportait == globals.characters.characters[person.unique].get('imageportait',''):
		var imagetype
		if int(person.exposed.chest) + int(person.exposed.genitals) + int(person.exposed.ass) >= 2:
			imagetype = IMAGE_NAKED
		else:
			imagetype = IMAGE_DEFAULT
		var stress
		if person.stress < 20:
			stress = LOW_STRESS
		elif person.stress < 60:
			stress = MID_STRESS
		else:
			stress = HIGH_STRESS
		if person.preg.duration > 0 && person.knowledge.append('currentpregnancy') || person.swollen > 0 && person.swollen >= globals.heightarrayexp.find(person.height)/2:
			if dictUniqueImagePaths[person.unique][imagetype].has(IMAGE_PREG):
				stress = IMAGE_PREG
		person.imagetype = typeEnumToString[imagetype]
		var ref = dictUniqueImagePaths[person.unique][imagetype]
		person.imagefull = ref[stress] if ref.has(stress) else ref[HIGH_STRESS] 
	###---End Expansion---###
	elif person.imagefull != null:
		var attempt = []
		if person.preg.duration > 0  && person.knowledge.append('currentpregnancy') || person.swollen > 0 && person.swollen >= globals.heightarrayexp.find(person.height)/2:
			attempt.append('preg')
		if int(person.exposed.chest) + int(person.exposed.genitals) + int(person.exposed.ass) >= 2:
			attempt.append('naked')
		attempt.append('default')
		for a in attempt:
			var path = person.imagefull.replace( typeToPath[person.imagetype], typeToPath[a] )
			if globals.canloadimage(path):
				person.imagefull = path
				person.imagetype = a
				break
	else:
		if person.imageportait != null && person.imagetype == 'default':
			var path = person.imageportait.replace('portraits',"bodies")
			if globals.canloadimage(path):
				person.imagefull = path
				person.imagetype = 'default'

var listCompat = ['','low','medium','high']
var listSex = ['male', 'female', 'futanari']

func updateSexualityImage(person):
	if person == null:
		return
	
	var refSexImg = person.sexuality_images
	if person.knowledge.has('sexuality'):
		refSexImg.base = 'base_' + person.sex.trim_suffix('nari').replace('dickgirl','futa')
		for sex in listSex:
			var idx = listCompat.find(testSexualCompatibility(person, sex))
			refSexImg[sex] = null if idx < 1 else (sex.trim_suffix('nari') + "_" + str(idx))
	else:
		refSexImg.male = null
		refSexImg.female = null
		refSexImg.futa = null
		refSexImg.base = 'unknown'


func checkIncest(person):
	var related = relatedCheck(person,globals.player)
	var modifier = 0
	if related != "none":
		person.dailyevents.append('incest')
		if person.consentexp.incest != true:
			modifier = round((globals.fetishopinion.find(person.fetish.incest)-4) + (person.dailyevents.count('incest')*.25))
			if modifier == 0:
				modifier += rand_range(-1,1)
	return modifier

func quickStrip(person):
	person.exposed.chest = true
	person.exposed.genitals = true
	person.exposed.ass = true

func isSameSex(sex1, sex2):
	if sex1 == sex2:
		return true
	var futaconsideration = globals.expansionsettings.futasexualitymatch
	if sex1 == 'futanari' || sex1 == 'dickgirl':
		if futaconsideration == 'both':
			return true
		sex1 = futaconsideration
	if sex2 == 'futanari' || sex2 == 'dickgirl':
		if futaconsideration == 'both':
			return true
		return sex1 == futaconsideration
	return false

func getSexualAttraction(person, target):
	var compatibility = testSexualCompatibility(person, target.sex)
	if compatibility == 'none':
		return false
	var base_attraction = (target.beauty-40) + (person.lewdness*.25) + (person.lust*.35) + person.sexexp.orgasmpartners.get(target.id,0)
	var attraction_modifier = target.level * (target.lust*.05)
	if person == globals.player:
		base_attraction += globals.expansionsettings.playerattractionmodifier
	elif target == globals.player:
		attraction_modifier += person.obed*.15 + person.metrics.ownership*.25 + globals.expansionsettings.playerattractionmodifier
	#Check Attraction for Success/Failure
	base_attraction += attraction_modifier
	if compatibility == 'low':
		return base_attraction >= 75
	elif compatibility == 'medium':
		return base_attraction >= 40
	elif compatibility == 'high':
		return base_attraction >= 10
	return false

func testSexualCompatibility(person, targetSex):
	if person == null:
		return 'none'
	if person == globals.player:
		return 'high'
	#Set Compatibility Rating
	var idxKS = globals.kinseyscale.find(person.sexuality)
	if isSameSex(person.sex, targetSex):
		if idxKS >= 5:
			return 'high'
		elif idxKS >= 3:
			return 'medium'
		elif idxKS > 0:
			return 'low'
	else:
		if idxKS <= 1:
			return 'high'
		elif idxKS <= 3:
			return 'medium'
		elif idxKS < 5:
			return 'low'
	return 'none'

func insertCum(taker,giver,location):
	#Just to Test

	taker.person.cum[location] = taker.person.cum.get(location, 0) + round(rand_range(0,1) + giver.person.pregexp.cumprod)
	if location == 'pussy':
		taker.pregexp.latestvirility = giver.pregexp.virility
	updatePerson(taker)
	updatePerson(giver)

func getResponse(person,value):
	#Value accepts Respected, Degraded, and Lewd
	var moodmod = 0
	var response = ''
	#Track Treatment
	person.mind.treatment.append(value)
	#Update Mood (Their Expression)
	if value == 'respected':
		person.loyal += round(rand_range(1,5))
		moodmod = round(rand_range(1,2))
		response = 'positive'
	elif value == 'degraded':
		moodmod = -round(rand_range(1,2))
		if person.traits.has('Submissive') || person.traits.has('Masochist'):
			person.lust += round(rand_range(1,5))
			moodmod = round(rand_range(1,2))
			response = 'positive'
		else:
			person.fear += round(rand_range(1,5))
			person.stress += round(rand_range(3,7))
			moodmod = -round(rand_range(1,2))
			response = 'negative'
	elif value == 'lewd':
		if person.lust + person.lewdness >= 100 || person.mood == 'horny':
			person.lust += round(rand_range(1,5))
			moodmod = round(rand_range(1,2))
			response = 'positive'
		else:
			person.lust -= round(rand_range(1,5))
			moodmod = -round(rand_range(1,2))
			response = 'negative'
	updateMood(person,moodmod,'any')
	return response

###---Checks all Treatment Additions and Sorts for the Top Ranked---###
static func treatmentSort(a, b):
	return a[0] > b[0]

func getTreatment(person):
	#Returns Respect, Degradation, or Lewd
	var totalcount = []
	for i in ['respected','degraded','lewd']:
		if person.mind.treatment.has(i):
			totalcount.append([person.mind.treatment.count(i), i])
	if totalcount.empty():
		return 'respected'
	totalcount.sort_custom(self, "treatmentSort")
	return totalcount[0][1]

###---Expansion End---###

func setTraitsperFetish(person):
	#---D/S
	#Dominant
	if globals.fetishopinion.find(person.fetish.dominance) >= 5 && !person.traits.has('Dominant'):
		if person.knownfetishes.has('dominance'):
			person.add_trait('Dominant')
			person.trait_remove('Undiscovered Trait')
			if person.dailytalk.has('hint_dominance'):
				person.dailytalk.erase('hint_dominance')
		else:
			person.add_trait('Undiscovered Trait')
			if !person.dailytalk.has('hint_dominance'):
				person.dailytalk.append('hint_dominance')
	elif globals.fetishopinion.find(person.fetish.dominance) <= 4 && person.traits.has('Dominant'):
		person.trait_remove('Dominant')
	#Submissive
	if globals.fetishopinion.find(person.fetish.submission) >= 5 && !person.traits.has('Submissive'):
		if person.knownfetishes.has('submission'):
			person.add_trait('Submissive')
			person.trait_remove('Undiscovered Trait')
			if person.dailytalk.has('hint_submissive'):
				person.dailytalk.erase('hint_submissive')
		else:
			person.add_trait('Undiscovered Trait')
			if !person.dailytalk.has('hint_submissive'):
				person.dailytalk.append('hint_submissive')
	elif globals.fetishopinion.find(person.fetish.submission) <= 4 && person.traits.has('Submissive'):
		person.trait_remove('Submissive')
	#---S/M
	#Sadist
	if globals.fetishopinion.find(person.fetish.sadism) >= 5 && !person.traits.has('Sadist'):
		if person.knownfetishes.has('sadism'):
			person.add_trait('Sadist')
			person.trait_remove('Undiscovered Trait')
			if person.dailytalk.has('hint_sadism'):
				person.dailytalk.erase('hint_sadism')
		else:
			person.add_trait('Undiscovered Trait')
			if !person.dailytalk.has('hint_sadism'):
				person.dailytalk.append('hint_sadism')
	elif globals.fetishopinion.find(person.fetish.sadism) <= 4 && person.traits.has('Sadist'):
		person.trait_remove('Sadist')
	#Masochist
	if globals.fetishopinion.find(person.fetish.masochism) >= 5 && !person.traits.has('Masochist'):
		if person.knownfetishes.has('masochism'):
			person.add_trait('Masochist')
			person.trait_remove('Undiscovered Trait')
			if person.dailytalk.has('hint_masochism'):
				person.dailytalk.erase('hint_masochism')
		else:
			person.add_trait('Undiscovered Trait')
			if !person.dailytalk.has('hint_masochism'):
				person.dailytalk.append('hint_masochism')
	elif globals.fetishopinion.find(person.fetish.masochism) <= 4 && person.traits.has('Masochist'):
		person.trait_remove('Masochist')

#---Sort Best Slaves || Used for Envy Flaws
func getBestSlave():
	var bestslavelist = []
	for person in globals.slaves:
		var score = person.metrics.ownership + person.metrics.sex*3 + person.metrics.win*2 + person.level*7
		bestslavelist.append({person = person, score = score})
	bestslavelist.sort_custom(self, 'sortbestslave')
	return bestslavelist[0].person

###---Ripped from Events.gd to Sort Slavelist
func sortbestslave(first, second):
	if first.score > second.score:
		return true
	else:
		return false
