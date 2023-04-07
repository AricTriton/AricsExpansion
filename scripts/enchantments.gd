### <ModFile> ###

var enchantment_creation_ingredients = {
	enchdmg = {
		donor_races = ["Human"],
		essence_types = {taintedessenceing = 1, bestialessenceing = 1},
		flavor_text = "Humans don't have much magic, or sharp fangs - but they have weapons. And their blood can make your weapon more dangerous."
	},
	enchspeed = {
		donor_races = ["Harpy", "Seraph", "Fairy", "Bird"],
		essence_types = {bestialessenceing = 1, fluidsubstanceing = 1},
		flavor_text = "For your weapon to fly in your hand, you want blood of a flying race. Harpy, or Seraph, or Fairy, or Bird beastkin."
	},
	encharmor = {
		donor_races = ["Lizardfolk"],
		essence_types = {natureessenceing = 1, fluidsubstanceing = 1},
		flavor_text = "If you want your armor to protect you better, Lizardfolk blood is your best bet. Their scales are a natural armor."
	},
	enchstr = {
		donor_races = ["Orc", "Wolf", "Giant"],
		essence_types = {bestialessenceing = 2},
		flavor_text = "Orcs are strong. Wolves are strong. Giants are strong. These races have strong blood in them."
	},
	enchagi = {
		donor_races = ["Cat", "Fox", "Tanuki", "Squirrel"],
		essence_types = {fluidsubstanceing = 2},
		flavor_text = "Agility magic reacts with beastkin well - with Cats, Foxes, Tanukis and Squirrels best of all."
	},
	enchend = {
		donor_races = ["Taurus", "Centaur", "Otter"],
		essence_types = {natureessenceing = 2},
		flavor_text = "Hooved races such as Taurus and Centauri are renowned for their stamina. Otters are not bad, too."
	},
	enchmaf = {
		donor_races = ["Elf"],
		essence_types = {magicessenceing = 2},
		flavor_text = "To make your item more receptive to magic, you want Elf blood. Light or Dark or Tribal, does not matter."
	},
	enchhealth = {
		donor_races = ["Beastkin"],
		essence_types = {natureessenceing = 1, bestialessenceing = 1},
		flavor_text = "Beastkin blood has some echoes of wild and health in it.\nNote: Halfkin blood does not have enough health part."
	},
	enchenergy = {
		donor_races = ["Dryad"],
		essence_types = {magicessenceing = 1, natureessenceing = 1},
		flavor_text = "With their overflow of nature energy, Dryads blood is a natural conduit of energy enchantments."
	},
	enchcour = {
		donor_races = ["Wolf", "Orc", "Centaur"],
		essence_types = {magicessenceing = 1, bestialessenceing = 1},
		flavor_text = "Wolves, Orcs and Centaurs are not afraid of anyone - others are afraid of them."
	},
	enchconf = {
		donor_races = ["Seraph", "Dragonkin", "Harpy", "Lamia", "Nereid", "Scylla", "Bird"],
		essence_types = {magicessenceing = 1, natureessenceing = 1},
		flavor_text = "Navigating air or sea needs confidence in yourself, so aquatic and flying races are good donors of confidence."
	},
	enchwit = {
		donor_races = ["Elf", "Fox", "Tanuki"],
		essence_types = {magicessenceing = 1, fluidsubstanceing = 1},
		flavor_text = "Elves accumulate knowledge in their long life. And Foxes and Tanuki are just born witty. Any will do."
	},
	enchcharm = {
		donor_races = ["Cat", "Human"],
		essence_types = {magicessenceing = 1, taintedessenceing = 1},
		flavor_text = "Cats are champions of charm. And Humans are just so common to not startle anyone."
	},
	enchbeauty = {
		donor_races = ["Lamia", "Nereid", "Scylla", "Seraph"],
		essence_types = {taintedessenceing = 1, natureessenceing = 1},
		flavor_text = "Beauty enchantments come from exotic blood sources - try aquatic Lamias, Nereids, Scyllas. Or Seraphs."
	},
	enchfear = {
		donor_races = ["Arachna", "Slime", "Gnoll", "Ogre"],
		essence_types = {taintedessenceing = 2},
		flavor_text = "Fear can be induced with blood of more monstrous races - Arachae, Slimes, Gnolls or Ogres."
	},
	enchfearaccess = {
		donor_races = ["Arachna", "Slime", "Gnoll", "Ogre"],
		essence_types = {taintedessenceing = 2},
		flavor_text = "Fear can be induced with blood of more monstrous races - Arachae, Slimes, Gnolls or Ogres."
	},
	enchstress = {
		donor_races = ["Fairy", "Mouse", "Gnome", "Bird"],
		essence_types = {natureessenceing = 1, fluidsubstanceing = 1},
		flavor_text = "Smaller races typically have higher stress concentration - meaning Fairies, Mice, Gnomes and Birds."
	},
	enchobedmod = {
		donor_races = ["Human"],
		essence_types = {taintedessenceing = 1, bestialessenceing = 1},
		flavor_text = "Another trait of Humans is tendency to build hierarches, which cultivates obedience."
	},
	enchaccobedmod = {
		donor_races = ["Human"],
		essence_types = {taintedessenceing = 1, bestialessenceing = 1},
		flavor_text = "Another trait of Humans is tendency to build hierarches, which cultivates obedience."
	},
	enchlux = {
		donor_races = ["Dragonkin"],
		essence_types = {magicessenceing = 1, taintedessenceing = 1, fluidsubstanceing = 1},
		flavor_text = "Some say that Dragonkin blood contains gold in it. Maybe that's why it carries sense of luxury?"
	},
	enchlust = {
		donor_races = ["Goblin", "Bunny"],
		essence_types = {taintedessenceing = 1, bestialessenceing = 1, fluidsubstanceing = 1},
		flavor_text = "Goblins and Bunnies have the highest sex drive of all the races. Their blood will do."
	},
	enchunderstress = {
		donor_races = ["Cat", "Fox", "Wolf", "Bunny", "Tanuki", "Mouse", "Squirrel", "Otter"],
		essence_types = {magicessenceing = 1, taintedessenceing = 1, natureessenceing = 1},
		flavor_text = "Ever tried petting a Cat? They purr, and it's very nice. Most other Beastkin are also very pettable."
	},
	enchdailyenergy = {
		donor_races = ["Dryad"],
		essence_types = {taintedessenceing = 1, bestialessenceing = 1, natureessenceing = 1},
		flavor_text = "Dryad's nature energy can be harvested for faster recovery and deeper sleep."
	},
	enchtox = {
		donor_races = ["Demon"],
		essence_types = {magicessenceing = 1, taintedessenceing = 2},
		flavor_text = "Demons don't suffer from toxicity much. Need I say more?"
	},
}


