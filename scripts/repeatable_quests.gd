static func randsex():
	if globals.rules.male_chance > 0 && rand_range(0, 100) < globals.rules.male_chance:
		return 'male'
	elif rand_range(0, 100) < globals.rules.futa_chance && globals.rules.futa == true:
		return 'futanari'
	elif rand_range(0, 100) < globals.rules.dickgirl_chance && globals.rules.dickgirl == true:
		return 'dickgirl'
	else:
		return 'female'

static func randanyeyecolor():
	var text = globals.alleyecolors
	return text[randi()%text.size()]

static func randhybridrace():
	var text
	text = globals.dictionary.hybriddict.keys()
	text = text[randi()%text.size()]
	return text

func questarray():
	var questsarray = {
		quest001 = {
			code = '001',
			shortdescription = 'A local aristocrat wants an obedient servant for his house. ',
			description = 'A local nobleman is looking for an obedient worker for his estate, or someone who will provide one. The semi-famous house name provides some crediability to the customer. A $sex servant must present $himself meekly and have above avearge looks. Only humanoids. ',
			reqs = [['obed','gte', 80],['conf','lte',40],['beauty','gte',50],['bodyshape','eq','humanoid']],
			reqstemp = [['sex', 'eq', randsex()]],
			time = round(rand_range(4,7)),
			reward = round(rand_range(80,110))*10,
			location = ['any'],
			difficulty = 'medium'
		},
		quest002 = {
			code = '002',
			shortdescription = 'A senior citizen wants someone strong to help him around his residence. ',
			description = 'An old man looking for someone physically fit to take care of everyday tasks instead of him. ',
			reqs = [['obed','gte', 80],['send','gte',2], ['sstr','gte',2]],
			reqstemp = [],
			time = round(rand_range(5,10)),
			reward = round(rand_range(45,55))*10,
			location = ['wimborn','frostford'],
			difficulty = 'easy'
		},
		quest003 = {
			code = '003',
			shortdescription = 'Exquisite collector looking for a rare species.',
			description = 'A particularly elegant letterhead bears the nuanced description of a slave desired by a famously eccentric collector. A handsome reward is offered for the delivery of a $sex $race. ',
			reqs = [['obed','gte', 80]],
			reqstemp = [['age','eq',randage()],['race','eq',rarerace()],['sex', 'eq', randsex()]],
			time = round(rand_range(6,12)),
			reward = round(rand_range(75,90))*10,
			location = ['any'],
			difficulty = 'medium'
		},
		quest004 = {
			code = '004',
			shortdescription = 'Mage guild requests a dependable, clever worker.',
			description = 'One of the Mages Order’s carefully-scribed requisition letters is posted, detailing a new position available for full-time worker. Applicants should be versed in the Magical Arts and be very dependable.',
			reqs = [['obed','gte', 80], ['wit', 'gte', 60], ['smaf','gte',2],['conf', 'gte', 50]],
			reqstemp = [],
			time = round(rand_range(6,8)),
			reward = round(rand_range(75,95))*10,
			location = ['wimborn'],
			difficulty = 'medium'
		},
		quest005 = {
			code = '005',
			shortdescription = 'Brothel owner looking for a new resident.',
			description = "As the last $race girl has been bought out by one of her frequent customers, there's a dire need for a new one. ",
			reqs = [['obed','gte', 80], ['lewdness', 'gte', 25], ['beauty','gte',40]],
			reqstemp = [['race','eq',commonrace()]],
			time = round(rand_range(4,6)),
			reward = round(rand_range(45,70))*10,
			location = ['any'],
			difficulty = 'easy'
		},
		quest006 = {
			code = '006',
			shortdescription = "A market stall needs a helping hand. ",
			description = "One of the somewhat successful merchants has decided to get a dependable assistant. Besides being pleasant to look at, they must be able to handle all sorts of people they would be interacting with.",
			reqs = [['obed','gte', 80], ['conf', 'gte', 50],['charm','gte',40], ['beauty','gte',40]],
			reqstemp = [],
			time = round(rand_range(5,9)),
			reward = round(rand_range(75,95))*10,
			location = ['any'],
			difficulty = 'medium'
		},
		quest007 = {
			code = '007',
			shortdescription = "City guard looking for capable recruits. ",
			description = "A call to arms has been made by the Captain of the Watch, who is seeking a capable warrior to add to the ranks of the town guard. Prospective candidates must be able to follow orders, and have the courage to stand their ground against the city’s toughest criminals.",
			reqs = [['obed','gte', 80], ['cour','gte',50], ['sstr','gte',2], ['send', 'gte', 2]],
			reqstemp = [],
			time = round(rand_range(5,9)),
			reward = round(rand_range(75,100))*10,
			location = ['any'],
			difficulty = 'medium'
		},
		quest008 = {
			code = '008',
			shortdescription = "Local nobleman wants a dominant slave for bed-play. ",
			description = "An anonymous request was made by a certain nobleman, who is looking for a girl with strong character for his eccentric lewd plays. ",
			reqs = [['obed','gte', 80], ['sex','eq','female'], ['lewdness', 'gte', 25],['conf','gte',65], ['asser','gte',50]],
			reqstemp = [],
			time = round(rand_range(4,8)),
			reward = round(rand_range(75,110))*10,
			location = ['wimborn','frostford'],
			difficulty = 'medium'
		},
		quest009 = {
			code = '009',
			questreq = globals.rules.male_chance >= 10,
			shortdescription = "Undisclosed customer wants a very pretty boy of young age.",
			description = "A small note promises a hefty reward for delivery of an obedient boy for bed duty. It also specifies that a desirable appearance is required. ",
			reqs = [['obed','gte', 80], ['sex','eq','male'], ['age','eq','teen'], ['beauty','gte',70], ['hairlength','gte',3]],
			reqstemp = [],
			time = round(rand_range(4,8)),
			reward = round(rand_range(75,100))*10,
			location = ['wimborn','frostford'],
			difficulty = 'medium'
		},
		quest010 = {
			code = '010',
			shortdescription = "An eccentric experimenter requests a rare species.",
			description = "You find a note of one of the more proactive mages, searching for a subject of $race race for his dangerous experiments. He would like it to be at least somewhat cooperative and preferably smart. ",
			reqs = [['obed','gte', 40], ['wit','gte',40]],
			reqstemp = [['race','eq',rarerace()]],
			time = round(rand_range(6,12)),
			reward = round(rand_range(45,65))*10,
			location = ['wimborn','gorn'],
			difficulty = 'easy'
		},
		quest011 = {
			code = '011',
			shortdescription = "A local nobleman is looking for a bride for his son.",
			description = "The head of a noble house wants to arrange a marriage for his love-timid son. In order to preserve their aristocratic dynasty, a pure maiden of Noble descent is required. She must be knowledgeable in the management of an estate, and have an attractiveness befitting for nobility. ",
			reqs = [['obed','gte', 80], ['sex','eq','female'],['origins','eq','noble'],['beauty','gte',80] ],
			reqstemp = [],
			time = round(rand_range(6,12)),
			reward = round(rand_range(80,120))*10,
			location = ['wimborn','gorn'],
			difficulty = 'medium'
		},
		quest012 = {
			code = '012',
			shortdescription = "A traveller is looking for a reliable companion.",
			description = "A lone adventurer wants to purchase a steadfast person to keep them company on a long journey. ",
			reqs = [['obed','gte', 80], ['send','gte', 3], ['cour','gte',40]],
			reqstemp = [],
			time = round(rand_range(6,8)),
			reward = round(rand_range(45,65))*10,
			location = ['any'],
			difficulty = 'easy'
		},
		quest013 = {
			code = '013',
			shortdescription = "A widower is looking for a replacement for his deceased wife.",
			description = "A middle-aged man wishes to move on with his life but has been too reliant on cohabitant for past years. Having neither the confidence nor the time to look for new wife personally, he has decided to cut corners and try out a different approach. ",
			reqs = [['obed','gte', 80], ['sex','eq', 'female'], ['haircolor','eq',randhaircolor()], ['bodyshape','eq','humanoid']],
			reqstemp = [],
			time = round(rand_range(6,12)),
			reward = round(rand_range(40,50))*10,
			location = ['any'],
			difficulty = 'easy'
		},
		quest014 = {
			code = '014',
			shortdescription = "A rich kid desires a new toy.",
			description = "A fairly simple note from a rich and well-bred background requests a $race girl as a birthday present for their son. Hastily scribbled in one corner of the paper you can see 'MUST HAVE BIG BOOBS' in another style of handwriting. ",
			reqs = [['obed','gte', 80], ['sex','eq', 'female'],['titssize','gte',3]],
			reqstemp = [['race','eq',commonrace()]],
			time = round(rand_range(6,8)),
			reward = round(rand_range(50,60))*10,
			location = ['wimborn','gorn'],
			difficulty = 'easy'
		},
		quest015 = {
			code = '015',
			shortdescription = "An anonymous person is looking for half-pint slave.",
			description = "You spot a request for any of the tiny-sized races for unspecified reasons. It seems to lack any other hard requirement besides specifically not being slave descendants. ",
			reqs = [['obed','gte', 80],['bodyshape','eq','shortstack'],['origins','neq','slave']],
			reqstemp = [],
			time = round(rand_range(6,8)),
			reward = round(rand_range(40,50))*10,
			location = ['gorn','wimborn'],
			difficulty = 'easy'
		},
		quest016 = {
			code = '016',
			shortdescription = "Unspecified person desires a lively slave.",
			description = "A note desiring a high grade $sex slave. Taming is not needed. ",
			reqs = [['origins','gte','rich'], ['sex', 'eq', randsex()]],
			reqstemp = [],
			time = round(rand_range(6,8)),
			reward = round(rand_range(70,90))*10,
			location = ['any'],
			difficulty = 'medium'
		},
		quest017 = {
			code = '017',
			questreq = globals.rules.male_chance >= 10,
			shortdescription = "Noble seeks young squire.",
			description = "An elegant note describes the search for a young male to act as squire for a newly knighted lord.\nMust be well behaved and physically able. ",
			reqs = [['obed','gte', 80],['sex', 'eq', 'male'], ['sstr', 'gte', 2], ['age','neq','adult']],
			reqstemp = [],
			time = round(rand_range(7,12)),
			reward = round(rand_range(30,50))*10,
			location = ['wimborn','frostford'],
			difficulty = 'easy'
		},
		quest018 = {
			code = '018',
			shortdescription = "Fresh blood for our troupe!",
			description = "A traveling circus is looking to take in a new performer. Male or female doesn't matter, just that they be young, flexible, and a quick learner. ",
			reqs = [['obed','gte', 80], ['sagi', 'gte', 2], ['wit','gte',40], ['age','neq','adult']],
			reqstemp = [],
			time = round(rand_range(7,9)),
			reward = round(rand_range(35,55))*10,
			location = ['wimborn','gorn'],
			difficulty = 'easy'
		},
		quest019 = {
			code = '019',
			questreq = globals.rules.male_chance >= 15,
			shortdescription = "An anonymous woman desires a real man to satisfy her.",
			description = "A sexually frustrated wife is looking for a male slave to give her the attention she desperately craves. Looks should not be very high, to avoid husband's suspicion. Must be well endowed with good stamina! ",
			reqs = [['sex', 'eq', 'male'], ['obed','gte', 80],['send','gte',2],['beauty','lte',40],['penis','gte',1]],
			reqstemp = [],
			time = round(rand_range(7,12)),
			reward = round(rand_range(30,50))*10,
			location = ['wimborn','frostford'],
			difficulty = 'easy'
		},
		quest020 = {
			code = '020',
			questreq = globals.rules.furry == true,
			shortdescription = "Wanted: dogs for breeding purposes.",
			description = 'A rather plain and slightly crinkled notice explains how a certain quirky land owner is buying pure beastkin wolves for a "breeding project." Appearances should be decent but looks are a secondary concern at the moment.  ',
			reqs = [['race','eq','Beastkin Wolf'],['obed','gte', 80],['beauty','gte',20]],
			reqstemp = [['sex', 'eq', randsex()]],
			time = round(rand_range(7,12)),
			reward = round(rand_range(30,40))*10,
			location = ['wimborn','gorn'],
			difficulty = 'easy'
		},
		####Hard Quests
		quest021 = {
			code = '021',
			questreq = true,
			shortdescription = "Skilled Fighter",
			description = 'A rich local noble seeks for a very capable fighter for unspecified task. ',
			reqs = [['obed','gte', 100],['origins','gte','commoner']],
			reqstemp = [['sex', 'eq', randsex()], ['spec', 'eq', randcombspec()], ['level', 'gte', round(rand_range(3,5))]],
			reqsfunc = ['nobadtraits'],
			time = round(rand_range(22,30)),
			reward = round(rand_range(220, 315))*10,
			location = ['any'],
			difficulty = 'hard'
		},
		quest022 = {
			code = '022',
			questreq = true,
			shortdescription = "A high grade sex slave",
			description = 'A detailed note with a list of characteristics for future sex servant and a hefty price. ',
			reqs = [['obed','gte', 100],['beauty','gte',80], ['charm','gte',80], ['origins','gte','rich'], ['lewdness', 'gte', 65]],
			reqstemp = [['sex', 'eq', randsex()], ['spec', 'eq', randsexspec()],['age','eq',randage()]],
			reqsfunc = [],
			time = round(rand_range(20,35)),
			reward = round(rand_range(250, 350))*10,
			location = ['any'],
			difficulty = 'hard'
		},
		quest023 = {
			code = '023',
			questreq = true,
			shortdescription = "An exquisite doll",
			description = 'An anonymous request has been made for a slave matching an exact specification. ',
			reqs = [['obed','gte', 100],['beauty','gte',90], ['cour','lte',20], ['conf','lte',20]],
			reqstemp = [['sex', 'eq', randsex()],['age','eq',randage()], ['haircolor','eq',randanyhaircolor()], ['eyecolor','eq', randanyeyecolor()]],
			reqsfunc = [],
			time = round(rand_range(20,35)),
			reward = round(rand_range(250, 350))*10,
			location = ['any'],
			difficulty = 'hard'
		},
		quest024 = {
			code = '024',
			questreq = true,
			shortdescription = "Custom Hybrid Request",
			description = 'A local collector has placed a request for a certain hybrid for undisclosed purposes. ',
			reqs = [['obed','gte',50]],
			reqstemp = [['race_display', 'eq', randhybridrace()]],
			reqsfunc = [],
			time = round(rand_range(20,35)),
			reward = round(rand_range(250, 350))*10,
			location = ['any'],
			difficulty = 'hard'
		},
		quest025 = {
			code = '025',
			questreq = true,
			shortdescription = "Legendary Diva",
			description = 'An opera house in the capitol has placed a request for a certain hybrid to be trained to serenade the elite.\n\nBreeding Instructions: At least half Elf and as much elemental water affinity as can be managed. ',
			reqs = [['obed','gte',90],['sex', 'neq', 'male'],['race_display', 'eq', 'Siren']],
			reqstemp = [],
			reqsfunc = [],
			time = round(rand_range(20,35)),
			reward = round(rand_range(250, 350))*10,
			location = ['wimborn'],
			difficulty = 'hard'
		},
		quest026 = {
			code = '026',
			questreq = true,
			shortdescription = "Fresh Calamari",
			description = 'A wealthy widow has requested a sentient tentacle monster for undisclosed purposes.\n\nBreeding Instructions: At least half Scylla and with as much mana corruption as can be managed. ',
			reqs = [['obed','gte',80], ['lewdness', 'gte', 20], ['race_display', 'eq', 'Tentacle'],['sex', 'neq', 'female']],
			reqstemp = [],
			reqsfunc = [],
			time = round(rand_range(20,35)),
			reward = round(rand_range(250, 350))*10,
			location = ['wimborn'],
			difficulty = 'hard'
		},
		quest027 = {
			code = '027',
			questreq = true,
			shortdescription = "Teach My Son A Lesson",
			description = 'Local lord has experienced some success treating his third born son of alcoholism by forcing spirits on the boy and now requests a succubus to cure him of his whoring addiction.\n\nBreeding Instructions: At least half Demon and as close to half Bunnykin as can be managed. ',
			reqs = [['obed','gte',95],['sex', 'eq', 'female'],['race_display', 'eq', 'Succubus']],
			reqstemp = [],
			reqsfunc = [],
			time = round(rand_range(20,35)),
			reward = round(rand_range(250, 350))*12,
			location = ['wimborn'],
			difficulty = 'hard'
		},
		quest028 = {
			code = '028',
			questreq = true,
			shortdescription = "Role Model For Goblins",
			description = 'An indecipherable note with a bloody thumb print in place of a seal has been written over by the slave guild indicating that a nearby warlord is in search of a goblin brute to serve as an example for a contingent of conscripted goblins in training.\n\nBreeding Instructions: At least half Goblin and as close to an even mix of Orc and either Lamia, Arachna, or Slime as can be managed. ',
			reqs = [['obed','gte',80], ['sstr', 'gte', 4],['race_display', 'eq', 'Hobgoblin']],
			reqstemp = [],
			reqsfunc = [],
			time = round(rand_range(20,35)),
			reward = round(rand_range(250, 350))*10,
			location = ['gorn'],
			difficulty = 'hard'
		},
		quest029 = {
			code = '029',
			questreq = true,
			shortdescription = "Desert Caravan",
			description = 'A foreign merchant is sick and tired of half his revenue going to hauling water across the desert. He requests a Lizardkin to act as a caravan guard while surviving on minimal water.\n\nBreeding Instructions: At least half Orc and as much Lamia and Dragonkin as can be managed. ',
			reqs = [['obed','gte',80], ['sstr', 'gte', 2], ['send', 'gte', 1],['race_display', 'eq', 'Lizardman']],
			reqstemp = [],
			reqsfunc = [],
			time = round(rand_range(20,35)),
			reward = round(rand_range(250, 350))*10,
			location = ['gorn'],
			difficulty = 'hard'
		},
		quest030 = {
			code = '030',
			questreq = true,
			shortdescription = "Crazy Old Erasmus",
			description = 'The crazy old hermit in the Marsh posted a tattered note requesting a well camoflaged guard.\n\nBreeding Instructions: At least half Dryad and as close to quarter Gnome and quarter Taurus as can be managed. ',
			reqs = [['obed','gte',50],['race_display', 'eq', 'Ent']],
			reqstemp = [],
			reqsfunc = [],
			time = round(rand_range(20,35)),
			reward = round(rand_range(250, 350))*10,
			location = ['frostford'],
			difficulty = 'hard'
		},
		quest031 = {
			code = '031',
			questreq = true,
			shortdescription = "A Sandbag That Bleeds",
			description = 'An arena master from a neighboring country seeks a living practice dummy his gladiators can practice on without having to replace so often.\n\nBreeding Instructions: At least half Orc and posessing a significant elemental earth affinity. ',
			reqs = [['obed','gte',80],['race_display', 'eq', 'Troll']],
			reqstemp = [],
			reqsfunc = [],
			time = round(rand_range(20,35)),
			reward = round(rand_range(250, 350))*10,
			location = ['gorn'],
			difficulty = 'hard'
		},
		quest032 = {
			code = '032',
			questreq = true,
			shortdescription = "A Fleet Messenger",
			description = 'City Hall has posted a request for Sylph to be trained as an especially swift messenger.\n\nBreeding Instructions: At least half Fairy and as much wind elemental affinity as can be managed. ',
			reqs = [['obed','gte',95],['race_display', 'eq', 'Sylph']],
			reqstemp = [],
			reqsfunc = [],
			time = round(rand_range(20,35)),
			reward = round(rand_range(250, 350))*10,
			location = ['frostford'],
			difficulty = 'hard'
		},
		quest033 = {
			code = '033',
			questreq = true,
			shortdescription = "Crazy Old Erasmus",
			description = 'The crazy old hermit in the Marsh posted a tattered note requesting a well camoflaged guard.\n\nBreeding Instructions: At least half Arachna and as much elemental water affinity as can be managed. ',
			reqs = [['obed','gte',50],['race_display', 'eq', 'Crabkin']],
			reqstemp = [],
			reqsfunc = [],
			time = round(rand_range(20,35)),
			reward = round(rand_range(250, 350))*10,
			location = ['frostford'],
			difficulty = 'hard'
		},
		quest034 = {
			code = '034',
			shortdescription = 'Buy and Release. ',
			description = 'A local $race group are buying enslaved $race of any type to restore them to freedom. Taming is not required. ',
			reqs = [['race','eq',commonrace()]],
			reqstemp = [],
			time = round(rand_range(3,5)),
			reward = round(rand_range(20,40))*10,
			location = ['any'],
			difficulty = 'easy'
		},
		quest035 = {
			code = '035',
			shortdescription = 'Adventuring party needs dedicated healer. ',
			description = 'A varied group of adventurers are in desperate need of a healer for their travels. The healer must have high skills in magic, the courage to not falter even in grim circumstances and be ever loyal to the party. ',
			reqs = [['obed','gte', 80], ['smaf','gte', 3], ['cour','gte',40]],
			reqstemp = [['sex', 'eq', randsex()]],
			time = round(rand_range(6,8)),
			reward = round(rand_range(80,110))*10,
			location = ['any'],
			difficulty = 'medium'
		},
		quest036 = {
			code = '036',
			questreq = globals.rules.children == true,
			shortdescription = 'Older gentleman seeks young heir. ',
			description = 'An aged man needs to name an heir for his estate. He requires a young $race boy with similar physical features to himself and carry himself fairly well. The boy must be well behaved and quite smart for his age.',
			reqs = [['race','eq',commonrace()], ['sex', 'eq', 'male'], ['obed','gte', 80], ['origins','gte','common'], ['wit','gte',40], ['haircolor','eq',randhaircolor()], ['eyecolor','eq',randanyeyecolor()], ['age','eq','child']],
			reqstemp = [],
			time = round(rand_range(4,7)),
			reward = round(rand_range(90,120))*10,
			location = ['wimborn'],
			difficulty = 'hard'
		},
		quest037 = {
			code = '037',
			questreq = globals.rules.children == true,
			shortdescription = 'Needing a young servant girl. ',
			description = 'A call for a young girl to act as servant and playmate has been issued by a well off family for their growing daughter. The girl in need must be biddable, quick and submissive.',
			reqs = [['sex', 'eq', 'female'], ['obed','gte', 80], ['sagi','gte',3], ['cour','lte',40], ['age','eq','child'], ['bodyshape','eq','humanoid']],
			reqstemp = [],
			time = round(rand_range(5,9)),
			reward = round(rand_range(70,90))*10,
			location = ['any'],
			difficulty = 'medium'
		},
		quest038 = {
			code = '038',
			shortdescription = 'Looking for a suitable mate. ',
			description = "A member of the $rare race desires a worthy mate for reproductive purposes. $He must be at least average in appearance and open to $his mate's commands. ",
			reqs = [['obed','gte', 80],['beauty','gte',50]],
			reqstemp = [['sex', 'eq', randsex()], ['race','eq',rarerace()]],
			time = round(rand_range(6,10)),
			reward = round(rand_range(80,110))*10,
			location = ['any'],
			difficulty = 'medium'
		},
		quest039 = {
			code = '039',
			shortdescription = 'Buying Equine Mares. ',
			description = "The wealthy owner of quality race horses needs a new female centaur to keep his stallions in good temperment. Taming is not required, and looks aren't important but she should have decent endurance. ",
			reqs = [['sex', 'eq', 'female'], ['bodyshape','eq','halfhorse'], ['send', 'gte', 2]],
			reqstemp = [],
			time = round(rand_range(6,10)),
			reward = round(rand_range(50,80))*10,
			location = ['gorn'],
			difficulty = 'medium'
		},
		quest040 = {
			code = '040',
			shortdescription = 'Exotic pet. ',
			description = 'A wealthy merchant is seeking a new pet to display during an upcoming social event. He requires a $rare slave of exceptional beauty and grace to delight his guests. ',
			reqs = [['obed','gte', 80],['beauty','gte',70]],
			reqstemp = [['sex', 'eq', randsex()], ['race','eq',rarerace()]],
			time = round(rand_range(4,7)),
			reward = round(rand_range(80,100))*10,
			location = ['gorn'],
			difficulty = 'medium'
		},
		quest041 = {
			code = '041',
			shortdescription = 'Ritual Help. ',
			description = 'An influential group of magic enthusiasts are needing a "new member" to join in on an upcoming ceremony. The request stresses that the person meet exact criteria and preferably have no family ties. ',
			reqs = [],
			reqstemp = [['sex', 'eq', randsex()],['haircolor','eq',randhaircolor()]],
			time = round(rand_range(3,5)),
			reward = round(rand_range(10,20))*10,
			location = ['wimborn'],
			difficulty = 'easy'
		},
		quest042 = {
			code = '042',
			shortdescription = 'Hiring A Real Brute. ',
			description = 'An eccentric and wealthy man wants a "right and proper ugly brute" to act as a personal bodyguard. Everything about him MUST be huge and intimidating. ',
			reqs = [['obed','gte', 80],['beauty','lte',30],['sex', 'eq', 'male'],['age','eq','adult'],['sstr','gte',4], ['penis','gte',1]],
			reqstemp = [],
			time = round(rand_range(4,7)),
			reward = round(rand_range(120,150))*10,
			location = ['gorn'],
			difficulty = 'hard'
		},
		quest043 = {
			code = '043',
			shortdescription = 'New Housekeeper. ',
			description = 'An upperclass household is seeking to buy the contract for a good maid to eventually replace their aging stewardess. She must be very capable in all domestic duties and be able to delegate tasks. The stewardess of the house is quite strict with her underlings and demands perfection of a would-be successor.',
			reqs = [['obed','gte', 90],['sex', 'eq', 'female'],['age','eq','adult'], ['bodyshape','eq','humanoid'], ['sagi','gte', 4], ['conf','gte',40], ['spec', 'eq', 'housekeeper']],
			reqstemp = [],
			time = round(rand_range(6,8)),
			reward = round(rand_range(80,110))*10,
			location = ['any'],
			difficulty = 'hard'
		},
		quest044 = {
			code = '044',
			shortdescription = 'Wet Nurse Needed. ',
			description = "A rich household needs to acquire a competent wet nurse quickly due to a new mother's poor health. Despite the urgency, there is a strict list of requirements. The new father is willing to pay a high sum for an expedited sale.",
			reqs = [['obed','gte', 90],['sex', 'eq', 'female'],['age','eq','adult'], ['bodyshape','eq','humanoid'], ['titssize','gte',4], ['lactation','eq',true]],
			reqstemp = [],
			time = round(rand_range(1,2)),
			reward = round(rand_range(200,230))*10,
			location = ['any'],
			difficulty = 'hard'
		},
		quest045 = {
			code = '045',
			shortdescription = "I don't want an animal, but... ",
			description = 'A note scribbled in rough ink states the following: I think animal fuckers are disgusting and beastkin are just animals walking upright. BUT. I am currently looking for a hot HALFKIN bitch ready to accept orders. ',
			reqs = [['obed','gte', 80],['sex', 'eq', 'female'],['race','eq','Halfkin Wolf', 'Halfkin Cat', 'Halfkin Fox', 'Halfkin Bunny', 'Halfkin Tanuki'],['beauty','gte',50]],
			reqstemp = [],
			time = round(rand_range(7,12)),
			reward = round(rand_range(30,50))*10,
			location = ['wimborn','gorn'],
			difficulty = 'easy'
		},
		quest046 = {
			code = '046',
			shortdescription = 'Dairy Delivery. ',
			description = 'You can faintly see the logo of a well known dairy farm under a thick splotch of ink on a request for a heavily modified taurus.',
			reqs = [['obed','gte', 80],['sex', 'eq', 'female'],['titsextra','eq',true], ['titssize','gte',4], ['spec','eq','hucow'], ['lactation','eq',true]],
			reqstemp = [],
			time = round(rand_range(5,6)),
			reward = round(rand_range(240,320))*10,
			location = ['wimborn','gorn'],
			difficulty = 'hard'
		},
	}
	return questsarray
