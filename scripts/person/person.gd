var scalecolor = ''
var feathercolor = ''


###---Added by Expansion---### Modified by Deviate
#var preg = {fertility = 0, has_womb = true, duration = 0, baby = null}
# preg.bonus_fertility variable is bonus from hybrid race modification
# preg.baby_type variable is either 'birth' or 'egg'
# preg.ovulation_type is 0 for none, 1 for standard (8 days ovulate, 15 days not) and 2 for extended (12 days ovulate, 15 days not)
# preg.ovulation_stage variable is either 0 for not able to ovulate, 1 for ovulating and 2 for not ovulating
# preg.baby_count variable is the number of babies pregnant with
# preg.womb variable is array of cum in womb
# preg.baby variable is not used, only populated with dummy value when pregnant to not break other mods which might look at it
var preg = {fertility = 0, bonus_fertility = 0, has_womb = true, is_preg = false, duration = 0, baby = null, baby_type = '',  ovulation_type = 0, ovulation_stage = 0, ovulation_day = 0, womb = [], offspring_count = 0, unborn_baby = [],}
var manafeedpolicy = 99999 #ralphC - mana resource value set for each npc below which mana eaters do not get fed (only relevant for mana eaters; ie. Succubus, Golem)
var mana_hunger = 0 #ralphC - only used for Succubus and future mana eating races/hybrids
###---End Expansion---###


###---Added by Expansion---### Modified by Deviate
#var metrics = {ownership = 0, jail = 0, mods = 0, brothel = 0, sex = 0, partners = [], randompartners = 0, item = 0, spell = 0, orgy = 0, threesome = 0, win = 0, capture = 0, goldearn = 0, foodearn = 0, manaearn = 0, birth = 0, preg = 0, vag = 0, anal = 0, oral = 0, roughsex = 0, roughsexlike = 0, orgasm = 0}
# metrics.animalpartners used to track times had sex with animal
var metrics = {ownership = 0, jail = 0, mods = 0, brothel = 0, sex = 0, partners = [], randompartners = 0, animalpartners = 0, item = 0, spell = 0, orgy = 0, threesome = 0, win = 0, capture = 0, goldearn = 0, foodearn = 0, manaearn = 0, birth = 0, preg = 0, vag = 0, anal = 0, oral = 0, roughsex = 0, roughsexlike = 0, orgasm = 0}
###---End Expansion---###

var stats = {
	str_max = 0,
	str_mod = 0,
	str_base = 0,
	agi_max = 0,
	agi_mod = 0,
	agi_base = 0,
	maf_max = 0,
	maf_mod = 0,
	maf_base = 0,
	end_base = 0,
	end_mod = 0,
	end_max = 0,
	cour_max = 100,
	cour_base = 0,
	cour_racial = 0,
	conf_max = 100,
	conf_base = 0,
	conf_racial = 0,
	wit_max = 100,
	wit_base = 0,
	wit_racial = 0,
	charm_max = 100,
	charm_base = 0,
	charm_racial = 0,
	obed_cur = 0.0,
	obed_max = 100,
	obed_min = 0,
	obed_mod = 1,
	stress_cur = 0.0,
	stress_max = 120,
	stress_min = 0,
	stress_mod = 1,
	tox_cur = 0.0,
	tox_max = 100,
	tox_min = 0,
	tox_mod = 1,
	lust_cur = 0,
	lust_max = 100,
	lust_min = 0,
	lust_mod = 0,
	health_cur = 0,
	health_max = 100,
	health_base = 0,
	health_bonus = 0,
	energy_cur = 75,
	energy_max = 100,
	energy_mod = 0,
	armor_cur = 0,
	armor_max = 0,
	armor_base = 0,
	loyal_cur = 0.0,
	loyal_mod = 1,
	loyal_max = 100,
	loyal_min = 0,
}

func add_trait(trait, remove = false):
	var traitEntry = globals.origins.trait(trait)
	if traitEntry == null:
		globals.printErrorCode("adding non-existant trait " + str(trait))
		return false
	for i in get_traits():
		if i.name == traitEntry.name || traitEntry.name in i.conflict:
			return false
	traits.append(traitEntry.name)
	if globals.get_tree().get_current_scene().has_node("infotext") && globals.slaves.has(self) && away.at != 'hidden':
		var text = self.dictionary("$name acquired new trait: " + traitEntry.name)
		globals.get_tree().get_current_scene().infotext(text, 'yellow')
	if !traitEntry.effect.empty():
		add_effect(traitEntry.effect)
	
	###---Added by Expansion---### Sort Traits Alphabetically
	traits.sort()
	###---End Expansion---###
	
	return true

func trait_remove(trait):
	trait = globals.origins.trait(trait)
	if traits.find(trait.name) < 0:
		return
	traits.erase(trait.name)
	if trait['effect'].empty() != true:
		add_effect(trait['effect'], true)
	
	if globals.get_tree().get_current_scene().has_node("infotext") && globals.slaves.find(self) >= 0 && away.at != 'hidden':
		var text = self.dictionary("$name lost trait: " + trait.name)
		globals.get_tree().get_current_scene().infotext(text,'yellow')


###---Added by Expansion---###
#Expanded: False for Never Touched, True for Touched | ExpandedVersion: Updates Already Expanded People
var expanded = false
var expansionversion = 0
var imagetype = 'default'

#Category: Better NPCs
var npcexpanded = {
	mansionbred = false,
	racialbonusesapplied = false,
	citizen = true,
	reputation = 0,
	location = '',
	dailyaction = '',
	lastevent = 'action',
	enslavedby = "",
	timesmet = 0,
	timesfought = 0,
	timesrescued = 0,
	timesescaped = 0,
	timesraped = 0,
	timesreleased = 0,
	possessions = {gold = 0, food = 0, noncombatants=[], items =[]},
	restrained = [],
	body = {
		penis = {traits = []},
		vagina = {traits = [], inside = [], pliability = 0, elasticity = 0},
		asshole = {traits = [], inside = [], pliability = 0, elasticity = 0},
		},
	contentment = 0,
	temptraits = [],
	onlyonce = [],
}

#var dietexpanded = {dailyneed = 0, nourishment = {food = 100, milk = 30, cum = 15, piss = 0, blood = 0}, hunger = 0}
#OLD BELOW Daily: Diet

var diet = {base = 10, type = "food", hunger = 0, dailyneed = 0, nourishment = {food = 100, milk = 30, cum = 15, piss = 0, blood = 0,},}

#Mind is the "AI" that can be altered for Dialogue
#Identity: The way they currently think/act | Id: Natural Instincts | Ego: Conscious/Intentional Identity
#Thoughts: Their current focuses (hungry, horny, work, sleepy etc)
var mind = {
	willpower = 100,
	accepted = [],
	identity = '',
	id = ['self'],
	ego = ['self'],
	thoughts = [],
	secrets = [],
	secretslog = "",
	status = "none",
	demeanor = "none",
	flaw = "none",					#TBK - Remove Next Save-Incompatible Version
	flawless = false,				#TBK - Remove Next Save-Incompatible Version
	vice = "none",
	vice_presented = false,
	vice_known = false,
	vice_removed = false,
	treatment = [],
	respect = 0,
	humiliation = 0,
	lewd = 0,
	approaches = {openness = 0, loyal = 0, obed = 0, fear = 0, lust = 0, pushed = []},
}

#Instinct is the base desired, based on Race. These are the current "Needs"
var instinct = {
	hunger = 0,
	reproduce = 0
}
#Mood is what determines their Expression and/or Response
var mood = "none"
var moodnum = 0

#Traitline Modifications
var existingtraitlines = []
var traitstorage = []

#--Sexual---#
#Tracks Fetishes and Sexual Opinions
var sexuality = 'bi'
var sexuality_images = {
	base = '',
	male = '',
	female = '',
	futa = '',
}
var knownfetishes = []

