### <CustomFile> ###

extends Node

var person

###Color Guide
#Location: [color=#947C44] [/color]
#Response: \n\n[color=yellow] [/color]
#Object of Interest: [color=green] [/color]
#Negative: [color=red] [/color]
#Liquid/Item: [color=aqua] [/color]
#Sexual: [color=#FFD5CF] [/color]
#Cum/Milk: [color=#E0D8C6] [/color]

#text += "\n[color=yellow]-" + str(responseExample(person)) + "[/color]"

#Still Need = Finish Stance, both Convo Events (check and get)
#Then: Finish Intros, then work on Talk/Convos, then Choices, then Responses

#Convo Path: Intro (Dialogue Only), Player Selects Button, Button Reaction is Checked, Slave Accepts/Refuses (one more Player Input) or Reacts, back to Hub

###Randomly choose the name for "Master" each Convo
func getMasterName(person):
	var names = []
	var related = ''
	var text = ''
	#Begin
	names.clear()
	related = globals.expansion.relatedCheck(globals.player, person)
###Normal
	if globals.player.sex == 'male':
		names.append('Master')
		names.append('Master')
		names.append('Sir')
		names.append('Sir')
		names.append('Lord')
		if person.age == 'child':
			names.append('Mister')
		elif person.age == 'teen':
			names.append('Dude')
			names.append('Mister')
			names.append('Master')
		elif person.age == 'adult':
			names.append('Sir')
			names.append('Master')
	else:
		names.append('Mistress')
		names.append('Mistress')
		names.append('Madam')
		names.append('Madam')
		names.append('Lady')
		if person.age == 'child':
			names.append('Miss')
			names.append("Ma'am")
			names.append('Mistress')
			names.append('Madam')
		elif person.age == 'teen':
			names.append("Ma'am")
			names.append('Lady')
			names.append('Woman')
			names.append('Mistress')
			names.append('Madam')
		elif person.age == 'adult':
			names.append('Mistress')
			names.append('Madam')
###Stats
	if person.loyal >= 80:
		names.append('my Master')
		names.append('beloved Master')
		names.append('my Hero')
		names.append('noble Master')
	if person.obed > 50:
		if globals.player.sex == 'male':
			names.append('Master')
			names.append('Master')
			names.append('Sir')
			names.append('Sir')
		else:
			names.append('Mistress')
			names.append('Mistress')
			names.append('Madam')
			names.append('Madam')
	if person.lust > 50:
		names.append('Sexy')
		names.append('Sexy')
		names.append('Cutie')
		if globals.player.sex == 'male':
			names.append('Handsome')
			names.append('Tiger')
		elif globals.player.sex == 'female':
			names.append('Beautiful')
###Racial
	if person.race == 'Taurus' || person.traits.has('Cow'):
		names.append('Moooster')
		names.append('Moooo- sorry...mooaaaster')
	if person.race.find('Cat') >= 0:
		names.append('Meowster')
		names.append('Purrfect Moewster')
	if person.race.find('Wolf') >= 0:
		names.append('Pack Leader')
		names.append('Alpha')
	if person.race.find('Lamia') >= 0:
		names.append('Masssssster')
		names.append('Mmmasssssster')
	if person.race.find('Elf') >= 0:
		names.append('Sire')
		names.append('Your Majesty')
		names.append('Monarch')
		names.append('Your Excellency')
	if person.race.find('Scylla') >= 0 || person.race.find('Nereid') >= 0:
		names.append('Kingfish')
		names.append('Triton')
		names.append('Avatar of Poseidon')
	if person.race.find('Orc') >= 0:
		names.append('Tribe-Leader')
		names.append('Chieftain')
		names.append('Shaman')
		names.append('Master Shaman')
	if person.race.find('Goblin') >= 0:
		names.append('Burrow-Master')
		names.append('Cave-Leader')
		names.append('Chieftain')
	if person.race.find('Arachnid') >= 0:
		if globals.player.sex == 'male':
			names.append('Broodfather')
		else:
			names.append('Broodmother')
	if person.race.find('Seraph') >= 0:
		names.append('Arch-Angel')
		names.append('Host')
	if person.race.find('Demon') >= 0:
		names.append('Unholy Host')
		names.append('Profane Master')
	if person.race.find('Dragonkin') >= 0:
		names.append('Talon-Lord')
		names.append('Mightybreath')
		names.append('Dovah')
		names.append('Dovahkin')
	if person.race.find('Dark Elf') >= 0:
		names.append('Tyrant')
		names.append('Your Majesty')
		if globals.player.sex == 'male':
			names.append('Patriach')
		else:
			names.append('Matriach')
	if person.race.find('Slime') >= 0:
		names.append('Oozemaster')
		names.append('Slimelord')
	if person.race.find('Harpy') >= 0:
		if globals.player.sex == 'male':
			names.append('Nestfather')
		else:
			names.append('Nestmother')
		names.append('Strongbeak')
		names.append('Talonlord')
