### <CustomFile> ###
extends Node

func randomfromarray(array):
	return array[randi() % array.size()]

func getzonetraveltext(zone,progress):
	var array = ["Your journey continues peacefully. "]
	var player = globals.player
	var party = globals.state.playergroup.duplicate()
	var teammates = []
	var bunnyteammates = [] #by Fibian - Ralph note: I moved the code up here so it can be accessible beyond just the forest and changed to populating an array for flexibility
	for i in party:
		var j = globals.state.findslave(i)
		if globals.player != j:
			teammates.append(j)
		if j.race in ['Halfkin Bunny','Beastkin Bunny']:
			bunnyteammates.append(j)
	var tempteammate = null if teammates.empty() else randomfromarray(teammates)

	var corestats = ['sstr','sagi','smaf','send']
	var playertitle = {"sstr":"The Bandit Crusher","sagi":"The Lightning Quick Bounty Hunter","smaf":"The Arcane Bandit Hunter","send":"The Unstoppable"}
	var playertopstat = "smaf"
	var tempplayerstat = 0
	for i in corestats:
		if player[i] > tempplayerstat:
			tempplayerstat = player[i]
			playertopstat = i

	var gotrope = globals.state.backpack.stackables.has('rope')
	
	var gotsupplies = false
	if globals.state.backpack.stackables.has('supply') && globals.state.backpack.stackables.supply >= 3:
		gotsupplies = true
	
	var captives = []
	var captivecitizens = 0
	var captivebaddies = 0
	var captivebaddiesratio
	if globals.state.capturedgroup.size() != 0:
		captives = globals.state.capturedgroup
		for i in captives:
			if i.npcexpanded.citizen == true:
				captivecitizens += 1
			else:
				captivebaddies += 1
		captivebaddiesratio = 100 * captivebaddies / captives.size()
	#for i in party:
		#if party[0].inlovewith party[1] || party [2]:
		#	text =
		#if !globals.state.backpack.stackables.has('bandage') && i.health < i.max_health/2:
		#	text =
		#	break
	if rand_range(0,1) > 0.9:
		array.append("A flock of crows pick at a well scavenged corpse nearby.  Upon examination of the nearly stripped bones and tattered remains of clothing, you figure this poor traveler was likely a poor sword for hire or vagabond.  It's unclear what killed him.  Whatever possessions he might have once had have long been looted or dragged away by vermin.  Unable to determine even their place of origin or likely destination, you decide to move on.")
	if globals.expansionsettings.sillymode:
		if rand_range(0,1) > 0.975:
			array.append("You come across a feminine looking [color=yellow]dragonkin[/color] sitting at an easel and painting the scenery. You get close enough to see the name Rendrassa signed on the canvass before noticing that the painter has turned to look at you with an unnerving smile.  Filled with a strange terror, you quickly compliment the painting and hasten to leave.")
		if rand_range(0,1) > 0.98:
			array.append("You notice a hunched figure in the shadows softly chanting.\n[color=yellow]-Must get more money. Must get more money. Gold, gold, gold, I need more.[/color]\nTales of the mythological [color=aqua]Money Seeker[/color] surfaces in your mind and you hold your coin purse close. You hurry away before the being can smell your gold.")
	if rand_range(0,1) > 0.5:
		for i in teammates:
			if i.traits.has("Natural Beauty") && i.beauty < 70 && !i.origins in ["noble","rich"] && rand_range(0,1) > 0.3:
				array.append("You turn to face "+i.name+" and "+randomfromarray(["take agood look","end up staring","casually examine"])+".  You wonder how attractive "+i.name+" could have become if born into a better family.") 
			if (i.traits.has("Scarred") || i.traits.has("Blemished")) && rand_range(0,1) > 0.5:
				array.append("You turn to face "+i.name+" and "+randomfromarray(["get a close-up look at those scars","end up staring","try to look natural","feel a little disgusted"])+".  Maybe you should get "+i.name+" worked on in the lab.") 
			if i.traits.has("Clumsy") && rand_range(0,1) > 0.3:
				array.append(i.name+" "+randomfromarray(["trips and falls, picking up some fresh bruises.","manages to bump into you as you halt for a moment to survey the surroundings.","starts to drop some gear and only makes it worse by fumbling to catch it.","slips and nearly falls before grabbing onto you."]))
			if i.traits.has("Quick") && i.sagi > player.sagi && rand_range(0,1) > 0.6:
				array.append(randomfromarray(["You trip and start to fall","You take a wrong step","You start to lose your balance"])+", but "+i.name+" "+randomfromarray([" is there in a flash to steady you.","leaps into motion, saving you.","is quick to support you."]))	
			if !i.traits.has("Mute") && !i.traits.has("Lisp") && !i.traits.has("Stutter") && i.brand != 'advanced':
				if i.traits.has("Clingy") && rand_range(0,1) > 0.7:
					if i.metrics.ownership > 6:
						array.append(i.name+" "+randomfromarray(["gloms onto","rushes up next to","walks beside","catches up to"])+" you and expresses a heartfelt appreciation to being brought along.")
				if i.traits.has("Foul Mouth") && rand_range(0,1) > 0.7:
					if i.metrics.ownership > 6:
						array.append(i.name+" trips randomly and begins to curse, stringing together a string of vile epithets that at various points would offend people of nearly any race, creed, or sex.  This goes on for several minutes and provides a good deal of entertainment to the party as "+i.name+" has become well known for their foul language and no one takes it too personally.")
					else:
						array.append(i.name+" trips randomly and begins to curse, stringing together a string of vile epithets that at various points would offend people of nearly any race, creed, or sex.  A fight nearly breaks out and you threaten to gag "+i.name+".")
			if i.traits.has("Prude") && rand_range(0,1) > 0.9:
				if i.lewdness > 50:
					array.append("You sight a pair of animals mating and notice "+i.name+" pointedly looking away and blushing.")
				else:
					array.append(i.name+" notices a pair of animals mating and pointedly looking away flustered.")
			if i.traits.has("Mute") && progress < 6 && rand_range(0,1) > 0.7:
				array.append(i.name+" Tugs on you to get your attention and points out "+randomfromarray(['some potential trouble','a possible threat','what look like bandits','some wildlife','something unusual'])+" "+randomfromarray(['ahead','in the distance','before anyone else notices','further ahead','you did not expect'])+".")
	if rand_range(0,1) > 0.9:
		var temp = randomfromarray(['petite','short','average','tall','towering'])
		if globals.player.height != temp:
			array.append("You daydream about what life might be like if you were "+temp+" rather than "+globals.player.height+".")
		temp = randomfromarray(['male','female','futanari','dickgirl'])
		if globals.player.sex != temp:
			array.append("You wonder about what life might be like if you were a "+temp+" rather than a "+globals.player.sex+".")
	if rand_range(0,1) > 0.5:
		if travelwhen() == "early":
			if globals.state.sexactions == 0 && rand_range(0,1) > 0.5:
				array.append("You yawn and stretch as you walk.  It's still early, but spending the better part of the morning fucking has left you feeling sleepy.")
			elif rand_range(0,1) > 0.5:
				array.append("It's early yet.  With a little luck, this should be productive day.")
			if gotsupplies:
				var lowestenergy = 1
				var energyratio = 1
				var selected
				for i in teammates: #who's most ready to camp (and eat)
					energyratio = i.energy / i.stats.energy_max
					if energyratio < lowestenergy && !i.traits.has("Mute") && !i.traits.has("Stutter") && !i.traits.has("Lisp") && i.brand != 'advanced':
						selected = i
						lowestenergy = energyratio
				if selected != null:
					array.append(selected.dictionary("Suddenly you hear a loud growling coming from right behind you and spin around, weapon ready.\n\nIt's just $name standing there sheepishly clutching $his stomach.\n\n[color=yellow]Can we stop and eat? I'm really hungry.[/color] "))
		elif travelwhen() == "afternoon":
			if tempteammate != null && !tempteammate.traits.has("Mute") && !tempteammate.traits.has("Stutter") && !tempteammate.traits.has("Lisp") && tempteammate.brand != 'advanced' && rand_range(0,1) > 0.5:
				array.append(tempteammate.name+" asks how much longer until you'll all return home for the day.")
			elif globals.state.sexactions > 0:
				array.append("There's only so much daylight left and you've got people to fuck back at the mansion.  You wonder why you're still out here and pick up the pace.")
		elif travelwhen() == "late":
			if tempteammate != null && !tempteammate.traits.has("Mute") && !tempteammate.traits.has("Stutter") && !tempteammate.traits.has("Lisp") && tempteammate.brand != 'advanced' && rand_range(0,1) > 0.2:
				array.append(tempteammate.name+" points toward the setting sun and asks how much longer you intend to stay out.")
			elif globals.state.sexactions > 0:
				array.append("It'll be dark soon and you've got people to fuck back at the mansion.  You wonder why you're still out here and pick up the pace.")	
	if zone.code == 'wimbornoutskirts':
		if rand_range(0,1) > 0.5:
			array.append(randomfromarray(["The road winds along flanked by "+travelcrops()+" fields being tended to by "+randomfromarray(["slaves","peasants","tenant farmers beholden to the guilds","commoners with just enough land to eke out a living"])+".","A "+randomfromarray(["gopher","rabbit","badger","large rodent","giant earthworm"])+" pokes its head up from the soil and seems to sniff the air before retreating into another hole to dig some more, after what you do not know.","Migrating "+randomfromarray(["birds","geese","ducks","gulls","wind squirrels","butterflies","hummingbirds"])+" fly overhead with as much organization as you've come to expect.","A "+randomfromarray(["bunch","mob","parcel","rangale","herd"])+" of deer hops over a farmers fence in twos and threes.","A lone gnarled oak tree casts shade over a crossroads and you take a moment to rest under its branches."]))
		else:
			array.append(randomfromarray(["You pass a caravan on it's way to town.  Trade between Wimborn and "+randomfromarray(["Gorn","Frostford","Amberguard","foreign nations","it's neighbors"])+" appears to be "+randomfromarray(["filling the guilds' coffers","profitable","good","lucrative"])+".","You look for a shortcut and end up crossing a pasture full of "+randomfromarray(["cattle","sheep","horses","livestock","oxen","donkeys","hucows of various races all branded as property of the mage guild."])+".","A nearby copse of trees grows larger to your vision.  You see the telltale woodsmoke of a chimney rising from it.  It's probably not worth investigating.  You continue on.","There's a Gazebo atop a hill in the distance.  Your party studiously ignores it.","There's a slaughterhouse here.  It's odd.  You'd have expected they'd locate it closer to town, but then the wind shifts and you have an idea why it's here.","You start to pass a few hovels crowded around a communal well then think again and stop for a drink."]))
		if captives.size() > 5 && globals.state.reputation.wimborn <= -20:
			array.append("A large "+travelgroup()+" of " +travelcheerful()+" "+randomfromarray(['townsfolk','revelers','students','tradesmen'])+" returning to town sees you then they "+travelfearreaction()+" and pointedly averts their gaze after noticing your procession of captives shuffling along in their restraints.")
		elif captives.size() > 5 && globals.state.reputation.wimborn > 50 && captivebaddiesratio > 69:
			array.append("A large "+travelgroup()+" of " +travelcheerful()+" "+randomfromarray(['townsfolk','revelers','students','tradesmen','guards'])+" returning to town cheers you and your party along after they see your "+travelcaptivedesc()+" captives shuffling along in their restraints.")
		if rand_range(0,1) > 0.8 && globals.expansionsettings.sillymode:
			array.append("You notice a "+travelcheerful()+" "+travelrandomperson()+" "+travelfucking()+" "+travelrandomadj()+" "+travelfucktarget()+" - "+travelobserved()+".\n\n"+travellink()+"\n\nIt's clearly a "+travelreaction()+" moment for them and a "+travelreaction()+" moment for you.")
		if globals.state.reputation.wimborn >= -20:
			if globals.state.mainquest >= 2 && globals.state.bountiescollected["wimborn"] <= 3 && progress < 3:
				array.append("A man leading a group of Wimborn guards calls you over.\n\n[color=yellow]Hail "+globals.player.name+".  Ah, no we haven't met, but I know of you by reputation.\n\nListen, I understand you're a Mage and it's not my place to ask, but if you happen to come across bandits in your travels we could really use a hand rounding them up.\n\nWe can't do much to them if they don't already have bounties on their heads, but a lot of them do.  I know you can make good coin selling them through the Slavers' Guild depending on their value, but we can pay you a good bounty on a lot of them based purely on their crimes too.  You never know, sometimes a wimp thief is out here or in the wilds with a huge bounty just waiting to be collected.\n\nAll I'm sayin' really is: keep us in mind.  There aren't enough of us to put much of a dent in the banditry problem around here, and if you turn some over for justice under the law instead of making a quick sale to the slavers it couldn't hurt your reputation and most of the time we'll put some gold in your pockets too.[/color]")
			elif globals.state.bountiescollected["wimborn"] > 50:
				array.append("A guard patrol salutes as you pass.  You hear a few of the men remarking on you and someone refers to you as "+str(player.name+" "+playertitle.playertopstat)+".")
			elif globals.state.bountiescollected["wimborn"] > 25:
				array.append("A guard captain waves as his patrol passes by.  He claps you on the shoulder and tells you to keep up the good work collecting those bounties.")
			elif globals.state.bountiescollected["wimborn"] > 3:
				array.append("A squad of Wimborn guards passes by.\n\nThey call out to remind you that more bounties have been sworn out today on bandits in the area.")
		elif globals.state.reputation.wimborn <= -50:
			array.append("You pass a large and heavily guarded caravan on it's way to town.  The guards tighten grips on their weapons and eye your party warily.")
		elif globals.state.reputation.wimborn <= -20:
			if globals.state.mainquest >= 2 && globals.state.bountiescollected["wimborn"] <= 10 && !teammates.empty():
				array.append("A man leading a large group of the town guard halts your party.\n\n[color=yellow]"+player.name+", I know of you.  You're that Mage who's been abusing his guild privileges - no don't deny it.  As much as it pains me to admit it, there are more bandits out here than we can handle.  I hear you've made a pretty coin selling them off as slaves, but if you turn some over for justice under the law instead of making a quick sale to the slavers it might improve your reputation and, I expect more importantly to you, we'll put some gold in your pockets as well.[/color]")
			else:
				array.append("You pass a large and heavily guarded caravan on it's way to town.  Bandits would have to be suicidal to attack this one.")
	elif zone.code == 'frostfordoutskirts':
		if captives.size() > 5 && globals.state.reputation.frostford <= -20:
			array.append("You pass by a large "+travelcareful()+" "+travelgroup()+" of "+randomfromarray(['beastfolk','lumberers','trappers'])+" traveling the other way on the snowy path. They spot you and "+travelfearreaction()+" watching you with about as much trust as they have for the local wildlife after noticing the procession of captives you half drag through the snow behind you.")
		elif captives.size() > 5 && globals.state.reputation.frostford > 50 && captivebaddiesratio > 69:
			array.append("A large "+travelcareful()+" "+travelgroup()+" of "+randomfromarray(['beastfolk','lumberers','trappers','guards'])+" approaches on the snowy path.  Someone in the "+travelgroup()+" recognizes you and speaks to the others.  By the time you pass them, they've become "+travelcheerful()+" and you receive words of encouragement and praise while your "+travelcaptivedesc()+" prisoners are "+travelmockery()+" and "+travelharassment()+" as they stumble through the snow.")
		array.append("It's hard to tell where the path is under all this snow.  Several times the road turns and you don't notice until it's clear you're feet are crunching down on uneven terrain and frozen vegetation.")
		if !teammates.empty():
			array.append(randomfromarray(teammates).name+" stumbles over a "+randomfromarray(['root','stone','log','frozen animal corpse','rock','branch'])+" hidden in the snow and "+travelcomplains()+" "+travelcomplainsadj()+" as you trudge on.")
	elif zone.code == 'gornoutskirts':
		var temprace = randomfromarray(["Orc","Goblin"])
		if player.race != temprace:
			array.append("A "+travelwarparty()+" of "+temprace+" "+travelmoves()+"s by.  Several of them sneer at you.\n\n[color=yellow]It's dangerous for a "+player.race+" out here.  "+randomfromarray(["Better run home before you get hurt.","No guild out here to help you.","These are our hunting grounds.  Don't forget that.","Go home to your "+player.race+" mama.","This is no place for your kind."])+"[/color]  They continue to jeer as they "+travelmoves()+" off through the wind and dust.")
		else:
			array.append("A "+travelwarparty()+" of "+temprace+" "+travelmoves()+"s by.  Several of them stare at you in challenge, but they offer no objection to your passage.")
		if captives.size() > 5 && globals.state.reputation.gorn <= -20:
			array.append("You pass by a large "+travelcareful()+" "+travelgroup()+" of "+randomfromarray(['orcs','slave catchers','guards','slavers','tribal elves','goblins','travelers'])+" traveling the other way on the packed dirt road. They spot you and "+travelfearreaction()+" watching you with about as much trust as they have for the local wildlife after noticing the procession of captives you half drag through the snow behind you.")
		elif captives.size() > 5 && globals.state.reputation.gorn > 50 && captivebaddiesratio > 69:
			array.append("A large "+travelcareful()+" "+travelgroup()+" of "+randomfromarray(['beastfolk','lumberers','trappers','guards'])+" approaches on the snowy path.  Someone in the "+travelgroup()+" recognizes you and speaks to the others.  By the time you pass them, they've become "+travelcheerful()+" and you receive words of encouragement and praise while your "+travelcaptivedesc()+" prisoners are "+travelmockery()+" and "+travelharassment()+" as they stumble through the snow.")
	elif zone.code == 'sea':
		array.append_array(["You spot a large group of Nereids setting up some sort of "+randomfromarray(['encampment','fortification','supply depot','base','stockade','nets'])+" situated just off the beach so that it will remain submerged even at low tide, but you can't get close enough to tell more without being spotted.  You keep your distance.","You keep inland from the beach so as not to leave obvious tracks.","A "+randomfromarray(['trade ship','galleon','schooner','catamaran','yacht','carrack','clipper','brigantine','bark','xebec','slaving ship','fishing boat','naval ship of some type','a pirate ship'])+" can be seen far off the coast.","You pass various "+randomfromarray(['flotsam','jetsam','detritus','bleached and broken hulls','masses of kelp','scavenged sea monster corpses'])+" washed up on the beach."])
	elif zone.code == 'prairie':
		array.append_array(["You see a hill, conspicuous among the expanse of flat earth, with a crude leather curtain covering a hole in its side and several dozen spikes sporting decapitated heads and skulls in various states of decay.  It's a goblin nest and a big one at that.  This would be a very bad place to be after nightfall.","You spot a whole herd of Centaurs and keep your distance so as not to provoke them.","A war party of orcs is skirmishing with a large "+travelgroup()+" of "+randomfromarray(['tribal elves','goblins','centaurs','bandits'])+" not far off and you hasten to avoid getting involved."])
	elif zone.code == 'forest':
		array.append_array(["A squirrel chitters at you and pelts your party with sticks and nuts.","You pass forest animals that show no particular concern for your presence.","You enjoy a peaceful walk through the woods.","Your party stumbles into "+randomfromarray(['a heavily webbed section of trees','a charnel pit heaped with the rotting carcasses and bones of wolves, bears, and even giant spiders','an illusory veil that tugs violently at your sanity, probably concealing a foxkin village if the rumors are true'])+" and carefully, quietly make your way back to the path.","The sounds of songbirds ring out across the forest.  It's a lovely day to be looking for an acquisition.","Enjoying the "+traveltimeofday()+" sun, you stroll through the forest looking for the next encounter.  It so happens that your next encounter is a facefull of spider webbing.  You spend longer than you should have incinerating the place to ensure that the spider's entire family is long dead.","Lost in thought, you walk along the path and nothing really happens for some time.  After a while, some movement in the brush to your right ends your daydream of how to handle your latest guest."]) #several adds by Fibian 
		if captives.size() > 4 && rand_range(0,1) > 0.5: 
			array.append("In the distance you catch glimpse of a foxkin walking along the path.  As you slowly draw nearer, one of your captives stumbles and falls into a thornbush and yelps in pain.  When you turn back around to look for the foxkin, it has disappeared.") #by Fibian
		if tempteammate == null && rand_range(0,1) > 0.5: 
			var tempforestwalk = ["You think nothing of it and continue along your path.","You try to approach the animal, but you spook it and it runs off."] #by Fibian
			if globals.expansionsettings.sillymode:
				tempforestwalk.append("Feeling generous you pull out a can of soup, open the top, and partially bury the can in the ground.  As you move away from the offering, the fox approaches the soup and sniffs at it for a bit.  The fox lifts up the can of soup sideways and bolts off into the forest... spilling out the entire can of soup along the way.  Good job dumbass.") #by Fibian - Ralph Note: I made the "can of soup" possibility part of sillymode b/c I'm not sure canned goods are lore friendly, etc.
			array.append("You've been walking along the path for some time and you've noticed you've picked up a companion somewhere along the way.  You occasionally catch glimpses of a small fox stealthily following you far behind.  "+randomfromarray(tempforestwalk)) #by Fibian
		if globals.expansionsettings.sillymode:
			if bunnyteammates.size() > 0 && rand_range(0,1) > 0.5: #by Fibian - Ralph Note: I thought this was a more flexible way to use the boolean
				var tempbunny = randomfromarray(bunnyteammates)
				array.append("As your party walks through the forest, it appears that a group of bunnies has started to gather around "+str(tempbunny.name)+".  As the party continues, more and more bunnies begin to gather around "+str(tempbunny.name)+" to the point that it's hard to walk without stepping on one.  "+str(he(tempbunny))+" pleads with you for help, but this is actually quite amusing and you outdistance "+him(tempbunny)+", perhaps to leave "+him(tempbunny)+" to "+his(tempbunny)+" bunny fate.") #by Fibian
			else:
				array.append_array(["In the brush you can barely see a bunny nibbling on something.  Seizing the moment you very stealthily creep up on the animal.  Slowly.  Slower.  You reach out and very gently put your hand on the animal.  It turns around very methodically and gazes upon a creature 20 times it's size.\n\n[color=yellow]Boo![/color]\n\nThe bunny panics and bolts deeper into the brush.  Got him.", "The numerous squeaking bunnies can be heard in the nearby brush as the party moves along a portion of the trail.  Better not upset the bunny god today.  You and your party continue without a moments delay."]) #by Fibian
	elif zone.code == 'elvenforest':
		array.append_array(["There's a clearing here, likely used to allow carts or wagons to pass one another given the narrow forest road.","This patch of trees is especially tranquil.","You pass forest animals that show no particular concern for your presence.","You enjoy a peaceful walk through the woods.","The forest here is meticulously maintained.","The path meanders wide and flat enough for a cart and yet twisting around trees, many ancient, suggesting none were removed to form this forest road."])
		if globals.state.reputation.amberguard <= -20 && rand_range(0,1) > 0.5:
			array.append("Your party walks deeper and deeper into the forest. Light fades in the forest as high above the canopy threatens to blot out the sun. Deeper and deeper you walk into the forest all the while having the sensation of someone, or something, watching you from high above in the canopy.  It's unsettling but you must move on.") #by Fibian
	elif zone.code == 'grove':
		array.append_array(["Strange disembodied voices seem to whisper from all sides as your veer off the beaten path and you rush back to resume your trek.","Your party stumbles into "+randomfromarray(['a heavily webbed section of trees','a charnel pit heaped with the rotting carcasses and bones of wolves, bears, and even giant spiders','an illusory veil that tugs violently at your sanity, probably concealing a foxkin village if the rumors are true'])+" and carefully, quietly you make your way back to the path."])
	elif zone.code == 'marsh':
		array.append_array(["Strange disembodied voices seem to whisper from all sides as your veer off the beaten path and you rush back to resume your trek.","Your party begins to stumble into "+randomfromarray(['a clearing devoid of any living things except mycelium.  The spores begin to itch in your throats ','a bog that seems to suck you down','a patch of quicksand','a heavily webbed section of trees','a stagnant pool heaped with the rotting carcasses and bones of wolves, bears, and even giant spiders'])+" and you carefully make your way back to the path."])
	elif zone.code == 'mountains':
		array.append_array(["As you travel along a rocky cliff, you notice an old prayer shrine.  It has several old animal bones and broken egg shells scattered around it as offerings.  The amount of large, shabby feathers scattered about the area leads you to conclude this is a [color=yellow]harpy[/color] shrine of some kind.  You figure it's best to move on without disturbing it.","Your party is uneasy.  This is an ideal setting for an ambush.","It would be unbearably hot if not for shade cast by the cliffs above.","Squaking, vile cursing, and flung feces rain down on your party.  You've distrubed an entire colony of savage harpies nestled between narrow outcrops above and race on, narrowly avoiding capture and presumably a life as breeding stock and/or death as harpy fodder.","The winged shadow of a "+travelmountainflyer()+" flits across your path. but when you look up you see nothing.","Pebbles and rocks cascade from a ledge above.  You feel like you're being watched, and urge the party forward."])
	elif zone.code == 'mountaincave':
		array.append_array(["You pass a pile of cracked bare bones.  The stench of ammonia is overwhelming.  An ooze has fed here recently.","Totems appear around a corner.  This must be goblin territory.","The walls are slick with condensation as the temperature drops inside the caves.","You think you hear voices and order the party to halt in silence, but hear only dripping and your own breathing."])
		var canread = false
		for i in teammates:
			if i.race in ['Elf','Dark Elf','Tribal Elf']:
				canread = true
		if canread:
			array.append("There's writing on the wall here.  In some dialect of elvish, it reads: "+randomfromarray(["Abandon hope any who enter.","Turn around cousin on pain of death, we serve you no longer.","We tolerate no intruders.","No Trespassing","Do Not Trespass","Scenic Cavern Ahead","Don't Feed the Ooze","Disclaimer: This enclave of dark elves is not responsible for dismemberment or death of any party trespassing herein."]))
		else:
			array.append("There's writing on the wall here.  "+randomfromarray(["It's some dialect of elvish, but you cannot make it out","It's illegible to you, but an arrow pointing onward with an 'X' carved through it and skulls convey the meaning well enough."]))
	elif zone.code == 'undercityruins':
		array.append_array(["Your party turns a corner and comes face to face with a wall.  You turn around to backtrack and dozens of sightless eyes glisten in the darkness from alcoves you couldn't see on your way into this dead end.\n\nYou prepare for the end as one massive trogolodyte moves to the center of the tunnel ahead of the others, but before it can act a Kobold wearing some sort of jersey drops from the ceiling and bravely slaps the monstrosity on its nose as it falls before scurrying through the trog's legs and behind it.\n\nThe Kobold races down the hall screaming it's warcry, [color=yellow]Got your nose![/color].  The enraged trogolodytes forget all about your party and give chase, leaving you alone in relative safety.\n\nYou're relatively certain that the Kobold's jersey read: 'Capitualize'."]) #ralphD - leaving it as append_array() b/c there will certainly be additions
	if array.size() == 0:
		array.append(randomfromarray(["Your journey proceeds uneventfully","There's nothing much to see here.  Your party seems bored.","This part of the path seems like any other."]))
	return randomfromarray(array)

