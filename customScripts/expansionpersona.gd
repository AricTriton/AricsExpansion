### <CustomFile> ###

#Template Storage for easy guidance
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
# 		imageportait = "res://files/images/melissa/melissaportrait.png",
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

var persona = {
	Alice = {
		basics = ['Human', 'adult', 'female', 'commoner'],
		name = 'Alice',
		surname = '',
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
		obed = 20,
		cour = 10,
		conf = 20,
		wit = 50,
		charm = 50,
		asser = 20,
		level = 4,
		str_base = 1,
		agi_base = 3,
		maf_base = 2,
		end_base = 2,
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
		var fetish = {
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

func createpersona(name):
	var refChar = persona.get(name)
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
			elif i in person:
				person[i] = refChar[i]
			elif i in person.stats:
				person.stats[i] = refChar[i]
			elif i in person.fetish:
				person.fetish[i] = refChar.fetish[i]
			elif i in person.npcexpanded:
				person.npcexpanded[i] = refChar[i]
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
#---End---#