#Statuses
#"Valued" Statuses
	if person.mind.status == 'Lover':
		if rand_range(0,1) > .6:
			names.clear()
		names.append('Beloved')
		names.append('Lover')
		names.append('my Heart')
		names.append('Sweetheart')
		names.append('Honey')
	if person.mind.status == 'Friend':
		if rand_range(0,1) > .25:
			names.clear()
		names.append('Pal')
		names.append('Friend')
		names.append('Buddy')
		names.append('Dude')
	if person.mind.status == 'Trophy':
		names.append('Honey')
		if globals.player.sex == 'male':
			names.append('Master')
			names.append('Sugar-Daddy')
			names.append('Mister')
		else:
			names.append('Mistress')
			names.append('Sugar-Mommy')
			names.append('Miss')
	if person.mind.status == 'Socialite':
		names.append('Boss')
		if globals.player.sex == 'male':
			names.append('Sire')
			names.append('my charming Master')
			names.append('Prince Charming')
		else:
			names.append('my charming Mistress')
			names.append('Dame')
	if person.mind.status == 'Warrior' && person.consentexp.party == true:
		if rand_range(0,1) > .25:
			names.clear()
		names.append('Commander')
		names.append('Mage Commander')
		names.append('Commandant')
#Property Statuses
	if person.mind.status == 'Fucktoy':
		if rand_range(0,1) > .25:
			names.clear()
		if globals.player.penis != 'none':
			names.append('Cock-Lord')
			names.append('you well-endowed Hunk')
		names.append('Sexy')
		names.append('Desirable')
	if person.mind.status == 'Baby-Maker':
		if rand_range(0,1) > .25:
			names.clear()
		names.append('Master Breeder')
		names.append('Breeding Master')
		if globals.player.sex == 'male':
			names.append('Baby-Father')
			names.append('Child Rearer')
		else:
			names.append('Baby-Mother')
			names.append('Child Rearer')
	if person.mind.status == 'Laborer':
		if rand_range(0,1) > .25:
			names.clear()
		names.append('Boss')
		names.append('Owner')
		names.append('Slave-Driver')
		names.append('Master')
	if person.mind.status == 'Auction Meat':
		if rand_range(0,1) > .25:
			names.clear()
		names.append('Master for now')
		names.append('temporary Master')
		names.append('Owner')
	if person.mind.status == 'Worthless':
		if rand_range(0,1) > .25:
			names.clear()
		names.append('Owner')
		names.append('Owner')
		names.append('Slaver')
		names.append('Slaver')
		#Consent Additions
	if person.consentexp.party == true:
		names.append('Leader')
		names.append('Commander')
	if person.consentexp.pregnancy == true:
		if globals.player.sex in ['male','futanari']:
			names.append('Baby-Daddy')
			names.append('Big Baby-Daddy')
			names.append('Baby-Dad')
			if person.traits.has('Ditzy') || person.mind.flaw == 'greed':
				names.append('Sugar Daddy')
				names.append('Daddy-kins')
		if globals.player.sex in ['female','futanari']:
			names.append('Baby-Mommy')
			names.append('Big Momma')
			names.append('Baby-Mum')
			if person.traits.has('Ditzy') || person.mind.flaw == 'greed':
				names.append('Mommy-kins')
				names.append('Sugar Momma')