func getcya(zone): #this is a placeholder that does nothing at present
	var rvar
	var array = []
	var party = globals.state.playergroup.duplicate()
	if globals.resources.mana < rand_range(0,500) + 100 || rand_range(0,100) > 75:
		rvar.append_array([])
	if globals.resources.gold < rand_range(0,1000) + 250 || rand_range(0,100) > 75:
		rvar.append_array([])
	if !globals.state.backpack.stackables.has('rope'):
		rvar.append_array([])
	if !globals.state.backpack.stackables.has('supply') && globals.state.restday == globals.resources.day:
		rvar.append_array([])
	for i in party:
		#if party[0].inlovewith party[1] || party [2]:
		#	rvar.append_array([])
		if !globals.state.backpack.stackables.has('bandage') && i.health < i.max_health/2:
			rvar.append_array([])
			break
	if zone.code in ['wimbornoutskirts','gornoutskirts','frostfordoutskirts']:
		rvar.append_array([])
	elif zone.code == 'sea':
		rvar.append_array([])
	elif zone.code == 'prairie':
		rvar.append_array([])
	elif zone.code == 'forest':
		rvar.append_array([])
	elif zone.code == 'elvenforest':
		rvar.append_array([])
	elif zone.code == 'grove':
		rvar.append_array([])
	elif zone.code == 'marsh':
		rvar.append_array([])
	elif zone.code == 'mountains':
		rvar.append_array([])
	elif zone.code == 'mountaincave':
		rvar.append_array([])
	elif zone.code == 'sea':
		rvar.append_array([])				
	return rvar

