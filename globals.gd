
var rules = {
	futa = true,
	futaballs = false,
	furry = true,
	furrynipples = true,
	dickgirl = false, # centerflag982 - added dickgirl
	male_chance = 15,
	futa_chance = 10,
	dickgirl_chance = 5, # centerflag982 - added dickgirl
	children = false,
	noadults = false,
	slaverguildallraces = false,
	fontsize = 18,
	musicvol = 24,
	soundvol = 24,
	receiving = true,
	fullscreen = false,
	oldresize = true,
	fadinganimation = true,
	permadeath = false,
	autoattack = true,
	showfullbody = true,
	enddayalise = 1,
	spritesindialogues = true,
	instantcombatanimation = false,
	randomcustomportraits = true,
	thumbnails = false,
}

###---Added by Expansion---### Hucow Specialization
var specarray = ['geisha','ranger','executor','bodyguard','assassin','housekeeper','trapper','nympho','merchant','tamer','hucow','mage','warrior','dancer']
###---End Expansion---###

var gradeimages = {
	"slave" : load("res://files/buttons/mainscreen/40.png"),
	poor = load("res://files/buttons/mainscreen/41.png"),
	commoner = load("res://files/buttons/mainscreen/42.png"),
	rich = load("res://files/buttons/mainscreen/43.png"),
	atypical = load("res://files/buttons/mainscreen/40.png"), ###---Added by Expansion---###
	noble = load("res://files/buttons/mainscreen/44.png"),
}

###---Added by Expansion---###
var specimages = {
	Null = null,
	geisha = load("res://files/buttons/mainscreen/33.png"),
	ranger = load("res://files/buttons/mainscreen/37.png"),
	executor = load("res://files/buttons/mainscreen/38.png"),
	bodyguard = load("res://files/buttons/mainscreen/31.png"),
	assassin = load("res://files/buttons/mainscreen/30.png"),
	housekeeper = load("res://files/buttons/mainscreen/34.png"),
	trapper = load("res://files/buttons/mainscreen/39.png"),
	nympho = load("res://files/buttons/mainscreen/36.png"),
	merchant = load("res://files/buttons/mainscreen/35.png"),
	tamer = load("res://files/buttons/mainscreen/32.png"),
	hucow = load("res://files/aric_expansion_images/specialization_icons/cow_icon.png"),
	mage = load("res://files/aric_expansion_images/specialization_icons/mage_icon.png"),
	warrior = load("res://files/aric_expansion_images/specialization_icons/warrior_icon.png"),
	dancer = load("res://files/aric_expansion_images/specialization_icons/dancer_icon.png"),
}
###---End Expansion---###

var sexicon = {
	female = load("res://files/buttons/sexicons/female.png"),
	male = load("res://files/buttons/sexicons/male.png"),
	futanari = load("res://files/buttons/sexicons/futa.png"),
	dickgirl = load("res://files/buttons/sexicons/dickgirl.png"), # centerflag982 - added dickgirl icon
}

func loadsettings():
	var file = File.new()
	var dir = Directory.new()
	var retCode
	
	###---Added by Expansion---### Images Expanded
	var baseFolders = {portraits = appDataDir +'portraits/', fullbody = appDataDir + 'bodies/', mods = appDataDir + 'mods/', fullbodynaked = appDataDir + 'bodiesnaked/', fullbodypreg = appDataDir + 'bodiespreg/'}
	###---End Expansion---###
	for i in baseFolders.values():
		if !dir.dir_exists(i):
			retCode = dir.make_dir_recursive(i)
			printErrorCode("Creating folder " + i, retCode)
		
	if file.file_exists(settingsFile):
		retCode = file.open(settingsFile, File.READ)
		if retCode == OK:
			var temp = str2var(file.get_as_text())
			if typeof(temp) == TYPE_DICTIONARY:
				for i in rules:
					if temp.has(i):
						rules[i] = temp[i]
			else:
				printErrorCode("settings file contains no data", ERR_FILE_CORRUPT)
			file.close()
		else:
			printErrorCode("Reading file " + settingsFile, retCode)
	else:
		retCode = file.open(settingsFile, File.WRITE)
		if retCode == OK:
			file.store_line(var2str(rules))
			file.close()
		else:
			printErrorCode("Writing file " + settingsFile, retCode)

	if file.file_exists(progressFile):
		retCode = file.open_encrypted_with_pass(progressFile, File.READ, 'tehpass')
		if retCode == OK:
			var storedsettings = file.get_var()
			var temp = storedsettings.get('chars')
			if temp:
				for character in charactergallery:
					if !temp.has(character):
						continue
					for part in charactergallery[character]:
						if part in ['unlocked', 'nakedunlocked'] && temp[character].has(part):
							charactergallery[character][part] = temp[character][part]
						elif part == 'scenes':
							for scene in range(temp[character][part].size()):
								charactergallery[character][part][scene].unlocked = temp[character][part][scene].unlocked

			temp = storedsettings.get('folders')
			if temp:
				for i in temp:
					if temp[i].ends_with('/'):
						baseFolders[i] = temp[i]
					else:
						baseFolders[i] = temp[i] + '/'

			temp = storedsettings.get('savelist')
			if temp:
				for i in temp:
					savelist[i] = temp[i]

			file.close()
		else:
			printErrorCode("Reading file " + progressFile, retCode)
	else:
		retCode = file.open_encrypted_with_pass(progressFile, File.WRITE, 'tehpass')
		if retCode == OK:
			var data = {chars = charactergallery, folders = baseFolders, savelist = {}}
			file.store_var(data)
			file.close()
		else:
			printErrorCode("Writing file " + progressFile, retCode)
	return baseFolders

func clearstate():
	state = progress.new()
	slaves.clear()
	events = load("res://files/scripts/events.gd").new()
	items = load("res://files/scripts/items.gd").new()
	itemdict = items.itemlist
	spells = load("res://files/scripts/spells.gd").new()
	spelldict = spells.spelllist
	if useRalphsTweaks:
		expansionsettings.applyItemMarketCostTweaks()
		expansionsettings.applySpellManacostTweaks()
	resources = resource.new()

func newslave(race, age, sex, origins = 'slave', unique = null):
	return constructor.newslave(race, age, sex, origins, unique)

func slaves_set(person):
	person.originstrue = person.origins
	person.health = max(person.health, 5)
	if person.ability.has('protect') == false:
		person.ability.append("protect")
		person.abilityactive.append("protect")
	###---Added by Expansion---### Category: NPCs Expanded
	if person.npcexpanded.timesmet > 0:
		if person.npcexpanded.timesfought > 0:
			person.fear = person.npcexpanded.timesfought*5
		if person.npcexpanded.timesrescued > 0:
			person.loyal = person.npcexpanded.timesrescued*5
	if globals.state.relativesdata[person.id].state != "enslaved":
		globals.state.relativesdata[person.id].state = "enslaved"
	###---End Expansion---###
	slaves.append(person)
	if get_tree().get_current_scene().find_node('CharList'):
		get_tree().get_current_scene().rebuild_slave_list()
	if get_tree().get_current_scene().find_node('ResourcePanel'):
		get_tree().get_current_scene().find_node('population').set_text(str(slavecount())) 
	if globals.get_tree().get_current_scene().has_node("infotext"):
		globals.get_tree().get_current_scene().infotext("New Character acquired: " + person.name_long(),'green')

