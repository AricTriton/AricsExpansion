
func getslavedescription(tempperson, mode = 'default'):
	showmode = mode
	person = tempperson
	###---Added by Expansion---### Person Expanded
	globals.expansion.updatePerson(person)
	###---Expansion End---###
	var text = basics() + features() + genitals() + mods() + tattoo() + piercing() + onceperdayConvos()
	if person.customdesc != '':
		text += '\n\n' + person.customdesc
	if person == globals.player:
		text = person.dictionaryplayerplus(person.dictionaryplayer(text))
	else:
		text = person.dictionary(text)

	if text.find('[furcolor]'):
		text = text.replace('[furcolor]', getdescription('furcolor'))


	return text

###---Added by Expansion---### Once Per Day Notifications
func onceperdayConvos():
	var text = '\n'
	if globals.expansionsettings.show_onceperday_notification == true && person != globals.player:
		text += "\n[center][color=#d1b970]---Once Per Day Talk Subjects Still Available Today---[/color][/center]"
		#Consent
		if !person.dailytalk.has('consentparty') && person.consentexp.party == false:
			text += "\n[color=aqua]Ask for $His Consent to Fight alongside Me[/color]"
		#Sexual with You
		if !person.dailytalk.has('consent') && person.consent == false:
			text += "\n[color=aqua]Ask for $His Consent to Fuck Me[/color]"
		if person.consent == true && !person.dailytalk.has('consentpregnant') && (person.preg.has_womb == true && globals.player.penis != "none") && person.consentexp.pregnancy == false:
			text += "\n[color=aqua]Ask for $His Consent to Be Impregnated By You[/color]"
		#Pregnancy with Others
		if person.penis != "none" && !person.dailytalk.has('consentstud') && person.consentexp.stud == false:
			text += "\n[color=aqua]Ask for $His Consent to Impregnate Your Other Slaves[/color]"
		if !person.dailytalk.has('consentbreeder') && person.consentexp.breeder == false:
			text += "\n[color=aqua]Ask for $His Consent to be Bred as Be Impregnated by Someone Else[/color]"
		#Sexual with Family
		if !person.dailytalk.has('consentincest') && person.consentexp.incest == false:
			text += "\n[color=aqua]Ask for $His Consent to Fuck Family Members[/color]"
		if person.consentexp.incest == true && (person.consentexp.breeder == true || person.consentexp.stud == true) && !person.dailytalk.has('consentincestbreeder') && person.consentexp.incestbreeder == false:
			text += "\n[color=aqua]Ask for $His Consent to be Bred by Family Members[/color]"
		#Farm
		if globals.state.farm >= 3 && (person.consentexp.breeder == true || person.consentexp.stud == true) && !person.dailytalk.has('consentlivestock') && person.consentexp.livestock == false:
			text += "\n[color=aqua]Ask for $His Consent to be Treated as Livestock on the Farm[/color]"
		#Sexuality
		if !person.dailytalk.has('talksexuality') and !person.knowledge.has('sexuality'):
			text += "\n[color=aqua]Ask about $His Sexuality[/color]"
		if !person.dailytalk.has('talkfetishes'):
			text += "\n[color=aqua]Learn, Encourage, or Discourage $His Fetishes[/color]"
		#The Number of Children
		if !person.knowledge.has('desiredoffspring') && !person.dailytalk.has('desiredoffspring'):
			text += "\n[color=aqua]Ask How Many Kids $He Wants[/color]"
		elif person.knowledge.has('desiredoffspring') && !person.dailytalk.has('desiredoffspring'):
			text += "\n[color=aqua]Encourage or Discourage the Number of Kids $He Wants[/color]"
		#Crystal
		if !person.dailytalk.has('crystalresearch') && globals.state.thecrystal.power <= person.smaf - 1:
			text += "\n[color=aqua]Attempt to Research the Crystal[/color]: $His [color=aqua]Wit[/color] equates to $his chance of success to not accidentally make the [color=aqua]Crystal[/color] more [color=aqua]Powerful[/color] and harder to [color=aqua]Research[/color]."
			if globals.state.thecrystal.mode == "dark":
				text += "\n[color=red]Extreme Failure may result in $his being consumed by the [color=aqua]Crystal[/color] to sate its hunger.[/color]"
		
	return text

###---End Expansion---###

func features():
	var text = '\n'
	if showmode == 'default':
		text += '[url=appearance][color=#d1b970]Appearance:[/color][/url] '
	###---Added by Expansion---### Person Expanded
	if globals.state.descriptsettings.appearance == true || showmode != 'default':
		text = "\n" + text
		#Face
		text += "\n[color=#d1b970]Head:[/color]\n" + getdescription('hairlength') + getdescription('hairstyle') + getdescription("eyecolor") + getdescription("eyeshape") + getdescription('horns') + getdescription('ears') + getdescription('lips')
		text += "\n" + globals.expansion.getCheeksDescription(person) + globals.expansion.getCumCoatedDescription(person,'face')
		#Body
		text += "\n[color=#d1b970]Body:[/color]\n" + getdescription('skin') + getdescription("skincov") + getdescription("wings") + getdescription("tail") + getdescription("height") + getdescription("asssize")
		text += "[color=green]" + globals.expansion.getSwollenDescription(person,true) + "\n" + globals.expansion.getCumCoatedDescription(person,'body') + "[/color]"
	###---Expansion End---###
	else:
		text += "Omitted. "
	return text

