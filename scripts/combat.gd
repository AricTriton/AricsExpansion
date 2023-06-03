
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
	var hp setget health_set
	var hpmax
	var energy
	var energymax
	var stress = 0
	var stressmax = 0
	var lust
	var lustmax
	var passives = {}
	var attack = 0
	var critPower = 1
	var magic = 0
	var armor = 0
	var protection = 0
	var speed = 0
	var portrait
	var target
	var geareffects = []
	var enemy_abilities
	var active_abilities
	var auto_abilities
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
		enemy_abilities = data.stats.abilities
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

	
	func update_skills_person():
		active_abilities = person.abilityactive.duplicate()
		auto_abilities = person.ability_autoattack.duplicate()
		
	
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
		update_skills_person()
		enemy_abilities = person.ability.duplicate()
		if data != null:
			for i in data.stats.abilities:
				enemy_abilities.append(i)
		
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
		if 'Seraph' in person.race:
		###---Expansion End---###
			speed += 4
		elif 'Wolf' in person.race:
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
		if person.movement == 'fly':
			speed += 3
			attack += 3
			if person.race.find('Bird') >= 0:
				speed += 2
				attack += 2
		
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
				#if group == 'player':
				#	tempitem = globals.state.unstackables[i]
				#else:
				#	tempitem = scene.enemygear[i]
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
		
		critPower = (globals.expansionsettings.critical_damage_base + person.sstr * globals.expansionsettings.critical_damage_per_str) / 100
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
		for i in active_abilities:
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
			#if action != null:
			#	if action.name == skill.name:
			#		newbutton.set_pressed(true)
			if newbutton.is_disabled():
				newbutton.get_node("number").set('custom_colors/font_color', Color(1,0,0,1))
			elif newbutton.is_pressed():
				newbutton.get_node("number").set('custom_colors/font_color', Color(0,1,1,1))
	
	func dodge():
		scene.floattext(node.rect_global_position, 'Miss!', '#ffff00')
	
	func health_set(new_hp):
		var old_hp = hp
		hp = clamp(ceil(new_hp), 0, hpmax)
		
		var difference = ceil(new_hp - old_hp)
		show_health_change(difference)
		get_stressed_from_damage(old_hp, difference)			
		
		if group == 'enemy' && person != null && ai == 'attack' && hp <= hpmax/2 && randf() >= 0.6:
			ai = 'escape'
		
		check_zero_hp()

	func show_health_change(difference: float):
		var text_color = 'white'
		if difference > 0:
			text_color = '#00ff5e'
			scene.healdamage(self)
		elif difference < 0:
			text_color = '#f05337'
			scene.takedamage(self)
		scene.floattext(node.rect_global_position, str(difference), text_color)

	
	###---Added by Expansion---### Combat Stress
	func get_stressed_from_damage(old_hp: float, difference: float):
		if difference < 0 && person != null:
			var damage_taken_now = difference * -1
			var health_missing_pct = (hpmax - old_hp) / hpmax * 100
			var stress_threshold = damage_taken_now + health_missing_pct
			
			if stress_threshold > person.cour || old_hp <= hpmax/4:
				#Max of 50% for 1/4 Health Left OR Damage + Total Damage Taken > Courage
				if rand_range(0,100) > (person.cour + person.conf)/4:
					stress += round(rand_range(2,4))
					if person.traits.has('Coward'):
						stress += round(rand_range(2,4))
			#Chance of 100% Resist
			elif stress_threshold > person.cour/2:
				if rand_range(0,100) > (person.cour + person.conf)/2:
					stress += round(rand_range(2,4))
					if person.traits.has('Coward'):
						stress += round(rand_range(2,4))
	###---End Expansion---###

	func check_zero_hp():
		if hp <= 0 && state != 'defeated':
			#---Second Wind
			if group == 'player' && globals.state.thecrystal.abilities.has('secondwind') && !person.dailyevents.has('crystal_second_wind'):
				var name = "You" if person == globals.player else person.name
				
				scene.queue.combatlog += "\n[color=#ff4949]" + name + " received a fatal blow, but the magic of the [color=aqua]Crystal[/color] swirls around them, restoring them to [color=lime]half health[/color]. [/color]"
				globals.state.thecrystal.hunger += 1
				hp += round(hpmax*.5)
				person.dailyevents.append('crystal_second_wind')
				if globals.state.thecrystal.abilities.has('attunement'):
					scene.queue.combatlog += "\n[color=#ff4949]The [color=aqua]Crystal's Hunger[/color] grows to [color=red]" + str(globals.state.thecrystal.hunger) + "[/color]. It cannot restore " + person.name + " like this again today.[/color] "
				else:
					scene.queue.combatlog += "\n[color=#ff4949]The [color=aqua]Crystal[/color] cannot restore " + name + " like this again today.[/color] "
			else:
				defeat()
	
	func defeat():
		###---Added by Expansion---### Combat Death Prevention
		state = 'defeated'
		scene.defeatanimation(self)
		yield(scene, 'defeatfinished')
		node.hide()
		effects.clear()
		scene.combatantnodes.erase(node)
		
		if group == 'enemy':
			on_enemy_defeated()
		if group == 'player':
			scene.playergroup.remove(scene.playergroup.find(self))
			if person == globals.player:
				pass
			else:
				on_slave_defeated()
		
		animationplaying = false
		scene.ongoinganimation = false
		scene.emit_signal("defeat2finished")
		scene.endcombatcheck()

	func on_enemy_defeated():
		scene.combatlog += scene.combatantdictionary(self, self, "\n[color=aqua][name1] has been defeated.[/color]")
		for i in scene.enemygroup:
			if i.passives.has("cultleaderpassive") && i.state != 'defeated':
				i.hpmax += 150
				i.hp += 300
				i.attack += 50
				scene.combatlog += "\n[color=red]Cult leader absorbs the power of defeated ally and grows stronger![/color]"
		scene.repositionanimation()

	func on_slave_defeated():
		var _slave = person
		if !globals.rules.permadeath || globals.state.thecrystal.preventsdeath:
			if !globals.rules.permadeath:
				scene.combatlog += "\n[color=#ff4949]" + _slave.name + " has been defeated. [/color]"
			else:
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