class resource:
	var day = 1 setget day_set
	var gold = 0 setget gold_set
	var mana = 0 setget mana_set
	var energy = 100 setget energy_set
	var food = 0 setget food_set
	var upgradepoints = 0 setget upgradepoints_set
	var panel
	###---Added by Expansion---### Farm Expanded
	var array = ['day','gold','mana','energy','food', 'milk', 'semen', 'lube', 'piss']
	var milk = 0 setget milk_set
	var semen = 0 setget semen_set
	var lube = 0 setget lube_set
	var piss = 0 setget piss_set
	var farmexpanded = {
		workstation = {free = -1, rack = 0, cage = 0},
		stallbedding = {dirt = -1, hay = 0, cot = 0, bed = 0},
		extractors = {hand = -1, suction = 0, pump = 0, pressurepump = 0},
		containers = {cup = 0, bucket = 0, pail = 0, jug = 0, canister = 0, bottle = 0},
		farminventory = {prods = 0}, #TBK - Remove Later
		vats = {
			processingorder = ['milk','semen','lube','piss'],
			milk = {vat = 0, new = 0, sell = 0, food = 0, refine = 0, bottle2sell = 0, bottle2refine = 0, priceper = 0, foodper = 0, auto = 'vat', autobuybottles = false, basebottlingenergy = 5,},
			semen = {vat = 0, new = 0, sell = 0, food = 0, refine = 0, bottle2sell = 0, bottle2refine = 0, priceper = 0, foodper = 0, auto = 'vat', autobuybottles = false, basebottlingenergy = 6},
			lube = {vat = 0, new = 0, sell = 0, food = 0, refine = 0, bottle2sell = 0, bottle2refine = 0, priceper = 0, foodper = 0, auto = 'vat', autobuybottles = false, basebottlingenergy = 6},
			piss = {vat = 0, new = 0, sell = 0, food = 0, refine = 0, bottle2sell = 0, bottle2refine = 0, priceper = 0, foodper = 0, auto = 'vat', autobuybottles = false, basebottlingenergy = 7},
		},
		snails = {eggs = 0, auto = 'none', neweggs = 0, food = 0, sell = 0, hatch = 0, cookwithoutchef = false, foodperchef = 3, goldperegg = 25, goldpersnail = 250},
		incubators = {
			'1': {name = "Incubator 1", level = 0, filled = false, growth = 0},
			'2': {name = "Incubator 2", level = 0, filled = false, growth = 0},
			'3': {name = "Incubator 3", level = 0, filled = false, growth = 0},
			'4': {name = "Incubator 4", level = 0, filled = false, growth = 0},
			'5': {name = "Incubator 5", level = 0, filled = false, growth = 0},
			'6': {name = "Incubator 6", level = 0, filled = false, growth = 0},
			'7': {name = "Incubator 7", level = 0, filled = false, growth = 0},
			'8': {name = "Incubator 8", level = 0, filled = false, growth = 0},
			'9': {name = "Incubator 9", level = 0, filled = false, growth = 0},
			'10': {name = "Incubator 10", level = 0, filled = false, growth = 0},
			basecost = 200,
			upgrademultiplier = 2.5,
			upgrademax = 10,
		},
		bottler = {level = 0, totalproduced = 0},
		worker_cycle = {'farmhand':[], 'milkmaid':[], 'stud':[]},
		work_type = "",
	}
	###---Expansion End---### 
	
	var foodcaparray = [500, 750, 1000, 1500, 2000, 3000]
	
	func update():
		for i in array:
			#self[i] += 0
			set(i, get(i))
	
	func gold_set(value):
		value = round(value)
		var color
		var difference = gold - value
		var text = ""
		gold = value
		if gold < 0:
			gold = 0
		if panel != null:
			panel.get_node('gold').set_text(str(gold))
		
		
		if difference != 0:
			if difference < 0:
				text = "Obtained " + str(abs(difference)) +  " gold"
				color = 'green'
			else:
				color = 'red'
				text = "Lost " + str(abs(difference)) +  " gold"
		
		if globals.get_tree().get_current_scene().has_node("infotext"):
			globals.get_tree().get_current_scene().infotext(text,color)
	
	func day_set(value):
		day = value
		if day < 0:
			day = 0
		if panel != null:
			panel.get_node('day').set_text(str(day))
	
	func food_set(value):
		value = round(value)
		var color
		var difference = round(food - value)
		var text = ""
		food = clamp(value, 0, foodcaparray[globals.state.mansionupgrades.foodcapacity])
		if panel != null:
			panel.get_node('food').set_text(str(food))
		if difference != 0:
			if difference < 0:
				text = "Obtained " + str(abs(difference)) +  " food"
				color = 'green'
			else:
				text = "Lost " + str(abs(difference)) +  " food"
				color = 'red'
		if globals.get_tree().get_current_scene().has_node("infotext"):
			globals.get_tree().get_current_scene().infotext(text,color)
	
	func mana_set(value):
		value = round(value)
		#var color
		var difference = mana - value
		var text = ""
		mana = value
		if mana < 0:
			mana = 0
		
		if panel != null:
			panel.get_node('mana').set_text(str(mana))
		
		if difference != 0:
			if difference < 0:
				text = "Obtained " + str(abs(difference)) +  " mana"
			else:
				text = "Used " + str(abs(difference)) +  " mana"
		
		if globals.get_tree().get_current_scene().has_node("infotext"):
			globals.get_tree().get_current_scene().infotext(text)
		
	###---Added by Expansion---### Farm Expanded
	func milk_set(value):
		value = round(value)
		var color
		var difference = round(milk - value)
		var text = ""
#		milk = value
		#Clamp Values per Mansion Upgrade
		var vatmax = globals.getVatMaxCapacity('vatmilk')
		milk = clamp(value, 0, vatmax)
#		if panel != null:
#			panel.get_node('food').set_text(str(food))
		if difference != 0:
			if difference < 0:
				text = "Obtained " + str(abs(difference)) +  " units of milk in your vat"
				color = 'green'
			else:
				text = "Lost " + str(abs(difference)) +  " units of milk in your vat"
				color = 'red'
		if globals.get_tree().get_current_scene().has_node("infotext"):
			globals.get_tree().get_current_scene().infotext(text,color)
	
	func semen_set(value):
		value = round(value)
		var color
		var difference = round(semen - value)
		var text = ""
#		semen = value
#		if semen < 0:
#			semen = 0
		#Clamp Values per Mansion Upgrade
		var vatmax = globals.getVatMaxCapacity('vatsemen')
		semen = clamp(value, 0, vatmax)
		if difference != 0:
			if difference < 0:
				text = "Obtained " + str(abs(difference)) +  " units of semen in your vat"
				color = 'green'
			else:
				text = "Lost " + str(abs(difference)) +  " units of semen in your vat"
				color = 'red'
		if globals.get_tree().get_current_scene().has_node("infotext"):
			globals.get_tree().get_current_scene().infotext(text,color)

	func lube_set(value):
		value = round(value)
		var color
		var difference = round(lube - value)
		var text = ""
		#Clamp Values per Mansion Upgrade
		var vatmax = globals.getVatMaxCapacity('vatlube')
		lube = clamp(value, 0, vatmax)
#		lube = value
#		if lube < 0:
#			lube = 0
#		cum = clamp(value, 0, foodcaparray[globals.state.mansionupgrades.foodcapacity])
#		if panel != null:
#			panel.get_node('food').set_text(str(food))
		if difference != 0:
			if difference < 0:
				text = "Obtained " + str(abs(difference)) +  " units of lube in your vat"
				color = 'green'
			else:
				text = "Lost " + str(abs(difference)) +  " units of lube in your vat"
				color = 'red'
		if globals.get_tree().get_current_scene().has_node("infotext"):
			globals.get_tree().get_current_scene().infotext(text,color)

	func piss_set(value):
		value = round(value)
		var color
		var difference = round(piss - value)
		var text = ""
		#Clamp Values per Mansion Upgrade
		var vatmax = globals.getVatMaxCapacity('vatpiss')
		piss = clamp(value, 0, vatmax)
#		piss = value
#		if piss < 0:
#			piss = 0
#		piss = clamp(value, 0, foodcaparray[globals.state.mansionupgrades.foodcapacity])
#		if panel != null:
#			panel.get_node('food').set_text(str(food))
		if difference != 0:
			if difference < 0:
				text = "Obtained " + str(abs(difference)) +  " units of piss in your vat"
				color = 'green'
			else:
				text = "Lost " + str(abs(difference)) +  " units of piss in your vat"
				color = 'red'
		if globals.get_tree().get_current_scene().has_node("infotext"):
			globals.get_tree().get_current_scene().infotext(text,color)
	###---Expansion End---### 
	
	func upgradepoints_set(value):
		var difference = upgradepoints - value
		var bonus = 0
		var gifted = false
		if difference < 0:
			for i in globals.slaves:
				if i.traits.has("Gifted"):
					gifted = true
		if gifted:
			bonus = ceil(abs(difference) * 0.2)
		var text = ""
		upgradepoints = value + bonus
		
		
		if difference < 0:
			text = "Obtained " + str(abs(difference)+bonus) +  " Mansion Upgrade Points"
		
		
		if globals.get_tree().get_current_scene().has_node("infotext"):
			globals.get_tree().get_current_scene().infotext(text,'green')
	
	func energy_set(value):
		if panel != null:
			panel.get_node("energy").set_text(str(round(globals.player.energy)))

