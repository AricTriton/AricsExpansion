
func gornpalaceivran(stage):
	var text
	var state = true
	var buttons = []
	var sprite = null
	
	if stage == 1:
		sprite = [['garthor','pos1']]
		text = textnode.MainQuestGornIvranExecute
		if !globals.state.sidequests.ivran in ['tobetaken','tobealtered','potionreceived','notaltered']:
			text += textnode.MainQuestGornAydaSolo
		globals.state.sidequests.ivran = 'killed'
		globals.state.mainquest = 16
		globals.main.exploration.zoneenter('gorn')
	elif stage == 2:
		sprite = [['garthor','pos1']]
		text = textnode.MainQuestGornIvranImprison
		if !globals.state.sidequests.ivran in ['tobetaken','tobealtered','potionreceived','notaltered']:
			text += textnode.MainQuestGornAydaSolo
		globals.state.sidequests.ivran = 'imprisoned'
		globals.state.mainquest = 16
		globals.main.exploration.zoneenter('gorn')
	elif stage == 3 && !globals.state.sidequests.ivran in ['tobetaken','tobealtered','potionreceived']:
		sprite = [['garthor','pos1']]
		text = textnode.MainQuestGornIvranKeep
		globals.state.sidequests.ivran = 'tobetaken'
		globals.main.exploration.zoneenter('gorn')
	elif stage == 3 && globals.state.sidequests.ivran in ['tobetaken','tobealtered']:
		text = "Garthor refuses to give you Ivran as is. You should find his acquaintance. "
	elif stage == 3 && globals.state.sidequests.ivran == 'potionreceived':
		text = textnode.MainQuestGornIvranChange
		sprite = [['garthor','pos1']]
		globals.state.sidequests.ivran = 'changed'
		globals.state.mainquest = 16
		globals.state.decisions.append('ivrantaken')
		ivran = globals.characters.create("Ivrana")
		globals.main._on_mansion_pressed()
		buttons = [['Continue','ivranname']]
		state = false
	elif stage == 4:
		closedialogue()
		return
	
	globals.main.dialogue(state, self, text, buttons, sprite)