func genitals():
	###---Added by Expansion---### Person Expanded
	var text = '\n'
	var capacity = globals.expansion.getCapacity(person, person.vagina) + globals.expansion.getCapacity(person, person.asshole)
	if showmode == 'default':
		text += '[url=genitals][color=#d1b970]Privates:[/color][/url] '
	if globals.state.descriptsettings.genitals == true || showmode != 'default':
		if person.titssize != "masculine":
			text += "\n[color=#d1b970]Breasts:[/color]"
		else:
			text += "\n[color=#d1b970]Chest:[/color]"
		if person.exposed.chest == true:
			text += "\n" + getdescription("titssize") + gettitsextra()
			if person.lactation == true:
				text += "\n$His nipples are incredibly hard and occassionally sput streams of milk when $he moves or breathes heavily. [color=green]$He is obviously lactating.[/color]"
		elif person == globals.player:
			text += "\n" + getdescription("titssize") + gettitsextra()
			if person.lactation == true:
				text += "\nYour nipples are incredibly hard and occassionally sput streams of milk when you move or breathe heavily. [color=green]You are obviously lactating.[/color]"
		else:
			text += '\n$He is wearing a [color=red]shirt[/color] at the moment, obscuring the details of $his ' + str(globals.expansion.getChest(person)) + ' from your ' + str(globals.randomitemfromarray(['eyes','gaze','inspection'])) + '.'
			if person.lactation == true:
				text += "\n$His clothes have large " + str(globals.randomitemfromarray(['wet','gloopy','moist','damp','dark'])) + " spots soaking $his " + str(globals.expansion.getChest(person)) + ", trailing down towards $his stomach. [color=green]$He is obviously lactating.[/color]"
		text += lowergenitals() + " " 
		###---Expansion End---###
	else:
		text += "Omitted. "

	return text

func lowergenitals():
	var text = ''
	###---Added by Expansion---### Person Expanded
	var vagcapacity = globals.expansion.getCapacity(person, person.vagina)
	var asscapacity = globals.expansion.getCapacity(person, person.asshole)
	if person.exposed.genitals == true && person != globals.player:
		if person.vagina != 'none':
			text += "\n\n[color=#d1b970]Vagina:[/color]\n"
			if person.vagvirgin == true:
				text += ' $He spreads $his legs open to show you $his tight, [color=green]virgin ' + str(globals.expansion.namePussy()) + '[/color]. '
			else:
				text += ' $He spreads $his legs open to show you ' + getdescription('vagina')
			if person.cum.pussy > 0:
				text += " As $his legs are spread open, you notice a little [color=aqua]" +str(globals.expansion.nameCum())+"[/color] slip out of $his [color=aqua]" + str(globals.expansion.namePussy()) + "[/color]. "
			if person.cum.pussy > vagcapacity:
				text += "" + globals.expansion.vagOverload(person) + "\n"
		if person.penis != 'none':
			text += "\n[color=#d1b970]Penis:[/color]\n"
			var temp = person.penistype + '_' + person.penis
			if newpenisdescription.has(temp):
				text += " " + newpenisdescription[temp]
		if person.balls != 'none':
			text += "\n[color=#d1b970]Balls:[/color]\n"
			text += getdescription('balls')
			text += "$He produces [color=aqua]" + str(person.pregexp.cumprod) + "oz[/color] of [color=aqua]" +str(globals.expansion.nameCum())+ "[/color] per ejaculation. "
	elif person != globals.player:
		text += ' $His crotch is [color=red]clothed[/color] and [color=red]covered[/color] at the moment, obscuring the details of $his ' + str(globals.expansion.getGenitals(person)) + ' from your ' + str(globals.randomitemfromarray(['eyes','gaze','inspection'])) + '.'
		if person.cum.pussy > vagcapacity:
			text += "\nYou " + str(globals.randomitemfromarray(['spot','notice','glance at','see'])) + " a mass of " + str(globals.randomitemfromarray(['wet','gloopy','moist','damp','dark'])) + " spots seeping from $his crotch and sticking to $his " + str(globals.randomitemfromarray(['crotch','thighs','clothing',str(globals.expansion.namePussy())])) + ". " + str(globals.randomitemfromarray(['Did $he piss $himself?','How much is oozing out of $him?','Can $he still feel it pouring out?','Is that why $he is flushed?','Interesting...']))
	if person == globals.player:
		if person.vagina != 'none':
			text += "\n[color=#d1b970]Vagina:[/color]\n"
			text+= ' Between your legs you have '+ getdescription('vagina')
		if person.penis != 'none':
			text += "\n[color=#d1b970]Penis:[/color]\n"
			var temp = person.penistype + '_' + person.penis
			if newpenisdescription.has(temp):
				text += " Your crotch is covered at the moment, but you know what is hiding beneath your clothing. " + newpenisdescription[temp]
		if person.balls != 'none':
			text += "\n[color=#d1b970]Balls:[/color]\n"
			text += getdescription('balls')
			text += "You know that you produce [color=aqua]" + str(globals.player.pregexp.cumprod) + "oz[/color] of [color=aqua]" +str(globals.expansion.nameCum())+ "[/color] per ejaculation. "
	if person.vagina == 'none' && person.penis == 'none' && person.balls == 'none':
		text += " For some reason, $his crotch has no visible genitals. "
	if person.asshole != 'none':
		text += "\n[color=#d1b970]Asshole:[/color]\n"
		if person.exposed.ass == true && person != globals.player:
			if person.assvirgin == true:
				text += 'When requested, $he turns around and bends over when requested to show off $his tight, [color=green]virgin ' + str(globals.expansion.nameAsshole()) + '[/color]. '
			else:
				text += 'When requested, $he turns around and bends over when requested to show off ' + getdescription('asshole')
			if person.cum.ass > 0:
				text += " As $his legs are spread open, you see a little [color=aqua]" +str(globals.expansion.nameCum())+"[/color] slip out of $his [color=aqua]" + str(globals.expansion.nameAsshole()) + "[/color]. "
			if person.cum.ass > asscapacity:
				text += "" + globals.expansion.assOverload(person) + "\n"
		elif person != globals.player:
			text += '$His ' + str(globals.expansion.nameAsshole()) + ' is [color=red]clothed[/color] and [color=red]covered[/color] at the moment, obscuring the details of $his ' + str(globals.expansion.nameAsshole()) + ' from your ' + str(globals.randomitemfromarray(['eyes','gaze','inspection'])) + '.'
		elif person == globals.player:
			text += ' All your life, you have had an ' + str(globals.expansion.nameAsshole()) + ' following you around. It is ' + getdescription('asshole')
		if person.cum.ass > asscapacity:
			text += "\nYou " + str(globals.randomitemfromarray(['spot','notice','glance at','see'])) + " a mass of " + str(globals.randomitemfromarray(['wet','gloopy','moist','damp','dark'])) + " spots seeping from $his " + str(globals.expansion.nameAsshole()) + " and sticking to $his " + str(globals.randomitemfromarray(['ass','thighs','clothing',str(globals.expansion.nameAsshole())])) + ". " + str(globals.randomitemfromarray(['Is it still coming out?','How much is oozing out of $him?','Can $he still feel it pouring out?','Is that why $he is flushed?','Interesting...']))
	text += globals.expansion.getSwollenDescription(person,false)
	###---Expansion End---###
	return text