class progress:
	var pregduration = variables.pregduration
	var tutorialcomplete = false
	var supporter = false
	var location = 'wimborn'
	var nopoplimit = false
	var condition = 85 setget cond_set
	var conditionmod = 1.3
	var spec = ''
	var farm = 0 
	var apiary = 0
	var branding = 0
	var slaveguildvisited = 0
	var umbrafirstvisit = true
	var itemlist = {}
	var curRopeBreakChance = 0
	var spelllist = {}
	var mainquest = 0
	var mainquestcomplete = false
	var rank = 0
	var password = ''
	var sidequests = {startslave = 0, emily = 0, brothel = 0, cali = 0, caliparentsdead = false, chloe = 0, ayda = 0, ivran = '', yris = 0, zoe = 0, ayneris = 0, sebastianumbra = 0, maple = 0, dimcrystal = 0} setget quest_set
	var repeatables = {wimbornslaveguild = [], frostfordslaveguild = [], gornslaveguild = []}
	var babylist = []
	var companion = -1
	var headgirlbehavior = 'none'
	var portals = {wimborn = {'enabled' : false, 'code' : 'wimborn'}, gorn = {'enabled':false, 'code' : 'gorn'}, frostford = {'enabled':false, 'code' : 'frostford'}, amberguard = {'enabled':false, 'code':'amberguard'}, umbra = {'enabled':false, 'code':'umbra'}}
	var sebastianorder = {race = 'none', taken = false, duration = 0}
	var sebastianslave
	var sandbox = false
	var snails = 0
	var groupsex = true
	var playergroup = []
	var timedevents = {}
	var customcursor = "res://files/buttons/kursor1.png"
	var upcomingevents = []
	###---Added by Expansion---### Towns Expanded
	var reputation = {wimborn = 0, frostford = 0, gorn = 0, amberguard = 0, shaliq = 0, umbra = 0} setget reputation_set
	var bountiescollected = {wimborn = 0, frostford = 0, gorn = 0, amberguard = 0, shaliq = 0, umbra = 0} #ralphD
	###---End Expansion---###
	var dailyeventcountdown = 0
	var dailyeventprevious = 0
	var currentversion = 5000
	var unstackables = {}
	var supplykeep = 10
	var foodbuy = 200
	var supplybuy = false
	var manastock = 200
	var manabuy = false
	var tutorial = {basics = false, person = false, alchemy = false, jail = false, lab = false, farm = false, outside = false, combat = false, interactions = false}
	var itemcounter = 0
	var slavecounter = 0
	var alisecloth = 'normal'
	var decisions = []
	var lorefound = []
	var racemarketsat = {} #ralph5 - variable to track market saturation of various races (sell a lot of one race and its pricing goes down, etc.)
	var relativesdata = {}
	var descriptsettings = {full = true, basic = true, appearance = true, genitals = true, piercing = true, tattoo = true, mods = true}
	###---Added by Expansion---### Dimensional Crystal & Farm Expanded
	var mansionupgrades = {
		farmcapacity = 0,
		farmhatchery = 0,
		farmtreatment = 0,
		farmmana = 0,
		foodcapacity = 0,
		foodpreservation = 0,
		jailcapacity = 1,
		jailtreatment = 0,
		jailincenses = 0,
		mansioncommunal = 4,
		mansionpersonal = 1,
		mansionbed = 0,
		mansionluxury = 0,
		mansionalchemy = 0,
		mansionlibrary = 0,
		mansionlab = 0,
		mansionkennels = 0,
		mansionnursery = 0,
		mansionparlor = 0,
		dimensionalcrystal = 0,
		vatspace = 0,
		vatmilk = 0,
		vatsemen = 0,
		vatlube = 0,
		vatpiss = 0,
		bottler = 0,
		traininggrounds = 0,
	}
	###---End Expansion---###
	var plotsceneseen = []
	var capturedgroup = []
	###---Added by Expansion---### Towns Expanded
	var ghostrep = {wimborn = 0, frostford = 0, gorn = 0, amberguard = 0, shaliq = 0, umbra = 0}
	###---End Expansion---###
	var backpack = {stackables = {}, unstackables = []} setget backpack_set
	var restday = 0
	var defaultmasternoun = "Master"
	var sexactions = 1
	var nonsexactions = 1
	var actionblacklist = []
	var marklocation 
	###---Added by Expansion---###
	var expansionversion = 0
	#---Category: NPCs Expanded
	var allnpcs = [] setget npcs_set
	#offscreennpcs = [person.id, location.code, encounterchance, action, reputation, status]
	var offscreennpcs = []
	#v Old v
	var npclastlocation = []
	#---Towns Expanded | Number is Efficiency and/or Opinion for checks out of 100
	var townsexpanded = {
		wimborn = {
			localnpcs = {leader = -1, nobles = [], guards = [], commoners = [], whores = [], beggers = []},
			gold = 10000,
			guardskill = 25,
			slavery = 65,
			nudity = 50,
			wearcum = 20,
			milkvalue = 13,
			milkinterest = 5,
			acceptablemilk = ['Taurus'],
			pendingexecution = [],
			currentevents = [],
			dailyreport = {text = "", shopping = 0, crimeattempted = 0, crimeprevented = 0, crimesucceeded = 0},
			laws = {public_nudity = false,},
			townhall = {
				law_change_cost = 5,
				fines = [],
				autopay_fines = false,
			},
		},
		shaliq = {
			localnpcs = {leader = -1, nobles = [], guards = [], commoners = [], whores = [], beggers = []},
			gold = 3000,
			guardskill = 5,
			slavery = 40,
			prostitution = 10,
			nudity = 30,
			wearcum = 10,
			milkvalue = 15,
			milkinterest = 5,
			acceptablemilk = ['Taurus'],
			pendingexecution = [],
			currentevents = [],
			dailyreport = {text = "", shopping = 0, crimeattempted = 0, crimeprevented = 0, crimesucceeded = 0},
			laws = {public_nudity = false,},
			townhall = {
				law_change_cost = 5,
				fines = [],
				autopay_fines = false,
			},
		},
		frostford = {
			localnpcs = {leader = -1, nobles = [], guards = [], commoners = [], whores = [], beggers = []},
			gold = 10000,
			guardskill = 5,
			slavery = 25,
			prostitution = 10,
			nudity = 80,
			wearcum = 20,
			milkvalue = 20,
			milkinterest = 5,
			acceptablemilk = ['Taurus','Wolf','Cat','Bunny'],
			pendingexecution = [],
			currentevents = [],
			dailyreport = {text = "", shopping = 0, crimeattempted = 0, crimeprevented = 0, crimesucceeded = 0},
			laws = {public_nudity = false,},
			townhall = {
				law_change_cost = 5,
				fines = [],
				autopay_fines = false,
			},
		},
		gorn = {
			localnpcs = {leader = -1, nobles = [], guards = [], commoners = [], whores = [], beggers = []},
			gold = 10000,
			guardskill = 30,
			slavery = 85,
			prostitution = 20,
			nudity = 60,
			wearcum = 30,
			milkvalue = 18,
			milkinterest = 5,
			acceptablemilk = ['Taurus'],
			pendingexecution = [],
			currentevents = [],
			dailyreport = {text = "", shopping = 0, crimeattempted = 0, crimeprevented = 0, crimesucceeded = 0},
			laws = {public_nudity = false,},
			townhall = {
				law_change_cost = 5,
				fines = [],
				autopay_fines = false,
			},
		},
		umbra = {
			localnpcs = {leader = -1, nobles = [], guards = [], commoners = [], whores = [], beggers = []},
			gold = 15000,
			guardskill = 40,
			slavery = 100,
			prostitution = 100,
			nudity = 90,
			wearcum = 75,
			milkvalue = 20,
			milkinterest = 5,
			acceptablemilk = ['Taurus'],
			pendingexecution = [],
			currentevents = [],
			dailyreport = {text = "", shopping = 0, crimeattempted = 0, crimeprevented = 0, crimesucceeded = 0},
			laws = {public_nudity = false,},
			townhall = {
				law_change_cost = 5,
				fines = [],
				autopay_fines = false,
			},
		},
		amberguard = {
			localnpcs = {leader = -1, nobles = [], guards = [], commoners = [], whores = [], beggers = []},
			gold = 10000,
			guardskill = 35,
			slavery = 25,
			prostitution = 15,
			nudity = 10,
			wearcum = 5,
			milkvalue = 15,
			milkinterest = 5,
			acceptablemilk = ['Taurus'],
			pendingexecution = [],
			currentevents = [],
			dailyreport = {text = "", shopping = 0, crimeattempted = 0, crimeprevented = 0, crimesucceeded = 0},
			laws = {public_nudity = false,},
			townhall = {
				law_change_cost = 5,
				fines = [],
				autopay_fines = false,
			},
		}
	}
	#Tracks and Saves created Hybrid Races
	var hybridraces = {}
	#Debug/Cheat Change Before Release to "Unlockable"
	var perfectinfo = true
	#Crystal Prevent's Death
	var thecrystal = {mode = 'light', research = 0, abilities = [], power = 0, lifeforce = 10, hunger = 0, empoweredvirginity = false, preventsdeath = false,}
	#Milk Economy / globals.state.milkeconomy.currentvalue
	var milkeconomy = {currentvalue = 1, futurevalue = 1}
	#Best Slave - Used for Envy Flaw
	var bestslave
	###---Expansion End---###
	
	func quest_set(value):
		sidequests = value
		if globals.mainscreen != 'mainmenu':
			globals.main.infotext('Side Quest Advanced',"yellow")
	
	func calculateweight():
		var _slave
		var tempitem
		var currentweight = 0
		var maxweight = variables.basecarryweight + max(globals.player.sstr*variables.carryweightperstrplayer, 0)
		var array = [globals.player]
		for i in globals.state.playergroup:
			_slave = globals.state.findslave(i)
			array.append(_slave)
			maxweight += max(_slave.sstr*variables.slavecarryweightperstr,0) + variables.baseslavecarryweight
			if _slave.race.find('Squirrel') >= 0:
				maxweight += 15
		for i in globals.state.backpack.stackables:
			if globals.itemdict[i].has('weight'):
				currentweight += globals.itemdict[i].weight * globals.state.backpack.stackables[i]
		
		for i in globals.state.unstackables.values():
			if i.has('weight') && str(i.owner) == 'backpack':
				currentweight += i.weight
		for i in array:
			for k in i.gear.values():
				###---Added by Expansion---### Fixed by PallingtonA1
				if k != null && globals.state.unstackables[k].code.find('travelbag') != -1: maxweight += 20
				###---End Expansion---###
		var dict = {currentweight = currentweight, maxweight = maxweight, overload = maxweight < currentweight}
		return dict
	
	func reputation_set(value):
		var text = ''
		var color
		for i in value:
			if ghostrep[i] != value[i]:
				value[i] = min(max(value[i], -50),50)
				if ghostrep[i] > value[i]:
					text += "Reputation with " + i.capitalize() + " has worsened!"
					color = 'red'
				else:
					text += "Reputation with " + i.capitalize() + " has increased!"
					color = 'green'
				ghostrep[i] = value[i]
		if globals.get_tree().get_current_scene().has_node("infotext"):
			globals.get_tree().get_current_scene().infotext(text,color)

	
	func cond_set(value):
		condition += value*conditionmod
		if condition > 100:
			condition = 100
		elif condition < 0:
			condition = 0
	
	func findbaby(id):
		var rval
		for i in babylist:
			if str(i.id) == str(id):
				rval = i
		return rval
	
	func findslave(id):
		id = str(id)
		###---Added by Expansion---### Category: NPCs Expanded | Search Baddies if not in Slaves
		if str(globals.player.id) == id:
			return globals.player
		for person in globals.slaves:
			if str(person.id) == id:
				return person
		return findnpc(id)
		###---End Expansion---###

	###---Added by Expansion---### Category: Better NPCs
	func npcs_set(refperson):
		var person = refperson
		if person == null:
			return
		person.originstrue = person.origins
		person.health = max(person.health, 5)
		if person.ability.has('protect') == false:
			person.ability.append("protect")
			person.abilityactive.append("protect")
		
		if globals.get_tree().get_current_scene().has_node("infotext"):
			if person.npcexpanded.lastevent == 'rescued':
				globals.get_tree().get_current_scene().infotext(person.name_long() + " was rescued. Maybe you'll meet them again! ",'green')
			elif person.npcexpanded.lastevent == 'raped':
				globals.get_tree().get_current_scene().infotext(person.name_long() + " limps away clutching their aching genitals. You look forward to seeing them again. ",'red')
			elif person.npcexpanded.lastevent == 'fought':
				globals.get_tree().get_current_scene().infotext(person.name_long() + " crawls away, bloodied and broken. They won't forget today's defeat. ",'red')
			else:
				globals.get_tree().get_current_scene().infotext(person.name_long() + " goes free. Maybe you will see them again.. ",'green')
