# TODO: Consider artificially enhanced tongues.

func isRough(member):
	return member.person.traits.has("Likes it rough") || member.person.traits.has("Sadist") || member.person.traits.has("Dominant")


func likesRough(member):
	return member.person.traits.has("Likes it rough") || member.person.traits.has("Masochist") || member.person.traits.has("Submissive")


func canSpeak(member):
	return !member.person.traits.has("Mute") && !member.person.rules.silence


# Return true if the given member was embarrassed by her chest size. Grown females with low
# confidence and small tits can feel embarrassed, and suffer a penalty.
func isEmbarrassed(member):
	# Return true if member: has not already been embarrassed AND is female AND is teen or older AND has small tits AND has low confidence AND failed confidence check.
	return member.embarrassedStatus == 0 && member.person.sex == "female" && member.person.age != "child" && member.person.titssize in ['masculine','flat','small'] && member.person.conf <= 40 && rand_range(-10, 45) > member.person.conf

# --------------------------------------------------------------------------------------------------

var act_shared_initialLowSens = [
	"[name1] {^quickly :slowly :expertly :}tease[s/1] [names2] nipples with the tips of [his1] tongues",
	"[name1] {^rapidly :repeatedly :expertly :}flick[s/1] [names2] nipples with [his1] tongues",
	"[name1] {^gently:softly:lovingly} squeeze[s/1] [names2] nipples with [his1] {^soft :}lips"
]

var act_shared_initialHighSens = [
	"[name1] {^lick[s/1]:suck[s/1]:suckle[s/1]:kiss[es/1]} [names2] nipples{^ firmly: teasingly: thoroughly:}",
	"[name1] bite[s/1] [names2] nipples {^gently:lightly}",
	"[name1] nibble[s/1] {^gently:lightly} at [names2] nipples"
]

var act_shared_final = [
	", sharing {^a happy:an excited} {^look:glance} as [he1] also share[s/1] [names2] nipples.",
	", {^enjoying:pleasuring:playing with} one nipple each.",
	", ensuring that all of [his2] nipples are {^stimulated:teased:played with}.",
	", happy to share [his2] delicious treats."
]

# Two givers suck one nipple each. This presumes there are several givers and one taker.
func getSharedAction():
	if takers[0].sens < 500:
		return globals.randomitemfromarray(act_shared_initialLowSens) + globals.randomitemfromarray(act_shared_final)
	return globals.randomitemfromarray(act_shared_initialHighSens) + globals.randomitemfromarray(act_shared_final)

# --------------------------------------------------------------------------------------------------

var cont_shared_initial = [
	"[name1] {^keep[s/1] sharing:continue[s/1] to share} [names2] nipples",
	"[name1] {^keep[s/1] enjoying:continue[s/1] to play with} [names2] nipples together"
]

var cont_shared_finalLowSens = [
	", {^quickly :slowly :expertly :}teasing them with the tips of [his1] tongues",
	", {^rapidly :repeatedly :expertly :}flicking them with [his1] tongues",
	", {^gently:softly:lovingly} squeezing them with [his1] {^soft :}lips"
]

var cont_shared_finalHighSens = [
	", {^licking:sucking:suckling:kissing} them {^firmly:teasingly:thoroughly}.",
	", {^biting:nibbling} them {^gently:lightly}."
]

# Two givers keep sucking one nipple each. This presumes there are several givers and one taker.
func getSharedContinuation(givers, takers):
	if takers[0].sens < 500:
		return globals.randomitemfromarray(cont_shared_initial) + globals.randomitemfromarray(cont_shared_finalLowSens)
	return globals.randomitemfromarray(cont_shared_initial) + globals.randomitemfromarray(cont_shared_finalHighSens)

# --------------------------------------------------------------------------------------------------

