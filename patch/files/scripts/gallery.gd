extends Node


var chardescript = {
	emily = "Young girl from Wimborn's orphanage. Despite her harsh life she's pretty naive and kind. ",
	tisha = "Emily's older sister. Since an early age she has aimed to work hard to provide for both herself and her sister a better life than what they initially had. Being constantly abused by rich and powerful people, Tisha grew to despise others. She is rather protective towards her sister. ",
	cali = "Halfkin wolf-girl who ended up in Wimborn due to some unfortunate events. Although her age and appearance might not suggest it, she is quite cheeky. ",
	chloe = "A gnome girl from Shaliq village, who decided to venture out of her homeland due to her research or in search of adventure. Despite that, she's pretty timid and seems to be insecure about her height. ",
	yris = "A beastkin resident of Gorn's bar. A Catgirl with a playful nature who loves thrill and challenges. ",
	zoe = "Young member of Frostford's ruling wolven clan. Being discontent with her suggested position, she seeks a way to prove herself and try a different life. Theron's niece. ",
	ayneris = "Youngest child of a powerful elven clan with declining prosperity. Her attempts to rival her siblings didn't worked out in a way she wanted, but in return she may have discovered something exciting about herself... ",
	melissa = "Second-in-command of the Wimborn's Mage's Order and your direct mentor. Despite her friendly appearance she seems to have her own undisclosed goals. ",
	fairy = "One of the Wimborn Slaver Guild's main attendants. Her cheerful and friendly nature helps new customers to settle in quickly. ",
	ayda = "Resident alchemist in Gorn's Palace. Though she prefers to keep to herself, she is forced to cooperate to fulfill her needs. ",
	garthor = "One of the leading persons around Gorn. As a head of his clan, he's very dependanble and a skillful politician.",
	theron = "Frostford's leader and a chieftain of his clan. His high moral standards and combat skills earned him great respect around Frostford. ",
	hade = "An unknown man recently appearing around The Empire with hidden intentions. Some authorities around The Order believe he might be a dangerous hostile. ",
}

