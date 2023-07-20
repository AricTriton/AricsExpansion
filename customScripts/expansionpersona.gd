### <CustomFile> ###
"""
Template to read so I don't keep switching tabs
# Melissa = {
# 		basics = ['Human', 'adult', 'female', 'noble'],
# 		name = 'Melissa',
# 		surname = '',
# 		titssize = 'big',
# 		asssize = 'average',
# 		beautybase = 49,
# 		hairlength = 'shoulder',
# 		height = 'average',
# 		haircolor = 'brown',
# 		eyecolor = 'green',
# 		hairstyle = 'straight',
# 		vagvirgin = false,
# 		unique = 'Melissa',
# 		imageportait = 'res://files/images/melissa/melissaportrait.png',
# 		obed = 20,
# 		cour = 77,
# 		conf = 65,
# 		wit = 97,
# 		charm = 84,
# 		asser = 70,
# 		level = 4,
# 		str_base = 1,
# 		agi_base = 3,
# 		maf_base = 2,
# 		end_base = 2,
# 		skillpoints = 0,
# 		lewdness = 60,
# 		skin = 'fair',
# 		traits = ['Authority', 'Natural Beauty', 'Dominant', 'Responsive'],
# 		ability = ['attack', 'shackle', 'sedation', 'mindblast'],
# 	},
"""

#For access to names
var namefile = load("res://files/scripts/characters/names.gd").new()
var names = namefile.names

