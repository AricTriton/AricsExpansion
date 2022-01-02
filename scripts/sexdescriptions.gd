var C_FULL_BODY_SCALES = 'fullscales'
var C_FULL_BODY_FEATHERS = 'fullfeathers'
var C_FULL_BODY_FEATHERS_AND_FUR = 'feathers_and_fur'

var refPenisTypeArray = globals.penistypearray # ['human','canine','feline','equine','reptilian','rodent','bird',]

var descBodyType = [
	["transparent","squishy","gelatinous"], # bodyshape: jelly
	["long","serpentine"], # bodyshape: halfsnake
	["furry","fluffy","fur-covered"], # skincov: full_body_fur
	["scaly","reptilian",], # skincov: fullscales
	["feathery","feathered",], # skincov: fullfeathers
	["raptorish","feathered","alien"], # skincov: feathers_and_fur
]

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

var descPenisType = [
	[ null ], # penisType: human
	["knotted","tapered","canine"], # penisType: canine
	["barbed","feline"], # penisType: feline
	["flared","long","equine"], # penisType: equine
	["tapered","slender","reptilian"], # penisType: reptilian
	["unsheathed","tapered","slender","rodent-like"], # penisType: rodent
	["unsheathed","tapered","slender","bird-like"], # penisType: bird
]

var descAssBodyType = [
	["gelatinous","slimy","gooey"], # bodyshape: jelly
	["equine","hairy"], # bodyshape: halfhorse
	["chitinous","spider"], # bodyshape: halfspider
	["furry","hairy"], # skincov: full_body_fur
	["scaly","reptilian"], # skincov: fullscales
	["feathery","feathered",], # skincov: fullfeathers
	["raptorish","feathered","alien"], # skincov: feathers_and_fur
]

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

var descHipsBodyType = [
	["equine","hairy"], # bodyshape: halfhorse
	["furry","hairy"], # skincov: full_body_fur
	["scaly","reptilian"], # skincov: fullscales
	["feathery","feathered",], # skincov: fullfeathers
	["raptor-like","feathery"], # skincov: feathers_and_fur
]

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

var descTitsBodyType = [
	["gelatinous","slimy","gooey"], # bodyshape: jelly
	["furry","fluffy"], # skincov: full_body_fur
	["scaly","reptilian"], # skincov: fullscales
	["feathery","feathered",], # skincov: fullfeathers
	["furry","fluffy"], # skincov: feathers_and_fur
]

func describeTitsBodyType(group):
	if areAllAttrib_E_val(group, C_BODYSHAPE, 'jelly'):
		return getRandStr(descTitsBodyType[0])
	if areAllAttrib_E_val(group, C_SKINCOV, C_FULL_BODY_FUR):
		return getRandStr(descTitsBodyType[1])
	if areAllAttrib_E_val(group, C_SKINCOV, C_FULL_BODY_SCALES):
		return getRandStr(descTitsBodyType[2])
	if areAllAttrib_E_val(group, C_SKINCOV, C_FULL_BODY_FEATHERS):
		return getRandStr(descTitsBodyType[3])
	if areAllAttrib_E_val(group, C_SKINCOV, C_FULL_BODY_FEATHERS_AND_FUR):
		return getRandStr(descTitsBodyType[4])
	return null