var act_careless_initial = [
	"[name1] {^lick[s/1]:suck[s/1]:suckle[s/1]:kiss[es/1]} [names2] nipples{^ firmly: playfully: thoroughly: tenderly but firmly:}",
	"[name1] bite[s/1] [names2] nipples{^ playfully: firmly: possessively:}",
	"[name1] nibble[s/1] {^playfully:firmly:possessively:vigorously} at [names2] nipples",
	"[name1] gnaw[s/1] [names2] nipples{^ playfully: firmly: possessively: vigorously:}"
]

var act_careless_final = [
	".",
	", growling {^lovingly:passionately:hungrily} at [him2].",
	", purring with {^contentment:appreciation} as [he1] move[s/1] from one to the other.",
	", simultaneously {^flicking:whipping:tickling:polishing} the tip of [his2] nipples with [his1] rough tongue.",
	", while {^teasing:stimulating:flicking:whipping:polishing} the tip with [his1] rough tongue.",
	", then let[s/1] [his1] mouth {^swallow:engulf} [his2] nipples and aureolae, munching {^slowly:lovingly:passionately:hungrily} on each of them in turn."
]

# A careless giver does what he wants, regardless of taker's excitement. The action can be slightly
# rough. This presumes there is only one giver and one taker.
func getCarelessAction():
	return globals.randomitemfromarray(act_careless_initial) + globals.randomitemfromarray(act_careless_final)

# --------------------------------------------------------------------------------------------------

var cont_careless_initial = [
	"[name1] keep[s/1] {^licking:biting:nibbling at:gnawing} [names2] nipples",
	"[name1] continue[s/1] to {^lick:bite:nibble at:gnaw} [names2] nipples"
]

var cont_careless_final = [
	".",
	", growling {^lovingly:passionately:hungrily} at [him2].",
	", purring with {^contentment:appreciation} as [he1] move[s/1] from one to the other.",
	", munching {^slowly:lovingly:passionately:hungrily} on each of them in turn."
]

# A careless giver continues to do what he wants, regardless of taker's excitement. The action can
# be slightly rough. This presumes there is only one giver and one taker.
func getCarelessContinuation(givers, takers):
	return globals.randomitemfromarray(cont_careless_initial) + globals.randomitemfromarray(cont_careless_final)

# --------------------------------------------------------------------------------------------------

var act_rough_initialLowSens = [
	"[name1] {^firmly :carefully :expertly :}tease[s/1] [names2] nipples with the tip of [his1] tongue",
	"[name1] {^rapidly :insistently :expertly :}flick[s/1] [names2] nipples with [his1] tongue",
	"[name1] {^gently:firmly:possesively} squeeze[s/1] [names2] nipples with [his1] {^firm :strong :}lips"
]

var act_rough_finalLowSens = [
	".",
	", giving [him2] {^a commanding:an encouraging:a loving:a hungry} {^look:glance} as [he1] switch[es/1] from one to the other.",
	", then let[s/1] [his1] tongue circle [his2] nipples {^playfully:firmly:a few times:appreciatively} before [he1] make[s/1] [his1] way to the other side.",
	", then let[s/1] [his1] tongue play around the base of [his2] nipples for a moment, before moving across to the other side."
]

var act_rough_actionsLowSens = [
	"[name1] {^[is1] about to:pretend[s/1] to} bite {^down on :down hard on :}[names2] nipple, but stop[s/1], {^looking:glancing} up at [him2] with a {^wolfish:hungry} grin.",
	"[name1] {^bare[s/1] [his1] teeth as if to:looks like [he1] want[s/1] to} bite {^down on :down hard on :}[names2] nipple, but stop[s/1], {^looking:glancing} up at [him2] with a {^wolfish:hungry} grin.",
	"[name1] look[s/1] like [he1] want[s/1] to bite [names2] nipples, but stop[s/1]."
]

var act_rough_initialHighSens = [
	"[name1] {^lick[s/1]:suck[s/1]:suckle[s/1]:kiss[es/1]} [names2] nipples{^ firmly: hard: thoroughly:}",
	"[name1] bite[s/1] [names2] nipples {^playfully:firmly:possessively:vigorously:with great relish}",
	"[name1] nibble[s/1] {^playfully:firmly:possessively:vigorously:with great relish} at [names2] nipples"
]

