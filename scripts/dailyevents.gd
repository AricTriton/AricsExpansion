

#ralphC
func succubuscheck(npc,minorgasms,maxorgasms):
	var succubusfed = false
	if npc != null && npc.race_display == "Succubus":
		npc.mana_hunger -= variables.orgasmmana * randi()%(max(maxorgasms-1,1)+minorgasms)
		succubusfed = true
	return succubusfed
#/ralphC

func play(stage = 0):
	var tempbuttons
	showntext = eventstext[currentevent][stage]
	if stage == 0:
		tempbuttons = [['Play Active Games (-25 energy)', 1], ['Play Logic Games (-25 energy)',2], ['Play Lewd Games (-25 energy)', 3], ['Send $him off',4]]
	if stage == 1:
		person.cour += rand_range(0,10)
		person.conf += rand_range(0,10)
		person.loyal += rand_range(10,15)
		person.stress += -rand_range(15,25)
	elif stage == 2:
		person.wit += rand_range(0,10)
		person.charm += rand_range(0,10)
		person.loyal += rand_range(10,15)
		person.obed += rand_range(15,25)
		person.learningpoints += round(rand_range(3,6))
	elif stage == 3:
		person.lust = -rand_range(5,10)
		person.lewdness += rand_range(3,5)
		person.lastsexday = globals.resources.day
		if !succubuscheck(person,1,1): #ralphC - also indented below
			globals.resources.mana += rand_range(2,3)
			###---Added by Expansion---### Races Expanded
			if person.race.find("Dark Elf") >= 0:
			###---Expansion End---###
				globals.resources.mana += 1
	elif stage == 4:
		person.loyal += -rand_range(5,10)
		person.obed += -rand_range(15,25)
	if stage != 0 && stage != 4:
		globals.player.energy -= 25
	buttons = tempbuttons
	showevent()

func spendtime(stage = 0):
	var tempbuttons
	showntext = eventstext[currentevent][stage]
	if stage == 0:
		tempbuttons = [['Visit Town (-25 energy)', 1], ['Have intimate talk (-25 energy)',2], ['Sex (-25 energy)', 3], ['Send $him off',4]]
	if stage == 1:
		person.cour += rand_range(0,10)
		person.conf += rand_range(0,10)
		person.loyal += rand_range(10,15)
		person.obed += rand_range(15,25)
	elif stage == 2:
		person.wit += rand_range(0,10)
		person.charm += rand_range(0,10)
		person.loyal += rand_range(10,15)
		person.stress += -rand_range(15,25)
	elif stage == 3:
		person.lastsexday = globals.resources.day
		person.lust = -rand_range(15,25)
		if !succubuscheck(person,1,2): #ralphC - also indented below
			globals.resources.mana += rand_range(3,5)
			###---Added by Expansion---### Races Expanded
			if person.race.find("Dark Elf") >= 0:
			###---Expansion End---###
				globals.resources.mana += 1
	elif stage == 4:
		person.loyal += -rand_range(5,10)
		person.obed += -rand_range(15,25)
	if stage != 0 && stage != 4:
		globals.player.energy -= 25
	buttons = tempbuttons
	showevent()

func horny(stage = 0):
	var tempbuttons
	showntext = eventstext[currentevent][stage]
	if stage == 0:
		tempbuttons = [['Accept (-25 energy)', 1], ['Discipline (-25 energy)',2], ['Ignore ', 3]]
	if stage == 1:
		person.lastsexday = globals.resources.day
		person.lust = -rand_range(15,25)
		person.loyal += rand_range(5,10)
		person.stress += -rand_range(15,25)
		if !succubuscheck(person,1,2): #ralphC - also indented below
			globals.resources.mana += rand_range(3,5)
			###---Added by Expansion---### Races Expanded
			if person.race.find("Dark Elf") >= 0:
			###---Expansion End---###
				globals.resources.mana += 1
	elif stage == 2:
		person.obed += rand_range(20,35)
		person.lust = rand_range(15,25)
	elif stage == 3:
		person.obed += -rand_range(25,35)
		person.loyal += -rand_range(5,10)
	if stage != 0 && stage != 3:
		globals.player.energy -= 25
	buttons = tempbuttons
	showevent()