#Fetishes turn Stress into Lust for the relevant situation || ing means doing it to others
#Creampie considered is holding cum inside the Hole
var fetish = {
	incest = "none",
	lactation = "none",
	drinkmilk = "none",
	bemilked = "none",
	exhibitionism = "none",
	drinkcum = "none",
	wearcum = "none",
	wearcumface = "none",
	creampiemouth = "none",
	creampiepussy = "none",
	creampieass = "none",
	pregnancy = "none",
	oviposition = "none",
	drinkpiss = "none",
	wearpiss = "none",
	otherspissing = "none",
	bondage = "none",
	dominance = "none",
	submission = "none",
	sadism = "none",
	masochism = "none",
	transformation = "none",
}

#Tracks their Consent for Expanded Options
var consentexp = {
	party = false,
	nudity = false,
	pregnancy = false,
	stud = false,
	breeder = false,
	incest = false,
	incestbreeder = false,
	livestock = false,
}
#Asshole Size (May add Types later, would add Penis and Vagina types as well)
var lips = 'none'
var asshole = 'normal'

var lubrication = -1 setget lube_set, lube_get

#Pliability: % for Temp Change without Tearing, Elasticity: % for Permanent Change
var sexexpanded = {sexualitylocked = false, pressure = 0, pliability = 0, elasticity = 0}

#restraintsarray = ['none','cuffed','shackled','fully','fullyexposed','farmrestraints']
var restrained = 'none'

#Tracks the Swelling from Pregnancy and/or Cum Inflation
var swollen = 0
var movement = "unset"
var movementreasons = []

var knowledge = []

#Tracks Nudity: ___Forced implies torn clothing or rules forbidding reclothing at End of Day
var exposed = {
	chestforced = false,
	chest = false,
	genitalsforced = false,
	genitals = false, #Penis and Vagina, May separate if needed in the future
	assforced = false,
	ass = false,
}

#Tracks Cum Storage
var cum = {face = 0, mouth = 0, body = 0, pussy = 0, ass = 0}

#Sex and Pregnancy Additions
var pregexp = {
	virility = 1, #The Virility of the Penis, aka Virility Traitline
	cumprod = 0, #Amount of Semen Produced
	latestvirility = 1, #The Virility of the last person who came inside the pussy
	eggstr = 1, #The Fertility Multipier for the Cum in the Pussy, aka Egg Strength Traitline
	gestationspeed = 1,
	babysize = 0,
	titssizebonus = 0,
	desiredoffspring = 1,
	wantedpregnancy = false,
	incestbaby = false
}

#Tracks Milk Storage and Milking Factors
var lactating = {
	hyperlactation = false,
	milkedtoday = false,
	daysunmilked = 0,
	duration = 0,
	regen = 0,
	milkmax = 0,
	milkstorage = 0,
	pressure = 0,
	leaking = 0
}

#Not Implimented Yet
var jobsexpanded = {location='none',timeserved = 0, varint=0, varstring='none'}
var joblocation = 'none'
var jobskills = {
	headgirl = 0,
	farmmanager = 0,
	cook = 0,
	maid = 0,
	nurse = 0,
	hunter = 0,
	forager = 0,
	lumberjack = 0,
	merchant = 0,
	mage = 0,
	entertainer = 0,
	combat = 0,
	sexworker = 0,
	farmhand = 0,
	milking = 0,
	milkmaid = 0,
	milkmerchant = 0,
	bottler = 0,
	stud = 0,
	trainer = 0,
	trainee = 0,
	pet = 0,
}

func add_jobskill(job, value = 1):
	var text = ""
	if job == null || job == "" || value == 0:
		return
	
	#Add if Non-Existant
	if !self.jobskills.has(job):
		self.jobskills[job] = 0
		text = str(job).capitalize() + " added to " + str(self.name) + "'s Job Skills."
	
	if rand_range(0,100) <= self.wit && self.jobskills[job] + value*2 <= 100:
		self.jobskills[job] += value*2
		text += self.dictionary("$name increased $his " + str(job).capitalize() + " Skill by " + str(value*2) + ". ")
	elif self.jobskills[job] + value < 100:
		self.jobskills[job] += value
		text += self.dictionary("$name increased $his " + str(job).capitalize() + " Skill by " + str(value) + ". ")
	elif self.jobskills[job] + value >= 100 && self.npcexpanded.onlyonce.find(job + 'skillmaxed') < 0:
		self.jobskills[job] = 100
		self.npcexpanded.onlyonce.append(job + 'skillmaxed')
		text += self.dictionary("$name's " + str(job).capitalize() + " Skill is at Maximum. ")
	if globals.get_tree().get_current_scene().has_node("infotext") && globals.slaves.find(self) >= 0 && away.at != 'hidden':
		globals.get_tree().get_current_scene().infotext(text,'green')

#Category: Farm Expanded
var farmexpanded = {
	timesmilked = 0,
	resistance = -1,
	stallbedding = 'dirt',
	workstation = 'free',
	dailyaction = 'none',
	restrained = false,
	giveaphrodisiac = false,
	aphrodisiac = 0,
	usesedative = false,
	sedative = 0,
	extraction = 'default',
	container = 'default',
	#Breeder/Stud (Status: none, breeder, stud, both, snails)
	breeding = {status = 'none', partner = '-1', forced = false, snails = false, eggsbirthed = 0},
	zones = {sleep = "dirt", work = "free", sleepfurnishings = [], workfurnishings = []},
	extractmilk = {enabled = false, restrained = false, method = 'leak', container = 'cup', sessions = 0, totalextracted = 0, resistance = -1, opinion = [], fate = "undecided"},
	extractcum = {enabled = false, restrained = false, method = 'leak', container = 'cup', sessions = 0, totalextracted = 0, resistance = -1, opinion = [], fate = "undecided"},
	extractpiss = {enabled = false, restrained = false, method = 'leak', container = 'cup', sessions = 0, totalextracted = 0, resistance = -1, opinion = [], fate = "undecided"},
	production = 'default',
	autopump = false,
	objects = []
}

#Personality Traits
var dignity = 0

#Conversation
var randomname = true #True: The Slave Randomizes the name / False: The Slave's noun is manually set

#Daily Events: Exhaustion (Forced Rest), Consents, Fetishes
var dailyevents = [] #Tracks pending events like "Milk Leak", "Pissing", etc
var dailytalk = [] #Tracks Once Per Day Topics

var flawknown = false			#TBK - Remove on Next Save Incompatible Version

#Not Implimented Yet
var daylog = {} #Tracks Events from the Day Before | So far: brokerule_name or followedrule_name

#---Sex Expanded | Fetish Content
func checkFetish(fetish, alternatemod = 0, increase = true, addevent = true):
	#Checks and Updates Fetishes | alternatemod needs to be a Number between .1-3
	var success = false
	var clamper = 0
	var modifier = 0
	if fetish == 'none':
		return success
	
	self.dailyevents.append(fetish)
	#Success/Fail Check
	var opinionrank = globals.fetishopinion.find(self.fetish[fetish])
	if alternatemod == 0:
		clamper = clamp(opinionrank-2, 0.5, 3)
	else:
		clamper = alternatemod
	if rand_range(0,100) <= globals.expansionsettings.fetish_base_increase_chance + ((opinionrank*10) * clamper) || self.effects.has("entranced"):
		success = true
		if addevent == true:
			self.dailyevents.append(fetish)
		if self.effects.has("entranced"):
			self.add_effect(globals.effectdict.entranced, true)
	
	#Fetish Increase Check
	if increase == true:
		if self.dailyevents.count(fetish) > 0:
			modifier = self.dailyevents.count(fetish)*10
		if rand_range(0,100) <= ((globals.fetishopinion.find(self.fetish[fetish])-3)*10) + modifier:
			clamper = globals.fetishopinion.find(self.fetish[fetish])+1
			clamper = clamp(clamper,0,globals.fetishopinion.size()-1)
			self.fetish[fetish] = globals.fetishopinion[clamper]
		
	return success

func setFetish(fetish='none',mod=0):
	#Safely Modify and Clamp Fetishes
	var clamper = 0
	if fetish != 'none':
		self.dailyevents.append(fetish)
		#Success/Fail Check
		clamper = globals.fetishopinion.find(self.fetish[fetish])+mod
		clamper = clamp(clamper,0,globals.fetishopinion.size()-1)
		self.fetish[fetish] = globals.fetishopinion[clamper]