#Family (Status or Related)
	if person.mind.status == 'Family' || related != 'unrelated':
		if rand_range(0,1) > .6:
			names.clear()
		if related == 'son' || related == 'daughter':
			if globals.player.sex == 'male':
				if person.age == 'child':
					names.append('Daddie')
					names.append('Dad')
					names.append('Papa')
				if person.age == 'teen':
					names.append('Pops')
					names.append('Papa')
					names.append('Pop')
					names.append('Father')
					names.append('Papa')
					names.append('Dad')
				if person.age == 'adult':
					names.append('Dad')
					names.append('Dad')
					names.append('Father')
				if person.vagina != 'none':
					names.append('Daddie')
					names.append('Daddie')
				if person.penis != 'none':
					names.append('Sir')
					names.append('Dad')
				if rand_range(0,1) > 0.5:
					names.append('Da')
					names.append('Pa')
					names.append('Abba')
			elif globals.player.sex == 'female':
				if person.age == 'child':
					names.append('Mommie')
					names.append('Mom')
					names.append('Mama')
					names.append('Mum')
				if person.age == 'teen':
					names.append('Mom')
					names.append('Mum')
					names.append('Mama')
					names.append('Mother')
				if person.age == 'adult':
					names.append('Mom')
					names.append('Mom')
					names.append('Mum')
					names.append('Mother')
		elif related == 'brother' || related == 'sister':
			if globals.player.sex == 'male':
				names.append('Brother')
				names.append('Brother')
				names.append('Brother')
				names.append('Bro')
				names.append('Bro')
				names.append('Bro')
			elif globals.player.sex == 'female':
				names.append('Sister')
				names.append('Sister')
				names.append('Sister')
				names.append('Sis')
				names.append('Sis')
				names.append('Sis')
		elif related == 'mother' || related == 'father':
			if globals.player.sex == 'male':
				names.append('Son')
			elif globals.player.sex == 'female':
				names.append('Daughter')
	###Negatives
	if person.fear < 20 && person.obed < 30:
		names.append('Asshole')
		names.append('Fuck-Face')
		names.append('Prick')
	if person.consent == false && person.metrics.sex > 0 && rand_range(0,1) >= 0.25:
		if rand_range(0,1) > .3:
			names.clear()
		names.append('Rapist')
		names.append('Rapist')
		names.append('Rapist Prick')
		names.append('Rapist Asshole')
	#Captured
	var captured
	for i in person.effects.values():
		if i.code == 'captured':
			captured = true
	if captured == true:
		names.clear()
		names.append('Monster')
		names.append('Asshole')
		names.append('Prick')
		names.append('Cocksucker')
		names.append('you slaver piece of shit')
		names.append('Fucker')
		names.append('Mas-monster')
		names.append('Maste-Wait, no, Fucker.')
		names.append('you piece of shit')
		names.append('god-damned slaver')
		names.append('slaving bastard')
		names.append('Bastard')
	#Mute/Silent check
	if person.traits.has('Mute'):
		names.clear()
		names.append('Mmmmph')
		names.append('...')
		names.append('Mmm')

	text = globals.randomitemfromarray(names)
	#Quick Fix to stop "Null" names
	if text == null:
		if globals.player == 'male':
			text = "Master"
		else:
			text = "Mistress"
	person.masternoun = str(text)

var difficultyarray = ['None','Simple','Easy','Medium','Hard','Impossible']
var chatchecktypearray = ['degrading','lewd','respectful']

