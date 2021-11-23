extends Control

var location
var person
var public = false
var modFearObed = 1
var mood = 0.0 setget mood_set,mood_get
var fear = 0.0 setget fear_set
var stress = 0.0 setget stress_set
var fearStart
var obedStart
var stressStart
var loyalStart
var lustStart
var learningpointsStart
var date = false
var jail = false
var drunkness = 0.0
var actionhistory = []
var categories = ['Actions','P&P','Location','Items']
var locationarray = ['livingroom','town','dungeon','garden','bedroom']
var showntext = '' setget showtext_set,showtext_get
var turns = 0 setget turns_set,turns_get

var helpdescript = {
	mood = '[center]Mood[/center]\nA high mood increases loyalty and reduces stress after interaction is finished\nMood grows from positive interactions and decreases from negative interactions. Its also affected by loyalty.',
	fear = '[center]Fear[/center]\nFear helps to keep obedience high for long period of time. Its built with disciplinary actions but often comes with stress. ',
	stress = '[center]Stress[/center]\nStress accumulates from injury in combat,  poor treatment or unsanitary conditions\nHigh amounts of stress over a long period of time can reduce performance and loyalty',
}

func fear_set(value):
	var difference = value - fear
	if difference != 0:
		if difference > 0:
			$fear/Label.text = "+"
			$fear/Label.set("custom_colors/font_color", Color(1,0,0))
		else:
			$fear/Label.text = "—"
			$fear/Label.set('custom_colors/font_color', Color(0,1,0))
		$fear/Label/AnimationPlayer.play("fade")
	person.fear = value
	fear = person.fear
	$fear.value = value

func stress_set(value):
	var difference = value - stress
	if difference != 0:
		if difference > 0:
			$stress/Label.text = "+"
			$stress/Label.set("custom_colors/font_color", Color(1,0,0))
		else:
			$stress/Label.text = "—"
			$stress/Label.set('custom_colors/font_color', Color(0,1,0))
		$stress/Label/AnimationPlayer.play("fade")
	person.stress = value
	$stress.value = person.stress
	stress = person.stress

func mood_set(value):
	var difference = value - mood
	if difference != 0:
		if difference > 0:
			$mood/Label.text = "+"
			$mood/Label.set("custom_colors/font_color", Color(0,1,0))
		else:
			$mood/Label.text = "—"
			$mood/Label.set('custom_colors/font_color', Color(1,0,0))
		$mood/Label/AnimationPlayer.play("fade")
	if difference > 0:
		mood = max(0,value + difference*(person.loyal/400))
	else:
		mood = max(0,value)
	$mood.value = value*2

func mood_get():
	return mood

