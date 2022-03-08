extends Node

const category = 'humiliation'
const code = 'facefuck'
var givers
var takers
const canlast = true
const giverpart = 'penis'
const takerpart = 'mouth'
const virginloss = false
const giverconsent = 'any'
const takerconsent = 'any'
const givertags = ['penis']
const takertags = ['shame', 'punish', 'mouth']

func getname(state = null):
	if givers.size() + takers.size() == 2:
		return "Facefuck"
	else:
		return "Double Facefuck"

func getongoingname(givers, takers):
	return "[name1] thrust[s/1] [his1] [penis1] into [names2] mouth."

func getongoingdescription(givers, takers):
	var temparray = []
	if givers.size() > 1:
		temparray += ["[name1] {^both continue to [fuck1]:continue taking turns [fucking1]:continue to tag team [fuck1]} [names2] {^mouth:face}."]
		temparray += ["[name1] {^stand over:loom over} [name2] as the two continue to {^grind their [penis1] together in:hump:roughly [fuck1]} [names2] mouth."]
	else:
		if takers[0].person.horns == "none":
			temparray += ["[name1] {^grab[s/1]:hold[s/1] onto} [names2] head and {^continue[s/1] to fuck [names2] mouth:thrust[s/1] [his1] [penis1] into [him2] mouth}."]
		else:
			temparray += ["[name1] {^grab[s/1]:hold[s/1] onto} [names2] horns and {^continue[s/1] to fuck [names2] mouth:thrust[s/1] [his1] [penis1] into [him2] mouth}."]
	return temparray[randi()%temparray.size()]

func requirements():
	var valid = true
	if takers.size() < 1 || givers.size() < 1:
		valid = false
	elif takers.size() > 1 || givers.size() > 2:
		valid = false
	else:
		for i in givers:
			if i.person.penis == 'none':
				valid = false
			if 	i.person.energy == 0:
				valid = false
	return valid

func givereffect(member):
	var result
	var effects = {sens = 180}
	if member.consent == true || (member.person.traits.find("Likes it rough") >= 0 && member.sens >= 200):
		result = 'good'
	elif member.person.traits.find("Likes it rough") >= 0:
		result = 'average'
	else:
		result = 'bad'
	return [result, effects]

func takereffect(member):
	member.person.metrics.oral += 1
	if !member.person.sexuals.actions.has('blowjob'):
		member.person.sexuals.actions['blowjob'] = 0
	member.person.sexuals.actions['blowjob'] += 1
	var result
	var effects = {sens = 75}
	if member.consent == true || (member.person.traits.find("Likes it rough") >= 0 && member.sens >= 200):
		result = 'good'
	elif member.person.traits.find("Likes it rough") >= 0:
		result = 'average'
	else:
		result = 'bad'
	return [result, effects]

func initiate():
	var temparray = []
	var horns = 'head'
	if takers[0].person.horns != "none":
		horns = 'horns'
	temparray += ["[name1] {^grab[s/1]:hold[s/1] onto} [names2] " + horns + " and {^shove:rub:grind} [his1] [penis1] against [names2] face. [he2] responds by taking and putting [it1] into [he2] mouth."]
	temparray += ["[name1] {^grab[s/1]:hold[s/1] onto} [names2] " + horns + " and open [his2] mouth, where [he1] {^thrust:pump:shove:ram} [his1] [penis1] inside. [name2] {^moans at the:coos at the:loves the} {^embarassing:demeaning:humiliating} treatment."]
	return temparray[randi()%temparray.size()]

func reaction(member):
	var text = ''
	var horns = 'head'
	if member.person.horns != "none":
		horns = 'horns'
	if member.sens < 100:
		text = "[name2] take[s/2] [names1] [penis1] and {^lick[s/2]:kiss[es/2]:rub[s/2]} [it1]. [name1] grab [names2] " + horns + " and {^slowly:methodically:softly} {^slide:thrust:pump}[s/1] [his1] [penis1] into [his2] mouth."
	elif member.sens < 400:
		text = "[name2] look[s/2] up at [name1] with {^lustful:horny:bedroom} eyes. {^In response:In turn:As an answer}, [name1] {^pick up the pace:begin to move quicker} and {^push:thrust:pump}[s/1] [his1] [penis1] into [his2] mouth."
	elif member.sens < 800:
		text = "[name2] {^suck:blow}[s/2] [names1] [penis1], [his1] rod[/s1] being {^thrust:pumped:shoved:rammed} {^with passion:fervently:feverishly:passionately} into [names2] mouth. [his2] face is {^slapped:pounded:flattened:trampled} by [his1] balls and [he2] {^can't get enough:love[s/2] it:want[s/2] more}."
	else:
		text = "[name2] {^trembles:shakes:quivers}, barely able to contain [himself2]. [name1] see[s/1] this, knowing [he2] loves the {^rough:brutal:demeaning:embarassing} treatment as [he2] {^sputter:gag:choke}[s/2] on [his1] [penis1]. [he1] only move faster as [his2] face is {^slapped:pounded:flattened:trampled} by [his1] balls and [he2] {^can't get enough:love[s/2] it:want[s/2] more}."
	return text 