#		globals.state.allnpcs.append(inst2dict(person))
		globals.state.allnpcs.append(person)
	
	func findnpc(newid):
		newid = str(newid)
		for npc in allnpcs:
			if str(npc.id) == newid:
				return npc
		return null
	###---End Expansion---###

	func backpack_set(value):
		backpack = value
		checkbackpack()
	
	func checkbackpack():
		for i in backpack.stackables.duplicate():
			if backpack.stackables[i] <= 0:
				backpack.stackables.erase(i)

	func getCountStackableItem(item, search = 'any'):
		var count = 0
		if (search in ['any','backpack']):
			if backpack.stackables.has(item):
				count += backpack.stackables[item]
		if (search in ['any','inventory']):		
			if globals.itemdict.has(item):
				count += globals.itemdict[item].amount
		return count

	func removeStackableItem(item, count = 1, search = 'any'):
		if count > 0 && (search in ['any','backpack']):
			if backpack.stackables.has(item):
				if backpack.stackables[item] > count:
					backpack.stackables[item] -= count
					return 0
				else:
					count -= max(backpack.stackables[item], 0)
					backpack.stackables.erase(item)
		if count > 0 && (search in ['any','inventory']):	
			if globals.itemdict.has(item):
				if globals.itemdict[item].amount >= count:
					globals.itemdict[item].amount -= count
					return 0
				else:
					count -= max(globals.itemdict[item].amount, 0)
					globals.itemdict[item].amount = 0
		return count
		
	#ralph5
	func setupracemarketsat():
		for race in globals.races:
			if !racemarketsat.has(race):
				racemarketsat[race] = globals.races[race].pricemod
				#print(race + " added to racemarketsat with value: " + str(racemarketsat[race]))
	#/ralph5

	# calculates and returns the number of ropes recovered after use, mainly for adding to appropriate inventory. displays infotext if ropes are lost
	func calcRecoverRope(numPersons, usedFor = 'capture'):
		var lostRope = 0
		if usedFor == 'capture':
			if variables.consumerope <= 0:
				return 0
			for i in range(numPersons):
				if rand_range(0, 100) < curRopeBreakChance:
					lostRope += variables.consumerope
					curRopeBreakChance = 0
				else:
					curRopeBreakChance += variables.ropewearoutrate
			numPersons *= variables.consumerope
		elif usedFor == 'sex':
			for i in range(numPersons):
				if rand_range(0, 100) < curRopeBreakChance / 2:
					lostRope += 1
					curRopeBreakChance = 0
				else:
					curRopeBreakChance += variables.ropewearoutrate / 2
		if globals.main && lostRope > 0:
			globals.main.infotext(str(lostRope) + ' rope%s wore out from use' % ('s' if lostRope > 1 else ''),'red')
		return numPersons - lostRope

func addrelations(person, person2, value):
	if person == player || person2 == player || person == person2:
		return
	if person == null || person2 == null:
		return
	if person.relations.has(person2.id) == false:
		person.relations[person2.id] = 0
	if person2.relations.has(person.id) == false:
		person2.relations[person.id] = 0
	if person.relations[person2.id] > 500 && value > 0 && checkifrelatives(person, person2):
		value = value/1.5
	elif person.relations[person2.id] < -500 && value < 0 && checkifrelatives(person,person2):
		value = value/1.5
	if value > 0 && (person.race.find('Otter') >= 0 || person2.race.find('Otter') >= 0):
		person.relations[person2.id] += value*1.5
	else:
		person.relations[person2.id] += value
	person.relations[person2.id] = clamp(person.relations[person2.id], -1000, 1000)
	person2.relations[person.id] = person.relations[person2.id]
	if person.relations[person2.id] < -200 && value < 0:
		person.stress += rand_range(4,8)
		person2.stress += rand_range(4,8)
	
static func count_sleepers():
	var your_bed = 0
	var personal_room = 0
	var jail = 0
	var farm = 0
	var communal = 0
	###---Added by Expansion---### Kennels Expanded
	var kennel = 0
	###---End Expansion---###		  
	var rval = {}
	for i in globals.slaves:
		if i.away.duration == 0 || i.away.at in ['rest','lab','in labor']:
			if i.sleep == 'personal':
				personal_room += 1
			elif i.sleep == 'your':
				your_bed += 1
			elif i.sleep == 'jail':
				jail += 1
			elif i.sleep == 'farm':
				farm += 1
			elif i.sleep == 'communal':
				communal += 1
			###---Added by Expansion---### Kennels Expanded | Added by Deviate
			elif i.sleep == 'kennel':
				kennel += 1
			###---End Expansion---###
	rval.personal = personal_room
	rval.your_bed = your_bed
	rval.jail = jail
	rval.farm = farm
	rval.communal = communal
	###---Added by Expansion---### Kennels Expanded | Added by Deviate
	rval.kennel = kennel
	###---End Expansion---###
	return rval

