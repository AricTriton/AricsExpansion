

extends Node

var guildslaves = {wimborn = [], gorn = [], frostford = [], umbra = []}
var gameversion = '1.0d'
var state = progress.new()
var developmode = false
var gameloaded = false

var mainscreen = 'mainmenu'

var gameDir = "res://"
var fileDir = "res://files/"
var backupDir = "res://backup/"
#for those that want to move appData to program folder, swap next two lines
#var appDataDir = "res://appData/"
var appDataDir = "user://"
var saveDirDefault = appDataDir + "saves/"
# saveDir is the current path which is created by modpanel.gd using saveDirDefault and saveID
var saveDir = saveDirDefault
var settingsFile = appDataDir + "settings.ini"
var progressFile = appDataDir + "progressdata"

var backupExtensions = ['gd','tscn','scn']
var imageExtensions = ["png","jpg","webp"]

var rules = {
	futa = true,
	futaballs = false,
	furry = true,
	furrynipples = true,
	dickgirl = true,
	male_chance = 15,
	futa_chance = 10,
	dickgirl_chance = 5,
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

var gallery = load("res://files/scripts/gallery.gd").new()
var characters = gallery
var charactergallery = gallery.charactergallery setget savechars
var savelist = {}
var setfolders = loadsettings() setget savefolders
var modfolder = setfolders.mods

var logModErrors = PoolStringArray() # holds errors that occur when creating modDict as modpanel has not loaded yet
var modDict = createModDict() # dyanamic pathing for mods, format = {'modRootName' : 'pathToRoot'}, also see the functions: createModDict, getPathModFile, loadModFile, loadModImage

var resources = resource.new()
var person = load("res://files/scripts/person/person.gd")
var assets = load("res://files/scripts/assets.gd").new()
var constructor = load("res://files/scripts/characters/constructor.gd").new()
var origins = load("res://files/scripts/origins.gd").new()
var description = load("res://files/scripts/characters/description.gd").new()
var dictionary = load("res://files/scripts/dictionary.gd").new()
var racefile = load("res://files/scripts/characters/races.gd").new()
var races = racefile.races
var names = racefile.names
var questtext = load("res://files/scripts/questtext.gd").new()
var sexscenes = load("res://files/scripts/sexscenes.gd").new()
var glossary = load("res://files/scripts/glossary.gd").new()
var repeatables = load("res://files/scripts/repeatable_quests.gd").new()
var abilities = load("res://files/scripts/abilities.gd").new()
var effects = load("res://files/scripts/effects.gd").new()
var effectdict = effects.effectlist
onready var events = load("res://files/scripts/events.gd").new()
var items = load("res://files/scripts/items.gd").new()
var itemdict = items.itemlist
onready var spells = load("res://files/scripts/spells.gd").new()
onready var spelldict = spells.spelllist
var dailyevents = load("res://files/scripts/dailyevents.gd").new()
var jobs = load("res://files/scripts/jobs&specs.gd").new()
var mansionupgrades = load("res://files/scripts/mansionupgrades.gd").new()
var mansionupgradesdict = mansionupgrades.dict

var patronlist = load("res://files/scripts/patronlists.gd").new()
var areas = load('res://files/scripts/explorationregions.gd').new()
var combatdata = load("res://files/scripts/combatdata.gd").new()

#var slavegen = load("res://files/scripts/slavegen.gd").new()
#var slavedialogues = load("res://files/scripts/slavedialogues.gd").new()

#QMod - Variables
#var mainQuestTexts = events.mainquestTexts
#var sideQuestTexts = events.sidequestTexts
var places = {
	anywhere = {region = 'any', area = 'any', location = 'any'},
	nowhere = {region = 'none', area = 'none', location = 'none'},
	wimborn = {region = 'wimborn', area = 'any', location = 'any'},
	gorn = {region = 'gorn', area = 'any', location = 'any'},
	frostford = {region = 'frostford', area = 'any', location = 'any'}
}
var main

var slaves = [] setget slaves_set
var allracesarray = []
var specarray = ['geisha','ranger','executor','bodyguard','assassin','housekeeper','trapper','nympho','merchant','tamer']
var player
var partner

var spritedict = gallery.sprites
var backgrounds = gallery.backgrounds
var scenes = gallery.scenes
var musicdict = {
	combat1 = load("res://files/music/battle1.ogg"),
	combat2 = load("res://files/music/battle2.ogg"),
	combat3 = load("res://files/music/battle3.ogg"),
	mansion1 = load("res://files/music/mansion1.ogg"),
	mansion2 = load("res://files/music/mansion2.ogg"),
	mansion3 = load("res://files/music/mansion3.ogg"),
	mansion4 = load("res://files/music/mansion4.ogg"),
	wimborn = load("res://files/music/wimborn.ogg"),
	gorn = load("res://files/music/gorn.ogg"),
	frostford = load("res://files/music/frostford.ogg"),
	explore = load("res://files/music/exploration.ogg"),
	maintheme = load("res://files/music/opening.ogg"),
	ending = load("res://files/music/ending.ogg"),
	dungeon = load("res://files/music/dungeon.ogg"),
	intimate = load("res://files/music/intimate.ogg"),
}
var sounddict = {
	door = load("res://files/sounds/door.wav"),
	stab = load("res://files/sounds/stab.wav"),
	win = load("res://files/sounds/win.wav"),
	teleport = load("res://files/sounds/teleport.wav"),
	fall = load("res://files/sounds/fall.wav"),
	page = load("res://files/sounds/page.wav"),
	attack = load("res://files/sounds/normalattack.wav"),
}
###---Added by Expansion---###
var gradeimages = {
	"slave" : load("res://files/buttons/mainscreen/40.png"),
	poor = load("res://files/buttons/mainscreen/41.png"),
	commoner = load("res://files/buttons/mainscreen/42.png"),
	rich = load("res://files/buttons/mainscreen/43.png"),
	atypical = load("res://files/buttons/mainscreen/40.png"),
	noble = load("res://files/buttons/mainscreen/44.png"),
}
###---End Expansion---###
				 
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
}

###---Added by Expansion---### Movement Icons
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
###---End Expansion---###