#---End Expansion---#


func levelup():
	levelupreqs.clear()
	level += 1
	skillpoints += variables.skillpointsperlevel
	realxp = 0
	if int(level) % 2 == 0:
		self.health += 10
	self.loyal += rand_range(5,10)
	if self != globals.player:
		globals.get_tree().get_current_scene().infotext(dictionary("$name has advanced to Level " + str(level)),'green')
	else:
		globals.get_tree().get_current_scene().infotext(dictionary("You have advanced to Level " + str(level)),'green')

func getessence():
	var essence
	###---Added by Expansion---### Races Expanded
	if findRace(['Demon', 'Arachna', 'Lamia','Gnoll']):
		essence = 'taintedessenceing'
	if findRace(['Fairy','Dark Elf','Dragonkin','Kobold']):
		essence = 'magicessenceing'
	if findRace(['Dryad','Lizardfolk']):
		essence = 'natureessenceing'
	if findRace(['Harpy', 'Centaur','Beastkin','Halfkin']):
		essence = 'bestialessenceing'
	if findRace(['Slime','Nereid', "Scylla"]):
		essence = 'fluidsubstanceing'
	###---Expansion End---###
	return essence

func cleartraits():
	spec = null
	while !traits.empty():
		trait_remove(traits.back())
	for i in ['str_base','agi_base', 'maf_base', 'end_base']:
		stats[i] = 0
	if globals.useRalphsTweaks && globals.expansionsettings.ralphs_tweaks_partial.clear_player_racial_bonus && self == globals.player:
		for i in ['str_mod','agi_mod','maf_mod','end_mod']:
			stats[i] = 0
	skillpoints = 2
	level = 1
	xp = 0

func health_set(value):
	###---Added by Expansion---### Crystal | Added Death Prevention
	var text = ""
	var color
	if race.find('Ogre') >= 0: # Capitulize
		stats.health_max = max(10, ((variables.ogrebasehealth + (stats.end_base+stats.end_mod)*variables.ogrehealthperend) + floor(level/2)*5) + stats.health_bonus)
	else:
		stats.health_max = max(10, ((variables.basehealth + (stats.end_base+stats.end_mod)*variables.healthperend) + floor(level/2)*5) + stats.health_bonus) # /Capitulize
	stats.health_cur = clamp(floor(value), 0, stats.health_max)
	if stats.health_cur <= 0:
		if globals.state.thecrystal.preventsdeath == true:
			text += "$name's death was prevented by the magic of the Crystal. "
			globals.state.thecrystal.lifeforce -= 1
			color = 'green'
			if text != '' && globals.get_tree().get_current_scene().has_node("infotext") && globals.slaves.has(self) && away.at != 'hidden':
				globals.get_tree().get_current_scene().infotext(self.dictionary(text),color)
			stats.health_cur = 1
		else:
			death()
	###---End Expansion---###


func loyal_set(value):
	var difference = stats.loyal_cur - value
	var string = ""
#warning-ignore:unused_variable
	var color
#warning-ignore:unused_variable
	var text = ""
	if difference > 0:
		###---Added by Expansion---### Racial Bonuses
		if genealogy.dog >= 100:
			difference = round(difference * 2)
		elif genealogy.dog >= 70:
			difference = round(difference * 1.75)
		elif genealogy.dog >= 30:
			difference = round(difference * 1.5)
		###---End Expansion---###
		difference = abs(difference)
		if abs(difference) < 5:
			string = "(-)"
		elif abs(difference) < 10:
			string = "(--)"
		else:
			string = "(---)"
		
		###---Added by Expansion---### Racial Bonuses
		if genealogy.dog >= 30:
			string += " / Wolf Race Increased"
		###---End Expansion---###
		
		stats.loyal_cur -= difference
		text = self.dictionary("$name's loyalty decreased " + string)
		color = 'red'
	elif difference < 0:
		###---Added by Expansion---### Racial Bonuses
		if genealogy.dog >= 100:
			difference = round(difference * 2)
		elif genealogy.dog >= 70:
			difference = round(difference * 1.75)
		elif genealogy.dog >= 30:
			difference = round(difference * 1.5)
		###---End Expansion---###
		
		difference = abs(difference)
		if abs(difference) < 5:
			string = "(+)"
		elif abs(difference) < 10:
			string = "(++)"
		else:
			string = "(+++)"
		
		###---Added by Expansion---### Racial Bonuses
		if genealogy.dog >= 30:
			string += " / Wolf Race Increased"
		###---End Expansion---###
		
		text = self.dictionary("$name's loyalty grown " + string)
		color = 'green'
		stats.loyal_cur += difference*stats.loyal_mod


	stats.loyal_cur = max(min(stats.loyal_cur, stats.loyal_max),stats.loyal_min)
#		if globals.get_tree().get_current_scene().has_node("infotext") && globals.slaves.find(self) >= 0 && away.at != 'hidden':
#			globals.get_tree().get_current_scene().infotext(text,color)


###---Added by Expansion---### Modified by Deviate - Allow current stat up to max stat
func cour_set(value):
	if stats.cour_max > 100:
		stats.cour_base = clamp(value - stats.cour_racial, 0, stats.cour_max)
	else:
		stats.cour_base = clamp(value - stats.cour_racial, 0, min(stats.cour_max, originvalue[origins]))

func conf_set(value):
	var bonus = max(0, stats.conf_max - originvalue['noble'])
	if stats.conf_max > 100:
		stats.conf_base = clamp(value - stats.conf_racial, 0, stats.conf_max)
	else:
		stats.conf_base = clamp(value - stats.conf_racial, 0, min(stats.conf_max, originvalue[origins] + bonus))

func wit_set(value):
	if stats.wit_max > 100:
		stats.wit_base = clamp(value - stats.wit_racial, 0, stats.wit_max)
	else:
		stats.wit_base = clamp(value - stats.wit_racial, 0, min(stats.wit_max, originvalue[origins]))

func charm_set(value):
	if stats.charm_max > 100:
		stats.charm_base = clamp(value - stats.charm_racial, 0, stats.charm_max)
	else:
		stats.charm_base = clamp(value - stats.charm_racial, 0, min(stats.charm_max, originvalue[origins]))
###---End Expansion---###


func cour_get():
	return floor(stats.cour_base + stats.cour_racial)

func conf_get():
	return floor(stats.conf_base + stats.conf_racial)

func wit_get():
	return floor(stats.wit_base + stats.wit_racial)

func charm_get():
	return floor(stats.charm_base + stats.charm_racial)


func name_long():
	var text = ''
	if nickname == '':
		text = name
	else:
		text = '"' + nickname + '" ' + name
	if surname != "":
		text += " " + str(surname)

	return text

func name_short():
	if globals.expansionsettings.use_nickname_plus_first_name == true:
		## CHANGED - 25/5/19 - changed name_short() and similar to include first name too, to better handle non-unique nicknames
		if nickname == '':
			return name
		else:
			return str("\""+nickname+"\" "+name).substr(0,20) ## return nickname
	else:
		if nickname == '':
			return name
		else:
			return nickname


###---Added by Expansion---### Racial Support
#Use: globals.findRace(person,['',''])
func findRace(races=[]):
	var result = false
	var myrace = self.race
	if myrace.find('Halfkin') >= 0:
		myrace.replace('Halfkin', 'Beastkin')
	for i in races:
		if myrace.find(i) >= 0:
			result = true
	return result
###---End Expansion---###

