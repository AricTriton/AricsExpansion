extends Node


var groupArray = [null, [], [], []] #null aligns index with groupNum
var player
var playerGroup = 0

#For expressions in brackets: 1 refers to givers, 2 refers to takers and checks if groups consist of 1 or more persons to pick up correct references. 
#[name1] and [name2] build name lists of those parties, while [name] refers to specific person from any side (generally used in reactions)
#expressions without brackets tend to refer only to specific person and build their description or pronounce parts. [body] will try to add some random adjectives depending on character's traits.
#[his], [he] etc will be replaced with female pronouns if referred character is not male
#[his1] can be also replaced with their and will refer to group

# this file has been primarily optimized for faster performance. some basic optimizations:
#	var is faster than const. dictionary lookup is faster for strings in var. string comparison and string manipulation is faster for raw strings. 


func _init():
	simplifyDesc(descAssSizeAgeKeys, descAssSizeAgeConvert)
	simplifyDesc(descHipsSizeAgeKeys, descHipsSizeAgeConvert)
	simplifyDesc(descTitsSizeAgeKeys, descTitsSizeAgeConvert)


#-------------------------------------------------------------------------------------------------------------------------
# tags
var personVerbs = [
	null, #null aligns index with groupNum
	[
		#state verbs
		'[is1]',
		'[has1]',
		'[was1]',
		#verb endings
		'[ies/y1]',
		'[s/1]',
		'[es/1]',
	],
	[
		#state verbs
		'[is2]',
		'[has2]',
		'[was2]',
		#verb endings
		'[ies/y2]',
		'[s/2]',
		'[es/2]',
	],
]

# if group.size() >= 2 || group[0][C_PERSON] == player
var personVerbsPlural = [
	#state verbs
	"are", # [is1]
	"have", # [has1]
	"were", # [was1]
	#verb endings
	"y", # [ies/y1]
	"", # [s/1]
	"", # [es/1]
]
# if group.size() == 1
var personVerbsSingular = [
	#state verbs
	"is", # [is1]
	"has", # [has1]
	"was", # [was1]
	#verb endings
	"ies", # [ies/y1]
	"s", # [s/1]
	"es", # [es/1]
]
#-------------------------------------------------------------------------------------------------------------------------
# tags
var objectVerbsNouns = [
	null, #null aligns index with groupNum
	[
		#verb endings involving objects and body actions. always third person, so only takes number into account
		'[ies/y#1]',
		'[s/#1]',
		'[es/#1]',
		#nouns
		'[y/ies1]',
		'[/s1]',
		'[/es1]',
		'[a /1]',
		'[an /1]',
		#pronouns
		'[it1]',
	],
	[
		#verb endings involving objects and body actions. always third person, so only takes number into account
		'[ies/y#2]',
		'[s/#2]',
		'[es/#2]',
		#nouns
		'[y/ies2]',
		'[/s2]',
		'[/es2]',
		'[a /2]',
		'[an /2]',
		#pronouns
		'[it2]',
	],
]

# if group.size() >= 2
var objectVerbsNounsPlural = [
	#verb endings involving objects and body actions. always third person, so only takes number into account
	"y", # [ies/y#1]
	"", # [s/#1]
	"", # [es/#1]
	#nouns
	"ies", # [y/ies1]
	"s", # [/s1]
	"es", # [/es1]
	"", # [a /1]
	"", # [an /1]
	#pronouns
	"them", # [it1]
]
# if group.size() == 1
var objectVerbsNounsSingular = [
	#verb endings involving objects and body actions. always third person, so only takes number into account
	"ies", # [ies/y#1]
	"s", # [s/#1]
	"es", # [es/#1]
	#nouns
	"y", # [y/ies1]
	"", # [/s1]
	"", # [/es1]
	"a ", # [a /1]
	"an ", # [an /1]
	#pronouns
	"it", # [it1]
]
#-------------------------------------------------------------------------------------------------------------------------
# tags
var pronouns = [
	null, #null aligns index with groupNum
	[
		'[he1]',
		'[him1]',
		'[himself1]',
		'[his1]',
		'[his_1]',
	],
	[
		'[he2]',
		'[him2]',
		'[himself2]',
		'[his2]',
		'[his_2]',
	],
	[
		'[he3]',
		'[him3]',
		'[himself3]',
		'[his3]',
		'[his_3]',
	],
]
#pre-located indexes for simple lookup
var pronounIdxHimself = pronouns[1].find('[himself1]')
var pronounIdxHis = pronouns[1].find('[his1]')

# if playerGroup == groupNum && group.size() == 1
var pronounsPlayerSingular = [
	"you", # [he1]
	"you", # [him1]
	"yourself", # [himself1]
	"your", # [his1]
	"yours", # [his_1]
]
# if playerGroup == groupNum && group.size() == 2
var pronounsPlayerDuo = [
	"{^you both:you}", # [he1]
	"{^you both:both of you}", # [him1]
	"yourselves", # [himself1]
	"{^both of your:your}", # [his1]
	"yours", # [his_1]
]
# if playerGroup == groupNum && group.size() > 2
var pronounsPlayerPlural = [
	"{^you all:you}", # [he1]
	"{^you all:all of you}", # [him1]
	"yourselves", # [himself1]
	"{^all of your:your}", # [his1]
	"yours", # [his_1]
]
# if group.size() == 1 && group[0][C_SEX] == 'male'
var pronounsMaleSingular = [
	"he", # [he1]
	"him", # [him1]
	"himself", # [himself1]
	"his", # [his1]
	"his", # [his_1]
]
# if group.size() == 1 && group[0][C_SEX] != 'male'
var pronounsFemaleSingular = [
	"she", # [he1]
	"her", # [him1]
	"herself", # [himself1]
	"her", # [his1]
	"hers", # [his_1]
]
# if group.size() == 2
var pronounsDuo = [
	"{^they both:they}", # [he1]
	"them", # [him1]
	"themselves", # [himself1]
	"their", # [his1]
	"theirs", # [his_1]
]
# if group.size() > 2
var pronounsPlural = [
	"they", # [he1]
	"them", # [him1]
	"themselves", # [himself1]
	"their", # [his1]
	"theirs", # [his_1]
]
#-------------------------------------------------------------------------------------------------------------------------
# constant strings except that const is slightly slower than var
var C_PERSON = 'person'
var C_NAME = 'name'
var C_RACE = 'race'
var C_AGE = 'age'
var C_SEX = 'sex'
var C_MALE = 'male'
var C_TITSSIZE = 'titssize'
var C_ASSSIZE = 'asssize'
var C_PREG = 'preg'
var C_DURATION = 'duration'
var C_HAS_WOMB = 'has_womb'
var C_MASCULINE = 'masculine'
var C_BODYSHAPE = 'bodyshape'
var C_CHILD = 'child'
var C_SKINCOV = 'skincov'
var C_FULL_BODY_FUR = 'full_body_fur'
var C_FULL_BODY_SCALES = 'fullscales'
var C_FULL_BODY_FEATHERS = 'fullfeathers'
var C_FULL_BODY_FEATHERS_AND_FUR = 'feathers_and_fur'
var C_HALFHORSE = 'halfhorse'
var C_SINGLE = 'single'
var C_PLURAL = 'plural'
var C_SINGLEPOS = 'singlepos'
var C_PLURALPOS = 'pluralpos'


###---Added by Expansion---### Person Expanded
var refSizeArray = globals.sizearray # ['masculine','flat','small','average','big','huge']
var refTitsSizeArray = globals.titssizearray # ['masculine','flat','small','average','big','huge','incredible','massive','gigantic','monstrous','immobilizing']
var refAgesArray = globals.agesarray # ['child','teen','adult']
var refHeightArray = globals.heightarrayexp # ['tiny','petite','short','average','tall','towering']
var refGenitaliaArray  = globals.penissizearray # ['micro','tiny','small','average','large','massive']
var refPenisTypeArray = globals.penistypearray # ['human','canine','feline','equine','reptilian','rodent','bird',]
var refAssSizeArray = globals.asssizearray #['masculine','flat','small','average','big','huge']
###---End Expansion---###


func applyVerbsNouns(text):
	var refWhat
	var refForWhat
	for i in [1,2]:
		refWhat = personVerbs[i]
		refForWhat = personVerbsPlural if (groupArray[i].size() >= 2 || groupArray[i][0][C_PERSON] == player) else personVerbsSingular
		for j in refWhat.size():
			text = text.replace( refWhat[j], refForWhat[j])

		refWhat = objectVerbsNouns[i]
		refForWhat = objectVerbsNounsPlural if (groupArray[i].size() >= 2) else objectVerbsNounsSingular
		for j in refWhat.size():
			text = text.replace( refWhat[j], refForWhat[j])
	return text

func selectPronouns(group, groupNum):
	if playerGroup & groupNum: # bitwise & is effectively equivalent to:  playerGroup == groupNum || (groupNum == 3 && playerGroup > 0)
		if group.size() == 1:
			return pronounsPlayerSingular
		elif group.size() == 2:
			return pronounsPlayerDuo
		else:
			return pronounsPlayerPlural
	elif group.size() == 1:
		if group[0][C_SEX] == 'male':
			return pronounsMaleSingular
		else:
			return pronounsFemaleSingular
	elif group.size() == 2:
		return pronounsDuo
	else:
		return pronounsPlural

