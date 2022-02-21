func givereffect(member):
	if !member.person.sexuals.actions.has('blowjob'):
		member.person.sexuals.actions['blowjob'] = 0
	member.person.sexuals.actions['blowjob'] += 1
	var result
	var effects = {sens = 75}
	member.person.metrics.oral += 1
	if member.consent == true || (member.person.traits.find("Likes it rough") >= 0 && member.sens >= 200):
		result = 'good'
	elif member.person.traits.find("Likes it rough") >= 0:
		result = 'average'
	else:
		result = 'bad'
	return [result, effects]