var charactergallery = { 
	emily = {
		unlocked = false, name = 'Emily Hale', descript = chardescript.emily, sprite = 'emily2happy', naked = 'emilynakedhappy', nakedunlocked = false,
		scenes = [{code = 'emilyshowersex', name = 'Hazy first day', unlocked = false, text = "Spiked taste of adult life"}, {code = 'showerrape', name = 'Harsh Reception', unlocked = false, text = 'Forceful approach'}, {code = 'tishaemilysex', name = 'Sisters Love', unlocked = false, text = 'Let two sisters bond with each other'}]
	},
	tisha = {
		unlocked = false, name = 'Tisha Hale', descript = chardescript.tisha, sprite = 'tishaneutral', naked = 'tishanakedneutral', nakedunlocked = false, 
		scenes = [{code = 'tishablackmail', name = 'Blackmail', unlocked = false, text = "Older sister will have to 'stay up' for younger"}, {code = 'tishareward', name = 'Gratitude', unlocked = false, text = "Your help will be repaid with sincerencess"}, {code = 'tishaemilysex', name = 'Sisters Love', unlocked = false, text = 'Let two sisters bond with each other'}]
	},
	cali = {
		unlocked = false, name = 'Cali', descript = chardescript.cali, sprite = 'calineutral', naked = 'calinakedhappy', nakedunlocked = false, 
		scenes = [{code = 'calivirgin', name = "Cali's first time", unlocked = false, text = 'Young girl might feel stronger about you, if there were no rush'}]
	},
	chloe = {
		unlocked = false, name = 'Chloe', descript = chardescript.chloe, sprite = 'chloeneutral', naked = 'chloenakedneutral', nakedunlocked = false, 
		scenes = [{code = 'chloemana', name = 'Mana harvest', unlocked = false, text = 'Trade with Benefits'}, {code = 'chloeforest', name = 'Gnome in need', unlocked = false, text = 'An accident in the forest'}]
	},
	yris = {
		unlocked = false, name = 'Yris', descript = chardescript.yris, sprite = 'yrisnormal', naked = 'yrisnormalnaked', nakedunlocked = false, 
		scenes = [{code = 'yrisblowjob', name = 'First Bet', unlocked = false, text = 'Her bets can be tough'}, {code = 'yrissex', name = 'Second Bet', unlocked = false, text = 'Eventual success'}, {code = 'yrissex2', name = 'Third Bet', unlocked = false, text = 'A Breakthrough'}]
	},
	zoe = {
		unlocked = false, name = 'Zoe', descript = chardescript.zoe, sprite = 'zoeneutral', naked = 'zoeneutralnaked', nakedunlocked = false,
		scenes = [{code = 'zoetentacle', name = 'Dangerous Knowledge', unlocked = false, text = 'What old texts might reveal'}]
	},
	ayneris = {
		unlocked = false, name = 'Ayneris', descript = chardescript.ayneris, sprite = 'aynerisneutral', naked = 'aynerisneutralnaked', nakedunlocked = false,
		scenes = [{code = 'aynerispunish', name = 'Dirty Punishment', unlocked = false, text = 'Even rich need discipline'}, {code = 'aynerissex', name = 'Advanced Punishment',unlocked = false, text = 'Additional Discipline... might go too far'}]
	},
	melissa = {
		unlocked = false, name = 'Melissa', descript = chardescript.melissa, sprite = 'melissafriendly', naked = 'null', nakedunlocked = false, 
		scenes = []
	},
	maple = {
		unlocked = false, name = 'Maple', descript = chardescript.fairy, sprite = 'fairy', naked = 'fairynaked', nakedunlocked = false,
		scenes = [{code = 'mapleflirt', name = 'Risky Affair', unlocked = false, text = 'Build relationship sooner'},{code = 'mapleflirt2', name = 'Repeating Affair', unlocked = false, text = 'Foregone conclusion'}]
	},
	ayda = {
		unlocked = false, name = 'Ayda', descript = chardescript.ayda, sprite = 'aydanormal', naked = 'aydanaked', nakedunlocked = false,
		scenes = [{code = 'aydasex1', name = "Deferred Reward", unlocked = false, text = "Be persistent"}]
	},
	garthor = {
		unlocked = false, name = 'Garthor', descript = chardescript.garthor, sprite = 'garthor', naked = 'null', nakedunlocked = false,
		scenes = []
	},
	theron = {
		unlocked = false, name = 'Theron', descript = chardescript.theron, sprite = 'theron', naked = 'null', nakedunlocked = false,
		scenes = []
	},
	hade = {
		unlocked = false, name = 'Hade', descript = chardescript.hade, sprite = 'hadeneutral', naked = 'null', nakedunlocked = false,
		scenes = []
	},
} setget charactergallery_set

func charactergallery_set(value):
	charactergallery = value
	globals.overwritesettings()


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
		if globals.state.relativesdata.has(person.id):
			globals.state.relativesdata[person.id].name = person.name_long()
		return person
	else:
		globals.printErrorCode("Gallery character not found: " + name)
		return null