var actionsdict = {
	chat = {
		group = 'Actions',
		name = 'Chat',
		reqs = 'true',
		descript = 'Have a friendly chat',
		effect = 'chat',
		disablereqs = "person.traits.has('Mute')",
	},
	intimate = {
		group = "Actions",
		name = 'Intimate Talk',
		descript = 'Have an intimate talk',
		reqs = 'true',
		effect = 'intimate',
		disablereqs = "person.traits.has('Mute')",
	},
	touch = {
		group = "Actions",
		name = 'Touch',
		reqs = 'true',
		descript = 'Light physical contact',
		effect = 'touch',
	},
	holdhands = {
		group = "Actions",
		name = 'Hold hands',
		descript = "Take $name's hand into yours",
		reqs = "location in ['garden','town','bedroom']",
		effect = 'holdhands',
	},
	combhair = {
		group = "Actions",
		name = 'Comb Hair',
		descript = "Comb $name's hair",
		reqs = "true",
		effect = 'combhair',
	},
	hug = {
		group = "Actions",
		name = 'Hug',
		descript = "Prolonged close physical contact",
		reqs = "true",
		effect = 'hug',
	},
	kiss = {
		group = "Actions",
		name = 'Kiss',
		descript = "Kiss $name lightly",
		reqs = "true",
		effect = 'kiss',
	},
	frenchkiss = {
		group = "Actions",
		name = 'French Kiss',
		descript = "Kiss $name in an erotic manner",
		reqs = "true",
		effect = 'frenchkiss',
	},
	pushdown = {
		group = "Actions",
		name = 'Push down',
		descript = "Force yourself on $name. \n[color=yellow]Requires that you can interact with the slave at least 1 more time today.[/color]",
		reqs = "true",
		effect = 'pushdown',
		disablereqs = "!person.canInteract()",
	},
	proposal = {
		group = "Actions",
		name = 'Request intimacy',
		descript = "Ask $name if they would like to be intimate. \n[color=yellow]Requires that the slave can do 1 more interaction.[/color]",
		reqs = "true",
		effect = 'propose',
		disablereqs = "!person.canInteract()",
	},
	praise = {
		group = "P&P",
		name = 'Praise',
		descript = "Praise $name for $his previous success to encourage further good behavior",
		reqs = "true",
		effect = 'praise',
	},
	pathead = {
		group = "P&P",
		name = 'Pat head',
		descript = "Praise $name and pat $his head for $his previous success to encourage further good behavior",
		reqs = "true",
		effect = 'pathead',
	},
	scold = {
		group = "P&P",
		name = 'Scold',
		descript = "Scold $name for $his previous mistakes to re-enforce obedience",
		reqs = "true",
		effect = 'scold',
	},
	slap = {
		group = "P&P",
		name = 'Slap',
		descript = "Slap $name across the face to reprimand $him",
		reqs = "true",
		effect = 'slap',
	},
	flagellate = {
		group = "P&P",
		name = 'Flagellate',
		descript = "Spank $name as punishment",
		reqs = "location == 'dungeon'",
		effect = 'flag',
	},
	whip = {
		group = "P&P",
		name = 'Whipping',
		descript = "Whip $name as punishment",
		reqs = "location == 'dungeon'",
		effect = 'whip',
	},
	wax = {
		group = "P&P",
		name = 'Hot Wax',
		descript = "Torture with hot wax",
		reqs = "location == 'dungeon'",
		effect = 'wax',
	},
	woodenhorse = {
		group = "P&P",
		name = 'Wooden Horse',
		descript = "Torture with a wooden horse",
		reqs = "location == 'dungeon'",
		effect = 'horse',
	},
	publicpunish = {
		group = "P&P",
		name = 'Invite others',
		descript = "Invite other slaves to observe $name's punishments. Observing punishments builds fear and stress, although, at lower rate. However, it also gives punished more stress and lowers loyalty. ",
		reqs = "location == 'dungeon' && public == false",
		effect = 'public',
	},
	publicpunishoff = {
		group = "P&P",
		name = 'Disperse others',
		descript = "Make other slaves leave and not observe $name's punishments. ",
		reqs = "location == 'dungeon' && public == true",
		effect = 'public',
	},
	castfear = {
		group = "P&P",
		name = 'Cast Fear',
		descript = "Punish $name with Fear spell. \n[color=aqua]Costs " + str(globals.spells.spellcost(globals.spelldict.fear)) + " mana.[/color]",
		reqs = "globals.spelldict.fear.learned == true && globals.resources.mana >= globals.spells.spellcost(globals.spelldict.fear)",
		effect = 'castfear',
	},
	castsedate = {
		group = "P&P",
		name = 'Cast Sedation',
		descript = "Use Sedation spell on $name. \n[color=aqua]Costs " + str(globals.spells.spellcost(globals.spelldict.sedation)) + " mana.[/color]",
		reqs = "globals.spelldict.sedation.learned == true && globals.resources.mana >= globals.spells.spellcost(globals.spelldict.sedation)",
		effect = 'castsedate',
	},
	
	
	teach = {
		group = "Actions",
		name = 'Teach',
		descript = "Teach $name to accumulate learning points",
		reqs = "location in ['livingroom','garden']",
		effect = 'teach',
	},
	
	gift = {
		group = "Items",
		name = "Make Gift",
		descript = "Make a small decorative gift for $name. \n[color=yellow]Requires 10 gold.[/color]",
		reqs = "!location == 'dungeon'",
		disablereqs = 'globals.resources.gold < 10',
		effect = 'gift',
		onetime = true,
	},
	sweets = {
		group = "Items",
		name = "Buy Sweets",
		descript = "Purchase sweets from street vendor for $name\n[color=yellow]Requires 5 gold.[/color]",
		reqs = "location == 'town'",
		disablereqs = 'globals.resources.gold < 5',
		effect = 'sweets',
		onetime = true,
	},
	tea = {
		group = "Items",
		name = "Drink Tea",
		descript = "Serve tea for you and $name. [color=yellow]Requires 1 supply.[/color]",
		reqs = 'location in ["livingroom","bedroom"]',
		disablereqs = 'globals.itemdict.supply.amount < 1',
		effect = 'tea',
	},
	wine = {
		group = "Items",
		name = "Drink Wine",
		descript = "Serve wine for you and $name (Alcohol eases intimacy request but may cause a knockout). [color=yellow]Requires 2 supplies.[/color]",
		reqs = 'location in ["livingroom","bedroom","garden","town"]',
		disablereqs = 'globals.itemdict.supply.amount < 2',
		effect = 'wine',
	},
	stop = {
		group = "Actions",
		name = "Stop",
		descript = "Leave $name right now",
		reqs = 'true',
		effect = 'stop',
	},
}
onready var nakedspritesdict = {
	Cali = {cons = 'calinakedhappy', rape = 'calinakedsad', clothcons = 'calineutral', clothrape = 'calisad'},
	Tisha = {cons = 'tishanakedhappy', rape = 'tishanakedneutral', clothcons = 'tishahappy', clothrape = 'tishaneutral'},
	Emily = {cons = 'emilynakedhappy', rape = 'emilynakedneutral', clothcons = 'emily2happy', clothrape = 'emily2worried'},
	Chloe = {cons = 'chloenakedhappy', rape = 'chloenakedneutral', clothcons = 'chloehappy2', clothrape = 'chloeneutral2'},
	Maple = {cons = 'fairynaked', rape = 'fairynaked', clothcons = 'fairy', clothrape = 'fairy'},
	Yris = {cons = 'yrisnormalnaked', rape = 'yrisshocknaked', clothcons = 'yrisnormal', clothrape = 'yrisshock'},
	Ayneris = {cons = 'aynerisneutralnaked', rape = 'aynerisangrynaked', clothcons = 'aynerisneutral', clothrape = 'aynerisangry'},
	Zoe = {cons = "zoehappynaked", rape = 'zoesadnaked', clothcons = 'zoehappy', clothrape = 'zoesad'},
	Melissa = {cons = "melissanakedfriendly", rape = 'melissanakedneutral', clothcons = 'melissafriendly', clothrape = 'melissaneutral'},
}

