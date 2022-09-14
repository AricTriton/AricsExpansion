
func getslavedescription(tempperson, mode = 'default'):
	showmode = mode
	person = tempperson
	###---Added by Expansion---###
	globals.expansion.updatePerson(person)
	var text = basics() + features() + genitals() + mods() + tattoo() + piercing() + showVice() + onceperdayConvos()
	###---Expansion End---###
	if person.customdesc != '':
		text += '\n\n' + person.customdesc
	if person == globals.player:
		text = person.dictionaryplayerplus(person.dictionaryplayer(text))
		#ralph8
		var array = []
		var textcolor = ""
		if person.preg.duration > 2:
			text += "\n\nYou are now certain you are pregnant. If you had to guess you'd say " + str(globals.expansion.getTrimester(person)).capitalize() + " trimester."
		elif person.preg.duration > 0:
			text += "\n\nYou're not completely sure, but you think you might be pregnant."
		if !person.traits.empty():
			for i in person.traits:
				array.append(i)
			if array.size() == 1:
				text += "\n\nYour new life has been quite interesting so far. You've aquired a trait: " + array[0] + "."
			else:
				var count = 0
				text += "\n\nYour new life has been quite interesting so far. You've aquired some traits: "
				for i in array:
					count += 1
					if count < array.size():
						text += i + ", "
					else:
						text += "and " + i + "."
		text += "\n\nYour mind wanders to sex and in comparing yourself to others, you suspect your fetishes are:\n"
		for i in person.fetish:
			if person.fetish[i] in ['mindblowing','enjoyable']:
				textcolor = "[color=green]"
			elif person.fetish[i] in ['acceptable','uncertain']:
				textcolor = "[color=yellow]"
			else:
				textcolor = "[color=red]"
			text += i.capitalize() + ": " + textcolor + person.fetish[i].capitalize() + "[/color]\n"
		#/ralph8
	else:
		text = person.dictionary(text)

	if text.find('[furcolor]'):
		text = text.replace('[furcolor]', getdescription('furcolor'))
		
	if text.find('[hairstyle]'):
		text = text.replace('[hairstyle]', getdescription('hairstyle'))

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
		if !person.dailytalk.has('talk_new_fetish') || !person.dailytalk.has('talk_change_fetish'):
			text += "\n[color=aqua]Learn, Encourage, or Discourage $His Fetishes[/color]"
		#The Number of Children
		if !person.knowledge.has('desiredoffspring') && !person.dailytalk.has('desiredoffspring'):
			text += "\n[color=aqua]Ask How Many Kids $He Wants[/color]"
		elif person.knowledge.has('desiredoffspring') && !person.dailytalk.has('desiredoffspring'):
			text += "\n[color=aqua]Encourage or Discourage the Number of Kids $He Wants[/color]"
		#Crystal - TBK REMOVE
#		if !person.dailytalk.has('crystalresearch') && globals.state.thecrystal.power <= person.smaf - 1:
			text += "\n[color=aqua]Attempt to Research the Crystal[/color]\n     $His [color=aqua]Wit[/color] equates to $his chance of success to not accidentally make the [color=#E389B9]Crystal[/color] more [color=aqua]Powerful[/color] and harder to [color=aqua]Research[/color]."
			if globals.state.thecrystal.mode == "dark":
				text += "\n[color=red]Extreme Failure may result in $his being consumed by the [color=#E389B9]Crystal[/color] to sate its hunger.[/color]"
		
	return text