###---Added by Expansion---### Updated Code provided by Ankmairdor
#At the end of every sent "Dialogue" text to add "Convo Quirks", unlike Person.Dictionary which can be for descriptors
func quirk(text):
	var string = dictionary(text)
	#Add little "Quirks" based on Race, etc
	#replaceRand(string, 'target', 'new', 50, 1)
	#---Phrase Additions
	if traits.has('Foul Mouth'):
		string = replaceRand(string, '. ', '.'+globals.expansiontalk.quirkCursing(' '), 50, 2)
		string = replaceRand(string, '! ', '!'+globals.expansiontalk.quirkCursing(' '), 50, 1)
		string = replaceRand(string, ', ', ','+globals.expansiontalk.quirkCursing(' '), 50, 3)
		string = replaceRand(string, '? ', '?'+globals.expansiontalk.quirkCursing(' '), 50, 2)
	if traits.has('Ditzy'):
		string = replaceRand(string, '. ', '.'+globals.expansiontalk.quirkDitzy(' '), 50, 2)
		string = replaceRand(string, '! ', '!'+globals.expansiontalk.quirkDitzy(' '), 50, 2)
		string = replaceRand(string, ', ', ','+globals.expansiontalk.quirkDitzy(' '), 50, 1)
		string = replaceRand(string, '? ', '?'+globals.expansiontalk.quirkDitzy(' '), 50, 1)
	if race.find('Cat') > 0:
		string = replaceRand(string, ' ', globals.expansiontalk.quirkCat(self,' '), 50, 2)
	if race.find('Dog') > 0:
		string = replaceRand(string, ' ', globals.expansiontalk.quirkDog(self,' '), 50, 2)
	if mood == "crying":
		string = replaceRand(string, ' ', globals.expansiontalk.quirkCrying(self,' '), 50, 2)
	#---Letter Replacers
	if race.find('Lamia') > 0:
		string = replaceRand(string, 's', globals.randomitemfromarray(['s','ss','sss','ssss','sssss']), 50, 1)
	if race.find('Arachna') > 0:
		string = replaceRand(string, 's', globals.randomitemfromarray(['s','ss','sss','ssss','sssss']), 50, 2)
	if race.find('Taurus') > 0:
		string = replaceRand(string, 'mo', globals.randomitemfromarray(['mo','moo','mooo','moooo']), 50, 1)
	if traits.has('Lisp'):
		string = replaceRand(string, 's', 'th', 100, 0)
	if traits.has('Stutter') || mood == "scared" || mood == "crying":
		string = replaceRand(string, 'st', globals.randomitemfromarray(['st-st','s-st-st','s-st']), 50, 1)
		string = replaceRand(string, 'rr', globals.randomitemfromarray(['rr-r','rr-rr','rr-r-r']), 25, 1)
		string = replaceRand(string, 'g', globals.randomitemfromarray(['g-g','gg-g','gg-gg-g']), 50, 1)
		string = replaceRand(string, 'k', globals.randomitemfromarray(['k-k','kk-k','kk-kk-k']), 75, 1)
		string = replaceRand(string, 'ch', globals.randomitemfromarray(['ch-ch','c-ch','ch-c-ch']), 75, 1)
		string = replaceRand(string, 'b', globals.randomitemfromarray(['bb-b','b-b','bb-bb-b']), 25, 1)
	#---Casual Additions || rand_range(0,100) < obed
	if mind.identity == 'proper' || rand_range(0,1) > .5:
		string = string.replace('$Thanks','Thank you')
		string = string.replace('$thanks','thank you')
	else:
		string = string.replace('$Thanks','Thanks')
		string = string.replace('$thanks','thanks')
	#---Text Replacers
	#Cancel All Text for Mute && (obed+loyal)*.5 >= 50
	if rules.silence == true:
		string = globals.randomitemfromarray(['...','...','...','...um...can I talk?','...I am not supposed to talk...','*cough*','*clears throat*','*shrugs at you*','*gestures that $he is not allowed to speak*'])
	if traits.has('Mute'):
		string = '...'

	return string

###---Added by Expansion---### Provided by Ankmairdor
func replaceRand(string, targetStr, newStr, rate = 50, delay = 1):
	var pos = string.find(targetStr, 0)
	var tag = string.find( '[', 0)
	var delayCount = 0
	while pos != -1:
		if tag != -1 && tag < pos:
			tag = string.find( ']', tag)
			if pos < tag:
				pos = string.find(targetStr, tag)
				tag = string.find( '[', tag)
				continue
		if delayCount <= 0 && rand_range(0,100) < rate:
			string.erase(pos, targetStr.length())
			string = string.insert(pos, newStr)
			delayCount = delay
			pos = string.find(targetStr, pos + newStr.length())
		else:
			delayCount -= 1
			pos = string.find(targetStr, pos + 1)
	return string

# searches given string beginning at the given start position for each string in array, returns the array index and position found for the first encountered match after the start position
func findFirst(string, start, array):
	var bestI = 0
	var bestPos = string.find( array[0], start)
	for i in range(1, array.size()):
		var temp = string.find( array[i], start)
		if temp != -1 && temp < bestPos:
			bestI = i
			bestPos = temp
	return [bestI, bestPos]

# randomly replaces instances of targetArray with randomly selected entries from newArray, rate is a percentage, delay is the number of targetArray skipped after a replacement
func replaceRandArray(string, targetArray, newArray, rate = 50, delay = 1):
	var find = findFirst(string, 0, targetArray)
	var tag = string.find( '[', 0)
	var delayCount = 0
	while find[1] != -1:
		if tag != -1 && tag < find[1]:
			tag = string.find( ']', tag)
			if find[1] < tag:
				find = findFirst(string, tag, targetArray)
				tag = string.find( '[', tag)
				continue
		if delayCount <= 0 && rand_range(0,100) < rate:
			string.erase(find[1], targetArray[find[0]].length())
			var newStr = newArray[randi() % newArray.size()]
			string = string.insert(find[1], newStr)
			delayCount = delay
			find = findFirst(string, find[1] + newStr.length(), targetArray)
		else:
			delayCount -= 1
			find = findFirst(string, find[1] + 1, targetArray)
	return string
###---End Expansion---###

func selfdictionary(text):
	#Used for Thoughts or Self-Reference
	var string = text
	string = string.replace('$name', 'I')
	string = string.replace('$surname', surname)
	string = string.replace('$penis', globals.fastif(penis == 'none', 'strapon', 'my cock'))
	string = string.replace('$child', globals.fastif(sex == 'male', 'boy', 'girl'))
	string = string.replace('$sex', sex)
	string = string.replace('$He', 'I')
	string = string.replace('$he', 'I')
	string = string.replace('$His', 'My')
	string = string.replace('$his', 'my')
	string = string.replace('$him', 'me')
	string = string.replace('$son', globals.fastif(sex == 'male', 'son', 'daughter'))
	string = string.replace('$sibling', globals.fastif(sex == 'male', 'brother', 'sister'))
	string = string.replace('$parent', globals.fastif(sex == 'male', 'father', 'mother'))
	string = string.replace('$sir', globals.fastif(sex == 'male', 'Sir', "Ma'am"))
	string = string.replace('$race', globals.decapitalize(race).replace('_', ' '))
	string = string.replace('$playername', globals.player.name_short())
	string = string.replace('$master', masternoun)
	string = string.replace('[haircolor]', haircolor)
	string = string.replace('[eyecolor]', eyecolor)
	string = string.replace('[scalecolor]', scalecolor)
	string = string.replace('[feathercolor]', feathercolor)
	return string

###---Expansion End---###

func dictionary(text):
	var string = text
	###---Added by Expansion---### Colorize Names (Removed for now)
	string = string.replace('$name', name_short())