func entry():
	var text = ''
	if globals.slaves.find(person) >= 0 || globals.player == person || person.fromguild == true || globals.get_tree().get_current_scene().get("makeoverPerson") != null:
		if person.sleep == 'jail':
			text = 'Behind the iron bars you see '
		elif globals.player == person:
			text = 'In the mirror you see '
		else:
			text = 'You see '
		if person.nickname == '':
			text += person.name + ' ' + person.surname + '. '
		else:
			text += person.name + ' "'+person.nickname+'" ' + person.surname + '. '
	else:

		text = 'A tied and bound [color=yellow]$sex[/color] looks at you with fear and hatred. '
	text = text.replace(" .", ".")
	return text

###---Added by Expansion---### Fixed to pull from the New Descriptions instead
func getdescription(value):
	var text
	if newdescriptions.has(value) && newdescriptions[value].has(person[value]):
		text = newdescriptions[value][person[value]]
		text = text.split('|',true)
		text = text[rand_range(0,text.size())]
	elif newdescriptions.has(value) && newdescriptions[value].has('default'):
		text = newdescriptions[value].default
	else:
		text = "[color=red]Error at getting description for " + value + ": " + person[value] + '[/color]. '
	return text
###---End Expansion---###

func getbeauty(justtext = false):
	var calculate
	var text = ''
	var appeal = person.beauty
	var tempappeal = person.beautytemp

	if appeal <= 15:
		calculate = 'ugly'
	elif appeal <= 30:
		calculate = 'boring'
	elif appeal <= 50:
		calculate = 'normal'
	elif appeal <= 70:
		calculate = 'cute'
	elif appeal <= 85:
		calculate = 'pretty'
	else:
		calculate = 'beautiful'

	text = descriptions['beauty'][calculate]
	if justtext == false:
		text += "("
		if tempappeal != 0:
			text += '[color=aqua]'+str(floor(appeal))+'[/color]'
		else:
			text += str(floor(appeal))
		text += ")"
	if justtext == false:
		return text
	else:
		return calculate

###---Added by Expansion---###
func randomitemfromarray(source):
	if source.size() > 0:
		#source[randi() % source.size()] Old
		return source[rand_range(0,source.size())]

func nameTits():
	var text = str(randomitemfromarray(['boobs','breasts','tits','boobs','breasts','tits','knockers','udders']))
	return text

func namePenis():
	var text = str(randomitemfromarray(['penis','cock','member','dick','penis','cock','member','dick']))
	return text