func applyPronouns(text):
	var refWhat
	var refForWhat
	for i in [1,2,3]:
		refWhat = pronouns[i]
		refForWhat = selectPronouns(groupArray[i], i)
		for j in refWhat.size():
			text = text.replace( refWhat[j], refForWhat[j])
	return text


func decoder(text, tempGivers, tempTakers = []):
	player = globals.player
	playerGroup = 0
	for member in tempGivers:
		if member[C_PERSON] == player:
			playerGroup = 1
			break
	if playerGroup == 0:
		for member in tempTakers:
			if member[C_PERSON] == player:
				playerGroup = 2
				break

	if tempTakers.empty():
		if tempGivers.empty():
			return text
		groupArray[1] = tempGivers
		groupArray[2] = tempGivers
		groupArray[3] = tempGivers
	elif tempGivers.empty():
		groupArray[1] = tempTakers
		groupArray[2] = tempTakers
		groupArray[3] = tempTakers
	else:
		groupArray[1] = tempGivers
		groupArray[2] = tempTakers
		groupArray[3] = tempGivers + tempTakers
	
	#split before parse
	text = splitrand(text)
	
	#some tricks to make proper nouns easier
	if text.find('[name1]') < 0 && text.find('[names1]') < 0:
		text = text.replace('[he1]', '[name1]')
	if text.find('[name2]') < 0 && text.find('[names2]') < 0:
		text = text.replace('[he2]', '[name2]')

	text = text.replace('[their]', "your" if playerGroup > 0 else "their")

	text = applyVerbsNouns(text)
	text = applyPronouns(text)
	text = searchAndReplace(text)
	
	text = splitrand(text)
	
	#handle capitalization and return
	return capitallogic(text)

#choose randomly from str in {^str:str:str}
#does not support nesting
func splitrand(text):
	var pos = text.find("{^")
	while pos >= 0:
		var targetText = text.substr(pos, text.find("}", pos)+1 - pos)
		var splitText = targetText.substr(2, targetText.length()-3).split(":")
		text = text.replace(targetText, splitText[ randi() % splitText.size() ])
		pos = text.find("{^", pos)
	return text

var clookfor = ["\n", ". ", "! "]
#capitalize the first letter in text and those after strings in the array clookfor
#ignores flags inside "[" and "]"
func capitallogic(text):
	var cplace
	for i in clookfor:
		cplace = 0
		while cplace < text.length():
			if text[cplace] == "[":
				cplace = text.find("]", cplace) + 1
				if cplace == 0:
					break
				continue
			if text[cplace] == " ":
				cplace += 1
				continue
			text[cplace] = text[cplace].to_upper()
			cplace = text.find(i, cplace)
			if cplace < 0:
				break
			cplace += i.length()
	return text


var replacements = {
	#proper nouns
	'[name1]' : [funcref(self, 'name'), 1, true],
	'[name2]' : [funcref(self, 'name'), 2, false],
	'[name3]' : [funcref(self, 'name'), 3, false],
	'[names1]' : [funcref(self, 'names'), 1, true],
	'[names2]' : [funcref(self, 'names'), 2, false],
	'[names3]' : [funcref(self, 'names'), 3, false],
	'[partner1]' : [funcref(self, 'partner'), 1, 1],
	'[partner2]' : [funcref(self, 'partner'), 2, 2],
	'[partner3]' : [funcref(self, 'partner'), 3, 3],
	'[partners1]' : [funcref(self, 'partners'), 1, 1],
	'[partners2]' : [funcref(self, 'partners'), 2, 2],
	'[partners3]' : [funcref(self, 'partners'), 3, 3],
	#body parts
	'[pussy1]' : [funcref(self, 'pussy'), 1],
	'[pussy2]' : [funcref(self, 'pussy'), 2],
	'[pussy3]' : [funcref(self, 'pussy'), 3],
	'[penis1]' : [funcref(self, 'penis'), 1],
	'[penis2]' : [funcref(self, 'penis'), 2],
	'[penis3]' : [funcref(self, 'penis'), 3],
	'[ass1]' : [funcref(self, 'ass'), 1],
	'[ass2]' : [funcref(self, 'ass'), 2],
	'[ass3]' : [funcref(self, 'ass'), 3],
	'[hips1]' : [funcref(self, 'hips'), 1],
	'[hips2]' : [funcref(self, 'hips'), 2],
	'[hips3]' : [funcref(self, 'hips'), 3],
	'[tits1]' : [funcref(self, 'tits'), 1],
	'[tits2]' : [funcref(self, 'tits'), 2],
	'[tits3]' : [funcref(self, 'tits'), 3],
	'[body1]' : [funcref(self, 'body'), 1],
	'[body2]' : [funcref(self, 'body'), 2],
	'[body3]' : [funcref(self, 'body'), 3],
	#sex actions
	'[fuck1]' : [funcref(self, 'fuck'), 1, 1, ''],
	'[fuck2]' : [funcref(self, 'fuck'), 2, 2, ''],
	'[fuck3]' : [funcref(self, 'fuck'), 3, 3, ''],
	'[fucks1]' : [funcref(self, 'fuck'), 1, 1, 's'],
	'[fucks2]' : [funcref(self, 'fuck'), 2, 2, 's'],
	'[fucks3]' : [funcref(self, 'fuck'), 3, 3, 's'],
	'[fucking1]' : [funcref(self, 'fuck'), 1, 1, 'ing'],
	'[fucking2]' : [funcref(self, 'fuck'), 2, 2, 'ing'],
	'[fucking3]' : [funcref(self, 'fuck'), 3, 3, 'ing'],
	'[vfuck1]' : [funcref(self, 'vfuck'), 1, 1, ''],
	'[vfuck2]' : [funcref(self, 'vfuck'), 2, 2, ''],
	'[vfuck3]' : [funcref(self, 'vfuck'), 3, 3, ''],
	'[vfucks1]' : [funcref(self, 'vfuck'), 1, 1, 's'],
	'[vfucks2]' : [funcref(self, 'vfuck'), 2, 2, 's'],
	'[vfucks3]' : [funcref(self, 'vfuck'), 3, 3, 's'],
	'[vfucking1]' : [funcref(self, 'vfuck'), 1, 1, 'ing'],
	'[vfucking2]' : [funcref(self, 'vfuck'), 2, 2, 'ing'],
	'[vfucking3]' : [funcref(self, 'vfuck'), 3, 3, 'ing'],
	'[afuck1]' : [funcref(self, 'afuck'), 1, 1, ''],
	'[afuck2]' : [funcref(self, 'afuck'), 2, 2, ''],
	'[afuck3]' : [funcref(self, 'afuck'), 3, 3, ''],
	'[afucks1]' : [funcref(self, 'afuck'), 1, 1, 's'],
	'[afucks2]' : [funcref(self, 'afuck'), 2, 2, 's'],
	'[afucks3]' : [funcref(self, 'afuck'), 3, 3, 's'],
	'[afucking1]' : [funcref(self, 'afuck'), 1, 1, 'ing'],
	'[afucking2]' : [funcref(self, 'afuck'), 2, 2, 'ing'],
	'[afucking3]' : [funcref(self, 'afuck'), 3, 3, 'ing'],
	#unfinished
	'[labia1]' : [funcref(self, 'labia'), 1],
	'[labia2]' : [funcref(self, 'labia'), 2],
	'[labia3]' : [funcref(self, 'labia'), 3],
	'[anus1]' : [funcref(self, 'anus'), 1],
	'[anus2]' : [funcref(self, 'anus'), 2],
	'[anus3]' : [funcref(self, 'anus'), 3],
}

func searchAndReplace(text):
	var priorPos = 0
	var pos1 = text.find("[")
	var pos2
	var strPool = PoolStringArray()
	while pos1 >= 0:
		pos2 = text.find("]", pos1)
		if pos2 < 0:
			break
		var refRep = replacements.get(text.substr(pos1, pos2 - pos1 + 1))
		if refRep != null:
			strPool.append( text.substr(priorPos, pos1 - priorPos) )
			if refRep.size() == 3:
				strPool.append( refRep[0].call_func( groupArray[refRep[1]], refRep[2]) )
			elif refRep.size() == 2:
				strPool.append( refRep[0].call_func( groupArray[refRep[1]]) )
			elif refRep.size() == 4:
				strPool.append( refRep[0].call_func( groupArray[refRep[1]], refRep[2], refRep[3]) )
			priorPos = pos2 + 1
		pos1 = text.find("[", pos2)
	strPool.append( text.substr(priorPos, text.length() - priorPos) )
	return strPool.join("")


# isGivers is true only when group is only the givers
func name(group, isGivers):
	var strArr = PoolStringArray()
	if isGivers:
		for member in group:
			if member[C_PERSON] == player:
				strArr.append("[color=yellow]you[/color]")
			else:
				strArr.append("[color=yellow]%s[/color]" % member[C_NAME])
	else:
		for member in group:
			if member[C_PERSON] == player:
				strArr.append("[color=aqua]you[/color]")
			elif randf() <= 0.5:
				var relName = globals.getrelativename(groupArray[1][0][C_PERSON], member[C_PERSON])
				if relName != null:
					if playerGroup == 1:
						strArr.append("[color=aqua]your %s[/color]" % relName)
					else:
						strArr.append(groupArray[1][0][C_PERSON].dictionary("[color=aqua]$his %s[/color]" % relName))
				else:
					strArr.append("[color=aqua]%s[/color]" % member[C_NAME])
			else:
				strArr.append("[color=aqua]%s[/color]" % member[C_NAME])
	if strArr.size() <= 2:
		return strArr.join(" and ")
	strArr[strArr.size()-1] = "and " + strArr[strArr.size()-1]
	return strArr.join(", ")

