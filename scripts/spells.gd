
extends Node

var spelllist = {
#	mindread = { Spell entry
#		code = 'mindread', # spell entry reference
#		name = 'Mind Reading', # Displayed name
#		description = 'Enhances your mind to be more cunning towards others. Allows to get accurate information about other characters. ', #description
#		effect = 'mindreadeffect', #effect called on activation
#		manacost = 3, #mana cost
#		req = 0, #requirements (mansion alchemy upgrade)
#		price = 100, #gold cost to learn
#		personal = true, #can be used on another slave
#		combat = true, #has a corresponding combat ability
#		learned = false, #when learned, will be saved and loaded
#		type = 'control', #category
#		flavor = "Bonus description",
#	},
	mindread = {
		code = 'mindread',
		name = 'Mind Reading',
		description = 'Enhances your mind to be more cunning towards others. Allows to get accurate information about other characters. ',
		effect = 'mindreadeffect',
		manacost = 3,
		req = 0,
		price = 100,
		personal = true,
		combat = true,
		learned = false,
		type = 'control',
		flavor = "Reading other person's thoughts hardly worth the effort: way too often they are just chaotic streams changing one after another. Nevertheless, you can grasp some understanding how others think by devoting your time to them. ",
	},
	sedation = {
		code = 'sedation',
		name = 'Sedation',
		description = "Eases target's stress and fear.",
		effect = 'sedationeffect',
		manacost = 10,
		req = 0,
		price = 200,
		personal = true,
		combat = true,
		learned = false,
		type = 'control',
		flavor = "Ability to calm down another person is invaluable in many situations. ",
	},
	masssedation = { 
		code = 'masssedation', #Added by Expansion: Taken from MinorTweaks by Dabros with permission
		name = 'Mass Sedation',
		description = "Same effect as Sedate, only now targetting all stressed slaves with one casting (even those away from mansion)",
		effect = 'masssedationeffect',
		manacost = 10,
		req = 0,
		price = 2000,
		personal = true,
		combat = false,
		learned = false, ## NOTE - locked away, if you have enough slaves you really needing it, you can afford to save up
		type = 'control',
		flavor = "The ability to bring calm to all those around you is priceless in many situations.",
	},
	heal = {
		code = 'heal',
		name = 'Heal',
		description = 'Heals physical wounds. ',
		effect = 'healeffect',
		manacost = 10,
		req = 0,
		price = 200,
		personal = true,
		combat = true,
		learned = false,
		type = 'defensive',
		flavor = "Regeneration is a part of every living being.",
	},
	massheal = {
		code = 'massheal', #Added by Expansion: Taken from MinorTweaks by Dabros with permission
		name = 'Mass Heal',
		description = 'Heals physical wounds for your combat party. ',
		effect = 'masshealeffect',
		manacost = 10,
		req = 0,
		price = 2000,
		personal = true,
		combat = true,
		learned = false,
		type = 'defensive',
		flavor = "Regeneration is a part of every living being.",
	},
	dream = {
		code = 'dream',
		name = 'Dream',
		description = 'Puts target into deep, restful sleep. ',
		effect = 'dreameffect',
		manacost = 20,
		req = 0,
		price = 350,
		personal = true,
		combat = false,
		learned = false,
		type = 'control',
	},
	entrancement = {
		code = 'entrancement',
		name = 'Entrancement',
		description = 'Makes target more susceptible to suggestions. Kinks, Fetishes, and Consent are easier to manipulate.',
		effect = 'entrancementeffect',
		manacost = 15,
		req = 10,
		price = 400,
		personal = true,
		combat = false,
		learned = false,
		type = 'control',
	},
	fear = {
		code = 'fear',
		name = 'Fear',
		description = 'Invokes subconscious feel of terror onto the target. Can be effective punishment. ',
		effect = 'feareffect',
		manacost = 10,
		req = 0,
		price = 250,
		personal = true,
		combat = false,
		learned = false,
		type = 'control',
	},
	domination = {
		code = 'domination',
		name = 'Domination',
		description = 'Attempts to overwhelm  the target′s mind and instill unwavering obedience. May cause irreversible mental trauma. ',
		effect = 'dominationeffect',
		manacost = 40,
		req = 10,
		price = 500,
		personal = true,
		combat = false,
		learned = false,
		type = 'control',
	},
	mutate = {
		code = 'mutate',
		name = 'Mutation',
		description = 'Enforces mutation onto target. Results may vary drastically. ',
		effect = 'mutateeffect',
		manacost = 15,
		req = 2,
		price = 400,
		personal = true,
		combat = false,
		learned = false,
		type = 'utility',
	},
	barrier = {
		code = 'barrier',
		name = 'Barrier',
		description = "Creates a magical barrier around target, raising its armor. ",
		effect = '',
		manacost = 12,
		req = 1,
		price = 200,
		personal = false,
		combat = true,
		learned = false,
		type = 'defensive',
	},
	shackle = {
		code = 'shackle',
		name = 'Shackle',
		description = "Ties single target to ground making escape impossible. ",
		effect = '',
		manacost = 10,
		req = 1,
		price = 200,
		personal = false,
		combat = true,
		learned = false,
		type = 'utility',
	},
	acidspit = {
		code = 'acidspit',
		name = 'Acid Spit',
		description = "Turns your saliva into highly potent corrosive substance for a short time. \nDeals spell damage to single target enemy and reduces its armor. ",
		effect = '',
		manacost = 6,
		req = 2,
		price = 400,
		personal = false,
		combat = true,
		learned = false,
		type = 'offensive',
	},
	mindblast = {
		code = 'mindblast',
		name = 'Mind Blast',
		description = "Simple mind attack which can be utilized in combat. While not terribly effective on its own, can eventually break the enemy. \nDeals spell damage to single target enemy. ",
		effect = '',
		manacost = 5,
		req = 1,
		price = 100,
		personal = false,
		combat = true,
		learned = false,
		type = 'offensive',
	},
	invigorate = {
		code = 'invigorate',
		name = 'Invigorate',
		description = "Restores caster's and target's energy by using mana and target body's potential. Builds up target's stress. Can be used in wild. ",
		effect = 'invigorateeffect',
		manacost = 5,
		req = 2,
		price = 300,
		personal = true,
		combat = false,
		learned = false,
		type = 'utility',
	},
	summontentacle = {
		code = 'summontentacle',
		name = 'Summon Tentacle',
		description = 'Summons naughty tentacles from the otherworld for a short time. Can make up for a very effective punishment.',
		effect = 'tentacleeffect',
		manacost = 35,
		req = 10,
		price = 650,
		personal = true,
		combat = false,
		learned = false,
		type = 'utility',
	},
	guidance = {
		code = 'guidance',
		name = 'Guidance',
		description = "An utility spell which helps to find shortest and safest paths among the wilds. \nEffect grows with Magic Affinity. \n[color=yellow]Effect reduced in enclosed spaces[/color] ",
		effect = 'guidanceeffect',
		manacost = 8,
		req = 2,
		price = 250,
		personal = false,
		combat = false,
		learned = false,
		type = 'utility',
	},
	mark = {
		code = 'mark',
		name = 'Mark',
		description = "An utility spell, leaving a permanent mark on the location, allowing to return to it from portal room later on. Only 1 mark at the time is allowed. ",
		effect = 'markeffect',
		manacost = 10,
		req = 2,
		price = 500,
		personal = false,
		combat = false,
		learned = false,
		type = 'utility',
	},
###---Added by Expansion---### DeathnDekay's Leak Spell (Modified)
	leak = {
		code = 'leak',
		name = 'Leak',
		description = 'Forces lactating breasts to drain their milk. It has been known to occassionally cause non-lactating breasts to begin lactating, though it may cause stress to the subject if failed. ',
		effect = 'leakeffect',
		manacost = 20,
		req = 0,
		price = 500,
		personal = true,
		combat = false,
		learned = true,
		type = 'utility',
	},
###---End Expansion---###
}