func he(person):
	if person.sex == 'male':
		return "he"
	else:
		return "she"

func his(person):
	if person.sex == 'male':
		return "his"
	else:
		return "her"
		
func him(person):
	if person.sex == 'male':
		return "him"
	else:
		return "her"

func traveltimeofday():
	var alreadycamped = (globals.state.restday == globals.resources.day)
	var text = "morning"
	if alreadycamped && globals.player.energy < globals.player.stats.energy_max / 2:
		text = "evening"
	elif alreadycamped:
		text = "afternoon"
	return text
	
func travelwhen():
	var alreadycamped = (globals.state.restday == globals.resources.day)
	var text = "early"
	if alreadycamped:
		text = "late"
	return text

func travelwealth():
	var array = ["solvent","financially stable","doing ok with gold","not poor","only rich on paper"]
	if globals.resources.gold > 25000:
		array = ["filthy rich","extremely wealthy","wealthier than the nobles"]
	elif globals.resources.gold > 15000:
		array = ["rich","wealthy","well-to-do"]
	elif globals.resources.gold > 10000:
		array = ["fairly wealthy","up and coming","doing alright","in the black"]
	elif globals.resources.gold < 3000:
		array = ["keeping above water","keeping ahead of bills"]
	elif globals.resources.gold < 1500:
		array = ["in need of funds","poor","strapped for gold","on a shoe-sting budget"]
	elif globals.resources.gold < 500:
		array = ["impoverished","out of money","barely able to pay the bills","nearly bankrupt","may soon be destitute"]
	return randomfromarray(array)