func showVice():
	var text = ""
	if person == globals.player || person.mind.vice_known == false || globals.expansionsettings.vices_luxury_effects == false:
		return ""
	match person.mind.vice:
		'lust':
			return "\n\n[color=#d1b970]Vice:[/color]\n$His greatest [color=aqua]vice[/color] is [color=red]Lust[/color]. $His sexuality is far higher than that of the average person and $he enjoys sex more than almost anything else. \n[color=#d1b970]Job Bonus:[/color] $He will be satisfied by [color=aqua]Prostitution[/color], [color=aqua]Escort[/color], and [color=aqua]Fucktoy[/color] jobs. $He will not experience any [color=red]Vice Luxury Penalties[/color] while in those positions. \n[color=#d1b970]Consent Bonus:[/color] $He is more likely to give [color=aqua]Sexual Consent[/color]. \n[color=green]Fucking Bonus:[/color] [color=green]+10 Luxury[/color] if $he was fucked today, whether from $his job or directly by $his master. Recieves [color=green]10 Percent[/color] of $his [color=aqua]Lewdness[/color] as bonus [color=aqua]Luxury[/color] daily. Every day $he isn't fucked reduces the total by [color=red]-3 Luxury[/color] to a maximum penalty of [color=red]-20 Luxury[/color] after [color=aqua]6 sexless days[/color].\n[color=#d1b970]Rule Penalty:[/color] Receive [color=red]-5 Luxury[/color] if not fucked that day and ordered not to [color=aqua]masturbate[/color]. "
		'pride':
			return "\n\n[color=#d1b970]Vice:[/color]\n$His greatest [color=aqua]vice[/color] is [color=red]Pride[/color]. $He is incredibly focused on $his own appearance and will feel disheartened if not allowed to maintain $his standards of presentability.\n[color=#d1b970]Job Bonus:[/color] $He will be satisfied by [color=aqua]Headgirl[/color], [color=aqua]Farm Manager[/color], and [color=aqua]Jailor[/color] jobs. $He will not experience any [color=red]Vice Luxury Penalties[/color] while in those positions. $He will additionally gain [color=green]+10 Luxury[/color] while in one of those positions.\n[color=#d1b970]Rule Bonus:[/color] Gain [color=green]+5 Luxury[/color] if $he is allowed [color=aqua]Cosmetics[/color] (using [color=red]1 Additional Supply[/color]) or a [color=aqua]Personal Bath[/color]. $He will lose [color=red]-10 Luxury[/color] if they are not allowed and not in a [color=aqua]satisfying[/color] job. "
		'greed':
			return "\n\n[color=#d1b970]Vice:[/color]\n$His greatest [color=aqua]vice[/color] is [color=red]Greed[/color]. $He is exceptionally materialistic and enjoys having the freedom to spend $his own money.\n[color=#d1b970]Job Bonus:[/color] $He will be satisfied by [color=aqua]Merchant[/color] and [color=aqua]Milk Merchant[/color] jobs. $He will not experience any [color=red]Vice Luxury Penalties[/color] while in those positions. $He will additionally gain [color=green]+10 Luxury[/color] while in one of those positions.\n[color=#d1b970]Rule Bonus:[/color] $He will gain [color=green]+10 Luxury[/color] (using [color=red]5 additional Gold[/color]) while allowed [color=aqua]Pocket Money[/color]. Otherwise, $he will lose [color=red]-10 Luxury[/color] if $he is not in a [color=aqua]satisfying[/color] job. "
		'sloth':
			return "\n\n[color=#d1b970]Vice:[/color]\n$His greatest [color=aqua]vice[/color] is [color=red]Sloth[/color]. $He enjoys rest, relaxation, and is very sensitive to stress.\n[color=#d1b970]Job Bonus:[/color] $He will be satisfied by [color=aqua]Rest[/color] and [color=aqua]Housepet[/color] jobs. $He will not experience any [color=red]Vice Luxury Penalties[/color] while in those positions. $He will additionally gain [color=green]+5 Luxury[/color] while in one of those positions.\n[color=#d1b970]Rule Bonus:[/color] $He will gain [color=green]+5 Luxury[/color] while allowed a [color=aqua]Personal Bath[/color].\n[color=aqua]Relaxation Bonus:[/color] $He will gain [color=green]+10 Luxury[/color] if $he has full [color=aqua]Energy[/color] by the end of the day. $He will also gain  Otherwise, $he will lose [color=red]-5 Luxury[/color] if $he has below [color=aqua]25 Percent[/color] [color=aqua]Energy[/color] and/or over [color=red]over 75%[/color] of $his maximum [color=aqua]Stress[/color]. "
		'gluttony':
			return "\n\n[color=#d1b970]Vice:[/color]\n$His greatest [color=aqua]vice[/color] is [color=red]Gluttony[/color]. $His greatest pleasure is in good food and drink.\n[color=#d1b970]Job Bonus:[/color] $He will be satisfied by the [color=aqua]Cook[/color] job. $He will not experience any [color=red]Vice Luxury Penalties[/color] while in those positions. $He will additionally gain [color=green]+10 Luxury[/color] while in one of those positions.\n[color=#d1b970]Date Bonus:[/color] Food and Drink Interactions will always give the [color=green]best results[/color] on [color=aqua]Dates[/color].\n[color=#d1b970]Rule Bonus:[/color] $He will gain [color=green]+10 Luxury[/color] while allowed [color=aqua]Better Food[/color] (using [color=red]3 additional Food[/color]). Otherwise, $he will lose [color=red]-10 Luxury[/color] if $he is not in a [color=aqua]satisfying[/color] job. "
		'wrath':
			return "\n\n[color=#d1b970]Vice:[/color]\n$His greatest [color=aqua]vice[/color] is [color=red]Wrath[/color]. $He loves the passion of battle and the thrill of combat. However, $he is an oddity among other [color=aqua]Vices[/color] in that $he holds no expectations on you unless you have promised $him a good fight.\n[color=#d1b970]Consent Bonus:[/color] $He is more likely to give [color=aqua]Consent to Fight Alongside You[/color]. However, $he will expect to be granted a good fight regularly once $his consent has been given.\n[color=#d1b970]Job Bonus:[/color] $He will be satisfied by the [color=aqua]Guardian[/color], [color=aqua]Slave-Catcher[/color], [color=aqua]Trainer[/color], and [color=aqua]Trainee[/color] jobs. $He will not experience any [color=red]Vice Luxury Penalties[/color] while in those positions. $He will additionally gain [color=green]+5 Luxury[/color] while in one of those positions.\n[color=#d1b970]Combat Bonus:[/color] $He will gain or lose [color=aqua]Luxury[/color] equal to $his total [color=aqua]Wins[/color] minus the number of days $he has been [color=aqua]Owned[/color] by you to a maximum bonus or penalty of [color=aqua]20[/color]. "
		'envy':
			return "\n\n[color=#d1b970]Vice:[/color]\n$His greatest [color=aqua]vice[/color] is [color=red]Envy[/color]. $He cannot help but compare $himself and $his living conditions to whoever $he considers to be the current favorite slave of the mansion.\n[color=#d1b970]Favored Slave Bonus:[/color] If $he is considered the [color=aqua]favored slave[/color], $he will receive a flat [color=green]+20 Luxury[/color] and ignore all remaining [color=aqua]vice[/color] factors.\n[color=#d1b970]Job Bonus:[/color] $He will be satisfied by the [color=aqua]Headgirl[/color], [color=aqua]Farm Manager[/color], and [color=aqua]Jailer[/color] jobs. $He will not experience any [color=red]Vice Luxury Penalties[/color] while in those positions. $He will additionally gain [color=green]+5 Luxury[/color] while in one of those positions.\n[color=#d1b970]Favored Slave Comparison:[/color] $He will compare $himself with your favored slave on the following factors and gain [color=green]+5 Luxury[/color] if successful or [color=red]-5 Luxury[/color] if not. $He will see if the favored slave is sleeping in [color=aqua]Your Bed[/color] or a [color=aqua]Personal Room[/color] and be envious if $he is not. $He will be envious if $he has [color=aqua]consented[/color] to [color=aqua]sex with you[/color] and the favored slave slept with you more recently than $he has. $He will be envious if the favored slave has [color=aqua]50 Percent[/color] less stress than $he does. Finally, $he will be envious if the favored slave has a higher [color=aqua]Grade[/color] than $he does. $He will receive a maximum [color=aqua]Bonus[/color] or [color=aqua]Penalty[/color] of 20. "
		'none':
			return ""

###---End Expansion---###

