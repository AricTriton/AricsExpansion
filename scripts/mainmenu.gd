
var racebonusdict = {
	human = {descript = 'Reputation with Wimborn increased'},
	elf = {descript = 'Start with +1 Magic Affinity'},
	"tribal elf" : {descript = 'Start with +1 Agility'},
	orc = {descript = 'Reputation with Gorn increased'},
	demon = {descript = 'Start with +1 unassigned Skillpoint, all starting reputation lowered slightly'},
	beastkin = {descript = 'Reputation with Frostford increased'},
	halfkin = {descript = 'All starting reputation increased slightly'},
	taurus = {descript = 'Start with +1 Endurance'},
	kobold = {descript = 'Start with +1 Agility'},
	gnoll = {descript = 'Start with +1 Strength'},
	avali = {descript = 'Start with +1 Magic Affinity'},
}

var skindict = {
	human = [ 'pale', 'fair', 'olive', 'tan', 'brown', 'dark' ],
	kobold = ['none'],
	dragonkin = ['scales'],
	lizardfolk = ['none'],
	avali = ['none'],
	drow = ['blue', 'purple', 'pale blue'],
	orc = ['green'],
	goblin = ['green'],
	dryad = ['green'],
	slime = ['jelly'],
	nereid = ['teal', 'blue', 'pale blue']
}

var horndict = {
	human = ['none'],
	demon = ['short', 'long_straight', 'curved'],
	dragonkin = ['short', 'long_straight', 'curved', 'manyhorned',],
	lizardfolk = ['short', 'long_straight', 'curved', 'manyhorned'],
	kobold = ['short', 'long_straight', 'curved', 'manyhorned'],
	taurus = ['long_straight'],
}

var scaledict = {
	human = ['none'],
	dragonkin = ['red', 'blue', 'white', 'green', 'black', 'yellow'],
	lizardfolk = ['red', 'blue', 'white', 'green', 'black', 'yellow'],
	kobold = ['red', 'blue', 'white', 'green', 'black', 'yellow'],
}

var feathercolordict = {
	"human" : ['none'],
	"harpy" : ['white', 'black', 'brown',],
	"beastkin bird" : ['white', 'black', 'brown',],
	"avali" : ['white', 'black', 'brown',],
}

var eardict = {
	elf = ['pointy'],
	"dark elf" : ['pointy'],
	drow = ['pointy'],
	orc = ['pointy'],
	goblin = ['pointy'],
	fairy = ['pointy'],
	seraph = ['pointy'],
	dryad = ['pointy'],
	slime = ['none'],
	lamia = ['pointy'],
	harpy = ['feathery'],
	arachna = ['pointy'],
	scylla = ['pointy'],
	cat	= ['short_furry'],
	fox = ['long_pointy_furry'],
	wolf = ['short_furry'],
	bunny = ['long_round_furry', 'long_droopy_furry'],
	raccoon = ['short_furry'],
	centaur = ['short_furry'],
	nereid = ['fins'],
	demon = ['pointy'],
	dragonkin = ['pointy'],
	lizardfolk = ['short_reptilian','pointy', 'frilled','none','long_round_reptilian','long_droopy_reptilian','long_pointy_reptilian'],
	kobold = ['short_reptilian','pointy', 'frilled','none','long_round_reptilian','long_droopy_reptilian','long_pointy_reptilian'],
	mouse = ['wide_furry'],
	taurus = ['short_furry'],
	gnoll = ['short_furry'],
	squirrel = ['short_furry','long_pointy_furry'],
	otter = ['short_furry'],
	bird = ['feathery'],
	avali = ['avali'],
}

var wingsdict = {
	human = ['none'],
	"fairy" : ['insect', 'gossamer'], #Added 'gossamer' wing type
	"demon" : ['leather_black', 'leather_red'],
	"dragonkin" : ['leather_black', 'leather_red','leather_blue','leather_white','leather_green',],
	"seraph" : ['feathered_black', 'feathered_white', 'feathered_brown'],
	"beastkin bird" : ['feathered_black', 'feathered_white', 'feathered_brown'],
	"halfkin bird" : ['feathered_black', 'feathered_white', 'feathered_brown'],
}