var characters = {
	Melissa = {
		basics = ['Human', 'adult', 'female', 'noble'],
		name = 'Melissa',
		surname = '',
		titssize = 'big',
		asssize = 'average',
		beautybase = 49,
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
		conf = 65,
		wit = 97,
		charm = 84,
		asser = 70,
		level = 4,
		str_base = 1,
		agi_base = 3,
		maf_base = 2,
		end_base = 2,
		skillpoints = 0,
		lewdness = 60,
		skin = 'fair',
		traits = ['Authority', 'Natural Beauty', 'Dominant', 'Responsive'],
		ability = ['attack', 'shackle', 'sedation', 'mindblast'],
	},
	Emily = {
		basics = ['Human', 'teen', 'female', 'poor'],
		name = 'Emily',
		surname = 'Hale',
		titssize = 'small',
		asssize = 'small',
		beautybase = 33,
		hairlength = 'shoulder',
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
		traits = ['Small Eater'],
	},
	Tisha = {
		basics = ['Human', 'adult', 'female', 'commoner'],
		name = 'Tisha',
		surname = 'Hale',
		unique = 'Tisha',
		beautybase = 45,
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
		level = 2,
		agi_base = 1,
		maf_base = 1,
		end_base = 1,
		skillpoints = 1,
		height = 'average',
		imageportait = "res://files/images/tisha/tishaportrait.png",
		traits = ['Hard Worker','Natural Beauty'],
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
		hairstyle = 'straight',
		skin = 'fair',
		imageportait = 'res://files/images/cali/caliportrait.png',
		vagvirgin = true,
		asser = 37,
		obed = 65,
		loyal = 0,
		cour = 47,
		conf = 55,
		wit = 35,
		charm = 20,
		agi_base = 1,
		skillpoints = 1,
		unique = "Cali",
		traits = ['Sturdy', 'Monogamous'],
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
		cour = 37,
		conf = 34,
		wit = 77,
		charm = 51,
		level = 2,
		maf_base = 1,
		str_base = 1,
		end_base = 1,
		skillpoints = 1,
		obed = 90,
		lewdness = 20,
		traits = ['Grateful', 'Gifted', 'Clever', 'Clumsy'],
	},
	Tia = {
		basics = ['Human', 'teen', 'female', 'commoner'],
		name = 'Tia',
		unique = 'Tia',
		surname = '',
		imageportait = 'res://files/aric_expansion_images/characters/New Tia/tiaportrait.png',
		beautybase = 80,
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
		hairlength = 'hips',
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
		level = 5,
		str_base = 3,
		agi_base = 3,
		maf_base = 1,
		end_base = 2,
		skillpoints = 1,
		obed = 90,
		traits = ['Nimble', 'Quick', 'Spoiled', 'Likes it rough', 'Masochist'],
		ability = ['attack','aimedstrike'],
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
		level = 3,
		str_base = 1,
		agi_base = 3,
		end_base = 2,
		skillpoints = 0,
		loyal = 25,
		obed = 90,
		lewdness = 70,
		traits = ['Grateful', 'Scoundrel', 'Quick', 'Pervert'],
	},
	Maple = {
		basics = ['Fairy', 'adult', 'female', 'rich'],
		name = 'Maple',
		unique = 'Maple',
		surname = '',
		titssize = 'average',
		asssize = 'small',
		beautybase = 74,
		hairlength = 'waist',
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
		charm = 72,
		level = 6,
		agi_base = 3,
		maf_base = 3,
		end_base = 2,
		skillpoints = 4,
		obed = 90,
		lewdness = 20,
		traits = ['Grateful', 'Influential', 'Pretty voice'],
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
		eyecolor = 'blue',
		vagvirgin = true,
		asser = 42,
		cour = 45,
		conf = 55,
		wit = 87,
		charm = 46,
		height = 'average',
		furcolor = 'gray',
		obed = 90,
		loyal = 25,
		imageportait = 'res://files/images/zoe/zoeportrait.png',
		level = 2,
		maf_base = 2,
		skillpoints = 2,
		traits = ['Grateful', 'Mentor', 'Responsive', 'Pretty voice'],
	},
	Ayda = {
		basics = ['Tribal Elf', 'adult', 'female', 'rich'],
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
		level = 3,
		agi_base = 2,
		maf_base = 3,
		end_base = 1,
		skillpoints = 0,
		lewdness = 50,
		traits = ['Experimenter','Clever'],
	},
	Ivrana = {
		basics = ['Tribal Elf', 'adult', 'female', 'rich'],
		name = 'Ivran',
		unique = 'Ivrana',
		surname = '',
		imageportait = 'res://files/aric_expansion_images/characters/ivranaportrait.png',
		beautybase = 75,
		haircolor = 'brown',
		hairlength = 'shoulder',
		hairstyle = 'straight',
		titssize = 'big',
		asssize = 'average',
		skin = 'brown',
		eyecolor = 'amber',
		vagvirgin = true,
		obed = 50,
		loyal = 0,
		stress = 60,
		asser = 20,
		cour = 65,
		conf = 83,
		wit = 55,
		charm = 48,
		height = 'tall',
	},
}