func spellCostCalc(cost):
	if globals.state.spec == 'Mage' && globals.expansionsettings.mage_mana_reduction:
		cost = cost/2
	return cost*globals.expansionsettings.spellcost
	
func spellcost(spell):
	return spellCostCalc(spell.manacost)

func mindreadeffect():
	var spell = globals.spelldict.mindread
	var text = ''
	globals.resources.mana -= spellcost(spell)
	###---Added by Expansion---### Colored / Legibility; 
	text = "You peer into $name's soul. "
	if person.effects.has('captured') == true:
		text = text + "\n[color=red]\n$name doesn't accept $his new life in your domain. (Rebelling: " + str(person.effects.captured.duration) + ")[/color]"
	text += "\n\n$He is of [color=aqua]" + person.origins.capitalize() + "[/color] origins.\nStrength: " + str(person.sstr) + ", Agility: " + str(person.sagi) + ", Magic Affinity: " + str(person.smaf) + ", Endurance: " + str(person.send)
	text += "\nBase Beauty: " + str(person.beautybase) + ', Temporal (Temporary) Beauty: ' + str(person.beautytemp)
	text += "\nObedience: " + str(round(person.obed)) + ", Fear: " + str(person.fear) + ', Stress: '+ str(round(person.stress)) + ', Loyalty: ' + str(round(person.loyal)) + ', Lust: '+ str(round(person.lust)) + ', Courage: ' + str(round(person.cour)) + ', Confidence: ' + str(round(person.conf)) + ', Wit: '+ str(round(person.wit)) + ', Charm: ' + str(round(person.charm)) + ", Toxicity: " + str(floor(person.toxicity)) + ", Lewdness: " + str(floor(person.lewdness)) + ", Role Preference: " + str(floor(person.asser))
	if person.traits.size() >= 0:
		text += '\n\n$name has corresponding traits: [color=aqua]'
		for i in person.traits:
			text += '\n' + i
		text += '[/color]'
	#Trait Storage
	if !person.traitstorage.empty():
		text += "\nYou also sense the following traits buried deep within $him. $He may pass these down to $his offspring, but $he will likely never know that $he carried these.[color=aqua]"
		for i in person.traitstorage:
			text += "\n" + i
		text += "[/color]"
	if person.preg.duration > 0:
		text += "\nPregnancy: " + str(person.preg.duration)
		if !person.knowledge.has('currentpregnancy') && !person.mind.secrets.has('currentpregnancy'):
			text += "\n$He doesn't even know that $he is having this baby yet. "
		if person.pregexp.wantedpregnancy == true:
			text += "\n[center][color=green]She wants this baby, won't resist her bodily changes, and will not be as stressed by those changes.[/color][/center]"
		else:
			text += "\n[center][color=red]She doesn't want this baby and the pregnancy will be more stressful for her as she resists the changes her body goes through.[/color][/center]"
	###---End Expansion---###
	if person.lastsexday != 0:
		text += "\n\n$name had sex last time " + str(globals.resources.day - person.lastsexday) + " day(s) ago"
	###---Added by Expansion---### NPC Expanded
	text += "\n\n[center][color=#d1b970]History[/color][/center]"
	if person.npcexpanded.timesmet > 0:
		text += "\nYou have met $him before [color=aqua]"+str(person.npcexpanded.timesmet)+"[/color] times. "
	if person.npcexpanded.timesfought > 0:
		text += "\nYou have fought and beaten $him [color=red]"+str(person.npcexpanded.timesfought)+"[/color] times. "
	if person.npcexpanded.timesrescued > 0:
		text += "\nYou rescued $him [color=aqua]"+str(person.npcexpanded.timesrescued)+"[/color] times. "
	if person.npcexpanded.timesraped > 0:
		text += "\nYou have raped $him before [color=red]"+str(person.npcexpanded.timesraped)+"[/color] times. "
	if person.npcexpanded.timesreleased > 0:
		text += "\nYou freed $him [color=aqua]"+str(person.npcexpanded.timesreleased)+"[/color] times. "
	if person.npcexpanded.timesreleased == 0 && person.npcexpanded.timesraped == 0 && person.npcexpanded.timesrescued == 0 && person.npcexpanded.timesfought == 0 && person.npcexpanded.timesmet == 0:
		text += "\nYou have no prior history together."
	#Vice Discovery
	var envytarget = globals.expansion.getBestSlave()
	if person.mind.vice_known == false:
		if globals.expansionsettings.vices_discovery_has_to_present_first == false || globals.expansionsettings.vices_discovery_has_to_present_first == true && person.mind.vice_presented == true:
			var vice_text = person.revealVice(person.mind.vice)
			var vice_discoverychance = (globals.player.smaf*10) + (person.dailyevents.count(person.mind.vice)*10)
			if person.mind.vice_presented == true:
				vice_discoverychance += globals.expansionsettings.vices_discovery_presentation_bonus
			if vice_text == "":
				text += "\n\nYou sense $him resisting your mental probing. It seems there is an internal weakness or [color=aqua]Vice[/color] that $he is subconsciousnessly desparate to hide from you. You feel you may be able to break this resistance down if you continued to cast this on $him.\n\nYou currently have a [color=aqua]" + str(vice_discoverychance) + " Percent[/color] to break this resistance."
			else:
				text += "\n" + vice_text
				if person.checkVice('envy'):
					text += "\nSlave Currently considered Favored: [color=aqua]"+ envytarget.dictionary("$name") +"[/color]"
	else:
		text += "\n\n[center][color=#d1b970]Vice[/color][/center]\n$His [color=aqua]Vice[/color] is [color=aqua]"+ str(person.mind.vice.capitalize()) +"[/color]"
		if person.checkVice('envy'):
			text += "\nCurrent Favored Slave (Target of Envy): [color=aqua]"+ envytarget.dictionary("$name") +"[/color]"
	#Luxury
	var luxurydict = person.countluxury(false)
	var luxuryreq = str(person.calculateluxury())
	text += "\n\n[center][color=#d1b970]Luxury[/color][/center]\nCurrent Luxury: "+ globals.fastif(int(luxurydict.luxury) >= int(luxuryreq), "[color=lime]","[color=red]") + str(luxurydict.luxury) +"[/color]  |  Current Luxury Requirement: [color=aqua]"+ luxuryreq +"[/color]"
	###---End Expansion---###
	text = person.dictionary(text)
	return text