#	string = string.replace('$name', "[color=aqua]"+name_short()+"[/color]")
	###---End Expansion---###
	string = string.replace('$surname', surname)
	string = string.replace('$sex', sex)
	if sex == 'male':
		string = string.replace('$penis', 'strapon' if (penis == 'none') else 'his cock')
		string = string.replace('$child', 'boy')
		string = string.replace('$He', 'He')
		string = string.replace('$he', 'he')
		string = string.replace('$His', 'His')
		string = string.replace('$his', 'his')
		string = string.replace('$him', 'him')
		string = string.replace('$son', 'son')
		string = string.replace('$sibling', 'brother')
		string = string.replace('$parent', 'father')
		string = string.replace('$sir', 'Sir')
	else:
		string = string.replace('$penis', 'strapon' if (penis == 'none') else 'her cock')
		string = string.replace('$child', 'girl')
		string = string.replace('$He', 'She')
		string = string.replace('$he', 'she')
		string = string.replace('$His', 'Her')
		string = string.replace('$his', 'her')
		string = string.replace('$him', 'her')
		string = string.replace('$son', 'daughter')
		string = string.replace('$sibling', 'sister')
		string = string.replace('$parent', 'mother')
		string = string.replace('$sir', "Ma'am")
	string = string.replace('$race', race.to_lower())
	string = string.replace('$playername', globals.player.name_short())
	string = string.replace('$master', getMasterNoun())
	string = string.replace('[haircolor]', haircolor)
	string = string.replace('[eyecolor]', eyecolor)
	string = string.replace('[scalecolor]', scalecolor)
	string = string.replace('[feathercolor]', feathercolor)
	var idx = string.find('$stutter') # "$stutter$master" may produce "M-Master"
	while idx >= 0:
		string = string.left(idx) + string.substr(idx + 8, randi() % 2 + 1) + "-" + string.right(idx + 8)
		idx = string.find('$stutter')
	return string
	
func dictionaryplayer(text):
	var string = text
	string = string.replace('[Playername]', globals.player.name_short())
	string = string.replace('$name', name_short())
	string = string.replace('$sex', sex)
	string = string.replace('$He', 'You')
	string = string.replace('$he', 'you')
	string = string.replace('$His', 'Your')
	string = string.replace('$his', 'your')
	string = string.replace('$him', 'your')
	string = string.replace('$master', getMasterNoun())
	if sex == 'male':
		string = string.replace('$penis', globals.fastif(penis == 'none', 'strapon', 'his cock'))
		string = string.replace('$child', 'boy')
		string = string.replace('$child', 'son')
		string = string.replace('$sibling', 'brother')
		string = string.replace('$sir', 'Sir')
	else:
		string = string.replace('$penis', globals.fastif(penis == 'none', 'strapon', 'her cock'))
		string = string.replace('$child', 'girl')
		string = string.replace('$child', 'daughter')
		string = string.replace('$sibling', 'sister')
		string = string.replace('$sir', "Ma'am")
	string = string.replace('[haircolor]', haircolor)
	string = string.replace('[eyecolor]', eyecolor)
	string = string.replace('[scalecolor]', scalecolor)
	string = string.replace('[feathercolor]', feathercolor)
	string = string.replace('$race', race.to_lower())
	return string

###---Added by Expansion---### Added Actually_Run to allow checking without affecting
func countluxury(actually_run = true):
	var templuxury = luxury
	var goldspent = 0
	var foodspent = 0
	var nosupply = false
	var value = 0
	if sleep == 'personal':
		templuxury += 10+(5*globals.state.mansionupgrades.mansionluxury)
	elif sleep == 'your':
		templuxury += 5+(5*globals.state.mansionupgrades.mansionluxury)
	if rules.betterfood == true && globals.resources.food >= 5:
		if actually_run == true:
			globals.resources.food -= 5
		foodspent += 5
		templuxury += 5
	if rules.personalbath == true:
		if spec != 'housekeeper':
			value = 2
		else:
			value = 1
		if globals.itemdict.supply.amount >= value:
			templuxury += 5
			if actually_run == true:
				globals.itemdict.supply.amount -= value
		else:
			#nosupply == true
			nosupply = true
	if rules.pocketmoney == true:
		if spec != 'housekeeper':
			value = 10
		else:
			value = 5
		if globals.resources.gold >= value:
			templuxury += 10
			goldspent += value
			if actually_run == true:
				globals.resources.gold -= value
	if rules.cosmetics == true:
		if globals.itemdict.supply.amount > 1:
			templuxury += 5
			if actually_run == true:
				globals.itemdict.supply.amount -= 1
		else:
			nosupply = true
	
	###---Added by Expansion---### Vices
	var roll = round(rand_range(0,100))
	var vice_modifier = 0
	var vice_satisfied = false
	if globals.expansionsettings.vices_luxury_effects == true && (self.mind.vice_known == true || roll <= globals.expansionsettings.vices_undiscovered_trigger_chance):
		#Lust
		if self.checkVice('lust'):
			var vice_lust_mod = clamp(round(self.lewdness * .1), 1, 10)
			if self.work in ['fucktoy','fucktoywimborn','escortwimborn','whorewimborn','ffprostitution']:
				vice_satisfied = true
			if lastsexday == globals.resources.day:
				vice_lust_mod += 10
			elif self.rules.masturbation == false:
				vice_lust_mod -= 5
			vice_modifier = clamp(vice_lust_mod - ((globals.resources.day - self.lastsexday)*3), -20, 20)

		#Sloth
		elif self.checkVice('sloth'):
			if self.work in ['rest','housepet']:
				vice_satisfied = true
				vice_modifier += 5
			if rules.personalbath == true:
				vice_modifier += 5
			if self.energy == self.stats.energy_max:
				vice_modifier += 10
			elif self.energy <= self.stats.energy_max * .25:
				vice_modifier -= 5
			if self.stress <= self.stats.stress_max * .25:
				vice_modifier += 5
			elif self.stress > self.stats.stress_max * .75:
				vice_modifier -= 5
			if vice_satisfied == true:
				vice_modifier = clamp(vice_modifier, 0, 20)
		#Wrath
		elif self.checkVice('wrath') && self.consentexp.party:
			if self.metrics.win >= self.metrics.ownership || self.work in ['guardian','slavecatcher','trainer','trainee']:
				vice_satisfied = true
				vice_modifier += 5
			if vice_satisfied == true:
				vice_modifier += clamp(self.metrics.win - self.metrics.ownership, 0, 20)
			else:
				vice_modifier += clamp(self.metrics.win - self.metrics.ownership, -20, 20)
		#Pride
		if self.checkVice('pride'):
			if self.work in ['headgirl','farmmanager','jailer']:
				vice_satisfied = true
				vice_modifier += 10
			if self.rules.cosmetics == true && globals.itemdict.supply.amount >= 1:
				if actually_run == true:
					globals.itemdict.supply.amount -= 1
				vice_modifier += 5
			elif self.rules.cosmetics == false && vice_satisfied == false:
				vice_modifier -= 10
			if rules.personalbath == true:
				vice_modifier += 5
			elif rules.personalbath == false && vice_satisfied == false:
				vice_modifier -= 10
		#Gluttony
		elif self.checkVice('gluttony'):
			if self.work == 'cooking':
				vice_satisfied = true
				vice_modifier += 10
			if self.rules.betterfood == true && globals.resources.food >= 3:
				foodspent += 3
				if actually_run == true:
					globals.resources.food -= 3
				vice_modifier += 10
			elif vice_satisfied == false:
				vice_modifier -= 10
		#Greed
		elif self.checkVice('greed'):
			if self.work in ['storewimborn','milkmerchant']:
				vice_satisfied = true
				vice_modifier += 10
			if self.rules.pocketmoney == true && globals.resources.gold >= 5:
				if actually_run == true:
					globals.resources.gold -= 5
				goldspent += 5
				vice_modifier += 10
			elif self.rules.pocketmoney == false && vice_satisfied == false:
				vice_modifier -= 10
		#Envy
		elif self.checkVice('envy'):
			var envytarget = globals.expansion.getBestSlave()
			if envytarget == self:			
				vice_satisfied = true
				vice_modifier += 20
			else:
				if self.work in ['headgirl','farmmanager','jailer']:
					vice_satisfied = true
					vice_modifier += 5
				if envytarget.sleep in ['personal','your'] && !self.sleep in ['personal','your']:
					vice_modifier -= 5
				else:
					vice_modifier += 5
				if envytarget.lastsexday > self.lastsexday && self.consent == true:
					vice_modifier -= 5
				else:
					vice_modifier += 5
				if envytarget.stress < self.stress * .5:
					vice_modifier -= 5
				else:
					vice_modifier += 5
				if globals.originsarrayexp.find(envytarget.origins) > globals.originsarrayexp.find(self.origins):
					vice_modifier -= 10
				else:
					vice_modifier += 5
			if vice_satisfied == true:
				vice_modifier = clamp(vice_modifier, 0, 20)
		#Calculation
		if vice_modifier != 0:
			vice_modifier = clamp(vice_modifier, -20, 20)
			templuxury += vice_modifier
	var luxurydict = {luxury = templuxury, goldspent = goldspent, foodspent = foodspent, nosupply = nosupply, vice_modifier = vice_modifier}
	###---End Expansion---###
	return luxurydict