func travelcheerful():
	return randomfromarray(["cheerful","happy","boisterous","joyful","jovial","lively","rowdy","gleeful","delighted","rambuncious"])

func travelcareful():
	return randomfromarray(["careful","wary","cautious","tense"])
	
func travelmoves():
	return randomfromarray(["trudge","walk","file","jog","trot"])
	
func travelfucking():
	return randomfromarray(["fucking","plowing","screwing","penetrating","churning inside","pummeling","plunging into","absolutely hammering","pounding","pumping into","slamming","thrusting into","grinding against","driving into"])

func travelgroup():
	return randomfromarray(["group","bunch","gaggle","party","crowd","band","collection"])
	
func travelwarparty():
	return randomfromarray(["war party","horde","large band","large squad"])

func travelfearreaction():
	return randomfromarray(["go silent","begin whispering","begin to panic","hush"])
	
func travelcaptivedesc():
	return randomfromarray(["scruffy","forlorn","defeated","demoralized","morose","pitiful","bedraggled","ragged","bruised","beaten"])

func travelmockery():
	return randomfromarray(["jeered at","mocked","insulted","made sport of"])

func travelharassment():
	return randomfromarray(["jostled","shoved","pushed","knocked about","spit upon","gestured at rudely"])
	
func travelrandomperson():
	var array = ["Centerflag","Pallington","Aric Triton","psychopath","farmer","herder","rancher","artist","traveler","slaver","politician","guardsman","peddler","mage","mercenary","bandit","old man","bard","tax collector","thug","pugilist","strap-on clad dominatrix","hunter","alchemist","breeder"]
	if globals.expansionsettings.sillymode:
		randomfromarray(["Aric Triton","mod author","smutty video game developer","thespian","philosopher","pedestrian","clown","mime","puppeteer","barkeep","prince","pixel art Colonel Custer","mid-boss","final boss"])
	return randomfromarray(array)