var persona = {
	AliceClassic = {
		basics = ['Human', 'adult', 'female', 'commoner'],
		persona = 'AliceClassic',
		name = 'Alice',
		surname = 'Bunny',
		imageportait = 'res://files/aric_expansion_images/KK/Alice Portraits/A_Base_portrait.png' ,
		skin = 'fair',
		titssize = 'big',
		asssize = 'average',
		beautybase = 50,
		hairlength = 'shoulder',
		height = 'short',
		haircolor = 'brown',
		eyecolor = 'green',
		hairstyle = 'straight',
		vagvirgin = false,
		obed = 100,
		cour = 10,
		conf = 20,
		wit = 50,
		charm = 50,
		asser = 20,
		skillpoints = 0,
		lewdness = 60,
		traits = ['Submissive','Likes it rough'],
		ability = ['attack'],
		#Expansion Added Attributes
		#Sexuality
		sexuality = 'bi',
		#npcexpandedstuff- body
		asshole = 'tight',
		vagina = 'tight',
		#fetishes
		fetish = {
			exhibitionism = "acceptable",
			drinkcum = "acceptable",
			wearcum = "uncertain",
			wearcumface = "uncertain",
			creampiemouth = "mindblowing",
			creampiepussy = "mindblowing",
			pregnancy = "unacceptable",
			oviposition = "taboo",
			bondage = "enjoyable",
			dominance = "uncertain",
			submission = "mindblowing",
			sadism = "taboo",
			masochism = "uncertain",
			transformation = "dirty"
		}
	},
	AliceBunny = {
		basics = ['Halfkin Bunny', 'adult', 'female', 'commoner'],
		persona = 'AliceBunny',
		name = 'Alice',
		surname = 'Bunny',
		imageportait = 'res://files/aric_expansion_images/KK/Alice Portraits/A_bunny_portrait.png', 
		skin = 'fair',
		titssize = 'big',
		asssize = 'average',
		beautybase = 50,
		hairlength = 'shoulder',
		height = 'short',
		haircolor = 'brown',
		eyecolor = 'green',
		hairstyle = 'straight',
		vagvirgin = false,
		obed = 100,
		cour = 10,
		conf = 20,
		wit = 50,
		charm = 50,
		asser = 20,
		lewdness = 60,
		traits = ['Submissive','Likes it rough'],
		ability = ['attack'],
		#Expansion Added Attributes
		#Sexuality
		sexuality = 'bi',
		#npcexpandedstuff- body
		asshole = 'tight',
		vagina = 'tight',
		#fetishes
		fetish = {
			exhibitionism = "mindblowing",
			drinkcum = "acceptable",
			wearcum = "uncertain",
			wearcumface = "uncertain",
			creampiemouth = "mindblowing",
			creampiepussy = "mindblowing",
			pregnancy = "mindblowing",
			oviposition = "taboo",
			bondage = "enjoyable",
			dominance = "uncertain",
			submission = "mindblowing",
			sadism = "taboo",
			masochism = "uncertain",
			transformation = "dirty"
		}
	},
	AliceMeow = {
		basics = ['Halfkin Cat', 'adult', 'female', 'commoner'],
		persona = 'AliceMeow',
		name = 'Alice',
		surname = 'Meow',
		imageportait = 'res://files/aric_expansion_images/KK/Alice Portraits/A_cat_portrait.png', 
		skin = 'fair',
		titssize = 'big',
		asssize = 'average',
		beautybase = 50,
		hairlength = 'shoulder',
		height = 'short',
		haircolor = 'brown',
		eyecolor = 'green',
		hairstyle = 'straight',
		vagvirgin = false,
		obed = 100,
		cour = 10,
		conf = 20,
		wit = 50,
		charm = 50,
		asser = 20,
		lewdness = 60,
		traits = ['Submissive','Likes it rough'],
		ability = ['attack'],
		#Expansion Added Attributes
		#Sexuality
		sexuality = 'bi',
		#npcexpandedstuff- body
		asshole = 'tight',
		vagina = 'tight',
		#fetishes
		fetish = {
			drinkmilk = "mindblowing",
			exhibitionism = "acceptable",
			drinkcum = "acceptable",
			wearcum = "uncertain",
			wearcumface = "uncertain",
			creampiemouth = "mindblowing",
			creampiepussy = "mindblowing",
			pregnancy = "unacceptable",
			oviposition = "taboo",
			bondage = "enjoyable",
			dominance = "uncertain",
			submission = "mindblowing",
			sadism = "taboo",
			masochism = "uncertain",
			transformation = "dirty"
		}
	},
	AlicePuppy = {
		basics = ['Halfkin Wolf', 'adult', 'female', 'commoner'],
		persona = 'AlicePuppy',
		name = 'Alice',
		surname = 'Puppy',
		imageportait = 'res://files/aric_expansion_images/KK/Alice Portraits/A_dog_portrait.png',
		skin = 'fair',
		titssize = 'big',
		asssize = 'average',
		beautybase = 50,
		hairlength = 'shoulder',
		height = 'short',
		haircolor = 'brown',
		eyecolor = 'green',
		hairstyle = 'straight',
		vagvirgin = false,
		obed = 100,
		cour = 10,
		conf = 20,
		wit = 50,
		charm = 50,
		asser = 20,
		skillpoints = 0,
		lewdness = 60,
		traits = ['Submissive','Likes it rough'],
		ability = ['attack'],
		#Expansion Added Attributes
		#Sexuality
		sexuality = 'bi',
		#npcexpandedstuff- body
		asshole = 'tight',
		vagina = 'tight',
		#fetishes
		fetish = {
			pissing = "mindblowing",
			drinkpiss = "enjoyable",
			wearpiss = "mindblowing",
			otherspissing = "enjoyable",
			exhibitionism = "acceptable",
			drinkcum = "acceptable",
			wearcum = "uncertain",
			wearcumface = "uncertain",
			creampiemouth = "mindblowing",
			creampiepussy = "mindblowing",
			pregnancy = "unacceptable",
			oviposition = "taboo",
			bondage = "enjoyable",
			dominance = "uncertain",
			submission = "mindblowing",
			sadism = "taboo",
			masochism = "uncertain",
			transformation = "dirty"
		}
	},
	AliceFoxy = {
		basics = ['Halfkin Fox', 'adult', 'female', 'commoner'],
		persona = 'AliceFoxy',
		name = 'Alice',
		surname = 'Foxxy',
		imageportait = 'res://files/aric_expansion_images/KK/Alice Portraits/A_fox_portrait.png',
		skin = 'fair',
		titssize = 'big',
		asssize = 'average',
		beautybase = 50,
		hairlength = 'shoulder',
		height = 'short',
		haircolor = 'brown',
		eyecolor = 'green',
		hairstyle = 'straight',
		vagvirgin = false,
		obed = 100,
		cour = 10,
		conf = 20,
		wit = 50,
		charm = 50,
		asser = 20,
		maf_base = 2,
		skillpoints = 0,
		lewdness = 60,
		traits = ['Submissive','Likes it rough'],
		ability = ['attack'],
		#Expansion Added Attributes
		#Sexuality
		sexuality = 'bi',
		#npcexpandedstuff- body
		asshole = 'tight',
		vagina = 'tight',
		#fetishes
		fetish = {
			exhibitionism = "acceptable",
			drinkcum = "acceptable",
			wearcum = "uncertain",
			wearcumface = "uncertain",
			creampiemouth = "mindblowing",
			creampiepussy = "mindblowing",
			pregnancy = "unacceptable",
			oviposition = "taboo",
			bondage = "uncertain",
			dominance = "uncertain",
			submission = "mindblowing",
			sadism = "taboo",
			masochism = "uncertain",
			transformation = "dirty"
		}
	},
	AliceMilker = {
		basics = ['Taurus', 'adult', 'female', 'commoner'],
		persona = 'AliceMilker',
		name = 'Alice',
		surname = 'Milker',
		skin = 'fair',
		titssize = 'big',
		asssize = 'average',
		beautybase = 50,
		hairlength = 'shoulder',
		height = 'short',
		haircolor = 'brown',
		eyecolor = 'green',
		hairstyle = 'straight',
		vagvirgin = false,
		obed = 100,
		cour = 10,
		conf = 20,
		wit = 50,
		charm = 50,
		asser = 20,
		lewdness = 60,
		traits = ['Submissive','Likes it rough'],
		ability = ['attack'],
		#Expansion Added Attributes
		#Sexuality
		sexuality = 'bi',
		#npcexpandedstuff- body
		asshole = 'tight',
		vagina = 'tight',
		#fetishes
		fetish = {
			bemilked = "bemilked",
			lactation = "mindblowing",
			exhibitionism = "acceptable",
			drinkcum = "acceptable",
			wearcum = "uncertain",
			wearcumface = "uncertain",
			creampiemouth = "mindblowing",
			creampiepussy = "mindblowing",
			pregnancy = "unacceptable",
			oviposition = "taboo",
			bondage = "enjoyable",
			dominance = "uncertain",
			submission = "mindblowing",
			sadism = "taboo",
			masochism = "uncertain",
			transformation = "dirty"
		}
	}
}
# imageportait = 'res://files/aric_expansion_images/characters/ivranaportrait.png', Portrait addition template to persona data
#sprites is also supposed to contain portrait images. If the above doesn't work try adding them here. This is just to see what happens.
var sprites = {
	#Alices
	#classic
	alice_classic = load("res://files/aric_expansion_images/KK/Alice Portraits/A_Base.png"),
	alice_classic_naked = load("res://files/aric_expansion_images/KK/Alice Portraits/A_base_naked.png"),
	alice_classic_preg = load("res://files/aric_expansion_images/KK/Alice Portraits/A_base_preg.png"),
	#bunny
	alice_bunny = load("res://files/aric_expansion_images/KK/Alice Portraits/A_bunny.png"),
	alice_bunny_naked = load("res://files/aric_expansion_images/KK/Alice Portraits/A_bunny_naked.png"),
	alice_bunny_preg = load("res://files/aric_expansion_images/KK/Alice Portraits/A_bunny_preg.png"),
	#meow
	alice_meow = load("res://files/aric_expansion_images/KK/Alice Portraits/A_cat.png"),
	alice_meow_naked = load("res://files/aric_expansion_images/KK/Alice Portraits/A_cat_naked.png"),
	alice_meow_preg = load("res://files/aric_expansion_images/KK/Alice Portraits/A_cat_preg.png"),
	#puppy
	alice_puppy = load("res://files/aric_expansion_images/KK/Alice Portraits/A_dog.png"),
	alice_puppy_naked = load("res://files/aric_expansion_images/KK/Alice Portraits/A_dog_naked.png"),
	alice_puppy_preg = load("res://files/aric_expansion_images/KK/Alice Portraits/A_dog_preg.png"),
	#foxy
	alice_foxy = load("res://files/aric_expansion_images/KK/Alice Portraits/A_fox.png"),
	alice_foxy_naked = load("res://files/aric_expansion_images/KK/Alice Portraits/A_fox_naked.png"),
	alice_foxy_preg = load("res://files/aric_expansion_images/KK/Alice Portraits/A_fox_preg.png")
	#milker
}