func calculateprice():
	var price = 0
	var bonus = 1
	price = beautybase*variables.priceperbasebeauty + beautytemp*variables.priceperbonusbeauty
	price += (level-1)*variables.priceperlevel
	price = (price*globals.state.racemarketsat[race.replace('Halfkin', 'Beastkin')] if globals.useRalphsTweaks else price*globals.races[race.replace('Halfkin', 'Beastkin')].pricemod)
	if vagvirgin == true:
		bonus += variables.pricebonusvirgin
	if sex == 'futanari':
		bonus += variables.pricebonusfuta
	###---Added by Expansion---### centerflag982 - added dickgirl bonus
	if sex == 'dickgirl':
		bonus += variables.pricebonusdickgirl
	###---End Expansion---###
	for i in get_traits():
		if i.tags.has('detrimental'):
			bonus += variables.pricebonusbadtrait

	###---Added by Expansion---### Ank BugFix v4a
	if self.toxicity >= 60:
		bonus += variables.pricebonustoxicity
	###---End Expansion---###

	if variables.gradepricemod.has(origins):
		bonus += variables.gradepricemod[origins]
	if variables.agepricemods.has(age):
		bonus += variables.agepricemods[age]

	###---Added by Expansion---### Ank BugFix v4a
	if traits.has('Uncivilized'):
		bonus += variables.priceuncivilized
	###---End Expansion---###

	###---Added by Expansion---### Breeder Support
	if npcexpanded.mansionbred == true && globals.state.spec == 'Breeder':
		price *= globals.expansionsettings.mansion_bred_and_breeder
	elif npcexpanded.mansionbred == true:
		price = round(price*1.25)
	###---End Expansion---###
	bonus = bonus/globals.expansionsettings.calculate_price_bonus_divide
	
	price = price*bonus

	price *= globals.expansionsettings.slavePriceMod

	price = max(price,variables.priceminimum)

	return round(price)

func sellprice(alternative = false):
	var price = calculateprice()*0.6

	if effects.has('captured') == true && alternative == false:
		price = price/2
	var influential = false
	for i in globals.slaves:
		if i.traits.has("Influential"):
			influential = true
	if influential:
		price *= 1.2
	price = max(round(price), variables.priceminimumsell)
	###---Added by Expansion---### Breeder Support
	if npcexpanded.mansionbred == true && globals.state.spec == 'Breeder':
		price *= globals.expansionsettings.mansion_bred_and_breeder
	elif npcexpanded.mansionbred == true:
		price = round(price*1.25)
	###---End Expansion---###
	if globals.state.spec == 'Slaver' && fromguild == false:
		price *= 2
	return price

func death():
	if globals.slaves.has(self):
		globals.main.infotext(self.dictionary("$name has deceased. "),'red')
		globals.items.unequipall(self)
		###---Added by Expansion---### Ank BugFix v4a
		abortion()
		###---End Expansion---###
		globals.slaves.erase(self)
		if globals.state.relativesdata.has(id):
			globals.state.relativesdata[id].state = 'dead'
	elif globals.state.babylist.has(self):
		globals.state.babylist.erase(self)
		globals.clearrelativesdata(self.id)
	globals.state.playergroup.erase(self.id)
	###---Added by Expansion---### Ank BugFix v4a
	for i in relations:
		var tempslave = globals.state.findslave(i)
		if tempslave != null:
			tempslave.relations.erase(id)
	###---End Expansion---###

###---Added by Expansion---### Category: Better NPCs
func baddiedeath():
	if globals.slaves.has(self):
		globals.main.infotext(self.dictionary("$name has deceased. "),'red')
		globals.items.unequipall(self)
		globals.slaves.erase(self)
	if globals.state.relativesdata.has(id):
		globals.state.relativesdata[id].state = 'dead'
	if globals.state.babylist.has(self):
		globals.state.babylist.erase(self)
		globals.clearrelativesdata(self.id)
	if globals.state.allnpcs.has(self):
		globals.state.allnpcs.erase(self)
	for npcs in globals.state.offscreennpcs:
		if npcs[0] == self.id:
			globals.state.offscreennpcs.erase(npcs)
	globals.state.playergroup.erase(self.id)

#---Pregnancy Expanded
func abortion():
	while !preg.unborn_baby.empty():
		globals.miscarriage(self)
###---End Expansion---###

###---Added by Expansion---### centerflag982 - allows dickgirls to be identified
func checksex():
	if penis != 'none':
		if vagina != 'none':
			sex = 'futanari'
		elif globals.rules.dickgirl && titssize != 'masculine' && titssize != 'flat':
			sex = 'dickgirl'
		else:
			sex = 'male'
	else:
		sex = 'female'
###---End Expansion---###

###---Added by Expansion---### SetGet

func lube_set(value):
	if vagina == "none":
		self.lube = -1
	else:
		self.lube = clamp(round(value), 0, 10)

func lube_get():
	var number = 0
	if vagina == "none":
		number = -1
		return number
	
	number = round(self.lust * .05)
	
	if traits.has('Soaker'):
		number = number * 2
	
	number = clamp (number, 1, 10)
	return number

###---Expansion End---###

###---Added by Expansion---### NPC Expanded: Contentment
func displayContentment():
	var text = ""
	if npcexpanded.contentment >= 5:
		text = "[color=lime]Happy[/color]"
	elif npcexpanded.contentment >= 0:
		text = "[color=green]Content[/color]"
	elif npcexpanded.contentment >= -5:
		text = "[color=red]Discontent[/color]"
	else:
		text = "[color=red]Miserable[/color]"
	return text

func checkContentmentLoss(type):
	#Types High / Med / Low
	var fail = false
	if type == 'high' && rand_range(0,100) <= self.conf + self.wit:
		fail = true
	elif type == 'med' && rand_range(0,100) <= (self.conf + self.wit)/2:
		fail = true
	elif type == 'low' && rand_range(0,100) <= (self.conf + self.wit)/4:
		fail = true
	#Fail Result
	if fail == true:
		npcexpanded.contentment -= 1
	return fail

###---End Expansion---###

###---Added by Expansion---### Farm Expanded: Breeder Jobs
func assignBreedingJob(type):
	var text = ""
	var success = true
	if type in ["breeder","both"]:
		if consentexp.breeder == false:
			text += dictionary("[color=red]$name hasn't given $his consent to be impregnated and refuses.[/color]\n")
			success = false
	if type in ["stud","both"]:
		if consentexp.stud == false:
			text += dictionary("[color=red]$name hasn't given $his consent to impregnate others and refuses.[/color]\n")
			success = false
	
	#Succeed if Consent
	if success == true || success == false && farmexpanded.breeding.forced == true:
		farmexpanded.breeding.status = type
	
	return text

func assignBreedingPartner(partnerid):
	var text = ""
	var success = true
	var partner = globals.state.findslave(partnerid)
	if partner == null || partnerid == '-1':
		text = "Invalid Partner"
		success = false