###---Added by Expansion---### centerflag982 - added dickgirl icon
var sexicon = {
female = load("res://files/buttons/sexicons/female.png"),
male = load("res://files/buttons/sexicons/male.png"),
futanari = load("res://files/buttons/sexicons/futa.png"),
dickgirl = load("res://files/buttons/sexicons/dickgirl.png"),
}
###---End Expansion---###									

#var combatencounterdata = explorationscrips.enemygroup

var noimage = load("res://files/buttons/noimagesmall.png")

var punishcategories = ['spanking','whipping','nippleclap','clitclap','nosehook','mashshow','facesit','afacesit','grovel']

var playerspecs = {
	Slaver = "+100% gold from selling captured slaves\n+33% gold reward from slave delivery tasks",
	Hunter = "+100% gold drop from random encounters\n+20% gear drop chance\nBonus to preventing ambushes",
	Alchemist = "Start with an alchemy room\nDouble potion production\nSelling potions earn 100% more gold",
	Mage = "-50% mana cost of spells\nCombat spell deal 20% more damage",
}

func _init():
	if OS.get_executable_path() == 'C:\\Users\\1\\Desktop\\godot\\Godot_v3.0.4-stable_win64.exe':
		developmode = true
	randomize()
	if rules.fullscreen == true:
		OS.set_window_fullscreen(true)
	
	for i in races:
		allracesarray.append(i)
		if i.find("Beastkin") >= 0:
			allracesarray.append(i.replace("Beastkin", "Halfkin"))
	
#	if variables.oldemily == true:
#		for i in ["emilyhappy", "emilynormal","emily2normal","emily2happy","emily2worried","emilynakedhappy","emilynakedneutral"]:
#			spritedict[i] = spritedict['old'+ i]
#		characters.characters.Emily.imageportait = "res://files/images/emily/oldemilyportrait.png"


func _ready():
	var temp


# makes a dictionary of all modRootNames and their paths in the modfolder, then removes the duplicate mods, and ensures that all root mod folders have info.txt
func createModDict():
	var dir = Directory.new()
	var retCode
	var arrayDir = scanModFolder()
	var tempModDict = {}
	var idx = 0
	while idx < arrayDir.size():
		var path = arrayDir[idx]
		var arraySubDir = []
		retCode = dir.open(path)
		if retCode != OK:
			printErrorCode("Opening mod directory " + str(modfolder), retCode)
			continue
		retCode = dir.list_dir_begin(true)
		if retCode != OK:
			handleModError("Scanning mod directory " + str(modfolder), retCode)
			continue
		var file_name = dir.get_next()
		while file_name != '':
			var isMod = false
			if file_name == null:
				continue
			if dir.current_is_dir():
				if file_name in ['scripts','patch']:
					isMod = true
				else:
					arraySubDir.append( path.plus_file(file_name) )
			elif file_name == 'info.txt' || file_name.get_extension() in backupExtensions:
				isMod = true
			if isMod:
				arraySubDir.clear()
				var temp = path.right(path.find_last('/')+1)
				if tempModDict.has(temp):
					tempModDict[temp].append(path)
				else:
					tempModDict[temp] = [path]
				break
			file_name = dir.get_next()
		for childPath in arraySubDir:
			arrayDir.append(childPath)
		idx += 1
	removeDupMods(tempModDict)
	createModInfo(tempModDict)
	return tempModDict

# makes an array of all folders in modfolder
func scanModFolder():
	var dir = Directory.new()
	var retCode
	var array = []
	if !dir.dir_exists(modfolder):
		retCode = dir.make_dir(modfolder)
		handleModError("Making mod directory " + str(modfolder), retCode)
		return array
	retCode = dir.open(modfolder)
	if retCode != OK:
		handleModError("Opening mod directory " + str(modfolder), retCode)
		return array
	retCode = dir.list_dir_begin(true)
	if retCode != OK:
		handleModError("Scanning mod directory " + str(modfolder), retCode)
		return array
	var file_name = dir.get_next()
	while file_name != "":
		if dir.current_is_dir() && file_name != null:
			array.append(modfolder + file_name)
		file_name = dir.get_next()
	return array

func removeDupMods(refModDict):
	for rootName in refModDict:
		if refModDict[rootName].size() > 1:
			var minLevels = 999
			var pathMin
			var text = "Warning: Found more than one mod with the same root name: "
			for path in refModDict[rootName]:
				var temp = path.split('/', false).size()
				if temp < minLevels || (temp == minLevels && path < pathMin):
					minLevels = temp
					pathMin = path
				text += "\n     " + path
			refModDict[rootName] = pathMin
			print(text)
			traceFile(text)
		else:
			refModDict[rootName] = refModDict[rootName][0]

# create default info.txt if mods don't have one
func createModInfo(refModDict):
	var file = File.new()
	var retCode
	for path in refModDict.values():
		if !file.file_exists(path +'/info.txt'):
			retCode = file.open(path +'/info.txt', File.WRITE)
			if retCode == OK:
				file.store_line("There's no information on this mod.")
				file.close()
			else:
				handleModError("Creating default info.txt for " + path, retCode)

func handleModError(msg, code):
	if code != OK:
		logModErrors.append("ERROR: " + msg + " (" + errorText[code] + ")")
		printErrorCode(msg, code)


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

func savechars(value):
	gallery.charactergallery = value

func savefolders(value):
	overwritesettings()

func overwritesettings():
	var file = File.new()
	var retCode = file.open(settingsFile, File.WRITE)
	if retCode == OK:
		file.store_line(var2str(rules))
		file.close()
	else:
		printErrorCode("Writing file " + settingsFile, retCode)
	retCode = file.open_encrypted_with_pass(progressFile, File.WRITE, 'tehpass')
	if retCode == OK:
		var data = {chars = charactergallery, folders = setfolders, savelist = savelist}
		file.store_var(data)
		file.close()
	else:
		printErrorCode("Writing file " + progressFile, retCode)

func clearstate():
	state = progress.new()
	slaves.clear()
	events = load("res://files/scripts/events.gd").new()
	items = load("res://files/scripts/items.gd").new()
	itemdict = items.itemlist
	spells = load("res://files/scripts/spells.gd").new()
	spelldict = spells.spelllist
	resources.reset()

func newslave(race, age, sex, origins = 'slave'):
	return constructor.newslave(race, age, sex, origins)

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