#Main Quest Finale
func mountainwin(stage = 0):
	var state = false
	var text = ''
	var buttons = []
	var sprite = []
	if stage == 0:
		globals.charactergallery.hade.unlocked = true
		if globals.state.decisions.has("mainquestelves"):
			text = textnode.MainQuestFinaleElfWin
		elif globals.state.decisions.has("mainquestslavers"):
			text = textnode.MainQuestFinaleMercWin
		buttons.append({text = "Continue", function = 'mountainwin', args = 1})
	elif stage == 1:
		text += textnode.MainQuestFinaleHadeSpeech
		sprite = [['hadeneutral','pos1','opac']]
	###---Added by Expansion---### Races Expanded
		if globals.player.race.find('Human') >= 0:
			text += '\n\n' + textnode.MainQuestFinaleHadeSpeechHuman
	###---Expansion End---###
		buttons.append({text = "Continue", function = 'mountainwin', args = 2})
	elif stage == 2:
		var counter = 0
		sprite = [['hadeneutral','pos1']]
		text += "[color=yellow]— I propose you join with us against The Old Order. You will be able to achieve greatness beyond what could ever be possible if you choose to stick to the old ways. I promise, once we reform the old fools at The Order’s main branch we can give the capable people like you far more power, real power, and not be beholden to stupid, obsolete laws.[/color]\n\n[color=#ff5df8]— I know you love power and you wish to achieve more with it. We are the same in that regard. After all, you did force all those people into servitude. "
		if globals.state.decisions.has("emilyseduced"):
			text += "You didn’t hesitate to force yourself on that orphan girl. "
			counter += 1
		if globals.state.decisions.has("tishaemilytricked"):
			counter += 2
			text += "You tricked that Tisha girl into offering herself to you and also kept her sister despite your promise. "
		elif globals.state.decisions.has("tishatricked"):
			counter += 1
			text += "You tricked that Tisha girl into offering herself to you. "
		if globals.state.decisions.has("chloebrothel"):
			counter += 1
			text += "You also broken and sold that gnome girl to brothel. "
		elif globals.state.decisions.has("chloeamnesia"):
			text += "You also brainwashed that gnome girl, for your own benefit. "
			counter += 1
		elif globals.state.decisions.has("chloeaphrodisiac"):
			text += "You also broken that gnome girl for your own amusement before enslaving her. "
			counter += 1
		if globals.state.decisions.has('tiataken'):
			text += "I remember you kidnapped that village girl, as well. "
			counter += 1
		elif globals.state.decisions.has('tiatricked'):
			text += "I remember you brainwashed that village girl into joining you, as well. "
			counter += 1
		if globals.state.decisions.has("ivrantaken"):
			text += "You went so far as to take possession of a tribal elf leader. "
			counter += 1
		if globals.state.decisions.has("calisexforced"):
			text += "You even forced that wolf girl to sleep with a stranger just to save you some cash. "
			counter += 1
		text += "[/color]"
		
		globals.state.mainquest = 40
		
		if counter >= 3:
			text += '\n\n' + textnode.MainQuestFinaleHadeSpeechAdditional
		buttons.append({text = "Refuse", function = 'mountainwin', args = 4})
		buttons.append({text = "Join Hade", function = 'mountainwin', args = 3})
	elif stage == 3:
		state = true
		globals.state.decisions.append('badroute')
		sprite = [['hadesmile','pos1']]
		text = textnode.MainQuestFinaleBadAccept
		globals.main.exploration.zoneenter('mountaincave')
	elif stage == 4:
		state = true
		globals.state.decisions.append('goodroute')
		sprite = [['hadeangry','pos1']]
		text = textnode.MainQuestFinaleGoodChoice
		globals.main.exploration.zoneenter('mountaincave')
		
	globals.main.dialogue(state, self, text, buttons, sprite)

func finalemelissa(stage = 0):
	var text = ''
	var state = false
	var buttons = []
	var slavelist = []
	var image = 'finale'
	for i in globals.slaves:
		var score = i.metrics.ownership + i.metrics.sex*3 + i.metrics.win*2 + i.level*7
		slavelist.append({person = i, score = score})
	slavelist.sort_custom(self, 'bestslave')
	if globals.slaves.size() == 0:
		stage = 5
	if stage == 0:
		finaleperson = slavelist[0].person
		text = finaleperson.dictionary(textnode.MainQuestFinaleGoodHadeDefeat)
		buttons.append({text = "Let Hade go", function = 'finalemelissa', args = 1})
		buttons.append({text = finaleperson.dictionary("Let $name die"), function = 'finalemelissa', args = 2})
	elif stage == 1:
		text = finaleperson.dictionary(textnode.MainQuestFinaleGoodReleaseHade)
		buttons.append({text = "Continue", function = 'finalemelissa', args = 3})
		globals.state.decisions.append("haderelease")
	elif stage == 2:
		text = finaleperson.dictionary(textnode.MainQuestFinaleGoodTakeHade)
		globals.main.sound('stab')
		image = 'finale2'
		buttons.append({text = "Subdue Melissa", function = 'finalemelissa', args = 4})
		globals.state.decisions.append("hadekeep")
		globals.main.music_set('stop')
		###---Added by Expansion---### Crystal Immortality | Added by Pallington
		if globals.state.thecrystal.preventsdeath == true:
			globals.state.thecrystal.lifeforce -= 1
			finaleperson.stats.health_cur = 15
			finaleperson.away.duration = 3
			finaleperson.away.at = 'rest'
			finaleperson.work = 'rest'
			globals.state.playergroup.erase(finaleperson.id)
		else:				
			finaleperson.removefrommansion()
		###---End Expansion---###
	elif stage == 3:
		text = finaleperson.dictionary(textnode.MainQuestFinaleGoodReleaseHade2)
		globals.main.closescene()
		var sprite = [["melissaworried", 'pos1', 'opac']]
		buttons.append({text = finaleperson.dictionary("Rush to $name"), function = 'ending'})
		globals.main.dialogue(state, self, text, buttons, sprite)
		return
	elif stage == 4:
		text = finaleperson.dictionary("You subdue and capture Melissa, but $name is above saving... ")
		globals.main.closescene()
		var sprite = [["melissaworried", 'pos1', 'opac'], ['hadeneutral','pos2','opac']]
		buttons.append({text = "...", function = 'ending'})
		globals.main.dialogue(state, self, text, buttons, sprite)
		return
	elif stage == 5:
		text = "With Hade's defeat you secure this victory..."
		globals.main.closescene()
		globals.state.decisions.append("melissanoslave")
		var sprite = [['hadeneutral','pos1','opac']]
		buttons.append({text = "...", function = 'ending'})
		globals.main.dialogue(state, self, text, buttons, sprite)
		return
	globals.main.scene(self, image, text, buttons)