#	#Invalid Breeder Type Check
#	if farmexpanded.breeding.status in ["none","breeder"]:
#		text += dictionary("[color=red]$name isn't assigned as a Stud.[/color]\n")
#		success = false
#	elif farmexpanded.breeding.status in ["none","stud"]:
#		text += dictionary("[color=red]$name isn't assigned as a Breeder.[/color]\n")
#		success = false
#	#Incest Breeder Check
#	if str(globals.expansion.relatedCheck(self, partner)) != "unrelated" && (consentexp.incestbreeder == false || partner.consentexp.incestbreeder == false):
#		text += dictionary("[color=aqua]$name[/color] cannot be partnered with [color=aqua]" + str(partner.name) + "[/color] as they both haven't consented to breeding with family members.\n")
#		success = false
	#Success
	if success == true:
		unassignPartner()
		farmexpanded.breeding.partner = partnerid
		partner.unassignPartner()
		partner.farmexpanded.breeding.partner = self.id
		text = "[color=aqua]"+name_short()+"[/color] is now partnered to breed with [color=aqua]" + str(partner.name) + "[/color]. They will continue to breed together until they are given further orders.\n"	
	return text

func unassignPartner():
	#Unassigned the Old Partner and clears that slot
	if farmexpanded.breeding.partner != '-1':
		var partner = globals.state.findslave(farmexpanded.breeding.partner)
		if partner != null && partner.farmexpanded.breeding.partner == self.id:
			partner.farmexpanded.breeding.partner = '-1'
		farmexpanded.breeding.partner = '-1'
###---End Expansion---###

###---Added by Expansion---### Deviate New Code
# race_type variable is 0 for animal, 1 for humanoid, 2 for uncommon, 3 for beast and 4 for not breedable
var race_type = 0
var race_display = ''
var race_secondary = ''
var race_secondary_percent = 0

###---Added by Expansion---### Pregnancy Expanded | Added by Deviate
var genealogy = {
	human = 0,
	elf = 0,
	dark_elf = 0,
	tribal_elf = 0,
	orc = 0,
	ogre = 0,
	giant = 0,
	gnome = 0,
	goblin = 0,
	demon = 0,
	kobold = 0,
	dragonkin = 0,
	lizardfolk = 0,
	fairy = 0,
	seraph = 0,
	dryad = 0,
	lamia = 0,
	harpy = 0,
	avali = 0,
	arachna = 0,
	nereid = 0,
	scylla = 0,
	slime = 0,
	bunny = 0,
	dog = 0,
	cow = 0,
	hyena = 0,
	cat = 0,
	fox = 0,
	horse = 0,
	raccoon = 0,
	mouse = 0,
	squirrel = 0,
	otter = 0,
	bird = 0,
}

func get_birth_amount_name():
	match int(clamp(preg.unborn_baby.size(),0,10)):
		1:
			return 'one baby'
		2:
			return 'twins'
		3:
			return 'triplets'
		4:
			return 'quadruplets'
		5:
			return 'quintuplets '
		6:
			return 'sextuplets'
		7:
			return 'septuplets'
		8:
			return 'octuplets'
		9:
			return 'nonuplets'
		10:
			return 'litter'
		0:
			return ''

func get_race_display():
	var rvar = ''
	if race != race_display:
		if race_display in globals.dictionary.hybriddict:
			rvar = ' ([color=yellow]Subspecies: ' + race_display + '[/color])'
		else:
			rvar = ' (' + race_display + ')'
	
	return rvar

func get_genealogy():
	var description = ""
	
	var temprace = globals.constructor.genealogy_decoder(race)
	
	if genealogy[temprace] >= 100:
		description = "$He is obviously a pure specimen of a full-blooded " + race + ".\n\n"
	elif genealogy[temprace] >= 50:
		if race_display in globals.dictionary.hybriddict:
			description = globals.dictionary.hybriddict[race_display]
		else:
			description = "$He appears to be primarily a " + race + ", though $he has certain physical features that may suggest that $he is unlikely to be a from a purely " + race + " bloodline.\n\n"
	elif genealogy[temprace] >= 30:
		description = "$His features are such a mix that it is only on very close inspection that $his " + race + " heritage shines through.\n\n"
	else:
		description = "$He appears to be some distorted mix of " + race + ", though it is so muddled that it is unlikely that any " + race + " would consider $him one of their own.\n\n"
	
	if globals.jobs.jobdict.nurse != null || globals.state.perfectinfo == true || globals.player.id == id:
		description += "$His full genealogy is :\n"
		
		#Simplified by Ankmairdor
		for race in genealogy:
			if self.genealogy[race] > 0 && !race in ['cat','dog','horse']:
#			if genealogy[race] > 0:
				description += race.replace('_',' ').capitalize() + " : " + str(genealogy[race]) + "%\n"
			elif self.genealogy[race] > 0 && race in ['cat','dog','horse']:
				if race == 'cat':
					description += "Feline : " + str(genealogy.cat) + "%\n"
				if race == 'dog':
					description += "Canine : " + str(genealogy.dog) + "%\n"
				if race == 'horse':
					description += "Equine : " + str(genealogy.horse) + "%\n"
	
	return description

func get_wombsemen():
	var semen = 0
	
	for i in preg.womb:
		semen += i.semen
	
	return semen

