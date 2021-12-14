
func create(name):
	var refChar = characters.get(name)
	if characters.has(name):
		var person = globals.newslave(refChar.basics[0], refChar.basics[1],refChar.basics[2],refChar.basics[3])
		person.cleartraits()
		person.imagefull = null
		if person.age == 'child' && globals.rules.children == false:
			person.age = 'teen'
		for i in refChar:
			if i == 'traits':
				for j in refChar[i]:
					person.add_trait(j)
			elif i in person:
				person[i] = refChar[i]
			elif i in person.stats:
				person.stats[i] = refChar[i]
			elif i != 'basics':
				globals.printErrorCode("Gallery character improper attribute: " + str(i) + " on " + name)
		###---Added by Expansion---### Unique Genealogy Fixer
		uniqueGenealogyFixer(person)
		###---End Expansion---###
		return person
	else:
		globals.printErrorCode("Gallery character not found: " + name)
		return null

###---Added by Expansion---### Unique Genealogy Fixer
func uniqueGenealogyFixer(_slave):
	if _slave.npcexpanded.racialbonusesapplied == true && globals.expansionsettings.racialstatbonuses == true:
		globals.expansionsetup.setRaceBonus(_slave, false)
	var racegenes = globals.constructor.genealogy_decoder(_slave.race)
	if _slave.race.find('Halfkin') >= 0:
		_slave.genealogy[racegenes] = 70
		_slave.genealogy.human = 30
		for i in _slave.genealogy:
			if !i in ['human',racegenes]:
				_slave.genealogy[i] = 0
	else:
		_slave.genealogy[racegenes] = 100
		for i in _slave.genealogy:
			if !i in ['human',racegenes]:
				_slave.genealogy[i] = 0
	if globals.expansionsettings.racialstatbonuses == true:
		globals.expansionsetup.setRaceBonus(_slave, true)
	globals.constructor.setRaceDisplay(_slave)
###---End Expansion---###
