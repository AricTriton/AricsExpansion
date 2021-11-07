
func traits(tag):
	var rval = []
	var traits = traitlist
	
	if tag == 'any':
		for i in traits:
			###---Added by Expansion---### Modified to block Expansion Traits from randomizing
			if traits[i]['tags'].has('secondary') != true && traits[i]['tags'].has('expansiontrait') != true:
			###---Expansion End---###
				rval.append(traits[i])
	else:
#warning-ignore:unused_variable
		var temp = traits.keys()
		if typeof(tag) != TYPE_ARRAY:
			for i in traits:
				if traits[i]['tags'].has(tag):
					rval.append(traits[i])
		else:
			for i in traits:
				if traits[i]['tags'].has(tag[0]) && traits[i]['tags'].has(tag[1]):
					rval.append(traits[i])
	return globals.randomfromarray(rval)
