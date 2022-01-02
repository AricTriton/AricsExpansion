
func takereffect(member):
	var result
	var effects = {sens = 150}
	member.lube()
	if member.sex == 'male' || member.sex == 'dickgirl':
		member.lube = min(5, member.lube + 2)
	if member.consent == true || (member.person.traits.find("Likes it rough") >= 0 && member.sens >= 300):
		result = 'good'
	elif member.person.traits.find("Likes it rough") >= 0:
		result = 'average'
	else:
		result = 'bad'
	return [result, effects]
