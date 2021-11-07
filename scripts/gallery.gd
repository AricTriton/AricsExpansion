
func create(code):
	if characters.has(code):
		var _slave = globals.newslave(characters[code].basics[0], characters[code].basics[1],characters[code].basics[2],characters[code].basics[3])
		_slave.cleartraits()
		_slave.imagefull = null
		if _slave.age == 'child' && globals.rules.children == false:
			_slave.age = 'teen'
		for i in characters[code]:
			if i in _slave:
				_slave[i] = characters[code][i]
			elif i in _slave.stats:
				_slave.stats[i] = characters[code][i]
		###---Added by Expansion---### Unique Genealogy Fixer
		uniqueGenealogyFixer(_slave)
		###---End Expansion---###
		return _slave
	else:
		return "Character not found: " + code

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

}