func chatCheck(person,type,difficulty):
	var roll = 0
	var diff = 20*difficultyarray.find(difficulty)
	var result = "failure"

	#Roll the relevant check (Max should be around 100 per)
	if type == "respectful":
	#check the daysowned metric
		roll = (person.loyal*.5) + (person.obed*.25) + (person.metrics.ownership*2) + (person.respect*.2)
	elif type == "degrading":
		roll = (person.fear*.5) + (person.obed*.25) + (person.loyal*.2) + (person.humiliation*.2)
	elif type == "lewd":
		roll = (person.lewd*.5) + (person.lust*.25) + (person.loyal*.2) + (person.obed*.2)
	else:
		result = "failure"

	if roll >= diff:
		result = "success"
	elif roll >= 20*(difficultyarray.find(difficulty)-1):
		result = "success"
		person.stress += diff-roll
	elif roll >= 20*(difficultyarray.find(difficulty)-2):
		result = "barter"
	else:
		result = "failure"

	return result

#---Quirk Text Replacers---#
func quirkCursing(text):
	if rand_range(0,1) >= .5:
		text = ' ' + str(globals.randomitemfromarray(['fuck','shit','fucking','motherfucker','shitballs','cocksucker','damn','damn','twat','cunt'])) + ' '
	return text

func quirkDitzy(text):
	if rand_range(0,1) >= .5:
		text = ' ' + str(globals.randomitemfromarray(['-like-','-and, uh-','-and, like-','-uh-','-uhhh','...like...'])) + ' '
	return text

func quirkCat(person,text):
	if rand_range(0,1) >= .5:
		if person.mood in ['happy','horny']:
			text = ' ' + str(globals.randomitemfromarray(['*purr*','*puuurr*','*puuurrrr*','*nya*'])) + ' '
		elif person.mood == "sad":
			text = ' ' + str(globals.randomitemfromarray(['*whine*','*meow*','*moew*'])) + ' '
		elif person.mood == "angry":
			text = ' ' + str(globals.randomitemfromarray(['*hiss*','*hissss*','*sssss*'])) + ' '
	return text

func quirkDog(person,text):
	if rand_range(0,1) >= .5:
		if person.mood in ['happy','horny']:
			text = ' ' + str(globals.randomitemfromarray(['*YIP*','*BARK*','*YIP-YIP*','*WOOF*'])) + ' '
		elif person.mood == "sad":
			text = ' ' + str(globals.randomitemfromarray(['*whine*','*whimper*'])) + ' '
		elif person.mood == "angry":
			text = ' ' + str(globals.randomitemfromarray(['*grrr*','*grrrrr','growl'])) + ' '
	return text

func quirkCrying(text):
	if rand_range(0,1) >= .5:
		text = ' ' + str(globals.randomitemfromarray(['*sniff*','*sob*','*cough*','*-sob-sniff-sob-*'])) + ' '
	return text

#---End Quirk Text Replacers---#

###---Barter Text---###

func buttonTextPride(person):
	var text = str(globals.randomitemfromarray(['Here I thought you, of all people, could handle it.','I guess that is too much for you','That a bit too much for you to handle?']))
	return text

func buttonTextEnvy(person):
	var text = str(globals.randomitemfromarray(["I should have asked a more professional slave","I should have asked a better slave","I should have asked someone else","Other slaves could handle it..."]))
	return text

func buttonTextWrath(person):
	var text = str(globals.randomitemfromarray(["Aww, you can't handle it.","Haha, I guess it is too much for you","No problem, you can't handle it. I get it."]))
	return text

func buttonTextLust(person):
	var text = str(globals.randomitemfromarray(["Aww, not even for me, sugar?","But you'd look so good...","It'd be really hot!","It'd make me SUPER happy *lip bite*"]))
	return text