func chloeforest(stage = 0):
	var text = ''
	var state = false
	var sprite = [['chloehappy', 'pos1']]
	var buttons = []
	if stage == 0:
		sprite = [['chloeneutral', 'pos1', 'opac']]
		if globals.state.sidequests.chloe == 1:
			chloeforest(3)
			return
		else:
			var havegnomemember = false
			for i in globals.state.playergroup:
				var person = globals.state.findslave(i)
				###---Added by Expansion---### Races Expanded
				if person.race.find('Gnome') >= 0:
					havegnomemember = true
				###---End Expansion---###
			if havegnomemember == false:
				text = textnode.ChloeEncounter
				if globals.spelldict.sedation.learned == true && globals.spells.spellcost(globals.spelldict.sedation) <= globals.resources.mana:
					buttons.append({text = 'Cast Sedation',function = 'chloeforest',args = 1, disabled = false})
				elif globals.spelldict.sedation.learned == true:
					buttons.append({text = 'Cast Sedation',function = 'chloeforest',args = 1, disabled = true, tooltip = 'Not enough mana'})
				else:
					buttons.append({text = "You have no other available options yet",function = 'chloeforest',args = 1, disabled = true})
			else:
				text = textnode.ChloeEncounterGnome
				buttons.append({text = 'Talk with her',function = 'chloeforest',args = 2, disabled = false})
			buttons.append({text = 'Leave her alone',function = 'chloeforest',args = 6})
	
	
	
	elif stage == 1:
		globals.resources.mana -= globals.spells.spellcost(globals.spelldict.sedation)
		text = textnode.ChloeSedate + textnode.ChloeEncounterTalk
		globals.state.sidequests.chloe = 1
		buttons.append({text = 'Lead her to the Shaliq',function = 'chloeforest',args = 4})
		buttons.append({text = "Tell her you can't help",function = 'chloeforest',args = 5})
	elif stage == 2:
		text = textnode.ChloeEncounterTalk
		globals.state.sidequests.chloe = 1
		buttons.append({text = 'Lead her to the Shaliq',function = 'chloeforest',args = 4})
		buttons.append({text = "Tell her you can't help",function = 'chloeforest',args = 5})
	elif stage == 3:
		text = textnode.ChloeEncounterRepeat
		buttons.append({text = 'Lead her to the Shaliq',function = 'chloeforest',args = 4})
		buttons.append({text = "Tell her you can't help",function = 'chloeforest',args = 5})
	elif stage == 4:
		text = textnode.ChloeEncounterHelp
		buttons.append({text = 'Proceed to Shaliq with Chloe',function = 'chloeforest',args = 7})
	elif stage == 5:
		text = textnode.ChloeEncounterRefuse
		buttons.append({text = 'Continue',function = 'chloeforest',args = 6})
	elif stage == 6:
		globals.main.exploration.zoneenter('forest')
		closedialogue()
		return
	elif stage == 7:
		text = textnode.ChloeShaliq
		globals.state.sidequests.chloe = 2
		globals.main.exploration.progress = 0
		globals.main.exploration.zoneenter('shaliq')
		yield(globals.main, 'animfinished')
		buttons.append({text = 'Leave',function = 'chloevillage',args = 0})
	globals.main.dialogue(state,self,text,buttons,sprite)