###---Added by Expansion---### Size Expanded
var dictChangeParts = {
	15 : ['height', globals.heightarray, "height"],
	16 : ['titssize', globals.titssizearray, "chest size"],
	17 : ['asssize', globals.asssizearray, "butt size"],
	18 : ['skin', globals.allskincolors, "skin color"],
	19 : ['eyecolor', globals.alleyecolors, "eye color"],
	20 : ['eyeshape', ['normal','slit'], "pupil shape"],
	21 : ['haircolor', globals.allhaircolors, "hair color"],
	22 : ['ears', globals.allears, "ear shape"],
}

func invigorateeffect():
	if globals.useRalphsTweaks && globals.expansionsettings.ralphs_tweaks_partial.tweak_invigorate:
		return invigorateeffect_Ralphs()
	var text = ''
	var spell = globals.spelldict.invigorate
	globals.resources.mana -= spellcost(spell)
	person.energy += person.stats.energy_max/2
	person.stress += max(rand_range(25,35)-globals.player.smaf*4, 10)
	globals.player.energy += 50
	text = person.dictionary("You cast Invigorate on $name. Your and $his energy is partly restored. $His stress has increased. ")
	return text

#ralph
func invigorateeffect_Ralphs():
	var text = ''
	var spell = globals.spelldict.invigorate
	globals.resources.mana -= spellcost(spell)
	if person.unique != 'player':
		person.energy += person.stats.energy_max/2
		person.stress += max(rand_range(25,35)-globals.player.smaf*4, 10)
		globals.player.energy += 50
		text = person.dictionary("You cast Invigorate on $name. Your and $his energy is partly restored. $His stress has increased. ")
	else:
		if person.health >= person.stats.health_max/2 && person.health > 30:
			person.health -= rand_range(20,30)
			globals.player.energy += 50
			text = person.dictionary("You cast Invigorate on yourself. You cut your palm using your own blood as the catalyst for the spell. Your energy is partly restored at the cost of a small amount of your health. ")
		else:
			globals.player.energy += 25
			text = person.dictionary("You cast Invigorate on yourself and make a sputtering gasp, coughing up a little blood. You're not in any shape for this. Your energy is partly restored, but not as much as you hoped. ")
	return text