func canloadimage(path):
	if path == null || typeof(path) == TYPE_OBJECT:
		return path != null
	if ResourceLoader.exists(path):
		return load(path) != null
	if !File.new().file_exists(path):
		return false
	if Image.new().load(path) != OK:
		return false
	return true

var showLoadImageNotFound = true  # change to false to hide errors when image files are not found
func loadimage(path):
	#var file = File.new()
	if path == null || typeof(path) == TYPE_OBJECT:
		return path
	if ResourceLoader.exists(path):
		return load(path)
	if !File.new().file_exists(path):
		if showLoadImageNotFound:
			printErrorCode("loadimage("+str(path)+")", ERR_FILE_NOT_FOUND)
		return null
	var image = Image.new()
	var retVal = image.load(path)
	if retVal != OK:
		printErrorCode("loadimage("+str(path)+")", retVal)
		return null
	var temptexture = ImageTexture.new()
	temptexture.create_from_image(image)
	return temptexture


# convenience function for getting the path for single mod files using the dynamic path system
# modRootName is the name of the folder containing info.txt
# subpath is the path from the folder named modRootName to the mod file
func getPathModFile(modRootName, subpath):
	if modDict.has(modRootName):
		return modDict[modRootName].plus_file(subpath)
	else:
		printErrorCode("getPathModFile("+str(modRootName)+", "+str(subpath)+")", ERR_INVALID_PARAMETER)
		return null

# convenience function for loading single mod files using the dynamic path system, see getPathModFile for args.
# only loads script, scene, or import files
func loadModFile(modRootName, subpath):
	if modDict.has(modRootName):
		return load( modDict[modRootName].plus_file(subpath) )
	else:
		printErrorCode("loadModFile("+str(modRootName)+", "+str(subpath)+")", ERR_INVALID_PARAMETER)
		return null

# convenience function for loading single mod files using the dynamic path system, see getPathModFile for args.
# only intended for image files
func loadModImage(modRootName, subpath):
	if modDict.has(modRootName):
		return loadimage( modDict[modRootName].plus_file(subpath) )
	else:
		printErrorCode("loadModImage("+str(modRootName)+", "+str(subpath)+")", ERR_INVALID_PARAMETER)
		return null


func slavecount():
	var number = 0
	for i in slaves:
		if i.away.at != 'hidden':
			number += 1
	return number


var scenedict = {
	#Mansion = 'res://files/Mansion.scn',
	Mansion = 'res://files/Mansion.tscn',
}

var CurrentScene

func ChangeScene(name):
	var loadscreen = load("res://files/LoadScreen.tscn").instance()
	get_tree().get_root().add_child(loadscreen)
	loadscreen.goto_scene(scenedict[name])


class resource:
	var day = 1 setget day_set
	var gold = 0 setget gold_set
	var mana = 0 setget mana_set
	var energy = 0 setget energy_set
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
	farminventory = {prods = 0},
	vats = {
	processingorder = ['milk','semen','lube','piss'],
	milk = {vat = 0, new = 0, sell = 0, food = 0, refine = 0, bottle2sell = 0, bottle2refine = 0, priceper = 0, foodper = 0, auto = 'vat', autobuybottles = false, basebottlingenergy = 5,},
	semen = {vat = 0, new = 0, sell = 0, food = 0, refine = 0, bottle2sell = 0, bottle2refine = 0, priceper = 0, foodper = 0, auto = 'vat', autobuybottles = false, basebottlingenergy = 6},
	lube = {vat = 0, new = 0, sell = 0, food = 0, refine = 0, bottle2sell = 0, bottle2refine = 0, priceper = 0, foodper = 0, auto = 'vat', autobuybottles = false, basebottlingenergy = 6},
	piss = {vat = 0, new = 0, sell = 0, food = 0, refine = 0, bottle2sell = 0, bottle2refine = 0, priceper = 0, foodper = 0, auto = 'vat', autobuybottles = false, basebottlingenergy = 7},
	},
	snails = {eggs = 0, auto = 'none', neweggs = 0, food = 0, sell = 0, hatch = 0, cookwithoutchef = false, foodperchef = 3, goldperegg = 25, goldpersnail = 250},
	incubators = {
	1: {name = "Incubator 1", level = 0, filled = false, growth = 0},
	2: {name = "Incubator 2", level = 0, filled = false, growth = 0},
	3: {name = "Incubator 3", level = 0, filled = false, growth = 0},
	4: {name = "Incubator 4", level = 0, filled = false, growth = 0},
	5: {name = "Incubator 5", level = 0, filled = false, growth = 0},
	6: {name = "Incubator 6", level = 0, filled = false, growth = 0},
	7: {name = "Incubator 7", level = 0, filled = false, growth = 0},
	8: {name = "Incubator 8", level = 0, filled = false, growth = 0},
	9: {name = "Incubator 9", level = 0, filled = false, growth = 0},
	10: {name = "Incubator 10", level = 0, filled = false, growth = 0},
	basecost = 200,
	upgrademultiplier = 2.5,
	upgrademax = 10,
	},
	bottler = {level = 0, totalproduced = 0},
	}
	###---Expansion End---### 
	
	var foodcaparray = [500, 750, 1000, 1500, 2000, 3000]
	
	func update():
		for i in array:
			#self[i] += 0
			set(i, get(i))
	
	func reset():
		day = 1
		gold = 0
		mana = 0
		energy = 0
		food = 0
		###---Added by Expansion---### Farm Expanded
		milk = 0
		semen = 0
		lube = 0
		piss = 0
		###---Expansion End---###
	
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

var portalnames = {wimborn = 'Wimborn', gorn = 'Gorn', frostford = 'Frostford', umbra = 'Umbra',amberguard = 'Amberguard', dragonnests = 'Dragon Nests'}