var enchantments_by_effect = {} # contain both effect to array of enchantments, and enchantment to array of enchantments with same effect


var enchant_bbcode_colors = {
	basic = "green",
	unique = "#cc8400",
	custom = "#4fccbd",
	custom_blood = "#e32636",
}


var enchant_colors = {
	basic = Color.green.darkened(0.5), # from string constructor does not work on names 
	unique = Color(enchant_bbcode_colors["unique"]).darkened(0.2),
	custom = Color(enchant_bbcode_colors["custom"]).darkened(0.2),
	custom_blood = Color(enchant_bbcode_colors["custom_blood"]).darkened(0.2),
}


var _enchantment_id_to_id = {}

func _init():
	for enchantment_id in enchantmentdict:
		var enchantment = enchantmentdict[enchantment_id]
		_enchantment_id_to_id[enchantment.id] = enchantment

		if !enchantments_by_effect.has(enchantment.effect):
			enchantments_by_effect[enchantment.effect] = []
		enchantments_by_effect[enchantment.effect].append(enchantment_id)
		enchantments_by_effect[enchantment_id] = enchantments_by_effect[enchantment.effect]


func addrandomenchant(item, number = 1):
	var encharray = []
	var existingenchants = []
	var existingenchantsids = []
	if item.enchant != '': return
	for i in item.effects:
		existingenchants.append(i.effect)
		if i.has("id"):
			existingenchantsids.append(i.id)
	for i in enchantmentdict:
		if enchantmentdict[i].itemtypes.has(item.type) && !existingenchantsids.has(enchantmentdict[i].id):
			encharray.append(i)
	while number > 0 && encharray.size() > 0:
		number -= 1
		item.enchant = 'basic'
		var encharrayid = encharray[randi()%encharray.size()]
		var tempenchant = enchantmentdict[encharrayid]
		var enchant = {id = tempenchant.id, type = tempenchant.type, effect = tempenchant.effect, effectvalue = 0,
						descript = "", enchant_id = _enchantment_id_to_id[tempenchant.id]}
		encharray.erase(encharrayid)
		if tempenchant.has("mineffect") and tempenchant.has("maxeffect"):
			if tempenchant.maxeffect < 1:
				enchant.effectvalue = round(rand_range(tempenchant.mineffect, tempenchant.maxeffect)*100)/100
			else:
				enchant.effectvalue = round(rand_range(tempenchant.mineffect, tempenchant.maxeffect))
		elif tempenchant.has('effectvalue'):
			enchant.effectvalue = tempenchant.effectvalue
		var enchant_description = tempenchant.name.replace('&100v', str(enchant.effectvalue*100)).replace('&v', str(enchant.effectvalue))
		enchant.descript = '[color=%s]%s[/color]' % [enchant_bbcode_colors[item.enchant], enchant_description]
		
		item.effects += [enchant]