var furcolordict = {
	"human" : ['none'],
	"beastkin cat" : ['white', 'gray', 'orange_white','black_white','black_gray','black'],
	"beastkin fox" : ['black_white', 'orange'],
	"beastkin wolf" : ['gray', 'black_gray', 'brown'],
	"beastkin bunny" : ['white', 'gray'],
	"beastkin tanuki" : ['black_gray'],
	"beastkin mouse" : ['white', 'gray', 'brown', 'black'],
	"beastkin squirrel" : ['white', 'gray', 'brown', 'black'],
	"beastkin otter" : ['white', 'gray', 'brown', 'black'],
	"avali" : ['white', 'gray', 'orange_white','black_white','black_gray','black'], 
	"gnoll" : ['gray', 'brown','black_white','black_gray','black']
}

###---Added by Expansion---### Player Expanded | Added new Hobby
var hobbydescription = {
	'Physical' : '[color=aqua]+1 Max Strength, +25 Courage[/color]\n\n$name is no stranger to fighting and tends to act boldly in many situations.',
	'Etiquette' : "[color=aqua]+20 Confidence, +15 Charm[/color]\n\n$name has spent $his youth among elderly people and high society, learning how to be liked and present $himself while also feeling superior to commonfolk.",
	'Graceful' : "[color=aqua]+1 Max Agility, +10 Confidence[/color]\n\n$name was the fastest kid $he knew growing up and a natural when it came to hand-eye coordination in general.", #ralph3
	'Magic' : "[color=aqua]+{maf} Max Magic, +25 Wit[/color]\n\n$name was a very curious child and spent a lot of $his time reading and studying various things, including magic.", #ralph3
	'Servitude' : "[color=aqua]+1 Max Endurance, +35 Min Obedience, +20 Loyalty[/color]\n\n$name has spent $his youth in harsh training which lead to $him being more physically fit and respecting to $his superiors.",
	'Curious' : "[color=aqua]Start with the [color=green]Gifted[/color] trait.[/color]\n\n$name spends $his time searching for answers and meaning in this crazy world. This has led $him to become more receptive to new skills and knowledge.",
	'Genius' : "[color=aqua]Start with the [color=green]Clever[/color] trait and randomly either the [color=green]Responsive[/color] or [color=green]Gifted[/color] trait.[/color]\n[color=red]Gains either the Clumsy, Frail, or Weak trait.[/color]\n\n$name spends $his time studying and thinking and tends to not focus on physical activities.\n",
	'Socialite' : "[color=aqua]Start with the traits [color=green]Pretty Voice[/color] and either [color=green]Natural Beauty[/color] or [color=green]Ditzy[/color]. Gain [color=red]Fickle[/color].[/color]\n\n$name understands that the only real happiness in life comes from being popular and now even craves the attention from others.\n",
	'Waifu' : "[color=aqua]Start with the traits [color=green]Monogamous[/color], [color=green]Fertile[/color], [color=green]Ascetic[/color], and [color=red]Clingy[/color].\n\nStarts with the [color=green]Submissive[/color] fetish at [color=lime]Mindblowing[/color] and [color=green]Dominance[/color] at [color=red]Taboo[/color].[/color]\n\n$name has spent $his whole life preparing $himself to be the perfect, submissive partner.\n\n[color=yellow]Very Unbalanced[/color]\n",
	'Perfect Specimen' : "[color=aqua]Start with the traits [color=green]Strong[/color], [color=green]Quick[/color], [color=green]Robust[/color], and [color=green]Responsive[/color].[/color]\n\n$name has been perfectly crafted to be the perfect specimen of their race.\n\n[color=red]Insanely Unbalanced[/color]\n"
}

<AddTo 7>
func _ready():
	###---Added by Expansion---###
	globals.useRalphsTweaks = globals.expansionsettings.use_ralphs_tweaks
	globals.useCapsTweaks = globals.expansionsettings.use_caps_tweaks
	if globals.useRalphsTweaks:
		globals.expansionsettings.applyRalphsTweaks()
	if globals.useCapsTweaks:
		globals.expansionsettings.applyCapitulizeTweaks()

func _slave_hobby(button):
	for i in get_tree().get_nodes_in_group("slavehobby"):
		if i != button:
			i.set_pressed(false)
		else:
			i.set_pressed(true)
	startSlaveHobby = button.get_meta('hobby')
	get_node("TextureFrame/newgame/stage8/backgroundtext").set_bbcode(startSlave.dictionary(hobbydescription[startSlaveHobby].format({"maf":str(globals.expansionsettings.magic_hobby_maf_max)})))

#Provides a container for Additional Hobbies
var slaveHobbiesExpanded = ['Graceful','Curious','Genius','Socialite','Waifu','Perfect Specimen'] #ralph3
###---Expansion End---###

<AddTo -1>
func _ready():
	if globals.useCapsTweaks:
		eardict.dragonkin = ['short_reptilian','pointy', 'frilled','none','long_round_reptilian','long_droopy_reptilian','long_pointy_reptilian']
		skindict.dragonkin = ['none']