#/ralph

func entrancementeffect():
	var text = ''
	var spell = globals.spelldict.entrancement
	var exists = false
#	globals.resources.mana -= spellcost(spell)
	if person.effects.has('entranced') == false:
		###---Added by Expansion---### Entrancement Expanded
		globals.resources.mana -= spellcost(spell)
		text = "$name's eyes "+ globals.randomitemfromarray(['dialate','slowly spin','half-close','drift lazily','glaze over','become unable to focus on anything','cross slightly','go listless','glow faintly violet','grow dim']) +". $He seems ready to accept whatever you tell $him. The next suggestion you give him, whether a request for [color=aqua]Consent[/color], [color=aqua]Fetish[/color] changes, or [color=aqua]Number of Children Wanted[/color], $he will fully accept. This will consume the mana flowing through $him and end the trance, however. "
		###---End Expansion---###
		person.add_effect(globals.effectdict.entranced)
	else:
		text = "It seems like $name is already entranced. "
	return person.dictionary(text)

func feareffect():
	var text = "You grab hold of $name's shoulders and hold $his gaze. At first, $he’s calm, but the longer you stare into $his eyes, the more $he trembles in fear. Soon, panic takes over $his stare. "
	var spell = globals.spelldict.fear
	globals.resources.mana -= spellcost(spell)
	person.fear += 20+caster.smaf*10
	person.stress += max(5, 20-caster.smaf*3)
	if person.effects.has('captured') == true:
		text += "\n[color=green]$name becomes less rebellious towards you.[/color]"
		person.effects.captured.duration -= floor(1+globals.player.smaf/globals.expansionsettings.reduce_rebellion_with_fear)
	text = (person.dictionary(text))
	return text

