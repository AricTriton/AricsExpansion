
###---Added by Expansion---### Sizes Expanded
func getsexfeatures(person):
	var temp
	var dick = false
	var pussy = false
	if person.race.find("Beastkin") >= 0 && globals.rules.furrynipples == true:
		person.titsextra = 3
	if person.sex == 'male':
		person.asser = rand_range(30,90)
		dick = true
		if person.age == 'child':
			temp = ['flat']
		else:
			temp = ['flat','masculine']
		person.asssize = getrandomfromarray(temp)
		person.titssize = getrandomfromarray(temp)
		#Lip Sizes
		temp = ['masculine','thin','small','average']
		person.lips = getrandomfromarray(temp)
	else:
		#Tit Sizing
		temp = ['flat','small','average','big','huge']
		person.asser = rand_range(10,70)
		###---Added by Expansion---### centerflag982 - handle dickgirl genitals
		if person.sex != 'dickgirl':
			pussy = true
		if person.sex == 'futanari' || person.sex == 'dickgirl':
			dick = true
		###---End Expansion---###
		if person.age == 'child':
			temp.append('flat')
			temp.append('small')
		elif person.age == 'teen':
			temp.append('small')
			temp.append('average')
		person.titssize = getrandomfromarray(temp)
		for i in ['Taurus','Demon','Seraph','Centaur','Orc','Gnoll']:
			if person.race.find(i) >= 0 && rand_range(0,1) > .5:
				if globals.titssizearray.back() != person.titssize:
					person.titssize = globals.titssizearray[globals.titssizearray.find(person.titssize)+1]
		#Ass Sizing
		person.asssize = getrandomfromarray(temp)
		for i in ['Taurus','Centaur','Gnome','Goblin']:
			if person.race.find(i) >= 0 && rand_range(0,1) > .5:
				if globals.asssizearray.back() != person.asssize:
					person.asssize = globals.asssizearray[globals.titssizearray.find(person.asssize)+1]
		#Add Lip Sizes
		temp = ['thin','small','average','big','huge','plump']
		if person.age in ['teen','adult']:
			temp.append('small')
			temp.append('average')
			temp.append('big')
		for i in ['Gnome','Orc','Taurus']:
			if person.race.find(i) >= 0:
				temp.append('big')
				temp.append('big')
				temp.append('plump')
		person.lips = getrandomfromarray(temp)
	if dick == true:
		###---Added by Expansion---### Sizes Expanded
		temp = globals.penissizearray.duplicate()
		if person.age in ['child','teen']:
			temp.append('tiny')
			temp.append('small')
		for i in ['Gnome','Goblin','Fairy','Harpy']:
			if person.race.find(i) >= 0:
				temp.append('tiny')
				temp.append('small')
				temp.append('small')
		for i in  ['Orc','Demon','Dragonkin','Taurus','Centaur','Wolf']:
			if person.race.find(i) >= 0:
				temp.append('large')
				temp.append('large')
				temp.append('massive')
		person.penis = getrandomfromarray(temp)
		###---Added by Expansion---### centerflag982 - handle dickgirl genitals
		if person.sex == 'male' || person.sex == 'dickgirl' || globals.rules.futaballs == true:
			person.balls = getrandomfromarray(temp)
		else:
		###---End Expansion---###
			person.balls = 'none'
	else:
		person.penis = 'none'
		person.balls = 'none'
	if pussy == true:
		###---Added by Expansion---### Sizes Expanded
		if person.age == 'child':
			temp = ['tiny','tiny','tiny','tight','tight','tight','average','average']
		elif person.age == 'teen':
			temp = ['tiny','tiny','tight','tight','tight','average','average','average','loose']
		else:
			temp = ['tiny','tight','average','average','average','loose']
		person.vagina = getrandomfromarray(temp)
		###---End Expansion---###
	else:
		person.vagina = 'none'
		person.preg.has_womb = false
	
	if person.penis != 'none' && (person.race.find('Beastkin') >= 0 || person.race.find('Dragonkin') >= 0 || person.race.find('Kobold') >= 0 || person.race.find('Lizardfolk') >= 0 || person.race.find('Avali') >= 0 || person.race.find('Gnoll') >= 0):
		if person.race.find('Cat') >= 0:
			person.penistype = 'feline'
		elif person.race.find('Fox') >= 0 || person.race.find('Wolf') >= 0 || person.race.find('Gnoll') >= 0:
			person.penistype = 'canine'
		elif person.race.find('Dragonkin') >= 0 || person.race.find('Kobold') >= 0 || person.race.find('Lizardfolk') >= 0:
			person.penistype = 'reptilian'
		elif person.race.find('Mouse') >= 0 || person.race.find('Squirrel') >= 0 || person.race.find('Otter') >= 0:
			person.penistype = 'rodent'
		elif person.race.find('Avali') >= 0 || person.race.find('Bird') >= 0:
			person.penistype = 'bird'
	if person.penis != 'none' && person.race.find('Centaur') >= 0:
		person.penistype = 'equine'
	getheight(person)
	gethair(person)
	getname(person)
	
	###---Added by Expansion---### Sizes Expanded
	if person.age == 'child':
		temp = ['tiny','tiny','tiny','tight','tight','tight','average','average']
	elif person.age == 'teen':
		temp = ['tiny','tiny','tight','tight','tight','average','average','average','loose']
	else:
		temp = ['tiny','tight','average','average','average','loose','gaping']
	person.asshole = getrandomfromarray(temp)
	
	globals.expansionsetup.expandPerson(person)
	###---End Expansion---###
###---End Expansion---###

func gethair(person):
	if person.sex == 'male':
		person.hairlength = getrandomfromarray(['bald','ear','ear','ear','neck','neck','shoulder'])
		person.hairstyle = getrandomfromarray(['straight', 'straight', 'straight', 'straight', 'ponytail'])
	else:
		if person.age == 'child':
			person.hairlength = getrandomfromarray(['bald','ear','neck','shoulder'])
		elif person.age == 'teen':
			person.hairlength = getrandomfromarray(['bald','ear','neck','shoulder','waist'])
		else:
			person.hairlength = getrandomfromarray(['bald','ear','neck','shoulder','waist','hips'])
		
		if person.hairlength != 'short' && rand_range(0,10) < 6:
			person.hairstyle = getrandomfromarray(['ponytail', 'twintails', 'braid', 'two braids', 'bun'])
		else:
			person.hairstyle = 'straight'
###---Added by Expansion---### centerflag982 - makes sure dickgirls get names too
func getname(person):
	var tempSex = person.sex.replace("futanari",'female').replace("dickgirl",'female')
	var text = person.race.to_lower()+tempSex
	if !globals.racefile.names.has(text):
		if person.race in ['Dark Elf', 'Drow']:
			text = 'elf'+person.sex.replace("futanari",'female').replace("dickgirl",'female')
		elif person.race == 'Dryad':
			text = 'dryadfemale'
		elif person.race == 'Scylla':
			text = 'nereid'+person.sex.replace("futanari",'female').replace("dickgirl",'female')
		else:
			text = 'human'+person.sex.replace("futanari",'female').replace("dickgirl",'female')
	person.name = getrandomfromarray(globals.names[text])
###---End Expansion---###
