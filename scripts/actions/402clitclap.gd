
func getname(state = null):
	return "Clit Clamp"


func requirements():
	var valid = true
	for i in takers:
#		if i.acc6 != null:
#			valid = false
		if i.person.vagina == 'none':
			valid = false
	if takers.size() != 1 || givers.size() != 1:
		valid = false
	return valid


func reaction(member):
	var text = ''
	if member.energy == 0:
		text = "[name2] lie[s/2] unconscious, {^trembling:twitching} {^slightly :}as [his2] clit {^respond[s/2]:react[s/2]} to {^the stimulation:the clamp's pressure:the clamp's teasing}."
	#elif member.consent == false:
		#TBD
	elif member.sens < 100:
		text = "[name2] {^show:give}[s/2] little {^response:reaction} to [his2] clit being {^stimulated:teased:pressed:pinched:squeezed}."
	elif member.sens < 400:
		text = "[name2] {^begin:start}[s/2] to {^respond:react} as [his2] clit is {^stimulated:teased:pressed:pinched:squeezed}."
	elif member.sens < 800:
		text = "[name2] {^moan[s/2]:cr[ies/y2] out} in {^pleasure:arousal:ecstasy} as [his2] clit is {^stimulated:teased:pressed:pinched:squeezed}."
	else:
		text = "[names2] body {^trembles:quivers} {^with the slightest pressure of the clamp:in response to the clamp's pressure}{^ as [he2] rapidly near[s/2] orgasm: as [he2] approach[es/2] orgasm: as [he2] edge[s/2] toward orgasm:}."
	return text