class progress:
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
	var sidequests = {startslave = 0, emily = 0, brothel = 0, cali = 0, caliparentsdead = false, chloe = 0, ayda = 0, ivran = '', yris = 0, zoe = 0, ayneris = 0, sebastianumbra = 0, maple = 0} setget quest_set
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
	###---End Expansion---###
	var dailyeventcountdown = 0
	var dailyeventprevious = 0
	var currentversion = 5000
	var unstackables = {}
	var supplykeep = 10
	var foodbuy = 200
	var supplybuy = false
	var tutorial = {basics = false, person = false, alchemy = false, jail = false, lab = false, farm = false, outside = false, combat = false, interactions = false}
	var itemcounter = 0
	var slavecounter = 0
	var alisecloth = 'normal'
	var decisions = []
	var lorefound = []
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
		milkvalue = 10,
		milkinterest = 5,
		acceptablemilk = ['Taurus'],
		pendingexecution = [],
		currentevents = [],
		dailyreport = {text = "", shopping = 0, crimeattempted = 0, crimeprevented = 0, crimesucceeded = 0},
		},
	shaliq = {
		localnpcs = {leader = -1, nobles = [], guards = [], commoners = [], whores = [], beggers = []},
		gold = 3000,
		guardskill = 5,
		slavery = 40,
		prostitution = 10,
		nudity = 30,
		wearcum = 10,
		milkvalue = 10,
		milkinterest = 5,
		acceptablemilk = ['Taurus'],
		pendingexecution = [],
		currentevents = [],
		dailyreport = {text = "", shopping = 0, crimeattempted = 0, crimeprevented = 0, crimesucceeded = 0}
		},
	frostford = {
		localnpcs = {leader = -1, nobles = [], guards = [], commoners = [], whores = [], beggers = []},
		gold = 10000,
		guardskill = 5,
		slavery = 25,
		prostitution = 10,
		nudity = 80,
		wearcum = 20,
		milkvalue = 10,
		milkinterest = 5,
		acceptablemilk = ['Taurus','Wolf','Cat','Bunny'],
		pendingexecution = [],
		currentevents = [],
		dailyreport = {text = "", shopping = 0, crimeattempted = 0, crimeprevented = 0, crimesucceeded = 0}
		},
	gorn = {
		localnpcs = {leader = -1, nobles = [], guards = [], commoners = [], whores = [], beggers = []},
		gold = 10000,
		guardskill = 30,
		slavery = 85,
		prostitution = 20,
		nudity = 60,
		wearcum = 30,
		milkvalue = 10,
		milkinterest = 5,
		acceptablemilk = ['Taurus'],
		pendingexecution = [],
		currentevents = [],
		dailyreport = {text = "", shopping = 0, crimeattempted = 0, crimeprevented = 0, crimesucceeded = 0}
		},
	umbra = {
		localnpcs = {leader = -1, nobles = [], guards = [], commoners = [], whores = [], beggers = []},
		gold = 15000,
		guardskill = 40,
		slavery = 100,
		prostitution = 100,
		nudity = 90,
		wearcum = 75,
		milkvalue = 15,
		milkinterest = 5,
		acceptablemilk = ['Taurus'],
		pendingexecution = [],
		currentevents = [],
		dailyreport = {text = "", shopping = 0, crimeattempted = 0, crimeprevented = 0, crimesucceeded = 0}
		},
	amberguard = {
		localnpcs = {leader = -1, nobles = [], guards = [], commoners = [], whores = [], beggers = []},
		gold = 10000,
		guardskill = 35,
		slavery = 25,
		prostitution = 15,
		nudity = 10,
		wearcum = 5,
		milkvalue = 10,
		milkinterest = 5,
		acceptablemilk = ['Taurus'],
		pendingexecution = [],
		currentevents = [],
		dailyreport = {text = "", shopping = 0, crimeattempted = 0, crimeprevented = 0, crimesucceeded = 0}
		}
	}
	#Tracks and Saves created Hybrid Races
	var hybridraces = {}
	#Debug/Cheat Change Before Release to "Unlockable"
	var perfectinfo = true
	#Crystal Prevent's Death
	var thecrystal = {mode = 'light', research = 0, abilities = [], power = 0, lifeforce = 10, hunger = 0, preventsdeath = false}
	#Milk Economy / globals.state.milkeconomy.currentvalue
	var milkeconomy = {currentvalue = 1, futurevalue = 1}
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
		var rval
		###---Added by Expansion---### Category: NPCs Expanded | Search Baddies if not in Slaves
		var foundslave = false
		if str(globals.player.id) == str(id):
			return globals.player
		for i in range(0, globals.slaves.size()):
			if str(globals.slaves[i].id) == str(id):
				rval = globals.slaves[i]
				foundslave = true
		if foundslave == false:
			rval = findnpc(id)
		###---End Expansion---###
		if str(globals.player.id) == str(id):
			return globals.player
		for i in range(0, globals.slaves.size()):
			if str(globals.slaves[i].id) == str(id):
				rval = globals.slaves[i]
		return rval

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
		var rval
		var foundslave = false
		if !allnpcs.empty():
			for npc in allnpcs:
				if npc.id != null:
					if str(npc.id) == str(newid):
						rval = npc
						foundslave = true
			#How findslave does it