# isGivers is true only when group is only the givers
func names(group, isGivers):
	var strArr = PoolStringArray()
	if isGivers:
		for member in group:
			if member[C_PERSON] == player:
				strArr.append("[color=yellow]your[/color]")
			else:
				strArr.append("[color=yellow]%s's[/color]" % member[C_NAME])
	else:
		for member in group:
			if member[C_PERSON] == player:
				strArr.append("[color=aqua]your[/color]")
			else:
				strArr.append("[color=aqua]%s's[/color]" % member[C_NAME])
	if strArr.size() <= 2:
		return strArr.join(" and ")
	strArr[strArr.size()-1] = "and " + strArr[strArr.size()-1]
	return strArr.join(", ")

#fuck() and variants used after "to" or a modal verb such as "will/should"
#fucks() used in other present tense cases, will return fuck() depending on group characteristics
#vfuck() and afuck() variants assume verticality
var randFuckStrs = [
	{
		'' : [
			["fuck","plow","screw","penetrate","churn","pummel"],
			["plunge ","hammer ","pound ","pump ","slam ","thrust ","grind ","drive "],
			["plunge ","pump ","slide ","thrust "],
			["plunge ","thrust "],
		],
		's' : [
			["fucks","plows","screws","penetrates","churns","pummels"],
			["plunges ","hammers ","pounds ","pumps ","slams ","thrusts ","grinds ","drives "],
			["plunges ","pumps ","slides ","thrusts "],
			["plunges ","thrusts "],
		],
		'ing' : [
			["fucking","plowing","screwing","penetrating","churning","pummeling"],
			["plunging ","hammering ","pounding ","pumping ","slaming ","thrusting ","grinding ","driving "],
			["plunging ","pumping ","sliding ","thrusting "],
			["plunging ","thrusting "],
		],
	},
	[" deep into"," into"],
	[" in and out of"],
	[" in and out of"," inside"],
]

func fuck(group, groupNum, suffix):
	if suffix == 's':
		if group.size() >= 2 || group[0][C_PERSON] == player:
			suffix = ''
	var rng = randi() % 4
	var ref = randFuckStrs[0][suffix][rng]
	if rng == 0:
		return getRandStr(ref)
	elif rng in [1,2]:
		if bool(randi() % 2):
			return getRandStr(ref) + selectPronouns(group, groupNum)[pronounIdxHis] + " " + penis(group) + getRandStr(randFuckStrs[rng])
		else:
			return getRandStr(ref) + getRandStr(randFuckStrs[rng]).right(1) #fixes double space
	else:
		if bool(randi() % 2):
			return getRandStr(ref) + selectPronouns(group, groupNum)[pronounIdxHis] + " " + penis(group) + getRandStr(randFuckStrs[rng])
		else:
			return getRandStr(ref) + selectPronouns(group, groupNum)[pronounIdxHimself] + getRandStr(randFuckStrs[rng])
	
var randVAFuckStrs = [
	{
		'' : [
			["massage","squeeze","envelop","milk"],
			["grind ","bounce ","gyrate "],
			["grind ","bounce ","gyrate ","thrust ","pump ","work "],
			["grind ","thrust ","slam ","pound "],
			["impale ","pleasure ","churn ","satisfy "],
		],
		's' : [
			["massages","squeezes","envelops","milks"],
			["grinds ","bounces ","gyrates "],
			["grinds ","bounces ","gyrates ","thrusts ","pumps ","works "],
			["grinds ","thrusts ","slams ","pounds "],
			["impales ","pleasures ","churns ","satisfies "],
		],
		'ing' : [
			["massaging","squeezing","enveloping","milking"],
			["grinding ","bouncing ","gyrating "],
			["grinding ","bouncing ","gyrating ","thrusting ","pumping ","working "],
			["grinding ","thrusting ","slamming ","pounding "],
			["impaling ","pleasuring ","churning ","satisfying "],
		],
	},
	["on top of","on","atop"], #fixes double space
	[" on top of"," on"," atop"],
	[" against"," down on"],
	[" on top of"," on"],
]	

func vfuck(group, groupNum, suffix):
	if suffix == 's':
		if group.size() >= 2 || group[0][C_PERSON] == player:
			suffix = ''
	var rng = randi() % 4
	var ref = randVAFuckStrs[0][suffix][rng]
	if rng == 0:
		return getRandStr(ref)
	elif rng == 1:
		return getRandStr(ref) + getRandStr(randVAFuckStrs[rng])
	elif rng == 2:
		return getRandStr(ref) + selectPronouns(group, groupNum)[pronounIdxHis] + " " + hips(group) + getRandStr(randVAFuckStrs[rng])
	else:
		if bool(randi() % 2):
			return getRandStr(ref) + selectPronouns(group, groupNum)[pronounIdxHis] + " " + pussy(group) + getRandStr(randVAFuckStrs[rng])
		else:
			return getRandStr(ref) + selectPronouns(group, groupNum)[pronounIdxHimself] + getRandStr(randVAFuckStrs[rng])

func afuck(group, groupNum, suffix):
	if suffix == 's':
		if group.size() >= 2 || group[0][C_PERSON] == player:
			suffix = ''
	var rng = randi() % 4
	var ref = randVAFuckStrs[0][suffix][rng]
	if rng == 0:
		return getRandStr(ref)
	elif rng == 1:
		return getRandStr(ref) + getRandStr(randVAFuckStrs[rng])
	elif rng == 2:
		return getRandStr(ref) + selectPronouns(group, groupNum)[pronounIdxHis] + " " + hips(group) + getRandStr(randVAFuckStrs[rng])
	else:
		if bool(randi() % 2):
			return getRandStr(ref) + selectPronouns(group, groupNum)[pronounIdxHis] + " " + anus(group) + getRandStr(randVAFuckStrs[rng])
		else:
			return getRandStr(ref) + selectPronouns(group, groupNum)[pronounIdxHimself] + getRandStr(randVAFuckStrs[rng])