###---New addon to physdamage---###
func physdamage(caster: combatant, target: combatant, skill: Dictionary, is_crit = false) -> float:
	var damage = 0
	var power = (caster.attack * skill.power)
	var protection = float(float(100-target.protection)/100)
	var armor = target.armor
	if skill.attributes.has('physpen'):
		protection = 1
		armor = 0
	for i in caster.geareffects:
		if i.type == 'incombatphyattack':
			if i.effect == 'protpenetration':
				protection = 1
			if i.effect == 'fullpenetration':
				armor = 0
				protection = 1
	if target.passives.has('defenseless'):
		armor = 0
		protection = 1
	if caster.passives.has("armorbreaker"):
		armor = max(0, armor-8)
	if caster.passives.has('exhaust'):
		power = power * 0.66
	if is_crit:
		power = power * caster.critPower
	if caster.passives.has('rejuvenate'):
		caster.hp += 15

	damage = power * protection - armor
	if target.person != null && target.person.traits.has("Sturdy"):
		damage = damage*0.85
	damage = max(damage, 1)
	
	if skill.attributes.has('lifesteal'):
		caster.hp += damage/4
	
	return ceil(damage)

###---New addons to spell damage---###
func spelldamage(caster, target, skill):
	var damage = 0
	damage = max(1,(caster.magic * 4)) * skill.power
	if skill.code == 'mindblast':
		if target.faction == 'boss':
			damage += target.hpmax/15
		else:
			damage += target.hpmax/5
	if globals.state.spec == 'Mage' && caster.group == 'player':
		damage *= 1.2
	if caster.passives.has('rank1spelldamage'):
		damage *= 1.1
	if caster.passives.has('rank2spelldamage'): 
		damage *= 1.2
	if target.person != null && target.person.traits.has("Sturdy"):
		damage = damage*0.85
	return ceil(damage)