func features():
	var text = '\n'
	if showmode == 'default':
		text += '[url=appearance][color=#d1b970]Appearance:[/color][/url] '
	###---Added by Expansion---### Person Expanded
	if globals.state.descriptsettings.appearance == true || showmode != 'default':
		text = "\n" + text
		#Face
		text += "\n[color=#d1b970]Head:[/color]\n" + getdescription('hairlength') + getdescription("eyesclera") + getdescription("eyecolor") + getdescription("eyeshape") + getdescription('horns') + getdescription('ears') + getdescription('lips') #ralph2
		text += "\n" + globals.expansion.getCheeksDescription(person) + globals.expansion.getCumCoatedDescription(person,'face')
		#Body
		text += "\n[color=#d1b970]Body:[/color]\n" + getdescription('skin') + getdescription("skincov") + getdescription("wings") + getdescription("tail") + getdescription("height") + getdescription("asssize")
		text += "[color=green]" + globals.expansion.getSwollenDescription(person,true) + "\n" + globals.expansion.getCumCoatedDescription(person,'body') + "[/color]"
		text += "\n\n[color=green]" + globals.expansion.getSwollenDescription(person,false) + "[/color]"
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
				text += "\n$His nipples are incredibly hard and occassionally spout streams of milk when $he moves or breathes heavily. [color=green]$He is obviously lactating.[/color]"
		elif person == globals.player:
			text += "\n" + getdescription("titssize") + gettitsextra()
			if person.lactation == true:
				text += "\nYour nipples are incredibly hard and occassionally spout streams of milk when you move or breathe heavily. [color=green]You are obviously lactating.[/color]"
		else:
			text += '\n$He is wearing a [color=red]shirt[/color] at the moment, obscuring the details of $his ' + str(globals.expansion.getChest(person)) + ' from your ' + globals.randomitemfromarray(['eyes','gaze','inspection']) + '.'
			if person.lactation == true:
				text += "\n$His clothes have large " + globals.randomitemfromarray(['wet','gloopy','moist','damp','dark']) + " spots soaking $his " + str(globals.expansion.getChest(person)) + ", trailing down towards $his stomach. [color=green]$He is obviously lactating.[/color]"
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
				text += ' $He spreads $his legs open to show you $his tight, [color=green]virgin ' + globals.expansion.namePussy() + '[/color]. '
			else:
				text += ' $He spreads $his legs open to show you ' + getdescription('vagina')
			# if person.lust >= 50:
			# 	if person.lust >= 100:
			# 		text+= "A large quantity of lubrication drips from their"+ globals.expansion.namePussy()+" and down their thighs. A small puddle has formed beneath them. " 
			# 	elif person.lust >= 75:
			# 		text+= "You notice that they are leaking juices. Some of it dribbles down their inner thighs. "
			# 	else:
			# 		text += "You notice a little wetness between $his folds. "
			if person.cum.pussy > 0:
				text += " As $his legs are spread open, you notice a little [color=aqua]" +globals.expansion.nameCum()+"[/color] slip out of $his [color=aqua]" + globals.expansion.namePussy() + "[/color]. "
				if person.lust >= 50:
					if person.lust >= 80:
						text+= "[color=fuchsia]Excessive juices[/color] are mixed in with the [color=aqua]" +globals.expansion.nameCum()+"[/color]. " 
					elif person.lust >= 65:
						text+= "$His [color=fuchsia]liquid arousal[/color] has mixed with the [color=aqua]" +globals.expansion.nameCum()+"[/color] escaping from their [color=yellow]"+ globals.expansion.namePussy()+"[/color].  "
					else:
						text += "There is some [color=fuchsia]girlcum[/color] mixed in with the [color=aqua]" +globals.expansion.nameCum()+"[/color]. "
			else:
				if person.lust >= 50:
					if person.lust >= 80:
						text+= "A large quantity of [color=fuchsia]girlcum[/color] drips from $his [color=fuchsia] quivering "+ globals.expansion.namePussy()+" [/color]and down $his thighs. A small puddle has formed beneath them. " 
					elif person.lust >= 65:
						text+= "$His clit is [color=fuchsia]visibly swollen[/color]. You notice that $he is [color=fuchsia]leaking juices[/color]. Some of it dribbles down $his thighs. "
					else:
						text += "You notice a little [color=fuchsia]wetness[/color] between $his folds. "
			if person.cum.pussy > vagcapacity:
				text += "" + globals.expansion.vagOverload(person) + "\n"
		if person.penis != 'none':
			text += "\n[color=#d1b970]Penis:[/color]\n"
			var temp = person.penistype + '_' + person.penis
			if newpenisdescription.has(temp):
				text += " " + newpenisdescription[temp]
				if person.lust >= 50:
					if person.lust >= 80:
						text+= " $His [color=yellow]" +globals.expansion.namePenis() + "[/color] is [color=fuchsia]rock hard and bulging[/color]. It pulses visibly. " 
					elif person.lust >= 65:
						text+= " $His [color=yellow]" +globals.expansion.namePenis() + "[/color] is [color=fuchsia]fully erect[/color]. "
					else:
						text+= " $His [color=yellow]" +globals.expansion.namePenis() + "[/color] [color=fuchsia]twitches and flexes[/color] from time to time."
		if person.balls != 'none':
			text += "\n[color=#d1b970]Balls:[/color]\n"
			text += getdescription('balls')
			text += "$He produces [color=aqua]" + str(person.pregexp.cumprod) + "oz[/color] of [color=aqua]" +globals.expansion.nameCum()+ "[/color] per ejaculation. "
			if person.lust >= 80:
				text+= "As you watch, $his [color=yellow]" +globals.expansion.nameBalls() + "[/color] seem to clench and a [color=fuchsia]small bulge[/color] travels up through $his [color=yellow]"+globals.expansion.namePenis()+"[/color]. A bit of [color=aqua]"+globals.expansion.nameCum()+"[/color] drips from the tip of $his [color=yellow]"+globals.expansion.namePenis()+"[/color] to the floor." 
	elif person != globals.player:
		text += ' $His crotch is [color=red]clothed[/color] and [color=red]covered[/color] at the moment, obscuring the details of $his ' + str(globals.expansion.getGenitals(person)) + ' from your ' + globals.randomitemfromarray(['eyes','gaze','inspection']) + '.'
		if person.cum.pussy > vagcapacity:
			text += "\nYou " + globals.randomitemfromarray(['spot','notice','glance at','see']) + " a mass of " + globals.randomitemfromarray(['wet','gloopy','moist','damp','dark']) + " spots seeping from $his crotch and sticking to $his " + globals.randomitemfromarray(['crotch','thighs','clothing',globals.expansion.namePussy()]) + ". " + globals.randomitemfromarray(['Did $he piss $himself?','How much is oozing out of $him?','Can $he still feel it pouring out?','Is that why $he is flushed?','Interesting...'])
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
			text += "You know that you produce [color=aqua]" + str(globals.player.pregexp.cumprod) + "oz[/color] of [color=aqua]" +globals.expansion.nameCum()+ "[/color] per ejaculation. "
	if person.vagina == 'none' && person.penis == 'none' && person.balls == 'none':
		text += " For some reason, $his crotch has no visible genitals. "
	if person.preg.has_womb == false && person.sex != 'male':
		if person == globals.player:
			text += "\n\n[color=yellow]Your womb is sterile.[/color]"
		else:
			text += "\n\n[color=yellow]$name's womb is sterile.[/color]"
	if person.asshole != 'none':
		text += "\n[color=#d1b970]Asshole:[/color]\n"
		if person.exposed.ass == true && person != globals.player:
			if person.assvirgin == true:
				text += 'When requested, $he turns around and bends over to show off $his tight, [color=green]virgin ' + globals.expansion.nameAsshole() + '[/color]. '
			else:
				text += 'When requested, $he turns around and bends over to show off ' + getdescription('asshole')
			if person.cum.ass > 0:
				text += " As $his legs are spread open, you see a little [color=aqua]" +globals.expansion.nameCum()+"[/color] slip out of $his [color=aqua]" + globals.expansion.nameAsshole() + "[/color]. "
			if person.cum.ass > asscapacity:
				text += "" + globals.expansion.assOverload(person) + "\n"
		elif person != globals.player:
			text += '$His ' + globals.expansion.nameAsshole() + ' is [color=red]clothed[/color] and [color=red]covered[/color] at the moment, obscuring the details of $his ' + globals.expansion.nameAsshole() + ' from your ' + globals.randomitemfromarray(['eyes','gaze','inspection']) + '.'
		elif person == globals.player:
			text += ' All your life, you have had an ' + globals.expansion.nameAsshole() + ' following you around. It is ' + getdescription('asshole')
		if person.cum.ass > asscapacity:
			text += "\nYou " + globals.randomitemfromarray(['spot','notice','glance at','see']) + " a mass of " + globals.randomitemfromarray(['wet','gloopy','moist','damp','dark']) + " spots seeping from $his " + globals.expansion.nameAsshole() + " and sticking to $his " + globals.randomitemfromarray(['ass','thighs','clothing',globals.expansion.nameAsshole()]) + ". " + globals.randomitemfromarray(['Is it still coming out?','How much is oozing out of $him?','Can $he still feel it pouring out?','Is that why $he is flushed?','Interesting...'])
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
		text = text[randi() % text.size()]
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
	elif appeal <= 100:
		calculate = 'beautiful'
	else:
		calculate = 'gorgeous'

	text = newdescriptions['beauty'][calculate]
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