#			for i in range(0, globals.state.allnpcs.size()):
#				if str(globals.state.allnpcs[i].id) == str(id):
#					rval = globals.state.allnpcs[i]
#					foundslave = true
#		if foundslave == false:
#			rval = findslave(newid)
		return rval
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
	###---Added by Expansion---### Ank BugFix v1d
	if person == null || person2 == null:
		return
	###---End Expansion---###
	if person.relations.has(person2.id) == false:
		person.relations[person2.id] = 0
	if person2.relations.has(person.id) == false:
		person2.relations[person.id] = 0
	if person.relations[person2.id] > 500 && value > 0 && checkifrelatives(person, person2):
		value = value/1.5
	elif person.relations[person2.id] < -500 && value < 0 && checkifrelatives(person,person2):
		value = value/1.5
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
			if father.id != null:
				father_id = father.id
			else:
				father_id = '-1'
			father_unique = father.unique
			if father.unique == 'bunny':
				penis_mod = .3
				cumprod = 3
			elif father.unique == 'cat':
				penis_mod = .4
				cumprod = 4
			elif father.unique == 'cow':
				penis_mod = .6
				cumprod = 6
			elif father.unique == 'dog':
				penis_mod = .5
				cumprod = 5
			elif father.unique == 'fox':
				penis_mod = .4
				cumprod = 4
			elif father.unique == 'horse':
				penis_mod = .3
				cumprod = 6
			elif father.unique == 'raccoon':
				penis_mod = .4
				cumprod = 4
			else:
				cumprod = father.pregexp.cumprod
				
				if father.lastsexday == globals.resources.day:
					virility = rand_range(0.1,1)
				else:
					virility = rand_range(0.5,1.25)
				
				fertility += (father.preg.fertility + father.preg.bonus_fertility)
				
				if father.traits.has("Fertile"):
					fertility = fertility * 1.5
				elif father.traits.has("Infertile"):
					fertility = fertility * 0.5
				
				if father.penis == 'micro':
					penis_mod = .1
				elif father.penis == 'tiny':
					penis_mod = .2
				elif father.penis == 'small':
					penis_mod = .3
				elif father.penis == 'average':
					penis_mod = .4
				elif father.penis == 'large':
					penis_mod = .5
				elif father.penis == 'massive':
					penis_mod = .6
		elif unique == 'bunny':
			father_id = '-1'
			father_unique = unique
			penis_mod = .3
			cumprod = 3
		elif unique == 'cat':
			father_id = '-1'
			father_unique = unique
			penis_mod = .4
			cumprod = 4
		elif unique == 'cow':
			father_id = '-1'
			father_unique = unique
			penis_mod = .6
			cumprod = 6
		elif unique == 'dog':
			father_id = '-1'
			father_unique = unique
			penis_mod = .5
			cumprod = 5
		elif unique == 'fox':
			father_id = '-1'
			father_unique = unique
			penis_mod = .4
			cumprod = 4
		elif unique == 'horse':
			father_id = '-1'
			father_unique = unique
			penis_mod = .3
			cumprod = 6
		elif unique == 'raccoon':
			father_id = '-1'
			father_unique = unique
			penis_mod = .4
			cumprod = 4
		else:
			father_id = '-1'
			penis_mod = round(rand_range(1,6))
			penis_mod = (penis_mod*.1)
			cumprod = round(rand_range(1,7))
		virility = clamp(fertility * virility, 1, 100)
		cumprod = cumprod * penis_mod
		mother.preg.womb.append({id = father_id, unique = father_unique, semen = cumprod, virility = virility, day = 0,})
###---End Expansion---###

var baby

###---Added by Expansion---### Ank BugFix v1d
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
		###---Added by Expansion---### Pregnancy Expanded | int (i) etc added by Deviate
		for i in entry.children:
			if int(i) != int(person2.id):
				var entry2 = globals.state.relativesdata[i]
				connectrelatives(person2, entry2, 'sibling')
		###---End Expansion---###
		entry = globals.state.relativesdata[person2.id]
		entry[way] = person1.id
		if typeof(person1) != TYPE_DICTIONARY && typeof(person2) != TYPE_DICTIONARY:
			addrelations(person1, person2, 200)
	elif way == 'sibling':
		var entry = globals.state.relativesdata[person1.id]
		var entry2 = globals.state.relativesdata[person2.id]
		if entry.mother == entry2.mother && entry.father == entry2.father:
			if !entry.siblings.has(entry2.id):
				entry.siblings.append(entry2.id)
			if !entry2.siblings.has(entry.id):
				entry2.siblings.append(entry.id)
		else:
			if !entry.halfsiblings.has(entry2.id):
				entry.halfsiblings.append(entry2.id)
			if !entry2.halfsiblings.has(entry.id):
				entry2.halfsiblings.append(entry.id)
###---End Expansion---###

func createrelativesdata(person):
	var newdata = {name = person.name_long(), state = person.state, id = person.id, race = person.race, sex = person.sex, mother = -1, father = -1, siblings = [], halfsiblings = [], children = []}
	globals.state.relativesdata[person.id] = newdata

###---Added by Expansion---### Ank BugFix v1d
func clearrelativesdata(id):
	var entry
	if globals.state.relativesdata.has(id):
		entry = globals.state.relativesdata[id]
		
		for i in ['mother','father']:
			if globals.state.relativesdata.has(entry[i]):
				globals.state.relativesdata[entry[i]].children.erase(id)
		for i in entry.siblings:
			if globals.state.relativesdata.has(i):
				globals.state.relativesdata[i].siblings.erase(id)
		for i in entry.halfsiblings:
			if globals.state.relativesdata.has(i):
				globals.state.relativesdata[i].halfsiblings.erase(id)
		
		globals.state.relativesdata.erase(id)
###---End Expansion---###

func checkifrelatives(person, person2):
	var result = false
	var data1 
	var data2
	if globals.state.relativesdata.has(person.id):
		data1 = globals.state.relativesdata[person.id]
	else:
		createrelativesdata(person)
		data1 = globals.state.relativesdata[person.id]
	if globals.state.relativesdata.has(person2.id):
		data2 = globals.state.relativesdata[person2.id]
	else:
		createrelativesdata(person2)
		data2 = globals.state.relativesdata[person2.id]
	for i in ['mother','father']:
		if str(data1[i]) == str(data2.id) || str(data2[i]) == str(data1.id):
			result = true
	for i in [data1, data2]:
		if i.siblings.has(data1.id) || i.siblings.has(data2.id):
			result = true
	
	
	return result

func getrelativename(person, person2):
	var result = null
	var data1 
	var data2
	if globals.state.relativesdata.has(person.id):
		data1 = globals.state.relativesdata[person.id]
	else:
		createrelativesdata(person)
		data1 = globals.state.relativesdata[person.id]
	if globals.state.relativesdata.has(person2.id):
		data2 = globals.state.relativesdata[person2.id]
	else:
		createrelativesdata(person2)
		data2 = globals.state.relativesdata[person2.id]
	
	#print(data1, data2)
	for i in ['mother','father']:
		if str(data1[i]) == str(data2.id):
			result = '$parent'
		elif str(data2[i]) == str(data1.id):
			result = '$son'
	for i in [data1, data2]:
		if i.siblings.has(data1.id) || i.siblings.has(data2.id):
			result = '$sibling'
	if result != null:
		result = person2.dictionary(result)
	return result

func showtooltip(text):
	var screen = get_viewport().get_visible_rect()
	var tooltip = main.get_node("tooltip")
	main.get_node("tooltip/RichTextLabel").set_bbcode(text)
	var pos = main.get_global_mouse_position()
	pos = Vector2(pos.x+20, pos.y+20)
	tooltip.set_position(pos)
	tooltip.visible = true
	yield(get_tree(), "idle_frame")
	tooltip.get_node("RichTextLabel").rect_size.y = main.get_node("tooltip/RichTextLabel").get_v_scroll().get_max()
	tooltip.rect_size.y = main.get_node("tooltip/RichTextLabel").rect_size.y + 30
	if tooltip.get_rect().end.x >= screen.size.x:
		tooltip.rect_global_position.x -= tooltip.get_rect().end.x - screen.size.x
	if tooltip.get_rect().end.y >= screen.size.y:
		tooltip.rect_global_position.y -= tooltip.get_rect().end.y - screen.size.y

