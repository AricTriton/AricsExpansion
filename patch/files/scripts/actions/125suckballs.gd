extends Node

const category = 'caress'
const code = 'suckballs'
const order = 11
var givers
var takers
const canlast = true
const giverpart = 'mouth'
const takerpart = 'balls'
const virginloss = false
const giverconsent = 'basic'
const takerconsent = 'any'
const givertags = ['oral','noorgasm']
const takertags = ['balls']

func getname(state = null):
	if givers.size() + takers.size() == 2:
		return "Suck Balls"
	else:
		return "Smlt. Suck Balls"

func getongoingname(givers, takers):
	return "[name1] suck[s/1] [names2] balls."

func getongoingdescription(givers, takers):
	var temparray = []
	temparray += ["[name1] {^steadily :rhythmically :carefully :}{^suck:lick}[s/1] [names2] balls{^, trying to maintain eye contact:, studying [his2] reactions:}."]
	temparray += ["[name1] {^work:nurse:serve}[s/1] [names2] balls with [his1] mouth[/s1]."]
	return temparray[randi()%temparray.size()]

func requirements():
	var valid = true
	if takers.size() < 1 || givers.size() < 1:
		valid = false
	else:
		for i in takers:
			if i.person.balls == 'none':
				valid = false
	return valid

func givereffect(member):
	var result
	var effects = {sens = 55}
	member.person.metrics.oral += 1
	if member.consent == true || (member.person.traits.find("Likes it rough") >= 0 && member.sens >= 200):
		result = 'good'
	elif member.person.traits.find("Likes it rough") >= 0:
		result = 'average'
	else:
		result = 'bad'
	return [result, effects]

func takereffect(member):
	var result
	var effects = {sens = 150}
	if member.consent == true || (member.person.traits.find("Likes it rough") >= 0 && member.sens >= 200):
		result = 'good'
	elif member.person.traits.find("Likes it rough") >= 0:
		result = 'average'
	else:
		result = 'bad'
	return [result, effects]

func initiate():
	var temparray = []
	temparray += ["[name1] {^take:place:shove}[s/1] [names2] balls into [his1] mouth[/s1], {^carefully serving:sucking:slurping at} them with [his1] tongue[/s1]."]
	temparray += ["[name1] {^kiss[es/1]:rub[s/1] [his1] face against:lick[s/1] the underside:admire[s/1]} [names2] balls as [he1] begin[s/1] {^servicing:slurping at:milking:attending} them."]
	return temparray[randi()%temparray.size()]

func reaction(member):
	var text = ''
	if member.energy == 0:
		text = "[name2] lie[s/2] unconscious, {^trembling:twitching} {^slightly :}as [his2] balls {^respond:react}[s/#2] to {^the stimulation:[names1] mouth[/s1]:[names1] fellatio}."
	#elif member.consent == false:
		#TBD
	elif member.sens < 100:
		text = "[name2] {^show:give}[s/2] little {^response:reaction} to {^the stimulation:[names1] efforts:[names1] fellatio}."
	elif member.sens < 400:
		text = "[name2] {^begin:start}[s/2] to {^respond:react} as [his2] balls get[s/#1] {^sucked:licked:fellated}."
	elif member.sens < 800:
		text = "[name2] {^moan[s/2]:cr[ies/y2] out} in {^pleasure:arousal:ecstacy} as [his2] balls get[s/#1] {^sucked:licked:fellated}."
	else:
		text = "[names2] body {^trembles:quivers} {^at the slightest movement of [names1] tongue[/s1] against [his2] balls]:in response to [names1] fellatio}{^ as [he2] rapidly near[s/2] orgasm: as [he2] approach[es/2] orgasm: as [he2] edge[s/2] toward orgasm:}."
	return text 