var act_rough_finalHighSens = [
	".",
	", looking {^lovingly:passionately:hungrily} at [him2].",
	", purring with {^contentment:appreciation} as [he1] move[s/1] from one to the other.",
	", simultaneously {^flicking:whipping:tickling:polishing} the tip of [his2] nipples with [his1] tongue.",
	", while {^teasing:stimulating:flicking:whipping:polishing} the tip with [his1] tongue.",
	", then let[s/1] [his1] mouth {^swallow:engulf} [his2] nipples and aureolae, munching {^slowly:lovingly:passionately:hungrily} on each of them in turn."
]

var act_rough_actionsHighSens = [
	"[name1] pretend[s/1] to bite [names2] nipple hard, but in the event only nibble[s/1] it gently{^, wearing a wolfish grin:}.",
	"[name1] pinch[es/1] [names2] nipple with [his1] lips - softly at first, then harder, {^looking:glancing} up at [him2] to see if it hurts yet.",
	"[name1] clamp[s/1] [names2] nipple between [his1] lips, then shake[s/1] [his1] head, tugging and pulling it sideways. Then [he1] do[es/1] the same thing to the other one."
]

# The giver adapts slightly to the taker's excitement. The action can be rough. This presumes there
# is only one giver and one taker.
func getRoughAction():
	if takers[0].sens < 500:
		if randf() < 0.15:
			return globals.randomitemfromarray(act_rough_actionsLowSens)
		return globals.randomitemfromarray(act_rough_initialLowSens) + globals.randomitemfromarray(act_rough_finalLowSens)
	if randf() < 0.15:
		return globals.randomitemfromarray(act_rough_actionsHighSens)
	return globals.randomitemfromarray(act_rough_initialHighSens) + globals.randomitemfromarray(act_rough_finalHighSens)

# --------------------------------------------------------------------------------------------------

var cont_rough_initialLowSens = [
	"[name1] keep[s/1] {^teasing:flicking:licking:nibbling at} [names2] nipples",
	"[name1] continue[s/1] to {^tease:flick:lick:nibble at} [names2] nipples"
]

var cont_rough_finalLowSens = [
	".",
	", giving [him2] {^a commanding:an encouraging:a loving:a hungry} {^look:glance} as [he1] switch[es/1] from one to the other.",
	", letting [his1] tongue circle them {^playfully:firmly:repeatedly:appreciatively} before making [his1] way to the other side.",
	", letting [his1] tongue play around the base for a moment before moving across to the other side."
]

var cont_rough_initialHighSens = [
	"[name1] keep[s/1] {^licking:sucking:suckling:kissing:biting:nibbling at} [names2] nipples",
	"[name1] continue[s/1] to {^lick:suck:suckle:kiss:bite:nibble at} [names2] nipples"
]

var cont_rough_finalHighSens = [
	".",
	", purring with {^contentment:appreciation} as [he1] move[s/1] from one to the other.",
	", while {^teasing:stimulating:flicking:whipping:polishing} their tips with [his1] tongue.",
	", munching {^slowly:lovingly:passionately:hungrily} on each of them in turn."
]

# The giver adapts slightly to the taker's excitement. The action can be rough. This presumes there
# is only one giver and one taker.
func getRoughContinuation(givers, takers):
	if takers[0].sens < 500:
		return globals.randomitemfromarray(cont_rough_initialLowSens) + globals.randomitemfromarray(cont_rough_finalLowSens)
	return globals.randomitemfromarray(cont_rough_initialHighSens) + globals.randomitemfromarray(cont_rough_finalHighSens)

# --------------------------------------------------------------------------------------------------

var act_gentle_initialLowSens = [
	"[name1] {^quickly :slowly :expertly :}tease[s/1] [names2] nipples with the tip of [his1] tongue",
	"[name1] {^rapidly :repeatedly :expertly :}flick[s/1] [names2] nipples with [his1] tongue",
	"[name1] {^gently:softly:lovingly} squeeze[s/1] [names2] nipples with [his1] {^soft :}lips"
]