func sspotion(stage = 0):
	if globals.state.mansionupgrades.mansionalchemy == 0: #check every 3 days if alchemy room has been purchased
		globals.state.upcomingevents.append({code = 'sspotion', duration = 3})
		return
	
	var state = false
	var text
	var buttons = []
	var sprites = []
	var startslave
	for i in globals.slaves:
		if i.unique == 'startslave':
			startslave = i
	if startslave == null:
		return
	
	var textdict 
	
	if startslave.imagefull != null:
		if stage == 0:
			sprites = [[startslave.imagefull,'pos1','opac']]
		else:
			sprites = [[startslave.imagefull,'pos1']]
	globals.state.sidequests.startslave = 3
	
	match stage:
		0:
			if startslave.sex in ['male','dickgirl']:
				text = ssnode.sspotionmale
			else:
				text = ssnode.sspotionfemale
			state = false
			buttons.append({text = 'Help out', function = 'sspotion', args = 1})
			buttons.append({text = 'Scold', function = 'sspotion', args = 2})
			buttons.append({text = 'Pass Towel and Leave', function = 'sspotion', args = 3})
		1:
			startslave.loyal += 10
			globals.state.decisions.append("sspotionfair")
			buttons.append({text = 'Continue', function = 'sspotionaftermatch', args = 0})
			if startslave.sex in ['male','dickgirl']:
				text = ssnode.sspotionfairmale 
			else:
				text = ssnode.sspotionfairfemale 
		2:
			startslave.obed += 25
			globals.state.decisions.append("sspotionstrict")
			if startslave.sex in ['male','dickgirl']:
				text = ssnode.sspotionstrictmale
			else:
				text = ssnode.sspotionstrictfemale
			buttons.append({text = 'Continue', function = 'sspotionaftermatch', args = 0})
		3:
			var yandere = false
			buttons.append({text = 'Continue', function = 'sspotionaftermatch', args = 0})
			globals.state.decisions.append("sspotionweak")
			if globals.state.decisions.has('ssweak') && globals.state.decisions.has("ssmassageweak"):
				yandere = true
			if yandere == false:
				text = ssnode.sspotionleave
			else:
				globals.state.decisions.append('ssyandere')
				if startslave.sex in ['male','dickgirl']:
					text = ssnode.sspotionleaveyanderemale
				else:
					text = ssnode.sspotionleaveyanderefemale
	
	globals.main.dialogue(state, self, startslave.dictionary(text), buttons, sprites)