var locationdicts = {
	livingroom = {code = 'livingroom',name = 'Living Room', background = 'mansion'},
	bedroom = {code = 'bedroom',name = 'Bedroom', background = 'mansion'},
	dungeon = {code = 'dungeon',name = 'Dungeon', background = 'jail'},
	garden = {code = 'garden',name = 'Garden', background = 'crossroads'},
	town = {code = 'town',name = 'Streets', background = 'localtown'},
}


var dateclassarray = []

class dateclass:
	var person
	var sex
	var name
	var lust = 0
	var lube = 0
	var sens = 0 

func _ready():
	for i in helpdescript:
		get_node(i).connect("mouse_entered",globals,'showtooltip',[helpdescript[i]])
		get_node(i).connect("mouse_exited",globals,'hidetooltip')

func initiate(tempperson):
	var text = ''
	self.visible = true
	self.mood = 0
	if tempperson.effects.has('drunk'):
		self.drunkness = max(0, tempperson.send)
	else:
		self.drunkness = 0
	globals.spells.caster = globals.player
	date = false
	public = false
	$sexswitch.visible = false
	$end.visible = false
	$textfield/RichTextLabel.clear()
	
	actionhistory.clear()
	dateclassarray.clear()
	
	
	person = tempperson
	person.recordInteraction()
	if person.race == 'Human':
		modFearObed = 1.5
	else:
		modFearObed = 1
	var newclass = dateclass.new()
	newclass.sex = globals.player.sex
	newclass.name = globals.player.name_short()
	newclass.person = globals.player
	dateclassarray.append(newclass)
	newclass = dateclass.new()
	newclass.person = person
	newclass.sex = person.sex
	newclass.name = person.name_short()
	dateclassarray.append(newclass)
	
	person.attention = 0
	
	jail = person.sleep == 'jail'
	
	self.stress = person.stress
	self.fear = person.fear
	self.obedStart = person.obed
	self.fearStart = person.fear
	self.stressStart = person.stress
	self.loyalStart = person.loyal
	self.lustStart = person.lust
	self.learningpointsStart = person.learningpoints
	self.turns = int(variables.timeformeetinteraction)
	$fullbody.set_texture(null)
	if nakedspritesdict.has(person.unique):
		if person.obed >= 50 || person.stress < 10:
			$fullbody.set_texture(globals.spritedict[nakedspritesdict[person.unique].clothcons])
		else:
			$fullbody.set_texture(globals.spritedict[nakedspritesdict[person.unique].clothrape])
	elif person.imagefull != null && globals.loadimage(person.imagefull) != null:
		$fullbody.set_texture(globals.loadimage(person.imagefull))
	$textfield/slaveportrait.texture = null
	
	if person.imageportait != null && globals.loadimage(person.imageportait):
		$textfield/slaveportrait.set_texture(globals.loadimage(person.imageportait))
	else:
		person.imageportait = null
		$textfield/slaveportrait.set_texture(null)
	if $textfield/slaveportrait.texture == null:
		$textfield/slaveportrait/TextureRect.visible = false
	else:
		$textfield/slaveportrait/TextureRect.visible = true
	
	$textfield/masterportrait.texture = null
	if globals.player.imageportait != null && globals.loadimage(globals.player.imageportait):
		$textfield/masterportrait.set_texture(globals.loadimage(globals.player.imageportait))
	else:
		globals.player.imageportait = null
		$textfield/masterportrait.set_texture(null)
	if $textfield/masterportrait.texture == null:
		$textfield/masterportrait/TextureRect.visible = false
	else:
		$textfield/masterportrait/TextureRect.visible = true
	
	
	
	if jail == true:
		get_parent().background = 'jail'
		location = 'dungeon'
		text = "You visit [name2] in [his2] cell and decide to spend some time with [him2]. "
		$panel/categories/Location.disabled = true
	else:
		$panel/categories/Location.disabled = false
		get_parent().background = 'mansion'
		location = 'livingroom'
		text = "You meet [name2] and order [him2] to keep you company. "
		if person.loyal >= 25:
			text += "[he2] gladly accepts your order and is ready to follow you anywhere you take [him2]. "
			self.mood += 10
		elif person.obed >= 90:
			self.mood += 4
			text += "[he2] obediently agrees to your order and tries [his2] best to please you. "
		else:
			
			text += "Without great joy [he2] obeys your order and reluctantly joins you. "
		if person.lust >= 30:
			mood += 6
		elif person.traits.has("Devoted"):
			mood += 10
	
	$panel/consent.visible = person.consent
	
	self.showntext = text
	updatelist()
	$panel/categories/Actions.emit_signal("pressed")