#Added Penis Sizes
#QMod - Incompletely modified, a bit more random now, does not fully implement choice consequences 'properly'
func _on_quickstart_pressed():
	var ageArray = ['teen', 'adult']
	var sexArray = ['male','male','futanari','dickgirl']
	var playerSpecializationArray = ['Slaver','Hunter'] #Added 'Hunter', 'Alchemist', 'Mage'

	#Select random start location
	var locationArray = locationDict.keys()
	#startingLocation = locationArray[rand_range(0, locationArray.size())]
	startingLocation = 'wimborn'
	
	#Generate random Player
	player.race = globals.getracebygroup('active' if isSandbox || variables.storymodeanyrace else 'starting')
	
	if !globals.rules.futa: #If futanari not allowed, remove futa
		sexArray.erase('futanari')

	if !globals.rules.dickgirl: #If dickgirl not allowed, remove dickgirl
		sexArray.erase('dickgirl')
	
	player.sex = globals.randomfromarray(sexArray)
	player.age = globals.randomfromarray(ageArray)
	regenerateplayer()
	quickstartStats()
	player.spec = globals.randomfromarray(playerSpecializationArray)
	
	#Generate random starting slave
	if globals.rules.children: #If children allowed, add 'child' age
		ageArray.push_front('child')
	
	slaveDefaults.race = globals.getracebygroup('active' if isSandbox || variables.storymodeanyrace else 'starting')
	
	slaveDefaults.age = globals.randomfromarray(ageArray)
	slaveDefaults.sex = 'random'
	startSlave = globals.newslave(slaveDefaults.race, slaveDefaults.age, slaveDefaults.sex, 'poor', 'startslave') ###---Added by Expansion---### new arg unique
	player.imagefull = null
	player.imageportait = playerPortraits[randi()%playerPortraits.size()]
	startSlave.cleartraits()

	var traitpool = []
	for i in globals.origins.traitlist.values():
		if i.tags.has("secondary") || forbiddentraits.has(i):
			continue
		traitpool.append(i.name)
	slaveTrait = globals.randomfromarray(traitpool)
	startSlaveHobby = globals.randomfromarray(slaveHobbies)
	_on_slaveconfirm_pressed()

#Stage05 - Select player gender, age, stats
#QMod
func _stage5():
	#Clear age, gender
	get_node("TextureFrame/newgame/stage5/age").clear()
	get_node("TextureFrame/newgame/stage5/sex").clear()
	var listSex = ['male','female','futanari','dickgirl']
	if !globals.rules.futa:
		listSex.erase('futanari')
	if !globals.rules.dickgirl:
		listSex.erase('dickgirl')

	#Build age & gender lists, display currently selected options
	for i in listSex:
		get_node("TextureFrame/newgame/stage5/sex").add_item(i)
		if player.sex == i:
			get_node("TextureFrame/newgame/stage5/sex").select(get_node("TextureFrame/newgame/stage5/sex").get_item_count()-1)

	var listAge = ['adult','teen','child']
	if !globals.rules.children:
		listAge.erase('child')
	for i in listAge:
		get_node("TextureFrame/newgame/stage5/age").add_item(i)
		if player.age == i:
			get_node("TextureFrame/newgame/stage5/age").select(get_node("TextureFrame/newgame/stage5/age").get_item_count()-1)

	_update_stage5()

func regenerateplayer():
	var imageportait = player.imageportait
	player = globals.newslave(player.race, player.age, player.sex, 'slave', 'player')###---Added by Expansion---### new arg unique
	globals.player = player
	player.cleartraits()
	#player.unique = 'player'
	player.imageportait = imageportait
	player.imagefull = null
	player.beautybase = variables.playerstartbeauty
	playerBonusStatPoints = variables.playerbonusstatpoint
	for i in ['str','agi','maf','end']:
		player.stats[i+'_max'] = 4
	_update_stage5()


func regenerateslave():
	var memory = startSlave.memory
	startSlave = globals.newslave(startSlave.race, startSlave.age, startSlave.sex, 'poor', 'startslave') ###---Added by Expansion---### new arg unique
	startSlave.unique = 'startslave' #ralphE - needed for my quickfix to allow startslave hybrid race to be set
	startSlave.memory = memory
	startSlave.beautybase = variables.characterstartbeauty

