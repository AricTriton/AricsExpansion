### <CustomFile> ###

var talk = globals.expansiontalk

func getzonetraveltext(zone,enemygroup,progress):
	var array = ["Your journey continues peacefully. "]
	
	var party = globals.state.playergroup.duplicate()
	var teammates = []
	for i in party:
		var j = globals.state.findslave(i)
		if globals.player != j:
			teammates.append_array(j)
	#for i in teammates:
			
	var gotrope = globals.state.backpack.stackables.has('rope')
	
	var gotsupplies = false
	if globals.state.backpack.stackables.has('supply') && globals.state.backpack.stackables.supply >= 3:
		gotsupplies = true
	
	var captives = enemygroup.captured
	var captivecitizens = 0
	var captivebaddies = 0
	for i in captives:
		if i.npcexpanded.citizen == true:
			captivecitizens += 1
		else:
			captivebaddies += 1
	var captivebaddiesratio = 100 * captivebaddies / captives.size()
	#for i in party:
		#if party[0].inlovewith party[1] || party [2]:
		#	text =
		#if !globals.state.backpack.stackables.has('bandage') && i.health < i.max_health/2:
		#	text =
		#	break
	for i in teammates:
		if i.traits.has("Foul Mouth") && rand_range(0,1) > 0.6:
			if i.metrics.ownership > 6:
				array.append_array(i.name+" trips randomly and begins to curse, stringing together a string of vile epithets that at various points would offend people of nearly any race, creed, or sex.  This goes on for several minutes and provides a good deal of entertainment to the party as "+i.name+" has become well known for their foul language and no one takes it too personally.")
			else:
				array.append_array(i.name+" trips randomly and begins to curse, stringing together a string of vile epithets that at various points would offend people of nearly any race, creed, or sex.  A fight nearly breaks out and you threaten to gag "+i.name+".")
		if i.traits.has("Prude") && rand_range(0,1) > 0.9:
			if i.lewdness > 50:
				array.append_array("You sight a pair of animals mating and notice "+i.name+" pointedly looking away and blushing.")
			else:
				array.append_array(i.name+" notices a pair of animals mating and pointedly looking away flustered.")
		if i.traits.has("Mute") && progress < 6 && rand_range(0,1) > 0.5:
			array.append_array(i.name+" Tugs on you to get your attention and points out "+globals.randomitemfromarray(['some potential trouble','a possible threat','what look like bandits','some wildlife','something unusual'])+" "+globals.randomitemfromarray(['ahead','in the distance','before anyone else notices','further ahead','you did not expect'])+".")
	if rand_range(0,1) > 0.9:
		var temp = globals.randomitemfromarray(['petite','short','average','tall','towering'])
		if globals.player.height != temp:
			array.append_array("You daydream about what life might be like if you were "+temp+" rather than "+globals.player.height+".")
		temp = globals.randomitemfromarray(['male','female','futanari','dickgirl'])
		if globals.player.sex != temp:
			array.append_array("You wonder about what life might be like if you were a "+temp+" rather than a "+globals.player.sex+".")
	if gotsupplies && talk.travelwhen() == "early":
		var lowestenergy = 1
		var energyratio = 1
		var selected = ""
		for i in teammates: #who's most ready to camp (and eat)
			energyratio = teammates[i].energy / teammates[i].energy_max
			if energyratio < lowestenergy && !i.traits.has("Mute") && !i.traits.has("Lisp") && i.brand != 'advanced':
				selected = teammates[i].name
				lowestenergy = energyratio
		array.append_array("Suddenly you hear a loud growling coming from right behind you and spin around, weapon ready.\n\nIt's just "+selected+" standing there sheepishly clutching $his stomach.\n\n[color=yellow]Can we stop and eat? I'm really hungry.[/color] ") #ralphD note: make sure $his works
	if zone.code == 'wimbornoutskirts':
		if captives.size() > 5 && globals.state.reputation.wimborn <= -20:
			array.append_array("A large "+talk.travelgroup()+" of " +talk.travelcheerful()+" "+globals.randomitemfromarray(['townsfolk','revelers','students','tradesmen'])+" returning to town sees you then they "+talk.travelfearreaction()+" and pointedly averts their gaze after noticing your procession of captives shuffling along in their restraints.")
		elif captives.size() > 5 && globals.state.reputation.wimborn > 50 && captivebaddiesratio > 69:
			array.append_array("A large "+talk.travelgroup()+" of " +talk.travelcheerful()+" "+globals.randomitemfromarray(['townsfolk','revelers','students','tradesmen','guards'])+" returning to town cheers you and your party along after they see your "+talk.travelcaptivedesc()+" captives shuffling along in their restraints.")
		if rand_range(0,1) > 0.5 && globals.expansionsettings.sillymode:
			array.append_array("You notice a "+talk.travelcheerful()+" "+talk.travelrandomperson()+" fucking "+talk.travelrandomadj()+" "+talk.travelfucktarget()+" in broad daylight.  Your eyes meet.  It's clearly a "+talk.travelreaction()+" moment for him and a "+talk.travelreaction()+" moment for you.")
		if rand_range(0,1) > 0.5:
			array.append_array("You start to pass a few hovels crowded around a communal well and stop so your party can sate their thirst.")
			array.append_array("There's a slaughterhouse here.  It's odd.  You'd have expected they'd locate it closer to town, but then the wind shifts and you have an idea why it's here.")
			array.append_array("There's a Gazebo atop a hill in the distance.  Your party studiously ignores it.")
		array.append_array("The road winds along flanked by "+talk.travelcrops()+" fields being tended to by "+globals.getrandomfromarray(["slaves","peasants","tenant farmers beholden to the guilds","commoners with just enough land to eke out a living"])+".")
		array.append_array("You look for a shortcut and end up crossing a pasture full of "+globals.getrandomfromarray(["cattle","sheep","horses","livestock","oxen","donkeys","beastkin of various types all branded as property of the mage guild."])+".")
		if globals.state.reputation.wimborn >= 20:
			array.append_array("You pass a caravan on it's way to town.  Trade between Wimborn and "+globals.getrandomfromarray(["Gorn","Frostford or perhaps Amberguard","foreign nations","it's neighbors"])+" appears to be "+globals.getrandomfromarray(["filling the guilds' coffers","profitable","good","lucrative"])+".")
		elif globals.state.reputation.wimborn <= -50:
			array.append_array("You pass a large and heavily guarded caravan on it's way to town.  The guards tighten grips on their weapons and eye your party warily.")
		elif globals.state.reputation.wimborn <= -20:
			array.append_array("You pass a large and heavily guarded caravan on it's way to town.  Bandits would have to be suicidal to attack this one.")
	elif zone.code == 'frostfordoutskirts':
		if captives.size() > 5 && globals.state.reputation.frostford <= -20:
			array.append_array("You pass by a large "+talk.travelcareful()+" "+talk.travelgroup()+" of "+globals.randomitemfromarray(['beastfolk','lumberers','trappers'])+" traveling the other way on the snowy path. They spot you and "+talk.travelfearreaction()+" watching you with about as much trust as they have for the local wildlife after noticing the procession of captives you half drag through the snow behind you.")
		elif captives.size() > 5 && globals.state.reputation.frostford > 50 && captivebaddiesratio > 69:
			array.append_array("A large "+talk.travelcareful()+" "+talk.travelgroup()+" of "+globals.randomitemfromarray(['beastfolk','lumberers','trappers','guards'])+" approaches on the snowy path.  Someone in the "+talk.travelgroup()+" recognizes you and speaks to the others.  By the time you pass them, they've become "+talk.travelcheerful()+" and you receive words of encouragement and praise while your "+talk.travelcaptivedesc()+" prisoners are "+talk.travelmockery()+" and "+talk.travelharassment()+" as they stumble through the snow.")
		array.append_array("It's hard to tell where the path is under all this snow.  Several times the road turns and you don't notice until it's clear you're feet are crunching down on uneven terrain and frozen vegetation.")
		array.append_array(globals.getrandomfromarray(teammates).name+" stumbles over a "+globals.getrandomfromarray(['root','stone','log','frozen animal corpse','rock','branch'])+" hidden in the snow and "+talk.travelcomplains()+" "+talk.travelcomplainsadj()+" as you trudge on.")
	elif zone.code == 'gornoutskirts':
		if captives.size() > 5 && globals.state.reputation.gorn <= -20:
			array.append_array("You pass by a large "+talk.travelcareful()+" "+talk.travelgroup()+" of "+globals.randomitemfromarray(['orcs','slave catchers','guards','slavers','tribal elves','goblins','travelers'])+" traveling the other way on the packed dirt road. They spot you and "+talk.travelfearreaction()+" watching you with about as much trust as they have for the local wildlife after noticing the procession of captives you half drag through the snow behind you.")
		elif captives.size() > 5 && globals.state.reputation.gorn > 50 && captivebaddiesratio > 69:
			array.append_array("A large "+talk.travelcareful()+" "+talk.travelgroup()+" of "+globals.randomitemfromarray(['beastfolk','lumberers','trappers','guards'])+" approaches on the snowy path.  Someone in the "+talk.travelgroup()+" recognizes you and speaks to the others.  By the time you pass them, they've become "+talk.travelcheerful()+" and you receive words of encouragement and praise while your "+talk.travelcaptivedesc()+" prisoners are "+talk.travelmockery()+" and "+talk.travelharassment()+" as they stumble through the snow.")
	elif zone.code == 'sea':
		array.append_array(globals.getrandomfromarray(["You spot a large group of Nereids setting up some sort of "+globals.getrandomfromarray(['encampment','fortification','supply depot','base','stockade','nets'])+" situated just off the beach so that it will remain submerged even at low tide, but you can't get close enough to tell more without being spotted.  You keep your distance.","You keep inland from the beach so as not to leave obvious tracks.","A "+globals.getrandomfromarray(['trade ship','galleon','schooner','catamaran','yacht','carrack','clipper','brigantine','bark','xebec','slaving ship','fishing boat','naval ship of some type','a pirate ship'])+" can be seen far off the coast.","You pass various "+globals.getrandomfromarray(['flotsam','jetsam','detritus','bleached and broken hulls','masses of kelp','scavenged sea monster corpses'])+" washed up on the beach."]))
	elif zone.code == 'prairie':
		array.append_array(globals.getrandomfromarray(["You see a hill, conspicuous among the expanse of flat earth, with a crude leather curtain covering a hole in its side and several dozen spikes sporting decapitated heads and skulls in various states of decay.  It's a goblin nest and a big one at that.  This would be a very bad place to be after nightfall.","You spot a whole herd of Centaurs and keep your distance so as not to provoke them.","A war party of orcs is skirmishing with a large "+talk.travelgroup()+" of "+globals.getrandomfromarray(['tribal elves','goblins','centaurs','bandits'])+" not far off and you hasten to avoid getting involved."]))
	elif zone.code == 'forest':
		array.append_array(globals.getrandomfromarray(["A squirrel chitters at you and pelts your party with sticks and nuts.","You pass forest animals that show no particular concern for your presence.","You enjoy a peaceful walk through the woods.","Your party stumbles into "+globals.getrandomfromarray(['a heavily webbed section of trees','a charnel pit heaped with the rotting carcasses and bones of wolves, bears, and even giant spiders','an illusory veil that tugs violently at your sanity, probably concealing a foxkin village if the rumors are true'])+" and carefully, quietly make your way back to the path."]))
	elif zone.code == 'elvenforest':
		array.append_array(globals.getrandomfromarray(["There's a clearing here, likely used to allow carts or wagons to pass one another given the narrow forest road.","This patch of trees is especially tranquil.","You pass forest animals that show no particular concern for your presence.","You enjoy a peaceful walk through the woods.","The forest here is meticulously maintained.","The path meanders wide and flat enough for a cart and yet twisting around trees, many ancient, suggesting none were removed to form this forest road."]))
	elif zone.code == 'grove':
		array.append_array(globals.getrandomfromarray(["Strange disembodied voices seem to whisper from all sides as your veer off the beaten path and you rush back to resume your trek.","Your party stumbles into "+globals.getrandomfromarray(['a heavily webbed section of trees','a charnel pit heaped with the rotting carcasses and bones of wolves, bears, and even giant spiders','an illusory veil that tugs violently at your sanity, probably concealing a foxkin village if the rumors are true'])+" and carefully, quietly you make your way back to the path."]))
	elif zone.code == 'marsh':
		array.append_array(globals.getrandomfromarray(["Strange disembodied voices seem to whisper from all sides as your veer off the beaten path and you rush back to resume your trek.","Your party begins to stumble into "+globals.getrandomfromarray(['a clearing devoid of any living things except mycelium.  The spores begin to itch in your throats ','a bog that seems to suck you down','a patch of quicksand','a heavily webbed section of trees','a stagnant pool heaped with the rotting carcasses and bones of wolves, bears, and even giant spiders'])+" and you carefully make your way back to the path."]))
	elif zone.code == 'mountains':
		array.append_array(globals.getrandomfromarray(["Your party is uneasy.  This is an ideal setting for an ambush.","It would be unbearably hot if not for shade cast by the cliffs above.","Squaking, vile cursing, and flung feces rain down on your party.  You've distrubed an entire colony of savage harpies nestled between narrow outcrops above and race on, narrowly avoiding capture and presumably a life as breeding stock and/or death as harpy fodder.","The winged shadow of a "+talk.travelmountainflyer()+" flits across your path. but when you look up you see nothing.","Pebbles and rocks cascade from a ledge above.  You feel like you're being watched, and urge the party forward."]))
	elif zone.code == 'mountaincave':
		array.append_array(globals.getrandomfromarray(["","You pass a pile of cracked bare bones.  The stench of ammonia is overwhelming.  An ooze has fed here recently.","Totems appear around a corner.  This must be goblin territory.","The walls are slick with condensation as the temperature drops inside the caves.","You think you hear voices and order the party to halt in silence, but hear only dripping and your own breathing."]))
		var canread = false
		for i in party:
			if i.race in ['Elf','Dark Elf','Tribal Elf']:
				canread = true
		if canread:
			array.append_array(globals.getrandomfromarray(["There's writing on the wall here.  In some dialect of elvish, it reads: "+globals.getrandomfromarray(["Abandon hope any who enter.","Turn around cousin on pain of death, we serve you no longer.","We tolerate no intruders.","No Trespassing","Do Not Trespass","Scenic Cavern Ahead","Don't Feed the Ooze","Disclaimer: This enclave of dark elves is not responsible for dismemberment or death of any party trespassing herein."])]))
		else:
			array.append_array(globals.getrandomfromarray(["There's writing on the wall here.  "+globals.getrandomfromarray(["It's some dialect of elvish, but you cannot make it out","It's illegible to you, but an arrow pointing onward with an 'X' carved through it and skulls convey the meaning well enough."])]))
	array.append_array(globals.randomitemfromarray(["Your journey proceeds uneventfully","There's nothing much to see here.  Your party seems bored.","This part of the path seems like any other."]))	
	return globals.randomitemfromarray(array)

func getcya(zone):
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
#---End---#
