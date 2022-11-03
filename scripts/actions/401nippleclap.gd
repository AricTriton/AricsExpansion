
func getname(state = null):
	return "Nipple Clamps"


func reaction(member):
	var text = ''
	if member.energy == 0:
		text = "[name2] lie[s/2] unconscious, {^trembling:twitching} {^slightly :}as [his2] nipples {^respond:react} to {^the stimulation:the clamps' pressure:the clamps' teasing}."
	#elif member.consent == false:
		#TBD
	elif member.sens < 100:
		text = "[name2] {^show:give}[s/2] little {^response:reaction} to [his2] nipples being {^stimulated:teased:pressed:pinched:squeezed}."
	elif member.sens < 400:
		text = "[name2] {^begin:start}[s/2] to {^respond:react} as [his2] nipples are {^stimulated:teased:pressed:pinched:squeezed}."
	elif member.sens < 800:
		text = "[name2] {^moan[s/2]:cr[ies/y2] out} in {^pleasure:arousal:ecstasy} as [his2] nipples are {^stimulated:teased:pressed:pinched:squeezed}."
	else:
		text = "[names2] body {^trembles:quivers} {^with the slightest pressure of the clamps:in response to the clamps' pressure}{^ as [he2] rapidly near[s/2] orgasm: as [he2] approach[es/2] orgasm: as [he2] edge[s/2] toward orgasm:}."
	return text