# race_unique : [penis_mod, cumprod]
var fatherRaceMods = {
	'bunny': [.3, 3],
	'cat': [.4, 4],
	'cow': [.6, 6],
	'dog': [.5, 5],
	'fox': [.4, 4],
	'horse': [.3, 6],
	'raccoon': [.4, 4],
	'hyena': [.6, 6],
	'mouse': [.3, 3],
	'squirrel': [.3, 3],
	'otter': [.4, 4],
	'bird': [.4, 4]
}
# size : penis_mod
var fatherSizeMods = {
	'micro': .1,
	'tiny': .2,
	'small': .3,
	'average': .4,
	'large': .5,
	'massive': .6,
}

###---Added by Expansion---### Pregnancy Expanded | Reworked by Deviate
func impregnation(mother, father = null, unique = ''):
	var penis_mod = .025
	var cumprod = 1
	var fertility = 100
	var virility = .5
	var father_id
	var father_unique
	if mother.preg.has_womb == false || mother.effects.has('contraceptive') || mother.race_type == 4:
		return
	elif father != null && (father.penis == 'none' || father.penis == null || father.effects.has('contraceptive')):
		return
	elif father != null && (father.race == 'Slime' || father.race_type == 4) && !mother.preg.unborn_baby.empty():
		slimeConversionCheck(mother, father)
#		expansion_slimebreeding.slimeConversionCheck(mother, father)
	else:
		if father != null:
			father_id = father.id if father.id != null else '-1'
			father_unique = father.unique
			var ref = fatherRaceMods.get(father_unique)
			if ref != null:
				penis_mod = ref[0]
				cumprod = ref[1]
			else:
				cumprod = father.pregexp.cumprod
				penis_mod = fatherSizeMods.get(father.penis, .025)
				
			if father.lastsexday == globals.resources.day:
				virility = rand_range(0.1,1) * father.pregexp.virility
			else:
				virility = rand_range(0.5,1.25) * father.pregexp.virility
			
			fertility += (father.preg.fertility + father.preg.bonus_fertility)
			
			if father.traits.has("Fertile"):
				fertility *= 1.5
			elif father.traits.has("Infertile"):
				fertility *= 0.5
		else:
			father_id = '-1'
			var ref = fatherRaceMods.get(unique)
			if ref != null:
				father_unique = unique
				penis_mod = ref[0]
				cumprod = ref[1]
			else:
				penis_mod = round(rand_range(1,6))
				penis_mod = penis_mod * .1
				cumprod = round(rand_range(1,7))
		virility = clamp(fertility * virility, 1, 100)
		cumprod *= penis_mod
		mother.preg.womb.append({id = father_id, unique = father_unique, semen = cumprod, virility = virility, day = 0,})

func connectrelatives(person1, person2, way):
	if person1 == null || person2 == null || person1.id == person2.id:
		return
	if !globals.state.relativesdata.has(person1.id):
		createrelativesdata(person1)
	if !globals.state.relativesdata.has(person2.id):
		createrelativesdata(person2)
	if way in ['mother','father']:
		var entry = globals.state.relativesdata[person1.id]
		for child in entry.children:
			connectrelatives(person2, globals.state.relativesdata[child], 'sibling')
		entry.children.append(person2.id)
		entry = globals.state.relativesdata[person2.id]
		entry[way] = person1.id
		if typeof(person1) != TYPE_DICTIONARY && typeof(person2) != TYPE_DICTIONARY:
			addrelations(person1, person2, 200)
	elif way == 'sibling':
		var entry = globals.state.relativesdata[person1.id]
		var entry2 = globals.state.relativesdata[person2.id]
		if str(entry.mother) == str(entry2.mother) && str(entry.father) == str(entry2.father):
			if !entry.siblings.has(entry2.id):
				entry.siblings.append(entry2.id)
			if !entry2.siblings.has(entry.id):
				entry2.siblings.append(entry.id)
		else:
			if !entry.halfsiblings.has(entry2.id):
				entry.halfsiblings.append(entry2.id)
			if !entry2.halfsiblings.has(entry.id):
				entry2.halfsiblings.append(entry.id)

func slavetooltip(person):
	var text = ''
	var node = main.get_node('slavetooltip')
	if node == null:
		return
	node.visible = true
	text += "Level: " + str(person.level)
	text += "\n[color=yellow]" + person.race.capitalize() + "[/color]\n" 
	description.person = person
	text += description.getbeauty(true).capitalize() + '\n' + person.age.capitalize()
	node.get_node("portrait").texture = loadimage(person.imageportait)
	node.get_node("portrait").visible = !node.get_node('portrait').texture == null
	node.get_node("name").text = person.name_long()
	if globals.player == person:
		node.get_node("name").set('custom_colors/font_color', Color(1,1,0))
		node.get_node("name").text = globals.state.defaultmasternoun + " " + node.get_node("name").text
	else:
		#Whims -- added custom colors
		node.get_node("name").set('custom_colors/font_color', ColorN(person.namecolor))
	if person != globals.player:
		node.get_node("spec").set_texture(specimages[str(person.spec)])
	node.get_node("grade").set_texture(gradeimages[person.origins])
	node.get_node("spec").visible = !globals.player == person
	node.get_node("grade").visible = !globals.player == person
	node.get_node("text").bbcode_text = text
	node.get_node("sex").texture = globals.sexicon[person.sex]
	###---Added by Expansion---###
	#---Movement Icons
	node.get_node("movement").set_texture(movementimages[str(expansion.getMovementIcon(person))])
	node.get_node("movement").visible = true
	if person.preg.duration > 0 && person.knowledge.has('currentpregnancy'):
		node.get_node("pregnancy").visible = true
	else:
		node.get_node("pregnancy").visible = false
	#---Jail Icons
	node.get_node("jailportrait").visible = (person.sleep == 'jail')
	###---End Expansion---###
	
	text = 'Traits: '
	if person.traits.size() > 0:
		text += "[color=aqua]"
		for i in person.traits:
			text += i + ', '
		text = text.substr(0, text.length() - 2) + '.[/color]'
	else:
		text += "None"
	
	node.get_node('traittext').bbcode_text = text
	
	var screen = get_viewport().get_visible_rect()
	var pos = main.get_global_mouse_position()
	pos = Vector2(pos.x+20, pos.y+20)
	node.set_position(pos)
	if node.get_rect().end.x >= screen.size.x:
		node.rect_global_position.x -= node.get_rect().end.x - screen.size.x
	if node.get_rect().end.y >= screen.size.y:
		node.rect_global_position.y -= node.get_rect().end.y - screen.size.y

var hairlengtharray = ['bald','ear','neck','shoulder','waist','hips']
var longtails = ['cat','fox','neko','hyena','wolf','demon','dragon','scruffy','snake tail','racoon','mouse','reptilian','otter','squirrel','avali',]
var skincovarray = ['none','scales','fullscales','fullfeathers','feathers','full_body_fur','plants']
var penistypearray = ['human','canine','feline','equine','reptilian','rodent','bird',]
var alltails = ['cat','fox','wolf','bunny','bird','demon','dragon','scruffy','snake tail','racoon','mouse','reptilian','squirrel','otter','avali',]
var allwings = ['feathered_black', 'feathered_white', 'feathered_brown', 'leather_black','leather_red','leather_green','leather_white','leather_blue','insect','gossamer']
var allears = ['human','feathery','pointy','frilled','none','short_furry','short_reptilian','long_pointy_furry','long_pointy_reptilian','fins','long_round_furry','long_droopy_furry','long_round_reptilian','long_droopy_reptilian','wide_furry','avali',]
var alleyecolors = ['blue', 'green', 'brown', 'hazel', 'black', 'gray', 'purple', 'yellow', 'amber', 'red', 'auburn']

###---Added by Expansion---### Kennels Expanded
var sleepdict = {communal = {name = 'Communal Room'}, jail = {name = "Jail"}, personal = {name = 'Personal Room'}, your = {name = "Your bed"}, kennel = {name = "Dog Kennel"}}

func save():
	state.spelllist.clear()
	state.itemlist.clear()
	var dict = {}
	for i in spelldict:
		if spelldict[i].learned == true:
			state.spelllist[i] = true
	for i in itemdict:
		if itemdict[i].amount > 0:
			state.itemlist[i] = {}
			state.itemlist[i].amount = itemdict[i].amount
	dict.resources = inst2dict(resources)
	dict.state = inst2dict(state)
	dict.state.currentversion = gameversion
	dict.guildslaves = {}
	for g in guildslaves:
		dict.guildslaves[g] = []
		for i in guildslaves[g]:
			dict.guildslaves[g].append(inst2dict(i))
	dict.slaves = []
	dict.babylist = []
	if globals.state.sebastianorder.taken == true:
		dict.sebastianslave = inst2dict(state.sebastianslave)
	for i in slaves:
		dict.slaves.append(inst2dict(i))
	for i in state.babylist:
		dict.babylist.append(inst2dict(i))
	###---Added by Expansion---### NPCs Expanded
	dict.allnpcs = []
	for i in state.allnpcs:
		dict.allnpcs.append(inst2dict(i))
	###---End Expansion---###
	dict.player = inst2dict(player) 
	return dict