func buttonTextGreed(person):
	var text = str(globals.randomitemfromarray(["How about some gold to whet your whistle?","How'd you like to make some gold?","It'll be worth your while","Would you do it for gold?"]))
	return text

#func buttonTextGluttony(person):
#	var text = str(globals.randomitemfromarray(["How about some " +str(person.diettype)+ " to whet your whistle?","How'd you like some " +str(person.diettype)+ "?","It'll be worth your while. I have " +str(person.diettype)+".","Would you do it for " +str(person.diettype)+ "?"]))
#	return text

func buttonTextSloth(person):
	var text = str(globals.randomitemfromarray(["If you do it, I'll give you a day off","How'd you like the day off?","It'll be worth your while. I will let you relax today.","Would you do it for a day off?"]))
	return text

#---Barter Text End---#

#---Intros---#
#2-3 each for: ['sad','angry','scared','indifferent','obediant','horny','respectful','happy','playful']
#2-3 each for: Flaws
#That gives between 4-6 choices per person

func introGeneral(person):
	var text = ""
	var choice = []
	###---Add Flaws later

	if person.mood == 'playful':
		choice.append("Well if it isn't my favorite $master!")
		choice.append("Well what are the chances of bumping into you here, $master?")
		choice.append("Well, I didn't know you came here too! *giggle*")
	if person.mood == 'happy':
		choice.append("Hey, $master! Good to see you!")
		choice.append("How is it going, $master?")
		choice.append("How are you on this great day, $master?")
		choice.append("How are you on this lovely day, $master?")
	if person.mood == 'respectful':
		choice.append("$master, how can I help you?")
		choice.append("What can I do for you, $master?")
		choice.append("$master?")
	if person.mood == 'horny':
		choice.append("Mmm...looking good today, $master...")
		choice.append("You...you are looking good, $master...")
		choice.append("$master, do you...think my " +str(globals.expansion.nameAss())+" looks good?")
		choice.append("$master, do you...think my " +str(globals.expansion.getGenitals(person))+" look good...enough to fuck?")
	if person.mood == 'obediant':
		choice.append("It is my pleasure to serve you, $master")
		choice.append("I will serve, $master, however I can.")
		choice.append("How may I serve, $master?")
	if person.mood == 'indifferent':
		choice.append("Yes, $master?")
		choice.append("Yeah? What's up, $master?")
		choice.append("Mmhmm?")
	if person.mood == 'scared':
		choice.append("W...w...what do you want, $master?")
		choice.append("D-do you...need me for something?")
		choice.append("What did I do, $master?")
	if person.mood == 'angry':
		choice.append("Yeah? What do you want?")
		choice.append("What?")
		choice.append("What do you want?")
		choice.append("I'm not going to call you $master. What do you want?")

	choice.append("What's up?")
	choice.append("What is going on?")

	text = globals.randomitemfromarray(choice)
	return text

func introStrip(person):
	var text = ""
	var choices = []
	if person.mind.demeanor in ['meek','shy']:
		choices.append('Talk about...my clothing?')
		choices.append('What...what I am wearing?')
		choices.append('Why do you want to talk about what I am wearing?')
	elif person.mind.demeanor == "reserved":
		choices.append('What about my clothing?')
		choices.append('My clothing?')
		choices.append('What I am wear? Okay, I guess...')
	if person.mind.demeanor in ['open','excitable']:
		choices.append('Okay, cool! Lets talk!')
		choices.append('What do you want to talk about?')
		choices.append('My clothes? Do you like them? Should I wear more? Less?')
	if person.exposed.chest == true && person.exposed.chestforced == false:
		choices.append('Can I cover up my ' + str(globals.expansion.getChest(person)) + "?")
	elif person.exposed.chest == true && person.exposed.chestforced == true:
		choices.append('Why did you ruin my shirt?')
		choices.append('Why can I not wear a shirt?')
		choices.append('Why did you take away my shirt?')
	if person.exposed.genitals == true && person.exposed.genitalsforced == false:
		choices.append('Can I cover up my ' + str(globals.expansion.getGenitals(person)) + "?")
	elif person.exposed.genitals == true && person.exposed.genitalsforced == true:
		choices.append('Why did you ruin my pants?')
		choices.append('Why can I not wear a pants?')
		choices.append('Why did you take away my pants?')
	if person.exposed.ass == true && person.exposed.assforced == false:
		choices.append('Can I cover up my ' + str(globals.expansion.nameAsshole()) + "?")
	elif person.exposed.ass == true && person.exposed.assforced == true:
		choices.append('Why did you ruin my pants?')
		choices.append('Why can I not wear anything to cover up my ass?')
		choices.append('Why did you take away my pants?')
	text = globals.randomitemfromarray(choices)
	return text