#---Clothing
func updateClothing():
	var text = ""
	#Player Check
	if self == globals.player && globals.expansionsettings.player_treats_clothing_like_slave == false:
		return text
	
	#Determine Clothing Status
	var exposed_parts = []
	var amnude = false
	for part in ['chest','genitals','ass']:
		if self.exposed[part] == true:
			exposed_parts.append(part)
	if exposed_parts.size() > 1:
		amnude = true
	
	#Determine if they should Strip or Dress
	var captured = 0
	if amnude == true:
		var redress = false
		#Naked - Do They Need/Want to Dress? Can They?
		for i in self.effects.values():
			if i.code == 'captured':
				captured = i.duration/2
		if self.rules.nudity == false && !self.fetish.exhibitionism in ['enjoyable','mindblowing']:
			text += "\n[color=aqua]$name[/color] wanted to cover $his "+ globals.expansion.nameNaked() +" body. You hadn't ordered $him to stay "+ globals.expansion.nameNaked() +" so $he proceeded. "
			redress = true
		elif self.rules.nudity == true && globals.fetishopinion.find(self.fetish.exhibitionism) <= 2:
			#Chance to Rebel
			var chance = round(self.metrics.ownership + ((self.loyal + self.obed + self.fear)/3) - (captured * 10))
			var roll = round(rand_range(0,100))
			if roll <= chance && (globals.expansionsettings.only_rebels_can_refuse_strip_rule == true && captured > 0 || globals.expansionsettings.only_rebels_can_refuse_strip_rule == false):
				text += "\n[color=aqua]$name[/color] wanted to cover $his "+ globals.expansion.nameNaked() +" body. However, you ordered $him to stay "+ globals.expansion.nameNaked() +". $He followed your orders obediently. "
				if self.dailyevents.find('rule_nudity_obeyed') < 0 && self.dailyevents.find('rule_nudity_obeyed') < 0:
					self.dailyevents.append('rule_nudity_obeyed')
			else:
				text += "\n[color=aqua]$name[/color] wanted to cover $his "+ globals.expansion.nameNaked() +" body. You had ordered $him to stay "+ globals.expansion.nameNaked() +", but $he ignored your order.\n[color=green]Punishment Valid Reason added; Bonus Applied to Next Date[/color] "
				if self.dailyevents.find('rule_nudity_obeyed') < 0 && self.dailyevents.find('rule_nudity_obeyed') < 0:
					self.dailyevents.append('rule_nudity_disobeyed')
				redress = true
			if globals.expansionsettings.perfectinfo == true:
				text += "\n\nRolled [color=aqua]" + str(roll) + "[/color] | Chance [color=aqua]" + str(chance) + " [/color]. "+ globals.fastif(roll <= chance, '[color=green]Success[/color]', '[color=red]Failure[/color]') +" "
		#Redress
		if redress == true:
			text += "\n"
			#Attempt Failed due to Restraints
			if self.restrained != "none":
				text += "[color=aqua]$name[/color] "+ globals.randomitemfromarray(['','','','desparately ','frustratedly ','angrily ','grumpily ']) +"tried to "+ globals.randomitemfromarray(['dress','clothe $himself','get dressed','redress','put $his clothes back on']) +", but $he was unable to due to $his [color=red]restraints[/color]. "
				globals.expansion.updateMood(self, -1)
				return text
			if self.exposed.chestforced == false || self.exposed.genitalsforced == false || self.exposed.assforced == false:
				text += "[color=aqua]$name[/color] looked at the shredded scraps that used to be $his clothing. These shredded pieces of cloth won't allow $him any privacy or the option to cover $himself in those areas. "
			if self.exposed.chest == true && self.exposed.chestforced == false:
				text += "[color=aqua]$name[/color] "+ globals.randomitemfromarray(['put back on','slipped into','put on']) +" $his tunic, obscuring $his "+ globals.expansion.getChest(self) +". "
				self.exposed.chest = false
			if self.exposed.genitals == true && self.exposed.genitalsforced == false || self.exposed.ass == true && self.exposed.assforced == false:
				text += "[color=aqua]$name[/color] "+ globals.randomitemfromarray(['put back on','slipped into','put on']) +" $his pants, obscuring $his "
				if self.exposed.genitals == true:
					text += globals.expansion.getGenitals(self)
				if self.exposed.ass == true:
					if self.exposed.genitals == true:
						text += " and " 
					text += globals.expansion.nameAss()
				self.exposed.genitals = false
				self.exposed.ass = false
				text += ". "
		
	else:
		var strip = false
		#Dressed - Do They Need/Want to Strip?
		if self.rules.nudity == true:
			#Consent
			if self.consentexp.nudity == true || self.fetish.exhibitionism in ['enjoyable','mindblowing']:
				text += "\n[color=aqua]$name[/color] wanted to strip " + globals.expansion.nameNaked() + " " + globals.randomitemfromarray(['','','slowly','quickly','eagerly','obediently']) + " as per your [color=aqua]rules[/color]. "
				if self.checkFetish('exhibitionism', 1, false, false):
					text += "$He likely would have done so "+ globals.randomitemfromarray(['','eagerly','excitedly']) +" anyways due to $his [color=green]"+ globals.randomitemfromarray(['exhibitionism','natural exhibitionism','exhibitionism fetish','love of being nude','enjoyment of others seeing $his naked body']) +"[/color]. "
				if self.dailyevents.find('rule_nudity_obeyed') < 0 && self.dailyevents.find('rule_nudity_obeyed') < 0:
					self.dailyevents.append('rule_nudity_obeyed')
				strip = true
			else:
				text += "\n[color=aqua]$name[/color] seemed to hesitate when considering stripping " + globals.expansion.nameNaked() + " as per your rules "+ globals.randomitemfromarray(['','as this is all new','as $he still feels awkward about it','as $he is unsure how $he feels about it']) +". "
				captured = 0
				for i in self.effects.values():
					if i.code == 'captured':
						captured = i.duration/2
				var chance = round(self.metrics.ownership + ((self.loyal + self.obed + self.fear)/2) - (captured * 10))
				var roll = round(rand_range(0,100))
				if roll <= chance:
					text += "$He decided that $he did want to strip " + globals.expansion.nameNaked() + " " + globals.randomitemfromarray(['','','slowly','quickly','eagerly','obediently','for you']) + " as per your rules. "
					if self.fetish.exhibitionism in ['enjoyable','mindblowing'] || self.checkFetish('exhibitionism', 1, false, false):
						text += "$His [color=green]"+ globals.randomitemfromarray(['exhibitionism','natural exhibitionism','exhibitionism fetish','love of being nude','enjoyment of others seeing $his naked body']) +"[/color] shone through and $he chose not hesistate to strip for you in the future. "
						self.consentexp.nudity = true
					else:
						text += "$He still seems hesitant about doing it in the future. $He may need to be more [color=green]"+ globals.randomitemfromarray(['exhibitionist','comfortable showing others $his body','into the exhibitionism fetish','of a nudist','into others seeing $his naked body']) +"[/color] to fully accept it. "
					if self.dailyevents.find('rule_nudity_obeyed') < 0 && self.dailyevents.find('rule_nudity_obeyed') < 0:
						self.dailyevents.append('rule_nudity_obeyed')
					strip = true
				else:
					text += "\n[color=red][color=aqua]$name[/color] refused to strip " + globals.expansion.nameNaked() + " per your orders. $He has broke your rules. $He seems to need a lesson in [color=aqua]Fear[/color], [color=aqua]Obedience[/color], or [color=aqua]Loyalty[/color]. [/color]\n[color=green]Punishment Valid Reason added; Bonus Applied to Next Date[/color] "
					if self.dailyevents.find('rule_nudity_obeyed') < 0 && self.dailyevents.find('rule_nudity_obeyed') < 0:
						self.dailyevents.append('rule_nudity_disobeyed')
				if globals.expansionsettings.perfectinfo == true:
					text += "\n\nRolled [color=aqua]" + str(roll) + "[/color] | Chance [color=aqua]" + str(chance) + " [/color]. "+ globals.fastif(roll <= chance, '[color=green]Success[/color]', '[color=red]Failure[/color]') +" "
		elif self.fetish.exhibitionism == 'mindblowing':
			strip = true
			text += "\n[color=aqua]$name[/color] "+ globals.randomitemfromarray(['','','eagerly','excitedly','happily']) +" tried to strip "+ globals.expansion.nameNaked() +"  due to $his [color=aqua]"+ globals.randomitemfromarray(['exhibitionism','natural exhibitionism','exhibitionism fetish','love of being nude','enjoyment of others seeing $his naked body']) +"[/color]. "
			
		#Strip
		if strip == true:
			text += "\n"
			#Attempt Failed due to Restraints
			if self.restrained != "none":
				text += "[color=aqua]$name[/color] "+ globals.randomitemfromarray(['','','','desparately','frustratedly','angrily','grumpily','sarcastically']) +" tried to "+ globals.randomitemfromarray(['strip','undress','get naked','get nude','strip $himself']) +", but $he was unable to due to $his [color=red]restraints[/color]. "
				globals.expansion.updateMood(self, -1)
				return text
			if self.exposed.chest == false:
				text += "[color=aqua]$name[/color] "+ globals.randomitemfromarray(['took off','stripped','removed','stripped off','pulled off','slipped out of']) +" $his tunic, revealing $his "+ globals.expansion.getChest(self) +". "
				self.exposed.chest = true
			if self.exposed.genitals == false || self.exposed.ass == true:
				text += "[color=aqua]$name[/color] "+ globals.randomitemfromarray(['took off','stripped','removed','stripped off','pulled off','slipped out of']) +" $his pants, revealing $his "
				if self.exposed.genitals == false:
					text += globals.expansion.getGenitals(self)
				if self.exposed.ass == true:
					if self.exposed.genitals == false:
						text += " and " 
					text += globals.expansion.nameAss()
				self.exposed.genitals = true
				self.exposed.ass = true
				text += ". "
				
	return text

#---Vice (Formerly Flaw)
#Vice Checks/Reveals
func checkVice(type, countascheck = true):
	var allvices = globals.expansion.vicearray
	var success = false
	if !allvices.has(type):
		print('Vice type ' + type + ' does not exist to be Checked')
		return success
	
	if self.mind.vice == type:
		success = true
		if countascheck == true:
			self.dailyevents.append(type)
	
	return success

func revealVice(incomingtype = 'none'):
	#use person.revealVice() to reveal their Vice, use person.revealVice('type') to "guess" the vice
	if self.mind.vice_known == true:
		return "\nYou already know $his [color=aqua]Vice[/color]."
	
	var allvices = globals.expansion.vicearray
	var text = ""
	var type = incomingtype
	if type != 'none' && !allvices.has(type):
		print('Vice type ' + type + ' does not exist to be Revealed')
		return
	
	#Modifier
	var chance = (globals.player.smaf*10) + (self.dailyevents.count(self.mind.vice)*10)
	if self.mind.vice_presented == true:
		chance += globals.expansionsettings.vices_discovery_presentation_bonus
	
	type = self.mind.vice
	
	if rand_range(0,100) <= chance:
		self.mind.vice_known = true
		text = globals.expansion.vicedict[type]
	else:
		self.dailyevents.append(type)
	return text

#Whims -- default color for the slave list
var namecolor = 'white'

###---End of Expansion---###