func travelfucktarget():
	var array = ["Centerflag","Ralphomayo","Aric Triton","horse","sheep","goat","dog","fencepost","watermelon","prostitute","sack of produce","corpse","farmgirl","farmer's wife","woman","whore","girl you had turned over to the Mage Guild","oddly familiar fairy","an oddly familiar Taurus girl with multiple leaking breasts","slave you believe you had sold at some point","bandit","traveling salesman"]
	array.append_array(globals.constructor.humanoid_races_array)
	array.append_array(globals.constructor.beast_races_array)
	if globals.expansionsettings.sillymode:
		array.append_array(["magical sheep that spits fireballs","receptionist you recognize from the slave guild","Sebastian","ghost as far as you can tell","Alise","pumpkin","Hade","giant sloth","effigy of a hated politician","famous actress","famous actor","Gazebo","portrait of a minor celebrity","anime waifu bodypillow","game console","statue","dragon in disguise","furry","model car enthusiast","trenchcoat-clad pervert","woman from your dreams","silhouette of a hard to illustrate race","pixel-art heroine"])
	return randomfromarray(array)
	
func travelrandomadj():
	return randomfromarray(["a disturbingly large","an oddly sensual","a comely","a handsome","a bizarre","a rotund","an obviously non-consenting","a lustful","a stoic","a fetching","a very unusual","a drop-dead gorgeous","a somewhat feminine","a somewhat masculine","a bored-looking","a sleeping","a drugged","a very out-of-place","a very confused-looking","a rueful","a well endowed","an oddly tiny","a muscular","an apoplectic","a narcoleptic","an epileptic","a perfectly proportioned","unfortunately physiqued"])