var sprites = {
	fairy = load("res://files/images/maple/maple.png"),
	fairynaked = load("res://files/images/maple/maplenaked.png"),
	melissafriendly = load("res://files/images/melissa/melissafriendly.png"),
	melissaneutral = load("res://files/images/melissa/melissaneutral.png"),
	melissaworried = load("res://files/images/melissa/melissaworried.png"),
	melissanakedfriendly = load("res://files/images/melissa/melissanakedfriendly.png"),
	melissanakedneutral = load("res://files/images/melissa/melissanakedneutral.png"),
	emilyhappy = load("res://files/images/emily/emilyhappy.png"),
	emilynormal = load("res://files/images/emily/emilyneutral.png"),
	emily2normal = load("res://files/images/emily/emily2neutral.png"),
	emily2happy = load("res://files/images/emily/emily2happy.png"),
	emily2worried = load("res://files/images/emily/emily2worried.png"),
	emilynakedhappy = load("res://files/images/emily/emilynakedhappy.png"),
	emilynakedneutral = load("res://files/images/emily/emilynakedneutral.png"),
	emilyportrait = load("res://files/images/emily/emilyportrait.png"),
	calineutral = load("res://files/images/cali/calineutral.png"),
	calihappy = load("res://files/images/cali/calihappy.png"),
	calinakedhappy = load("res://files/images/cali/calinakedneutral.png"),
	calinakedangry = load("res://files/images/cali/calinakedangry.png"),
	caliangry = load("res://files/images/cali/caliangry.png"),
	calisad = load("res://files/images/cali/calisad.png"),
	calinakedsad = load("res://files/images/cali/calinakedsad.png"),
	sebastian = load("res://files/images/sebastian.png"),
	tishahappy = load("res://files/images/tisha/tishahappy.png"),
	tishaneutral = load("res://files/images/tisha/tishaneutral.png"),
	tishaangry = load("res://files/images/tisha/tishaangry.png"),
	tishashocked = load("res://files/images/tisha/tishashocked.png"),
	tishanakedhappy = load("res://files/images/tisha/tishanakedhappy.png"),
	tishanakedneutral = load("res://files/images/tisha/tishanakedneutral.png"),
	chloehappy = load("res://files/images/chloe/chloehappy.png"),
	chloenakedhappy = load("res://files/images/chloe/chloenakedhappy.png"),
	chloeneutral = load("res://files/images/chloe/chloeneutral.png"),
	chloenakedneutral = load("res://files/images/chloe/chloenakedneutral.png"),
	chloehappy2 = load("res://files/images/chloe/chloehappy2.png"),
	chloeshy2 = load("res://files/images/chloe/chloeshy2.png"),
	chloenakedshy = load("res://files/images/chloe/chloenakedshy.png"),
	chloeneutral2 = load("res://files/images/chloe/chloeneutral2.png"),
	aydanormal = load("res://files/images/ayda/aydanormal.png"),
	aydanormal2 = load("res://files/images/ayda/aydanormal2.png"),
	aydanaked = load("res://files/images/ayda/aydanaked.png"),
	yrisnormal = load("res://files/images/yris/yrisnormaldressed.png"),
	yrisalt = load("res://files/images/yris/yrisaltdressed.png"),
	yrisshock = load("res://files/images/yris/yrisshockdressed.png"),
	yrisnormalnaked = load("res://files/images/yris/yrisnormalnaked.png"),
	yrisaltnaked = load("res://files/images/yris/yrisaltnaked.png"),
	yrisshocknaked = load("res://files/images/yris/yrisshocknaked.png"),
	aynerisneutral = load("res://files/images/ayneris/aynerisneutral.png"),
	aynerisangry = load("res://files/images/ayneris/aynerisangry.png"),
	aynerispissed = load("res://files/images/ayneris/aynerispissed.png"),
	aynerisneutralnaked = load("res://files/images/ayneris/aynerisneutralnaked.png"),
	aynerisangrynaked = load("res://files/images/ayneris/aynerisangrynaked.png"),
	aynerispissednaked = load("res://files/images/ayneris/aynerispissednaked.png"),
	ayneristopless = load("res://files/images/ayneris/ayneristopless.png"),
	zoeneutral = load("res://files/images/zoe/zoeneutral.png"),
	zoeneutralnaked = load("res://files/images/zoe/zoeneutralnaked.png"),
	zoehappy = load("res://files/images/zoe/zoehappy.png"),
	zoehappynaked = load("res://files/images/zoe/zoehappynaked.png"),
	zoesad = load("res://files/images/zoe/zoesad.png"),
	zoesadnaked = load("res://files/images/zoe/zoesadnaked.png"),

	theron = load("res://files/images/theron.png"),
	garthor = load("res://files/images/garthor.png"),

	oldemilyhappy = load("res://files/images/emily/oldemilyhappy.png"),
	oldemilynormal = load("res://files/images/emily/oldemilyneutral.png"),
	oldemily2normal = load("res://files/images/emily/oldemily2neutral.png"),
	oldemily2happy = load("res://files/images/emily/oldemily2happy.png"),
	oldemily2worried = load("res://files/images/emily/oldemily2worried.png"),
	oldemilynakedhappy = load("res://files/images/emily/oldemilynakedhappy.png"),
	oldemilynakedneutral = load("res://files/images/emily/oldemilynakedneutral.png"),
	oldemilyportrait = load("res://files/images/emily/oldemilyportrait.png"),

	chancellor = load("res://files/images/chancellor.png"),
	merchant = load("res://files/images/merchant.png"),
	hadesillh = load("res://files/images/hade/hadesillhoute.png"),
	hadeneutral = load("res://files/images/hade/hadeneutral.png"),
	hadesmile = load("res://files/images/hade/hadesmile.png"),
	hadeangry = load("res://files/images/hade/hadeangry.png"),
	hade2neutral = load("res://files/images/hade/hade2neutral.png"),
	hade2smile = load("res://files/images/hade/hade2smile.png"),
	hade2angry = load("res://files/images/hade/hade2angry.png"),
	goblin = load("res://files/images/goblin.png"),
	centaur = load("res://files/images/centaur.png"),
	forestspirit = load("res://files/images/forestspirit.png"),
	frostfordtrader = load("res://files/images/frostfordtrader.png"),
	frostfordslaver = load("res://files/images/ffslaver.png"),
	brothelhost = load("res://files/images/brothelhost.png"),
	
	###---Added by Expansion---###
	#Preg Uniques
	aynerisneutralnaked_preg = load("res://files/aric_expansion_images/characters/preg_uniques/aynerisneutralnaked_preggo.png"),
	chloenaked_preg = load("res://files/aric_expansion_images/characters/preg_uniques/chloenaked_preggo.png"),
	emilyf_preg = load("res://files/aric_expansion_images/characters/preg_uniques/emilyf_preg.png"),
	tisha_preggo = load("res://files/aric_expansion_images/characters/preg_uniques/tisha_preggo.png"),
	#Tia Images
	tiaportrait = load("res://files/aric_expansion_images/characters/New Tia/tiaportrait.png"),
	tiaclothed = load("res://files/aric_expansion_images/characters/New Tia/tianeutral.png"),
	tiaclothedsad = load("res://files/aric_expansion_images/characters/New Tia/tiasad.png"),
	tianaked = load("res://files/aric_expansion_images/characters/New Tia/tianudeneutral.png"),
	tianakedsad = load("res://files/aric_expansion_images/characters/New Tia/tianudesad.png"),
	tiapregnant = load("res://files/aric_expansion_images/characters/New Tia/tiapregnant.png"),
	#Old Tia Images
	tiaportrait_old = load("res://files/aric_expansion_images/characters/tiaportrait.png"),
	tiaclothed_old = load("res://files/aric_expansion_images/characters/tiaclothed.png"),
	tianaked_old = load("res://files/aric_expansion_images/characters/tianaked.png"),
	#Bunny Boy in Aydas Shop
	adya_assist_neutral = load("res://files/aric_expansion_images/characters/bunnyboy_neutral.png"),
	adya_assist_nervous = load("res://files/aric_expansion_images/characters/bunnyboy_nervous.png"),
	#Ivran/a
	ivran_male = load("res://files/aric_expansion_images/characters/ivranenemy.png"),
	ivran_male_portrait = load("res://files/aric_expansion_images/characters/ivranenemyicon.png"),
	ivrana_clothed = load("res://files/aric_expansion_images/characters/ivranaclothed.png"),
	ivrana_naked = load("res://files/aric_expansion_images/characters/ivrananaked.png"),
	ivrana_portrait = load("res://files/aric_expansion_images/characters/ivranaportrait.png"),
	ivrana_pregnant = load("res://files/aric_expansion_images/characters/ivranapregnant.png"),
	#Shuriya
	shuriya = load("res://files/aric_expansion_images/characters/shuriya.png"),
	#Halfkin Slaver
	halfkin_slaver_icon = load("res://files/aric_expansion_images/characters/Halfkin Slaver/halfkin_slaver_icon.png"),
	halfkin_slaver_smug = load("res://files/aric_expansion_images/characters/Halfkin Slaver/halfkin_slaver_smug.png"),
	halfkin_slaver_angry = load("res://files/aric_expansion_images/characters/Halfkin Slaver/halfkin_slaver_angry.png"),
	#Jason
	jasonfrown = load("res://files/aric_expansion_images/characters/Jason/jasonfrown.png"),
	jasonneutral = load("res://files/aric_expansion_images/characters/Jason/jasonneutral.png"),
	jasonsmirk = load("res://files/aric_expansion_images/characters/Jason/jasonsmirk.png"),
	###---End Expansion---###
}
var scenes = {
	finale = load("res://files/images/scene/finale.png"),
	finale2 = load("res://files/images/scene/finale2.png"),
	emilyshower = load("res://files/images/sexscenes/emilyshower.png"),
	emilyshowerrape = load("res://files/images/sexscenes/emilyshowerrape.png"),
	tishabj = load("res://files/images/sexscenes/tishabj.png"),
	tishafinale = load("res://files/images/sexscenes/tishafinale.png"),
	tishatable = load("res://files/images/sexscenes/tishatable.png"),
	tishaemily = load("res://files/images/sexscenes/tishaemily.png"),
	calisex = load("res://files/images/sexscenes/calisex.png"),
	aynerispunish = load("res://files/images/sexscenes/aynerispunish.png"),
	aynerissex = load("res://files/images/sexscenes/aynerissex.png"),
	chloebj = load("res://files/images/sexscenes/chloebj.png"),
	chloewoods = load("res://files/images/sexscenes/chloewoods.png"),
	maplebj = load("res://files/images/sexscenes/maplebj.png"),
	maplesex = load("res://files/images/sexscenes/maplesex.png"),
	yrisbj = load("res://files/images/sexscenes/yrisbj.png"),
	yrissex = load("res://files/images/sexscenes/yrissex.png"),
	zoetentacle1 = load("res://files/images/sexscenes/zoetentacle.png"),
	zoetentacle2 = load("res://files/images/sexscenes/zoetentacle2.png"),
	aydasex1 = load("res://files/images/sexscenes/aydasex1.png"),
	aydasex2 = load("res://files/images/sexscenes/aydasex2.png"),
}
var backgrounds = {
	mansion = load("res://files/backgrounds/mansion.png"),
	jail = load("res://files/backgrounds/jail.png"),
	alchemy0 = load("res://files/backgrounds/alchemy0.png"),
	alchemy1 = load("res://files/backgrounds/alchemy1.png"),
	alchemy2 = load("res://files/backgrounds/alchemy2.png"),
	#wimborn = load("res://files/backgrounds/town.png"), #Wimborn - vanilla background.
	wimborn = load("res://files/aric_expansion_images/backgrounds/wimborntown.png"), #Wimborn - new background.
	mageorder = load("res://files/backgrounds/mageorder.png"),
	slaverguild = load("res://files/backgrounds/slaveguild.png"),
	market = load("res://files/backgrounds/market.png"),
	library1 = load("res://files/backgrounds/library1.png"),
	library2 = load("res://files/backgrounds/library2.png"),
	#forest = load("res://files/backgrounds/forest.jpg"),  #Elven Grove - vanilla background.
	forest = load("res://files/aric_expansion_images/backgrounds/elvenforest.png"),  #Elven Grove - new background.
	shaliq = load("res://files/backgrounds/shaliq.png"),
	crossroads = load("res://files/backgrounds/crossroads.png"),
	#grove = load("res://files/backgrounds/grove.jpg"), #Eerie Grove - vanilla background.
	grove = load("res://files/aric_expansion_images/backgrounds/eeriegrove.png"), #Eerie Grove - new background.
	#highlands = load("res://files/backgrounds/highlands.jpg"), #Prairie, Gorn Outskirts - vanilla background.
	highlands = load("res://files/aric_expansion_images/backgrounds/prairie.png"),    #Prairie, Gorn Outskirts - new background.
	#marsh = load("res://files/backgrounds/marsh.jpg"), #Marsh - vanilla background.
	marsh = load("res://files/aric_expansion_images/backgrounds/marshlands.png"), #Marsh - new background.
	meadows = load("res://files/backgrounds/meadows.png"),
	sea = load("res://files/backgrounds/sea.jpg"),
	lab = load("res://files/backgrounds/laboratory.png"),
	gorn = load("res://files/backgrounds/gorn.png"),
	frostford = load("res://files/backgrounds/frostford.png"),
	mountains = load("res://files/backgrounds/mountains.jpg"),
	borealforest = load("res://files/backgrounds/borealforest.jpg"),
	amberguard = load("res://files/backgrounds/amberguard.png"),
	#amberroad = load("res://files/backgrounds/amberroad.png"), #Amber Road - vanilla background.
	amberroad = load("res://files/aric_expansion_images/backgrounds/newamberroad.png"),  #Amber Road - new background.
	undercity = load("res://files/backgrounds/undercity.png"),
	tunnels = load("res://files/backgrounds/tunnels.png"),
	mainorder = load("res://files/backgrounds/mainorder.png"),
	mainorderfinale = load("res://files/backgrounds/mainorderfinale.png"),
	umbra = load("res://files/backgrounds/umbra.png"),
	nightdesert = load("res://files/backgrounds/nightdesert.jpeg"),
	brothel = load("res://files/backgrounds/brothel.png"),
	dragonnests = load('res://files/backgrounds/dragonnest.png'),
	redcave = load("res://files/backgrounds/redcave.png"),
	culthideout = load("res://files/backgrounds/culthideout.png"),
	cavelake = load("res://files/backgrounds/cavelake.png"),
	darkness = load("res://files/backgrounds/darkness.png"),
	stairs = load("res://files/aric_expansion_images/dimensional_crystal/stairs.png"),
	stairs_red = load("res://files/aric_expansion_images/dimensional_crystal/stairs_red.png"),
	dimcrystal_dull = load("res://files/aric_expansion_images/dimensional_crystal/dimcrystal_dull.png"),
	dimcrystal_light1 = load("res://files/aric_expansion_images/dimensional_crystal/dimcrystal_light_1.png"),
	dimcrystal_dark1 = load("res://files/aric_expansion_images/dimensional_crystal/dimcrystal_dark_1.png"),
}