func getBabyDescription(person):
	var moreeyeinfo = ''
	if person.eyesclera != 'normal':
		moreeyeinfo = ' with ' + str(person.eyesclera) + ' sclera'
	var text
	if(person.skin != 'none'):	#Capitulize
		text = '$He has ' + person.haircolor + ' hair and ' + person.eyecolor + ' eyes' + moreeyeinfo + '. $His skin is ' + person.skin + '. '
	else:
		text = '$He has ' + person.haircolor + ' hair and ' + person.eyecolor + ' eyes' + moreeyeinfo + '. '

	var dict = {
		none = '',
		plants = "It is covered in some leaves and green plant matter. ",
		scales = "It is covered in a few scales. ",
		feathers = "It has bird feathers in some places. ",
		full_body_fur = "It shows the beginnings of fur. ",
		fullscales = '$He is covered in scales. ',
	}
	
	text += dict[person.skincov]
	if person.tail != 'none':
		text += '$He appears to have a small tail, inherited from one of the parents. '
	if person.horns != 'none':
		text += '$He has pair of tiny horns on $his head. '
		
	dict = {
		human = 'normal',
		short_furry = 'short and furry',
		long_pointy_furry = 'long and furry',
		pointy = 'pointy',
		long_round_furry = 'of a bunny',
		long_droopy_furry = 'of a bunny',
		feathery = "feathery",
		fins = 'fin-like',
		short_reptilian = 'short and scaled',
		long_pointy_reptilian = 'long and scaled',
		frilled = 'frills',
		none = '',
		long_round_reptilian = 'long, round, and reptilian',
		long_droopy_reptilian = 'long, droopy, and reptilian',
		wide_furry = 'big and round',
		avali = 'long and fluffy, with two pairs',
	}
	
	if(person.ears != 'none'):
		text += '$His ears are ' + dict[person.ears] + '. '
	else:
		text += '$He has no ears. '
	
	text = person.dictionary(text)
	return text

###---Added by Expansion---###
func randomitemfromarray(array):
	if array.empty():
		print("ERROR: randomitemfromarray() empty")
		return null
	else:
		return array[randi() % array.size()]

func nameTits():
	return randomitemfromarray(['boobs','breasts','tits','boobs','breasts','tits','udders'])

func namePenis():
	return randomitemfromarray(['penis','cock','member','dick','penis','cock','member','dick'])

func nameBalls():
	return randomitemfromarray(['balls','balls','nuts','nutsack','testicles','ballsack'])

func namePussy():
	return randomitemfromarray(['pussy','pussy','twat','cunt','cunt','vagina'])

func nameAsshole():
	return randomitemfromarray(['butt','bum','bumhole','asshole','ass','butthole','anus','sphincter'])

func nameAss():
	return randomitemfromarray(['ass','ass','butt','rump','behind','ass cheeks'])
###---End Expansion---###