func pressskill(skill):
#---patch ankmairdor made, fix softlock bug from vanilla game.
	if period != 'base' && period != 'skilltarget':
		return
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
	
	if globals.expansionsettings.combat_tweaks_enabled:
		hitchance = max(hitchance, globals.expansionsettings.minimal_hit_chance)
	
	if caster.person != null && caster.person.traits.has("Nimble"):
		hitchance *= 1.25
	if skill.has('accuracy'):
		hitchance = hitchance*skill.accuracy
	if target.person != null && target.person.race.findn("cat") >= 0:
		hitchance = hitchance*0.9
	return hitchance


enum HitResult {Miss, Hit, Crit}

func calculatehit(caster: combatant, target: combatant, skill: Dictionary) -> int:
	var hit_chance = hitChance(caster,target,skill)
	var crit_chance = hit_chance - 100

	if hit_chance < rand_range(0, 100):
		return HitResult.Miss

	if caster.effects.has('panic') && rand_range(0, 100) < 66:
		return HitResult.Miss
	
	var can_crit = globals.expansionsettings.combat_tweaks_enabled && globals.expansionsettings.critical_strikes && caster.group == 'player'
	if can_crit && crit_chance >= rand_range(0, 100):
		return HitResult.Crit
		
	return HitResult.Hit



class CombatLogAdder:
	var scene
	var caster: combatant
	var target: combatant

	func _init(scene, caster: combatant, target: combatant):
		self.scene = scene
		self.caster = caster
		self.target = target

	func log(text: String) -> void:
		scene.combatlog += scene.combatantdictionary(caster, target, text)


func checkTargetProtected(skill: Dictionary, caster: combatant, target: combatant) -> bool:
	if caster.group != target.group && target.effects.has('protecteffect'):
		var protector = target.effects.protecteffect.caster
		if protector.state == 'normal' && protector.hp > 0:
			self.combatlog += combatantdictionary(protector, target, "[name1] covers [targetname1] from attack.")
			useskills(skill, caster, protector, false)
			return true
	return false


func useResourcesForSkill(skill, caster) -> void:
	caster.actionpoints -= 1
	if skill.cooldown > 0:
		caster.cooldowns[skill.code] = skill.cooldown
	if playergroup.has(caster):
		if skill.costmana > 0:
			var cost = globals.spells.spellCostCalc(skill.costmana)
			globals.resources.mana -= cost
		caster.energy -= skill.costenergy


func calcMultipleAttack(skill, caster) -> int:
	var skillcounter = 1
	if caster.passives.has('doubleattack') && rand_range(0,100) < caster.passives.doubleattack.effectvalue && skill.type == 'physical':
		skillcounter += 1
		self.combatlog += "[color=yellow]Double attack![/color] "
	return skillcounter


func useskills(skill, caster = null, target = null, canRetarget = true):
	if caster == null || target == null:
		return

	deselectall()
	globals.hidetooltip()

	var logAdder = CombatLogAdder.new(self, caster, target)
	logAdder.log("\n")

	if canRetarget && checkTargetProtected(skill, caster, target):
		return

	useResourcesForSkill(skill, caster)
	
	var usesCount = calcMultipleAttack(skill, caster)
	for attackIndex in usesCount:
		var function_state = useSkillOnce(caster, target, skill)
		if function_state is GDScriptFunctionState: # Still working.
			yield(function_state, "completed")
	
	if period != 'enemyturn':
		endcombatcheck()
		if period == 'win':
			playerwin() 
		if period == 'skilluse':
			period = 'base'
		
	emit_signal("skillplayed")


#can yield
func useSkillOnce(caster: combatant, target: combatant, skill: Dictionary) -> void:
	var logAdder = CombatLogAdder.new(self, caster, target)
	if skill.has('castersfx'):
		call(skill.castersfx, caster)
		yield(self, "damagetrigger")
	else:
		animationskip = true
	
	if skill.has('targetsfx'):
		call(skill.targetsfx, target)
	
	#target skills
	if skill.target == 'one':
		useTargetSkill(caster, target, skill, logAdder)
	#aoe skills
	elif skill.target == 'all':
		useAllSkill(caster, skill, logAdder)
	#self skills
	elif skill.target == 'self':
		if useSelfSkill(caster, skill, logAdder) == "break":
			return
	
	if skill.has('effectself') && skill.effectself != null:
		sendbuff(caster, caster, skill.effectself)

	yield(self, 'tweenfinished')
	if skill.target == 'one' && target.animationplaying == true:
		yield(self, 'defeat2finished')