func travellink():
	var array = ["It begins to rain, but you take no heed.","Your eyes meet.","You cheer them on.","You hurl insults at them."]
	if globals.expansionsettings.sillymode:
		if wall4:
			var modifier1 = int(rand_range(2,14))
			var modifier2 = int(rand_range(0,6))
			var judge1 = "[color=yellow]"+randomfromarray(["Ankmairdor","Aric Triton","Ankmairdor","Aric Triton","Redle","Leonidas","JJoseph"])+"[/color]"
			var score1 = "[color=red]"+str(round(rand_range(modifier1,20-modifier2))/2-0.5)+"[/color]"
			var judge2 = "[color=yellow]"+randomfromarray(["Ralphomayo","Capitualize","Pallington","Rendrassa","Whims","Smargoos","Centerflag"])+"[/color]"
			var score2 = "[color=red]"+str(round(rand_range(modifier1,20-modifier2))/2)+"[/color]"
			var judge3 = "[color=yellow]"+randomfromarray(["TrashMan","Chaotic","Pleione","El Presidente","Deviate","Futur Planet","Fibian","King"])+"[/color]"
			var score3 = "[color=red]"+str(round(rand_range(modifier1,20-modifier2))/2)+"[/color]"
			array = ["The judges confer briefly before holding up signs.\n"+judge1+": "+str(score1)+"\n"+judge2+": "+str(score2)+"\n"+judge3+": "+str(score3)+""]
		else:
			array.append_array(["This is indeed a disturbing universe.","Your eyes meet.","Your eyes meet.","Your eyes meet.","He gives you the finger.","He invites you to join in.","He attempts to disengage in mid-nut, making an awful mess in the process.","You smile at one another knowingly.","You feel a kinship.","You consider if it'd make a better story in retrospect if you charged toward him.","You share the moment.","He calls out your name as he climaxes.","You realize you missed a sale this morning.","You ponder your life's choices up to this point.","You feel inspired to write a poem.","Just then a sinkhole opens beneath them.","Just then the Sarlac pit monster drags them down and belches loudly.","You thought your life was on the upswing. This is a new low.","Random text should never be entrusted to mod authors.","The end is nigh.","Why? Why is this happening?","You remember you have somewhere else to be.","You feel a sudden and irresistable urge to eat sausage.","You sprint away."])
	return randomfromarray(array)