#this could be added to the race dictionaries instead
var racenames = {
	Human = {
		single = " human",
		plural = " humans",
		singlepos = " human's",
		pluralpos = " humans'"
	},
	Elf = {
		single = " elf",
		plural = " elves",
		singlepos = " elf's",
		pluralpos = " elves'"
	},
	'Tribal Elf' : {
		single = " elf",
		plural = " elves",
		singlepos = " elf's",
		pluralpos = " elves'"
	},
	"Dark Elf" : {
		single = " elf",
		plural = " elves",
		singlepos = " elf's",
		pluralpos = " elves'"
	},
	Orc = {
		single = " orc",
		plural = " orcs",
		singlepos = " orc's",
		pluralpos = " orcs'"
	},
	Ogre = {
		single = " ogre",
		plural = " ogres",
		singlepos = " ogre's",
		pluralpos = " ogres'"
	},
	Giant = {
		single = " giant",
		plural = " giants",
		singlepos = " giant's",
		pluralpos = " giants'"
	},
	Gnome = {
		single = " gnome",
		plural = " gnomes",
		singlepos = " gnome's",
		pluralpos = " gnomes'"
	},
	Goblin = {
		single = " goblin",
		plural = " goblins",
		singlepos = " goblin's",
		pluralpos = " goblins'"
	},
	Fairy = {
		single = " fairy",
		plural = " fairies",
		singlepos = " fairy's",
		pluralpos = " fairies'"
	},
	Seraph = {
		single = " seraph",
		plural = " seraphs",
		singlepos = " seraph's",
		pluralpos = " seraphs'"
	},
	Demon = {
		single = " demon",
		plural = " demon's",
		singlepos = " demon's",
		pluralpos = " demons'"
	},
	Dryad = {
		single = " dryad",
		plural = " dryads",
		singlepos = " dryad's",
		pluralpos = " dryads'"
	},
	Dragonkin = {
		single = " dragon",
		plural = " dragons",
		singlepos = " dragon's",
		pluralpos = " dragons'"
	},
	Lizardfolk = {
		single = " lizard",
		plural = " lizards",
		singlepos = " lizard's",
		pluralpos = " lizards'",
	},
	Kobold = {
		single = " kobold",
		plural = " kobolds",
		singlepos = " kobold's",
		pluralpos = " kobolds'",
	}, 
	Gnoll = {
		single = " gnoll",
		plural = " gnolls",
		singlepos = " gnoll's",
		pluralpos = " gnolls'"
	},
	Taurus = {
		single = " taurus",
		plural = " tauruses",
		singlepos = " taurus'",
		pluralpos = " tauruses'"
	},
	Slime = {
		single = " slime",
		plural = " slimes",
		singlepos = " slime's",
		pluralpos = " slimes'"
	},
	Lamia = {
		single = " lamia",
		plural = " lamias",
		singlepos = " lamia's",
		pluralpos = " lamias'"
	},
	Harpy = {
		single = " harpy",
		plural = " harpies",
		singlepos = " harpy's",
		pluralpos = " harpies'"
	},
	Avali = {
		single = " avali",
		plural = " avalis",
		singlepos = " avali's",
		pluralpos = " avalis''"
	},
	Arachna = {
		single = " arachna",
		plural = " arachnas",
		singlepos = " arachna's",
		pluralpos = " arachnas'"
	},
	Centaur = {
		single = " centaur",
		plural = " centaurs",
		singlepos = " centaur's",
		pluralpos = " centaurs'"
	},
	Nereid = {
		single = " nereid",
		plural = " nereids",
		singlepos = " nereid's",
		pluralpos = " nereids'"
	},
	Scylla = {
		single = " scylla",
		plural = " scyllas",
		singlepos = " scylla's",
		pluralpos = " scyllas'"
	},
	"Beastkin Cat" : {
		single = " cat",
		plural = " cats",
		singlepos = " cat's",
		pluralpos = " cats'"
	},
	"Beastkin Fox" : {
		single = " fox",
		plural = " foxes",
		singlepos = " fox's",
		pluralpos = " foxes'"
	},
	"Beastkin Wolf" : {
		single = " wolf",
		plural = " wolves",
		singlepos = " wolf's",
		pluralpos = " wolves'"
	},
	"Beastkin Bunny" : {
		single = " bunny",
		plural = " bunnies",
		singlepos = " bunny's",
		pluralpos = " bunnies'"
	},
	"Beastkin Tanuki" : {
		single = " tanuki",
		plural = " tanukis",
		singlepos = " tanuki's",
		pluralpos = " tanukis'"
	},
	"Beastkin Mouse" : {
		single = " mousekin",
		plural = " micekin",
		singlepos = " mouse's",
		pluralpos = " mice",
	},
	"Beastkin Squirrel" : {
		single = " squirrelkin",
		plural = " squirrelkin",
		singlepos = " squirrel's",
		pluralpos = " squirrels'",
	},
	"Beastkin Otter" : {
		single = " otterkin",
		plural = " otterkin",
		singlepos = " otter's",
		pluralpos = " otters'",
	},
	"Beastkin Bird" : {
		single = " birdkin",
		plural = " birdkin",
		singlepos = " bird's",
		pluralpos = " birds'",
	},
	"Halfkin Cat" : {
		single = " cat",
		plural = " cats",
		singlepos = " cat's",
		pluralpos = " cats'"
	},
	"Halfkin Fox" : {
		single = " fox",
		plural = " foxes",
		singlepos = " fox's",
		pluralpos = " foxes'"
	},
	"Halfkin Wolf" : {
		single = " wolf",
		plural = " wolves",
		singlepos = " wolf's",
		pluralpos = " wolves'"
	},
	"Halfkin Bunny" : {
		single = " bunny",
		plural = " bunnies",
		singlepos = " bunny's",
		pluralpos = " bunnies'"
	},
	"Halfkin Tanuki" : {
		single = " tanuki",
		plural = " tanukis",
		singlepos = " tanuki's",
		pluralpos = " tanukis'"
	},
	"Halfkin Mouse" : {
		single = " mousekin",
		plural = " micekin",
		singlepos = " mouse's",
		pluralpos = " mice",
	},
	"Halfkin Squirrel" : {
		single = " squirrelkin",
		plural = " squirrelkin",
		singlepos = " squirrel's",
		pluralpos = " squirrels'",
	},
	"Halfkin Otter" : {
		single = " otterkin",
		plural = " otterkin",
		singlepos = " otter's",
		pluralpos = " otters'",
	},
	"Halfkin Bird" : {
		single = " birdkin",
		plural = " birdkin",
		singlepos = " bird's",
		pluralpos = " birds'",
	},
}


var descFemininity = [
	["muscular", "toned"], # masculine
	["dainty","delicate","slim","petite"], # thickness: [0,1,2] to [0,1,2]
	["healthy","shapely"], # thickness: [3,4] to [3,4,5,6]
	["healthy","shapely","sensuous","curvaceous","buxom"], # thickness: [5,6] to [5,6]
	["sensuous","curvaceous","buxom"], # thickness: [5,6] to 7+
	["sensuous","curvaceous","buxom","voluptuous","bombastic","meaty"], # thickness: 7+ to 7+
]
# tries to pick a descriptor that applies to the entire group, else returns null
func describeFemininity(group):
	if group[0][C_PERSON][C_TITSSIZE] == 'masculine':
		for i in range(1, group.size()):
			if group[i][C_PERSON][C_TITSSIZE] != 'masculine':
				return null
		return getRandStr(descFemininity[0])

	var low = 999
	var high = -999
	var temp
	for member in group:
		###---Added by Expansion---### Person Expanded
		temp = max(refTitsSizeArray.find(member[C_PERSON][C_TITSSIZE])-1, 0) + max(refAssSizeArray.find(member[C_PERSON][C_ASSSIZE])-1, 0) # calc thickness
		###---End Expansion---###
		low = min(low, temp)
		high = max(high, temp)
	if low <= 2:
		if high <= 2: # [0,1,2] to [0,1,2]
			return getRandStr(descFemininity[1])
	elif low <= 4:
		if high <= 6: # [3,4] to [3,4,5,6]
			return getRandStr(descFemininity[2])
	elif low <= 6:
		if high <= 6: # [5,6] to [5,6]
			return getRandStr(descFemininity[3])
		else: # [5,6] to 7+
			return getRandStr(descFemininity[4])
	else: # 7+ to 7+
		return getRandStr(descFemininity[5])
	return null


var descPreg = ["pregnant","gravid"]
# tries to pick a descriptor that applies to the entire group, else returns null
func describePreg(group):
	for member in group:
		if member[C_PERSON][C_PREG][C_DURATION] == 0:
			return null
	return getRandStr(descPreg)


var descAge = [
	["young","adolescent"], # ages: [0] to [0]
	["mature", "adult"], # ages: [2] to [2]
]
# tries to pick a descriptor that applies to the entire group, else returns null
func describeAge(group):
	var limitsAge = getAttribLimits(group, C_AGE, refAgesArray)
	if limitsAge[0] == 2: # [2] to [2]
		return getRandStr(descAge[1])
	elif limitsAge[1] == 1: # [0,1] to [1]
		return "young"
	elif limitsAge[1] == 0: # [0] to [0]
		return getRandStr(descAge[0])
	return null


var descBeauty = [
	["attractive","handsome"], # all male
	["attractive","cute","pretty"], # ages: [0] to [0,1]
	["attractive","cute","pretty","beautiful"], # ages: [1] to [1]
	["attractive","pretty","beautiful"], # ages: [1,2] to [2]
]
# tries to pick a descriptor that applies to the entire group, else returns null
func describeBeauty(group):
	if !areAllAttrib_GE_val(group, 'beauty', 50):
		return null
	if areAllAttrib_E_val(group, C_SEX, C_MALE):
		return getRandStr(descBeauty[0])

	var limitsAge = getAttribLimits(group, C_AGE, refAgesArray)
	if limitsAge[1] == 2:
		if limitsAge[0] >= 1: # [1,2] to [2]
			return getRandStr(descBeauty[3])
	elif limitsAge[0] == 0:
		if limitsAge[1] <= 1: # [0] to [0,1]
			return getRandStr(descBeauty[1])
	elif limitsAge[0] == limitsAge[1]: # [1] to [1]
		return getRandStr(descBeauty[2])
	return "attractive"


var descSize = [
	["tiny","small","little","pint-sized","diminutive"], # heights: [0,1] to [0,1]
	["giant","huge","large","big","tall"], # heights: [3,4] to [3,4]
]
# tries to pick a descriptor that applies to the entire group, else returns null
func describeSize(group):
	var limitsHeight = getAttribLimits(group, 'height', refHeightArray)
	if limitsHeight[0] < 2:
		if limitsHeight[1] < 2: # [0,1] to [0,1]
			return getRandStr(descSize[0])
	elif limitsHeight[0] > 2 && limitsHeight[1] > 2: # [3,4] to [3,4]
		return getRandStr(descSize[1])
	return null


var descCharm = [
	["adorable","cute"], # ages: [0] to [0,1]
	["adorable","cute","charming","enchanting","captivating"], # ages: [1] to [1]
	["charming","enchanting","captivating"], # ages: [1,2] to [2]
]
var descCour = ["shy","meek"]
var descConf = ["proud","haughty"]
var descLust = ["horny", "excited"]
# tries to pick a descriptor that applies to the entire group, else returns null
func describePersonality(group):
	var options = range(5)
	options.shuffle()
	for i in options:
		if i == 0:
			if areAllAttrib_G_val(group, 'charm', 60):
				var limitsAge = getAttribLimits(group, C_AGE, refAgesArray)
				if limitsAge[1] == 2: # [1,2] to [2]
					if limitsAge[0] >= 1:
						return getRandStr(descCharm[2])
				elif limitsAge[0] == 0: # [0] to [0,1]
					if limitsAge[1] <= 1:
						return getRandStr(descCharm[0])
				elif limitsAge[0] == limitsAge[1]: # [1] to [1]
					return getRandStr(descCharm[1])
		elif i == 1:
			if areAllAttrib_L_val(group, 'cour', 40):
				return getRandStr(descCour)
		elif i == 2:
			if areAllAttrib_G_val(group, 'wit', 80):
				return "clever"
		elif i == 3:
			if areAllAttrib_G_val(group, 'conf', 65):
				return getRandStr(descConf)
		elif i == 4:
			var val = true
			for member in group:
				if member.lust <= 300:
					val = false
					break
			if val:
				return getRandStr(descLust)
	return null