func hidetooltip():
	main.get_node("tooltip").visible = false
	slavetooltiphide()
	itemtooltiphide()

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
		node.get_node("name").text = "Master " + node.get_node("name").text
	else:
		node.get_node("name").set('custom_colors/font_color', Color(1,1,1))
	if person != globals.player:
		node.get_node("spec").set_texture(specimages[str(person.spec)])
	node.get_node("grade").set_texture(gradeimages[person.origins])
	node.get_node("spec").visible = !globals.player == person
	node.get_node("grade").visible = !globals.player == person
	node.get_node("text").bbcode_text = text
	node.get_node("sex").texture = globals.sexicon[person.sex]
	###---Added by Expansion---### Movement Icons - Line Added in Mod Globals File due to Call
#	node.get_node("movement").set_texture(movementimages[str(expansion.getMovementIcon(person))])
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

func slavetooltiphide(empty = null):
	if get_tree().get_current_scene().has_node('slavetooltip'):
		get_tree().get_current_scene().get_node('slavetooltip').visible = false

func openslave(person):
	if person == globals.player:
		main._on_selfbutton_pressed()
	elif globals.slaves.has(person) && person.away.duration == 0:
		main.openslavetab(person)

func itemtooltip(item):
	var text = itemdescription(item, true)
	var node = main.get_node('itemtooltip')
	if node == null:
		return
	node.visible = true
	node.get_node("image").texture = loadimage(item.icon)
	node.get_node('text').bbcode_text = text
	
	var screen = get_viewport().get_visible_rect()
	var pos = main.get_global_mouse_position()
	pos = Vector2(pos.x+20, pos.y+20)
	node.set_position(pos)
	if node.get_rect().end.x >= screen.size.x:
		node.rect_global_position.x -= node.get_rect().end.x - screen.size.x
	if node.get_rect().end.y >= screen.size.y:
		node.rect_global_position.y -= node.get_rect().end.y - screen.size.y
	

func itemtooltiphide(empty = null):
	if get_tree().get_current_scene().has_node('itemtooltip'):
		get_tree().get_current_scene().get_node('itemtooltip').visible = false

func gradetooltip(person):
	var text = ''
	for i in globals.originsarray:
		if i == person.origins:
			text += '[color=green] ' + i.capitalize() + '[/color]'
		else:
			text += i.capitalize()
		if i != 'noble':
			text += ' - '
	text += '\n\n' + globals.dictionary.getOriginDescription(person)
	globals.showtooltip(text)

static func merge(target, patch):
	for key in patch:
		if target.has(key):
			var tv = target[key]
			if typeof(tv) == TYPE_DICTIONARY:
				merge(tv, patch[key])
			elif typeof(tv) == TYPE_INT || typeof(tv) == TYPE_REAL:
				target[key] = target[key] + patch[key]
			else:
				target[key] = patch[key]
		else:
			target[key] = patch[key]

static func merge_overwrite(target, patch):
	for key in patch:
		if target.has(key):
			var tv = target[key]
			if typeof(tv) == TYPE_DICTIONARY:
				merge(tv, patch[key])
			else:
				target[key] = patch[key]
		else:
			target[key] = patch[key]

static func mergeclass(target, patch):
	for key in patch:
		target[key] = patch[key]

static func mergearrays(target, patch):
	var count = 0
	for key in patch:
		target[count] = patch[count]
		count += 1

static func fastif(formula, result1, result2):
	if formula == true:
		return result1
	else:
		return result2

static func find_trait(array, trait):
	var result = false
	for i in array:
		if i.name == trait:
			result = true
	return result

func getcodefromarray(array, code):
	var rval = false
	for i in array:
		if i.code == code:
			rval = i
	return rval

static func decapitalize(text):
	text = text.to_lower()
	text = text.replace(' ', '_')
	return text

static func sortbyname(first, second):
	if first.name < second.name:
		return true
	else:
		return false

static func sortbycost(first, second):
	if first.cost < second.cost:
		return true
	elif first.cost == second.cost:
		if first.name < second.name:
			return true
		else:
			return false
	else:
		return false

static func sortbynumber(first, second):
	if first.number < second.number:
		return true
	else:
		return false


var hairlengtharray = ['ear','neck','shoulder','waist','hips']
var sizearray = ['masculine','flat','small','average','big','huge']
var heightarray = ['petite','short','average','tall','towering']
var agesarray = ['child','teen','adult']
var genitaliaarray = ['small','average','big']
var originsarray = ['slave','poor','commoner','rich','noble']
var longtails = ['cat','fox','wolf','demon','dragon','scruffy','snake tail','racoon']
var skincovarray = ['none','scales','feathers','full_body_fur', 'plants']
var penistypearray = ['human','canine','feline','equine']
var alltails = ['cat','fox','wolf','bunny','bird','demon','dragon','scruffy','snake tail','racoon']
var allwings = ['feathered_black', 'feathered_white', 'feathered_brown', 'leather_black','leather_red','insect']
var allears = ['human','feathery','pointy','short_furry','long_pointy_furry','fins','long_round_furry', 'long_droopy_furry']
var allhorns = ['short', 'long_straight', 'curved']
var alleyecolors = ['blue', 'green', 'brown', 'hazel', 'black', 'gray', 'purple', 'blue', 'blond', 'red', 'auburn']
var allfurcolors = ['white', 'gray', 'orange_white','black_white','black_gray','black','orange','brown']
var allhaircolors = ['red', 'auburn', 'brown', 'black', 'white', 'green', 'purple', 'blue', 'blond', 'red']
var allskincolors = ['pale', 'fair', 'olive', 'tan', 'brown', 'dark', 'blue', 'purple', 'pale blue', 'green','jelly','teal']
var statsdict = {sstr = 'Strength', sagi = 'Agility', smaf = "Magic Affinity", send = "Endurance", cour = 'Courage', conf = 'Confidence', wit = 'Wit', charm = 'Charm'}
var maxstatdict = {sstr = 'str_max', sagi = 'agi_max', smaf = 'maf_max', send = 'end_max', cour = 'cour_max', conf = 'conf_max', wit = 'wit_max', charm = 'charm_max'}
var basestatdict = {sstr = 'str_base', sagi = 'agi_base', smaf = 'maf_base', send = 'end_base', cour = 'cour_base', conf = 'conf_base', wit = 'wit_base', charm = 'charm_base'}
var statsdescript = dictionary.statdescription
###---Added by Expansion---### Kennels Expanded
var sleepdict = {communal = {name = 'Communal Room'}, jail = {name = "Jail"}, personal = {name = 'Personal Room'}, your = {name = "Your bed"}, kennel = {name = "Dog Kennel"}}
###---End Expansion---###