func nameBalls():
	var text = str(randomitemfromarray(['balls','balls','nuts','nutsack','testicles','ballsack']))
	return text

func namePussy():
	var text = str(randomitemfromarray(['pussy','pussy','twat','cunt','cunt','vagina']))
	return text

func nameAsshole():
	var text = str(randomitemfromarray(['butt','bum','bumhole','asshole','ass','butthole','anus','sphincter']))
	return text

func nameAss():
	var text = str(randomitemfromarray(['ass','ass','butt','rump','behind','ass cheeks']))
	return text
###---End Expansion---###

###---Added by Expansion---###
var newpenisdescription = {
	human_micro = '$His [color=yellow]' +str(namePenis())+'[/color] is so ' + str(randomitemfromarray(['incredibly miniscule','microscopic','miniature'])) + ' that it is pitiable.',
	human_tiny = '$He has a ' + str(randomitemfromarray(['extremely small','tiny','itty bitty'])) + '  [color=yellow]' +str(namePenis())+'[/color] dangling below $his groin.',
	human_small = 'Below $his waist dangles a [color=yellow]tiny humanish '+str(namePenis())+'[/color], small enough that it could be called cute. ',
	human_average ='$He has an [color=yellow]ordinary humanish ' +str(namePenis())+'[/color] below $his waist, more than enough to make most men proud. ',
	human_large = 'A [color=yellow]huge humanish ' +str(namePenis())+'[/color] swings heavily from $his groin, big enough to give even the most veteran whore pause. ',
	human_massive ='$He has a thick ' + str(randomitemfromarray(['truly massive','gigantic','magnificent','outrageously big'])) + '  [color=yellow]' +str(namePenis())+'[/color] dangling below his groin that would destroy the average ' + namePussy() + '.',
	canine_micro = '$His slender, canine [color=yellow]' +str(namePenis())+'[/color] is so ' + str(randomitemfromarray(['incredibly miniscule','microscopic','miniature'])) + ' that you can barely see the knot at all.',
	canine_tiny = '$He has a thin, ' + str(randomitemfromarray(['extremely small','tiny','itty bitty'])) + '  canine [color=yellow]' +str(namePenis())+'[/color] dangling barely noticably below $his groin.',
	canine_small = 'A slender, pointed [color=yellow]canine ' +str(namePenis())+'[/color] hangs below $his waist, so small that its knot is barely noticeable. ',
	canine_average = '$He has a knobby, red, [color=yellow]canine ' +str(namePenis())+'[/color] of respectable size below $his waist, which wouldn’t look out of place on a large dog. ',
	canine_large = 'Growing from $his crotch is a [color=yellow]massive canine ' +str(namePenis())+'[/color], red-skinned and sporting a thick knot near the base. ',
	canine_massive = '$He has a slender, ' + str(randomitemfromarray(['truly massive','gigantic','magnificent','outrageously big'])) + ' canine [color=yellow]' +str(namePenis())+'[/color] dangling below his groin that would destroy the average ' + namePussy() + '. The knot alone would make the average girl look pregnant.',
	feline_micro = '$His slender, feline [color=yellow]' +str(namePenis())+'[/color] is so ' + str(randomitemfromarray(['incredibly miniscule','microscopic','miniature'])) + ' that you can barely see the barbs at all.',
	feline_tiny = '$He has a thin, ' + str(randomitemfromarray(['extremely small','tiny','itty bitty'])) + ' feline [color=yellow]' +str(namePenis())+'[/color] dangling barely noticably below $his groin. It is covered in tiny barbs.',
	feline_small = 'A [color=yellow]tiny feline ' +str(namePenis())+'[/color] dangles below $his waist, so small you can barely see the barbs. ',
	feline_average = '$He has a barbed [color=yellow]cat ' +str(namePenis())+'[/color] growing from $his crotch, big enough to rival an average human. ',
	feline_large = 'There is a frighteningly [color=yellow]large feline ' +str(namePenis())+'[/color] hanging between $his thighs, its sizable barbs making it somewhat intimidating. ',
	feline_massive = '$He has a sleek, ' + str(randomitemfromarray(['truly massive','gigantic','magnificent','outrageously big'])) + ' feline [color=yellow]' +str(namePenis())+'[/color] dangling below his groin that would destroy the average ' + namePussy() + '. The barbs would be excruciatingly painful to the unprepared.',
	equine_micro = '$His slender, equine [color=yellow]' +str(namePenis())+'[/color] is so ' + str(randomitemfromarray(['incredibly miniscule','microscopic','miniature'])) + ' that you could reasonably believe $he is a woman and it is $his clit.',
	equine_tiny = '$He has a thin, ' + str(randomitemfromarray(['extremely small','tiny','itty bitty'])) + ' equine [color=yellow]' +str(namePenis())+'[/color] dangling barely noticably below $his groin. It is spotted a variety of colors.',
	equine_small = 'Below $his waist hangs a [color=yellow]smallish equine ' +str(namePenis())+'[/color], which is still respectable compared to the average man. ',
	equine_average= 'A [color=yellow]sizable equine ' +str(namePenis())+'[/color] grows from $his nethers, which, while small on a horse, is still thicker and heavier than the average human tool. ',
	equine_large = 'A [color=yellow]massive equine ' +str(namePenis())+'[/color] hangs heavily below $his waist, its mottled texture not quite matching the rest of $his skin. ',
	equine_massive ='$He has a club-like, ' + str(randomitemfromarray(['truly massive','gigantic','magnificent','outrageously big'])) + ' equine [color=yellow]' +str(namePenis())+'[/color] dangling below $his groin that would destroy the average ' + namePussy() + '. The lumps in the middle could break someone in two.',
}
###---Expansion End---###