func tentacleeffect():
	var spell = globals.spelldict.summontentacle
	var text = "As you finish chanting the spell, a stream of tentacles emerge from small breach in air. "
	if person.unique == 'Zoe':
		text += "\n\n[color=yellow]—No... Please NO![/color]\n\n"
	
	text += "They quickly seize $name by the limbs and free $him from the clothes. You observe how $name is being toyed and raped by tentacles. After a couple of orgasms the tentacles disappear from reality and you make sure that $name learned this lesson well before leaving."
	person.obed += 75
	person.fear += 90
	person.lewdness += globals.expansionsettings.summontentacle_lewdness #/ralph
	person.lust -= rand_range(20,30)
	if person.vagvirgin == true:
		person.vagvirgin = false
	if !person.traits.has("Deviant"):
		person.loyal -= 20
		person.stress += rand_range(30,50)
	if person.unique == 'Zoe':
		person.loyal = 0
		text += "\n\n[color=yellow]—How could you...?[/color]"
	
	return person.dictionary(text)

func mutate(power=2):
	###---Added by Expansion---### Size Expanded
	var text = "Raw magic in $name's body causes $him to uncontrollably mutate. \n\n"
	var temp
	while power >= 1:
		var didChange = true
		match randi() % 25:
			0:
				if person.add_trait(globals.origins.traits('any').name):
					text += "$name has received a new trait. "
				else:
					didChange = false
			1:
				if person.penis == 'none':
					person.penis = globals.randomfromarray(['micro','tiny','small']) # beginning of penissizearray
					if (globals.rules.futa && randi() % 3 != 0) || person.vagina == 'none':
						text += "$name has grown a dick. "
					else:
						person.vagina = 'none'
						person.preg.has_womb = false
						text += "$name's vagina has transformed into a dick. "
				elif person.vagina == 'none':
					person.vagina = globals.randomfromarray(['impenetrable','tiny','tight']) # beginning of globals.vagsizearray
					person.preg.has_womb = true
					if (globals.rules.futa && randi() % 3 != 0) || person.penis == 'none':
						text += "$name has grown a " +person.vagina+ " "+globals.expansion.namePussy()+". "
					else:
						person.penis = 'none'
						text += "$name's dick has transformed into a " +person.vagina+ " "+globals.expansion.namePussy()+". "
				elif randi() % 2 == 0:
					person.vagina = 'none'
					person.preg.has_womb = false
					text += "$name's vagina has shrunk to nothing. "
				else:
					person.penis = 'none'
					text += "$name's dick has shrunk to nothing. "
			2:
				if person.penis == 'none':
					didChange = false
				elif randi() % 2 == 0:
					text += "$name's dick size has changed. "
					randNewPartFromArray(person, 'penis', globals.penissizearray)
				else:
					text += "$name's dick shape has changed. "
					randNewPartFromArray(person, 'penistype', globals.penistypearray)		
			3:
				### centerflag982 - added dickgirl check
				if !globals.rules.futaballs && person.sex != 'male' && person.sex != 'dickgirl':
					if person.balls != 'none':
						person.balls = 'none'
						text += "$name's scrotum has shrunk to nothing. "
					else:
						didChange = false
				elif person.balls == 'none':
					person.balls = 'small'
					text += "$name has grown a scrotum. "
				else:
					randNewPartFromArray(person, 'balls', globals.penissizearray + ['none'])
					if person.balls == 'none':
						text += "$name's scrotum has shrunk to nothing. "
					else:
						text += "$name's scrotum size has changed. "
			4:
				text += "$name's skin coverage has changed. "
				if globals.rules.furry:
					randNewPartFromArray(person, 'skincov', globals.skincovarray)
					randNewPartFromArray(person, 'furcolor', globals.allfurcolors)
				else:
					temp = globals.skincovarray
					temp.erase('full_body_fur')
					randNewPartFromArray(person, 'skincov', temp)
			5:
				if globals.hairlengtharray.find(person.hairlength) < globals.hairlengtharray.size() - 1:
					person.hairlength = globals.hairlengtharray[globals.hairlengtharray.find(person.hairlength) + 1]
					text += "$name's hair has grown. "
				else:
					didChange = false 
			6:
				text += "$name's general appeal has drastically changed. "
				temp = person.beautybase
				while abs(temp - person.beautybase) < 15:
					temp = round(rand_range(10, 90))
				person.beautybase = temp
			7:
				if person.lactation == false:
					text += "$name's breasts started secreting milk. "
					person.lactation = true
				else:
					text += "$name's breasts stopped secreting milk. "
					person.lactation = false
			8:
				temp = randNewFromArray(range(5), int(person.titsextra))
				text += "Additional %s have %s on $name's torso. " % ["tits" if person.titsextradeveloped else "nipples", "sprouted" if (temp > person.titsextra) else "shrunk to nothing"]
				person.titsextra = temp
			9:
				if person.preg.has_womb && person.preg.duration == 0 && !person.effects.has("contraceptive"):
					text += "It seems some new life has began in $name. "
					person.preg.fertility = 100
					globals.impregnation(person)
				else:
					didChange = false
			10:
				text += "$name's cognitive abilities have worsened. "
				person.wit -= rand_range(10,25)
			11:
				text += "$name's lust has greatly increased. "
				person.lust += rand_range(40,80)
			12:
				temp = randNewFromArray(globals.allhorns + ['none'], person.horns)
				if person.horns == 'none':
					text += "$name has grown a pair of horns. "
				elif temp == 'none':
					text += "$name's horns have shrunk to nothing. "
				else:
					text += "$name's horns have changed in shape. " 
				person.horns = temp
			13:
				temp = randNewFromArray(globals.alltails + ['none'], person.tail)
				if person.tail == 'none':
					text += "$name has grown a tail. "
				elif temp == 'none':
					text += "$name's tail has shrunk to nothing. "
				else:
					text += "$name's tail has changed in shape. " 
				person.tail = temp
			14:
				temp = randNewFromArray(globals.allwings + ['none'], person.wings)
				if person.wings == 'none':
					text += "$name has grown a pair of wings. "
				elif temp == 'none':
					text += "$name's wings have shrunk to nothing. " 
				else:
					text += "$name's wings have changed in shape. " 
				person.wings = temp
			23: #---Asshole
				if person.asshole == 'none':
					person.asshole = globals.randomfromarray(globals.assholesizearray)
					text += "$name has grown a " +person.asshole+ " "+globals.expansion.nameAsshole()+". "
				else:
					person.asshole = randNewFromArray(globals.assholesizearray, person.asshole)
					text += "$name's "+globals.expansion.nameAsshole()+" has change to " +person.asshole+ ". "
			24: #---Lips
				person.lips = randNewFromArray(globals.lipssizearray, person.lips)
				text += "$name's lips have changed to " +person.lips+ ". "
			var val:
				var ref = dictChangeParts.get(val)
				if ref == null:
					didChange = false
				else:
					randNewPartFromArray(person, ref[0], ref[1])
					text += "$name's %s has changed. " % ref[2]
		if didChange:
			person.stress += rand_range(5,15)
			power -= 1
	person.checksex()
	person.toxicity -= rand_range(20,30)
	text = person.dictionary(text)
	return text