#QMod - Patch fix for women/futa to have womb == true
func _on_sexconfirm_pressed():
	globals.assets.getsexfeatures(player) #Also modified assets.gd to set has_womb == true for females/futa
	if player.vagina != 'none': #Including this here temporarily for compatibility if no other files are modified
		player.preg.has_womb = true
	get_node("TextureFrame/newgame/stagespanel/VBoxContainer/sexage").set_text(player.sex.capitalize() + " " + player.age.capitalize())
	self.stage = 5	

#QMod - Refactor
func _process_stage6_sex_options():
	#Add sex size options
	var sexSizes
	var arraySelect = makeoverPerson.sex == 'male'
	var stage6 = get_node("TextureFrame/newgame/stage6")

	sexSizes = malesizes if arraySelect else femalesizes
	for i in sexSizes:
		stage6.get_node("asssize").add_item(i)
		if makeoverPerson.asssize == i:
			stage6.get_node("asssize").select(stage6.get_node("asssize").get_item_count()-1)

	if arraySelect:
		sexSizes = malesizes
	else:
		sexSizes = globals.titssizearray.duplicate()
		sexSizes.pop_front() #remove 'masculine'
		if makeoverPerson.sex == 'dickgirl':
			sexSizes.pop_front() #remove 'flat'
	for i in sexSizes:
		stage6.get_node("titssize").add_item(i)
		if makeoverPerson.titssize == i:
			stage6.get_node("titssize").select(stage6.get_node("titssize").get_item_count()-1)

	if makeoverPerson.sex != 'female':
		stage6.get_node("penis").set_disabled(false)
		stage6.get_node("balls").set_disabled(false)
		sexSizes = globals.penissizearray.duplicate()
		for i in sexSizes:
			stage6.get_node("penis").add_item(i)
			if makeoverPerson.penis == i:
				stage6.get_node("penis").select(stage6.get_node("penis").get_item_count()-1)
		sexSizes.push_front('none')
		for i in sexSizes:
			stage6.get_node("balls").add_item(i)
			if makeoverPerson.balls == i:
				stage6.get_node("balls").select(stage6.get_node("balls").get_item_count()-1)
	else:
		stage6.get_node("penis").set_disabled(true)
		stage6.get_node("penis").add_item('none')
		stage6.get_node("balls").set_disabled(true)
		stage6.get_node("balls").add_item('none')