var persona_videos = { #store persona-related videos here
	nothing = 'nothing to see here'
}

func createpersona(persona):
	var refChar = persona.get(persona)
	if persona.has(name):
		var person = globals.newslave(refChar.basics[0], refChar.basics[1],refChar.basics[2],refChar.basics[3])
		person.cleartraits()
		person.imagefull = null
		if person.age == 'child' && globals.rules.children == false:
			person.age = 'teen'
		for i in refChar:
			if i == 'traits':
				for j in refChar[i]:
					person.add_trait(j)
			elif i == 'fetish':
				for j in refChar[i]:
					person.fetish[j] = refChar.fetish[j]
			elif i in person:
				person[i] = refChar[i]
			elif i in person.stats:
				person.stats[i] = refChar[i]
			elif i in person.npcexpanded:
				person.npcexpanded[i] = refChar[i]
			elif i in person.pregexp:
				person.npcexpanded[i] = refChar[i]
			elif i in person.lactating:
				person.lactating[i] = refChar[i]
			elif i in person.consentexp:
				person.consentexp[i] = refChar[i]
			elif i != 'basics':
				globals.printErrorCode("Persona character improper attribute: " + str(i) + " on " + name)
		###---Added by Expansion---### Unique Genealogy Fixer
		#uniqueGenealogyFixer(person)
		###---End Expansion---###
		if globals.state.relativesdata.has(person.id):
			globals.state.relativesdata[person.id].name = person.name_long()
		return person
	else:
		globals.printErrorCode("Persona character not found: " + name)
		return null