#---From MinorTweaks by Dabros, with permission
func masssedationeffect():
	var text = '' ## CHANGED NEW - 27/5/19 - mass sedation spell
	var spell = globals.spelldict.sedation
	var newlyaffectedslaves = []
	var skippedslaves = []
	var alreadyaffectedslaves = []
	var stresstarget = 33
	text = ''
	for i in globals.slaves:
		if i.stress >= stresstarget:
			if !i.effects.has('sedated'):
				if globals.resources.mana - spellcost(spell) > -1:
					i.add_effect(globals.effectdict.sedated)
					i.stress -= rand_range(20,30) + globals.player.smaf*6
					i.fear -= rand_range(5,15)
					newlyaffectedslaves.append(i)
					globals.resources.mana -= spellcost(spell)
				else:
					skippedslaves.append(i)
			else:
				alreadyaffectedslaves.append(i)
	if newlyaffectedslaves.size() | alreadyaffectedslaves.size() | skippedslaves.size():
		text += 'You cast Mass Sedate on all of your slaves, knowing its effect will reach even well outside of your mansion.\n'
		text += '[color=green]' + str(newlyaffectedslaves.size()) + ' of ' + str(newlyaffectedslaves.size() + alreadyaffectedslaves.size() + skippedslaves.size()) + ' stressed slaves were affected[/color]\n'
		text += '' + str(newlyaffectedslaves.size() * spellcost(spell)) + ' mana used\n'
	else:
		text += 'You do not appear to have any stressed slaves (stress > ' + str(stresstarget-1) + ').\nYou can still cast standard Sedate on any slave, to further reduce stress and reduce fear in them.'
	if alreadyaffectedslaves.size():
		text += '[color=yellow]' + str(alreadyaffectedslaves.size()) + ' slaves were already under its effect[/color]\n'
	if skippedslaves.size():
		text += '[color=red]' + str(skippedslaves.size()) + ' slaves were left unaffected as you ran out of mana[/color]\n'
	if newlyaffectedslaves.size():
		var temp = []
		text += '\n[color=green]Newly affected:[/color] \n'
		for i in newlyaffectedslaves:
			temp.append('- '+i.name_long())
		text += PoolStringArray(temp).join("\n")+"\n"
	if alreadyaffectedslaves.size():
		var temp = []
		text += '\n[color=yellow]Already affected[/color]: \n'
		for i in alreadyaffectedslaves:
			temp.append('- '+i.name_long())
		text += PoolStringArray(temp).join("\n")+"\n"
	if skippedslaves.size():
		var temp = []
		text += '\n[color=red]Skipped due to low mana[/color]: \n'
		for i in skippedslaves:
			temp.append('- '+i.name_long())
		text += PoolStringArray(temp).join("\n")+"\n"
	main.rebuild_slave_list()
	return text