# tries to pick a descriptor that applies to the entire group, else returns null
func describeSexRace(group):
	var str1 = null
	var limitsAge = getAttribLimits(group, C_AGE, refAgesArray)
	if areAllAttrib_E_val(group, C_SEX, C_MALE):
		if limitsAge[0] == 2: # all adult
			str1 = " man" if group.size() == 1 else " men"
		elif bool(randi() % 2):
			str1 = " boy" if group.size() == 1 else " boys"
		elif limitsAge[1] == 0: # all child
			str1 = " child" if group.size() == 1 else " children"
		elif limitsAge[0] == limitsAge[1]: # all teen
			str1 = " teen" if group.size() == 1 else " teens"
		else: # more than 1 age
			str1 = " boys"
	elif areAllAttrib_NE_val(group, C_SEX, C_MALE):
		if limitsAge[0] == 2: # all adult
			str1 = " woman" if group.size() == 1 else " women"
		elif bool(randi() % 2):
			str1 = " girl" if group.size() == 1 else " girls"
		elif limitsAge[1] == 0: # all child
			str1 = " child" if group.size() == 1 else " children"
		elif limitsAge[0] == limitsAge[1]: # all teen
			str1 = " teen" if group.size() == 1 else " teens"
		else: # more than 1 age
			str1 = " girls"
	else:
		if limitsAge[1] == 0: # all child
			str1 = " child" if group.size() == 1 else " children"
		elif limitsAge[1] == 1 && limitsAge[0] == 1: # all teen
			str1 = " teen" if group.size() == 1 else " teens"
			
	if str1 != null:
		if randf() < 0.3:
			return str1
		var temp1 = racenames[ group[0][C_PERSON][C_RACE] ]
		var temp2 = temp1[C_SINGLE]
		for i in range(1,group.size()):
			if temp2 != racenames[ group[i][C_PERSON][C_RACE] ][C_SINGLE]:
				temp1 = null
				break	
		if temp1: # all same race
			if group.size() > 1 && randf() < 0.5:
				return temp1[C_PLURAL]
			else:
				return temp2 + str1
		else:
			return str1
	return null


# tries to pick a descriptor that applies to the entire group, else returns null
func describeSexRacePos(group):
	var str1 = null
	var limitsAge = getAttribLimits(group, C_AGE, refAgesArray)
	if areAllAttrib_E_val(group, C_SEX, C_MALE):
		if limitsAge[0] == 2: # all adult
			str1 = " man's" if group.size() == 1 else " men's"
		elif bool(randi() % 2):
			str1 = " boy's" if group.size() == 1 else " boys'"
		elif limitsAge[1] == 0: # all child
			str1 = " child's" if group.size() == 1 else " children's"
		elif limitsAge[0] == limitsAge[1]: # all teen
			str1 = " teen's" if group.size() == 1 else " teens'"
		else: # more than 1 age
			str1 = " boys'"
	elif areAllAttrib_NE_val(group, C_SEX, C_MALE):
		if limitsAge[0] == 2: # all adult
			str1 = " woman's" if group.size() == 1 else " women's"
		elif bool(randi() % 2):
			str1 = " girl's" if group.size() == 1 else " girls'"
		elif limitsAge[1] == 0: # all child
			str1 = " child's" if group.size() == 1 else " children's"
		elif limitsAge[0] == limitsAge[1]: # all teen
			str1 = " teen's" if group.size() == 1 else " teens'"
		else: # more than 1 age
			str1 = " girls'"
	else:
		if limitsAge[1] == 0: # all child
			str1 = " child's" if group.size() == 1 else " children's"
		elif limitsAge[1] == 1 && limitsAge[0] == 1: # all teen
			str1 = " teen's" if group.size() == 1 else " teens'"
			
	if str1 != null:
		if randf() < 0.3:
			return str1
		var temp1 = racenames[ group[0][C_PERSON][C_RACE] ]
		var temp2 = temp1[C_SINGLE]
		for i in range(1,group.size()):
			if temp2 != racenames[ group[i][C_PERSON][C_RACE] ][C_SINGLE]:
				temp1 = null
				break	
		if temp1: # all same race
			if randf() < 0.5:
				if group.size() > 1:
					return temp1[C_PLURALPOS]
				else:
					return temp1[C_SINGLEPOS]
			else:
				return temp2 + str1
		else:
			return str1
	return null


func partner(group, groupNum):
	if group.size() == 1 && groupNum == playerGroup:
		return "you"

	var str1 = null
	var options = range(6)
	options.shuffle()
	for i in options:
		if i < 3:
			if i == 0:
				str1 = describeFemininity(group)
			elif i == 1:
				str1 = describePreg(group)
			else:
				str1 = describeAge(group)
		else:
			if i == 3:
				str1 = describeBeauty(group)
			elif i == 4:
				str1 = describeSize(group)
			else:
				str1 = describePersonality(group)
		if str1 != null:
			break
	var str2 = describeSexRace(group)

	if str1 == null:
		if str2 == null:
			return "the diverse group"
		else:
			return "the" + str2
	elif str2 == null:
		return "the " + str1 + " group"
	else:
		return "the " + str1 + str2


func partners(group, groupNum):
	if group.size() == 1 && groupNum == playerGroup:
		return "your"

	var str1 = null
	var options = range(6)
	options.shuffle()
	for i in options:
		if i < 3:
			if i == 0:
				str1 = describeFemininity(group)
			elif i == 1:
				str1 = describePreg(group)
			else:
				str1 = describeAge(group)
		else:
			if i == 3:
				str1 = describeBeauty(group)
			elif i == 4:
				str1 = describeSize(group)
			else:
				str1 = describePersonality(group)
		if str1 != null:
			break
	var str2 = describeSexRace(group)
	
	if str1 == null:
		if str2 == null:
			return "the diverse group's"
		else:
			return "the" + str2
	elif str2 == null:
		return "the " + str1 + " group's"
	else:
		return "the " + str1 + str2


var descAge2 = ["youthful","immature"] # only children
# tries to pick a descriptor that applies to the entire group, else returns null
func describeAge2(group):
	var limitsAge = getAttribLimits(group, C_AGE, refAgesArray)
	if limitsAge[0] == 2: # [2] to [2]
		if areAllAttrib_E_val(group, C_SEX, C_MALE):
			return "manly"
		elif bool(randi() % 2) && areAllAttrib_NE_val(group, C_SEX, C_MALE):
			return "womanly"
		else:
			return "mature"
	elif limitsAge[1] == 1: # [0,1] to [1]
		return "youthful"
	elif limitsAge[1] == 0: # [0] to [0]
		return getRandStr(descAge2)
	return null


var descBeauty2 = [
	["alluring","enticing"], # child or male
	["alluring","enticing","ravishing","seductive"], # not child and not male
]
# tries to pick a descriptor that applies to the entire group, else returns null
func describeBeauty2(group):
	if !areAllAttrib_GE_val(group, 'beauty', 50):
		return null
	if areAllAttrib_NE_val(group, C_SEX, C_MALE) && areAllAttrib_NE_val(group, C_AGE, C_CHILD):
		return getRandStr(descBeauty2[1])
	return getRandStr(descBeauty2[0])

var descBodyType = [
	["transparent","squishy","gelatinous"], # bodyshape: jelly
	["long","serpentine"], # bodyshape: halfsnake
	["furry","fluffy","fur-covered"], # skincov: full_body_fur
	["scaly","reptilian",], # skincov: fullscales
	["feathery","feathered",], # skincov: fullfeathers
	["raptorish","feathered","alien"], # skincov: feathers_and_fur
]
# tries to pick a descriptor that applies to the entire group, else returns null
func describeBodyType(group):
	if areAllAttrib_E_val(group, C_BODYSHAPE, 'jelly'):
		return getRandStr(descBodyType[0])
	if areAllAttrib_E_val(group, C_BODYSHAPE, 'halfsnake'):
		return getRandStr(descBodyType[1])
	if areAllAttrib_E_val(group, C_SKINCOV, C_FULL_BODY_FUR):
		return getRandStr(descBodyType[2])
	if areAllAttrib_E_val(group, C_SKINCOV, C_FULL_BODY_SCALES):
		return getRandStr(descBodyType[3])
	if areAllAttrib_E_val(group, C_SKINCOV, C_FULL_BODY_FEATHERS):
		return getRandStr(descBodyType[4])
	if areAllAttrib_E_val(group, C_SKINCOV, C_FULL_BODY_FEATHERS_AND_FUR):
		return getRandStr(descBodyType[5])
	return null


func body(group):
	var str1 = null
	var options = range(5)
	options.shuffle()
	for i in options:
		if i < 2:
			if i == 0:
				str1 = describeFemininity(group)
			else:
				str1 = describeBeauty2(group)
		else:
			if i == 2:
				str1 = describeAge2(group)
			elif i == 3:
				str1 = describeSize(group)
			else:
				str1 = describeBodyType(group)
				
		if str1 != null:
			break
	var str2 = "body" if group.size() == 1 else "bodies"

	#30% of time do not use descriptors
	if str1 == null || randf() < 0.3:
		return str2
	else:
		return str1 + " " + str2