func load_game(text):
	var savegame = File.new()
	var newslave
	if !savegame.file_exists(text):
		return #Error!  We don't have a save to load
	clearstate()
	var currentline = {} 
	savegame.open(text, File.READ)
	currentline = parse_json(savegame.get_as_text())
	ChangeScene("Mansion")
	#get_tree().change_scene("res://files/Mansion.scn")
	for i in currentline.values():
		if i.has("@path") && i['@path'] in ["res://globals.gdc",'res://globals.gdc']:
			i['@path'] = "res://globals.gd"
		if i.has("@path"):
			i['@path'] = i['@path'].replace('.gdc','.gd')
	if currentline.player["@path"] != 'res://files/scripts/person/person.gd':
		currentline.player['@path'] = 'res://files/scripts/person/person.gd'
		currentline.player["@subpath"] = ''
		for i in currentline.values():
			if typeof(i) == TYPE_DICTIONARY:
				if i.has('stats'):
					i['@path'] = 'res://files/scripts/person/person.gd'
					i['@subpath'] = ''
			elif typeof(i) == TYPE_ARRAY:
				for k in i:
					k['@path'] = 'res://files/scripts/person/person.gd'
					k['@subpath'] = ''
	if currentline.resources['@subpath'] == '':
		currentline.resources['@subpath'] = "resource"
		currentline.state['@subpath'] = 'progress'
	if currentline.resources['@path'] == "res://globals.gd":
		currentline.resources['@path'] = "res://files/globals.gd"
		currentline.state['@path'] = 'res://files/globals.gd'
		for i in currentline.values():
			if typeof(i) == TYPE_DICTIONARY:
				if i['@path'].find("res://globals.gd") >= 0:
					i['@path'] = i['@path'].replace("res://globals.gd", "res://files/globals.gd")
			
			if i.has('stats') && i.stats.has("str_cur"):
				i.stats.str_base = i.stats.str_cur
				i.stats.agi_base = i.stats.agi_cur
				i.stats.maf_base = i.stats.maf_cur
				i.stats.end_base = i.stats.end_cur
			elif typeof(i) == TYPE_ARRAY:
				for k in i:
					if k['@path'].find("res://globals.gd") >= 0:
						k['@path'] = k['@path'].replace("res://globals.gd", "res://files/globals.gd")
					if k.has('stats') && k.stats.has("str_cur"):
						k.stats.str_base = k.stats.str_cur
						k.stats.agi_base = k.stats.agi_cur
						k.stats.maf_base = k.stats.maf_cur
						k.stats.end_base = k.stats.end_cur
					if k.has('stats') && k.stats.obed_mod <= 0:
						k.stats.obed_mod = 1
	resources = dict2inst(currentline.resources)
	player = dict2inst(currentline.player)
	state = dict2inst(currentline.state)
	guildslaves = {wimborn = [], gorn = [], frostford = [], umbra = []}
	if currentline.has('guildslaves'):
		for g in currentline.guildslaves:
			for i in currentline.guildslaves[g]:
				guildslaves[g].append(dict2inst(i))
	var statetemp = progress.new()
	for i in statetemp.reputation:
		if state.ghostrep.has(i) == false:
			state.ghostrep[i] = statetemp.reputation[i]
		if state.reputation.has(i) == false:
			state.reputation[i] = statetemp.reputation[i]
	for i in state.itemlist:
		if itemdict.has(i):
			itemdict[i].amount = state.itemlist[i].amount
	for i in statetemp.sidequests:
		if state.sidequests.has(i) == false:
			state.sidequests[i] = statetemp.sidequests[i]
	for i in statetemp.tutorial:
		if state.tutorial.has(i) == false:
			state.tutorial[i] = statetemp.tutorial[i]
	state.itemlist = {}
	for i in state.spelllist:
		spelldict[i].learned = true
	state.spelllist = {}
	if globals.state.sebastianorder.taken == true:
		state.sebastianslave = dict2inst(currentline.sebastianslave)
	state.babylist.clear()
	for i in currentline.slaves:
		if i['@path'].find('.gdc') >= 0:
			i['@path'] = i['@path'].replace('.gdc', '.gd')
		newslave = dict2inst(i)
		if i.has('face'):
			newslave.beautybase = round(i.face.beauty)
		slaves.append(newslave)
	for i in currentline.babylist:
		if i['@path'].find('.gdc'):
			i['@path'] = i['@path'].replace('.gdc', '.gd')
		newslave = dict2inst(i)
		if i.has('face'):
			newslave.beautybase = round(i.face.beauty)
		state.babylist.append(newslave)
	###---Added by Expansion---### NPCs Expanded
	var expansion = globals.expansion
	var expansionsetup = globals.expansionsetup
	state.allnpcs.clear()
	for i in currentline.allnpcs:
		if typeof(i) == TYPE_STRING:
			continue
		if i['@path'].find('.gdc'):
			i['@path'] = i['@path'].replace('.gdc', '.gd')
		newslave = dict2inst(i)
		if i.has('face'):
			newslave.beautybase = round(i.face.beauty)
		state.allnpcs.append(newslave)
	if str(state.expansionversion) != str(expansionsettings.modversion):
		print("Mod Version v" + str(state.expansionversion) + ". Expanding game to latest Aric's Expansion version")
		expansionsetup.expandGame()
		print("Congratulations, your game is expanded. So, so expanded. Your door locked? Volume low? You hydrated? Party on!")
	print("Aric's Expansion v" + str(expansionsettings.modversion))
	if expansionsettings.use_ralphs_tweaks == true:
		print("Ralph's Tweaks Enabled. Product hybridization complete.")
	if expansionsettings.sillymode == true:
		print("Silly Mode Enabled. Fourth wall successfully removed.")
	if expansionsettings.enablecheatbutton == true:
		print("Aric's Cheat Button Active. Access via Talk > Piece of Candy")
	if expansionsettings.perfectinfo == true:
		print("Perfect Information is Enabled. All Inspect information is available without Talking to the NPC first.")
	if expansionsettings.ihavebloodygoodtaste == true:
		print("Bloody Good Taste is Enabled. For Queen and Country, good chap.")
	###---End Expansion---###
	savegame.close()
	if state.customcursor == null:
		Input.set_custom_mouse_cursor(null)
	else:
		state.customcursor = "res://files/buttons/kursor1.png"
	###---Added by Expansion---### Facilities Expanded
	if !state.mansionupgrades.has("farmmana"):
		state.mansionupgrades.farmmana = 0
	if !state.mansionupgrades.has("traininggrounds"):
		state.mansionupgrades['traininggrounds'] = 0
	###---End Expansion---###
	
	
	gameloaded = true
	if str(state.currentversion) != str(gameversion):
		print("Using old save, attempting repair")
		repairsave()

	var personList = slaves + state.babylist
	personList.append(player)
	for guild in globals.guildslaves.values():
		for person in guild:
			personList.append(person)
	if state.sebastianorder.taken:
		personList.append(state.sebastianslave)
	for person in personList:
		if person.imageportait == null: # try to add portrait if slave doesn't have one
			constructor.randomportrait(person)
		if typeof(person.sex) != TYPE_STRING || person.sex.empty():
			person.checksex()


func checkfurryrace(text):
	if text in ['Cat','Wolf','Fox','Bunny','Tanuki','Mouse','Squirrel','Otter','Bird']:
		if rules.furry == true:
			if rand_range(0,1) >= 0.5:
				text = 'Halfkin ' + text
			else:
				text = 'Beastkin ' + text
		else:
			text = 'Halfkin ' + text
	return text


###---Added by Expansion---### Only to load from Mods folder
var expansion = loadModFile("AricsExpansion", "customScripts/expansion.gd").new()
var expansionsetup = loadModFile("AricsExpansion", "customScripts/expansionsetup.gd").new()
var expansionfarm = loadModFile("AricsExpansion", "customScripts/expansionfarm.gd").new()
var expansiontalk = loadModFile("AricsExpansion", "customScripts/expansiontalk.gd").new()
var backwardscompatibility = loadModFile("AricsExpansion", "customScripts/backwardscompatibility.gd").new()
var expansionsettings = loadModFile("AricsExpansion", "customScripts/expansionsettings.gd").new()
var useRalphsTweaks # = expansionsettings.use_ralphs_tweaks
var useCapsTweaks # = expansionsettings.use_caps_tweaks
var expansiontravel = loadModFile("AricsExpansion", "customScripts/expansiontravel.gd").new() #ralphD
var ae_eventtext = loadModFile("AricsExpansion", "customScripts/expansioneventtext.gd").new()