func useTargetSkill(caster: combatant, target: combatant, skill: Dictionary, logAdder: CombatLogAdder) -> void:
	if skill.code == 'attack':
		logAdder.log('[color=lime][name1][/color] tries to attack [targetname1]. ')
	else:
		logAdder.log('[name1] uses [color=aqua]{skill}[/color] on [targetname1]. '.format({skill = skill.name}))	
	useSkillOnOneTarget(caster, target, skill)


func useAllSkill(caster: combatant, skill: Dictionary, logAdder: CombatLogAdder) -> void:
	var isPlayerGroup: bool = playergroup.has(caster)
	var targetarray
	if (isPlayerGroup && skill.targetgroup == 'enemy') || (!isPlayerGroup && skill.targetgroup == 'ally'):
		targetarray = enemygroup
	else:
		targetarray = playergroup
	
	logAdder.log('[name1] uses [color=aqua]{skill}[/color]. '.format({skill = skill.name}))
	for i in targetarray:
		useSkillOnOneTarget(caster, i, skill)


func useSelfSkill(caster: combatant, skill: Dictionary, logAdder: CombatLogAdder):
	if skill.code == 'escape':
		if globals.main.get_node("explorationnode").launchonwin != null && caster.group == 'player':
			globals.main.popup("You can't escape from this fight")
			caster.energy += skill.costenergy
			caster.actionpoints += 1
			period = 'base'
			caster.cooldowns.erase('escape')
			return "break"
		else:
			logAdder.log("[name1] prepares to escape! ")
	if skill.code == 'mindread':
		caster.actionpoints += 1
	useSkillOnOneTarget(caster, caster, skill)


func useSkillOnOneTarget(caster: combatant, target: combatant, skill: Dictionary) -> void:
	var logAdder = CombatLogAdder.new(self, caster, target)
	
	if target.state != 'normal':
		return
	var infoText = [" "]
	var hit = HitResult.Hit

	if skill.can_miss == true:
		hit = calculatehit(caster, target, skill)
		infoText[0] += "H: {chance}% ".format({chance = hitChance(caster, target, skill)})

	if skill.attributes.has('damage'):
		skillDealDamage(caster, target, skill, hit, infoText, logAdder)

	if skill.effect != null && hit != HitResult.Miss:
		sendbuff(caster, target, skill.effect)
	if skill.has('script') && hit != HitResult.Miss:
		scripteffect(caster, target, skill.script)
	
	if skill.attributes.has('noescape') && target.effects.has('escapeeffect'):
		logAdder.log("[targetname1] being held in place! ")
		removebuff("escapeeffect",target)
	
	if globals.expansionsettings.perfectinfo:
		logAdder.log(infoText[0])


func skillDealDamage(caster: combatant, target: combatant, skill: Dictionary, hit: int, infoText: Array, logAdder: CombatLogAdder) -> void:
	if skill.type == 'spell':
		var damage = spelldamage(caster, target, skill)
		logAdder.log('[targetname1] takes [color=#f05337]{damage}[/color] spell damage.'.format({damage = damage}))
		target.hp -= damage
	
	elif skill.type == 'physical':
		if hit == HitResult.Crit:
			logAdder.log("[color=yellow]Critical Attack![/color] ")
		if hit != HitResult.Miss:
			var damage = physdamage(caster, target, skill, hit == HitResult.Crit)
			logAdder.log('[targetname1] takes [color=#f05337]{damage}[/color] damage.'.format({damage = damage}))
			infoText[0] += "B: {rawDmg} A: {armor} P: {prot}%".format({rawDmg = caster.attack*skill.power, armor = target.armor, prot = target.protection})
			target.hp -= damage
		else:
			target.dodge()
			logAdder.log("[targetname1] [color=yellow]dodges[/color] it. ")