var act_gentle_finalLowSens = [
	".",
	", giving [him2] a quick wink.",
	", giving [him2] a {^reassuring:comforting:loving} {^look:glance} as [he1] switch[es/1] from one to the other.",
	", then let[s/1] [his1] tongue circle [his2] nipples {^playfully:randomly:a few times:appreciatively} before [he1] make[s/1] [his1] way to the other side.",
	", then let[s/1] [his1] tongue play around the base of [his2] nipples for a moment, before moving across to the other side."
]

var act_gentle_initialHighSens = [
	"[name1] {^lick[s/1]:suck[s/1]:suckle[s/1]:kiss[es/1]} [names2] nipples{^ firmly: teasingly: thoroughly:}",
	"[name1] bite[s/1] [names2] nipples {^gently:lightly}",
	"[name1] nibble[s/1] {^gently:lightly} at [names2] nipples"
]

var act_gentle_finalHighSens = [
	".",
	", looking {^lovingly:passionately:hungrily} at [him2].",
	", purring softly with {^contentment:appreciation} as [he1] move[s/1] from one to the other.",
	", simultaneously {^flicking:tickling:teasing} the tip of [his2] nipples with [his1] tongue.",
	", while {^teasing:stimulating:flicking} the tip with [his1] tongue.",
	", then let[s/1] [his1] mouth {^swallow:engulf} [his2] nipples and aureolae, munching {^gently:lovingly:passionately} on each of them in turn."
]

var act_gentle_action = "[name1] worship[s/1] [names2] nipples with [his1] tongue, then look[s/1] up, as if to say {^how much [he1] love[s/1] them:how pretty they are}."

# The giver adapts slightly to the taker's excitement. The action is gentle and loving. This
# presumes there is only one giver and one taker.
func getGentleAction():
	if randf() < 0.05:
		return act_gentle_action
	if takers[0].sens < 500:
		return globals.randomitemfromarray(act_gentle_initialLowSens) + globals.randomitemfromarray(act_gentle_finalLowSens)
	return globals.randomitemfromarray(act_gentle_initialHighSens) + globals.randomitemfromarray(act_gentle_finalHighSens)

# --------------------------------------------------------------------------------------------------

var cont_gentle_initialLowSens = [
	"[name1] keep[s/1] {^teasing:flicking:licking} [names2] nipples",
	"[name1] continue[s/1] to {^tease:flick:lick} [names2] nipples"
]

var cont_gentle_finalLowSens = [
	".",
	", giving [him2] a {^reassuring:comforting:loving} {^look:glance} as [he1] switch[es/1] from one to the other.",
	", letting [his1] tongue circle them {^playfully:randomly:repeatedly:appreciatively} before making [his1] way to the other side.",
	", letting [his1] tongue play around the base for a moment before moving across to the other side."
]

var cont_gentle_initialHighSens = [
	"[name1] keep[s/1] {^licking:sucking:suckling:kissing:nibbling gently at} [names2] nipples",
	"[name1] continue[s/1] to {^lick:suck:suckle:kiss:nibble gently at} [names2] nipples"
]

var cont_gentle_finalHighSens = [
	".",
	", purring softly with {^contentment:appreciation} as [he1] move[s/1] from one to the other.",
	", while {^teasing:stimulating:flicking} their tips with [his1] tongue.",
	", munching {^gently:lovingly:passionately} on each of them in turn."
]

# The giver adapts slightly to the taker's excitement. The action is gentle and loving. This
# presumes there is only one giver and one taker.
func getGentleContinuation(givers, takers):
	if takers[0].sens < 500:
		return globals.randomitemfromarray(cont_gentle_initialLowSens) + globals.randomitemfromarray(cont_gentle_finalLowSens)
	return globals.randomitemfromarray(cont_gentle_initialHighSens) + globals.randomitemfromarray(cont_gentle_finalHighSens)

