
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

var characters = {
Melissa = {
basics = ['Human', 'adult', 'female', 'noble'],
name = 'Melissa',
surname = '',
titssize = 'big',
asssize = 'average',
beautybase = 84,
hairlength = 'shoulder',
height = 'average',
haircolor = 'brown',
eyecolor = 'green',
hairstyle = 'straight',
vagvirgin = false,
unique = 'Melissa',
imageportait = "res://files/images/melissa/melissaportrait.png",
obed = 20,
cour = 77,
conf = 90,
wit = 97,
charm = 84,
asser = 70,
skin = 'fair',
traits = ['Authority']
},
Emily = {
basics = ['Human', 'teen', 'female', 'poor'],
name = 'Emily',
surname = 'Hale',
titssize = 'small',
asssize = 'small',
beautybase = 33,
hairlength = 'neck',
height = 'average',
haircolor = 'brown',
eyecolor = 'gray',
hairstyle = 'straight',
vagvirgin = true,
unique = 'Emily',
tags = ['nosex'],
imageportait = "res://files/images/emily/emilyportrait.png",
asser = 25,
obed = 80,
cour = 35,
conf = 28,
wit = 54,
charm = 41,
skin = 'pale',
traits = ['Small Eater']
},
Tisha = {
basics = ['Human', 'adult', 'female', 'commoner'],
name = 'Tisha',
surname = 'Hale',
unique = 'Tisha',
beautybase = 80,
haircolor = 'auburn',
hairlength = 'waist',
hairstyle = 'braid',
titssize = 'big',
asssize = 'average',
skin = 'fair',
eyecolor = 'gray',
vagvirgin = false,
asser = 40,
cour = 65,
conf = 58,
wit = 39,
charm = 71,
height = 'average',
imageportait = "res://files/images/tisha/tishaportrait.png",
traits = ['Hard Worker']
},
Cali = {
basics = ['Halfkin Wolf', 'child', 'female', 'commoner'],
name = 'Cali',
surname = '',
titssize = 'flat',
asssize = 'small',
beautybase = 55,
hairlength = 'shoulder',
height = 'short',
haircolor = 'gray',
eyecolor = 'blue',
eyeshape = 'slit',
hairstyle = 'straight',
skin = 'fair',
imageportait = 'res://files/images/cali/caliportrait.png',
vagvirgin = true,
asser = 37,
obed = 65,
cour = 47,
conf = 55,
wit = 35,
charm = 20,
unique = "Cali",
traits = ['Sturdy']
},
Chloe = {
basics = ['Gnome', 'adult', 'female', 'commoner'],
name = 'Chloe',
unique = 'Chloe',
surname = '',
titssize = 'average',
asssize = 'big',
beautybase = 60,
hairlength = 'shoulder',
height = 'tiny',
haircolor = 'red',
eyecolor = 'blue',
skin = 'fair',
hairstyle = 'twintails',
vagvirgin = false,
imageportait = 'res://files/images/chloe/chloeportrait.png',
asser = 30,
cour = 57,
conf = 34,
wit = 77,
charm = 51,
obed = 90,
traits = ['Grateful', 'Gifted']
},
Tia = {
basics = ['Human', 'teen', 'female', 'commoner'],
name = 'Tia',
surname = '',
beautybase = 75,
haircolor = 'brown',
hairlength = 'waist',
hairstyle = 'straight',
titssize = 'small',
asssize = 'small',
skin = 'fair',
eyecolor = 'blue',
vagvirgin = true,
asser = 20,
cour = 23,
conf = 31,
wit = 55,
charm = 82,
height = 'short',
},
Ayneris = {
basics = ['Elf', 'teen', 'female', 'noble'],
name = 'Ayneris',
unique = 'Ayneris',
imageportait = "res://files/images/ayneris/aynerisportrait.png",
surname = '',
titssize = 'average',
asssize = 'average',
beautybase = 65,
hairlength = 'waist',
height = 'average',
haircolor = 'blond',
eyecolor = 'blue',
skin = 'fair',
hairstyle = 'straight',
vagvirgin = false,
asser = 55,
cour = 65,
conf = 88,
wit = 51,
charm = 48,
level = 2,
agi_base = 2,
str_base = 1,
skillpoints = 3, #ralph4
obed = 90,
traits = ['Nimble']
},
Yris = {
basics = ['Beastkin Cat', 'adult', 'female', 'commoner'],
name = 'Yris',
unique = 'Yris',
surname = '',
titssize = 'big',
asssize = 'average',
beautybase = 72,
hairlength = 'neck',
height = 'average',
haircolor = 'blond',
eyecolor = 'blue',
eyeshape = 'slit',
skin = 'fair',
furcolor = 'orange_white',
hairstyle = 'straight',
vagvirgin = false,
asser = 65,
charm = 71,
wit = 62,
cour = 33,
conf = 48,
imageportait = "res://files/images/yris/yrisportrait.png",
agi_base = 1,
end_base = 1,
loyal = 25,
obed = 90,
traits = ['Grateful', 'Scoundrel']
},
Maple = {
basics = ['Fairy', 'adult', 'female', 'rich'],
name = 'Maple',
unique = 'Maple',
surname = '',
titssize = 'average',
asssize = 'small',
beautybase = 74,
hairlength = 'shoulder',
height = 'tiny',
haircolor = 'red',
eyecolor = 'red',
skin = 'fair',
hairstyle = 'straight',
vagvirgin = false,
imageportait = 'res://files/images/maple/mapleportrait.png',
asser = 47,
cour = 65,
conf = 73,
wit = 69,
charm = 92,
level = 5,
skillpoints = 6, #ralph4
obed = 90,
traits = ['Grateful', 'Influential']
},
Zoe = {
basics = ['Beastkin Wolf', 'teen', 'female', 'noble'],
name = 'Zoe',
unique = 'Zoe',
surname = '',
beautybase = 45,
haircolor = 'brown',
hairlength = 'shoulder',
hairstyle = 'straight',
titssize = 'average',
asssize = 'average',
skin = 'fair',
eyecolor = 'red',
vagvirgin = true,
asser = 42,
cour = 45,
conf = 55,
wit = 87,
charm = 66,
height = 'average',
furcolor = 'gray',
obed = 90,
loyal = 25,
imageportait = 'res://files/images/zoe/zoeportrait.png',
maf_base = 1,
traits = ['Grateful', 'Mentor']
},
Ayda = {
basics = ['Dark Elf', 'adult', 'female', 'rich'],
name = 'Ayda',
unique = 'Ayda',
surname = '',
beautybase = 45,
haircolor = 'white',
hairlength = 'waist',
hairstyle = 'ponytail',
titssize = 'average',
asssize = 'big',
skin = 'brown',
eyecolor = 'amber',
vagvirgin = false,
asser = 65,
cour = 45,
conf = 66,
wit = 78,
charm = 32,
height = 'tall',
obed = 90,
loyal = 10,
imageportait = 'res://files/images/ayda/aydaportrait.png',
tags = ['nosex'],
maf_base = 2,
end_base = 1,
traits = ['Experimenter'],
},
}

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