func consentPartyAccept(person):
	var text = ""
	var choice = []
	###---Add Flaws later

	if person.mood == 'playful':
		choice.append("Yeah, sure! I'll travel alongside you, $master!")
		choice.append("What do you think we'll find, $master?")
		choice.append("Oooh, do you think I'll become a mighty warrior? *giggle*")
	if person.mood == 'happy':
		choice.append("Sure, $master! I'll come with you!")
		choice.append("Thanks for thinking of me, $master! Of course I'll come!")
		choice.append("Sounds fun! Let's go!")
		choice.append("Sounds like a lovely way to spend time together!")
	if person.mood == 'respectful':
		choice.append("$master, if that is your will. I will come.")
		choice.append("I will follow your lead, $master.")
		choice.append("Yes, $master. I'll come along.")
	if person.mood == 'horny':
		choice.append("Mmm...are we going to get more slaves? What are you going to do with them? Can...I watch?")
		choice.append("Sounds...enticing. I'm ready whenever you are, $master.")
		choice.append("Walking will do wonders for my " +str(globals.expansion.nameAss())+". Why not?")
	if person.mood == 'obediant':
		choice.append("Yes, $master. I am yours to command.")
		choice.append("I will serve, $master, even outside of these walls.")
		choice.append("I will come with you and serve you in battle, $master.")
	if person.mood == 'indifferent':
		choice.append("Sure, whatever. I'll come along.")
		choice.append("Traveling? Fighting? Alright...")
		choice.append("Sure thing, $master. Ready when you are.")
		choice.append("Alright then, I guess I'll fight for you. Tell me when you want me to travel with you.")
	if person.mood == 'scared':
		choice.append("O-o-okay $master...if that's what you want...")
		choice.append("I...guess I'll travel with you. Just...watch out for me?")
		choice.append("Go...outside? And fight? If you promise to p-protect m-me!")
	if person.mood == 'angry':
		choice.append("Yeah? Fine, I'll fight for you. Not like I have a choice...")
		choice.append("Anything to get out of here...")
		choice.append("Sure, whatever. We going now?")
		choice.append("You want me to enslave others for you? Fine, whatever. Better to be at the top of the wheel than beneath it, I suppose.")
	choice.append("Yes, $master, I'll travel with you!")
	choice.append("Yes, $master, I'll fight for you!")
	text = globals.randomitemfromarray(choice)
	return text