###---Added by Expansion---### Genital Expanded
var descPenisSize = [
	["micro","petite"], # size: [0] to [0]
	["micro","petite","immature"], # size: [0] to [0], child
	["tiny","small","petite"], # size: [0] to [0]
	["tiny","small","petite","immature"], # size: [0] to [0], child
	["small","petite"], # size: [0] to [0]
	["small","petite","immature"], # size: [0] to [0], child
	["average-sized","decently-sized"], # size: [1] to [1]
	["average-sized","decently-sized","well-developed","adult-like"], # size: [1] to [1], child
	["large","big","sizeable","thick","girthy"], # size: [2] to [2]
	["large","big","sizeable","thick","girthy","overgrown","surprisingly large"], # size: [2] to [2], child
	["massive","big","sizeable","thick","girthy","impressively large"], # size: [2] to [2]
	["massive","big","sizeable","thick","girthy","impressively large","overgrown","surprisingly humongous"], # size: [2] to [2], child
]
# tries to pick a descriptor that applies to the entire group, else returns null
func describePenis(group):
	var val
	var temp
	for member in group:
		temp = refGenitaliaArray.find(member[C_PERSON][C_PENIS])
		if temp == -1: # handle strapon with default size
			temp = 4
		if val != temp:
			if val == null:
				val = temp
			else:
				return null
	return getRandStr( descPenisSize[ clamp(val,0,5) * 2 + int(areAllAttrib_E_val(group, C_AGE, C_CHILD)) ])


var descPenisType = [
	[ null ], # penisType: human
	["knotted","tapered"], # penisType: canine
	["barbed"], # penisType: feline
	["flared","long"], # penisType: equine
	["tapered","slender","reptilian"], # penisType: reptilian
	["unsheathed","tapered","slender","rodent-like"], # penisType: rodent
	["unsheathed","tapered","slender","bird-like"], # penisType: bird
]
# tries to pick a descriptor that applies to the entire group, else returns null
func describePenisType(group):
	var limitsPenis = getAttribLimits(group, 'penistype', refPenisTypeArray)
	if limitsPenis[0] != 0 && limitsPenis[0] == limitsPenis[1]:
		return getRandStr(descPenisType[ limitsPenis[0] ])
	return null


var descPenis = [
	["strap-on","shaft"], # no penis singular nouns
	["strap-ons","shafts"], # no penis plural nouns
	["cock","dick","penis","shaft"], # penis singular nouns
	["cocks","dicks","penises","shafts"], # penis plural nouns
	["cock","dick","penis","shaft","manhood"], # only male penis singular nouns
	["cocks","dicks","penises","shafts","manhoods"], # only male penis plural nouns
	["cock","dick","penis","shaft","manhood","horse cock","horse dick"], # only male horse penis singular nouns
	["cocks","dicks","penises","shafts","manhoods","horse cocks","horse dicks"], # only male horse penis plural nouns
]
func penis(group):
	var str1 = null
	var options = range(3)
	options.shuffle()
	for i in options:
		if i == 0:
			str1 = describePenis(group)
		elif i == 1:
			str1 = describePenisType(group)
		elif areAllAttrib_E_val(group, C_SEX, 'futanari'):
			str1 = "futa"
				
		if str1 != null:
			break
	var str2
	if areAllAttrib_NE_val(group, 'penis', 'none'):
		if areAllAttrib_E_val(group, C_SEX, C_MALE):
			if areAllAttrib_E_val(group, 'penistype', 'equine'):
				str2 = getRandStr(descPenis[6] if group.size() == 1 else descPenis[7])
			else:
				str2 = getRandStr(descPenis[4] if group.size() == 1 else descPenis[5])
		else:
			str2 = getRandStr(descPenis[2] if group.size() == 1 else descPenis[3])
	elif areAllAttrib_E_val(group, 'penis', 'none'):
		str2 = getRandStr(descPenis[0] if group.size() == 1 else descPenis[1])
	else:
		str2 = "shaft" if group.size() == 1 else "shafts"

	#30% of time do not use descriptors
	if str1 == null || randf() < 0.3:
		return str2
	else:
		return str1 + " " + str2


var descPussyAge = [
	["childish","immature","girlish","youthful","undeveloped"], # ages: [0] to [0]
	["girlish","youthful"], # ages: [0] to [1]
	["girlish","youthful","developing"], # ages: [1] to [1]
	["womanly","mature","developed"], # ages: [2] to [2]
]
# tries to pick a descriptor that applies to the entire group, else returns null
func describePussyAge(group):
	var limitsAge = getAttribLimits(group, C_AGE, refAgesArray)
	if limitsAge[0] == 2: # [2] to [2]
		return getRandStr(descPussyAge[3])
	elif limitsAge[1] == 0: # [0] to [0]
		return getRandStr(descPussyAge[0])
	elif limitsAge[1] == 1:
		if limitsAge[0] == 0: # [0] to [1]
			return getRandStr(descPussyAge[1])
		else: # [1] to [1]
			return getRandStr(descPussyAge[2])
	return null


var descPussyLube = ["wet","slick","dripping"]
# tries to pick a descriptor that applies to the entire group, else returns null
func describePussyLube(group):
	for member in group:
		if member.lube <= 5:
			return null
	return getRandStr(descPussyLube)

# tries to pick a descriptor that applies to the entire group, else returns null
func describePussyFertile(group):
	for member in group:
		if !member[C_PERSON][C_PREG][C_HAS_WOMB] || member[C_PERSON][C_PREG][C_DURATION] > 0:
			return null
	return "fertile"


var descPubicHair = [
	["smooth","hairless","pubeless","bald"], # no pubic hair and child
	["hairless","pubeless"], # no pubic hair and mixed age
	["smoothly shaved","hairless","pubeless","shaved"], # no pubic hair and not child
]
# tries to pick a descriptor that applies to the entire group, else returns null
func describePubicHair(group):
	if areAllAttrib_NE_val(group, 'pubichair', 'clean'):
		var limitsAge = getAttribLimits(group, C_AGE, refAgesArray)
		if limitsAge[0] == 1: # [1,2] to [1,2]
			return getRandStr(descPubicHair[2])
		elif limitsAge[1] == 0: # [0] to [0]
			return getRandStr(descPubicHair[0])
		else: # [0] to [1,2]
			return getRandStr(descPubicHair[1])
	return null

var descPussy = [
	["virgin","virginal","unused"], # virgin vagina
	["muscular","horse","horse"], # all halfhorse
]
var pussyNouns = [
	["vagina","pussy","cunt"], # singular noun with halfhorses
	["vaginas","pussies","cunts"], # plural noun with halfhorses
	["vagina","pussy","cunt","slit"], # singular noun without halfhorses
	["vaginas","pussies","cunts","slits"], # plural noun without halfhorses
]
func pussy(group):
	var str1 = null
	var options = range(6)
	options.shuffle()
	for i in options:
		if i == 0:
			str1 = describePussyAge(group)
		elif i == 1:
			str1 = describePussyLube(group)
		elif i == 2:
			str1 = describePussyFertile(group)
		elif i == 3:
			if areAllAttrib_E_val(group, 'vagvirgin', true):
				str1 = getRandStr(descPussy[0])
		elif i == 4:
			str1 = describePubicHair(group)
		else:
			if areAllAttrib_E_val(group, C_BODYSHAPE, C_HALFHORSE):
				str1 = getRandStr(descPussy[1])

		if str1 != null:
			break
	var str2
	if areAllAttrib_NE_val(group, C_BODYSHAPE, C_HALFHORSE):
		str2 = getRandStr(pussyNouns[2] if group.size() == 1 else pussyNouns[3])
	else:
		str2 = getRandStr(pussyNouns[0] if group.size() == 1 else pussyNouns[1])

	#30% of time do not use descriptors
	if str1 == null || randf() < 0.3:
		return str2
	else:
		return str1 + " " + str2


var descLabia = ["labia","pussy lips","genitals","folds"]
func labia(group):
	if group.size() > 1:
		return "labia"
	return getRandStr(descLabia)


var descAssSizeAgeKeys = [
	[], # masculine child
	[], # masculine teen
	[], # masculine adult
	["flat","compact","tiny","developing","undeveloped","immature"], # flat child
	["flat","compact","tiny","developing","childlike"], # flat teen
	["flat","compact"], # flat adult
	["small","compact","undeveloped","immature"], # small child
	["small","compact","developing"], # small teen
	["small","compact"], # small adult
	["round","well-rounded","shapely","well-developed","impressively large"], # average child
	["round","well-rounded","shapely","well-developed"], # average teen
	["round","well-rounded","shapely"], # average adult
	["big","sizeable","plump","hefty","overgrown","surprisingly large"], # big child
	["big","sizeable","plump","hefty","well-developed","impressively large"], # big teen
	["big","sizeable","plump","hefty"], # big adult
	["huge","massive","fat","meaty","gigantic","enormous","overgrown","shockingly large"], # huge child
	["huge","massive","fat","meaty","gigantic","enormous","well-developed","surprisingly large"], # huge teen
	["huge","massive","fat","meaty","gigantic","enormous"], # huge adult
]
var descAssSizeAgeConvert = []
# tries to pick a descriptor that applies to the entire group, else returns null
# due to the complex overlaps of descriptor sets, this function uses the intersection of sets to create the set that applies to the entire group.
# to speed up the process, descAssSizeAgeConvert will store the unique descriptors and descAssSizeAgeKeys will be converted to the indexes of the descriptors found in descAssSizeAgeConvert.
func describeAssSizeAge(group):
	var refKeys
	var curSet = null
	for member in group:
		refKeys = descAssSizeAgeKeys[ clamp(refSizeArray.find(member[C_PERSON][C_ASSSIZE]),0,5) * 3 + refAgesArray.find(member[C_PERSON][C_AGE]) ]
		if curSet == null:
			curSet = refKeys # store ref as arrays are not mutated
		if curSet.empty():
			return null
		else:
			curSet = getIntersection(curSet, refKeys)
	if curSet.empty():
		return null
	else:
		return descAssSizeAgeConvert[ curSet[randi()%curSet.size()] ]