###---Added by Expansion---###
var newpenisdescription = {
	human_micro = '$His [color=yellow]' + namePenis() +'[/color] is so ' + randomitemfromarray(['incredibly miniscule','microscopic','miniature']) + ' that it is pitiable.',
	human_tiny = '$He has a ' + randomitemfromarray(['extremely small','tiny','itty bitty']) + ' [color=yellow]' + namePenis() + '[/color] dangling below $his groin.',
	human_small = 'Below $his waist dangles a [color=yellow]tiny humanish '+ namePenis() + '[/color], small enough that it could be called cute. ',
	human_average ='$He has an [color=yellow]ordinary humanish ' + namePenis() + '[/color] below $his waist, more than enough to make most men proud. ',
	human_large = 'A [color=yellow]huge humanish ' + namePenis() + '[/color] swings heavily from $his groin, big enough to give even the most veteran whore pause. ',
	human_massive ='$He has a thick ' +  randomitemfromarray(['truly massive','gigantic','magnificent','outrageously big']) + ' [color=yellow]' + namePenis() + '[/color] dangling below his groin that would destroy the average ' + namePussy() + '.',
	reptilian_micro = '$His [color=yellow]' + namePenis() + '[/color] is so ' +  randomitemfromarray(['incredibly miniscule','microscopic','miniature']) + ' that it barely extends out of $his slit.',
	reptilian_tiny = '$He has a ' +  randomitemfromarray(['extremely small','tiny','itty bitty']) + ' [color=yellow]' + namePenis() + '[/color] extending out $his slit.',
	reptilian_small = 'Below $his waist extends a [color=yellow]tiny reptilian '+ namePenis() + '[/color], small enough that it could be called cute. ',
	reptilian_average ='$He has [color=yellow]regular reptilian ' + namePenis() + '[/color] extending out of his slit, it is averagely sized. ',
	reptilian_large = 'A [color=yellow]huge reptilian ' + namePenis() + '[/color] extends out of $his slit, it is long and fit for deep penetration. ',
	reptilian_massive ='$He has a thick ' +  randomitemfromarray(['truly massive','gigantic','magnificent','outrageously big']) + ' [color=yellow]' + namePenis() + '[/color] extendin from his slit that would destroy the average ' + namePussy() + '.', # /Capitulize
	canine_micro = '$His slender, canine [color=yellow]' + namePenis() + '[/color] is so ' +  randomitemfromarray(['incredibly miniscule','microscopic','miniature']) + ' that you can barely see the knot at all.',
	canine_tiny = '$He has a thin, ' +  randomitemfromarray(['extremely small','tiny','itty bitty']) + ' canine [color=yellow]' + namePenis() + '[/color] dangling barely noticably below $his groin.',
	canine_small = 'A slender, pointed [color=yellow]canine ' + namePenis() + '[/color] hangs below $his waist, so small that its knot is barely noticeable. ',
	canine_average = '$He has a knobby, red, [color=yellow]canine ' + namePenis() + '[/color] of respectable size below $his waist, which wouldn’t look out of place on a large dog. ',
	canine_large = 'Growing from $his crotch is a [color=yellow]massive canine ' + namePenis() + '[/color], red-skinned and sporting a thick knot near the base. ',
	canine_massive = '$He has a slender, ' +  randomitemfromarray(['truly massive','gigantic','magnificent','outrageously big']) + ' canine [color=yellow]' + namePenis() + '[/color] dangling below his groin that would destroy the average ' + namePussy() + '. The knot alone would make the average girl look pregnant.',
	feline_micro = '$His slender, feline [color=yellow]' + namePenis() + '[/color] is so ' +  randomitemfromarray(['incredibly miniscule','microscopic','miniature']) + ' that you can barely see the barbs at all.',
	feline_tiny = '$He has a thin, ' +  randomitemfromarray(['extremely small','tiny','itty bitty']) + ' feline [color=yellow]' + namePenis() + '[/color] dangling barely noticably below $his groin. It is covered in tiny barbs.',
	feline_small = 'A [color=yellow]tiny feline ' + namePenis() + '[/color] dangles below $his waist, so small you can barely see the barbs. ',
	feline_average = '$He has a barbed [color=yellow]cat ' + namePenis() + '[/color] growing from $his crotch, big enough to rival an average human. ',
	feline_large = 'There is a frighteningly [color=yellow]large feline ' + namePenis() + '[/color] hanging between $his thighs, its sizable barbs making it somewhat intimidating. ',
	feline_massive = '$He has a sleek, ' +  randomitemfromarray(['truly massive','gigantic','magnificent','outrageously big']) + ' feline [color=yellow]' + namePenis() + '[/color] dangling below his groin that would destroy the average ' + namePussy() + '. The barbs would be excruciatingly painful to the unprepared.',
	rodent_micro = '$His slender, rodent [color=yellow]' + namePenis() + '[/color] is so ' +  randomitemfromarray(['incredibly miniscule','microscopic','miniature']) + ' that you can barely see its sheath under the fur.', # /Capitulize
	rodent_tiny = '$He has a thin, ' +  randomitemfromarray(['extremely small','tiny','itty bitty']) + ' rodent [color=yellow]' + namePenis() + '[/color] hidden within $his sheath.',
	rodent_small = 'A [color=yellow]tiny rodent ' + namePenis() + '[/color] is in its sheath, so small you can barely see the it. ',
	rodent_average = '$He has a [color=yellow]rodent ' + namePenis() + '[/color] growing from $his sheath, big enough to rival an average human. ',
	rodent_large = 'There is a frighteningly [color=yellow]large rodent ' + namePenis() + '[/color] inside a sheath between $his thighs as it extends in an intimidating way. ',
	rodent_massive = '$He has a sleek, ' +  randomitemfromarray(['truly massive','gigantic','magnificent','outrageously big']) + ' rodent [color=yellow]' + namePenis() + '[/color] extending out of $his sheath, it would destroy the average ' + namePussy() + '. ', 
	bird_micro = '$His slender, bird [color=yellow]' + namePenis() + '[/color] is so ' +  randomitemfromarray(['incredibly miniscule','microscopic','miniature']) + ' that you can barely see its cloaca under the feathers.',
	bird_tiny = '$He has a thin, ' +  randomitemfromarray(['extremely small','tiny','itty bitty']) + ' bird [color=yellow]' + namePenis() + '[/color] hidden within $his cloaca.',
	bird_small = 'A [color=yellow]tiny bird ' + namePenis() + '[/color] is in its cloaca, so small you can barely see the it. ',
	bird_average = '$He has a [color=yellow]bird ' + namePenis() + '[/color] growing from $his cloaca, big enough to rival an average human. ',
	bird_large = 'There is a frighteningly [color=yellow]large bird ' + namePenis() + '[/color] inside a cloaca between $his thighs as it extends in an intimidating way. ',
	bird_massive = '$He has a sleek, ' +  randomitemfromarray(['truly massive','gigantic','magnificent','outrageously big']) + ' bird [color=yellow]' + namePenis() + '[/color] extending out of $his cloaca, it would destroy the average ' + namePussy() + '. ', # /Capitulize
	equine_micro = '$His slender, equine [color=yellow]' + namePenis() + '[/color] is so ' +  randomitemfromarray(['incredibly miniscule','microscopic','miniature']) + ' that you could reasonably believe $he is a woman and it is $his clit.',
	equine_tiny = '$He has a thin, ' +  randomitemfromarray(['extremely small','tiny','itty bitty']) + ' equine [color=yellow]' + namePenis() + '[/color] dangling barely noticably below $his groin. It is spotted a variety of colors.',
	equine_small = 'Below $his waist hangs a [color=yellow]smallish equine ' + namePenis() + '[/color], which is still respectable compared to the average man. ',
	equine_average= 'A [color=yellow]sizable equine ' + namePenis() + '[/color] grows from $his nethers, which, while small on a horse, is still thicker and heavier than the average human tool. ',
	equine_large = 'A [color=yellow]massive equine ' + namePenis() + '[/color] hangs heavily below $his waist, its mottled texture not quite matching the rest of $his skin. ',
	equine_massive ='$He has a club-like, ' +  randomitemfromarray(['truly massive','gigantic','magnificent','outrageously big']) + ' equine [color=yellow]' + namePenis() + '[/color] dangling below $his groin that would destroy the average ' + namePussy() + '. The lumps in the middle could break someone in two.',
}
###---Expansion End---###