var category


func showtext_set(value):
	var text = decoder(value)
	$textfield/RichTextLabel.bbcode_text = text
	showntext = text

func showtext_get():
	return $textfield/RichTextLabel.bbcode_text

func turns_set(value):
	turns = value
	$turns/Label.text = 'x'+str(value)
	if turns == 0:
		endencounter()

func turns_get():
	return turns

func selectcategory(button):
	for i in $panel/categories.get_children():
		i.pressed = false
		if i.name == button:
			i.pressed = true
	category = button
	updatelist()

func endencounter():
	if $sexswitch.visible == false && $end.visible == false:
		var text = calculateresults()
		$end/RichTextLabel.bbcode_text = text
		$end.visible = true

func updatelist():
	for i in $panel/ScrollContainer/GridContainer.get_children():
		if i.name != 'Button':
			i.visible = false
			i.queue_free()
	$textfield/Label.text = locationdicts[location].name
	for i in actionsdict.values():
		if evaluate(i.reqs) == true && i.group == category:
			if i.has('onetime') && checkhistory(i.effect) > 0:
				continue
			var newnode = $panel/ScrollContainer/GridContainer/Button.duplicate()
			$panel/ScrollContainer/GridContainer.add_child(newnode)
			newnode.visible = true
			newnode.text = person.dictionary(i.name)
			newnode.connect("pressed",self,'doaction', [i.effect])
			newnode.connect("mouse_entered",self,'actiontooltip', [i.descript])
			newnode.connect("mouse_exited",globals,'hidetooltip')
			if i.has('disablereqs') && evaluate(i.disablereqs):
				newnode.disabled = true
	if category == 'Location':
		for i in locationdicts.values():
			if i.code == location:
				continue
			var newnode = $panel/ScrollContainer/GridContainer/Button.duplicate()
			$panel/ScrollContainer/GridContainer.add_child(newnode)
			newnode.visible = true
			newnode.text = "Move to "+ i.name
			newnode.connect("pressed",self,'moveto', [i.code])
#			newnode.connect("mouse_entered",self,'actiontooltip', [i.descript])
#			newnode.connect("mouse_exited",globals,'hidetooltip')
	globals.hidetooltip()
	$panel/ScrollContainer/GridContainer.move_child($panel/ScrollContainer/GridContainer/Button, $panel/ScrollContainer/GridContainer.get_children().size())
	$mana/Label.text = str(globals.resources.mana)
	$gold/Label.text = str(globals.resources.gold)
	$supply/Label.text = str(globals.itemdict.supply.amount)

func moveto(newloc):
	self.location = newloc
	if locationdicts[location].background != 'localtown':
		get_parent().background = locationdicts[location].background
	else:
		get_parent().background = globals.state.location
	if OS.get_name() != 'HTML5':
		yield(get_parent(),'animfinished')
	self.showntext = 'You lead [name2] to the [color=yellow]' + locationdicts[location].name + '[/color]. '
	if date == false && !newloc in ['bedroom','dungeon']:
		date = true
		self.showntext += "\n[color=green][name2] seems to be quite happy to be taken out of the usual place and ready to spend with you some additional time. [/color]"
	
	updatelist()

func actiontooltip(descript):
	globals.showtooltip(person.dictionary(descript))

func evaluate(input): #used to read strings as conditions when needed
	var script = GDScript.new()
	script.set_source_code("var person\nvar location\nvar public\nfunc eval():\n\treturn " + input)
	script.reload()
	var obj = Reference.new()
	obj.set_script(script)
	obj.person = person
	obj.location = location
	obj.public = public
	return obj.eval()