###---Added by Expansion---### General Arrays
#Size Arrays
var titssizearray = ['masculine','flat','small','average','big','huge','incredible','massive','gigantic','monstrous','immobilizing']
var lipssizearray = ['masculine','thin','small','average','big','huge','plump','massive','monstrous','facepussy']
var asssizearray = ['masculine','flat','small','average','big','huge']
var vagsizearray = ['impenetrable','tiny','tight','average','loose','gaping']
var assholesizearray = ['impenetrable','tiny','tight','average','loose','gaping']
var penissizearray = ['micro','tiny','small','average','large','massive']
var heightarrayexp = ['tiny','petite','short','average','tall','towering']
var originsarrayexp = ['slave','poor','commoner','rich','atypical','noble']

#Sexuality Arrays
var kinseyscale = ['straight','mostlystraight','rarelygay','bi','rarelystraight','mostlygay','gay']

#All Current Fetishes
var fetishesarray = ['incest','lactation','drinkmilk','bemilked','milking','exhibitionism','drinkcum','wearcum','wearcumface','creampiemouth','creampiepussy','creampieass','pregnancy','oviposition','drinkpiss','wearpiss','pissing','otherspissing','bondage','dominance','submission','sadism','masochism','transformation']
var fetishopinion = ['taboo','dirty','unacceptable','uncertain','acceptable','enjoyable','mindblowing']

var restraintsarray = ['none','cuffed','shackled','fully','fullyexposed']

#Expanded Towns
var expandedtowns = ['wimborn','frostford','gorn','amberguard','shaliq','umbra']

var expandedplayerspecs = {
	Slaver = "+100% gold from selling captured slaves\n+33% gold reward from slave delivery tasks",
	Hunter = "+100% gold drop from random encounters\n+20% gear drop chance\nBonus to preventing ambushes",
	Alchemist = "Double potion production\nSelling potions earn +100% more gold\n[color=aqua]Start with an Alchemy Room unlocked[/color]",
	Mage = "-50% mana cost of spells\nCombat spell deal +20% more damage", # if useRalphsTweaks "Combat spell deal +20% more damage"
	Breeder = "Pregnancy chance for everyone increased by 25%\nHalved grow-up times for offspring\nBred Slaves sell for 60% more and receive 60% more upgrade points as normal slaves.\n[color=aqua]Start with the Nursery unlocked[/color]" # if useRalphsTweaks "Pregnancy chance for everyone increased by 25%\nHalved grow-up times for offspring\nBred Slaves sell for 20% more gold and provide 20% more upgrade points as normal slaves.\n[color=aqua]Start with the Nursery unlocked[/color]"
}

###---Added by Expansion---### Movement Icons (replicated)
var movementimages = {
	Null = null,
	man_crawl_clothed = load("res://files/aric_expansion_images/movement_icons/man_crawl_clothed.png"),
	man_fly_clothed = load("res://files/aric_expansion_images/movement_icons/man_fly_clothed.png"),
	man_lay_clothed = load("res://files/aric_expansion_images/movement_icons/man_lay_clothed.png"),
	man_walk_clothed = load("res://files/aric_expansion_images/movement_icons/man_walk_clothed.png"),
	man_crawl_naked = load("res://files/aric_expansion_images/movement_icons/man_crawl_naked.png"),
	man_fly_naked = load("res://files/aric_expansion_images/movement_icons/man_fly_naked.png"),
	man_lay_naked = load("res://files/aric_expansion_images/movement_icons/man_lay_naked.png"),
	man_walk_naked = load("res://files/aric_expansion_images/movement_icons/man_walk_naked.png"),
	woman_crawl_clothed = load("res://files/aric_expansion_images/movement_icons/woman_crawl_clothed.png"),
	woman_crawl_clothed_pregnant_1 = load("res://files/aric_expansion_images/movement_icons/woman_crawl_clothed_pregnant_1.png"),
	woman_crawl_clothed_pregnant_2 = load("res://files/aric_expansion_images/movement_icons/woman_crawl_clothed_pregnant_2.png"),
	woman_crawl_clothed_pregnant_3 = load("res://files/aric_expansion_images/movement_icons/woman_crawl_clothed_pregnant_3.png"),
	woman_fly_clothed = load("res://files/aric_expansion_images/movement_icons/woman_fly_clothed.png"),
	woman_fly_clothed_pregnant_1 = load("res://files/aric_expansion_images/movement_icons/woman_fly_clothed_pregnant_1.png"),
	woman_fly_clothed_pregnant_2 = load("res://files/aric_expansion_images/movement_icons/woman_fly_clothed_pregnant_2.png"),
	woman_fly_clothed_pregnant_3 = load("res://files/aric_expansion_images/movement_icons/woman_fly_clothed_pregnant_3.png"),
	woman_lay_clothed = load("res://files/aric_expansion_images/movement_icons/woman_lay_clothed.png"),
	woman_lay_clothed_pregnant_1 = load("res://files/aric_expansion_images/movement_icons/woman_lay_clothed_pregnant_1.png"),
	woman_lay_clothed_pregnant_2 = load("res://files/aric_expansion_images/movement_icons/woman_lay_clothed_pregnant_2.png"),
	woman_lay_clothed_pregnant_3 = load("res://files/aric_expansion_images/movement_icons/woman_lay_clothed_pregnant_3.png"),
	woman_walk_clothed = load("res://files/aric_expansion_images/movement_icons/woman_walk_clothed.png"),
	woman_walk_clothed_pregnant_1 = load("res://files/aric_expansion_images/movement_icons/woman_walk_clothed_pregnant_1.png"),
	woman_walk_clothed_pregnant_2 = load("res://files/aric_expansion_images/movement_icons/woman_walk_clothed_pregnant_2.png"),
	woman_walk_clothed_pregnant_3 = load("res://files/aric_expansion_images/movement_icons/woman_walk_clothed_pregnant_3.png"),
	woman_crawl_naked = load("res://files/aric_expansion_images/movement_icons/woman_crawl_naked.png"),
	woman_crawl_naked_pregnant_1 = load("res://files/aric_expansion_images/movement_icons/woman_crawl_naked_pregnant_1.png"),
	woman_crawl_naked_pregnant_2 = load("res://files/aric_expansion_images/movement_icons/woman_crawl_naked_pregnant_2.png"),
	woman_crawl_naked_pregnant_3 = load("res://files/aric_expansion_images/movement_icons/woman_crawl_naked_pregnant_3.png"),
	woman_fly_naked = load("res://files/aric_expansion_images/movement_icons/woman_fly_naked.png"),
	woman_fly_naked_pregnant_1 = load("res://files/aric_expansion_images/movement_icons/woman_fly_naked_pregnant_1.png"),
	woman_fly_naked_pregnant_2 = load("res://files/aric_expansion_images/movement_icons/woman_fly_naked_pregnant_2.png"),
	woman_fly_naked_pregnant_3 = load("res://files/aric_expansion_images/movement_icons/woman_fly_naked_pregnant_3.png"),
	woman_lay_naked = load("res://files/aric_expansion_images/movement_icons/woman_lay_naked.png"),
	woman_lay_naked_pregnant_1 = load("res://files/aric_expansion_images/movement_icons/woman_lay_naked_pregnant_1.png"),
	woman_lay_naked_pregnant_2 = load("res://files/aric_expansion_images/movement_icons/woman_lay_naked_pregnant_2.png"),
	woman_lay_naked_pregnant_3 = load("res://files/aric_expansion_images/movement_icons/woman_lay_naked_pregnant_3.png"),
	woman_walk_naked = load("res://files/aric_expansion_images/movement_icons/woman_walk_naked.png"),
	woman_walk_naked_pregnant_1 = load("res://files/aric_expansion_images/movement_icons/woman_walk_naked_pregnant_1.png"),
	woman_walk_naked_pregnant_2 = load("res://files/aric_expansion_images/movement_icons/woman_walk_naked_pregnant_2.png"),
	woman_walk_naked_pregnant_3 = load("res://files/aric_expansion_images/movement_icons/woman_walk_naked_pregnant_3.png"),
}