#Store descriptions for various body parts. Separate alternative with | sign to make description pick one at random
var newdescriptions = {
	bodyshape = {
		humanoid = '$His body is quite [color=yellow]normal[/color]. ',
		bestial = "$His body resembles a human's, except for some [color=yellow]bestial features[/color] in $his face and body structure. ",
		shortstack = '$His body is rather [color=yellow]petite[/color], about half the size of the average person. ',
		jelly = '$His body is [color=yellow]jelly-like[/color] and partly transparent. ',
		halfbird = '$His body has [color=yellow]wings for arms and avian legs[/color] making everyday tasks difficult. ',
		halfsnake = 'The lower portion of $his body consists of a long-winding [color=yellow]snake’s tail[/color]. ',
		halffish = '$His body is [color=yellow]scaly and sleek[/color], possessing fins and webbed digits. ',
		halfspider = "The lower portion of $his body consists of a [color=yellow]spider's legs and abdomen[/color]. ",
		halfhorse = 'While $his upper body is human, $his lower body is [color=yellow]equine[/color] in nature. ',
		halfsquid = 'The lower portion of $his body consists of a [color=yellow]number of tentacular appendages[/color], similar to those of an octopus. ',
	},
	age = {
		child = '$He looks like a [color=aqua]' + str(randomitemfromarray(['','child','kid','young'])) + ' $sex [/color] that has barely hit puberty. ',
		teen = "$He's a young-looking [color=aqua]" + str(randomitemfromarray(['','teen','young-adult','teenaged'])) + " $sex[/color]. ",
		adult = "$He's a fully-grown [color=aqua]" + str(randomitemfromarray(['adult','specimen of a ',''])) + " $sex[/color]. ",
	},
	beauty = {
		ugly = '$He is rather [color=yellow]unsavory[/color] to look at. ',
		boring = '$His looks are [color=yellow]bland and unimpressive[/color]. ',
		normal = '$He appears to be pretty [color=yellow]average[/color] looking. ',
		cute = '$His looks are quite [color=yellow]cute[/color] and appealing. ',
		pretty = '$He looks unusually [color=yellow]pretty[/color] and attracts some attention. ',
		beautiful = '$He looks exceptionally [color=yellow]beautiful[/color], having no visible flaws and easily evoking envy. ',
	},
	lips = {
		masculine = '$He has thin, narrow [color=aqua]lips[/color] on his face that look rough and [color=aqua]manly[/color]. ',
		thin = '$His [color=aqua]lips[/color] are [color=aqua]' + str(randomitemfromarray(['tiny','thin','narrow'])) + '[/color] and ' + str(randomitemfromarray(['unremarkable','unassuming','unattractive'])) + '. ',
		small = '$His [color=aqua]lips[/color] are [color=aqua]'+ str(randomitemfromarray(['small','little','smaller than average'])) + '[/color]. ',
		average = '$He has [color=aqua]lips[/color] that are [color=aqua]' + str(randomitemfromarray(['nice','very average','average','normal'])) + '[/color]. ',
		big = '$His [color=aqua]lips[/color] are [color=aqua]' + str(randomitemfromarray(['very nice','big','slightly bigger than average'])) + '[/color]. ',
		huge = '$His [color=aqua]' + str(randomitemfromarray(['huge','very big','large','slightly plump'])) + '[/color] [color=aqua]lips[/color] are prominent on $his face. ',
		plump = '$His [color=aqua]' + str(randomitemfromarray(['plump','plush','protruding','swollen'])) + '[/color] [color=aqua]lips[/color] draw the eye just by glancing at $him. ',
		massive = '$He has a pair of [color=aqua]lips[/color] that are [color=aqua]' + str(randomitemfromarray(['massive','awe-inspiring','incredibly puffed-up'])) + '[/color] to the point that a speech impediment is inevitable. ',
		monstrous = '$His [color=aqua]' + str(randomitemfromarray(['monstrous','almost immobile','almost unusable','incredibly swollen'])) + '[/color] [color=aqua]lips[/color] are so large that $he almost is unable to speak as parting them seems strenuous. ',
		facepussy = '$His [color=aqua]' + str(randomitemfromarray(['unnaturaly','immobile','unusable','throbbing'])) + '[/color] [color=aqua]lips[/color] are so large $he is unable to speak any longer. $He no longer has working lips, rather a flushed, moist face-pussy. ',
	},
	hairlength = {
		ear = '$His [color=aqua][haircolor][/color] hair is cut [color=aqua]short[/color]. ',
		neck = '$His [color=aqua][haircolor][/color] hair falls down to just [color=aqua]below $his neck[/color]. ',
		shoulder = '$His wavy [color=aqua][haircolor][/color] hair is [color=aqua]shoulder length[/color]. ',
		waist = '$His gorgeous [color=aqua][haircolor][/color] hair [color=aqua]sways down to $his waist[/color]. ',
		hips = '$His [color=aqua][haircolor][/color] hair cascades down, [color=aqua]reaching $his hips[/color]. ',
	},
	hairstyle = {
		straight = 'It [color=aqua]hangs freely[/color] from $his head. ',
		ponytail = 'It is tied in a [color=aqua]high ponytail[/color]. ',
		twintails = 'It is managed in girly [color=aqua]twin-tails[/color]. ',
		braid = 'It is combed into a single [color=aqua]braid[/color]. ',
		'two braids' : 'It is combed into [color=aqua]two braids[/color]. ',
		bun = "It is tied into a neat [color=aqua]bun[/color]. ",
	},
	eyecolor = {
		default = '$His eyes are [color=aqua][eyecolor][/color]. ',
	},
	eyeshape = {
		normal = "",
		slit = "$He has [color=aqua]vertical, animalistic pupils[/color]. "
	},
	horns = {
		none = '',
		short = 'There is a pair of [color=aqua]tiny, pointed horns[/color] on top of $his head. ',
		'long_straight' : '$He has a pair of [color=aqua]long, bull-like horns[/color]. ',
		curved = 'There are [color=aqua]curved horns[/color] coiling around $his head. ',
	},
	ears = {
		human = '',
		short_furry = '$He has a pair of fluffy, [color=aqua]medium-sized animal-like ears[/color]. ',
		long_pointy_furry = '$He has a pair of fluffy, [color=aqua]lengthy, animal-like ears[/color]. ',
		pointy = '$He has quite long, [color=aqua]pointed[/color] ears. ',
		long_round_furry = '$He has a pair of [color=aqua]standing bunny ears[/color] rising above $his head. ',
		long_droopy_furry = '$He has a pair of [color=aqua]droopy, bunny ears[/color] on $his head. ',
		feathery = "There's a pair of clutched [color=aqua]feathery ears[/color] on the sides of " + '$His head. ',
		fins = '$His ears look like a pair of [color=aqua]fins[/color]. ',
	},
	skin = {
		pale = '$His skin is a [color=aqua]pale[/color] white. ',
		fair = '$His skin is healthy and [color=aqua]fair[/color] color. ',
		olive = '$His skin is of an unusual [color=aqua]olive[/color] tone. ',
		'tan' : '$His skin is a [color=aqua]tanned[/color] bronze color. ',
		brown = '$His skin is a mixed [color=aqua]brown[/color] color. ',
		dark = '$His skin is deep [color=aqua]dark[/color]. ',
		jelly = '$His skin is [color=aqua]semi-transparent and jelly-like[/color]. ',
		blue = '$His skin is dark [color=aqua]blue[/color]. ',
		"pale blue" : '$His skin is [color=aqua]light pale blue[/color]. ',
		green = '$His skin is [color=aqua]green[/color]. ',
		red = '$His skin is bright [color=aqua]red[/color]. ',
		purple = '$His skin is [color=aqua]purple[/color]. ',
		teal = '$His skin is [color=aqua]teal[/color]. ',
	},
	skincov = {
		none = '',
		plants = 'Various leaves and bits of [color=aqua]plant matter[/color] cover parts of $his body. ',
		scales = '$His skin is partly covered with [color=aqua]scales[/color]. ',
		feathers = '$His body is covered in [color=aqua]bird-like feathers[/color] in many places. ',
		full_body_fur = '$His body is covered in thick, soft [color=aqua]fur of [furcolor]',
	},
	furcolor ={ # fur color
		none = '',
		white = 'marble color[/color]. ',
		gray = 'gray color[/color]. ',
		orange_white = 'orange-white pattern[/color]. ',
		black_white = 'black-white pattern[/color]. ',
		black_gray = 'black-gray pattern[/color]. ',
		black = 'jet-black color[/color]. ',
		orange = 'common fox pattern[/color]. ',
		brown = 'light-brown tone[/color]. ',
	},
	#arms = {
	#	scales = '$His' + fastif(person['legs'] == 'scales', ' arms and legs', ' arms') + ' are covered in [color=aqua]scales[/color]. ',
	#	winged = "$His arms closely resemblance a [color=aqua]bird's wings[/color]. ",
	#	webbed = '$His' + fastif(person['legs'] == 'webbed', ' hands and feet', ' hands') + ' have [color=aqua]webbed digits[/color]. ',
	#	fur_covered = '$His' + fastif(person['legs'] == 'fur_covered', ' arms and legs', ' arms') + ' are covered in [color=aqua]fur[/color]. ',
	#},
	wings = {
		none = '',
		feathered_black = 'On $his back, $he has folded, [color=aqua]black, feathery wings[/color]. ',
		feathered_white = 'On $his back, $he has folded, [color=aqua]white, feathery wings[/color]. ',
		feathered_brown = 'On $his back, $he has folded, [color=aqua]brown, feathery wings[/color]. ',
		insect = 'On $his back rests translucent, insect-like [color=aqua]fairy wings[/color]. ',
		gossamer = 'On $his back rests translucent, silky [color=aqua]fairy wings[/color]. ',
		leather_black = 'Hidden on $his back is a pair of bat-like, [color=aqua]black leather wings[/color]. ',
		leather_red = 'Hidden on $his back is a pair of bat-like, [color=aqua]red leather wings[/color]. ',
	},
	tail = {
		none = '',
		cat = 'Below $his waist, you spot a slim [color=aqua]cat tail[/color] covered with fur. ',
		fox = '$He has a large, fluffy [color=aqua]fox tail[/color]. ',
		wolf = "Below $his waist there's a short, fluffy, [color=aqua]wolf tail[/color]. ",
		bunny = '$He has a [color=aqua]small ball of fluff[/color] behind $his rear. ',
		racoon = '$He has a plump, fluffy [color=aqua]raccoon tail[/color]. ',
		scruffy = 'Behind $his back you notice a long tail covered in a thin layer of fur which ends in a [color=aqua]scruffy brush[/color]. ',
		demon = '$He has a long, thin, [color=aqua]demonic tail[/color] ending in a pointed tip. ',
		dragon = 'Trailing somewhat behind $his back is a [color=aqua]scaled tail[/color]. ',
		bird = '$He has a [color=aqua]feathery bird tail[/color] on $his rear. ',
		fish = '$His rear ends in long, sleek [color=aqua]fish tail[/color]. ',
		"snake tail" : '',
		tentacles = '',
		horse = '',
		"spider abdomen" : ''
	},
	height = {
		tiny = '$His stature is [color=aqua]' + str(randomitemfromarray(['extremely small','tiny','itty bitty'])) + '[/color], barely half the size of a normal person. ',
		petite = '$His stature is quite [color=aqua]' + str(randomitemfromarray(['thin and small','petite','little'])) + '[/color]. ',
		short = '$His height is quite [color=aqua]' + str(randomitemfromarray(['short','small','slight'])) + '[/color]. ',
		average = '$He is of [color=aqua]' + str(randomitemfromarray(['average','normal'])) + '[/color] height. ',
		tall = '$He is quite [color=aqua]' + str(randomitemfromarray(['tall','large','big'])) + '[/color] compared to the average members of $his race. ',
		towering = '$He is unusually tall, [color=aqua]' + str(randomitemfromarray(['towering','looming'])) + '[/color] over others. ',
	},
	titssize = {
		masculine = '$His [color=yellow]chest[/color] is of definitive [color=yellow]' + str(randomitemfromarray(['masculine','manly'])) + '[/color] shape. ',
		flat = '$His [color=yellow]chest[/color] is barely visible and [color=yellow]' + str(randomitemfromarray(['flat','nearly nonexistant'])) + '[/color]. ',
		small = '$He has [color=yellow]' + str(randomitemfromarray(['small','tiny','miniscule','perky'])) + '[/color], round [color=yellow]' + str(nameTits()) + '[/color]. ',
		average= '$His nice, [color=yellow]' + str(randomitemfromarray(['average','nice','perky','decent'])) + '[/color] [color=yellow]' + str(nameTits()) + '[/color] are firm and inviting. ',
		big = '$His [color=yellow]' + str(randomitemfromarray(['big','sizable','large'])) + '[/color] [color=yellow]' + str(nameTits()) + '[/color] are pleasantly soft, but still have a nice spring to them. ',
		huge = '$His [color=yellow]' + str(nameTits()) + '[/color] are [color=yellow]' + str(randomitemfromarray(['huge','well developed','enviable','really big'])) + '[/color]. ',
		incredible = '$His [color=yellow]' + str(randomitemfromarray(['voluptuous','rather huge','incredible'])) + '[/color] [color=yellow]'+ str(nameTits()) + '[/color] are mind-blowingly big. ',
		massive = '$His [color=yellow]' + str(randomitemfromarray(['massive','inhuman','watermelon-sized'])) + '[/color] [color=yellow]'+ str(nameTits()) + '[/color] are almost too large for $him to function normally. ',
		gigantic = '$His [color=yellow]' + str(randomitemfromarray(['gigantic','unbelievable','chest encompassing'])) + '[/color] [color=yellow]'+ str(nameTits()) + '[/color] are so large that they impedes $his daily life. ',
		monstrous = '$His [color=yellow]' + str(randomitemfromarray(['monstrous','insanely heavy','pregnant belly sized'])) + '[/color] [color=yellow]'+ str(nameTits()) + ' [/color] are so big that $he can barely walk and has to crawl. ',
		immobilizing = '$His [color=yellow]' + str(randomitemfromarray(['unbelievable','rather huge','incredible'])) + '[/color] [color=yellow]'+ str(nameTits()) + '[/color] are mind-blowingly big. ',
	},
	asssize = {#ass strings
		flat = '$His [color=aqua]' + str(nameAss()) + '[/color] is skinny and [color=aqua]flat[/color]. ',
		small = '$He has a [color=aqua]small[/color], firm [color=aqua]' + str(nameAss()) + '[/color]. ',
		average= '$He has a nice, [color=aqua]pert[/color] [color=aqua]' + str(nameAss()) + '[/color] you could bounce a coin off. ',
		big = '$He has a pleasantly [color=aqua]plump[/color], heart-shaped [color=aqua]' + str(nameAss()) + '[/color] that jiggles enticingly with each step. ',
		huge = '$He has a [color=aqua]huge[/color], attention-grabbing [color=aqua]' + str(nameAss()) + '[/color]. ',
		masculine = '$His [color=aqua]' + str(nameAss()) + '[/color] definitively has a [color=aqua]masculine[/color] shape. ',
	},
	balls = {
		micro = '$His [color=yellow]' + str(nameBalls()) + '[/color] are so [color=yellow]' + str(randomitemfromarray(['microscopic','tiny','little','miniscule'])) + '[/color] that it is almost non-existant. ',
		tiny = '$He has some [color=yellow]' + str(randomitemfromarray(['tiny','little','very small'])) + '[/color] [color=yellow]' + str(nameBalls()) + '[/color] dangling between $his legs. ',
		small = '$He has a pair of [color=yellow]tiny[/color] [color=yellow]' + str(nameBalls()) + '[/color]. ',
		average = '$He has an  [color=yellow]average-sized[/color] [color=yellow]' + str(nameBalls()) + '[/color]. ',
		large = '$He has a [color=yellow]huge[/color] pair of [color=yellow]' + str(nameBalls()) + '[/color] weighing $him down. ',
		massive = '$He has some [color=yellow]' + str(randomitemfromarray(['truly massive','gigantic','magnificent','outrageously big'])) + '[/color] [color=yellow]' + str(nameBalls()) + '[/color] dangling between $his legs. ',
	},
	###---Added by Expansion---### Sizes Expanded
	vagina = {
		impenetrable = 'an [color=yellow]impenetrable[/color] [color=yellow]' + str(namePussy()) + '[/color] that looks like it would rip even trying to fit a finger inside.',
		tiny = 'a [color=yellow]tiny[/color] [color=yellow]' + str(namePussy()) + '[/color] that would very snugly squeeze a finger put inside of it. ',
		tight = '$his [color=yellow]tight[/color], little [color=yellow]' + str(namePussy()) + '[/color] that almost looks like it is still virginal. ',
		average = '$his pink, completely [color=yellow]average[/color] [color=yellow]' + str(namePussy()) + '[/color]. ',
		loose = 'an unfortunately [color=red]loose[/color] [color=yellow]' + str(namePussy()) + '[/color] that looks like it has seen some use. ',
		gaping = '$his [color=red]gaping[/color] [color=yellow]' + str(namePussy()) + '[/color], so spread open that you can almost see $his cervix. ',
		normal = '$his currently [color=red]undefined[/color] [color=yellow]' + str(namePussy()) + '[/color]. \nYou are sure you will understand it better tomorrow. ',
	},
	asshole = {
		impenetrable = 'an [color=yellow]impenetrable[/color] [color=yellow]' + str(nameAsshole()) + '[/color] that looks like it would rip even trying to fit a finger inside.',
		tiny = 'a [color=yellow]tiny[/color] [color=yellow]' + str(nameAsshole()) + '[/color] so small that it was hard to even find it between $his cheeks. ',
		tight = '$his [color=yellow]tight[/color] little [color=yellow]' + str(nameAsshole()) + '[/color] that looks like it has never been used for sex or anything else. ',
		average = '$his completely [color=yellow]average[/color] [color=yellow]' + str(nameAsshole()) + '[/color] ',
		loose = 'a surprisingly [color=yellow]loose[/color] [color=yellow]' + str(nameAsshole()) + '[/color] that looks like it has seen some use. ',
		gaping = '$his massive, [color=yellow]gaping[/color] [color=yellow]' + str(nameAsshole()) + '[/color] that is so wide it looks like the side walls of his asshole make a red flower. ',
		normal = '$his currently [color=yellow]undefined[/color] [color=yellow]' + str(nameAsshole()) + '[/color]. \nYou are sure you will understand it better tomorrow. ',
	},
###---End Expansion---###
}

###---Added by Expansion---### Description Updates | Deviate
func race():
	var text = "$He is "
	if person.race[0] in ['E','A','O','U']:
		text += 'an '
	else:
		text += 'a '
	text += "[color=yellow][url=race]" + person.race + '[/url][/color]' + person.get_race_display() + ": "
	return text

func basics():
	var text = ''
	if showmode == 'default':
		text += "[url=basic][color=#d1b970]Basics:[/color][/url]\n "
	if globals.state.descriptsettings.basic == true || showmode != 'default':
		text += entry() + race() + getdescription('bodyshape') + getdescription('age') + getbeauty() + "\n\n" + person.get_genealogy()

	else:
		text += "[color=yellow]$name, [url=race]" + person.race + "[/url]" + person.get_race_display() + ", " + person.age.capitalize() + "[/color]. "
	return text
###---End Expansion---###