func decoder(text):
	text = get_parent().get_node("interactions").decoder(text, [dateclassarray[0]], [dateclassarray[1]])
	return text

func doaction(action):
	self.showntext = decoder(call(action, person, checkhistory(action)))
	self.turns -= 1
	actionhistory.append(action)
	
	if turns%3:
		if location == 'bedroom':
			self.showntext += decoder("\n\n[color=yellow]Location influence:[/color] [name2] seems to be getting more into intimate mood...")
			person.lust += rand_range(2,3)
		elif location == 'garden' && person.conf < 50:
			self.mood += 3
			self.showntext += decoder("\n\n[color=yellow]Location influence:[/color] [name2] finds this place to be rather peaceful...")
		elif location == 'town' && person.conf >= 50:
			self.mood += 3
			self.showntext += decoder("\n\n[color=yellow]Location influence:[/color] [name2] finds this place to be rather joyful...")
		elif location == 'dungeon':
			self.fear += 4
			self.showntext += decoder("\n\n[color=yellow]Location influence:[/color] [name2] finds this place to be rather grim...")
	checkPassOut()
	updatelist()

func checkhistory(action):
	var counter = 0
	for i in actionhistory:
		if i == action:
			counter += 1
	return counter

func chat(person, counter):
	var text = ''
	text += "You attempt to initiate a friendly chat with [name2]. "
	
	if counter < 3 || randf() >= counter/10.0+0.1:
		text += "[name2] spends some time engaging in a friendly chat with you. "
		self.mood += 2
	else:
		self.mood -= 1
		text += "[name2] replies, but does so reluctantly. "
	
	
	return text

func intimate(person, counter):
	var text = ''
	text += "You talk to [name2] about personal matters. "
	
	if randf() >= counter/10.0 && self.mood >= 7 && person.loyal >= 10:
		text += "[he2] opens to you"
		self.mood += 3
		person.loyal += rand_range(2,5)
		if person.loyal >= 30 && randf() >= 0.65:
			text += ' and moves slightly closer'
			person.lust += 5
		text += '. '
	elif counter >= 5 && randf() >= 0.5:
		self.mood -= 1
		text += "[he2] looks at you contemplatively, but fails to make a connection. "
	else:
		self.mood -= 2
		text += "[he2] gives you an awkward look. "
	
	
	return text

func touch(person, counter):
	var text = ''
	text += "You casually touch [name2] in various places. "
	
	if counter < 3 && person.obed >= 80:
		text += "[he2] reacts relaxingly to your touch"
		self.mood += 2
		if person.loyal >= 10 && randf() >= 0.65:
			text += ' and touches you back'
			person.lust += 3
		text += '. '
	else:
		self.mood -= 1
		text += "[he2] reacts coldly to your touch. "
	return text

func holdhands(person, counter):
	var text = ''
	if location != 'bedroom':
		text += "You take [name2]'s hand into yours and stroll around. "
	else:
		text += "You take [name2]'s hand into yours and move closer. "
	if (counter < 3 || randf() >= 0.4) && self.mood >= 4:
		text += "[he2] holds your hand firmly. "
		self.mood += 2
		person.loyal += rand_range(2,3)
	else:
		self.mood -= 1
		text += "[he2] holds your hand, but looks reclusive. "
	
	return text

func combhair(person, counter): #play with hair would make more sense?
	var text = ''
	text += "You gently comb [name2]'s hair. "
	
	if (counter < 3 || randf() >= 0.8) && self.mood >= 4:
		text += "[he2] smiles and looks pleased. "
		self.mood += 2
		person.loyal += rand_range(2,3)
	else:
		self.mood -= 1
		text += "[he2] looks uncomfortable. "
	
	return text


func hug(person, counter): 
	var text = ''
	text += "You embrace [name2] in your arms. "
	
	if (counter < 3 || randf() >= 0.7) && self.mood >= 6:
		text += "[he2] embraces you back resting [his2] head on your chest. "
		self.mood += 3
		person.lust += 3
		person.loyal += rand_range(2,3)
	else:
		self.mood -= 2
		text += "[he2] does not do anything waiting uncomfortably for you to finish. "
	
	return text

func kiss(person, counter): 
	var text = ''
	text += "You gently kiss [name2] on the cheek. "
	
	if (self.mood >= 4 || person.loyal >= 15):
		text += "[he2] blushes and looks away. "
		self.mood += 3
		person.lust += 1
	else:
		self.mood -= 2
		text += "[he2] abruptly stops you, showing [his2] disinterest. "
	
	return text