var descAssBodyType = [
	["gelatinous","slimy","gooey"], # bodyshape: jelly
	["equine","hairy"], # bodyshape: halfhorse
	["chitinous","spider"], # bodyshape: halfspider
	["furry","hairy"], # skincov: full_body_fur
	["scaly","reptilian"], # skincov: fullscales
	["feathery","feathered",], # skincov: fullfeathers
	["raptorish","feathered","alien"], # skincov: feathers_and_fur
]
# tries to pick a descriptor that applies to the entire group, else returns null
func describeAssBodyType(group):
	if areAllAttrib_E_val(group, C_BODYSHAPE, 'jelly'):
		return getRandStr(descAssBodyType[0])
	if areAllAttrib_E_val(group, C_BODYSHAPE, C_HALFHORSE):
		return getRandStr(descAssBodyType[1])
	if areAllAttrib_E_val(group, C_BODYSHAPE, 'halfspider'):
		return getRandStr(descAssBodyType[2])
	if areAllAttrib_E_val(group, C_SKINCOV, C_FULL_BODY_FUR):
		return getRandStr(descAssBodyType[3])
	if areAllAttrib_E_val(group, C_SKINCOV, C_FULL_BODY_SCALES):
		return getRandStr(descAssBodyType[4])
	if areAllAttrib_E_val(group, C_SKINCOV, C_FULL_BODY_FEATHERS):
		return getRandStr(descAssBodyType[5])
	if areAllAttrib_E_val(group, C_SKINCOV, C_FULL_BODY_FEATHERS_AND_FUR):
		return getRandStr(descAssBodyType[6])
	return null


var descBeauty3 = [
	["cute","cute","flawless","perfect"], # ages: [0] to [0]
	["cute","flawless","perfect"], # ages: [0] to [1]
	["flawless","perfect"], # ages: [0] to [2]
	["cute","beautiful","flawless","perfect"], # ages: [1] to [1]
	["beautiful","flawless","perfect"], # ages: [1] to [2]
	["seductive","beautiful","flawless","perfect"], # ages: [2] to [2]
]
# tries to pick a descriptor that applies to the entire group, else returns null
func describeBeauty3(group):
	if areAllAttrib_GE_val(group, 'beauty', 50):
		var limitsAge = getAttribLimits(group, C_AGE, refAgesArray)
		if limitsAge[0] == 2: # [2] to [2]
			return getRandStr(descBeauty3[5])
		elif limitsAge[0] == 1:
			if limitsAge[1] == 2: # [1] to [2]
				return getRandStr(descBeauty3[4])
			else: # [1] to [1]
				return getRandStr(descBeauty3[3])
		else:
			if limitsAge[1] == 2: # [0] to [2]
				return getRandStr(descBeauty3[2])
			elif limitsAge[1] == 1: # [0] to [1]
				return getRandStr(descBeauty3[1])
			else: # [0] to [0]
				return getRandStr(descBeauty3[0])
	return null


var descAssNouns = [
	["ass","butt","backside","rear"],
	["asses","butts","backsides","rears"],
	["ass","butt","backside","rear","hindquarters"],
	["asses","butts","backsides","rears","hindquarters"],
	["abdomen","butt"],
	["abdomens","butts"],
]
func ass(group):
	var str1 = null
	var options = range(3)
	options.shuffle()
	for i in options:
		if i == 0:
			str1 = describeAssSizeAge(group)
		elif i == 1:
			str1 = describeAssBodyType(group)
		else:
			str1 = describeBeauty3(group)

		if str1 != null:
			break
	var str2
	if areAllAttrib_E_val(group, C_BODYSHAPE, 'halfspider'):
		str2 = getRandStr(descAssNouns[4] if group.size() == 1 else descAssNouns[5])
	elif areAllAttrib_E_val(group, C_BODYSHAPE, C_HALFHORSE):
		str2 = getRandStr(descAssNouns[2] if group.size() == 1 else descAssNouns[3])
	else:
		str2 = getRandStr(descAssNouns[0] if group.size() == 1 else descAssNouns[1])

	#30% of time do not use descriptors
	if str1 == null || randf() < 0.3:
		return str2
	else:
		return str1 + " " + str2

var maleAssSizes = ['masculine','flat','small']
var descHipsSizeAgeKeys = [
	["trim","slim"], # masculine child
	["trim","slim"], # masculine teen
	["trim","slim"], # masculine adult
	["slim","slender","petite","tiny"], # flat child
	["slim","slender","petite","tiny"], # flat teen
	["slim","slender","petite","tiny"], # flat adult
	["slim","slender","svelte","small"], # small child
	["slim","slender","svelte","small"], # small teen
	["slim","slender","svelte","small"], # small adult
	["curved","shapely","well-developed","impressively thick"], # average child
	["curved","shapely","well-developed"], # average teen
	["curved","shapely"], # average adult
	["sizeable","ample","wide","thick","curvaceous","overgrown","surprisingly thick"], # big child
	["sizeable","ample","wide","thick","curvaceous","well-developed","impressively thick"], # big teen
	["sizeable","ample","wide","thick","curvaceous"], # big adult
	["huge","massive","enormous","wide","thick","curvaceous","overgrown","shockingly thick"], # huge child
	["huge","massive","enormous","wide","thick","curvaceous","well-developed","surprisingly thick"], # huge teen
	["huge","massive","enormous","wide","thick","curvaceous"], # huge adult
]
var descHipsSizeAgeConvert = []
# tries to pick a descriptor that applies to the entire group, else returns null
# due to the complex overlaps of descriptor sets, this function uses the intersection of sets to create the set that applies to the entire group.
# to speed up the process, descAssSizeAgeConvert will store the unique descriptors and descAssSizeAgeKeys will be converted to the indexes of the descriptors found in descAssSizeAgeConvert.
func describeHipsSizeAge(group):
	var refKeys
	var curSet = null
	for member in group:
		if member[C_PERSON][C_SEX] == 'male' && member[C_PERSON][C_ASSSIZE] in maleAssSizes:
			refKeys = descHipsSizeAgeKeys[2]
		else:
			###---Added by Expansion---### Person Expanded
			refKeys = descHipsSizeAgeKeys[ clamp(refAssSizeArray.find(member[C_PERSON][C_ASSSIZE]),1,5) * 3 + refAgesArray.find(member[C_PERSON][C_AGE]) ]
			###---End Expansion---###
		if curSet == null:
			curSet = refKeys # store ref as arrays are not mutated
		if curSet.empty():
			return null
		else:
			curSet = getIntersection(curSet, refKeys)
	if curSet.empty():
		return null
	else:
		return descHipsSizeAgeConvert[ curSet[randi()%curSet.size()] ]


var descHipsBodyType = [
	["equine","hairy"], # bodyshape: halfhorse
	["furry","hairy"], # skincov: full_body_fur
	["scaly","reptilian"], # skincov: fullscales
	["feathery","feathered",], # skincov: fullfeathers
	["raptor-like","feathery"], # skincov: feathers_and_fur
]
# tries to pick a descriptor that applies to the entire group, else returns null
func describeHipsBodyType(group):
	if areAllAttrib_E_val(group, C_BODYSHAPE, C_HALFHORSE):
		return getRandStr(descAssBodyType[0])
	if areAllAttrib_E_val(group, C_BODYSHAPE, 'halfsnake'):
		return "scaly"
	if areAllAttrib_E_val(group, C_SKINCOV, C_FULL_BODY_FUR):
		return getRandStr(descAssBodyType[1])
	if areAllAttrib_E_val(group, C_SKINCOV, C_FULL_BODY_SCALES):
		return getRandStr(descAssBodyType[2])
	if areAllAttrib_E_val(group, C_SKINCOV, C_FULL_BODY_FEATHERS):
		return getRandStr(descAssBodyType[3])
	if areAllAttrib_E_val(group, C_SKINCOV, C_FULL_BODY_FEATHERS_AND_FUR):
		return getRandStr(descAssBodyType[4])
	return null


#only to be used in specific contexts to avoid description bloat
#not a replacement for "hips"
func hips(group):
	var str1 = null
	var options = range(2)
	options.shuffle()
	for i in options:
		if i == 0:
			str1 = describeHipsSizeAge(group)
		else:
			str1 = describeHipsBodyType(group)

		if str1 != null:
			break

	#30% of time do not use descriptors
	if str1 == null || randf() < 0.3:
		return "hips"
	else:
		return str1 + " hips"