func useAutoAbility(combatant):
	if combatant.auto_abilities.back() != "attack":
		combatant.auto_abilities.append("attack")
	for abilityName in combatant.auto_abilities:
		var ability = globals.abilities.abilitydict[abilityName]

		var notCooldown = !combatant.cooldowns.has(abilityName) 
		var hasEnergy = combatant.energy >= ability.costenergy
		var hasMana = globals.resources.mana >= globals.spells.spellCostCalc(ability.costmana)
		var isEnemyTargeting = ability.targetgroup == "enemy"
		if notCooldown && hasEnergy && hasMana && isEnemyTargeting:
			for j in enemygroup:
				if j.node != null && j.state == 'normal':
					useskills(ability, combatant, j)
					return

###---Added by Expansion---### Combat Stress Alteration
func enemyturn():
	for func_name in ["player_team_autoattack", "check_state_before_enemy_turn", "actual_enemy_turn", "process_end_of_turn_effects"]:
		var func_result = self.call(func_name)
		if func_result is GDScriptFunctionState:
			func_result = yield(func_result, "completed")
		if func_result == "break":
			break
	
	end_turn()


func player_team_autoattack():
	if $autoattack.pressed:
		for i in playergroup:
			if i.state == 'normal' && i.actionpoints > 0:
				useAutoAbility(i)
				yield(self, 'skillplayed')
				endcombatcheck()
				if period == 'win':
					return "break"


func check_state_before_enemy_turn():
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


func actual_enemy_turn():
	enemyturn = true
	for enemy_combatant in enemygroup:
		if enemy_combatant.state != 'normal' || enemy_combatant.effects.has('stun'):
			continue
		if playergroup.size() == 0:
			return "break"
		
		for effect in enemy_combatant.effects.values():
			if effect.code == 'escapeeffect':
				combatant.escape()
		
		var skill = enemy_select_used_skill(enemy_combatant)
		var target = enemy_select_random_target(enemy_combatant, skill)

		if target != null && enemy_combatant.state in ['normal']:
			useskills(skill, enemy_combatant, target)
			yield(self, 'skillplayed')


func enemy_select_used_skill(enemy_combatant: combatant) -> String:
	if enemy_combatant.ai == 'escape' && !enemy_combatant.effects.has('shackleeffect'):
		return globals.abilities.abilitydict['escape']
	else:
		var skills_list = []
		for k in enemy_combatant.enemy_abilities:
			var i = globals.abilities.abilitydict[k]
			if enemy_combatant.cooldowns.has(i.code):
				continue
			if i.aipatterns.has('attack'):
				skills_list.append({value = i, weight = i.aipriority})
		var selected_skill = globals.weightedrandom(skills_list)
		if selected_skill == null:
			return enemy_combatant.abilities[0]
		else:
			return selected_skill


func enemy_select_random_target(enemy_combatant: combatant, skill: Dictionary):
	var targetarray = []
	if skill.targetgroup == 'enemy':
		for i in playergroup:
			if i.state == 'normal':
				targetarray.append(i)
	elif skill.target == 'self':
		return enemy_combatant
	else:
		for i in enemygroup:
			if i.state == 'normal':
				targetarray.append(i)
	if targetarray.size() <= 0:
		return null
	return targetarray[randi()%targetarray.size()]


func process_end_of_turn_effects():
	process_enemy_effects()
	process_player_group_effects()


func process_enemy_effects():	
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


func process_player_group_effects():
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
	
func end_turn():
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
		elif period == 'lose':
			lose()


func endcombatcheck():
	var enemies_alive = 0
	for i in enemygroup:
		if i.state == 'normal':
			enemies_alive += 1
	
	if enemies_alive == 0:
		period = 'win'
		return

	var player_combatant = null
	for i in playergroup:
		if i.person == globals.player:
			player_combatant = i
			break
	
	if player_combatant != null && player_combatant.state == 'normal':
		return 'continue'
	
	if player_combatant != null && player_combatant.state == 'escaped':
		period = 'escape'
	else:
		period = 'lose'
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
		if globals.expansionsettings.combat_tweaks_enabled && globals.expansionsettings.panic_debuff:
			if combatant.stress >= 99:
				sendbuff(combatant, combatant, 'panic')
			else:
				removebuff('panic', combatant)

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