func itemdescription(item, short = false):
	var text = ''
	var name = ''
	name = item.name
	if short == false:
		text += item.description + '\n\n'
	elif !item.has('owner'):
		text += item.description
	if item.has('owner'):
		#text += '\n\n'
		if item.enchant == 'basic':
			name = '[color=green]' + name + '[/color]'
		elif item.enchant == 'unique':
			name = '[color=#cc8400]' + name + '[/color]'
		for i in item.effects:
			text += i.descript + "\n"
	if item.type == 'gear':
		text += '\n\n'
		for i in item.effect:
			text += i.descript + "\n"
	if item.has('weight'):
		text += "\n[color=yellow]Weight: " + str(item.weight) + "[/color]"
	return '[center]' + name + '[/center]\n' + text

#saveload system
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

func save_game(var savename):
	var savegame = File.new()
	var dir = Directory.new()
	if !dir.dir_exists(saveDir):
		dir.make_dir_recursive(saveDir)
	savegame.open(savename, File.WRITE)
	var nodedata = save()
	savelistentry(savename)
	overwritesettings()
	savegame.store_line(to_json(nodedata))
	savegame.close()
	get_tree().get_current_scene().infotext("Game Saved.",'green')

func savelistentry(savename):
	var date = OS.get_datetime()
	for i in date:
		if int(date[i]) < 10:
			date[i] = '0' + str(date[i])
		else:
			date[i] = str(date[i])

	savelist[savename] = {
		name = globals.state.defaultmasternoun + " " + player.name + "\nDay: " + str(resources.day) + '\nGold: [color=yellow] ' + str(resources.gold) + '[/color]\nSlaves: ' + str(slavecount()),
		path = savename,
		date = date.hour + ":" + date.minute + " " + date.day + '.' + date.month + '.' + date.year,
		portrait = player.imageportait
	}

func saveListNewEntry(savePath):
	var saveFile = File.new()
	saveFile.open(savePath, File.READ)
	var saveData = parse_json(saveFile.get_as_text())
	if !(typeof(saveData) == TYPE_DICTIONARY && saveData.has('slaves') && saveData.has('state') && saveData.has('player') && saveData.has('resources')):
		return false

	var date = OS.get_datetime()
	for i in date:
		if int(date[i]) < 10:
			date[i] = '0' + str(date[i])
		else:
			date[i] = str(date[i])

	var count = 0
	for person in saveData.slaves:
		if person.away.at != 'hidden':
			count += 1
	savelist[savePath] = {
		name = saveData.state.defaultmasternoun + " " + saveData.player.name + "\nDay: " + str(saveData.resources.day) + '\nGold: [color=yellow] ' + str(saveData.resources.gold) + '[/color]\nSlaves: ' + str(count),
		path = savePath,
		date = date.hour + ":" + date.minute + " " + date.day + '.' + date.month + '.' + date.year,
		portrait = saveData.player.imageportait
	}
	return true

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
	###---Added by Expansion---### NPCs Expanded - In the Mod Globals File to avoid the Error message
#	var expansion = globals.expansion
#	var expansionsetup = globals.expansionsetup
	state.allnpcs.clear()
	for i in currentline.allnpcs:
		if typeof(i) == TYPE_STRING:
			continue
		newslave = person.new()
		if i['@path'].find('.gdc'):
			i['@path'] = i['@path'].replace('.gdc', '.gd')
		newslave = dict2inst(i)
		if i.has('face'):
			newslave.beautybase = round(i.face.beauty)
		state.allnpcs.append(newslave)
#	if str(state.expansionversion) != str(expansionsettings.modversion):
#		print("Mod Version v" + str(state.expansionversion) + ". Expanding game to latest Aric's Expansion version")
#		expansionsetup.expandGame()
#	print("Aric's Expansion v" + str(expansionsettings.modversion))
#	if expansionsettings.enablecheatbutton == true:
#		print("Aric's Cheat Button Active. Access via Talk > Piece of Candy")
	###---End Expansion---###
	savegame.close()
	if state.customcursor == null:
		Input.set_custom_mouse_cursor(null)
	else:
		state.customcursor = "res://files/buttons/kursor1.png"
	if !state.mansionupgrades.has("farmmana"):
		state.mansionupgrades.farmmana = 0
	
	
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

func repairsave():
	state.currentversion = gameversion
	var personList = slaves + state.babylist
	personList.append(player)
	for guild in globals.guildslaves.values():
		for person in guild:
			personList.append(person)
	if state.sebastianorder.taken:
		personList.append(state.sebastianslave)
	for person in personList:
		person.id = str(person.id)
		if person.sexexp.has('partners') == false:
			person.sexexp = {partners = {}, watchers = {}, actions = {}, seenactions = {}, orgasms = {}, orgasmpartners = {}}
		if person.skin == "pale_blue":
			person.skin = "pale blue"
	for item in globals.state.unstackables.values():
		if item.enchant == null:
			item.enchant = ''
		if item.code == 'weaponshortsword':
			for e in item.effects:
				if e.has('type') && e.type == 'incombat':
					if e.effect == 'damage':
						if e.effectvalue == 6 && e.descript == "+9 Damage":
							e.effectvalue = 9
					elif e.effect == 'passive':
						e.type = 'passive'
						e.effect = 'armorbreaker'
						e.erase('effectvalue')
	globals.rules.showfullbody = globals.rules.get('showfullbody', true)

var showalisegreet = false