func traveljudgeadj():
	return randomfromarray(["seriously","with bored expressions","intently","through cracks between the fingers they cover their faces with","impassively","with stoicism","with embarrassment","while drinking beer","with a lewd remark here and there","seemingly out of place","as if their very lives depended on this singular act","because of clear and purlient interest","with building excitement","skeptically","with meticulous attention to detail","as if their parents walk in at any moment","like 6th graders in an art class with a nude model to paint","as if they'd never seen this before","as if this were just business as usual"])

var wall4 = false
func travelobserved(): #ralphD - I know this could be 2 lines like others, but I am adding variable content shortly so leaving it as is
	var array = ["in broad daylight","without any concern for being observed","for all to see","without a hint of embarrassment","as if in a trance","without a trace of self-consciousness"]
	if globals.expansionsettings.sillymode && rand_range(0,1) > 0.7:
		array = ["three judges look on "+traveljudgeadj()]
		wall4 = true
	return randomfromarray(array)
	
func travelcrops():
	return randomfromarray(["wheat","fallow","corn","lush","verdant","rice paddies rather than","rye","soybeans"])

func travelreaction():
	var array = ["awkward","singular","wild","bizarre","stimulating","strange","underwhelming","overwhelming","momentous","agitating","horrific","arousing","curious","salacious","powerful","moving","confusing","weird","molifying"]
	if globals.expansionsettings.sillymode:
		array.append_array(["insightful","enlightening","heartfelt","touching","existential","transcendent","triggering","bamboozling","immutable","holy","humbling","frank","ignoble","parsimonius","lamentable","relatively normal","boring","forgettable","droll","action-packed","stereotypical","silly","horrendous","terrifying","once-in-a-lifetime","one-of-those-days","victorious","merry"])
	return randomfromarray(array)
	
func travelcomplains():
	return randomfromarray(["complains","grumbles","mutters","bellyaches","grouses"])
	
func travelcomplainsadj():
	return randomfromarray(["bitterly","darkly","loudly","sullenly","somewhat childishly","in consternation","quietly","with irritation"])
	
func travelmountainflyer():
	return randomfromarray(["harpy","large bird of prey, perhaps even a roc","winged humanoid","some strange beast","a -could it be?- a griffon","a seraph with a spear"])
#---End---#