func frenchkiss(person, counter): 
	var text = ''
	text += "You invade [name2]'s mouth with your tongue. "
	
	if (self.mood >= 10 && person.lust >= 20) || person.loyal >= 25:
		text += "[he2] closes eyes passionately accepting your kiss. "
		if checkAcceptSexPairing(person):
			self.mood += 3
			person.lust += 3
		else:
			self.mood += 1
			person.lust += 1
	else:
		self.mood -= 4
		text += "[he2] abruptly stops you, showing [his2] disinterest. "
	
	return text

func pushdown(person, counter):
	var text = ''
	var mode
	text += "You forcefully push [name2] down giving [him2] a sultry look. "
	if person.consent:
		text += "[he2] is briefly overwhelmed, but looks at you eagerly. "
		self.mood += 6
		person.lust += 6
		mode = 'sex'
	else:
		var difficulty = 400
		if person.effects.has('captured'):
			difficulty += 100
		if person.effects.has('drunk'):
			difficulty /= 2
		difficulty -= person.obed*3 + person.loyal*2 + person.lust - person.lewdness/3
		if person.traits.has("Likes it rough"):
			difficulty -= 60

		if difficulty > 0 && !person.traits.has('Sex-crazed'):
			self.mood -= 10
			text += "[he2] resists and pushes you back. "
			mode = 'abuse'
		else:
			text += "[he2] closes eyes and silently accepts you. "
			self.mood += 3
			person.lust += 3
			mode = 'rapeconsent'
	showsexswitch(text,mode)
	return ''

func propose(person, counter):
	var text = ''
	var mode
	if person.consent == true:
		text = "[name2] previously gave you [his2] consent and you proceed with your intentions. "
		mode = 'sex'
		globals.state.sexactions += 1
		showsexswitch(text, mode)
		text = ''
	else:
		text += "You ask [name2] if [he2] would like to take your relationship to the next level. "
		var difficulty =  300 - (self.mood + person.obed*3 + person.loyal*2 + person.lust + drunkness*10)
		if person.effects.has('captured'):
			difficulty += 100
		if !checkAcceptSexPairing(person):
			difficulty += 60
		###---Added by Expansion---### Incest
		if globals.expansion != null:
			if globals.expansion.relatedCheck(person, globals.player) != 'unrelated':
				if !person.checkFetish('incest'):
					difficulty += 60
		else:
			if globals.state.relativesdata.has(person.id) && (int(globals.state.relativesdata[person.id].father) == int(globals.player.id) || int(globals.state.relativesdata[person.id].mother) == int(globals.player.id)):
				difficulty += 60
		###---Expansion End---###
		if person.traits.has('Prude'):
			difficulty +=30
		if difficulty >= 0:
			text += "[he2] shows a troubled face and rejects your proposal. "
			self.mood -= 4
		else:
			person.lust += 3
			person.consent = true
			mode = 'sex'
			text += "[he2] gives a meek nod and you lead [him2] to bedroom."
			text += "\n\n[color=green]Unlocked sexual actions with [name2].[/color]"
			if person.levelupreqs.has('code') && person.levelupreqs.code == 'relationship':
				text += "\n\n[color=green]After getting closer with [name2], you felt like [he2] unlocked new potential. [/color]"
				person.levelup()
			globals.state.sexactions += 1
			showsexswitch(text, mode)
			text = ''
			
	return text
	

var sexmode

func showsexswitch(text, mode):
	$sexswitch.visible = true
	sexmode = mode
	$end/RichTextLabel.bbcode_text = text
	if mode == 'abuse':
		text += "\n[color=yellow]Rape [name2] anyway?[/color]"
		$sexswitch/confirmsex.visible = true
		$sexswitch/cancelsex.visible = true
	elif mode == 'rapeconsent':
		sexmode = 'sex'
		$sexswitch/confirmsex.visible = true
		$sexswitch/cancelsex.visible = false
	elif mode == 'sex':
		$sexswitch/confirmsex.visible = true
		$sexswitch/cancelsex.visible = false
	
	text = decoder(text) 
	if $sexswitch/cancelsex.visible == false:
		text += calculateresults()
	$sexswitch/RichTextLabel.bbcode_text = text

func praise(person, counter):
	var text = ''
	text += "You praise [name2] for [his2] recent behavoir. "
	
	if person.obed >= 85 && counter < 2:
		self.mood += 3
		self.stress -= rand_range(5,10)
		text = text + "[he2] listens to your praise with joy evident on [his2] face.  "
	elif person.obed >= 85:
		text = text + "[he2] takes your words respectfully but without great joy. You’ve probably overpraised [him2] lately. "
		
	else:
		text = text + "[he2] takes your praise arrogantly, gaining joy from it. "
		self.mood += 3
		person.loyal -= rand_range(1,2)
	
	return text