func consentPartyRefuse(person):
	var text = ""
	var choice = []
	if person.mood == 'playful':
		choice.append("You really think that I'd risk my life alongside you?")
		choice.append("But what could I possibly get out of that, huh?")
	if person.mood == 'happy':
		choice.append("I would really rather not if that's okay...")
		choice.append("Thanks for the offer but...do I have to?")
	if person.mood == 'respectful':
		choice.append("I appreciate that you think that I'm ready for that, but I don't think that I am...")
		choice.append("If you want to force me to, you can $master, but if you want my consent...I'm not ready yet.")
	if person.mood == 'horny':
		choice.append("What? Run out and get myself killed? Why would I do that when I could stay here and fuck?")
		choice.append("Wouldn't it be much better if I waited for you here in your bedroom?")
	if person.mood == 'obediant':
		choice.append("If you want me to I would have to...but please don't make me fight $master...")
		choice.append("Thank you for asking me, $master. I am honored. I would rather not fight.")
	if person.mood == 'indifferent':
		choice.append("Why would I want to do that?")
		choice.append("What? Nah. No thanks.")
		choice.append("Hah! You think I'd risk my life alongside you? Dream on.")
	if person.mood == 'scared':
		choice.append("Me? Fight? I...um...Ahh! No!")
		choice.append("Fight? I'll get killed for sure! Please no!")
		choice.append("I can't...fight...*whimper*")
	if person.mood == 'angry':
		choice.append("You want me to fight for you? I'd be more likely to fight you!")
		choice.append("Fight for you? Fuck off. $master.")
		choice.append("Fight by your side? Hahahahaha...no.")
	choice.append("I really don't want to fight, $master.")
	choice.append("I appreciate you asking me. I don't think I'm ready to fight alongside you.")
	choice.append("I'm not ready yet. Please respect that.")
	choice.append("Maybe...one day. But not today.")
	text = globals.randomitemfromarray(choice)
	return text

func consentStudAccept(person):
	var text = ""
	var choice = []
	###---Add Flaws later

	if person.mood == 'playful':
		choice.append("Yeah, sure! I can't wait to stick it in one of your girls, $master!")
		choice.append("Yeah, sure! I can't wait to "+str(globals.expansion.nameBreed())+" one of your girls, $master!")
		choice.append("Ooh, do I get to pick the girl, $master?")
		choice.append("That sounds like a lot of fun! Count me in!")
	if person.mood == 'happy':
		choice.append("Sure, $master! I'll "+str(globals.expansion.nameBreed())+" those slaves!")
		choice.append("Thanks for thinking of me, $master! Of course I'll "+str(globals.expansion.nameBreed())+" them for you!")
		choice.append("Sounds fun! I've always wanted a family!")
		choice.append("Sounds like a lovely way to spend my time! I'm in!")
	if person.mood == 'respectful':
		choice.append("$master, if that is your will. I will "+str(globals.expansion.nameCum())+" inside of them.")
		choice.append("Thank you for this gift, $master. I accept.")
		choice.append("Yes, $master. Thank you.")
	if person.mood == 'horny':
		choice.append("Oh...oh fuck yes. Thank you, $master! I want to "+str(globals.expansion.nameBreed())+" them badly. For you, of course.")
		choice.append("Sounds...enticing. I'm ready whenever you are, $master! Or whenever they are. Same thing?")
		choice.append("Yes! I mean...yes. Yes. YES! ...Yes? Shit...Yes. I will.")
	if person.mood == 'obediant':
		choice.append("Yes, $master. My "+str(globals.expansion.namePenis())+" is yours to command.")
		choice.append("I will serve, $master. Even inside of another slave.")
		choice.append("I will gladly do as you ask, $master.")
	if person.mood == 'indifferent':
		choice.append("Sure, whatever. I'll "+str(globals.expansion.nameBreed())+" some bitches for you.")
		choice.append(""+str(globals.expansion.nameBreed())+" sluts? Alright...")
		choice.append("Sure thing, $master..")
		choice.append("Alright then, I guess I'll "+str(globals.expansion.nameBreed())+" for you. Tell me when you want me to start.")
	if person.mood == 'scared':
		choice.append("O-o-okay $master...if that's what you want...")
		choice.append("Will...I have to take care of the baby? I mean, I will...but will I?")
		choice.append("I...I guess. No one will be watching us, right?")
	if person.mood == 'angry':
		choice.append("Yeah? Fine, I'll "+str(globals.expansion.nameBreed())+" for you. Not like I have a choice...")
		choice.append("Really? That's what you want from me?\nLike...really? Fucking hell...\nFine. I'll do it.")
		choice.append("Sure, whatever. We going now?")
		choice.append("You want me to "+str(globals.expansion.nameBreed())+" others for you? Fine, whatever. Better to be at the top of the wheel than beneath it, I suppose.")
	choice.append("Yes, $master, I'll "+str(globals.expansion.nameBreed())+" for you!")
	text = globals.randomitemfromarray(choice)
	return text