func dir_contents(target = saveDir):
	var dir = Directory.new()
	var array = []
	if target.ends_with('/'):
		target.erase(target.length()-1,1)
	var retCode = dir.open(target)
	if retCode == OK:
		dir.list_dir_begin(true)
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				array += dir_contents(target + "/" + file_name)
			else:
				array.append(target + "/" + file_name)
			file_name = dir.get_next()
		return array
	else:
		printErrorCode("could not access path: "+ str(target), retCode)

var currentslave
var currentsexslave

func evaluate(input): #used to read strings as conditions when needed
	var script = GDScript.new()
	script.set_source_code("var person\nfunc eval():\n\treturn " + input)
	script.reload()
	var obj = Reference.new()
	obj.set_script(script)
	obj.person = currentslave
	return obj.eval()

func weightedrandom(array): #array must be made out of dictionaries with {value = name, weight = number} Number is relative to other elements which may appear
	var total = 0
	var counter = 0
	for i in array:
		if typeof(i) == TYPE_DICTIONARY:
			total += i.weight
		else:
			total += i[1]
	var random = rand_range(0,total)
	for i in array:
		if typeof(i) == TYPE_DICTIONARY:
			if counter + i.weight >= random:
				return i.value
			counter += i.weight
		else:
			if counter + i[1] >= random:
				return i[0]
			counter += i[1]

func randomfromarray(array):
	return array[randi() % array.size()]

func buildportrait(node, person):
	var array = ['race','hairlength','ears'] #add more pieces of layers in order they should be added
	var imagedict = { #should have all pieces you added to the array with paths
	race = {human = load('humanheadimage.png'), elf = load('elfheadimage.png')},
	hairlength = {long = load('longhairimage.png'), short = load('shorthairimage.png')},
	ears = {normal = load('normalears.png'), pointy = load('pointyearsimg.png')},
	} 
	for i in array:
		var newlayer = node.duplicate()
		node.add_child(newlayer)
		newlayer.set_texture(imagedict[i][person[i]])

func getracedata(person):
	var race = person.race
	return races[race.replace('Halfkin', 'Beastkin')]

func getracebygroup(group):
	var array = []
	for i in races:
		if group == 'bandits' && races[i].banditrace == true:
			array.append(i)
		elif group == 'starting' && races[i].startingrace == true:
			array.append(i)
		elif group == 'wimborn' && races[i].wimbornrace == true:
			array.append(i)
		elif group == 'gorn' && races[i].gornrace == true:
			array.append(i)
		elif group == 'frostford' && races[i].frostfordrace == true:
			array.append(i)
	addnonfurrycounterpart(array)
	if rules.furry == false:
		removefurries(array)
	return array[randi()%array.size()]


func addnonfurrycounterpart(array):
	for i in array.duplicate():
		if i.find('Beastkin') >= 0:
			array.append(i.replace('Beastkin', 'Halfkin'))

func removefurries(array):
	for i in array.duplicate():
		if i.find('Beastkin') >= 0:
			array.erase(i)


func checkfurryrace(text):
	if text in ['Cat','Wolf','Fox','Bunny','Tanuki']:
		if rules.furry == true:
			if rand_range(0,1) >= 0.5:
				text = 'Halfkin ' + text
			else:
				text = 'Beastkin ' + text
		else:
			text = 'Halfkin ' + text
	return text

const errorText = [
	"OK",
	"Generic",
	"Unavailable",
	"Unconfigured",
	"Unauthorized",
	"Parameter Range",
	"Out of memory",
	"File: not found",
	"File: Bad drive",
	"File: Bad path",
	"File: No permission",
	"File: Already in use",
	"File: Can't open",
	"File: Can't write",
	"File: Can't read",
	"File: Unrecognized",
	"File: Corrupt",
	"File: Missing dependencies",
	"File: End of file",
	"Can't open",
	"Can't create",
	"Query failed",
	"Already in use",
	"Locked",
	"Timeout",
	"Can't connect",
	"Can't resolve",
	"Connection",
	"Can't acquire resource",
	"Can't fork",
	"Invalid data",
	"Invalid parameter",
	"Already exists",
	"Does not exist",
	"Database: can't read",
	"Database: can't write",
	"Compilation failed",
	"Method not found",
	"Link failed",
	"Script failed",
	"Cyclic link",
	"Invalid declaration",
	"Duplicate symbol",
	"Parse",
	"Busy",
	"Skip",
	"Help",
	"Bug"
]

func printErrorCode(msg, code=ERR_BUG, showOK = false):
	if code != OK:
		traceFile("ERROR: " +str(msg)+ "  Error code("+ str(code)+ "): "+ str(errorText[code]))
		print("ERROR: ", msg, "  Error code(", code, "): ", errorText[code])
	elif showOK: 
		print("OK: ", msg)

#debugging function useful for diagnosing problems when Strive crashes and fails to produce normal error logs
#recommended use: spread calls to this function(with unique strings) around code likely to be the source of the crash, run Strive, and view the trace file
var firstTrace = true
func traceFile(string):
	string += '\n'
	var file = File.new()
	var type
	if firstTrace:
		type = File.WRITE
		firstTrace = false
		var dir = Directory.new() #Create log directory if it doesn't exist
		if !dir.dir_exists("user://logs/"):
			dir.make_dir_recursive("user://logs/")
	else:
		type = File.READ_WRITE
	if file.open("user://logs/DEBUG_TRACE.txt", type) == OK:
		file.seek_end()
		file.store_string(string)
		file.close()

func shellOpenFolder(path):
	var retCode = OS.shell_open(ProjectSettings.globalize_path(path))
	printErrorCode("OS shell opening " + path, retCode)

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
###---End Expansion---###

###---Added by Expansion---### Pregnancy Expanded | Added by Deviate
func get_person(id):
	var person
	
	if id == globals.player.id:
		person = globals.player
		return person
	else:
		for i in globals.slaves:
			if id == i.id:
				person = i
				return person

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
###---End of Expansion---###

###---Added by Expansion---### Slime Breeding / Prevents Globals Failure to Load, Function in Mod Globals
func slimeConversionCheck(mother, father):
	return

###---Added by Expansion---### General Usage
#I can't remember if I added this or found it elsewhere. Sorry if I didn't!
func randomitemfromarray(source):
	if source.size() > 0:
		#source[randi() % source.size()] Old
		return source[rand_range(0,source.size())]

func getfromarray(array, index):
	return array[ clamp(index, 0, array.size()-1) ]
###---End Expansion---###
