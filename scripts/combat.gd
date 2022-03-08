
func start_battle(nosound = false):
	get_parent().animationfade(0.4)
	instantanimation = globals.rules.instantcombatanimation
	resetpanels()
	yield(get_parent(),'animfinished')
	get_node("autowin").visible = get_parent().get_node("new slave button").visible
	var _slave
	var combatant
	trapper = null
	enemyturn = false
	globals.main.get_node("outside").hide()
	globals.main.get_node("ResourcePanel").hide()
	turns = 1
	self.combatlog = ''
	playergroup.clear()
	enemygroup.clear()
	combatantnodes.clear()
	for i in $enemypanel.get_children() + $grouppanel.get_children():
		if i.get_class() == 'TextureButton':
			i.hide()
			i.free()
			#i.queue_free()
	
	if nosound == false:
		globals.main.music_set('combat')
	self.visible = true
	ongoinganimation = false
	combatlog = ''
	var slavearray = []
	for i in globals.state.playergroup:
		slavearray.append(globals.state.findslave(i))
	for i in [globals.player] + slavearray:
		var newcombatant = self.combatant.new()
		var newbutton = $grouppanel/groupline/character.duplicate()
		$grouppanel/groupline.add_child(newbutton)
		newcombatant.node = newbutton
		newcombatant.scene = self
		newcombatant.createfromslave(i)
		newbutton.get_node("portrait").texture = globals.loadimage(newcombatant.portrait)
		newbutton.connect('pressed', newcombatant, 'selectcombatant')
		newbutton.connect('mouse_entered', newcombatant, 'combatanttooltip')
		newbutton.connect("mouse_exited", newcombatant, 'hidecombatanttooltip')
		newbutton.get_node("info").connect("pressed",self,'showinfochar',[newcombatant])
		newbutton.visible = true
		playergroup.append(newcombatant)
		newbutton.set_meta('combatant', newcombatant)
		checkforinheritdebuffs(newcombatant)
		combatantnodes.append(newbutton)
	
	for i in playergroup:
		if i.person.spec == 'trapper':
			trapper = i


	for i in currentenemies:
		var newcombatant = self.combatant.new()
		var newbutton = $enemypanel/enemyline/character.duplicate()
		$enemypanel/enemyline.add_child(newbutton)
		newcombatant.node = newbutton
		newbutton.set_meta('combatant', newcombatant)
		newcombatant.scene = self
		newbutton.connect('pressed', newcombatant, 'selectcombatant')
		newbutton.connect('mouse_entered', newcombatant, 'combatanttooltip')
		newbutton.connect("mouse_exited", newcombatant, 'hidecombatanttooltip')
		newbutton.visible = true
		if nocaptures == false && i.capture != null:
			newcombatant.createfromslave(i.capture, i)
		else:
			newcombatant.createfromdata(i)
		newbutton.get_node("portrait").texture = globals.loadimage(newcombatant.portrait)
		newcombatant.name = i.name
		enemygroup.append(newcombatant)
		combatantnodes.append(newbutton)
	
	###---Added by Expansion---### Category: NPCs Expanded | Enemies can be related
	var relatedbaddies = false
	for i in enemygroup:
		#i.capture didn't work?
		for k in enemygroup:
			if i.person != null && k.person != null && i.person != k.person:
				var person = i.person
				var person2 = k.person
				#Setting Framework for Personality Matches later
				if person.race == person2.race && rand_range(0,100) <= globals.expansion.npcrelatedchance:
					globals.expansion.setFamily(person,person2)
					relatedbaddies = true
				else:
					var bonusmin = 0
					var bonusmax = 0
					var relationlottery = 0
					if rand_range(0,1) <= .2:
						bonusmin = 0
						bonusmax = 900
						relationlottery = round(rand_range(bonusmin,bonusmax))
					else:
						bonusmin = -500
						bonusmax = 500
						relationlottery = round(rand_range(bonusmin,bonusmax))
					globals.addrelations(person, person2, relationlottery)

	#Equalize Genes
	for i in enemygroup:
		if i.person != null:
			globals.expansion.correctGenes(i.person)
	###---End Expansion---###
	
	$grouppanel/skilline/skill.set_meta('skill', {})
	nocaptures = false
	#if OS.get_name() != 'HTML5':
	yield(get_tree(),'idle_frame')
	for i in $grouppanel/groupline.get_children():
			if i.name != 'character':
				var pos = i.rect_global_position
				$grouppanel/groupline.remove_child(i)
				$grouppanel.add_child(i)
				i.rect_global_position = pos
	for i in $enemypanel/enemyline.get_children():
			if i.name != 'character':
				var pos = i.rect_global_position
				$enemypanel/enemyline.remove_child(i)
				$enemypanel.add_child(i)
				i.rect_global_position = pos
	period = 'base'
	
	if globals.state.tutorial.combat == false:
		globals.main.get_node("tutorialnode").combat()

