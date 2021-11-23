extends Node

const category = 'caress'
const code = 'rimjob'
const order = 8
var givers
var takers
const canlast = true
const giverpart = 'mouth'
const takerpart = 'anus'
const virginloss = false
const giverconsent = 'advanced'
const takerconsent = 'any'
const givertags = ['oral','noorgasm']
const takertags = ['anal']

func getname(state = null):
	return "Rimjob"

func getongoingname(givers, takers):
	return "[name1] give[s/1] [a /1]rimjob[/s1] to [name2]."

func getongoingdescription(givers, takers):
	return "[name1] {^eat[s/1] out:lick[s/1]:slurp[s/1] at} [names2] [anus2]."

func requirements():
	var valid = true
	if takers.size() < 1 || givers.size() < 1 || givers.size() + takers.size() > 3:
		valid = false
#	else:
#		for i in givers:
#			if i.mouth != null:
#				valid = false
#		for i in takers:
#			if i.anus != null:
#				valid = false
	return valid

func givereffect(member):
	var result
	var effects = {sens = 80}
	if member.consent == true || (member.person.traits.find("Likes it rough") >= 0 && member.lewd >= 20):
		result = 'good'
	elif member.person.traits.find("Likes it rough") >= 0:
		result = 'average'
	else:
		result = 'bad'
	return [result, effects]

func takereffect(member):
	var result
	var effects = {sens = 150}
	member.lube()
###---Added by Expansion---### centerflag982 - added dickgirl check
	if member.sex == 'male' || member.sex == 'dickgirl':
		member.lube = min(5, member.lube + 2)
###---End Expansion---###
	if member.consent == true || (member.person.traits.find("Likes it rough") >= 0 && member.sens >= 300):
		result = 'good'
	elif member.person.traits.find("Likes it rough") >= 0:
		result = 'average'
	else:
		result = 'bad'
	return [result, effects]

func initiate():
	var text = ''
	text += "[name1] {^eat[s/1] out:lick[s/1]:slurp[s/1] at} [names2] [anus2], stimulating the {^enterance:walls} with [his1] tongue[/s1]."
	return text

func reaction(member):
	var text = ''
	if member.energy == 0:
		text = "[name2] lie[s/2] unconscious, {^trembling:twitching} {^slightly :}as [his2] [anus2] {^respond:react}[s/#2] to {^the stimulation:[names1] tongue[/s1]}."
	#elif member.consent == false:
		#TBD
	elif member.sens < 100:
		text = "[name2] {^show:give}[s/2] little {^response:reaction} to {^the stimulation:[names1] tongue[/s1]}."
	elif member.sens < 400:
		text = "[name2] {^begin:start}[s/2] to {^respond:react} to {^the stimulation:[names1] tongue[/s1]}."
	elif member.sens < 800:
		text = "[name2] {^moans[s/2]:crie[s/2] out} in {^pleasure:arousal:extacy} as [his2] [anus2] [is2] {^stimulated:licked:eaten out}."
	else:
		text = "[names2] body {^trembles:quivers} {^at the slightest movement of [names1] tongue[/s1]:in response to [names1] licking}{^ as [he2] rapidly near[s/2] orgasm: as [he2] approach[es/2] orgasm: as [he2] edge[s/2] toward orgasm:}."
	return text