func masshealeffect():
	var text = '' ## CHANGED NEW - 7/6/19 - mass heal spell
	var spell = globals.spelldict.heal
	var newlyaffectedslaves = []
	var loyaltyaffectedslaves = []
	var skippedslaves = []
	var alreadyaffectedslaves = []
	text = ''

	## TODO - heal YOU first
	var _slave
	for i in globals.state.playergroup:
		_slave = globals.state.findslave(i)
		if _slave.health < _slave.stats.health_max:
			if globals.resources.mana - spellcost(spell) > -1:
				newlyaffectedslaves.append(_slave)
				while _slave.health < _slave.stats.health_max && globals.resources.mana - spellcost(spell) > -1:
					globals.resources.mana -= spellcost(spell)
					_slave.health += rand_range(20,30) + globals.player.smaf*7
					if globals.player != _slave:
						if _slave.loyal < 20:
							_slave.loyal += rand_range(2,4)
							_slave.obed += rand_range(10,15)
							loyaltyaffectedslaves.append(_slave)
			else:
				skippedslaves.append(_slave)
		else:
			alreadyaffectedslaves.append(_slave)
	if newlyaffectedslaves.size() | alreadyaffectedslaves.size() | skippedslaves.size():
		text += 'You cast Mass Heal on your combat party.\n'
		text += '[color=green]' + str(newlyaffectedslaves.size()) + ' of ' + str(newlyaffectedslaves.size() + alreadyaffectedslaves.size() + skippedslaves.size()) + ' wounded party members were affected[/color]\n'
		text += '' + str(newlyaffectedslaves.size() * spellcost(spell)) + ' mana used\n'
	else:
		text += 'You do not appear to have any wounded party members.'
	if alreadyaffectedslaves.size():
		text += '[color=yellow]' + str(alreadyaffectedslaves.size()) + ' party members were already fully healed[/color]\n'
	if skippedslaves.size():
		text += '[color=red]' + str(skippedslaves.size()) + ' party members were left completely unaffected as you ran out of mana before reaching them[/color]\n'
	if newlyaffectedslaves.size():
		var temp = []
		text += '\n[color=green]Affected:[/color] \n'
		for i in newlyaffectedslaves:
			temp.append('- '+i.name_long())
		text += PoolStringArray(temp).join("\n")+"\n"
	if loyaltyaffectedslaves.size():
		var temp = []
		text += '\n[color=green]Loyalty raised by this kind act:[/color] \n'
		for i in loyaltyaffectedslaves:
			temp.append('- '+i.name_long())
		text += PoolStringArray(temp).join("\n")+"\n"
	if alreadyaffectedslaves.size():
		var temp = []
		text += '\n[color=yellow]Already full health[/color]: \n'
		for i in alreadyaffectedslaves:
			temp.append('- '+i.name_long())
		text += PoolStringArray(temp).join("\n")+"\n"
	if skippedslaves.size():
		var temp = []
		text += '\n[color=red]Skipped due to low mana[/color]: \n'
		for i in skippedslaves:
			temp.append('- '+i.name_long())
		text += PoolStringArray(temp).join("\n")+"\n"
	main.rebuild_slave_list()
	return text