###---Added by Expansion---### Traits to Forbidden
#QMod - Refactor
func _process_stage6_body_options():
	var stage6 = get_node("TextureFrame/newgame/stage6")
	#Process height
	for i in globals.heightarray:
		stage6.get_node("height").add_item(i)
		if makeoverPerson.height == i:
			stage6.get_node("height").select(stage6.get_node("height").get_item_count()-1)

	#Process hair
	for i in globals.hairlengtharray:
		stage6.get_node("hairlength").add_item(i)
		if makeoverPerson.hairlength == i:
			stage6.get_node("hairlength").select(stage6.get_node("hairlength").get_item_count()-1)

	var tempRace = makeoverPerson.race.to_lower()
	#Process skin hues
	var skinHues
	if skindict.has(tempRace):
		skinHues = skindict[tempRace]
	else:
		skinHues = skindict.human
	for i in skinHues:
		stage6.get_node("skin").add_item(i)
		if makeoverPerson.skin == i:
			stage6.get_node("skin").select(stage6.get_node("skin").get_item_count()-1)

	#Process horns
	var hornTypes
	if horndict.has(tempRace):
		hornTypes = horndict[tempRace]
		stage6.get_node("horns").set_disabled(false)
	else:
		hornTypes = horndict.human
		stage6.get_node("horns").set_disabled(true)
	for i in hornTypes:
		stage6.get_node("horns").add_item(i.replace("_", " "))
		if makeoverPerson.horns == i:
			stage6.get_node("horns").select(stage6.get_node("horns").get_item_count()-1)
			
	# Capitulize: Process Scale Color
	var scaleTypes
	if scaledict.has(makeoverPerson.race.to_lower()):
		scaleTypes = scaledict[makeoverPerson.race.to_lower()]
		get_node("TextureFrame/newgame/stage6/scalecolor").set_disabled(false)
	else:
		scaleTypes = scaledict.human
		get_node("TextureFrame/newgame/stage6/scalecolor").set_disabled(true)
	for i in scaleTypes:
		get_node("TextureFrame/newgame/stage6/scalecolor").add_item(i.replace("_", " "))
		if makeoverPerson.scalecolor == i:
			get_node("TextureFrame/newgame/stage6/scalecolor").select(get_node("TextureFrame/newgame/stage6/scalecolor").get_item_count()-1)
			
	#Process feather color
	var featherTypes
	if feathercolordict.has(makeoverPerson.race.to_lower()):
		featherTypes = feathercolordict[makeoverPerson.race.to_lower()]
		get_node("TextureFrame/newgame/stage6/feathercolor").set_disabled(false)
	else:
		featherTypes = feathercolordict.human
		get_node("TextureFrame/newgame/stage6/feathercolor").set_disabled(true)
	for i in featherTypes:
		get_node("TextureFrame/newgame/stage6/feathercolor").add_item(i.replace("_", " "))
		if makeoverPerson.feathercolor == i:
			get_node("TextureFrame/newgame/stage6/feathercolor").select(get_node("TextureFrame/newgame/stage6/feathercolor").get_item_count()-1)

	#Process ears
	var earTypes
	if eardict.has(makeoverPerson.race.to_lower().replace("beastkin ", "").replace("halfkin ", "")):
		earTypes = eardict[makeoverPerson.race.to_lower().replace("beastkin ", "").replace("halfkin ", "")]
		if earTypes.size() > 1:
			get_node("TextureFrame/newgame/stage6/ears").set_disabled(false)
		else:
			get_node("TextureFrame/newgame/stage6/ears").set_disabled(true)
	else:
		earTypes = ['Human']
		get_node("TextureFrame/newgame/stage6/ears").set_disabled(true)
	for i in earTypes:
		get_node("TextureFrame/newgame/stage6/ears").add_item(i.replace("_", " "))
		if makeoverPerson.ears == i:
			get_node("TextureFrame/newgame/stage6/ears").select(get_node("TextureFrame/newgame/stage6/ears").get_item_count()-1)

	#Process wings
	var wingTypes
	if wingsdict.has(tempRace):
		wingTypes = wingsdict[tempRace]
		stage6.get_node("wings").set_disabled(false)
	else:
		wingTypes = wingsdict.human
		stage6.get_node("wings").set_disabled(true)
	for i in wingTypes:
		stage6.get_node("wings").add_item(i.replace("_", " "))
		###---Added by Expansion---### Ank Bugfix v4
		if makeoverPerson.wings == i:
			stage6.get_node("wings").select(stage6.get_node("wings").get_item_count()-1)
		###---End Expansion---###

	#Process fur colors
	var furColors
	if furcolordict.has(tempRace):
		furColors = furcolordict[tempRace]
		stage6.get_node("furcolor").set_disabled(false)
	else:
		furColors = furcolordict.human
		stage6.get_node("furcolor").set_disabled(true)
	for i in furColors:
		stage6.get_node("furcolor").add_item(i.replace("_", " "))
		if makeoverPerson.furcolor == i:
			stage6.get_node("furcolor").select(stage6.get_node("furcolor").get_item_count()-1)

	###---Added by Expansion---### Person Expanded | Sexuality, Lip, Asshole, and Vagina Sizes
	for i in globals.kinseyscale:
		stage6.get_node("sexuality").add_item(i)
		if makeoverPerson.sexuality == i:
			stage6.get_node("sexuality").select(stage6.get_node("sexuality").get_item_count()-1)

	for i in globals.lipssizearray:
		stage6.get_node("lips").add_item(i)
		if makeoverPerson.lips == i:
			stage6.get_node("lips").select(stage6.get_node("lips").get_item_count()-1)

	for i in globals.vagsizearray:
		stage6.get_node("asshole").add_item(i)
		if makeoverPerson.asshole == i:
			stage6.get_node("asshole").select(stage6.get_node("asshole").get_item_count()-1)

	if !makeoverPerson.sex in ['male','dickgirl']:
		stage6.get_node("vagina").set_disabled(false)
		for i in globals.vagsizearray:
			stage6.get_node("vagina").add_item(i)
			if makeoverPerson.vagina == i:
				stage6.get_node("vagina").select(stage6.get_node("vagina").get_item_count()-1)
	else:
		stage6.get_node("vagina").set_disabled(true)
		stage6.get_node("vagina").add_item('none')

	###---End Expansion---###

#QMod - Refactor
func _process_stage6_locked_options():
	#Set & lock immutable features
	get_node("TextureFrame/newgame/stage6/bodyshape").set_disabled(true)
	get_node("TextureFrame/newgame/stage6/bodyshape").add_item(makeoverPerson.bodyshape)
	get_node("TextureFrame/newgame/stage6/tail").set_disabled(true)
	get_node("TextureFrame/newgame/stage6/tail").add_item(makeoverPerson.tail)
	get_node("TextureFrame/newgame/stage6/penistype").add_item(makeoverPerson.penistype)
	get_node("TextureFrame/newgame/stage6/penistype").set_disabled(true)	
	get_node("TextureFrame/newgame/stage6/penistype").set_disabled(true)