func sspotionaftermatch(stage = 0):
	var state = true
	var text
	var buttons = []
	var sprites = []
	var startslave
	for i in globals.slaves:
		if i.unique == 'startslave':
			startslave = i
	if startslave == null:
		return
	
	if startslave.imagefull != null:
		sprites = [[startslave.imagefull,'pos1','opac']]
	
	globals.main.animationfade(1.5)
	yield(globals.main, 'animfinished')
	
	var yandere = false
	if globals.state.decisions.has('ssyandere'):
		yandere = true
	
	if yandere == true:
		if startslave.sex in ['male','dickgirl']:
			text = ssnode.sspotioncontyanderem
		else:
			text = ssnode.sspotioncontyanderef
	else:
		var weak = 0
		var strict = 0
		var fair = 0
		
		var weakdict = ['ssweak','ssmassageweak','sspotionweak']
		var fairdict = ['ssfair','ssmassagefair','sspotionfair']
		var strictdict = ['ssstrict','ssmassagestrict','sspotionstrict']
		
		
		for i in globals.state.decisions:
			if weakdict.has(i):
				weak += 1
			if fairdict.has(i):
				fair += 1
			if strictdict.has(i):
				strict += 1
		
		var character
		
		if weak >= 2:
			character = 'dominant'
		elif strict >= 2:
			character = 'submissive'
		
		if character == 'dominant':
			startslave.add_trait('Dominant')
			if startslave.sex in ['male','dickgirl']:
				text = ssnode.sspotioncontdomm
			else:
				text = ssnode.sspotioncontdomf
		elif character == 'submissive':
			startslave.add_trait('Submissive')
			if startslave.sex in ['male','dickgirl']:
				text = ssnode.sspotioncontsubm
			else:
				text = ssnode.sspotioncontsubf
		else:
			if startslave.sex in ['male','dickgirl']:
				text = ssnode.sspotioncontnormm
			else:
				text = ssnode.sspotioncontnormf
	
	globals.state.upcomingevents.append({code = 'sssexscene', duration = 5})
	
	globals.main.dialogue(state, self, startslave.dictionary(text), buttons, sprites)

func sssexscene(stage = 0):
	var state = true
	var text
	var buttons = []
	var sprites = []
	var startslave
	for i in globals.slaves:
		if i.unique == 'startslave':
			startslave = i
	if startslave == null:
		return
	if startslave.imagefull != null:
		if stage == 0:
			sprites = [[startslave.imagefull,'pos1','opac']]
		else:
			sprites = [[startslave.imagefull,'pos1']]
	match stage:
		0:
			state = false
			text = ssnode.ssfinale
			buttons.append({text = 'Check in', function = 'sssexscene', args = 1})
			buttons.append({text = 'Ignore', function = 'sssexscene', args = 2})
		1:
			var playersex = globals.player.sex
			var slavesex = startslave.sex
			if playersex in ['futanari','dickgirl']:
				playersex = 'male'
			if slavesex == 'futanari':
				slavesex = 'female'
			elif slavesex == 'dickgirl':
				slavesex = 'male'
			
			var textvar = slavesex[0] + playersex[0] #Selecting scene category
			
			var category # Selecting relationship category
			if startslave.traits.has("Dominant"):
				category = 'dom'
			elif startslave.traits.has("Submissive"):
				category = 'sub'
			elif globals.state.decisions.has("ssyandere"):
				category = 'yandere'
			else:
				category = 'neutral'
			
			var sexdict = {
				dom = {
					fm = ssnode.sssexdomfm,
					mm = ssnode.sssexdommm,
					ff = ssnode.sssexdomff,
					mf = ssnode.sssexdommf,
					},
				sub = {
					fm = ssnode.sssexsubfm,
					mm = ssnode.sssexsubmm,
					ff = ssnode.sssexsubff,
					mf = ssnode.sssexsubmf,
					},
				yandere = {
					fm = ssnode.sssexyanfm,
					mm = ssnode.sssexyanmm,
					ff = ssnode.sssexyanff,
					mf = ssnode.sssexyanmf,
					},
				neutral = {
					fm = ssnode.sssexneufm,
					mm = ssnode.sssexneumm,
					ff = ssnode.sssexneuff,
					mf = ssnode.sssexneumf,
					},
			}
			text = sexdict[category][textvar]
			startslave.add_trait("Grateful")
			startslave.loyal += 25
			startslave.obed += 20
		2:
			text = ssnode.sssexignore
	
	globals.main.dialogue(state, self, startslave.dictionary(text), buttons, sprites)