###---Added by Expansion---### Person Expanded
var descTitsSizeAgeKeys = [
	["muscular","strong","toned"], # masculine child
	["muscular","strong","toned"], # masculine teen
	["muscular","strong","toned"], # masculine adult
	["flat","small","tiny","developing","undeveloped","immature"], # flat child
	["flat","small","tiny","developing","childlike"], # flat teen
	["flat","small"], # flat adult
	["small","compact","undeveloped","immature","perky"], # small child
	["small","compact","developing","perky"], # small teen
	["small","compact","perky"], # small adult
	["round","well-rounded","shapely","well-developed","impressively large"], # average child
	["round","well-rounded","shapely","well-developed"], # average teen
	["round","well-rounded","shapely"], # average adult
	["big","sizeable","plump","hefty","overgrown","surprisingly large"], # big child
	["big","sizeable","plump","hefty","well-developed","impressively large"], # big teen
	["big","sizeable","plump","hefty"], # big adult
	["huge","fat","meaty","enormous","overgrown","shockingly large","pillowy"], # huge child
	["huge","fat","meaty","enormous","well-developed","surprisingly large","pillowy"], # huge teen
	["huge","fat","meaty","enormous","pillowy"], # huge adult
	["incredible","enormous","overgrown","shockingly large","incredible","over-sized"], # incredible child
	["incredible","enormous","well-developed","surprisingly large","incredible","over-sized"], # incredible teen
	["incredible","enormous","incredible","over-sized"], # incredible adult
	["massive","enormous","overgrown","unbelievably large","mind-blowing","over-sized","heavy","impressively large"], # massive child
	["massive","enormous","well-developed","unbelievably large","mind-blowing","over-sized","heavy","impressively large"], # massive teen
	["massive","enormous","over-sized","heavy","impressively large"], # massive adult
	["gigantic","enormous","overgrown","unbelievably large","mind-blowing","over-sized","bulging","insanely large"], # gigantic child
	["gigantic","enormous","over-developed","unbelievably large","mind-blowing","over-sized","bulging","insanely large"], # gigantic teen
	["gigantic","enormous","over-sized","heavy","insanely large"], # gigantic adult
	["monstrous","enormous","overgrown","unbelievable","mind-blowing","over-sized","debilitating","painfully large"], # monstrous child
	["monstrous","enormous","over-developed","unbelievable","mind-blowing","over-sized","debilitating","painfully large"], # monstrous teen
	["monstrous","enormous","unbelievable","over-sized","debilitating","insanely large"], # monstrous adult
	["immobilizing","enormous","overgrown","unbelievable","mind-blowing","over-sized","debilitating","painfully large"], # immobilizing child
	["immobilizing","enormous","over-developed","unbelievable","mind-blowing","over-sized","debilitating","painfully large"], # immobilizing teen
	["immobilizing","enormous","unbelievable","over-sized","debilitating","insanely large"], # immobilizing adult
]
###---End Expansion---###
var descTitsSizeAgeConvert = []
# tries to pick a descriptor that applies to the entire group, else returns null
# due to the complex overlaps of descriptor sets, this function uses the intersection of sets to create the set that applies to the entire group.
# to speed up the process, descTitsSizeAgeConvert will store the unique descriptors and descTitsSizeAgeKeys will be converted to the indexes of the descriptors found in descTitsSizeAgeConvert.
func describeTitsSizeAge(group):
	var refKeys
	var curSet = null
	for member in group:
		###---Added by Expansion---### Person Expanded
		refKeys = descTitsSizeAgeKeys[ clamp(refTitsSizeArray.find(member[C_PERSON][C_TITSSIZE]),0,5) * 3 + refAgesArray.find(member[C_PERSON][C_AGE]) ]
		###---End Expansion---###
		if curSet == null:
			curSet = refKeys # store ref as arrays are not mutated
		if curSet.empty():
			return null
		else:
			curSet = getIntersection(curSet, refKeys)
	if curSet.empty():
		return null
	else:
		return descTitsSizeAgeConvert[ curSet[randi()%curSet.size()] ]


var descTitsBodyType = [
	["gelatinous","slimy","gooey"], # bodyshape: jelly
	["furry","fluffy"], # skincov: full_body_fur
	["scaly","reptilian"], # skincov: fullscales
	["feathery","feathered",], # skincov: fullfeathers
	["furry","fluffy"], # skincov: feathers_and_fur
]
# tries to pick a descriptor that applies to the entire group, else returns null
func describeTitsBodyType(group):
	if areAllAttrib_E_val(group, C_BODYSHAPE, 'jelly'):
		return getRandStr(descTitsBodyType[0])
	###---Added by Expansion---### Sizes Expanded (Multiple Tits Crashing Issue)
	if areAllAttrib_E_val(group, C_SKINCOV, C_FULL_BODY_FUR):
		return getRandStr(descTitsBodyType[1])
	###---End Expansion---###
	if areAllAttrib_E_val(group, C_SKINCOV, C_FULL_BODY_SCALES):
		return getRandStr(descTitsBodyType[2])
	if areAllAttrib_E_val(group, C_SKINCOV, C_FULL_BODY_FEATHERS):
		return getRandStr(descTitsBodyType[3])
	if areAllAttrib_E_val(group, C_SKINCOV, C_FULL_BODY_FEATHERS_AND_FUR):
		return getRandStr(descTitsBodyType[4])
	return null


var descTitsNouns = [
	["chest","pecs"],
	["chests","pecs"],
	["tits","boobs","breasts","chest"],
	["tits","boobs","breasts","chests"],
]
func tits(group):
	var str1 = null
	var options = range(3)
	options.shuffle()
	for i in options:
		if i == 0:
			str1 = describeTitsSizeAge(group)
		elif i == 1:
			str1 = describeTitsBodyType(group)
		else:
			str1 = describeBeauty3(group)

		if str1 != null:
			break
	var str2
	if areAllAttrib_E_val(group, C_TITSSIZE, C_MASCULINE):
		str2 = getRandStr(descTitsNouns[0] if group.size() == 1 else descTitsNouns[1])
	elif areAllAttrib_NE_val(group, C_TITSSIZE, C_MASCULINE):
		str2 = getRandStr(descTitsNouns[2] if group.size() == 1 else descTitsNouns[3])
	else:
		str2 = "chest" if group.size() == 1 else "chests"

	#30% of time do not use descriptors
	if str1 == null || randf() < 0.3:
		return str2
	else:
		return str1 + " " + str2


var descAnus = [
	["virgin","virginal","unused"], # ass virgin
	["pink","youthful"], # not adult
	["rosy","mature"], # adult
	["anus","asshole","butthole","rectum"], # noun singular
	["anuses","assholes","buttholes","rectums"], # noun plural
]
func anus(group):
	var str1 = null
	if areAllAttrib_E_val(group, 'assvirgin', true):
		str1 = getRandStr(descAnus[0])
	if areAllAttrib_E_val(group, C_AGE, 'adult'):
		str1 = getRandStr(descAnus[2])
	elif areAllAttrib_NE_val(group, C_AGE, 'adult'):
		str1 = getRandStr(descAnus[1])
	if str1 == null:
		return getRandStr(descAnus[4] if group.size() > 1 else descAnus[3])
	return str1 + " " + getRandStr(descAnus[4] if group.size() > 1 else descAnus[3])



func getRandStr(array):
	if array.empty():
		return ""
	return array[randi()%array.size()]

# finds index of attribute value in refArray for each member of group
# returns array: [minIdx, maxIdx] 
func getAttribLimits(group, attrib, refArray):
	var low = 999
	var high = -999
	var temp
	for member in group:
		temp = refArray.find(member[C_PERSON][attrib])
		low = min(low, temp)
		high = max(high, temp)
	return [low, high]

# check if all members of group have attribute equal to given value
func areAllAttrib_E_val(group, attrib, value):
	for member in group:
		if member[C_PERSON][attrib] != value:
			return false
	return true

# check if all members of group have attribute not equal to given value
func areAllAttrib_NE_val(group, attrib, value):
	for member in group:
		if member[C_PERSON][attrib] == value:
			return false
	return true

# check if all members of group have attribute less than given value
func areAllAttrib_L_val(group, attrib, value):
	for member in group:
		if member[C_PERSON][attrib] >= value:
			return false
	return true

# check if all members of group have attribute less than or equal to given value
func areAllAttrib_LE_val(group, attrib, value):
	for member in group:
		if member[C_PERSON][attrib] > value:
			return false
	return true

# check if all members of group have attribute greater than given value
func areAllAttrib_G_val(group, attrib, value):
	for member in group:
		if member[C_PERSON][attrib] <= value:
			return false
	return true

# check if all members of group have attribute greater than or equal to given value
func areAllAttrib_GE_val(group, attrib, value):
	for member in group:
		if member[C_PERSON][attrib] < value:
			return false
	return true

func getIntersection(array1, array2):
	var intersection = []
	for i in array1:
		if array2.has(i):
			intersection.append(i)
	return intersection

# refDescConvert will store the unique descriptors and refDescKeys will be converted to the indexes of the descriptors found in refDescConvert.
# this function modifies the arrays passed to it by ref
func simplifyDesc(refDescKeys, refDescConvert):
	for i in range(refDescKeys.size()):
		var temp = refDescKeys[i]
		if typeof(temp) == TYPE_ARRAY:
			for j in range(temp.size()):
				var idx = refDescConvert.find(temp[j])
				if idx == -1:
					idx = refDescConvert.size()
					refDescConvert.append(temp[j])
				temp[j] = idx
		elif typeof(temp) == TYPE_STRING:
			var idx = refDescConvert.find(temp)
			if idx == -1:
				idx = refDescConvert.size()
				refDescConvert.append(temp)
			refDescKeys[i] = idx

var C_PENIS = 'penis'