func aliceinfinite(alice): #This function can be further generalized I think but this will do for now.
	if alice.race in ["Human", "Halfkin Bunny", "Halfkin Cat", "Halfkin Wolf", "Halfkin Fox"]:
		alice.surname = names.humansurname
	elif alice.race == "Taurus":
		alice.surname = names.taurussurname
	else: 
		globals.printErrorCode("Alice: Unrecognized Race on" + alice.name)
	return alice


func countpersona(persona): #takes an array as an argument. Double check syntax.
	var counter = 0
	for i in globals.slaves:
		if i.persona in persona:
			counter += 1
	return counter
		
func countpersonbyname(persons):
	var counter = 0
	for i in globals.slaves:
		if i.name in persons:
			counter += 1
	return counter

#Brought this here to mimic the dictionary structure for uniques without linking the entire script here.
enum {IMAGE_DEFAULT, IMAGE_NAKED}
enum {LOW_STRESS, MID_STRESS, HIGH_STRESS, IMAGE_PREG}
var typeEnumToString = ['default','naked']

var dictPersonaImagePaths = {
	'AliceClassic': {
		IMAGE_DEFAULT: {
			HIGH_STRESS: 'res://files/aric_expansion_images/KK/Alice Portraits/A_Base.png',
			IMAGE_PREG: 'res://files/aric_expansion_images/KK/Alice Portraits/A_Base_preg.png',
		},
		IMAGE_NAKED: {
			HIGH_STRESS: 'res://files/aric_expansion_images/KK/Alice Portraits/A_base_naked.png',
		},
	},
	'AliceBunny': {
		IMAGE_DEFAULT: {
			HIGH_STRESS: 'res://files/aric_expansion_images/KK/Alice Portraits/A_bunny.png',
			IMAGE_PREG: 'res://files/aric_expansion_images/KK/Alice Portraits/A_bunny_preg.png',
		},
		IMAGE_NAKED: {
			HIGH_STRESS: 'res://files/aric_expansion_images/KK/Alice Portraits/A_bunny_naked.png',
		},
	},
	'AliceMeow': {
		IMAGE_DEFAULT: {
			HIGH_STRESS: 'res://files/aric_expansion_images/KK/Alice Portraits/A_cat.png',
			IMAGE_PREG: 'res://files/aric_expansion_images/KK/Alice Portraits/A_cat_preg.png',
		},
		IMAGE_NAKED: {
			HIGH_STRESS: 'res://files/aric_expansion_images/KK/Alice Portraits/A_cat_naked.png',
		},
	},
	'AlicePuppy': {
		IMAGE_DEFAULT: {
			HIGH_STRESS: 'res://files/aric_expansion_images/KK/Alice Portraits/A_dog.png',
			IMAGE_PREG: 'res://files/aric_expansion_images/KK/Alice Portraits/A_dog_preg.png',
		},
		IMAGE_NAKED: {
			HIGH_STRESS: 'res://files/aric_expansion_images/KK/Alice Portraits/A_dog_naked.png',
		},
	},
	'AliceFoxy': {
		IMAGE_DEFAULT: {
			HIGH_STRESS: 'res://files/aric_expansion_images/KK/Alice Portraits/A_foxy.png',
			IMAGE_PREG: 'res://files/aric_expansion_images/KK/Alice Portraits/A_foxy_preg.png',
		},
		IMAGE_NAKED: {
			HIGH_STRESS: 'res://files/aric_expansion_images/KK/Alice Portraits/A_foxy_naked.png',
		},
	},
}

var typeToPath = {
	'default' : 'bodies',
	'preg' : 'bodiespreg',
	'naked' : 'bodiesnaked',
}