func strangerdisrespect(stage = 0):
	var tempbuttons
	showntext = eventstext[currentevent][stage]
	if stage == 0:
		tempbuttons = [["Let him use $name for a day",2], ["Reject", 3]]
		if globals.resources.gold >= 100:
			tempbuttons.insert(0, ['Compensate', 1])
	if stage == 1:
		globals.resources.gold -= 100
		person.loyal += rand_range(10,20)
	elif stage == 2:
		person.away.duration = 1
		person.away.at = 'stranger'
		person.lastsexday = globals.resources.day
		person.loyal -= rand_range(10,15)
		person.obed -= rand_range(15,25)
		person.lewdness += rand_range(3,6)
		if succubuscheck(person,2,6): #ralphC 
			 person.lust = person.lust / 2  #ralphC
	elif stage == 3:
		globals.state.reputation.wimborn -= rand_range(3,5)
		person.obed += rand_range(10,20)
		person.stress += rand_range(15,30)
	buttons = tempbuttons
	showevent()

func gift(stage = 0):
	var tempbuttons
	showntext = eventstext[currentevent][stage]
	if stage == 0:
		if globals.resources.gold < 50:
			tempbuttons = [["Deny", 2]]
		else:
			tempbuttons = [["Comply (-50 gold)",1],["Deny",2], ["Make $name earn it (-25 energy)", 3]]
	if stage == 1:
		person.loyal += rand_range(5,10)
		person.obed += rand_range(10,15)
		globals.resources.gold -= 50
	elif stage == 2:
		person.obed += -rand_range(20,35)
		person.loyal += -rand_range(2,5)
	elif stage == 3:
		if person.consent == false:
			person.obed += -rand_range(20,40)
			person.loyal += -rand_range(5,10)
			showntext += "$name is disgusted by your implications and leaves infuriated. "
		else:
			person.lastsexday = globals.resources.day
			showntext += "You spread your legs and bare your crotch, inviting $name over to which $he readily responds. After couple pleasant minutes of $name's eager mouth work you pass $him the requested money and return to your work. "
			person.obed += rand_range(10,25)
			person.lust = rand_range(10,15)
			person.sexuals.affection += round(rand_range(1,3))
			globals.resources.gold -= 50
			if !succubuscheck(person,1,2): #ralphC - also indented below
				globals.resources.mana += rand_range(3,6)
				###---Added by Expansion---### Races Expanded
				if person.race.find("Dark Elf") >= 0:
				###---Expansion End---###
					globals.resources.mana += 1
			globals.player.energy -= 25
	buttons = tempbuttons
	showevent()

func teenagersflirt(stage = 0):
	var tempbuttons
	showntext = eventstext[currentevent][stage]
	if stage == 0:
		tempbuttons = [["Drive them away (-25 energy)",1],["Let $name serve them (-25 energy)",2], ["Ignore", 3]]
	if stage == 1:
		globals.player.energy -= 25
		person.loyal += rand_range(7,15)
		person.obed += rand_range(10,15)
	elif stage == 2:
		globals.player.energy -= 25
		person.metrics.randompartners += round(rand_range(3,5))
		person.metrics.sex += 1
		person.lastsexday = globals.resources.day
		if (person.metrics.vag > 0 || person.metrics.anal > 0) && person.traits.has("Monogamous") == false:
			if !succubuscheck(person,3,6): #ralphC - also indented below
				globals.resources.mana += rand_range(5,10)
				###---Added by Expansion---### Races Expanded
				if person.race.find("Dark Elf") >= 0:
				###---Expansion End---###
					globals.resources.mana += 2
			person.loyal += -rand_range(5,10)
			showntext += "Getting caught up in the action, $name gets on all fours and lets one of the boys take $him from behind. "
			
			if person.vagina != 'none':
				person.metrics.vag += round(rand_range(1,3))
			if person.metrics.anal > 0:
				person.metrics.anal += round(rand_range(1,2))
		else:
			showntext += "$name greatly distressed with situation but having no ways out $he only keeps grudge against you. "
			person.stress += rand_range(15,25)
			person.loyal += -rand_range(10,20)
			person.obed += -rand_range(30,50)
		showntext += "After short time the boys shower the $child in semen. Satisfied with your hospitality, they leave happy. "
		if !succubuscheck(person,2,4): #ralphC - also indented below
			globals.resources.mana += rand_range(3,6)
			###---Added by Expansion---### Races Expanded
			if person.race.find("Dark Elf") >= 0:
			###---Expansion End---###
				globals.resources.mana += 1
	elif stage == 3:
		pass
	buttons = tempbuttons
	showevent()