func consentBreederAccept(person):
	var text = ""
	var choice = []
	###---Add Flaws later

	if person.mood == 'playful':
		choice.append("Yeah, sure! I can't wait to "+str(globals.expansion.nameBeBred())+" for you, $master!")
		choice.append("Yeah, sure! I can't wait to "+str(globals.expansion.nameBeBred())+", $master!")
		choice.append("Ooh, do I get to "+str(globals.expansion.nameBeBred())+", $master?")
		choice.append("That sounds like a lot of fun! Count me in!")
	if person.mood == 'happy':
		choice.append("Sure, $master! I'll "+str(globals.expansion.nameBeBred())+" for you!")
		choice.append("Thanks for thinking of me, $master! Of course I'll "+str(globals.expansion.nameBreed())+" them for you!")
		choice.append("Sounds fun! I've always wanted a family!")
		choice.append("Sounds like a lovely way to spend my time! Sign me up to "+str(globals.expansion.nameBeBred())+"!")
	if person.mood == 'respectful':
		choice.append("$master, if that is your will. I will "+str(globals.expansion.nameBeBred())+".")
		choice.append("Thank you for this gift, $master. I accept. Tell me when it is time to "+str(globals.expansion.nameBeBred())+"")
		choice.append("Yes, $master. Thank you.")
	if person.mood == 'horny':
		choice.append("Oh...oh fuck yes. Thank you, $master! I want to "+str(globals.expansion.nameBeBred())+" badly. For you, of course.")
		choice.append("Sounds...enticing. I'm ready whenever you are, $master!")
		choice.append("Yes! I mean...yes. Yes. YES! ...Yes? Shit...Yes. I will.")
		choice.append("Am...am I going to be strapped down and filled to the brink with cum? Mmmm...")
	if person.mood == 'obediant':
		choice.append("Yes, $master. My "+str(globals.expansion.namePussy())+" is yours to command.")
		choice.append("I will serve, $master. Even if that means I must "+str(globals.expansion.nameBeBred())+".")
		choice.append("I will humbly do as you ask, $master.")
	if person.mood == 'indifferent':
		choice.append("Sure, whatever. I'll "+str(globals.expansion.nameBeBred())+" for you.")
		choice.append("I'm to "+str(globals.expansion.nameBeBred())+" like some slut?\nAlright...I guess...")
		choice.append("Sure thing, $master...")
		choice.append("Alright then, I guess I'll "+str(globals.expansion.nameBeBred())+" for you. Tell me when you want me to start.")
	if person.mood == 'scared':
		choice.append("O-o-okay $master...if that's what you want...")
		choice.append("Will...I have to take care of the baby? I mean, I will...but will I?")
		choice.append("I...I guess. No one will be watching us, right?")
	if person.mood == 'angry':
		choice.append("Yeah? Fine, I'll "+str(globals.expansion.nameBeBred())+" for you. Not like I have a choice...")
		choice.append("Really? That's what you want from me?\nLike...really? Fucking hell...\nFine. Whatever. I'll do it. Breed me like an animal.")
		choice.append("Sure, whatever. It happening now?")
		choice.append("You want me to "+str(globals.expansion.nameBeBred())+" for you? Fine, whatever. Better to be at the top of the wheel than beneath it, I suppose.")
	choice.append("Yes, $master, I'll "+str(globals.expansion.nameBeBred())+" for you!")
	choice.append("I accept, $master")
	text = globals.randomitemfromarray(choice)
	return text

#---End Intro---#