# --------------------------------------------------------------------------------------------------
# The givers and takers arrays hold the people that were selected when the action was initiated. The
# currently selected set of givers and takers might have changed since then.
func getongoingdescription(givers, takers):
	if givers.size() > 1:
		return getSharedContinuation(givers, takers)
	if givers[0].person.traits.has("Uncivilized"):
		return getCarelessContinuation(givers, takers)
	if isRough(givers[0]):
		return getRoughContinuation(givers, takers)
	return getGentleContinuation(givers, takers)


# Return true if the action can take place.
# If the taker has more than two nipples, we could allow more givers.
func requirements():
	return (givers.size() == 1 || givers.size() == 2) && (takers.size() == 1)


func getActionResult(member, accepting):
	if member.consent || (accepting && member.sens >= 150):
		return "good"
	if accepting:
		return "average"
	return "bad"


func getGiverResult(member):
	return getActionResult(member, isRough(member))


func getTakerResult(member):
	return getActionResult(member, likesRough(member))


func givereffect(member):
	var result = getGiverResult(member)
	var effects

	# Licking nipples can be a turn-on, but does not give much in the way of physical stimulation.
	if member.sens < 300:
		effects = {sens = 60}
	else:
		effects = {sens = 40}
	return [result, effects]


func takereffect(member):
	var result = getTakerResult(member)
	var effects

	# Foreplay type actions give slightly better effect if the taker is not already excited. If the
	# taker is already aroused, they have lots of other sensations to process. Also, part of the
	# foreplay action's impact is psychological, gearing you up for more to come.
	if member.sens < 100:
		effects = {sens = 170}
	elif member.sens < 300:
		effects = {sens = 150}
	else:
		effects = {sens = 120}

	# Nipple sensitivity varies greatly, but we don't have a stat for this. However, male nipples are
	# assumed to be, on average, less sensitive.
	if member.person.sex == "male":
		effects.sens /= 2
	
	# Observant givers are a little better at sensing what the taker desires at any particular time.
	for giver in givers:
		if giver.person.traits.has("Observant"):
			effects.sens += 10

	# Better results if giver's and taker's tastes match.
	if likesRough(member):
		for giver in givers:
			if isRough(giver):
				effects.sens += 10

	# Penalty if embarrassed.
	if member.embarrassedStatus == 1:
		effects.sens -= 60
		member.embarrassedStatus = 2
	
	return [result, effects]


func initiate():
	if givers.size() > 1:
		return getSharedAction()
	if givers[0].person.traits.has("Uncivilized"):
		return getCarelessAction()
	if isRough(givers[0]):
		return getRoughAction()
	return getGentleAction()


# --------------------------------------------------------------------------------------------------

var react_unconscious_action = "[name2] lie[s/2] unconscious, {^trembling:twitching} {^slightly :}as [his2] nipples {^respond:react} to {^the stimulation:[names1] suckling:[names1] teasing}."

func getUnconsciousReaction(member):
	return react_unconscious_action

# --------------------------------------------------------------------------------------------------

var react_noncon_lowSens = {
	silent = "[name2] stare[s/2] at [name1] with {^undiluted hatred:obvious resentment}.",
	foulMouth = "[name2] stare[s/2] at [name1] with {^undiluted hatred:obvious resentment}, hissing {^a few choice words:a colourful curse}.",
	submissive = "[name2] stare[s/2] at [name1], {^eyes pleading for [him1] not to do this:eyes pleading for mercy:eyes pleading for [him1] to stop:eyes closed in silent recognition of the inevitability of what [he1] is doing:eyes closed in silent acceptance}.",
	passive = "[name2] stare[s/2] at [name1], {^eyes closed in silent resentment:eyes closed in silent hatred:eyes squeezed shut in quiet rejection}.",
	male = "[name2] stare[s/2] at [name1], a look of {^hatred:resentment} in [his2] eyes as [he2] grumble[s/2] a curse under [his2] breath.",
	female = "[name2] look[s/2] at [name1] with {^resentment:obvious resentment}, muttering a soft curse under [his2] breath."
}

var react_noncon_medSens = "[name2] {^grit[s/2] [his2] teeth and close[s/2] [his2] eyes:writhe[s/2] and squirm[s/2] in an attempt to get away}."