var sexuality_images = {
	Null = null,
	unknown = load("res://files/aric_expansion_images/sexuality_icons/sexuality_unknown.png"),
	base_male = load("res://files/aric_expansion_images/sexuality_icons/base_male.png"),
	base_female = load("res://files/aric_expansion_images/sexuality_icons/base_female.png"),
	base_futa = load("res://files/aric_expansion_images/sexuality_icons/base_futa.png"),
	male_1 = load("res://files/aric_expansion_images/sexuality_icons/male_1.png"),
	male_2 = load("res://files/aric_expansion_images/sexuality_icons/male_2.png"),
	male_3 = load("res://files/aric_expansion_images/sexuality_icons/male_3.png"),
	female_1 = load("res://files/aric_expansion_images/sexuality_icons/female_1.png"),
	female_2 = load("res://files/aric_expansion_images/sexuality_icons/female_2.png"),
	female_3 = load("res://files/aric_expansion_images/sexuality_icons/female_3.png"),
	futa_1 = load("res://files/aric_expansion_images/sexuality_icons/futa_1.png"),
	futa_2 = load("res://files/aric_expansion_images/sexuality_icons/futa_2.png"),
	futa_3 = load("res://files/aric_expansion_images/sexuality_icons/futa_3.png"),
}

var dimcrystal_images = {
	Null = null,
	dull = load("res://files/aric_expansion_images/dimensional_crystal/dimcrystal_dull.png"),
	light1 = load("res://files/aric_expansion_images/dimensional_crystal/dimcrystal_light_1.png"),
	light2 = load("res://files/aric_expansion_images/dimensional_crystal/dimcrystal_light_2.png"),
	light3 = load("res://files/aric_expansion_images/dimensional_crystal/dimcrystal_light_3.png"),
	dark1 = load("res://files/aric_expansion_images/dimensional_crystal/dimcrystal_dark_1.png"),
	dark2 = load("res://files/aric_expansion_images/dimensional_crystal/dimcrystal_dark_2.png"),
	dark3 = load("res://files/aric_expansion_images/dimensional_crystal/dimcrystal_dark_3.png"),
}

<AddTo 0>
func _ready():
	expansionsettings.addConstantsSupport()
	constructor.fillSizeArrayDict()

###---Added by Expansion---### Farm Expanded
func getVatMaxCapacity(type):
	var vatmax = 0
	if globals.state.mansionupgrades[type] == 0:
		vatmax = 0
	elif globals.state.mansionupgrades[type] == 1:
		vatmax = 100
	elif globals.state.mansionupgrades[type] == 2:
		vatmax = 250
	elif globals.state.mansionupgrades[type] >= 3:
		vatmax = 500
	return vatmax

func semen_volume(semen):
	var rvar
	var volume = semen * 10
	
	if int(volume) < 1000:
		rvar = str(int(volume)) + " mL"
	else:
		volume = volume / 1000
		rvar = str(round(volume * pow(10.0, 1)) / pow(10.0, 1)) + " L"
	
	traceFile('Semen Volume')
	return rvar


func fertilize_egg(mother, father_id, father_unique):
	var expansion = globals.expansion
	var expansionsetup = globals.expansionsetup
	var father
	var baby
	
	###Get/Build Father
	if father_id != null && father_id != '-1' && !father_unique in ['','dog','horse']:
		father = globals.state.findslave(father_id)
		#If Father disappeared from the World
		if father == null:
			father = globals.newslave('randomany', 'adult', 'male')
	else:
		father = globals.newslave('randomany', 'adult', 'male')
		father.id = '-1'
		
		if father_unique != null:
			father.unique = father_unique
		
		constructor.clearGenealogies(father)
		if father_unique == 'bunny':
			father.genealogy.bunny = 100
			father.race = 'Beastkin Bunny'
		elif father_unique == 'dog':
			father.genealogy.dog = 100
			father.race = 'Beastkin Wolf'
		elif father_unique == 'hyena':
			father.genealogy.hyena = 100
			father.race = 'Gnoll'
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
		elif father_unique == 'mouse':
			father.genealogy.mouse = 100
			father.race = 'Beastkin Mouse'
		elif father_unique == 'squirrel':
			father.genealogy.squirrel = 100
			father.race = 'Beastkin Squirrel'
		elif father_unique == 'otter':
			father.genealogy.otter = 100
			father.race = 'Beastkin Otter'
		elif father_unique == 'bird':
			father.genealogy.bird = 100
			father.race = 'Beastkin Bird'
		else:
			father.race = getracebygroup("starting")
			constructor.set_genealogy(father)
	
	#Consent/Wanted Pregnancy Check
	if father.id == player.id:
		mother.pregexp.wantedpregnancy = mother.consentexp.pregnancy
	else:
		mother.pregexp.wantedpregnancy = mother.consentexp['breeder' if expansion.relatedCheck(mother,father) == "unrelated" else 'incestbreeder']

	baby = constructor.newbaby(mother, father)

	if baby.id != null:
		baby.state == 'fetus'
		mother.preg.is_preg = true
		mother.preg.duration = 0
		mother.preg.baby = -1
		mother.preg.unborn_baby.append({id = baby.id})
		mother.preg.ovulation_stage = 0
		mother.preg.ovulation_day = 0
	
	traceFile('fertilize egg')

func miscarriage(person):
	var miscarried = false
	for i in person.preg.unborn_baby:
		if miscarried == false:
			globals.state.findbaby(i.id).death()
			person.preg.unborn_baby.erase(i)
			#baby.state = 'dead'
			miscarried = true
		
	if person.preg.unborn_baby.empty():
		person.preg.is_preg = false
		person.preg.duration = 0
		person.preg.baby = null
	#traceFile('miscarriage')


#Slime Conversion (Move to Expansion_slimebreeding after Split option)
func slimeConversionCheck(mother, father):
	var text = ""
	var baby
	var strongestgenes = 0
	if father == null:
		return
	
	var conversionstrength = father.level*(1+(resources.day - father.lastsexday))
	var rapidpregnancydamage = 0
	
	for i in mother.preg.unborn_baby:
		baby = globals.state.findslave(i.id)
		if baby == null:
			break
		#Find "Purest" Genes
		for genes in baby.genealogy:
			if baby.genealogy[genes] > 0:
				strongestgenes = baby.genealogy[genes]
		
		if rand_range(0,100) + conversionstrength > strongestgenes:
			#ralph
			expansionsetup.setRaceBonus(baby, false)
			baby.race = 'Slime'
			baby.race_type == 4
			#/ralph
			for genes in baby.genealogy:
				if genes != 'slime' && baby.genealogy[genes] > 0:
					baby.genealogy[genes] = 0
				elif genes == 'slime':
					baby.genealogy[genes] = 100
			expansionsetup.setRaceBonus(baby, true)
			if father.id != '-1' && father.id != null:
				globals.connectrelatives(father, baby, 'slimesire')
			
			rapidpregnancydamage = (globals.state.pregduration-1) - person.preg.duration
			person.preg.duration = globals.state.pregduration-1
			mother.stress += rapidpregnancydamage*2
			mother.health -= rapidpregnancydamage
			text += mother.dictionary("$name felt a shift in $his body from the slimey goo inside of $him. $His baby, " + baby.dictionary("$name ") + mother.dictionary(", has been warped into a Slime and is about to ooze out of $him. Health -"+str(rapidpregnancydamage)+" / Stress +"+str(rapidpregnancydamage*2)))
	
	if get_tree().get_current_scene().has_node("infotext") && globals.slaves.find(mother) >= 0 && mother.away.at != 'hidden':
		get_tree().get_current_scene().infotext(text,'red')

###---Added by Expansion---### General Usage
#I can't remember if I added this or found it elsewhere. Sorry if I didn't!
func randomitemfromarray(array):
	if array.empty():
		print("ERROR: randomitemfromarray() empty")
		return null
	else:
		return array[randi() % array.size()]

func randomfromarray(array):
	if array.empty():
		print("ERROR: randomfromarray() empty")
		return null
	else:
		return array[randi() % array.size()]

func getfromarray(array, index):
	return array[ clamp(index, 0, array.size()-1) ]

# selects an item matching the given value in the given option button node
# useMetaData can be an array or a boolean
#	array - find value in array to determine index
#	true - find value in node item metadata
#	false - find value in node item text
# returns true if an item matching value is found and selected, else false
func selectForOptionButton(value, node, useMetadata = false):
	if typeof(useMetadata) == TYPE_ARRAY:
		var temp = useMetadata.find(value)
		if temp >= 0 && temp < node.get_item_count():
			node.select(temp)
			return true
	elif useMetadata:
		for i in range(node.get_item_count()):
			if node.get_item_(i) == value:
				node.select(i)
				return true
	else:
		for i in range(node.get_item_count()):
			if node.get_item_text(i) == value:
				node.select(i)
				return true
	node.select(0)
	return false