func _update_stage6():
	###---Added by Expansion---### Quick Strip
	globals.expansion.quickStrip(makeoverPerson)
	###---End Expansion---###
	var text = makeoverPerson.description()
	get_node("TextureFrame/newgame/stage6/chardescript").set_bbcode(text)

###---Added by Expansion---### Vaginal Sizes Expanded
func _virgin_press():
	if makeoverPerson.vagina != 'none':
		makeoverPerson.vagvirgin = get_node("TextureFrame/newgame/stage6/virgin").is_pressed()
	_update_stage6()
###---End Expansion---###

#Stage07 - Select specialization
func _stage7():
	#Reset specialization
	player.spec = null

	#Set default description
	var text = "Specialization provides a\n" + "considerable bonus to certain way of\n" + "playing."
	get_node("TextureFrame/newgame/stage7/backgroundtext").set_bbcode(text)

	#Clear specializations list
	for i in get_node("TextureFrame/newgame/stage7/backgroundcontainer/VBoxContainer").get_children():
		if i != get_node("TextureFrame/newgame/stage7/backgroundcontainer/VBoxContainer/Button"):
			i.visible = false
			i.queue_free()

	#Build specialization list
	###---Added by Expansion---### New Specializations
	for i in globals.expandedplayerspecs:
		var newbutton = get_node("TextureFrame/newgame/stage7/backgroundcontainer/VBoxContainer/Button").duplicate()
		get_node("TextureFrame/newgame/stage7/backgroundcontainer/VBoxContainer").add_child(newbutton)
		newbutton.visible = true
		newbutton.set_text(i)
		newbutton.set_meta('spec', i)
		newbutton.connect("pressed",self,'_select_specialization', [newbutton])
	###---End Expansion---###

	#Disable 'confirm' button
	get_node("TextureFrame/newgame/stage7/backgroundconfirm").set_disabled(true)

#QMod - Renamed, tweaked for 'select' and 'deselect' behavior, added allow 'confirm' only when spec selected
func _select_specialization(button):
	#If button 'unpressed' reset spec panel
	if !button.is_pressed():
		var text = "Specialization provides a\n" + "considerable bonus to certain way of\n" + "playing."
		get_node("TextureFrame/newgame/stage7/backgroundtext").set_bbcode(text)
		get_node("TextureFrame/newgame/stage7/backgroundconfirm").set_disabled(true)
		return

	#Set all non-selected buttons to 'unpressed'
	for i in get_tree().get_nodes_in_group('bgbutton'):
		if i != button:
			i.set_pressed(false)

	#Set player specialization to selected spec
	var spec = button.get_meta('spec')
	player.spec = spec
	#Set specialization description
	###---Added by Expansion---### New Specializations
	var text = globals.expandedplayerspecs[spec]
	if player.spec in ['Mage', 'Alchemist','Breeder']:
		text += "\n\n[color=yellow]Not recommended for inexperienced players.[/color]"
	###---End Expansion---###
	get_node("TextureFrame/newgame/stage7/backgroundtext").set_bbcode(text)

	#Enable 'confirm' button
	get_node("TextureFrame/newgame/stage7/backgroundconfirm").set_disabled(false)

#QMod - Refactor
func _process_stage8_sex_options():
	#Build sex options
	var sexArray = ['female','futanari','male','dickgirl']
	if !globals.rules.futa:
		sexArray.erase('futanari')
	if !globals.rules.dickgirl:
		sexArray.erase('dickgirl')
	for i in sexArray:
		get_node("TextureFrame/newgame/stage8/slavesex").add_item(i)
		if startSlave.sex == i:
			get_node("TextureFrame/newgame/stage8/slavesex").select(get_node("TextureFrame/newgame/stage8/slavesex").get_item_count()-1)