func _process(delta):
	if self.visible == false:
		return
	$resources/mana/Label.text = str(globals.resources.mana)
	$resources/turns/Label.text = str(turns)
	$period.text = period
	
	if animationskip == true:
		animationskip = false
		tweenfinished()
	
	if period == 'nextturn' && ongoinganimation == false:
		turns += 1
		period = 'base'
		self.combatlog += "\n[center]Turn " + str(turns) + "[/center]"
	
	for i in combatantnodes:
		var combatant = i.get_meta('combatant')
		
		if ongoinganimation:
			break
		
		i.get_node("name").text = combatant.name
		var hpPercent = (combatant.hp/combatant.hpmax)*100
		if !i.get_node("hp").has_meta('hp') || i.get_node("hp").get_meta('hp') != hpPercent:
			$Tween.interpolate_property(i.get_node("hp"), "value", i.get_node('hp').value, hpPercent, 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()
			i.get_node("hp").set_meta('hp', hpPercent)
			#i.get_node("hp").value = (combatant.hp/combatant.hpmax)*100
		i.get_node("hp/Label").text = str(ceil(combatant.hp)) + "/" + str(combatant.hpmax)
		if combatant.group == 'enemy' && playergroup.size() > 0 && playergroup[0].effects.has('mindreadeffect'):
			i.get_node("hp/Label").visible = true
		elif combatant.group == 'enemy':
			i.get_node('hp/Label').visible = false
		if i.has_node("en"):
			i.get_node("en").value = float(combatant.energy)/combatant.energymax*100
			i.get_node("en/Label").text = str(ceil(combatant.energy)) + "/" + str(combatant.energymax)
		if i.has_node('stress') && combatant.person != globals.player:
			i.get_node('stress').visible = true
			i.get_node('stress/Label').text = str(floor(combatant.stress))
			i.get_node('stress').value = round(float(combatant.stress)/combatant.stressmax*100)
		
	
	#Reset panel textures
	###---Added by Expansion---### Ank BugFix v4a
	for i in $enemypanel.get_children():
		if i.get_class() == 'TextureButton':
			if period == 'skilltarget' && targetskill.targetgroup == 'enemy':
				i.set_normal_texture(enemypaneltextures.target)
			else:
				i.set_normal_texture(enemypaneltextures.normal)
	for i in $grouppanel.get_children():
		if i.get_class() == 'TextureButton':
			if period == 'skilltarget' && targetskill.targetgroup == 'ally':
				i.set_normal_texture(playerpaneltextures.target)
			elif i.get_meta('combatant').actionpoints <= 0:
				i.set_normal_texture(playerpaneltextures.disabled)
			else:
				i.set_normal_texture(playerpaneltextures.normal)
			if selectedcharacter == null && i.get_meta('combatant').actionpoints > 0:
				i.emit_signal('pressed')
	###---End Expansion---###
	
	#Set cursor and skill pressed
	if period == 'skilltarget':
		Input.set_custom_mouse_cursor(load("res://files/buttons/kursor_act.png"))
		for i in $grouppanel/skilline.get_children():
			i.pressed = i.get_meta("skill") == targetskill
	else:
		Input.set_custom_mouse_cursor(load("res://files/buttons/kursor.png"))
		for i in $grouppanel/skilline.get_children():
			i.pressed = false

func _input(event):
	if event.is_echo() == true || event.is_pressed() == false || get_node("abilitites/Panel").visible == true || is_visible_in_tree() == false:
		return
	#Cancel skill by rightclick
	if period == 'skilltarget' && (event.is_action_pressed("RMB") || event.is_action_pressed("escape")):
		period = 'base'
		selectedcharacter.selectcombatant()
	#Select ability by 1-8 nums
	if str(event.as_text()) in str(range(1,9)):
		if self.visible == true && $win.visible == false && $grouppanel/skilline.get_children().size() > int(event.as_text()) && $grouppanel/skilline.get_child(int(event.as_text())).disabled == false:
			get_node("grouppanel/skilline").get_child(int(event.as_text())).emit_signal('pressed')
	#select characters
	if event.as_text().length() in [2,3] && event.as_text()[0] == 'F' && $win.visible == false:
		var value = int(event.as_text().right(1))
		if period == 'base':
			if playergroup.size() >= value:
				playergroup[value-1].node.emit_signal('pressed')
		###---Added by Expansion---### Ank BugFix v4a
		elif period == 'skilltarget':
			if targetskill.targetgroup == 'enemy' && enemygroup.size() >= value:
				enemygroup[value-1].node.emit_signal('pressed')
			elif targetskill.targetgroup == 'ally' && playergroup.size() >= value:
				playergroup[value-1].node.emit_signal('pressed')
		###---End Expansion---###
	#End turn
	if event.is_action_pressed("F") == true && $confirm.disabled == false && $win.visible == false:
		_on_confirm_pressed()

class combatant:
	var person
	var group
	var state = 'normal'
	var panel
	var name
	var hp setget health_set, health_get
	var hpmax
	var energy
	var energymax
	var stress = 0
	var stressmax = 0
	var lust
	var lustmax
	var passives = {}
	var attack = 0
	var magic = 0
	var armor = 0
	var protection = 0
	var speed = 0
	var portrait
	var target
	var geareffects = []
	var abilities
	var activeabilities
	var node
	var scene
	var cooldowns = {}
	var actionpoints = 1
	var effects = {}
	var faction
	
	var animationplaying = false
	
	var ai = ''
	var aimemory = ''
	
	
	func createfromdata(data):
		name = data.name
		portrait = data.icon
		if person == globals.player || (globals.slaves.has(person) && globals.state.playergroup.has(person.id)):
			group = 'player'
		else:
			group = 'enemy'
		abilities = data.stats.abilities
		#Filling values
		
		###---Added by Expansion---###
		if person != null:
			globals.expansion.updatePerson(person)
		###---End Expansion---###

		if data.has('faction'):
			faction = data.faction
		
		hp = data.stats.health
		hpmax = data.stats.health
		energy = data.stats.energy
		
		attack = data.stats.power
		armor = data.stats.armor
		speed = data.stats.speed
		magic = data.stats.magic
		
		if data.stats.has("passives"):
			for i in data.stats.passives:
				var passive = globals.abilities.passivesdict[i]
				self.passives[passive.effect] = passive
		
		ai = 'attack'
		if scene.get_parent().get_node("explorationnode").deeperregion && !scene.nocaptures:
			attack = ceil(attack * 1.25)
			hpmax = ceil(hpmax * 1.5)
			hp = hpmax
			speed = ceil(speed + 5)
		
	
	func createfromslave(person, data = null):
		name = person.name_short()
		self.person = person
		if person == globals.player || (globals.slaves.has(person) && globals.state.playergroup.has(person.id)):
			group = 'player'
			portrait = person.imageportait
		else:
			group = 'enemy'
			portrait = data.icon
			if person.sex != 'male' && data.has('iconalt'):
				portrait = data.iconalt
		abilities = person.ability.duplicate()
		activeabilities = person.abilityactive
		if data != null:
			for i in data.stats.abilities:
				abilities.append(i)
		
		###---Added by Expansion---###
		if person != null:
			globals.expansion.updatePerson(person)
		###---End Expansion---###
		
		#Filling values
		
		hp = person.health
		hpmax = person.stats.health_max
		energy = person.energy
		energymax = person.stats.energy_max
		stress = person.stress
		stressmax = person.stats.stress_max
		lust = person.lust
		lustmax = person.stats.lust_max
		
		attack = variables.baseattack + floor(person.level/2)
		magic = person.smaf
		armor = person.stats.armor_cur
		speed = variables.speedbase + (person.sagi * variables.speedperagi)
		ai = 'attack'
		
		if data != null && data.stats.has("passives"):
			for i in data.stats.passives:
				var passive = globals.abilities.passivesdict[i]
				self.passives[passive.effect] = passive
		
		###---Added by Expansion---### Races Expanded
		if person.race.find('Seraph') >= 0:
		###---Expansion End---###
			speed += 4
		elif person.race.find('Wolf') >= 0:
			attack += 3
		if person.spec == 'assassin':
			speed += 5
			attack += 5
		elif person.spec == 'mage':
			magic *= 1.5
		elif person.spec == 'warrior':
			speed += 3
			attack += 3
		elif person.spec == 'dancer':
			speed += 7
		
		###---Added by Expansion---### Movement Expanded
		if person.movement == 'flying':
			if person.race.find('Bird') >= 0:
				speed = round(speed*1.4)
				attack = round(attack*1.4)
			else:
				speed = round(speed*1.25)
				attack = round(attack*1.25)
		elif person.movement == 'crawl':
			speed = round(speed*.5)
			attack = round(attack*.5)
		elif person.movement == 'none':
			speed = 0
			attack = 0
		###---Expansion End---###
		
		if person.preg.duration > globals.state.pregduration/3:
			speed = round(speed - speed*0.25)
			scene.getbuff(scene.makebuff('pregnancy', self, self), self)
		#Gear
		
		if (person.gear.weapon == null): # Capitulize - Fists = Strength
			attack += round(person.sstr * variables.damageperstr)
		for i in person.gear.values():
			var tempitem
			if i != null:
				###---Added by Expansion---### Items flipping out on NPCs
				if globals.state.unstackables.has(i):
					tempitem = globals.state.unstackables[i]
				else:
					tempitem = scene.enemygear[i]
#				if group == 'player':
#					tempitem = globals.state.unstackables[i]
#				else:
#					tempitem = scene.enemygear[i]
				###---End Expansion---###
				for k in tempitem.effects:
					if k.type == 'incombat' && globals.abilities.has_method(k.effect) && !k.has("effectscale"):
						globals.abilities.call(k.effect, self, k.effectvalue)
					elif k.type == 'incombat' && k.has("effectscale"): # Capitulize - Checks to see if incombat item has effectscale, if it does then give it proper damage type.
						globals.abilities.call(k.effect, self, k.effectvalue)
						if k.effectscale == 'str':
							attack += round(person.sstr * variables.damageperstr)
						elif k.effectscale == 'agi':
							attack += round(person.sagi * variables.damageperagi)
						elif k.effectscale == 'maf':
							attack += round(person.smaf * variables.damagepermaf)
					if k.type in ['incombatphyattack', 'incombatturn', 'incombatspecial']:
						self.geareffects.append(k)
					if k.type == 'passive':
						self.passives[k.effect] = k
		scene.rebuildbuffs(self)
	
	func selectcombatant():
		if state == 'defeated':
			return
		if actionpoints <= 0 && scene.period == 'base':
			node.pressed = false
			scene.floattext(node.rect_global_position,'This character has already acted this turn')
			return
		if scene.period == 'base':
			if group == 'enemy':
				return
			scene.selectedcharacter = self
			for i in scene.playergroup:
				if i.state == 'defeated':
					continue
				i.node.pressed = i == scene.selectedcharacter
			buildabilities()
		elif scene.period == 'skilltarget':
			if scene.targetskill.targetgroup == 'enemy' && scene.selectedcharacter.group == self.group:
				scene.floattext(node.rect_global_position,'Wrong Target')
				return
			elif scene.targetskill.targetgroup == 'ally' && scene.selectedcharacter.group != self.group:
				scene.floattext(node.rect_global_position,'Wrong Target')
				return
			scene.period = 'skilluse'
			scene.useskills(scene.targetskill, scene.selectedcharacter, self)
	
	func combatanttooltip():
		if group == 'player':
			node.get_node('Panel').visible = true
			for i in ['attack','speed','protection','armor']:
				node.get_node('Panel/' + i + '/Label').text = str(get(i))
			if actionpoints <= 0:
				node.hint_tooltip = 'No action points left'
			else:
				node.hint_tooltip = ''
		elif group == 'enemy':
			if scene.playergroup.size() > 0 && scene.playergroup[0].effects.has('mindreadeffect'):
				node.get_node('Panel').visible = true
				node.get_parent().move_child(node, node.get_parent().get_children().size())
				for i in ['attack','speed','protection','armor']:
					node.get_node('Panel/' + i + '/Label').text = str(get(i))
	
	func hidecombatanttooltip():
		node.get_node("Panel").hide()
	
	func buildabilities():
		for i in scene.get_node("grouppanel/skilline").get_children():
			if i.name != 'skill':
				i.hide()
				i.free()
		for i in activeabilities:
			var skill = globals.abilities.abilitydict[i]
			var newbutton = scene.get_node("grouppanel/skilline/skill").duplicate()
			scene.get_node("grouppanel/skilline").add_child(newbutton)
			var cost = globals.spells.spellCostCalc(skill.costmana)
			newbutton.set_disabled(cooldowns.has(skill.code) || skill.costenergy > energy || cost > globals.resources.mana)
			newbutton.show()
			
			newbutton.get_node("number").set_text(str(scene.get_node("grouppanel/skilline").get_children().size()-1))
			if skill.cooldown > 0 && cooldowns.has(skill.code):
				newbutton.get_node('cooldown').visible = true
				newbutton.get_node('cooldown').text = str(cooldowns[skill.code])
			newbutton.set_meta("skill", skill)
			newbutton.connect("mouse_entered",scene,'showskilltooltip',[skill])
			newbutton.connect("mouse_exited",scene,'hideskilltooltip')
			newbutton.connect("pressed",scene,'pressskill', [skill])
			if skill.has('iconnorm'):
				newbutton.set_normal_texture(skill.iconnorm)
				newbutton.set_pressed_texture(skill.iconpressed)
				newbutton.set_disabled_texture(skill.icondisabled)
#			if action != null:
#				if action.name == skill.name:
#					newbutton.set_pressed(true)
			if newbutton.is_disabled():
				newbutton.get_node("number").set('custom_colors/font_color', Color(1,0,0,1))
			elif newbutton.is_pressed():
				newbutton.get_node("number").set('custom_colors/font_color', Color(0,1,1,1))
	
	func dodge():
		scene.floattext(node.rect_global_position, 'Miss!', '#ffff00')
	
	func health_set(value):
		var effect = ''
		var color = 'white'
		var difference = ceil(value - hp)
		if difference > 0:
			effect = 'increase'
			color = '#00ff5e'
			scene.healdamage(self)
		elif difference < 0:
			effect = 'decrease'
			color = '#f05337'
			scene.takedamage(self)
			
			###---Added by Expansion---### Combat Stress
			if person != null:
				var hppercent = 100 - round(100*((100 - (hpmax - hp))/hpmax))
				if value + hppercent > person.cour || hp <= hpmax/4:
					#Max of 50% for 1/4 Health Left OR Damage + Total Damage Taken > Courage
					if rand_range(0,100) > (person.cour + person.conf)/4:
						stress += round(rand_range(2,4))
						if person.traits.has('Coward'):
							stress += round(rand_range(2,4))
				#Chance of 100% Resist
				elif value + hppercent > person.cour/2:
					if rand_range(0,100) > (person.cour + person.conf)/2:
						stress += round(rand_range(2,4))
						if person.traits.has('Coward'):
							stress += round(rand_range(2,4))
			###---End Expansion---###
		
		hp = clamp(ceil(value), 0, hpmax)
		
		if group == 'enemy' && person != null && ai == 'attack' && hp <= hpmax/2 && randf() >= 0.6:
			ai = 'escape'
		
		#draw()
		scene.floattext(node.rect_global_position, str(difference), color)
		if hp <= 0 && state != 'defeated':
			#---Second Wind
			if group == 'player' && globals.state.thecrystal.abilities.has('secondwind') && !person.dailyevents.has('crystal_second_wind'):
				if person == globals.player:
					scene.combatlog += "\n[color=#ff4949]You are struck a fatal blow, but the magic of the [color=aqua]Crystal[/color] swirls around you, restoring you to [color=lime]half health[/color]. [/color]"
					globals.state.thecrystal.hunger += 1
					hp += round(hpmax*.5)
					person.dailyevents.append('crystal_second_wind')
					if globals.state.thecrystal.abilities.has('attunement'):
						scene.combatlog += "\n[color=#ff4949]The [color=aqua]Crystal's Hunger[/color] grows to [color=red]" + str(globals.state.thecrystal.hunger) + "[/color]. It cannot restore you like this again today.[/color] "
					else:
						scene.combatlog += "\n[color=#ff4949]The [color=aqua]Crystal[/color] cannot restore you like this again today.[/color] "
				else:
					scene.combatlog += "\n[color=#ff4949]" + person.name + " is struck a fatal blow, but the magic of the [color=aqua]Crystal[/color] swirls around them, restoring them to [color=lime]half health[/color]. [/color]"
					globals.state.thecrystal.hunger += 1
					hp += round(hpmax*.5)
					person.dailyevents.append('crystal_second_wind')
					if globals.state.thecrystal.abilities.has('attunement'):
						scene.combatlog += "\n[color=#ff4949]The [color=aqua]Crystal's Hunger[/color] grows to [color=red]" + str(globals.state.thecrystal.hunger) + "[/color]. It cannot restore " + person.name + " like this again today.[/color] "
					else:
						scene.combatlog += "\n[color=#ff4949]The [color=aqua]Crystal[/color] cannot restore " + person.name + " like this again today.[/color] "
			else:
				defeat()
	
	func health_get():
		return hp
	
	func defeat():
		###---Added by Expansion---### Combat Death Prevention
		state = 'defeated'
		scene.defeatanimation(self)
		yield(scene, 'defeatfinished')
		node.hide()
		effects.clear()
		scene.combatantnodes.erase(node)
		if group == 'enemy':
			for i in scene.enemygroup:
				if i.passives.has("cultleaderpassive") && i.state != 'defeated':
					i.hpmax += 150
					i.hp += 300
					i.attack += 50
					scene.combatlog += "\n[color=red]Cult leader absorbs the power of defeated ally and grows stronger![/color]"
			scene.combatlog += scene.combatantdictionary(self, self, "\n[color=aqua][name1] has been defeated.[/color]")
		if group == 'player':
			scene.playergroup.remove(scene.playergroup.find(self))
			if person == globals.player:
				globals.main.animationfade(1)
				if OS.get_name() != 'HTML5':
					yield(globals.main, 'animfinished')
				globals.main.get_node("gameover").show()
				globals.main.get_node("gameover/Panel/text").set_bbcode("[center]You have died.[/center]")
				scene.period = 'end'
				return
			else:
				var _slave = person
				if globals.rules.permadeath == false:
					scene.combatlog += "\n[color=#ff4949]" + _slave.name + " has been defeated. [/color]"
					_slave.stats.health_cur = 15
					_slave.away.duration = 3
					_slave.away.at = 'rest'
					_slave.work = 'rest'
					globals.state.playergroup.erase(person.id)
				elif globals.state.thecrystal.preventsdeath == true:
					scene.combatlog += "\n[color=#ff4949]" + _slave.name + " has been defeated, but " + _slave.name + "'s death was prevented by the magic of the [color=aqua]Crystal[/color]. [/color]"
					scene.combatlog +=  "\n[color=#ff4949]The [color=aqua]Crystal's Lifeforce[/color] [color=red]decreases by 1[/color]. [/color]"
					globals.state.thecrystal.lifeforce -= 1
					_slave.stats.health_cur = 15
					_slave.away.duration = 3
					_slave.away.at = 'rest'
					_slave.work = 'rest'
					globals.state.playergroup.erase(person.id)
				else:
					scene.combatlog += "\n[color=#ff4949]" + _slave.name + " has died. [/color]"
					globals.state.playergroup.erase(person.id)
					for i in globals.state.playergroup:
						globals.state.findslave(i).stress += rand_range(25,40)
					_slave.death()
			###---End Expansion---###
		else:
			scene.repositionanimation()
		animationplaying = false
		scene.ongoinganimation = false
		scene.emit_signal("defeat2finished")
		scene.endcombatcheck()
	
	func escape():
		state = 'escaped'
		if group == 'enemy':
			scene.combatlog += scene.combatantdictionary(self, self,'\n[name1] [color=aqua]has escaped.[/color]')
		scene.escapeanimation(self)
		yield(scene, 'escapefinished')
		node.hide()
		effects.clear()
		scene.combatantnodes.erase(node)
		if group == 'enemy':
			scene.repositionanimation()
		animationplaying = false
		scene.ongoinganimation = false

func checkforresults():
	if playergroup[0].state == 'defeated':
		lose()
		return
	var counter = 0
	for i in enemygroup:
		if i.state == 'defeated':
			counter += 1
	if counter >= enemygroup.size():
		win()

func showskilltooltip(skill):
	var text = ''
	text += '[center]' + skill.name + '[/center]\n\n' + skill.description 
	if skill.costenergy > 0:
		text += "\n[color=yellow]Energy: " + str(skill.costenergy) + "[/color]"
	if skill.costmana > 0:
		var cost = globals.spells.spellCostCalc(skill.costmana)
		text += "\n[color=aqua]Mana: " + str(cost) + "[/color]"
	text += '\nBasic cooldown: ' + str(skill.cooldown)
	if selectedcharacter.cooldowns.has(skill.code):
		text += '\n\nCooldown: ' + str(selectedcharacter.cooldowns[skill.code])
	globals.showtooltip(text)

func pressskill(skill):
	var cost = globals.spells.spellCostCalc(skill.costmana)
	if (cost > 0 && globals.resources.mana < cost) || (skill.costenergy > 0 && selectedcharacter.energy < skill.costenergy):
		return
	if skill.target in ['one']:
		period = 'skilltarget'
		targetskill = skill
		if skill.targetgroup == 'enemy':
			var counter = 0
			var tempenemy
			for i in enemygroup:
				if i.state in ['escaped','captured','defeated']:
					counter += 1
				else:
					tempenemy = i
			if enemygroup.size() - counter <= 1:
				period = 'skilluse'
				useskills(skill, selectedcharacter, tempenemy)
	else:
		period = 'skilluse'
		useskills(skill, selectedcharacter, selectedcharacter)
	
func hitChance(caster,target,skill):
	var hitchance = 80
	if caster.speed >= target.speed:
		hitchance += (caster.speed - target.speed)*2.5
	else:
		hitchance -= (target.speed - caster.speed)*4
	if caster.person != null && caster.person.traits.has("Nimble"):
		hitchance *= 1.25
	if skill.has('accuracy'):
		hitchance = hitchance*skill.accuracy
	if target.person != null && target.person.race.findn("cat") >= 0:
		hitchance = hitchance*0.9
	return hitchance

func calculatehit(caster,target,skill):
	if rand_range(0,100) > hitChance(caster,target,skill):
		return 'miss'
	else:
		return 'hit'

func useskills(skill, caster = null, target = null, retarget = false):
	if caster == null || target == null:
		return
	else:
		deselectall()
	var text = ''
	var damage = 0
	var group = 'player'
	var hit = 'hit'
	var targetparty
	var targetarray
	globals.hidetooltip()
	if caster.group != target.group && target.effects.has('protecteffect') && retarget == false:
		if target.effects.protecteffect.caster.state == 'normal' && target.effects.protecteffect.caster.hp > 0:
			self.combatlog += combatantdictionary(target.effects.protecteffect.caster, target, "[name1] covers [targetname1] from attack.")
			useskills(skill, caster, target.effects.protecteffect.caster, true)
			return
	caster.actionpoints -= 1
	if skill.cooldown > 0:
		caster.cooldowns[skill.code] = skill.cooldown
	if playergroup.has(caster):
		if skill.costmana > 0:
			var cost = globals.spells.spellCostCalc(skill.costmana)
			globals.resources.mana -= cost
		caster.energy -= skill.costenergy
	else:
		group = 'enemy'

	var skillcounter = 1
	if caster.passives.has('doubleattack') && rand_range(0,100) < caster.passives.doubleattack.effectvalue && skill.type == 'physical':
		skillcounter += 1
		text += "[color=yellow]Double attack![/color] "
	while skillcounter > 0:
		skillcounter -= 1
		if skill.has('castersfx'):
			call(skill.castersfx, caster)
			yield(self, "damagetrigger")
		else:
			animationskip = true
		
		if skill.has('targetsfx'):
			call(skill.targetsfx, target)
		#target skills
		if skill.target == 'one':
			var infoText = " "
			if skill.code == 'attack':
				text += '[color=lime][name1][/color] tries to attack [color=#ec636a][targetname1][/color]. '
			else:
				text += '[name1] uses [color=aqua]' + skill.name + "[/color] on [targetname1]. "
			if skill.attributes.has('damage'):
				if skill.can_miss == true:
					hit = calculatehit(caster, target, skill)
					if skill.type == 'physical':
						infoText += "H: "+str(hitChance(caster, target, skill))+"% "
				if skill.type == 'physical' && hit != 'miss':
					damage = physdamage(caster, target, skill)
					text += '[targetname1] takes [color=#f05337]' + str(damage) + '[/color] damage.' 
					infoText += "B: "+str(caster.attack*skill.power)+" A: " + str(target.armor) + " P: " + str(target.protection)+"% "

				elif skill.type == 'spell':
					damage = spelldamage(caster, target, skill)
					text += '[targetname1] takes [color=#f05337]' + str(damage) + '[/color] spell damage.' 
				
				if skill.type == 'physical' && hit == 'miss':
					target.dodge()
					text += '[targetname1] [color=yellow]dodges[/color] it. '
				else:
					target.hp -= damage

				if globals.expansionsettings.perfectinfo:
					text += infoText
		#aoe skills
		elif skill.target == 'all':
			if group == 'player':
				targetarray = enemygroup
			else:
				targetarray = playergroup
			
			text += '[name1] uses [color=aqua]' + skill.name + '[/color]. '
			var counter = 0
			for i in targetarray:
				var infoText = " "
				if i.state != 'normal':
					continue
				if skill.attributes.has('damage'):
					if skill.can_miss == true:
						hit = calculatehit(caster, i, skill)
						if skill.type == 'physical':
							infoText += "H: "+str(hitChance(caster, i, skill))+"% "
					if skill.type == 'physical' && hit != 'miss':
						damage = physdamage(caster, i, skill)
						infoText += "B: "+str(caster.attack*skill.power)+" A: " + str(i.armor) + " P: " + str(i.protection)+"% "
					elif skill.type == 'spell':
						damage = spelldamage(caster, i, skill)
					if !i.effects.has("protecteffect"):
						if hit == 'hit':
							i.hp -= damage
							text += "[targetname" + str(counter) + "] takes [color=#f05337]" + str(damage) + '[/color] damage. '
						else:
							i.dodge()
							text += "[targetname" + str(counter) + "] [color=yellow]dodges[/color]. "
					if hit == 'hit' && skill.effect != null:
						sendbuff(caster, i, skill.effect)
					counter += 1

					if globals.expansionsettings.perfectinfo:
						text += infoText
			
		elif skill.target == 'self':
			if skill.code == 'escape' && globals.main.get_node("explorationnode").launchonwin != null && caster.group == 'player':
				globals.main.popup("You can't escape from this fight")
				caster.energy += skill.costenergy
				caster.actionpoints += 1
				period = 'base'
				caster.cooldowns.erase('escape')
				return
			if skill.code == 'mindread':
				caster.actionpoints += 1
		#buffs and effects
		if skill.attributes.has('noescape') && target.effects.has('escapeeffect'):
			text += "[targetname1] being held in place! "
			removebuff("escapeeffect",target)
		
		if skill.effect != null && hit == 'hit' && skill.target != 'all':
			sendbuff(caster, target, skill.effect)
		if skill.has('script') && hit == 'hit':
			scripteffect(caster,target,skill.script)
		if skill.has('effectself') && skill.effectself != null:
			sendbuff(caster, caster, skill.effectself)
		
		yield(self, 'tweenfinished')
		if skill.target == 'one' && target.animationplaying == true:
			yield(self, 'defeat2finished')
	if skill.code == 'heal':
		globals.abilities.restorehealth(caster,target)
	elif skill.code == "masshealcouncil":
		for i in targetarray:
			if i != caster:
				globals.abilities.restorehealth(caster,i)
	elif skill.code == 'escape':
		text += "[name1] prepares to escape! "
	
	
	if skill.target == 'all':
		target = targetarray
	
	self.combatlog += '\n' + combatantdictionary(caster, target, text)
	if period != 'enemyturn':
		endcombatcheck()
		if period == 'win':
			playerwin() 
		if period == 'skilluse':
			period = 'base'
		
	emit_signal("skillplayed")

func useAutoAbility(combatant):
	for abilityName in combatant.activeabilities:
		var ability = globals.abilities.abilitydict[abilityName]
		if !combatant.cooldowns.has(abilityName) && combatant.energy >= ability.costenergy && globals.resources.mana >= globals.spells.spellCostCalc(ability.costmana) && ability.targetgroup == "enemy":
			for j in enemygroup:
				if j.node != null && j.state == 'normal':
					useskills(ability, combatant, j)
					return
	for j in enemygroup:
		if j.node != null && j.state == 'normal':
			useskills(globals.abilities.abilitydict.attack, combatant, j)
			return

###---Added by Expansion---### Combat Stress Alteration
func enemyturn():
	if $autoattack.pressed == true:
		for i in playergroup:
			if i.state == 'normal' && i.actionpoints > 0:
				if globals.expansionsettings.autoattackability:
					useAutoAbility(i)
				else:
					for j in enemygroup:
						if j.node != null && j.state == 'normal':
							useskills(globals.abilities.abilitydict.attack, i, j)
							break
				yield(self, 'skillplayed')
				endcombatcheck()
				if period == 'win':
					playerwin() 
					return

	for i in enemygroup + playergroup:
		if i.state != 'normal':
			continue
		
		for effect in i.effects.values():
			if effect.caster.group == 'enemy':
				if effect.code == 'escapeeffect':
					if i.effects.has('stun'):
						continue
					if trapper != null && randf() > 0.5:

						self.combatlog += combatantdictionary(trapper, i,"\n[color=aqua][targetname1] has tried to escape but was caught in one of [name1]'s traps...[/color] ")
						i.defeat()
						yield(self, 'defeat2finished')
						continue
					i.escape()
				if effect.type == 'onendturn':
					self.combatlog += "\n" + combatantdictionary(i, i, globals.abilities.call(globals.abilities.effects[effect.code].script, i))
				if effect.duration > 0:
					effect.duration -= 1
				if effect.duration == 0:
					removebuff(effect.code, i)
	enemyturn = true
	var target
	for combatant in enemygroup:
		if combatant.state != 'normal' || combatant.effects.has('stun'):
			continue
		for effect in combatant.effects.values():
			if effect.code == 'escapeeffect':
				combatant.escape()
		var skill = []
		for k in combatant.abilities:
			var i = globals.abilities.abilitydict[k]
			
			if combatant.ai == 'escape':
				if !combatant.effects.has('shackleeffect'):
					skill = 'escape'
				else:
					combatant.ai = 'attack'
			if combatant.ai == 'attack':
				if combatant.cooldowns.has(i.code):
					continue
				if i.aipatterns.has('attack'):
					skill.append({value = i, weight = i.aipriority})
		
		
		
		
		if playergroup.size() == 0:
			lose()
			return
		
		if typeof(skill) == TYPE_ARRAY:
			skill = globals.weightedrandom(skill)
			combatant.aimemory = skill.code
		if skill == null:
			skill = globals.abilities.abilitydict[combatant.abilities[0]]
		elif typeof(skill) == TYPE_STRING:
			skill = globals.abilities.abilitydict[skill]
		var targetarray = []
		if skill.targetgroup == 'enemy':
			for i in playergroup:
				if i.state == 'normal':
					targetarray.append(i)
		elif skill.target == 'self':
			targetarray = [combatant]
		else:
			for i in enemygroup:
				if i.state == 'normal':
					targetarray.append(i)
		if targetarray.size() <= 0:
			return
		target = targetarray[randi()%targetarray.size()]
		if combatant.state in ['normal']:
			useskills(skill, combatant, target)
			yield(self, 'skillplayed')
	
	
	for i in enemygroup:
#		i.stress += 3
		i.actionpoints = 1
		if i.effects.has('stun'):
			i.actionpoints = 0
		var cooldownstoerase = []
		for k in i.cooldowns:
			i.cooldowns[k] -= 1
			if i.cooldowns[k] <= 0:
				cooldownstoerase.append(k)
		for k in cooldownstoerase:
			i.cooldowns.erase(k)
		for effect in i.effects.values():
			if effect.caster.group == 'player':
				if effect.duration > 0:
					effect.duration -= 1
				if effect.duration == 0:
					removebuff(effect.code, i)
	for i in playergroup:
		checkforinheritdebuffs(i)
#		i.stress += 3
#		if i.person.traits.has("Coward"):
#			i.stress += 3
		i.actionpoints = 1
		if i.effects.has("stun"):
			i.actionpoints = 0
		for k in i.cooldowns.duplicate():
			i.cooldowns[k] -= 1
			if i.cooldowns[k] <= 0:
				i.cooldowns.erase(k)
		###---Added by Expansion---### Ank BugFix v4a
		for e in i.geareffects:
			if e.type == 'incombatturn':
				if e.effect == 'lust':
					i.person.lust += e.effectvalue
		###---End Expansion---###
		for effect in i.effects.values():
			if effect.caster.group == 'player':
				if effect.duration > 0:
					effect.duration -= 1
				if effect.duration == 0:
					if effect.code == 'escapeeffect':
						i.state = 'escaped'
					removebuff(effect.code, i)
	
	if endcombatcheck() == 'continue':
		enemyturn = false
		
		period = 'nextturn'
	else:
		if $autoattack.pressed != globals.rules.autoattack:
			globals.rules.autoattack = $autoattack.pressed
			globals.overwritesettings()
		if period == 'escape':
			playerescape()
		elif period == 'win':
			playerwin()
###---End Expansion---###

func checkforinheritdebuffs(combatant):
	if combatant.energy > 0 && combatant.passives.has('exhausted'):
		removebuff('exhaust', combatant)
		combatant.passives.erase("exhaust")
	elif combatant.energy <= 0:
		getbuff(makebuff('exhaust', combatant, combatant), combatant)
		combatant.passives.exhaust = {code = 'exhaust'}
	if combatant.person != null && combatant.person != globals.player:
		if combatant.person.lust >= 80:
			getbuff(makebuff('luststrong', combatant, combatant), combatant)
			removebuff('lustweak', combatant)
		elif combatant.person.lust >= 50:
			getbuff(makebuff('lustweak', combatant, combatant), combatant)
			removebuff('luststrong', combatant)
		else:
			removebuff('luststrong',combatant)
			removebuff('lustweak',combatant)

func victory():
	var deads = []
	
	get_parent().animationfade(0.4)
	if OS.get_name() != 'HTML5':
		yield(get_parent(),'animfinished')
	get_node("win").hide()
	for i in range(0, enemygroup.size()):
		if enemygroup[i].state == 'escaped':
			currentenemies[i].state = 'escaped'
		else:
			currentenemies[i].state = 'defeated'
	globals.main.get_node("explorationnode").enemygroup.units = currentenemies
	hide()
	globals.main.get_node("outside").show()
	globals.main.get_node("ResourcePanel").show()
	globals.main.get_node("explorationnode").enemydefeated()