#----End MinorTweaks

func leakeffect():
	var spell = globals.spelldict.leak
	var text = ""
	var number = 0
	globals.resources.mana -= spellcost(spell)
	text += "You walk over to [color=aqua]$name[/color] and place your hands on $his " + str(globals.expansion.getChest(person)) + ". You focus your mind and summon the ancient words in the arcane tongue.\n-[color=yellow]Leak[/color]"
	if person.lactation == true:
		if person.lactating.milkstorage > 0:
			number = person.lactating.milkstorage
			person.lactating.milkstorage = 0
			person.lactating.daysunmilked = 0
			text += "\n\n$He steps back and grabs at $his nipples in shock as though a bolt of electricity shot through them. "
			if person.checkFetish('lactation', 1.1) || person.checkFetish('bemilked', 1.25):
				text += "$He moans in uncontrollably esctasy as $his nipples begin to stream [color=aqua]" + str(number) + " milk[/color] down $his "
				person.lust += number
			else:
				text += "$He looks horrified by $his own body and your power over it as $his nipples begin to stream [color=aqua]" + str(number) + " milk[/color] down $his "
				person.fear += number
			#Naked Check
			if person.exposed.chest == true:
				text += "naked breasts. "
			else:
				text += "breasts, soaking and staining the clothing with dark circles. "
		else:
			text += "\n\n$He grabs $his " + str(globals.expansion.getChest(person)) + " in pain as $his empty nipples try to produce [color=aqua]milk[/color] that isn't there. "
			text += "\n-" + person.quirk("[color=yellow]What were you trying to do to me? That hurt! ")
			number = round(rand_range(3,5))
			text += "\n[color=red]$He gained " + str(number) + " Stress from the attempt. [/color]"
			person.stress += number
	elif rand_range(0,100) <= globals.expansionsettings.leakcauseslactationchance:
		person.lactation = true
		number = round(rand_range(3,5))
		text += "\n\n$He steps back in confusion. $He suddenly grimaces and covers $his nipples as though a pain started there. As you watch, $his hand slowly rises as $his " + str(globals.expansion.getChest(person)) + " begins to swell. "
		if person.checkFetish('lactation', 1) || person.checkFetish('bemilked', 1):
			text += "$He moans in pleasure at the warm, full sensation filling $his breasts.\n-" + person.quirk("[color=yellow]Ooooh...that feels good.[/color]") + "\n\n$He seems unaware that $he is rubbing $his chest sensually as a droplet of [color=aqua]milk[/color] squeezes out of $his nipple and "
			person.lust += number
		else:
			text += "$He whimpers and moans.\n-" + person.quirk("[color=yellow]Please, no! No! I don't want to lactate! I'm not a cow![/color]") + "\n\n$He gasps in futility as a droplet of [color=aqua]milk[/color] slips out of $his helpless body and "
			person.fear += number
		#Naked Check
		if person.exposed.chest == true:
			text += "dribbles down $his naked breasts. "
		else:
			text += "soaks a dark ring around the hard nipple pressing against $his clothing. "
	else:
		text += "\n\n$He grabs $his " + str(globals.expansion.getChest(person)) + " in pain as $his empty nipples try to produce [color=aqua]milk[/color] that isn't there. "
		text += "\n-" + person.quirk("[color=yellow]What were you trying to do to me? That hurt! ")
		number = round(rand_range(3,5))
		text += "\n[color=red]$He gained " + str(number) + " Stress from the attempt. [/color]"
		person.stress += number
	
	return person.dictionary(text)

###---End Expansion---###