#Store descriptions for various body parts. Separate alternative with | sign to make description pick one at random
var newdescriptions = {
	bodyshape = {
		humanoid = '$His body is quite [color=yellow]normal[/color]. ',
		giant = "$His body resembles a human's, except that $he is [color=yellow]extremely large.[/color] ",
		bestial = "$His body resembles a human's, except for some [color=yellow]bestial features[/color] in $his face and body structure. ",
		reptilian ="$His body resembles a human's, except for [color=yellow]reptilian features[/color] in $his face and body structure. ",
		shortstack = '$His body is rather [color=yellow]petite[/color], about half the size of the average person. ',
		reptilianshortstack = '$His body is rather [color=yellow]petite[/color], about half the size of the average person. $He has [color=yellow]reptilian features[/color] in $his face and body structure. ',
		furryshortstack = '$His body is rather [color=yellow]petite[/color], about half the size of the average person. $He has [color=yellow]bestial features[/color] in $his face and body structure. ',
		avian = "$His body resembles a human's, except for [color=yellow]avian features[/color] in $his face and body structure. ",
		jelly = '$His body is [color=yellow]jelly-like[/color] and partly transparent. ',
		halfbird = '$His body has [color=yellow]wings for arms and avian legs[/color] making everyday tasks difficult. ',
		halfsnake = 'The lower portion of $his body consists of a long-winding [color=yellow]snake’s tail[/color]. ',
		halffish = '$His body is [color=yellow]scaly and sleek[/color], possessing fins and webbed digits. ',
		halfspider = "The lower portion of $his body consists of a [color=yellow]spider's legs and abdomen[/color]. ",
		halfhorse = 'While $his upper body is human, $his lower body is [color=yellow]equine[/color] in nature. ',
		halfsquid = 'The lower portion of $his body consists of a [color=yellow]number of tentacular appendages[/color], similar to those of an octopus. ',
		raptorshortstack = '$His body is rather [color=yellow]petite[/color], about half the size of the average person. $He has [color=yellow]raptor-like features[/color] in $his face and body structure. ',
	},
	age = {
		child = '$He looks like a [color=aqua]' + randomitemfromarray(['','child','kid','young']) + ' $sex [/color] that has barely hit puberty. ',
		teen = "$He's a young-looking [color=aqua]" + randomitemfromarray(['','teen','young-adult','teenaged']) + " $sex[/color]. ",
		adult = "$He's a fully-grown [color=aqua]" + randomitemfromarray(['adult','specimen of a ','']) + " $sex[/color]. ",
	},
	beauty = {
		ugly = '$He is rather [color=yellow]unsavory[/color] to look at. ',
		boring = '$His looks are [color=yellow]bland and unimpressive[/color]. ',
		normal = '$He appears to be pretty [color=yellow]average[/color] looking. ',
		cute = '$His looks are quite [color=yellow]cute[/color] and appealing. ',
		pretty = '$He looks unusually [color=yellow]pretty[/color] and attracts some attention. ',
		beautiful = '$He looks exceptionally [color=yellow]beautiful[/color], having no visible flaws and easily evoking envy. ',
		gorgeous = '$He is unbelievably [color=yellow]gorgeous[/color], outside of what any would consider normal beauty. ',
	},
	lips = {
		masculine = '$He has thin, narrow [color=aqua]lips[/color] on his face that look rough and [color=aqua]manly[/color]. ',
		thin = '$His [color=aqua]lips[/color] are [color=aqua]' + randomitemfromarray(['tiny','thin','narrow']) + '[/color] and ' + randomitemfromarray(['unremarkable','unassuming','unattractive']) + '. ',
		small = '$His [color=aqua]lips[/color] are [color=aqua]'+ randomitemfromarray(['small','little','smaller than average']) + '[/color]. ',
		average = '$He has [color=aqua]lips[/color] that are [color=aqua]' + randomitemfromarray(['nice','very average','average','normal']) + '[/color]. ',
		big = '$His [color=aqua]lips[/color] are [color=aqua]' + randomitemfromarray(['very nice','big','slightly bigger than average']) + '[/color]. ',
		huge = '$His [color=aqua]' + randomitemfromarray(['huge','very big','large','slightly plump']) + '[/color] [color=aqua]lips[/color] are prominent on $his face. ',
		plump = '$His [color=aqua]' + randomitemfromarray(['plump','plush','protruding','swollen']) + '[/color] [color=aqua]lips[/color] draw the eye just by glancing at $him. ',
		massive = '$He has a pair of [color=aqua]lips[/color] that are [color=aqua]' + randomitemfromarray(['massive','awe-inspiring','incredibly puffed-up']) + '[/color] to the point that a speech impediment is inevitable. ',
		monstrous = '$His [color=aqua]' + randomitemfromarray(['monstrous','almost immobile','almost unusable','incredibly swollen']) + '[/color] [color=aqua]lips[/color] are so large that $he almost is unable to speak as parting them seems strenuous. ',
		facepussy = '$His [color=aqua]' + randomitemfromarray(['unnaturaly','immobile','unusable','throbbing']) + '[/color] [color=aqua]lips[/color] are so large $he is unable to speak any longer. $He no longer has working lips, rather a flushed, moist face-pussy. ',
	},
	hairlength = {
		ear = '$His [color=aqua][haircolor][/color] hair is cut [color=aqua]short[/color]. [hairstyle]',
		neck = '$His [color=aqua][haircolor][/color] hair falls down to just [color=aqua]below $his neck[/color]. [hairstyle]',
		shoulder = '$His wavy [color=aqua][haircolor][/color] hair is [color=aqua]shoulder length[/color]. ',
		waist = '$His gorgeous [color=aqua][haircolor][/color] hair [color=aqua]sways down to $his waist[/color]. [hairstyle]',
		hips = '$His [color=aqua][haircolor][/color] hair cascades down, [color=aqua]reaching $his hips[/color]. [hairstyle]',
		bald = '', #/Capitulize
	},
	hairstyle = {
		straight = 'It [color=aqua]hangs freely[/color] from their head. ',
		ponytail = 'It is tied in a [color=aqua]high ponytail[/color]. ',
		twintails = 'It is managed in girly [color=aqua]twin-tails[/color]. ',
		braid = 'It is combed into a single [color=aqua]braid[/color]. ',
		'two braids' : 'It is combed into [color=aqua]two braids[/color]. ',
		bun = "It is tied into a neat [color=aqua]bun[/color]. ",
		bald = '$His head is absent any visible hair. ', #/Capitulize (Aric Added)
	},
	eyecolor = {
		default = '$His eyes are [color=aqua][eyecolor][/color]. ',
	},
	eyeshape = {
		normal = "",
		slit = "$He has [color=aqua]vertical, animalistic pupils[/color]. "
	},
	#ralph2
	eyesclera = {
		normal = "",
		yellow = 'Instead of whites, the sclera of $his eyes are entirely [color=aqua]yellow[/color]. ',
		green = 'Instead of whites, the sclera of $his eyes are entirely [color=aqua]green[/color]. ',
		black = 'Instead of whites, the sclera of $his eyes are entirely [color=aqua]black[/color]. ',
		red = 'Instead of whites, the sclera of $his eyes are entirely [color=aqua]red[/color]. ',
		glowing = '$His eyes glow with some luminous power. ',
		#default = 'Instead of whites, the sclera of $his eyes are entirely [color=aqua][eyesclera][/color]. ', #displays "[eyesclera]" instead of the color
	},
	#/ralph2
	horns = {
		none = '',
		short = 'There is a pair of [color=aqua]tiny, pointed horns[/color] on top of $his head. ',
		'long_straight' : '$He has a pair of [color=aqua]long, bull-like horns[/color]. ',
		curved = 'There are [color=aqua]curved horns[/color] coiling around $his head. ',
		manyhorned = 'There are [color=aqua]many horns[/color] along $his head. ',
	},
	ears = {
		human = '',
		short_furry = '$He has a pair of fluffy, [color=aqua]medium-sized animal-like ears[/color]. ',
		short_reptilian = '$He has a pair of scaled, [color=aqua]medium-sized reptilian-like ears[/color]. ',
		long_pointy_furry = '$He has a pair of fluffy, [color=aqua]lengthy, animal-like ears[/color]. ',
		long_pointy_reptilian = '$He has a pair of scaled, [color=aqua]lengthy, reptilian-like ears[/color]. ',
		pointy = '$He has quite long, [color=aqua]pointed[/color] ears. ',
		frilled = '$He has reptilian frills on the sides of $his head that act as ears. ',
		none = '$He has no ears. ',
		long_round_furry = '$He has a pair of [color=aqua]standing bunny ears[/color] rising above $his head. ',
		long_round_reptilian = '$He has a pair of [color=aqua]standing reptilian ears[/color] rising above $his head. ',
		long_droopy_furry = '$He has a pair of [color=aqua]droopy, bunny ears[/color] on $his head. ',
		long_droopy_reptilian = '$He has a pair of [color=aqua]droopy, reptilian ears[/color] on $his head. ',
		feathery = "There's a pair of clutched [color=aqua]feathery ears[/color] on the sides of " + '$his head. ',
		wide_furry = '$He has a pair of big, wide [color=aqua]animal-like ears[/color]. ',
		fins = '$His ears look like a pair of [color=aqua]fins[/color]. ',
		avali = '$He has two pairs of [color=aqua]lengthy, animal-like ears[/color] ears, one pair pointed above the head while the other pair dropping low below the neck. ',
	},
	skin = {
		none = '',
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
		scales = '$His skin is partly covered with [color=aqua][scalecolor] scales[/color]. ',
		feathers = '$His body is covered in [color=aqua][feathercolor] bird-like feathers[/color] in many places. ',
		feathers_and_fur = '$His body is sparsely covered with [color=aqua][feathercolor] bird-like feathers[/color]. Beneath that is thick, soft [color=aqua]fur of [furcolor]',
		fullscales = '$His body is covered with [color=aqua][scalecolor] scales[/color]. ',
		fullfeathers = '$His body is covered with [color=aqua][feathercolor] feathers[/color]. ',
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
		blue = 'deep blue tone[/color]. ', # Capitulize
		whiteandpink = 'white and pink color[/color]. ',
		'guardian white' : 'a glowing white color, tattooed with tribal magical runes[/color]. ',
	},
	feathercolor = { # feather color
		default = '[feathercolor]',
	},
	scalecolor = {
		default = '[scalecolor]',
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
		leather_green = 'Hidden on $his back is a pair of bat-like, [color=aqua]green leather wings[/color]. ',
		leather_white = 'Hidden on $his back is a pair of bat-like, [color=aqua]white leather wings[/color]. ',
		leather_blue = 'Hidden on $his back is a pair of bat-like, [color=aqua]blue leather wings[/color]. ',
	},
	tail = {
		none = '',
		cat = 'Below $his waist, you spot a slim [color=aqua]cat tail[/color] covered with fur. ',
		fox = '$He has a large, fluffy [color=aqua]fox tail[/color]. ',
		neko = 'Below $his waist, you spot a slim [color=aqua]cat tail that splits into two[/color] covered with fur. ',
		hyena = '$He has a large, matted [color=aqua]hyena tail[/color]. ',
		wolf = "Below $his waist there's a short, fluffy, [color=aqua]wolf tail[/color]. ",
		bunny = '$He has a [color=aqua]small ball of fluff[/color] behind $his rear. ',
		racoon = '$He has a plump, fluffy [color=aqua]raccoon tail[/color]. ',
		scruffy = 'Behind $his back you notice a long tail covered in a thin layer of fur which ends in a [color=aqua]scruffy brush[/color]. ',
		demon = '$He has a long, thin, [color=aqua]demonic tail[/color] ending in a pointed tip. ',
		dragon = 'Trailing somewhat behind $his back is a spiky [color=aqua]draconic tail[/color]. ',
		bird = '$He has a [color=aqua]feathery bird tail[/color] on $his rear. ',
		fish = '$His rear ends in long, sleek [color=aqua]fish tail[/color]. ',
		otter = '$He has a slender, sleek[color=aqua] otter tail[/color]. ', # Capitulize
		squirrel = '$He has a huge, fluffy[color=aqua] squirrel tail[/color]. ',
		reptilian = 'Trailing somewhat behind $his back is a [color=aqua]scaled tail[/color]. ',
		"snake tail" : '',
		tentacles = '',
		horse = '',
		"spider abdomen" : '',
		mouse = 'Below $his waist, you spot a slim [color=aqua]mouse tail[/color] covered in a fine thin layer of fuzz. ',
		avali = 'Trailing behind $his waist, you see a very long [color=aqua]avali tail[/color] with feathers at the base and a large feather at the tip. ',
	},
	height = {
		tiny = '$His stature is [color=aqua]' + randomitemfromarray(['extremely small','tiny','itty bitty']) + '[/color], barely half the size of a normal person. ',
		petite = '$His stature is quite [color=aqua]' + randomitemfromarray(['thin and small','petite','little']) + '[/color]. ',
		short = '$His height is quite [color=aqua]' + randomitemfromarray(['short','small','slight']) + '[/color]. ',
		average = '$He is of [color=aqua]' + randomitemfromarray(['average','normal']) + '[/color] height. ',
		tall = '$He is quite [color=aqua]' + randomitemfromarray(['tall','large','big']) + '[/color] compared to the average members of $his race. ',
		towering = '$He is unusually tall, [color=aqua]' + randomitemfromarray(['towering','looming']) + '[/color] over others. ',
	},
	titssize = {
		masculine = '$His [color=yellow]chest[/color] is of definitive [color=yellow]' + randomitemfromarray(['masculine','manly']) + '[/color] shape. ',
		flat = '$His [color=yellow]chest[/color] is barely visible and [color=yellow]' + randomitemfromarray(['flat','nearly nonexistant']) + '[/color]. ',
		small = '$He has [color=yellow]' + randomitemfromarray(['small','tiny','miniscule','perky']) + '[/color], round [color=yellow]' + nameTits() + '[/color]. ',
		average= '$His nice, [color=yellow]' + randomitemfromarray(['average','nice','perky','decent']) + '[/color] [color=yellow]' + nameTits() + '[/color] are firm and inviting. ',
		big = '$His [color=yellow]' + randomitemfromarray(['big','sizable','large']) + '[/color] [color=yellow]' + nameTits() + '[/color] are pleasantly soft, but still have a nice spring to them. ',
		huge = '$His [color=yellow]' + nameTits() + '[/color] are [color=yellow]' + randomitemfromarray(['huge','well developed','enviable','really big']) + '[/color]. ',
		incredible = '$His [color=yellow]' + randomitemfromarray(['voluptuous','rather huge','incredible']) + '[/color] [color=yellow]'+ nameTits() + '[/color] are mind-blowingly big. ',
		massive = '$His [color=yellow]' + randomitemfromarray(['massive','inhuman','watermelon-sized']) + '[/color] [color=yellow]'+ nameTits() + '[/color] are almost too large for $him to function normally. ',
		gigantic = '$His [color=yellow]' + randomitemfromarray(['gigantic','unbelievable','chest encompassing']) + '[/color] [color=yellow]'+ nameTits() + '[/color] are so large that they impedes $his daily life. ',
		monstrous = '$His [color=yellow]' + randomitemfromarray(['monstrous','insanely heavy','pregnant belly sized']) + '[/color] [color=yellow]'+ nameTits() + ' [/color] are so big that $he can barely walk and has to crawl. ',
		immobilizing = '$His [color=yellow]' + randomitemfromarray(['unbelievable','rather huge','incredible']) + '[/color] [color=yellow]'+ nameTits() + '[/color] are mind-blowingly big. ',
	},
	asssize = {#ass strings
		flat = '$His [color=aqua]' + nameAss() + '[/color] is skinny and [color=aqua]flat[/color]. ',
		small = '$He has a [color=aqua]small[/color], firm [color=aqua]' + nameAss() + '[/color]. ',
		average= '$He has a nice, [color=aqua]pert[/color] [color=aqua]' + nameAss() + '[/color] you could bounce a coin off. ',
		big = '$He has a pleasantly [color=aqua]plump[/color], heart-shaped [color=aqua]' + nameAss() + '[/color] that jiggles enticingly with each step. ',
		huge = '$He has a [color=aqua]huge[/color], attention-grabbing [color=aqua]' + nameAss() + '[/color]. ',
		masculine = '$His [color=aqua]' + nameAss() + '[/color] definitively has a [color=aqua]masculine[/color] shape. ',
	},
	balls = {
		micro = '$His [color=yellow]' + nameBalls() + '[/color] are so [color=yellow]' + randomitemfromarray(['microscopic','tiny','little','miniscule']) + '[/color] that it is almost non-existant. ',
		tiny = '$He has some [color=yellow]' + randomitemfromarray(['tiny','little','very small']) + '[/color] [color=yellow]' + nameBalls() + '[/color] dangling between $his legs. ',
		small = '$He has a pair of [color=yellow]tiny[/color] [color=yellow]' + nameBalls() + '[/color]. ',
		average = '$He has an [color=yellow]average-sized[/color] [color=yellow]' + nameBalls() + '[/color]. ',
		large = '$He has a [color=yellow]huge[/color] pair of [color=yellow]' + nameBalls() + '[/color] weighing $him down. ',
		massive = '$He has some [color=yellow]' + randomitemfromarray(['truly massive','gigantic','magnificent','outrageously big']) + '[/color] [color=yellow]' + nameBalls() + '[/color] dangling between $his legs. ',
	},
	###---Added by Expansion---### Sizes Expanded
	vagina = {
		impenetrable = 'an [color=yellow]impenetrable[/color] [color=yellow]' + namePussy() + '[/color] that looks like it would rip even trying to fit a finger inside.',
		tiny = 'a [color=yellow]tiny[/color] [color=yellow]' + namePussy() + '[/color] that would very snugly squeeze a finger put inside of it. ',
		tight = '$his [color=yellow]tight[/color], little [color=yellow]' + namePussy() + '[/color] that almost looks like it is still virginal. ',
		average = '$his pink, completely [color=yellow]average[/color] [color=yellow]' + namePussy() + '[/color]. ',
		loose = 'an unfortunately [color=red]loose[/color] [color=yellow]' + namePussy() + '[/color] that looks like it has seen some use. ',
		gaping = '$his [color=red]gaping[/color] [color=yellow]' + namePussy() + '[/color], so spread open that you can almost see $his cervix. ',
		normal = '$his currently [color=red]undefined[/color] [color=yellow]' + namePussy() + '[/color]. \nYou are sure you will understand it better tomorrow. ',
	},
	asshole = {
		impenetrable = 'an [color=yellow]impenetrable[/color] [color=yellow]' + nameAsshole() + '[/color] that looks like it would rip even trying to fit a finger inside.',
		tiny = 'a [color=yellow]tiny[/color] [color=yellow]' + nameAsshole() + '[/color] so small that it was hard to even find it between $his cheeks. ',
		tight = '$his [color=yellow]tight[/color] little [color=yellow]' + nameAsshole() + '[/color] that looks like it has never been used for sex or anything else. ',
		average = '$his completely [color=yellow]average[/color] [color=yellow]' + nameAsshole() + '[/color] ',
		loose = 'a surprisingly [color=yellow]loose[/color] [color=yellow]' + nameAsshole() + '[/color] that looks like it has seen some use. ',
		gaping = '$his massive, [color=yellow]gaping[/color] [color=yellow]' + nameAsshole() + '[/color] that is so wide it looks like the side walls of his asshole make a red flower. ',
		normal = '$his currently [color=yellow]undefined[/color] [color=yellow]' + nameAsshole() + '[/color]. \nYou are sure you will understand it better tomorrow. ',
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