var react_noncon_highSens = "[name2] squeeze[s/2] [his2] eyes shut and {^moan[s/2] involuntarily:can't help but moan:gasp[s/2] at the intense sensation:tremble[s/2] at the intense sensation}."

func getNonconReaction(member):
	if member.sens < 300:
		if !canSpeak(member):
			return react_noncon_lowSens.silent
		if member.person.traits.has("Foul Mouth"):
			return react_noncon_lowSens.foulMouth
		if member.person.traits.has("Submissive"):
			return react_noncon_lowSens.submissive
		if member.person.traits.has("Passive"):
			return react_noncon_lowSens.passive
		if member.person.sex == 'male':
			return react_noncon_lowSens.male
		return react_noncon_lowSens.female
	if member.sens < 800:
		return react_noncon_medSens
	return react_noncon_highSens

# --------------------------------------------------------------------------------------------------

var react_dom_lowSens = [
	"[name2] {^purr[s/2]:moan[s/2]} {^softly:happily:encouragingly} at the sensation.",
	"[name2] {^purr[s/2]:moan[s/2]} {^softly:happily:encouragingly} at the sensation, {^whispering:muttering:saying}: [color=yellow]{^Yes! Do that some more!:Go on, [dynamic]! Don't stop!}[/color]",
	"[name2] {^purr[s/2]:moan[s/2]} {^softly:happily:encouragingly} at the sensation, {^whispering:muttering:saying}: [color=yellow]{^That works. Do continue!:Yes, that's good. Keep going, [dynamic]!}[/color]"
]

var react_dom_medSens = [
	"[name2] {^moan[s/2]:purr[s/2]:sigh[s/2]} in {^pleasure:arousal:ecstasy}.",
	"[name2] {^moan[s/2]:purr[s/2]:sigh[s/2]} in {^pleasure:arousal:ecstasy}, {^whispering:muttering:crying}: [color=yellow]{^Yesss!:[dynamic]:Ooh, yes! [dynamic]:I like that!}[/color]",
	"[name2] {^moan[s/2]:purr[s/2]:sigh[s/2]} in {^pleasure:arousal:ecstasy}, {^whispering:muttering:crying}: [color=yellow]{^Ooh, I like that!:That's lovely!:Don't stop! [dynamic]}[/color]"
]

var react_dom_highSens = "[name2] {^tremble[s/2]:quiver[s/2]:shiver[s/2]} {^at the slightest touch:in response:ecstatically} {^as [he2] rapidly near[s/2] orgasm:as [he2] approach[es/2] orgasm:as [he2] edge[s/2] toward orgasm:}."

# Assumes that the member is not Mute, and is permitted to speak.
func getDomReaction(member):
	var text

	if member.sens < 300:
		if givers.size() > 1:
			text = "both of you"
		elif givers[0].person.sex == "male":
			text = "boy"
		else:
			text = "girl"
		return globals.randomitemfromarray(react_dom_lowSens).replace("[dynamic]", text)
	if member.sens < 800:
		if givers.size() > 1:
			text = "Keep going, both of you!"
		elif givers[0].person.sex == "male":
			text = "Good boy!"
		else:
			text = "Good girl!"
		return globals.randomitemfromarray(react_dom_medSens).replace("[dynamic]", text)
	return react_dom_highSens

# --------------------------------------------------------------------------------------------------

var react_norm_embarrassed = "[name2] {^gasp[s/2] and blush[es/2]:moan[s/2] and flush[es/2]:cringe[s/2]}{^ as [his2] nipples are stimulated: as [his2] nipples are teased}, {^look[s/2]:glance[s/2]} {^down :}at [his2] [dynamic] and {^whisper[s/2]:say[s/2] softly:mutter[s/2]}: [color=yellow]{^They're a bit small, aren't they?:Are they too small, you think?:Sorry! I wish they were bigger.}[/color]"