###---Added by Expansion---### DimCrystal Events
#Stages = -10: Dark | 0: Intro | 5: IntroComplete
func dimcrystalinitiate(stage = 0):
	var state = true
	var text
	var buttons = []
	var sprites = []
	
	match stage:
		0:
			globals.main.animationfade(1.5)
			if OS.get_name() != 'HTML5':
				yield(globals.main, 'animfinished')
			globals.main.music_set('stop')
			globals.main.backgroundinstant('mansion')
			globals.main.clearscreen()
			text = "While walking down a side corridor of your manor, you suddenly stop as a strange sensation runs up your spine. Turning to the wall, you notice an old mural detailing some fantastical battle. Examining the area more closely, you notice a small protrusion. You pull gently at it, hear a small click, and the section of wall silently swings open.\n\n[color=red]Warning: Hitting the Close button will break the game.[/color]"
			buttons.append(['Enter the Opening','dimcrystalinitiate',1])
		1:
			globals.main.animationfade(1.5)
			if OS.get_name() != 'HTML5':
				yield(globals.main, 'animfinished')
			globals.main.music_set('start')
			globals.main.backgroundinstant('stairs')
			globals.main.clearscreen()
			text = "Peering inside, you find an old spiral staircase leading down. A hidden cellar perhaps? The stonework is older than the rest of the manor and you can't yet decipher why magic would be wasted to create these beautiful enchanted lights for such a stairwell. Even with your uncle's supposed weath it seems like a frivolous expense.\n\nAt the bottom of the stairs is a dim corridor. You descend it and find that it ends in an weathered, dark-brown wooden door lacking any doorknob that you can see. It is engraved with light purple faintly visible runes that you immediately recognize as powerful, permanent magic sigils. From what you can tell, those runes seem like very old magic and even the linework of the runes seem like distant ancestors of modern magical standards.\n\nYou take off your footware, press it against the door cautiously, and the door does not budge. You put your footware back on before you very cautiously reach forward and press your hand to the door. Surprisingly, the door swings wide open with no resistance whatsoever the moment your hands touch the flickering purple runes. The room beyond is pitch black with the same solid stone flooring beneath your feet stretching as far as you can see into the darkness. The air blowing out from within feels cool and but oddly crisp like the breeze on a cold winter's morning."
			buttons.append(['Step Inside','dimcrystalinitiate',2])
		2:
			globals.main.animationfade(1.5)
			if OS.get_name() != 'HTML5':
				yield(globals.main, 'animfinished')
			globals.main.music_set('explore')
			globals.main.backgroundinstant('dimcrystal_dull')
			globals.main.clearscreen()
			text = "You cautiously enter and find your attention is immediately drawn to the only visible object in the room. Centered within the massive chamber that seems far too large for where you believe it would have to be located beneath your Mansion, an enormous [color=#E389B9]Crystal[/color] is suspended in the air in what appears to be the dead center of the large, smooth stone room. You realize that only the light reflecting from the blue magical lamps in the stairway reflect tiny beams through the dark crystalline prism.\n\nYou step closer towards the [color=#E389B9]Crystal[/color] while feeling a strange sense of belonging encompass you the closer you approach it. You are certain that there are no records of this object or chamber in the mansion's deeds or blueprints. This secret room may have lay here without notice for generations for all that you know.\n\nYou continue your approach and hear the faintest sounds of tingling and the very faintest of humming sounds in the back of your mind. You feel your feet carry you to the crystal and you press your hand against it with a rising certainty and sensation of power. You feel the dormant magic humming softly deep within the [color=#E389B9]Crystal[/color] through your fingertips."
			buttons.append(['Infuse It with Mana','dimcrystalinitiate',3])
		3:
			globals.main.animationfade(1.5)
			if OS.get_name() != 'HTML5':
				yield(globals.main, 'animfinished')
			globals.main.music_set('intimate')
			globals.main.backgroundinstant('dimcrystal_light1')
			globals.main.clearscreen()
			text = "You feel your magic surge into the strange [color=#E389B9]Crystal[/color] as it eager laps up the secret essense of mana within you. You feel it respond to your gift with a growing light and increasing vibrations within it, though they are still faint. The object glows dimly and you feel an immediate connection to it. You have a certainty that this object is the catalyst for powers beyond what any normal mortal could accomplish with modern magic.\n\nYou feel that having given it your magic may have bonded it to you, allowing only you and those you desire to interact with it. You believe that you could commission contractors that you trust to [color=aqua]Upgrade[/color] the powers of the [color=#E389B9]Crystal[/color] by cleaning, polishing, and smoothing out the minor scuffs and damages it has received over time. You believe that between upgrading it, researching it, and resting to understand it, you will be able to master the powers it could grant you.\n\n[color=lime]You can now visit the [color=#E389B9]Crystal[/color] at any time via the picture of it on the main Mansion screen.[/color]"
			buttons.append(['Return Upstairs','dimcrystalinitiate',4])
		4:
			globals.state.sidequests.dimcrystal = 5
			globals.main.animationfade(1.5)
			closedialogue()
			if OS.get_name() != "HTML5":
				yield(globals.main, 'animfinished')
			globals.main.backgroundinstant('mansion')
			globals.main._on_mansion_pressed()
			return
	
	globals.main.dialogue(state, self, str(text), buttons, sprites)