#QMod - Refactor
func _process_stage8_hobby_list():
	#Clear slave hobby list
	for i in get_node("TextureFrame/newgame/stage8/hobbycontainer/VBoxContainer").get_children():
		if i != get_node("TextureFrame/newgame/stage8/hobbycontainer/VBoxContainer/Button"):
			i.visible = false
			i.queue_free()

	#Build slave hobby list
	for i in slaveHobbies:
		var newbutton = get_node("TextureFrame/newgame/stage8/hobbycontainer/VBoxContainer/Button").duplicate()
		newbutton.visible = true
		newbutton.set_meta('hobby', i)
		if startSlaveHobby == i:
			newbutton.set_pressed(true)
		get_node("TextureFrame/newgame/stage8/hobbycontainer/VBoxContainer").add_child(newbutton)
		newbutton.set_text(i)
		newbutton.connect("pressed",self,'_slave_hobby', [newbutton])
	for i in slaveHobbiesExpanded:
		var newbutton = get_node("TextureFrame/newgame/stage8/hobbycontainer/VBoxContainer/Button").duplicate()
		newbutton.visible = true
		newbutton.set_meta('hobby', i)
		if startSlaveHobby == i:
			newbutton.set_pressed(true)
		get_node("TextureFrame/newgame/stage8/hobbycontainer/VBoxContainer").add_child(newbutton)
		newbutton.set_text(i)
		newbutton.connect("pressed",self,'_slave_hobby', [newbutton])

#QMod - Refactor
var forbiddentraits = ['Dominant','Submissive']
func _process_stage8_traits():
	#Clear trait list
	for i in $TextureFrame/newgame/stage8/traitpanel/ScrollContainer/VBoxContainer.get_children():
		if i.name != 'Button':
			i.visible = false
			i.queue_free()

	#Build trait list
	for i in globals.origins.traitlist.values():
		###---Added by Expansion---### Trait Support
		if i.tags.has("secondary") || i.tags.has("lockedtrait") || forbiddentraits.has(i):
			continue
		###---End Expansion---###
		var newbutton = $TextureFrame/newgame/stage8/traitpanel/ScrollContainer/VBoxContainer/Button.duplicate()
		newbutton.visible = true
		$TextureFrame/newgame/stage8/traitpanel/ScrollContainer/VBoxContainer.add_child(newbutton)
		newbutton.text = i.name

		newbutton.set_pressed(i.name == slaveTrait)
		newbutton.connect("pressed",self,'_trait_toggle',[i, newbutton]) #Connect list buttons to trait toggle method