func pathead(person, counter):
	var text = ''
	text += "You pat [name2]'s head and praise [him2] for [his2] recent behavior. "
	
	if counter < 5 || randf() >= 0.4:
		self.mood += 2
		self.stress -= 3
		text = text + "[he2] takes it with joy evident on [his2] face.  "
	else:
		text = text + "[he2] seems to be bored from repeated action. "
		self.mood -= 1
	return text

func scold(person, counter):
	var text = ''
	text += "You scold [name2] for [his2] recent faults. "
	self.mood -= 2
	self.fear += 7 * modFearObed
	
	text += punishaddedeffect()
	return text


func punishaddedeffect():
	var text = ''
	self.stress += 8
	if person.traits.has("Masochist") && randf() >= 0.5:
		text += "[Masochist][name2] seems to take [his2] punishment with some unusual enthusiasm... "
		person.lust += rand_range(2,4)
		self.mood += 3
		self.stress -= 5
	if person.traits.has("Coward"):
		self.fear += 5 * modFearObed
		text += "[Coward][name2] reacts strongly to your aggression. "
	if public == true:
		var slavearray = []
		for i in globals.slaves:
			if i.away.duration == 0 && i.sleep != 'farm' && i != person:
				slavearray.append(i)
		if slavearray.size() > 0:
			text += "\n\n[color=yellow]Invited slaves watch over [name2] in awe. [/color] "
			self.stress += 4
			for i in slavearray:
				if i.race == 'Human':
					i.fear += 4.5
				else:
					i.fear += 3
				i.stress += 3
				if actionhistory.back() in ['woodenhorse','flagellate']:
					i.lust += 2
	return text

func slap(person, counter):
	var text = ''
	text += "You slap [name2] across the face as punishment. [his2] cheek gets red. "
	self.fear += 6 * modFearObed
	self.mood -= 2
	text += punishaddedeffect()
	return text

func flag(person, counter):
	var text = ''
	text += "You put [name2] on the punishment table, and after exposing [his2] rear, punish it with force. "
	
	self.fear += 9 * modFearObed
	self.mood -= 3
	
	text += punishaddedeffect()
	return text

func whip(person, counter):
	var text = ''
	text += "You put [name2] on the punishment table, and after exposing [his2] rear, whip it with force. "
	
	self.fear += 11 * modFearObed
	self.mood -= 3
	
	text += punishaddedeffect()
	return text

func horse(person, counter):
	var text = ''
	text += "You tie [name2] securely to the wooden horse with [his2] legs spread wide. [he2] cries with pain under [his2] own weight. "
	
	self.fear += 12 * modFearObed
	self.mood -= 4
	person.lust += rand_range(5,10)
	
	text += punishaddedeffect()
	
	return text

func wax(person, counter):
	var text = ''
	text += "You put [name2] on the punishment table and after exposing [his2] body you drip hot wax over it making [him2] cry with pain. "
	
	self.fear += 11 * modFearObed
	self.mood -= 3
	
	text += punishaddedeffect()
	
	return text

func teach(person, counter):
	var text = ''
	var value = round(3 + person.wit/12) - drunkness*2
	if person.traits.has("Clever"):
		value += value*0.25
	text += "You spend some time with [name2], teaching [him2]. "
	
	if stress < 10+person.wit/2 || counter < 4:
		person.learningpoints += max(0, round(value))
		self.mood -= 1
		self.stress += 10 - person.wit/15
		text += "[name2] learns new things under your watch. " 
		if person.traits.has("Clever"):
			text += "\n[Clever]Bonus points"
	else:
		text += "[name2] looks heavily bored, not taking the lesson seriously. " 
	
	if drunkness > 0:
		text += "\nLesson was less effective due to [name2]'s alcohol intoxication. "
	
	return text

func gift(person, counter):
	var text = ''
	text += "You present [name2] with a small decorative gift. "
	
	if person.obed >= 75:
		self.mood += 7
		person.loyal += 4
		text = text + "[he2] accepts your gift with a pleasant smile on [his2] face.  "
		
	else:
		text = text + "[he2] takes your gift arrogantly, barely respecting your intention. "
		self.mood += 3
	
	
	globals.resources.gold -= 10
	
	return text

func sweets(person, counter):
	var text = ''
	text += "You purchase some candies for [name2] from a local vendor. "
	
	if person.obed >= 55:
		self.mood += 6
		person.loyal += 3
		text = text + "[he2] joyfull accepts them and enjoys the sweet taste.  "
		
	else:
		text = text + "[he2] takes your gift arrogantly, barely respecting your intention. "
		self.mood += 3
	
	
	globals.resources.gold -= 5
	
	return text


func tea(person, counter):
	var text = ''
	text += "You serve tea for you and [name2]. While drinking, you both chatand get a bit closer.  "
	
	if counter <= 3 || randf() >= 0.5:
		self.mood += 5
		self.stress -= rand_range(2,5)
		text += "[name2] seems to be pleased with your generosity and enjoys your company. "
	else:
		self.mood += 1
	
	globals.itemdict.supply.amount -= 1
	
	return text