func dimcrystaldarkened(stage = 0):
	var state = true
	var text
	var buttons = []
	var sprites = []
	
	match stage:
		0:
			globals.main.animationfade(1.5)
			if OS.get_name() != 'HTML5':
				yield(globals.main, 'animfinished')
			globals.main.music_set('dungeon')
			globals.main.backgroundinstant('stairs_red')
			globals.main.clearscreen()
			text = "You feel it deep within you...something is wrong with the [color=#E389B9]Crystal[/color]. You feel a strange gnawing hunger in the pit of your stomach any time you try to reach out and touch any of the purplish energy you see infused throughout the house.\n\nYou decide to check on it immediately. From the moment your foot strikes the first step of the stairs, the sensation of gnawing hunger increases. The once-steady magical lighting on the stairs seems to flicker slightly, an unsettling and strange change. There are little trails of light from each of the light sources all heading towards the middle of the chamber as though the light is being ever so slightly pulled towards the [color=#E389B9]Crystal[/color]. You force yourself to press on into the massive smooth stone chamber housing the [color=#E389B9]Crystal[/color].\n\n[color=red]Warning: Hitting the Close button will break the game.[/color]"
			buttons.append(['Rush Downstairs','dimcrystaldarkened',1])
		1:
			globals.main.animationfade(1.5)
			if OS.get_name() != 'HTML5':
				yield(globals.main, 'animfinished')
			globals.main.music_set('dungeon')
			globals.main.backgroundinstant('dimcrystal_dark1')
			globals.main.clearscreen()
			text = "In the center of the room, the [color=#E389B9]Crystal[/color] pulses with sickening reddish light. You feel the odd sensation of emptiness spread from just within your stomach all throughout your body. You can tell that the [color=#E389B9]Crystal[/color] is sharing its needs with you. It feels intensely like the [color=#E389B9]Crystal[/color] is... hungry?\n\nYou think back on how you've used the powers granted to you by the [color=#E389B9]Crystal[/color] and realize you've been, intentionally or not, consuming more of its lifeforce than it can naturally replenish. You can't help but wonder if the [color=#E389B9]Crystal[/color] will start to react differently to being touched now? Is it still safe to research?\n\nThe [color=#E389B9]Crystal[/color] could be dangerous to use in its current condition until it is repaired and restored. There might also be advantages to using it in this dark and broken state, however. Either way, you feel confident that you shouldn't use the [color=#E389B9]Darkened Crystal[/color] on anyone that you care about."
			buttons.append(['Return Upstairs','dimcrystaldarkened',2])
		2:
			globals.state.sidequests.dimcrystal = -10
			globals.main.animationfade(1.5)
			closedialogue()
			if OS.get_name() != "HTML5":
				yield(globals.main, 'animfinished')
			globals.main.backgroundinstant('mansion')
			globals.main._on_mansion_pressed()
			return
	
	globals.main.dialogue(state, self, str(text), buttons, sprites)