func fickleevent(stage = 0):
	var tempbuttons
	if stage == 0:
		tempbuttons = [["Shoo them away (-25 energy)",1],["Have threesome (-25 energy)",2], ["Ignore", 3]]
	if stage == 1:
		person.loyal += -rand_range(7,15)
		person.obed += -rand_range(10,20)
		person.lust = rand_range(15,25)
		globals.player.energy -= 25
	elif stage == 2:
		person.loyal += rand_range(5,10)
		person.consent = true
		globals.impregnation(person)
		person.lust = -rand_range(10,20)
		globals.player.energy -= 25
		person.lastsexday = globals.resources.day #ralphC - moved from below
		if !succubuscheck(person,0,0): #ralphC - also indented below
			globals.resources.mana += rand_range(4,10)
			###---Added by Expansion---### Races Expanded
			if person.race.find("Dark Elf") >= 0:
			###---Expansion End---###
				globals.resources.mana += 2
	elif stage == 3:
		person.lastsexday = globals.resources.day
		person.lust = -rand_range(10,20)
	buttons = tempbuttons
	showntext = eventstext[currentevent][stage]
	
	showevent()

func pervertevent(stage = 0):
	var tempbuttons
	var temp = false #ralphC - just so succubus check function doesn't produce any error messages for unused return boolean
	var peniscount = 0 #ralphC
	if stage == 0:
		slave2 = findfreeslave()
		tempbuttons = [["Interrupt them (-25 energy)",1],["Escalate the situtation (-25 energy)",2], ["Ignore", 3]]
	if stage == 1:
		person.loyal -= rand_range(5,10)
		slave2.loyal += rand_range(5,10)
		person.obed += -rand_range(10,20)
		globals.player.energy -= 25
	elif stage == 2:
		person.lastsexday = globals.resources.day
		slave2.lastsexday = globals.resources.day
		person.loyal += rand_range(5,10)
		person.lust = -rand_range(10,20)
		slave2.obed += -rand_range(10,30)
		slave2.lust = -rand_range(10,15)
		globals.player.energy -= 25
		#ralphC
		if person.race_display == 'Succubus' && slave2.race_display == 'Succubus': #ralphC - also indented below
			globals.resources.mana += 0
			if globals.player.penis != "none":
				temp = succubuscheck(person,1,1)
				temp = succubuscheck(slave2,1,1)
		elif slave2.race_display == 'Succubus':
			if globals.player.penis != "none":
				peniscount += 1
			if person.penis != "none":
				peniscount += 1
			temp = succubuscheck(slave2,peniscount,peniscount)
			globals.resources.mana += (2 - peniscount) * variables.orgasmmana
		elif person.race_display == 'Succubus':
			if globals.player.penis != "none":
				peniscount += 1
			if slave2.penis != "none":
				peniscount += 1
			temp = succubuscheck(person,peniscount,peniscount)
			globals.resources.mana += (2 - peniscount) * variables.orgasmmana
		else: #ralphC note - else original code for mana gain
			globals.resources.mana += rand_range(5,10)
			###---Added by Expansion---### Races Expanded
			if person.race.find("Dark Elf") >= 0:
			###---Expansion End---###
				globals.resources.mana += 2
		#/ralphC
	buttons = tempbuttons
	showntext = eventstext[currentevent][stage]
	
	showevent()