func wine(person, counter):
	var text = ''
	text += "You serve fresh wine for you and [name2]. "
	
	if self.mood < 23 && person.obed < 80:
		text = "[he2] refuses to drink with you. "
	else:
		if counter < 3:
			text += "[he2] drinks with you and [his2] mood seems to improve."
			self.mood += 4
			self.stress -= rand_range(6,12)
		else:
			self.mood += 2
			text += "[he2] keeps you company, but the wine does not seem to affect [him2] as heavily as before. "
		if person.traits.has("Alcohol Intolerance"):
			drunkness += 2
		else:
			drunkness += 1
		
		globals.itemdict.supply.amount -= 2
	
	return text

func castfear(person, counter):
	var text = ''
	var spell = globals.spelldict.fear
	person.metrics.spell += 1
	var spellnode = globals.spells
	spellnode.person = person
	text = spellnode.call(spell.effect)
	updatebars()
	return text

func castsedate(person, counter):
	var text = ''
	var spell = globals.spelldict.sedation
	person.metrics.spell += 1
	var spellnode = globals.spells
	spellnode.person = person
	text = spellnode.call(spell.effect)
	updatebars()
	return text


func public(person, counter):
	var text = ''
	public = !public
	if public == true:
		text = "You order everyone into dungeon and make them watch over [name2]'s disgrace. "
	else:
		text = "You order everyone to get back to their business leaving you and [name2] alone. "
	return text

func updatebars():
	self.fear = person.fear
	self.stress = person.stress

func stop(person, counter):
	var text = ''
	turns = 1
	return text

func checkAcceptSexPairing(person):
	###---AricExpansion---### Sexuality
	if globals.expansion != null:
		return globals.expansion.getSexualAttraction(person,globals.player)
	else:
		if person.traits.has("Bisexual"):
			return true
		if person.sex == globals.player.sex || (person.sex in ['female', 'futanari', 'dickgirl'] && globals.player.sex in ['female', 'futanari','dickgirl']):
			return person.traits.has('Homosexual')
	###---End Expansion---###
	return true

func checkPassOut():
	if drunkness > max(0, person.send*2) + 1:
		person.away.duration = 1
		person.away.at = 'rest'
		endencounter()
		$end/RichTextLabel.bbcode_text += decoder('\n\n[color=yellow][name2] has passed out from alcohol overdose. [/color]')
	elif drunkness > max(0, person.send) + 1 && !person.effects.has('drunk'):
		person.add_effect(globals.effectdict.drunk)
		$end/RichTextLabel.bbcode_text += decoder("\n\n[color=yellow][name2] drunkenly sways in place and slightly slurs [his2] words. [/color]")

func strChange(value):
	if value > 0:
		return "+" + str(round(value))
	else:
		return str(round(value))

func calculateresults():
	var text = ''
	globals.hidetooltip()
	var tempfear = fear
	var loyal = 2 + (mood / 10)
	var obed = mood / 1.5 * modFearObed
	self.fearStart = person.fear - self.fearStart
	self.obedStart = person.obed - self.obedStart
	self.stressStart = person.stress - self.stressStart
	self.loyalStart = person.loyal + loyal - self.loyalStart
	self.lustStart = person.lust - self.lustStart
	self.learningpointsStart = person.learningpoints - self.learningpointsStart
	text += "\nMood Bonus: "
	text += "\nObedience: " + strChange(obed) + "\nLoyalty: " + strChange(loyal)
	text += "\n\nFinal results: "
	text += "\nFear: " + strChange(self.fearStart) + "\nObedience: " + strChange(obed) + "\nStress: " + strChange(self.stressStart)
	text += "\nLoyalty: " + strChange(self.loyalStart) + "\nLust: " + strChange(self.lustStart) + "\nLearning Points: " + strChange(self.learningpointsStart)
	var dict = {loyal = loyal, obed = obed}
	
	for i in dict:
		person[i] += dict[i]
	return text


func _on_finishbutton_pressed():
	get_parent()._on_mansion_pressed()
	if OS.get_name() != 'HTML5':
		yield(get_parent(),'animfinished')
	self.visible = false

func _on_cancelsex_pressed():
	$sexswitch.visible = false

func _on_confirmsex_pressed():
	if $sexswitch/cancelsex.visible == true:
		calculateresults()
	self.visible = false
	get_parent().sexmode = 'sex'
	get_parent().sexslaves = [person]
	get_parent()._on_startbutton_pressed()
	yield(get_parent(),'animfinished')
	get_parent().sexmode = 'meet'
	get_parent().backgroundinstant('mansion')