#QMod - Incomplete refactor, removed firecheck
func _on_slaveconfirm_pressed():
	#Finish processing slave
	startSlave.cleartraits() #Clear traits, reset basics

	#Generate mental stats
	for i in ['conf','cour','wit','charm']:
		startSlave.stats[i+'_base'] = rand_range(30,35)
	startSlave.obed = 90
	startSlave.beautybase = variables.characterstartbeauty
	if startSlave.memory.find('$sibling') >= 0:
		globals.connectrelatives(startSlave, player, 'sibling')
	
	#Apply hobby bonus
	if startSlaveHobby == 'Physical':
		startSlave.cour += 25
		startSlave.stats.str_max += 1
	elif startSlaveHobby == 'Etiquette':
		startSlave.conf += 20
		startSlave.charm += 15
	#ralph3
	elif startSlaveHobby == 'Graceful':
		startSlave.conf += 10
		startSlave.stats.agi_max += 1
	#/ralph3
	elif startSlaveHobby == 'Magic':
		startSlave.wit += 25
		startSlave.stats.maf_max += globals.expansionsettings.magic_hobby_maf_max
	elif startSlaveHobby == 'Servitude':
		startSlave.stats.end_max += 1
		startSlave.loyal += 20
		startSlave.stats.obed_min += 35
	###---Added by Expansion---### New Hobbies
	elif startSlaveHobby == 'Curious':
		startSlave.add_trait('Gifted')
	elif startSlaveHobby == 'Genius':
		startSlave.add_trait('Clever')
		if rand_range(0,1) > .5:
			startSlave.add_trait('Responsive')
		else:
			startSlave.add_trait('Gifted')
		var random = rand_range(0,1)
		if random >= .7:
			startSlave.add_trait('Clumsy')
		elif random <= .3:
			startSlave.add_trait('Weak')
		else:
			startSlave.add_trait('Frail')
	elif startSlaveHobby == 'Socialite':
		startSlave.add_trait('Pretty voice')
		if rand_range(0,1) > .5:
			startSlave.add_trait('Natural Beauty')
		else:
			startSlave.add_trait('Ditzy')
		startSlave.add_trait('Fickle')
	elif startSlaveHobby == 'Waifu':
		startSlave.add_trait('Monogamous')
		startSlave.add_trait('Ascetic')
		startSlave.add_trait('Clingy')
		startSlave.add_trait('Fertile')
		startSlave.fetish.submission = 'mindblowing'
		startSlave.fetish.dominance = 'taboo'
		startSlave.knownfetishes.append('submission')
		startSlave.knownfetishes.append('dominance')
	elif startSlaveHobby == 'Perfect Specimen':
		startSlave.add_trait('Strong')
		startSlave.add_trait('Quick')
		startSlave.add_trait('Responsive')
		startSlave.add_trait('Robust')
	###---End Expansion---###

	#Add traits
	if slaveTrait != '':
		startSlave.add_trait(slaveTrait)

	startSlave.unique = 'startslave'

	###---Added by Expansion---### Ank Bugfix v4
	startSlave.health = 1000
	###---End Expansion---###

	globals.expansion.updatePerson(startSlave)
	if globals.state.relativesdata.has(startSlave.id):
		globals.state.relativesdata[startSlave.id].name = startSlave.name_long()
	#Assign start slave to global slave list
	globals.slaves = startSlave #A bit deceptive as it assigns 'person' to 'array', works because of 'setget'


	#Apply player racial bonuses
	###---Added by Expansion---### Races Expanded
	if player.race.find('Elf') >= 0 && player.race.find("Tribal Elf") < 0 && player.race.find("Dark Elf") < 0:
		player.stats.maf_base += 1
	elif player.race.find("Tribal Elf") >= 0:
		player.stats.agi_base += 1
	elif player.race.find('Orc') >= 0:
		globals.state.reputation.gorn += 30
	elif player.race.find('Demon') >= 0:
		for i in globals.state.reputation:
			globals.state.reputation[i] -= 10
		player.skillpoints += 1
	elif player.race.find('Taurus') >= 0:
		player.stats.end_base += 1
	elif player.race.find("Beastkin") >= 0:
		globals.state.reputation.frostford += 30
	elif player.race.find("Halfkin") >= 0:
		for i in globals.state.reputation:
			globals.state.reputation[i] += 15
	###---End Expansion---###
	else:
		globals.state.reputation.wimborn += 30

	#Add starting player abilities
	player.ability.append('escape')
	player.abilityactive.append('escape')
	player.ability.append("protect")
	player.abilityactive.append("protect")

	#Apply external player specialization bonuses
	globals.state.spec = player.spec
	if player.spec == 'Alchemist':
		globals.state.mansionupgrades.mansionalchemy += 1
	###---Added by Expansion---###
	elif player.spec == 'Breeder':
		globals.state.mansionupgrades.mansionnursery += 1
	###---End Expansion---###
	var tempitem
	if player.spec == 'Hunter':
		tempitem = globals.items.createunstackable("weapondagger")
		globals.state.unstackables[str(tempitem.id)] = tempitem
	else:
		tempitem = globals.items.createunstackable("weapondaggerrust")
		globals.state.unstackables[str(tempitem.id)] = tempitem


	#Set globals
	globals.guildslaves.wimborn = []
	globals.guildslaves.gorn = []
	globals.guildslaves.frostford = []
	globals.guildslaves.umbra = []

	#Apply Game-mode specific bonuses
	if isSandbox == false:
		globals.resources.upgradepoints = 5
		globals.resources.gold += 250
		globals.resources.food += 200
		globals.resources.mana += 10
		###---Added by Expansion---### Bubblepot's Grade Increase
		globals.player.origins = 'poor'
		###---End Expansion---###
	else:
		for i in globals.state.portals:
			var temp = globals.state.portals[i]
			if temp.code != startingLocation:
				temp.enabled = true
		globals.resources.upgradepoints = 30
		globals.resources.gold += 5000
		globals.resources.food += 500
		globals.resources.mana += 100

		globals.state.mainquest = 42
		globals.state.rank = 4
		globals.state.sidequests.brothel = 2
		globals.state.branding = 2
		globals.state.farm = 4
		globals.itemdict.youthingpot.unlocked = true
		globals.itemdict.maturingpot.unlocked = true
		globals.state.sidequests.sebastianumbra = 2
		###---Added by Expansion---### Bubblepot's Grade Increase
		globals.player.origins = 'noble'
		###---End Expansion---###
		globals.state.sandbox = true #Added this in case it used somewhere in the future?

	###---Added by Expansion---### Reset resources

	player.health = 1000
	globals.player = player
	###---Added by Expansion---###
	globals.expansion.updatePerson(globals.player)
	if globals.state.relativesdata.has(globals.player.id):
		globals.state.relativesdata[globals.player.id].name = globals.player.name_long()
	###---End Expansion---###
	globals.state.upcomingevents.append({code = 'ssinitiate', duration = 1})
	#Change scene to game start 'Mansion'
	globals.ChangeScene("Mansion")
	#self.queue_free()
	#get_tree().change_scene("res://files/Mansion.scn")