var nakedsprites = {
	Cali = {cons = 'calinakedhappy', rape = 'calinakedsad', clothcons = 'calineutral', clothrape = 'calisad'},
	Tisha = {cons = 'tishanakedhappy', rape = 'tishanakedneutral', clothcons = 'tishahappy', clothrape = 'tishaneutral'},
	Emily = {cons = 'emilynakedhappy', rape = 'emilynakedneutral', clothcons = 'emily2happy', clothrape = 'emily2worried'},
	Chloe = {cons = 'chloenakedhappy', rape = 'chloenakedneutral', clothcons = 'chloehappy2', clothrape = 'chloeneutral2'},
	Maple = {cons = 'fairynaked', rape = 'fairynaked', clothcons = 'fairy', clothrape = 'fairy'},
	Yris = {cons = 'yrisnormalnaked', rape = 'yrisshocknaked', clothcons = 'yrisnormal', clothrape = 'yrisshock'},
	Ayneris = {cons = 'aynerisneutralnaked', rape = 'aynerisangrynaked', clothcons = 'aynerisneutral', clothrape = 'aynerisangry'},
	Zoe = {cons = "zoehappynaked", rape = 'zoesadnaked', clothcons = 'zoehappy', clothrape = 'zoesad'},
	Melissa = {cons = "melissanakedfriendly", rape = 'melissanakedneutral', clothcons = 'melissafriendly', clothrape = 'melissaneutral'},
	Ayda = {cons = 'aydanaked',rape = 'aydanaked', clothcons = 'aydanormal',clothrape = 'aydanormal'},
	###---Added by Expansion---### Tia
	Tia = {cons = 'tianaked', rape = 'tianakedsad', clothcons = 'tiaclothed', clothrape = 'tiaclothedsad'},
	Ivrana = {cons = 'ivrana_naked', rape = 'ivrana_naked', clothcons = 'ivrana_clothed', clothrape = 'ivrana_clothed'},
	###---End Expansion---###
}

###---Added by Expansion---### Unique Genealogy Fixer
func uniqueGenealogyFixer(_slave):
	if _slave.npcexpanded.racialbonusesapplied == true && globals.expansionsettings.racialstatbonuses == true:
		globals.expansionsetup.setRaceBonus(_slave, false)
	var racegenes = globals.constructor.genealogy_decoder(_slave.race)
	if _slave.race.find('Halfkin') >= 0:
		for i in _slave.genealogy:
			_slave.genealogy[i] = 0
		_slave.genealogy[racegenes] = 70
		_slave.genealogy.human = 30
	else:
		for i in _slave.genealogy:
			_slave.genealogy[i] = 0
		_slave.genealogy[racegenes] = 100
	if globals.expansionsettings.racialstatbonuses == true:
		globals.expansionsetup.setRaceBonus(_slave, true)
	globals.constructor.setRaceDisplay(_slave)