var react_norm_lowSens = [
	"[name2] {^gasp[s/2] and shiver[s/2]:draw[s/2] [his2] breath sharply}{^ as [his2] nipples are stimulated: as [his2] nipples are teased: at the sensation:}.",
	"[name2] purr[s/2] {^softly:happily:encouragingly} at the sensation{^, [his2] eyes lighting up with desire::}.",
	"[name2] draw[s/2] a soft breath, and looks at [name1] in {^mounting :}anticipation.",
	"[name2] {^gasp[s/2]:draw[s/2] [his2] breath sharply}, whispering: [color=yellow]{^Bite me!:Yes! Bite me there!:Yes! Squeeze them hard!:Harder! Please!}[/color]",
	"[name2] {^gasp[s/2]:draw[s/2] [his2] breath sharply}, whispering: [color=yellow]{^Ooh, fuck! I like that!:Damn! You really know how to do that.:Bloody hell, that's nice!}[/color]",
	"[name2] {^gasp[s/2] and shiver[s/2]:draw[s/2] [his2] breath sharply}, whispering: [color=yellow]Take me! {^Please!:I'm all yours.}[/color]"
]

var react_norm_medSens = [
	"[name2] {^moan[s/2]:purr[s/2]:sigh[s/2]} in {^pleasure:arousal:ecstasy} as [his2] nipples are {^stimulated:teased:played with}.",
	"[name2] moan[s/2] a soft whisper of encouragement{^ under [his2] breath: at [name1]:}.",
	"[name2] {^moan[s/2]:purr[s/2]:sigh[s/2]} in {^pleasure:arousal:ecstasy}, whispering: [color=yellow]{^Bite me!:Yes! Bite me there!:Yes! Squeeze them hard!:Harder! Please!}[/color]",
	"[name2] {^moan[s/2]:purr[s/2]:sigh[s/2]} in {^pleasure:arousal:ecstasy}, whispering: [color=yellow]{^Ooh, fuck! I love it!:Ooh, that's so fucking good!:Bloody hell, that feels good!}[/color]"
]

var react_norm_highSens = "[name2] {^tremble[s/2]:quiver[s/2]:shiver[s/2]} {^at the slightest touch:in response:ecstatically} {^as [he2] rapidly near[s/2] orgasm:as [he2] approach[es/2] orgasm:as [he2] edge[s/2] toward orgasm:}."

func getNormalReaction(member):
	var canSpeak
	var text
	var possibleIndices
	var selectedIndex

	if member.sens < 300:
		canSpeak = canSpeak(member)
		if canSpeak && isEmbarrassed(member):
			member.embarrassedStatus = 1
			if member.person.titssize == "small":
				text = "{^rather small breasts:tiny breasts:embarrasingly small breasts:tiny mounds:cute little mounds}"
			else:
				text = "{^almost flat chest:barely visible mounds:girlish breast buds:budding breasts}"
			return react_norm_embarrassed.replace("[dynamic]", text)

		possibleIndices = [0, 1, 2]
		if canSpeak:
			if likesRough(member):
				possibleIndices.append(3)
			if member.person.traits.has("Foul Mouth"):
				possibleIndices.append(4)
			if member.person.traits.has("Submissive"):
				possibleIndices.append(5)
		selectedIndex = globals.randomitemfromarray(possibleIndices)
		return react_norm_lowSens[selectedIndex]

	if member.sens < 800:
		possibleIndices = [0]
		if canSpeak(member):
			possibleIndices.append(1)
			if likesRough(member):
				possibleIndices.append(2)
			if member.person.traits.has("Foul Mouth"):
				possibleIndices.append(3)
		selectedIndex = globals.randomitemfromarray(possibleIndices)
		return react_norm_medSens[selectedIndex]

	return react_norm_highSens

# --------------------------------------------------------------------------------------------------

func reaction(member):
	if member.energy <= 0:
		return getUnconsciousReaction(member)
	if !member.consent:
		return getNonconReaction(member)
	if member.person.traits.has("Dominant") && canSpeak(member):
		return getDomReaction(member)
	return getNormalReaction(member)
