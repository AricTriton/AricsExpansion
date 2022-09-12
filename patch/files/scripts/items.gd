extends Node


var person
var main
var enchantscript = load("res://files/scripts/enchantments.gd").new()


func enchantrand(item, number = 1):
	enchantscript.addrandomenchant(item, number)

var itemlist = {
	food = {
		code = 'food',
		name = 'Provisions',
		icon = load("res://files/images/items/food.png"),
		description = "Various assortments of preserved food servable for daily ration. Mostly stale, yet in high demand. \nPrice for 20 units.",
		effect = "foodpurchase",
		recipe = '',
		cost = 10,
		type = 'dummy',
		amount = 0,
		reqs = true,
	},
	supply = {
		code = 'supply',
		name = 'Supplies',
		icon = load("res://files/images/items/supply.png"),
		description = "An assemblance of various commodities which can be sold or used in certain tasks. Required for outside camping",
		effect = "supplypurchase",
		recipe = '',
		cost = 5,
		type = 'ingredient',
		amount = 0,
		weight = 2,
		reqs = true,
	},
	#FarmItems
	prods = {
		code = 'prods',
		name = 'Cattle Prods',
		icon = load("res://files/aric_expansion_images/potions/rendrassa_sedative_potion_bottle.png"), # TBK - Add prods image
		description = "Used to control cattle", # TBK - Replace placeholder text
		effect = '',
		recipe = '',
		cost = 75,
		type = 'dummy',
		amount = 0,
		reqs = true,
	},
	#ExplorationItems
	rope = {
		code = 'rope',
		name = 'Ropes',
		icon = load("res://files/images/items/rope.png"),
		description = "A sturdy rope required for safe transfer of unwilling slaves.\n\n[color=yellow]Must be in possession to capture defeated people. [/color]",
		effect = "rope",
		recipe = '',
		cost = 50,
		type = 'supply',
		amount = 0,
		weight = 3,
		reqs = true,
	},
	torch = {
		code = 'torch',
		name = 'Torch',
		icon = load("res://files/images/items/torch.png"),
		description = "A simple source of light during night or enclosed spaces. ",
		effect = "torch",
		recipe = '',
		cost = 25,
		type = 'supply',
		amount = 0,
		weight = 3,
		reqs = true,
	},
	teleportseal = {
		code = 'teleportseal',
		name = 'Teleportation Seal',
		icon = load("res://files/images/items/teleportseal.png"),
		description = "Magical device allowing a single person to teleport to specified personal location. \n\n[color=yellow]Allows to send captured people to your mansion without going with them.[/color]",
		effect = "teleportsealeffect",
		recipe = '',
		cost = 20,
		type = 'supply',
		amount = 0,
		weight = 1,
		reqs = true,
	},
	bandage = {
		code = 'bandage',
		name = 'Bandages',
		icon = load("res://files/images/items/bandage.png"),
		description = "A portable way to patch up an injured person. Restores 33% of health (20% if used recently).",
		effect = "bandageeffect",
		recipe = '',
		cost = 15,
		type = 'supply',
		amount = 0,
		weight = 2,
		reqs = true,
	},
	lockpick = {
		code = 'lockpick',
		name = 'Lockpicks',
		icon = load("res://files/images/items/lockpick.png"),
		description = "Assemblance of various tools for certain precisive tasks.",
		effect = "",
		recipe = '',
		cost = 20,
		type = 'supply',
		amount = 0,
		weight = 2,
		reqs = true,
	},
	teleportwimborn = {
		code = 'teleportwimborn',
		name = 'Teleportation Stone: Wimborn',
		icon = load("res://files/images/items/teleportwimborn.png"),
		description = "A waypoint stone made by skilled Arcanesmith which allows personal transportation to specific faraway places when integrated into specifically designed mechanisms. \n\n[color=yellow]Unlocks teleportation to Wimborn.[/color] ",
		effect = "teleportunlock",
		recipe = '',
		cost = 500,
		type = 'dummy',
		amount = 0,
		reqs = true,
	},
	teleportgorn = {
		code = 'teleportgorn',
		name = 'Teleportation Stone: Gorn',
		icon = load("res://files/images/items/teleportgorn.png"),
		description = "A waypoint stone made by skilled Arcanesmith which allows personal transportation to specific faraway places when integrated into specifically designed mechanisms. \n\n[color=yellow]Unlocks teleportation to Gorn.[/color] ",
		effect = "teleportunlock",
		recipe = '',
		cost = 500,
		type = 'dummy',
		amount = 0,
		reqs = true,
	},
	teleportfrostford = {
		code = 'teleportfrostford',
		name = 'Teleportation Stone: Frostford',
		icon = load("res://files/images/items/teleportfrostford.png"),
		description = "A waypoint stone made by skilled Arcanesmith which allows personal transportation to specific faraway places when integrated into specifically designed mechanisms. \n\n[color=yellow]Unlocks teleportation to Frostford.[/color] ",
		effect = "teleportunlock",
		recipe = '',
		cost = 500,
		type = 'dummy',
		amount = 0,
		reqs = true,
	},
	teleportamberguard = {
		code = 'teleportamberguard',
		name = 'Teleportation Stone: Amberguard',
		icon = load("res://files/images/items/teleportamberguard.png"),
		description = "A waypoint stone made by skilled Arcanesmith which allows personal transportation to specific faraway places when integrated into specifically designed mechanisms. \n\n[color=yellow]Unlocks teleportation to Amberguard.[/color]",
		effect = "teleportunlock",
		recipe = '',
		cost = 1500,
		type = 'dummy',
		amount = 0,
		reqs = true,
	},
	teleportumbra = {
		code = 'teleportumbra',
		name = 'Teleportation Stone: Umbra',
		icon = load("res://files/images/items/teleportumbra.png"),
		description = "A waypoint stone made by skilled Arcanesmith which allows personal transportation to specific faraway places when integrated into specifically designed mechanisms. \n\n[color=yellow]Unlocks teleportation to Umbra.[/color] ",
		effect = "teleportunlock",
		recipe = '',
		cost = 500,
		type = 'dummy',
		amount = 0,
		reqs = true,
	},
	aphrodisiac = {
		code = 'aphrodisiac',
		name = 'Aphrodisiac',
		icon = load("res://files/images/items/aphrodisiacpot.png"),
		description = "The simple dream drug of the past. Increases the drinker's lust. ",
		effect = 'aphrodisiaceffect',
		recipe = 'recipeaphrodisiac',
		cost = 75,
		type = 'potion',
		toxicity = 15,
		reqs = 'globals.state.mansionupgrades.mansionalchemy >= 1',
		weight = 1,
		amount = 0
	},
	hairdye = {
		code = 'hairdye',
		name = 'Hair Dye',
		icon = load("res://files/images/items/hairdyepot.png"),
		description = "Allows you to permanently change hair color when applied. For external use only. ",
		effect = 'hairdyeeffect',
		recipe = '',
		cost = 50,
		toxicity = 0,
		reqs = false,
		weight = 1,
		amount = 0,
		type = 'potion',
	},
	hairgrowthpot = {
		code = 'hairgrowthpot',
		name = 'Hair Growth Elixir',
		icon = load("res://files/images/items/hairgrowthpot.png"),
		description = "Makes hair grow instantly! A tiny disclaimer says this potion is not a FairyCo. product. ",
		effect = 'hairgrowtheffect',
		recipe = 'recipehairgrowth',
		cost = 120,
		type = 'potion',
		toxicity = 15,
		reqs = 'globals.state.mansionupgrades.mansionalchemy >= 1',
		weight = 1,
		amount = 0
	},
	maturingpot = {
		code = 'maturingpot',
		name = 'Maturing Elixir',
		icon = load("res://files/images/items/maturingpot.png"),
		description = "Causes a rapid acceleration in user's physical growth, results may vary. ",
		effect = 'maturingpot',
		recipe = 'recipematuringpot',
		cost = 200,
		type = 'potion',
		toxicity = 40,
		reqs = 'globals.state.mainquest >= 6',
		weight = 1,
		amount = 0
	},
	youthingpot = {
		code = 'youthingpot',
		name = 'Youthing Elixir',
		icon = load("res://files/images/items/youthingpot.png"),
		description = "Causes a regression of user's physical growth. 'Cause the smaller, the cuter. ",
		effect = 'youthingpot',
		recipe = 'recipeyouthingpot',
		cost = 200,
		type = 'potion',
		toxicity = 40,
		reqs = 'globals.state.mainquest >= 6',
		weight = 1,
		amount = 0
	},
	regressionpot = {
		code = 'regressionpot',
		name = 'Elixir of Regression',
		icon = load("res://files/images/items/regressionpot.png"),
		description = "Causes a regression of user's mental state to that of a child. Dangerous, but quite effective when you have a need to rehabilitate someone from their inconvenient character.",
		effect = 'regressionpoteffect',
		recipe = '',
		cost = 400,
		type = 'potion',
		toxicity = 50,
		reqs = false,
		weight = 1,
		amount = 0
	},
	claritypot = {
		code = 'claritypot',
		name = 'Elixir of Clarity',
		icon = load("res://files/images/items/claritypot.png"),
		description = "A strong mixture allowing the removal of persistent mental qualities.",
		effect = 'claritypoteffect',
		recipe = 'recipeclaritypot',
		cost = 750,
		type = 'potion',
		toxicity = 50,
		reqs = 'globals.state.mansionupgrades.mansionalchemy >= 2',
		weight = 1,
		amount = 0
	},
	amnesiapot = {
		code = 'amnesiapot',
		name = 'Amnesia Potion',
		icon = load("res://files/images/items/amnesiapot.png"),
		description = "Erases memories of the past (won't affect backstory or impactful experience). Removes vices.",
		effect = 'amnesiapoteffect',
		recipe = 'recipeamnesiapot',
		cost = 200,
		type = 'potion',
		toxicity = 25,
		reqs = 'globals.state.mansionupgrades.mansionalchemy >= 1',
		weight = 1,
		amount = 0
	},
	lactationpot = {
		code = 'lactationpot',
		name = 'Nursing Potion',
		icon = load("res://files/images/items/nursingpot.png"),
		description = "Special mixture causing perpetual lactation.",
		effect = 'lactationpoteffect',
		recipe = 'recipelactationpot',
		cost = 100,
		type = 'potion',
		toxicity = 20,
		reqs = 'globals.state.mansionupgrades.mansionalchemy >= 1',
		weight = 1,
		amount = 0
	},
	oblivionpot = {
		code = 'oblivionpot',
		name = 'Oblivion Potion',
		icon = load("res://files/images/items/oblivionpot.png"),
		description = "The drinker of this potion experiences a form of targeted amnesia, retaining their personality but clearing their fixations.\n\n[color=aqua]Resets level-up requirement.[/color]",
		effect = 'oblivionpoteffect',
		recipe = 'recipeoblivionpot',
		cost = 300,
		type = 'potion',
		toxicity = 50,
		reqs = 'globals.state.mansionupgrades.mansionalchemy >= 2',
		weight = 1,
		amount = 0
	},
	miscariagepot = {
		code = 'miscariagepot',
		name = 'Miscariage Potion',
		icon = load("res://files/images/items/miscarriagepot.png"),
		description = "The temporal solution to shortsightedness.",
		effect = 'misscariageeffect',
		recipe = 'recipemiscariagepot',
		cost = 100,
		type = 'potion',
		toxicity = 20,
		reqs = 'globals.state.mansionupgrades.mansionalchemy >= 1',
		weight = 1,
		amount = 0
	},
	stimulantpot = {
		code = 'stimulantpot',
		name = 'Stimulant Potion',
		icon = load("res://files/images/items/stimulantpot.png"),
		description = "Boosts person's sensitivity and strengthens mental response.",
		effect = 'stimulanteffect',
		recipe = 'recipestimulantpot',
		cost = 150,
		type = 'potion',
		toxicity = 20,
		reqs = 'globals.state.mansionupgrades.mansionalchemy >= 1',
		weight = 1,
		amount = 0
	},
	deterrentpot = {
		code = 'deterrentpot',
		name = 'Deterrent Potion',
		icon = load("res://files/images/items/deterrentpot.png"),
		description = "Dulls person's sensitivity and weakens mental response.",
		effect = 'deterrenteffect',
		recipe = 'recipedeterrentpot',
		cost = 150,
		type = 'potion',
		toxicity = 20,
		reqs = 'globals.state.mansionupgrades.mansionalchemy >= 1',
		weight = 1,
		amount = 0
	},
	minoruspot = {
		code = 'minoruspot',
		name = 'Minorus Concoction',
		icon = load("res://files/images/items/minoruspot.png"),
		description = "Application of this potion will reduce cumbersome body parts to more manageable sizes. For External use only.",
		effect = 'minoruseffect',
		recipe = 'recipeminoruspot',
		cost = 250,
		type = 'potion',
		toxicity = 30,
		reqs = 'globals.state.mansionupgrades.mansionalchemy >= 1',
		weight = 1,
		amount = 0
	},
	majoruspot = {
		code = 'majoruspot',
		name = 'Majorus Concoction',
		icon = load("res://files/images/items/majoruspot.png"),
		description = "Apply to various parts of someone's anatomy for rapid and fantastic results! For external use only.",
		effect = 'majoruseffect',
		recipe = 'recipemajoruspot',
		cost = 250,
		type = 'potion',
		toxicity = 30,
		reqs = 'globals.state.mansionupgrades.mansionalchemy >= 1',
		weight = 1,
		amount = 0
	},
	beautypot = {
		code = 'beautypot',
		name = 'Beauty Mixture',
		icon = load("res://files/images/items/beautypot.png"),
		description = "Clears the complexion and smoothes unsightly contours. Temporal effect. Administer with care. ",
		effect = 'beautyeffect',
		recipe = '',
		cost = 50,
		type = 'potion',
		toxicity = 10,
		reqs = false,
		weight = 1,
		amount = 0
	},
	aphroditebrew = {
		code = 'aphroditebrew',
		name = 'Aphrodite Brew',
		icon = load("res://files/images/items/aphroditespot.png"),
		description = "Extremely potent mixture of aphrodisiacs. Even slightest amounts of this can easily dim person's mind and awake their carnal desires. \n[color=yellow]Can't be used for single person, required to start orgy. [/color]",
		effect = '',
		recipe = 'recipeaphroditebrew',
		cost = 400,
		type = 'ingredient',
		reqs = 'globals.state.mansionupgrades.mansionalchemy >= 2',
		weight = 1,
		amount = 0
	},
	basicsolutioning = {
		code = 'basicsolutioning',
		name = 'Basic Solution',
		icon = load("res://files/images/items/basicsolution.png"),
		description = "Primal ingredient which is used as base for many potions.",
		effect = '',
		recipe = '',
		cost = 20,
		type = 'ingredient',
		reqs = false,
		weight = 1,
		amount = 0
	},
	magicessenceing = {
		code = 'magicessenceing',
		name = 'Magic Essence',
		icon = load("res://files/images/items/magicessence.png"),
		description = "A gleaming substance, rich with potent energy.",
		effect = '',
		recipe = '',
		cost = 50,
		type = 'ingredient',
		reqs = false,
		weight = 1,
		amount = 0
	},
	taintedessenceing = {
		code = 'taintedessenceing',
		name = 'Tainted Essence',
		icon = load("res://files/images/items/taintedessence.png"),
		description = "A dark substance, imbued with corrupting magic.",
		effect = '',
		recipe = '',
		cost = 50,
		type = 'ingredient',
		reqs = false,
		weight = 1,
		amount = 0
	},
	natureessenceing = {
		code = 'natureessenceing',
		name = 'Nature Essence',
		icon = load("res://files/images/items/natureessence.png"),
		description = "A clear substance, rich with raw life-energy.",
		effect = '',
		recipe = '',
		cost = 50,
		type = 'ingredient',
		reqs = false,
		weight = 1,
		amount = 0
	},
	bestialessenceing = {
		code = 'bestialessenceing',
		name = 'Bestial Essence',
		icon = load("res://files/images/items/beastessence.png"),
		description = "A pale and milky substance, rich with vigorous energy.",
		effect = '',
		recipe = '',
		cost = 50,
		type = 'ingredient',
		reqs = false,
		weight = 1,
		amount = 0
	},
	fluidsubstanceing = {
		code = 'fluidsubstanceing',
		name = 'Fluid Substance',
		icon = load("res://files/images/items/fluidsubstance.png"),
		description = "An oily transparent liquid with some unique abilities. Sometimes used as cheap lubricant. ",
		effect = '',
		recipe = '',
		cost = 50,
		type = 'ingredient',
		reqs = false,
		weight = 1,
		amount = 0
	},
	gem = {
		code = 'gem',
		name = 'Precious Gem',
		icon = load("res://files/images/items/gemstone.png"),
		description = "An unusually big precious gem. Traders will likely pay a huge sum for it. ",
		effect = '',
		recipe = '',
		cost = 1250,
		type = 'ingredient',
		reqs = false,
		weight = 1,
		amount = 0
	},
	######################################GEAR
	clothcommon = {
		code = 'clothcommon',
		name = 'Common Clothes',
		iconbig = true,
		icon = "res://files/images/items/clothcommon.png",
		description = "Bland common clothes without much of appeal. Thankfully there's no shortage of them.",
		effect = '',
		recipe = '',
		reqs = null,
		cost = 0,
		type = 'gear',
		subtype = 'costume',
		amount = -1,
	},
	clothsundress = {
		code = 'clothsundress',
		name = 'Sundress',
		icon = "res://files/images/items/sundress.png",
		iconbig = true,
		description = "Simple, comfortable, and lighthearted. Perfect for relaxation and exposure to sudden wind gusts.",
		effect = [{type = 'onendday', effect = 'sundresseffect', descript = "Reduces Stress by the end of a day"}],
		recipe = '',
		reqs = null,
		cost = 75,
		type = 'gear',
		subtype = 'costume',
		weight = 2,
		amount = 0,
	},
	clothmaid = {
		code = 'clothmaid',
		name = 'Maid Uniform',
		icon = "res://files/images/items/maiduniform.png",
		iconbig = true,
		description = "A set of black and white frilly clothes with a mandatory skirt and garter belt. Makes cleaning duty pleasant to watch.",
		effect = [{type = 'onendday', effect = 'maiduniformeffect', descript = "Increases Obedience by the end of a day"}],
		recipe = '',
		reqs = null,
		cost = 75,
		type = 'gear',
		subtype = 'costume',
		weight = 3,
		amount = 0,
	},
	clothkimono = {
		code = 'clothkimono',
		name = 'Kimono',
		icon = "res://files/images/items/clothkimono.png",
		description = "Brightly colored foreign clothes which are pretty popular for certain people.",
		effect = [{type = 'onequip', effect = 'beauty', effectvalue = 10, descript = "Slightly increases beauty"},{type = 'onequip', effect = 'luxury', effectvalue = 5, descript = "Slightly increases luxury (+5)"}],
		recipe = '',
		reqs = null,
		cost = 250,
		type = 'gear',
		subtype = 'costume',
		weight = 3,
		amount = 0,
	},
	clothmiko = {
		code = 'clothmiko',
		name = 'Miko Outfit',
		icon = "res://files/images/items/clothmiko.png",
		description = "Contrasting red and white clothes, originally worn by young women of certain foreign religions. They are now fetishized by certain people...",
		effect = [{type = 'onendday', effect = 'mikoeffect', descript = "Reduces stress and lust by the end of a day"}],
		recipe = '',
		reqs = null,
		cost = 200,
		type = 'gear',
		subtype = 'costume',
		weight = 4,
		amount = 0,
	},
	armorninja = {
		code = 'armorninja',
		name = 'Ninja Suit',
		icon = "res://files/images/items/clothninja.png",
		description = "A compact and versatile outfit rumored to be used by foreign assassins.",
		effect = [{type = 'incombat', effect = 'protection', effectvalue = 30, descript = "30% Protection"},{type = 'onequip', id = 'armoragi', effect = 'agi', effectvalue = 1, descript = "+1 Agility"}],
		recipe = '',
		reqs = null,
		cost = 200,
		type = 'gear',
		subtype = 'armor',
		weight = 4,
		amount = 0,
	},
	clothpet = {
		code = 'clothpet',
		name = 'Pet Suit',
		icon = "res://files/images/items/clothpet.png",
		description = "Specially designed pieces of leather decoration which represent a domestic animal, and force the wearer to walk on all fours. For obvious reasons, this should generally not be worn outside.",
		effect = [{type = 'onendday', effect = 'peteffect', descript = "Greatly increases obedience. If Confidence above 40, cause stress penalty and lowers it by the end of a day."}],
		recipe = '',
		reqs = null,
		cost = 250,
		type = 'gear',
		subtype = 'costume',
		weight = 2,
		amount = 0,
	},
	###---Added by Expansion---### ElPresidente
	clothchainbikini = {
		code = 'clothchainbikini',
		name = 'Chainmail Bikini',	
		icon = "res://files/aric_expansion_images/items/chainbikini1.png",
		description = "Sexy armored underwear that emphasizes the physical fitness of the wearer. Contrary to popular belief, it is an impractical choice for protective wear. It has been known to chafe, however.",
		effect = [{type = 'incombat', effect = 'armor', effectvalue = 1, descript = "+1 Armor"},{type = 'onendday', effect = 'chainbikinieffect', descript = "Gains Lust and Lewdness Daily; Gains Stress Daily"}],
		recipe = '',
		reqs = null,
		cost = 250,
		type = 'gear',
		subtype = 'underwear',
		weight = 3,
		amount = 0,
	},
	###---End Expansion---###
	clothbutler = {
		code = 'clothbutler',
		name = 'Butlers Uniform',
		icon = "res://files/images/items/clothbutler.png",
		description = "This is the uniform of a butler, a well fitted suit comprising of a double-breasted coat, waistcoat and trousers, along with a small black tie.",
		effect = [{type = 'onendday', effect = 'butleruniformeffect', descript = "Increases Obedience by the end of a day"}],
		recipe = '',
		reqs = null,
		cost = 75,
		type = 'gear',
		subtype = 'costume',
		weight = 4,
		amount = 0,
	},
	clothbedlah = {
		code = 'clothbedlah',
		name = 'Bedlah',
		icon = "res://files/images/items/clothbedlah.png",
		description = "Loose, translucent clothing from southern regions, generally worn by dancers and members of a harem.",
		effect = [{type = 'onendday', effect = 'bedlaheffect', descript = "Slightly increases Charm by the end of a day."}],
		recipe = '',
		reqs = null,
		cost = 250,
		type = 'gear',
		subtype = 'costume',
		weight = 3,
		amount = 0,
	},
	underwearplain = {
		code = 'underwearplain',
		name = 'Plain Underwear',
		icon = "res://files/images/items/underwear.png",
		iconbig = true,
		description = "Plain white cotton underwear for everyday life.",
		effect = "",
		recipe = '',
		reqs = null,
		cost = 0,
		type = 'gear',
		subtype = 'underwear',
		amount = -1,
	},
	underwearlacy = {
		code = 'underwearlacy',
		name = 'Lacy Underwear',
		icon = "res://files/images/items/underwearlacy.png",
		description = "Fancy and cute underwear available for people with moderate income.\n[color=green]Increases person's luxury[/color]",
		effect = [{type = 'onequip', effect = 'luxury', effectvalue = 5, descript = "Slightly increases luxury (+5)"}],
		recipe = '',
		reqs = null,
		cost = 100,
		type = 'gear',
		subtype = 'underwear',
		weight = 2,
		amount = 0,
	},
	underwearboxers = {
		code = 'underwearboxers',
		name = 'Silk Boxers',
		icon = "res://files/images/items/underwearboxers.png",
		description = "Fancy and comfortable male underwear available for people with moderate income.\n[color=green]Increases person's luxury[/color]",
		effect = [{type = 'onequip', effect = 'luxury', effectvalue = 5, descript = "Slightly increases luxury (+5)"}],
		recipe = '',
		reqs = null,
		cost = 100,
		type = 'gear',
		subtype = 'underwear',
		weight = 2,
		amount = 0,
	},
	armorleather = {
		code = 'armorleather',
		name = 'Leather Armor',
		icon = "res://files/images/items/armorleather.png",
		description = "Suit of tanned leather, providing some protection while not restricting movement too much.",
		effect = [{type = 'incombat', effect = 'protection', effectvalue = 20, descript = "20% Protection"},{type = 'incombat', effect = 'armor', effectvalue = 2, descript = "+2 Armor"}],
		recipe = '',
		reqs = null,
		cost = 100,
		type = 'gear',
		subtype = 'armor',
		weight = 3,
		amount = 0,
	},
	###---Added by Expansion---### ElPresidente Items
	armorpadded = {
		code = 'armorpadded',
		name = 'Padded Armor',
		icon = "res://files/aric_expansion_images/items/armorpadded2.png",
		description = "A step up from leather armor made from multiple layers of linen. It is effective, comfortable, and cheap, making it incredibly common.",
		effect = [{type = 'incombat', effect = 'protection', effectvalue = 25, descript = "25% Protection"},{type = 'incombat', effect = 'armor', effectvalue = 4, descript = "+4 Armor"}],
		recipe = '',
		reqs = null,
		cost = 150,
		type = 'gear',
		subtype = 'armor',
		weight = 4,
		amount = 0,
	},
	###---End Expansion---###
	armorchain = {
		code = 'armorchain',
		name = 'Chain Armor',
		icon = "res://files/images/items/armorchain.png",
		description = "A finely crafted suit of armor created from interwoven iron rings. Offers reasonable protection against sharp objects. ",
		effect = [{type = 'incombat', effect = 'protection', effectvalue = 40, descript = "40% Protection"},{type = 'incombat', effect = 'armor', effectvalue = 6, descript = "+6 Armor"}],
		recipe = '',
		reqs = null,
		cost = 250,
		type = 'gear',
		subtype = 'armor',
		weight = 8,
		amount = 0,
	},
	armorelvenchain = {
		code = 'armorelvenchain',
		name = 'Elven Chain Armor',
		icon = "res://files/images/items/armorelvenchain.png",
		description = "A suit of elvish armor created from interwoven mithril rings. It is supple and light yet provides ample protection.",
		effect = [{type = 'incombat', effect = 'protection', effectvalue = 35, descript = "35% Protection"},{type = 'incombat', effect = 'armor', effectvalue = 5, descript = "+5 Armor"}, {type = 'incombat', effect = 'speed', effectvalue = 3, descript = "+3 speed"}],
		recipe = '',
		reqs = null,
		cost = 500,
		type = 'gear',
		subtype = 'armor',
		weight = 5,
		amount = 0,
	},
	###---Added by Expansion---### ElPresidente Items
	armorplate = {
		code = 'armorplate',
		name = 'Plate Armor',
		icon = "res://files/images/items/armorplate.png",
		description = "An old, durable suit of plate armor. Protects the wearer against most physical damage. \n[color=yellow]Requirements: 1 Strength, 3 Endurance[/color]",
		effect = [{type = 'incombat', effect = 'protection', effectvalue = 60, descript = "60% Protection"},{type = 'incombat', effect = 'armor', effectvalue = 10, descript = "+10 Armor"}],
		recipe = '',
		reqs = [{reqstat = 'send', oper = 'gte', reqvalue = 3},{reqstat = 'sstr', oper = 'gte', reqvalue = 1}],
		cost = 750,
		type = 'gear',
		subtype = 'armor',
		weight = 10,
		amount = 0,
	},
	armorhalfplate = {
		code = 'armorhalfplate',
		name = "Half-Plate",
		icon = "res://files/aric_expansion_images/items/halfplate.png",
		description = "A combination of chaimail with plate covering only the most vital areas. Slightly cheaper and lighter than full plate, requiring less experience to use it. \n[color=yellow]Requirements: 1 Strength, 2 Endurance[/color]",
		effect = [{type = 'incombat', effect = 'protection', effectvalue = 50, descript = "50% Protection"},{type = 'incombat', effect = 'armor', effectvalue = 8, descript = "+8 Armor"}],
		recipe = '',
		reqs = [{reqstat = 'send', oper = 'gte', reqvalue = 2},{reqstat = 'sstr', oper = 'gte', reqvalue = 1}],
		cost = 600,
		type = 'gear',
		subtype = 'armor',
		weight = 8,
		amount = 0,
	},
	armorelvenhalfplate = {
		code = 'armorelvenhalfplate',
		name = "Elven Half-Plate",
		icon = "res://files/aric_expansion_images/items/elven_halfplate.png",
		description = "This highly efficient armor sacrifices no durabiltiy to achive lighter weight than it's human counterpart. \n[color=yellow]Requirements: 1 Agility, 1 Endurance[/color]",
		effect = [{type = 'incombat', effect = 'protection', effectvalue = 45, descript = "45% Protection"},{type = 'incombat', effect = 'armor', effectvalue = 8, descript = "+8 Armor"}],
		recipe = '',
		reqs = [{reqstat = 'sagi', oper = 'gte', reqvalue = 1},{reqstat = 'send', oper = 'gte', reqvalue = 1}],
		cost = 700,
		type = 'gear',
		subtype = 'armor',
		weight = 7,
		amount = 0,
	},
	armorfieldplate = {
		code = 'armorfieldplate',
		name = "Field Plate Armor",
		icon = "res://files/aric_expansion_images/items/fieldplate.png",
		description = "A magnificent suit of ornate field plate armor. Provides some of the best protection money can buy.\n[color=yellow]Requirements: 2 Strength, 2 Endurance[/color]",
		effect = [{type = 'incombat', effect = 'protection', effectvalue = 70, descript = "70% Protection"},{type = 'incombat', effect = 'armor', effectvalue = 10, descript = "+10 Armor"}],
		recipe = '',
		reqs = [{reqstat = 'sstr', oper = 'gte', reqvalue = 2},{reqstat = 'send', oper = 'gte', reqvalue = 2}],
		cost = 1500,
		type = 'gear',
		subtype = 'armor',
		weight = 9,
		amount = 0,
	},
	armormagerobe = {
		code = 'armormagerobe',
		name = "Archmages Robe",
		icon = "res://files/aric_expansion_images/items/archhmagerobe.png",
		description = "These runed robes do not restrict movement and amplify their wearer's inate Magic. However, they were not designed for combat and provide little protection.",
		effect = [{type = 'incombat', effect = 'protection', effectvalue = 20, descript = "20% Protection"},{type = 'incombat', effect = 'armor', effectvalue = 2, descript = "+2 Armor"},{type = 'onequip', id = 'armormaf', effect = 'maf', effectvalue = 2, descript = "+2 Magic Affinity"}],
		recipe = '',
		reqs = null,
		cost = 350,
		type = 'gear',
		subtype = 'armor',
		weight = 4,
		amount = 0,
	},
	###---End Expansion---###
	armorrobe = {
		code = 'armorrobe',
		name = "Wizard's Robe",
		icon = "res://files/images/items/armorrobe.png",
		description = "Despite what might appear as a clunky piece of clothing, combat robes allow the wearer to hold and hide various items and potions for quick and unexpected use and don't restrict movement. Outer fabric is easily torn to prevent grabbing and tuckling and can be quickly repaired with magic later. ",
		effect = [{type = 'incombat', effect = 'protection', effectvalue = 35, descript = "35% Protection"},{type = 'incombat', effect = 'armor', effectvalue = 4, descript = "+4 Armor"},{type = 'onequip', id = 'armormaf', effect = 'maf', effectvalue = 1, descript = "+1 Magic Affinity"}],
		recipe = '',
		reqs = null,
		cost = 350,
		type = 'gear',
		subtype = 'armor',
		weight = 5,
		amount = 0,
	},
	weapondaggerrust = {
		code = 'weapondaggerrust',
		name = 'Rusty Dagger',
		icon = "res://files/images/items/weapondaggerrust.png",
		description = "An alleged weapon. You really should find something else... ",
		effect = [{type = 'incombat', effect = 'damage', effectvalue = 2, effectscale = 'agi', descript = "+2 Damage, Agi Scaling"}],
		recipe = '',
		reqs = null,
		cost = 10,
		type = 'gear',
		subtype = 'weapon',
		weight = 2,
		amount = 0,
	},
	weapondagger = {
		code = 'weapondagger',
		name = 'Dagger',
		icon = "res://files/images/items/weapondagger.png",
		description = "A simple weapon providing bare minimum of physical power. ",
		effect = [{type = 'incombat', effect = 'damage', effectvalue = 4, effectscale = 'agi', descript = "+4 Damage, Agi Scaling"}],
		recipe = '',
		reqs = null,
		cost = 50,
		type = 'gear',
		subtype = 'weapon',
		weight = 2,
		amount = 0,
	},
	###---Added by Expansion---### Capitulize's Items
	weaponserrateddagger = {
		code = 'weaponserrateddagger',
		name = 'Serrated Dagger',
		icon = "res://files/aric_expansion_images/items/weaponserrateddagger.png",
		description = "A deadly blade with deadly grooves, this blade leaves painful wounds. \n[color=yellow]Requirements: 2 Agility[/color]",
		effect = [{type = 'incombat', effect = 'damage', effectvalue = 7, effectscale = 'agi', descript = "+7 Damage, Agi Scaling"}],
		recipe = '',
		reqs = [{reqstat = 'sagi', oper = 'gte', reqvalue = 2}],
		cost = 150,
		type = 'gear',
		subtype = 'weapon',
		weight = 5,
		amount = 0,
	},
	weaponbasicstaff = {
		code = 'weaponbasicstaff',
		name = 'Basic Staff',
		icon = "res://files/aric_expansion_images/items/weaponbasicstaff.png",
		description = "A basic staff for the aspiring mage.",
		effect = [{type = 'incombat', effect = 'damage', effectvalue = 3, effectscale = 'maf', descript = "+3 Damage, Maf Scaling"}],
		recipe = '',
		reqs =  null,
		cost = 50,
		type = 'gear',
		subtype = 'weapon',
		weight = 5,
		amount = 0,
	},
	###---End Expansion---###
	weaponsword = {
		code = 'weaponsword',
		name = 'Long Sword',
		icon = "res://files/images/items/weaponsword.png",
		description = "Medium sized sword perfectly balanced for close combat. \n[color=yellow]Requirements: 2 Strength[/color]",
		effect = [{type = 'incombat', effect = 'damage', effectvalue = 7, effectscale = 'str', descript = "+7 Damage, Str Scaling"}],
		recipe = '',
		reqs = [{reqstat = 'sstr', oper = 'gte', reqvalue = 2}],
		cost = 150,
		type = 'gear',
		subtype = 'weapon',
		weight = 4,
		amount = 0,
	},
	###---Added by Expansion---### ElPresidente Items
	weaponclaymore = {
		code = 'weaponclaymore',
		name = 'Claymore',
		icon = "res://files/images/items/weaponclaymore.png",
		description = "Large greatsword designed with a more aerodynamic design to minimize weight while still capable of delivering a heavy blow.\n[color=yellow]Requirements: 3 Strength[/color] ",
		effect = [{type = 'incombat', effect = 'damage', effectvalue = 9, effectscale = 'str', descript = "+9 Damage, Str Scaling"},{type = 'incombat', id = 'weaponspeed', effect = 'speed', effectvalue = -1, descript = "-1 Speed"}],
		recipe = '',
		reqs = [{reqstat = 'sstr', oper = 'gte', reqvalue = 3}],
		cost = 400,
		type = 'gear',
		subtype = 'weapon',
		weight = 5,
		amount = 0,
	},
	weapongreatsword = {
		code = 'weapongreatsword',
		name = 'Greatsword',
		icon = "res://files/aric_expansion_images/items/zweihander.png",
		description = "Massive two-handed sword with a long reach. Slows the wielder due to its size and weight, but capable of delivering devastating blows.\n[color=yellow]Requirements: 4 Strength[/color] ",
		effect = [{type = 'incombat', effect = 'damage', effectvalue = 12, effectscale = 'str', descript = "+12 Damage, Str Scaling"},{type = 'incombat', id = 'weaponspeed', effect = 'speed', effectvalue = -3, descript = "-3 Speed"}],
		recipe = '',
		reqs = [{reqstat = 'sstr', oper = 'gte', reqvalue = 4}],
		cost = 500,
		type = 'gear',
		subtype = 'weapon',
		weight = 7,
		amount = 0,
	},
	###---End Expansion---###
	weaponaynerisrapier = {
		code = 'weaponaynerisrapier',
		name = "Ayneris's Rapier",
		icon = "res://files/images/items/weaponaynerisrapier.png",
		description = "\n[color=yellow]Requirements: 4 Agility[/color] ",
		effect = [{type = 'incombat', effect = 'damage', effectvalue = 8, effectscale = 'agi', descript = "+8 Damage, Agi Scaling"}, {type = 'passive', effect = 'doubleattack', effectvalue = 50, descript = '50% chance to attack twice'}],
		recipe = '',
		enchant = 'unique',
		reqs = [{reqstat = 'sagi', oper = 'gte', reqvalue = 4}],
		cost = 500,
		type = 'gear',
		subtype = 'weapon',
		weight = 4,
		amount = 0,
	},
	###---Added by Expansion---### ElPresidente Items
	weaponrunesword = {
		code = 'weaponrunesword',
		name = 'Runesword',
		icon = "res://files/aric_expansion_images/items/ornate_sword_1.png",
		description = "A sword made for an ancient order of spellblades that is engraved with runes that help focus magical power. These weapons are now hard to find and unusable by anyone without some magical affinity.\n[color=yellow]Requirements: 2 Agility, 1 Magic[/color]",
		effect = [{type = 'incombat', effect = 'damage', effectvalue = 7, effectscale = 'agi', descript = "+7 Damage, Agi Scaling"}, {type = 'onequip', effect = 'maf', effectvalue = 1, descript = "+1 Magic Affinity"}],
		recipe = '',
		reqs = [{reqstat = 'sagi', oper = 'gte', reqvalue = 2},{reqstat = 'smaf', oper = 'gte', reqvalue = 1}],
		cost = 550,
		type = 'gear',
		subtype = 'weapon',
		weight = 4,
		amount = 0,
	},
	weaponceremonialsword = {
		code = 'weaponceremonialsword',
		name = "Ceremonial Sword",
		icon = "res://files/aric_expansion_images/items/ornate_sword_2.png",
		description = "More work of art than weapon, this blade has a beautifully decorated golden hilt. Unlike most ceremonial weaponry, this is blade seems to be completely functional in combat as well.\n[color=yellow]Requirements: 2 Agility[/color]",
		effect = [{type = 'incombat', effect = 'damage', effectvalue = 7, effectscale = 'str', descript = "+7 Damage, Str Scaling"}, {type = 'onequip', effect = 'luxury', effectvalue = 10, descript = "Increases luxury (+10)"}],
		recipe = '',
		reqs = [{reqstat = 'sagi', oper = 'gte', reqvalue = 2}],
		cost = 750,
		type = 'gear',
		subtype = 'weapon',
		weight = 4,
		amount = 0,
	},
	weaponancientsword = {
		code = 'weaponancientsword',
		name = "Ancient Sword",
		icon = "res://files/aric_expansion_images/items/ornate_sword_3.png",
		description = "This blade has clearly seen hundreds of battles, yet remains sharp and functional. Holding it reminds the wielder of its previous victories as well as its prior defeats.\n[color=yellow]Requirements: 1 Strength, 2 Agility[/color]",
		effect = [{type = 'incombat', effect = 'damage', effectvalue = 8, effectscale = 'str', descript = "+8 Damage, Str Scaling"},{type = 'onendday', effect = 'ancientswordeffect', descript = "Increase Confidence or Fear by the end of a day based on Courage."}],
		recipe = '',
		reqs = [{reqstat = 'sstr', oper = 'gte', reqvalue = 1},{reqstat = 'sagi', oper = 'gte', reqvalue = 2}],
		cost = 500,
		type = 'gear',
		subtype = 'weapon',
		weight = 5,
		amount = 0,
	},
	accbooklife = {
		code = 'accbooklife',
		name = 'Book of Life',
		icon = "res://files/aric_expansion_images/items/book_life.png",
		description = "This ancient book contains wisdom, tips, and helpful reminders for Mages.",
		effect = [{type = 'onequip', effect = 'wit', effectvalue = 15, descript = "Increases wit (+15)"},{type = 'onequip', effect = 'maf', effectvalue = 1, descript = "+1 Magic Affinity"}],
		recipe = '',
		reqs = null,
		cost = 800,
		type = 'gear',
		subtype = 'accessory',
		weight = 2,
		amount = 0,
	},
	accelvenboots = {
		code = 'accelvenboots',
		name = 'Elven Boots',
		icon = "res://files/aric_expansion_images/items/elvenboots.png",
		description = "Exquisite Elven-made boots that are not only comfortable, but also seem to hasten your step and make your steps less tiring.",
		effect = [{type = 'onequip', effect = 'energy', effectvalue = 20, descript = "+20 Energy"},{type = 'incombat', effect = 'speed', effectvalue = 2, descript = "+2 Speed"}],
		recipe = '',
		reqs = null,
		cost = 750,
		type = 'gear',
		subtype = 'accessory',
		weight = 2,
		amount = 0,
	},
	###---End Expansion---###
	accgoldring = {
		code = 'accgoldring',
		name = 'Golden Ring',
		icon = "res://files/images/items/goldring.png",
		description = "This finely crafted gold ring comprises of two intertwined bands.\n[color=green]Increases person's luxury[/color]",
		effect = [{type = 'onequip', effect = 'luxury', effectvalue = 10, descript = "Increases luxury (+10)"}],
		recipe = '',
		reqs = null,
		cost = 250,
		type = 'gear',
		subtype = 'accessory',
		weight = 1,
		amount = 0,
	},
	accslavecollar = {
		code = 'accslavecollar',
		name = 'A Leather Slave Collar',
		icon = "res://files/images/items/collar.png",
		description = "This leather collar is designed to fit tightly around the neck. It has rings to which bindings can be attached.\n",
		effect = [{type = 'onendday', effect = 'slavecollareffect', descript = "Increases Obedience by the end of a day. "}],
		recipe = '',
		reqs = null,
		cost = 150,
		type = 'gear',
		subtype = 'accessory',
		weight = 2,
		amount = 0,
	},
	acchandcuffs = {
		code = 'acchandcuffs',
		name = 'A Pair Of Handcuffs',
		icon = "res://files/images/items/handcuffs.png",
		description = "These handcuffs are lightly padded but robust enough to secure even the most troublesome person.\n",
		effect = [{type = 'onendday', effect = 'handcuffeffect', descript = "Increases Obedience by the end of a day and prevents escapes. "}],
		recipe = '',
		reqs = null,
		cost = 250,
		type = 'gear',
		subtype = 'accessory',
		weight = 2,
		amount = 0,
	},
	acctravelbag = {
		code = 'acctravelbag',
		name = 'Travelling Bag',
		icon = "res://files/images/items/bag.png",
		description = "A great partner of any experienced adventurer. Despite minor wear, it looks really sturdy. \nIncreases party's total carry weight by 20. ",
		effect = [],
		recipe = '',
		reqs = null,
		cost = 200,
		type = 'gear',
		subtype = 'accessory',
		weight = 5,
		amount = 0,
	},
	#newitems
	weaponelvensword = {
		code = 'weaponelvensword',
		name = 'Elven Sword',
		icon = "res://files/images/items/elvensword.png",
		description = "Medium sized sword perfectly balanced for close combat. \n[color=yellow]Requirements: 4 Agility[/color]",
		effect = [{type = 'incombat', effect = 'damage', effectvalue = 9, effectscale = "agi", descript = "+9 Damage, Agi Scaling"},{type = 'onequip', effect = 'agi', effectvalue = 1, descript = "+1 Agility"}],
		recipe = '',
		reqs = [{reqstat = 'sagi', oper = 'gte', reqvalue = 4}],
		cost = 250,
		type = 'gear',
		subtype = 'weapon',
		weight = 4,
		amount = 0,
	},
	accamuletruby = {
		code = 'accamuletruby',
		name = 'Ruby Amulet',
		icon = "res://files/images/items/amuletruby.png",
		description = "A luxury piece of jewelry with a trace of magic. ",
		effect = [{type = 'incombat', effect = 'damage', effectvalue = 2, descript = "+2 Damage"},{type = 'onequip', effect = 'luxury', effectvalue = 5, descript = "Increases luxury (+5)"}],
		recipe = '',
		reqs = null,
		cost = 400,
		type = 'gear',
		subtype = 'accessory',
		weight = 1,
		amount = 0,
	},
	accamuletemerald = {
		code = 'accamuletemerald',
		name = 'Emerald Amulet',
		icon = "res://files/images/items/amuletemerald.png",
		description = "A luxury piece of jewelry with a trace of magic. ",
		effect = [{type = 'onequip', effect = 'health', effectvalue = 15, descript = "+15 Health"},{type = 'onequip', effect = 'luxury', effectvalue = 5, descript = "Increases luxury (+5)"}],
		recipe = '',
		reqs = null,
		cost = 400,
		type = 'gear',
		subtype = 'accessory',
		weight = 1,
		amount = 0,
	},
	weaponnaturestaff = {
        code = 'weaponnaturestaff',
        name = 'Staff of Nature',
        icon = "res://files/images/items/naturestaff.png",
        description = "A twisted branch infused with Nature's power. Strengthens wielder but is not a very effective weapon.\n[color=yellow]Requirements: 1 Magic Affinity[/color]",
        effect = [{type = 'incombat', effect = 'damage', effectvalue = 4, effectscale = "maf", descript = "+4 Damage, Magic Aff Scaling"},{type = 'onequip', effect = 'health', effectvalue = 25, descript = "+25 Health"},{type = 'onequip', effect = 'maf', effectvalue = 1, descript = "+1 Magic Affinity"}],
        recipe = '',
        reqs =  [{reqstat = 'smaf', oper = 'gte', reqvalue = 1}],
        cost = 200,
        type = 'gear',
        subtype = 'weapon',
        weight = 5,
        amount = 0,
    },
	armortentacle = {
		code = 'armortentacle',
		name = 'Living Armor',
		icon = "res://files/images/items/armortentacle.png",
		description = "An unearthly semi-living object which can be worn. Feeds on the fluids of wearer which periodically stimulates in private places. ",
		effect = [{type = 'incombat', effect = 'protection', effectvalue = 50, descript = "50% Protection"},{type = 'incombat', effect = 'armor', effectvalue = 8, descript = "+8 Armor"},{type = 'onequip', effect = 'health', effectvalue = 50, descript = "+50 Health"},{type = 'incombatturn', effect = 'lust', effectvalue = 2, descript = "lust grows during the combat"}],
		recipe = '',
		reqs = null,
		cost = 500,
		type = 'gear',
		subtype = 'armor',
		weight = 9,
		amount = 0,
		enchant = 'unique',
	},
	clothtentacle = {
		code = 'clothtentacle',
		name = 'Living Suit',
		icon = "res://files/images/items/clothtentacle.png",
		description = "Parasitic suit which feeds on bodily fluids and stimulates person's privates. ",
		effect = [{type = 'onendday', effect = 'livingsuiteffect', descript = "lust grows at the end of the day"}],
		recipe = '',
		reqs = null,
		cost = 200,
		type = 'gear',
		subtype = 'underwear',
		weight = 3,
		amount = 0,
		enchant = '',
	},
	armorrogue = {
		code = 'armorrogue',
		name = "Rogue's Armor",
		icon = "res://files/images/items/roguearmor.png",
		description = "An unearthly semi-living object which can be worn. Feeds on the fluids of wearer which periodically stimulates in private places. ",
		effect = [{type = 'incombat', effect = 'protection', effectvalue = 45, descript = "45% Protection"},{type = 'incombat', effect = 'armor', effectvalue = 7, descript = "+7 Armor"},{type = 'onequip', effect = 'energy', effectvalue = 20, descript = "+20 Energy"}],
		recipe = '',
		reqs = null,
		cost = 500,
		type = 'gear',
		subtype = 'armor',
		weight = 5,
		amount = 0,
		enchant = 'unique',
	},
	weaponcursedsword = {
        code = 'weaponcursedsword',
        name = "Cursed Blade",
        icon = "res://files/images/items/weaponcursedsword.png",
        description = "An ancient mystical blade. Strong magic keeps it sharp even to this day, but all power comes with a price... ",
        effect = [{type = 'incombat', effect = 'damage', effectvalue = 15, effectscale = "maf", descript = "+15 Damage, Magic Aff Scaling"}, {type = 'passive', effect = 'doubleattack', effectvalue = 20, descript = '20% chance to attack twice'}, {type = 'passive', effect = 'defenseless', descript = "Wielder's armor is useless"}],
        recipe = '',
        reqs = null,
        cost = 800,
        type = 'gear',
        subtype = 'weapon',
        weight = 5,
        amount = 0,
        enchant = 'unique',
    },
	weaponhammer = {
		code = 'weaponhammer',
		name = "Great Hammer",
		icon = "res://files/images/items/weaponhammer.png",
		description = "A mighty weapon designed to deal with armored targets, but it is sluggish and heavy. \n[color=yellow]Requirements: 3 Strength[/color] ",
		effect = [{type = 'incombat', effect = 'damage', effectvalue = 14, effectscale = "str", descript = "+14 Damage, Str Scaling"},{type = 'incombatphyattack', effect = 'protpenetration', effectvalue = 1, descript = 'Ignores protection'},{type = 'incombat', id = 'weaponspeed', effect = 'speed', effectvalue = -5, descript = "-5 speed"}],
		recipe = '',
		reqs = [{reqstat = 'sstr', oper = 'gte', reqvalue = 3}],
		cost = 350,
		type = 'gear',
		subtype = 'weapon',
		weight = 6,
		amount = 0,
	},
	weaponkatana = {
		code = 'weaponkatana',
		name = "Eastern Sword",
		icon = "res://files/images/items/9.png",
		description = "A long sword originates from eastern lands. Its sharp edge allows a user to compensate for their strength with speed and precision.\n[color=yellow]Requirements: 3 Agility[/color] ",
		effect = [{type = 'incombat', effect = 'damage', effectvalue = 8, effectscale = "str", descript = "+8 Damage, Str Scaling"},{type = 'onequip', effect = 'str', effectvalue = 2, descript = '+2 Strength'},{type = 'onequip', effect = 'end', effectvalue = 1, descript = '+1 Endurance'}],
		recipe = '',
		reqs = [{reqstat = 'sagi', oper = 'gte', reqvalue = 3}],
		cost = 500,
		type = 'gear',
		subtype = 'weapon',
		weight = 5,
		amount = 0,
	},
	weaponshortsword = {
		code = 'weaponshortsword',
		name = "Armor Breaker",
		icon = "res://files/images/items/6.png",
		description = "A mighty weapon designed to deal with armored targets. ",
		effect = [{type = 'incombat', effect = 'damage', effectvalue = 9, effectscale = "agi", descript = "+9 Damage, Agi Scaling"}, {type = 'passive', effect = 'armorbreaker', descript = "Bypass 8 Armor"}],
		recipe = '',
		reqs = [],
		cost = 500,
		type = 'gear',
		subtype = 'weapon',
		weight = 4,
		amount = 0,
	},
	armorredcloak = {
		code = 'armorredcloak',
		name = "Red Cloak",
		icon = "res://files/images/items/2.png",
		description = "An armor once worn by a legendary mercenary. It still smells of blood.",
		effect = [{type = 'incombat', effect = 'protection', effectvalue = 50, descript = "50% Protection"},{type = 'incombat', effect = 'armor', effectvalue = 6, descript = "+6 Armor"},{type = 'incombat', effect = 'speed', effectvalue = 5, descript = "+5 speed"}],
		recipe = '',
		reqs = [],
		cost = 750,
		enchant = 'unique',
		type = 'gear',
		subtype = 'armor',
		weight = 8,
		amount = 0,
	},
	armorcarapace= {
		code = 'armorcarapace',
		name = "Carapace",
		icon = "res://files/images/items/3.png",
		description = "Thick plate made for finest defense. \n[color=yellow]Requirements: 4 Endurance[/color]  ",
		effect = [{type = 'incombat', effect = 'protection', effectvalue = 65, descript = "65% Protection"},{type = 'incombat', effect = 'armor', effectvalue = 5, descript = "+5 Armor"}],
		recipe = '',
		reqs = [{reqstat = 'send', oper = 'gte', reqvalue = 4}],
		cost = 600,
		type = 'gear',
		subtype = 'armor',
		weight = 7,
		amount = 0,
	},
	accessoryneck = {
		code = 'accessoryneck',
		name = "Golden Necklace",
		icon = "res://files/images/items/42.png",
		description = "A heavy necklace providing some protection.",
		effect = [{type = 'incombat', effect = 'armor', effectvalue = 4, descript = "+4 Armor"}],
		recipe = '',
		reqs = [],
		cost = 500,
		type = 'gear',
		subtype = 'accessory',
		weight = 2,
		amount = 0,
	},
	zoebook = {
		code = 'zoebook',
		name = 'Mysterious Book',
		icon = load("res://files/images/items/mysteriousbook.png"),
		description = "An ancient book written in unknown language...",
		effect = "zoebook",
		recipe = '',
		cost = 0,
		type = 'quest',
		amount = 0,
		weight = 0,
	},
	aydabrandy = {
		code = 'aydabrandy',
		name = 'Ice Brandy',
		icon = load("res://files/images/items/icebrandy.png"),
		description = "A quite expensive alcohol beverage brewed with a secret recipe. Feels cold to the taste even if it is not. ",
		effect = "aydabrandy",
		recipe = '',
		cost = 100,
		type = 'quest',
		amount = 0,
		weight = 0,
		obtainreqs = 'globals.state.sidequests.ayda == 8',
	},
	aydabook = {
		code = 'aydabook',
		name = 'Fairies and Their Many Uses',
		icon = load("res://files/images/items/questbook.png"),
		description = "A fancy looking book with bright cover. It seems to also have a number of indecent illustrations. ",
		effect = "aydabook",
		recipe = '',
		cost = 250,
		type = 'quest',
		amount = 0,
		weight = 0,
		obtainreqs = 'globals.state.sidequests.ayda == 11',
	},
	aydajewel = {
		code = 'aydajewel',
		name = "Ayda's Necklace",
		icon = load("res://files/images/items/access.png"),
		description = "This jewelry must be really important to someone.",
		effect = "aydajewel",
		recipe = '',
		cost = 0,
		type = 'quest',
		amount = 0,
		weight = 0,
		obtainreqs = 'globals.state.sidequests.ayda == 14',
	},
	###---Added by Expansion---### Farm Expanded
	hyperlactationpot = {
		code = 'hyperlactationpot',
		name = 'Hyperlactation Potion',
		icon = load("res://files/aric_expansion_images/potions/rendrassa_hyperlactation_bottle.png"),
		description = "Stimulates the milk glands of a lactating person to cause overwhelming lactation OR forces someone who isn't lactating to start lactating. Can permanently impair normal behavior and requires consistant milking.",
		effect = 'hyperlactationpoteffect',
		recipe = 'recipehyperlactationpot',
		cost = 250,
		type = 'potion',
		toxicity = 10,
		reqs = 'globals.state.mansionupgrades.mansionalchemy >= 1 && globals.state.farm >= 3',
		weight = 1,
		amount = 0
	},
	bottledmilk = {
		code = 'bottledmilk',
		name = 'Bottled Milk',
		icon = load("res://files/aric_expansion_images/potions/rendrassa_milk_bottle.png"),
		description = "Milk that has been refined and bottled. During the refining process, it has gained the properties to restore some [color=aqua]Energy[/color] as well the possibility to restore some significant [color=aqua]Stress[/color]. ",
		effect = 'milkeffect',
		recipe = '',
		cost = 40,
		type = 'potion',
		toxicity = 0,
		reqs = false,
		weight = 1,
		amount = 0
	},
	bottledsemen = {
		code = 'bottledsemen',
		name = 'Bottled Semen',
		icon = load("res://files/aric_expansion_images/potions/rendrassa_cum_bottle.png"),
		description = "Semen that has been refined and bottled. During the refining process, it has gained the properties to restore minor [color=aqua]Energy[/color] as well as make the drinker feel [color=aqua]Lewd[/color] by drinking it. ",
		effect = 'semeneffect',
		recipe = '',
		cost = 25,
		type = 'potion',
		toxicity = 0,
		reqs = false,
		weight = 1,
		amount = 0
	},
	bottledlube = {
		code = 'bottledlube',
		name = 'Bottled Lube',
		icon = load("res://files/aric_expansion_images/potions/rendrassa_lube_bottle.png"),
		description = "Vaginal Fluid that has been refined and bottled. During the refining process, it has gained the properties to restore minor [color=aqua]Energy[/color] as well as make the drinker feel [color=aqua]Lewd[/color] by drinking it. ",
		effect = 'lubeeffect',
		recipe = '',
		cost = 25,
		type = 'potion',
		toxicity = 0,
		reqs = false,
		weight = 1,
		amount = 0
	},
	bottledpiss = {
		code = 'bottledpiss',
		name = 'Bottled Piss',
		icon = load("res://files/aric_expansion_images/potions/rendrassa_piss_bottle.png"),
		description = "Urine that has been refined and bottled. During the refining process, it has gained the properties to restore [color=aqua]Energy[/color] as well as make the drinker feel incredibly [color=aqua]Lewd[/color] by drinking it. ",
		effect = 'pisseffect',
		recipe = '',
		cost = 10,
		type = 'potion',
		toxicity = 0,
		reqs = false,
		weight = 1,
		amount = 0
	},
	sedative = {
		code = 'sedative',
		name = 'Sedative',
		icon = load("res://files/aric_expansion_images/potions/rendrassa_sedative_potion_bottle.png"),
		description = "Reduces the Energy of the consumer by anywhere from 25% to 50% of a normal person's daily [color=aqua]Energy[/color] level. It also has a chance to reduce the [color=aqua]Wits[/color] of consumers. ",
		effect = 'sedativeeffect',
		recipe = 'recipesedative',
		cost = 75,
		type = 'potion',
		toxicity = 15,
		reqs = 'globals.state.mansionupgrades.mansionalchemy >= 1',
		weight = 1,
		amount = 0
	},
	sexchangepot = {
		code = 'sexchangepot',
		name = 'Sexual Conversion Tonic',
		icon = load("res://files/aric_expansion_images/potions/sex_change_potion.png"),
		description = "A powerful concoction that radically alters the drinker's sexual characteristics by flooding their body with magically charged hormones.",
		effect = 'sexchangepoteffect',
		recipe = 'recipesexchangepot',
		cost = 250,
		type = 'potion',
		toxicity = 50,
		reqs = 'globals.state.mansionupgrades.mansionalchemy >= 2',
		weight = 1,
		amount = 0
	},
###---End Expansion---###
}

var recipeaphrodisiac = {
	basicsolutioning = 1,
	taintedessenceing = 1,
	bestialessenceing = 1,
}

var recipehairgrowth = {
	basicsolutioning = 1,
	natureessenceing = 1,
	bestialessenceing = 1
}

var recipematuringpot = {
	majoruspot = 1,
	magicessenceing = 2,
	natureessenceing = 1
}

var recipeyouthingpot = {
	minoruspot = 1,
	magicessenceing = 2,
	basicsolutioning = 2
}

var recipeminoruspot = {
	basicsolutioning = 1,
	taintedessenceing = 2,
	fluidsubstanceing = 1
}

var recipemajoruspot = {
	basicsolutioning = 1,
	bestialessenceing = 2,
	natureessenceing = 1
}

var recipeamnesiapot = {
	basicsolutioning = 1,
	fluidsubstanceing = 1,
	taintedessenceing = 1
}

var recipeoblivionpot = {
	amnesiapot = 1,
	magicessenceing = 1,
	fluidsubstanceing = 2
}

var recipelactationpot = {
	basicsolutioning = 1,
	bestialessenceing = 2,
	natureessenceing = 1
}

var recipestimulantpot = {
	basicsolutioning = 1,
	fluidsubstanceing = 1,
	natureessenceing = 1
}

var recipedeterrentpot = {
	basicsolutioning = 1,
	fluidsubstanceing = 1,
	taintedessenceing = 1
}

var recipemiscariagepot = {
	basicsolutioning = 1,
	taintedessenceing = 2
}

var reciperegressionpot = {
	basicsolutioning = 2,
	amnesiapot = 1,
	youthingpot = 1
}

var recipeaphroditebrew = {
	aphrodisiac = 2,
	stimulantpot = 1,
	taintedessenceing = 2
}
var recipeclaritypot = {
	oblivionpot = 1,
	regressionpot = 1,
}

###---Added by Expansion---###
var recipehyperlactationpot = {
	lactationpot = 1,
	bottledmilk = 3,
}

var recipesedative = {
	basicsolutioning = 1,
	taintedessenceing = 1,
	bottledmilk = 1,
}

var recipesexchangepot = {
	taintedessenceing = 1,
	bottledsemen = 2,
	bottledlube= 2,
}
###---End Expansion

func armor(value):
	person.stats.armor_cur += value

func agi(value):
	person.stats.agi_mod += value

func stren(value):
	person.stats.str_mod += value

func maf(value):
	person.stats.maf_mod += value

func end(value):
	person.stats.end_mod += value

func cour(value):
	person.stats.cour_base += value
	return ''

func conf(value):
	person.stats.conf_base += value
	return ''

func wit(value):
	person.stats.wit_base += value
	return ''

func charm(value):
	person.stats.charm_base += value
	return ''

func health(value):
	person.stats.health_bonus += value
	person.health += 0

func energy(value):
	person.stats.energy_max += value

func energy_cur(value):
	person.energy += value
	return ''

func toxicity(value):
	person.toxicity -= value
	return ''

func beauty(value):
	person.beautytemp += value

func lust(value):
	person.lust += value
	return ''

func luxury(value):
	person.luxury += value
	return ''

func fear(value):
	person.fear_raw(value)
	return ''

func stress(value):
	person.stress -= value
	return ''

func obedmod(value):
	person.stats.obed_mod += value
	return ''

#caution: abilities gained from items should not be acquirable by other means
func abil(value):
	if value.ends_with('-'):
		value = toggleStrNeg(value)
		person.ability.erase(value)
		person.abilityactive.erase(value)
	else:
		if !person.ability.has(value):
			person.ability.append(value)
		if !person.abilityactive.has(value):
			person.abilityactive.append(value)

func checkreqs(item):
	if item.reqs == null:
		return true
	for i in item.reqs:
		if i.oper == 'gte':
			if person[i.reqstat] < i.reqvalue:
				return false
		elif i.oper == 'lte':
			if person[i.reqstat] > i.reqvalue:
				return false
		elif i.oper == 'eq':
			if person[i.reqstat] != i.reqvalue:
				return false
	return true



### CLOTH EFFECTS
func sundresseffect(person):
	person.stress -= rand_range(4,8)
	return "$name's sundress help $him slightly relax.\n"

func maiduniformeffect(person):
	person.obed += rand_range(5,10)
	return "$name's maid uniform inspires $him to be more obedient.\n"

func kimonoeffect(person):
	pass

func livingsuiteffect(person):
	person.lust += 10
	return "$name is being stimulated by wearing a [color=yellow]Living suit[/color] and $his lust grows.\n"

func peteffect(person):
	var text = "$name wears a pet suit "
	person.obed += rand_range(8,16)
	if person.conf >= 40 && person.traits.has('Submissive') == false:
		text += "and is very unhappy about it, although $his obedience grows.\n"
		person.stress += rand_range(5,10)
		person.conf += rand_range(-2,-4)
	else:
		text += "and $his obedience grows.\n"
	return text

func mikoeffect(person):
	var text = "$name's miko outfit helps $him to collect $his thoughts and calm down.\n"
	person.stress += rand_range(-3,-5)
	person.lust -= rand_range(4,6)
	return text

func bedlaheffect(person):
	var text = "$name's revealing clothes teach $him how to better present $himself to others. \n"
	person.charm += rand_range(1,3)
	return text

###---Added by Expansion---### ElPresidente's Items
func ancientswordeffect(person):
	var text = person.dictionary("$name finds $himself examining the blade at $his side throughout the day. ")
	if person.cour > 40:
		text += person.dictionary("The still-sharp blade gives $him confidence that $he will survive many battles as well while wielding it.\n")
		person.conf += round(rand_range(1,3))
	else:
		text += person.dictionary("The ancient bloodstains on its metal blade makes $him wonder when that is all $he will be as well and $he grows fearful.\n")
		person.fear += round(rand_range(3,5))
	return text

func chainbikinieffect(person):
	var text = person.dictionary("$name's skimpy bikini increases $his arousal and lewdness, but also provides stress as it chafes $him.\n")
	person.stress += round(rand_range(2,5))
	person.lust += round(rand_range(2,5))
	person.lewdness += round(rand_range(1,3))
	return text
###---End Expansion---###

func butleruniformeffect(person):
	person.obed += rand_range(5,10)
	return "$name is at your beck and call dressed as a butler. $His obedience grows.\n"

func slavecollareffect(person):
	var text = "$name "
	if person.traits.has('Submissive') == true:
		text += "happily wears the leather collar about $his neck showing $he is your person.\n"
		person.loyal += rand_range(1,3)
	else:
		if person.obed >= 70:
			text += "obediently wears the leather collar learning $his place.\n"
			person.obed += rand_range(3,6)
		else:
			text += "picks at the leather collar begging you to take it off.\n"
			person.obed += rand_range(3,6)
			person.stress += rand_range(3,6)
	return text
	
func handcuffeffect(person):
	var text = "$name "
	if person.traits.has('Deviant') == true:
		text += "becomes more aroused being bound by the handcuffs.\n"
		person.lust += rand_range(5,10)
		person.obed += rand_range(3,6)
	else:
		if person.obed >= 75:
			text += "attempts to do their daily tasks while handcuffed behind $his back.\n"
			person.obed += rand_range(3,6)
			person.asser += rand_range(-1,-3)
		else:
			text += "becomes more stressed as $he struggles to do $his daily tasks while handcuffed behind $his back.\n"
			person.obed += rand_range(3,6)
			person.stress += rand_range(5,10)
			person.asser += rand_range(-1,-3)
	return text


func createunstackable(itemcode):
	var item = itemlist[itemcode]
	var tempitem = {code = item.code, type = item.subtype, name = item.name, owner = null, effects = str2var(var2str(item.effect)), enchant = '', reqs = item.reqs, icon = item.icon, description = item.description, weight = item.weight}
	if item.has('enchant'): tempitem.enchant = item.enchant
	tempitem.id = "I" + str(globals.state.itemcounter) 
	globals.state.itemcounter += 1
	return tempitem

func aphrodisiaceffect():
	if person == globals.player:
		return('You decide this potion is not going to benefit you at all.')
	person.lust += 70
	var text = person.dictionary("After ingesting an aphrodisiac, $name begins showing signs of growing excitement.")
	return text

func regressionpoteffect():
	if person == globals.player:
		return('You decide this potion is not going to benefit you at all.')
	person.trait_remove('Uncivilized')
	person.add_trait('Pliable')
	person.add_trait('Regressed')
	person.loyal += rand_range(15,25)
	var text = person.dictionary("As $name drinks the potion, the look on $his face becomes less and less focused, until eventually $his mind is reformed back into a very young and learning state. With this you can leave much greater impact on $his consciousness. ")
	return text

func claritypoteffect():
	globals.main.traitpanelshow(person, 'clearmental')

func hairdyeeffect():
	globals.main.get_node("itemnode/hairdyepanel/TextEdit").set_text('')
	globals.main.get_node("itemnode/hairdyepanel").set_hidden(false)

func hairgrowtheffect():
	var text = ''
	var list = globals.hairlengtharray
	if person.hairlength != 'hips':
		person.hairlength = list[list.find(person.hairlength)+1]
		text = "Applying the elixir to $his hair, $name shows almost instant growth as $his hair gains new length."
	else:
		text = "The Hair Growth Elixir isn't effective as $name applies it, as $his hair is already overly long."
	if person == globals.player:
		text = text.replace("$name's", 'your')
		text = text.replace("$name", 'you')
	return text

func maturingpot():
	var text = ''
	if person.age != 'adult':
		person.age = globals.agesarray[globals.agesarray.find(person.age)+1]
		if person == globals.player:
			text = person.dictionary('You chug down an Elixir of Maturity and observe new changes in a nearby mirror. ')
		else:
			text = person.dictionary('You hand an Elixir of Maturity to $name, and tell $him to drink it. After a few moments, $his body begins to change. $He looks down in bewilderment, then checks out $his new, more mature-looking self in a nearby mirror. ')
		if rand_range(1,10) > 5 && person.height != 'tiny' && person.height != 'towering':
			person.height = globals.heightarrayexp[globals.heightarrayexp.find(person.height)+1]
			text = text + "$name has become taller. "
		if rand_range(1,10) > 5 && person.hairlength != 'hips':
				person.hairlength = globals.hairlengtharray[globals.hairlengtharray.find(person.hairlength)+1]
				text = text + "$name's hair has grown longer. "
		if person.sex != 'male':
			if rand_range(1,10) > 5 && person.asssize != 'huge':
				person.asssize = globals.asssizearray[globals.asssizearray.find(person.asssize)+1]
				text = text + "$name's butt has grown bigger. "
			if rand_range(1,10) > 5 && person.titssize != 'immobilizing':
				person.titssize = globals.titssizearray[globals.titssizearray.find(person.titssize)+1]
				text = text + "$name's tits have grown bigger. "
		if person.penis != 'none':
			if rand_range(1,10) > 5 && person.penis != 'massive':
				person.penis = globals.penissizearray[globals.penissizearray.find(person.penis)+1]
				text = text + "$name's cock has grown bigger. "
		if person.balls != 'none':
			if rand_range(1,10) > 5 && person.balls != 'massive':
				person.balls = globals.penissizearray[globals.penissizearray.find(person.balls)+1]
				text = text + "$name's balls have grown bigger. "
	else:
		text = 'Elixir of Maturity had no visible effect on $name. '
	if person == globals.player:
		text = text.replace("$name's", 'Your')
		text = text.replace("$name", 'You')
	return text

func youthingpot():
	var text = ''
	if (person.age != 'child' && globals.rules.children == true) || person.age == 'adult':
		person.age = globals.agesarray[globals.agesarray.find(person.age)-1]
		if person == globals.player:
			text = person.dictionary('You chug down an Elixir of Youth and observe new changes in a nearby mirror. ')
		else:
			text = person.dictionary('You hand an Elixir of Youth over to $name and tell $him to drink it. After a few moments, $his body begins to change. $He looks down in bewilderment, then checks out $his new, younger-looking self in a nearby mirror. ')
		if rand_range(1,10) > 5 && person.height != 'tiny' && person.height != 'petite':
			person.height = globals.heightarrayexp[globals.heightarrayexp.find(person.height)-1]
			text = text + "$name has become shorter. "
		if person.sex != 'male':
			if rand_range(1,10) > 5 && person.asssize != 'flat':
				person.asssize = globals.asssizearray[globals.asssizearray.find(person.asssize)-1]
				text = text + "$name's butt shrinks in size. "
			if rand_range(1,10) > 5 && person.titssize != 'flat' && !(person.sex == 'dickgirl' && person.titssize == 'small'):
				person.titssize = globals.titssizearray[globals.titssizearray.find(person.titssize)-1]
				text = text + "$name's tits shrink in size. "
		if person.penis != 'none':
			if rand_range(1,10) > 5 && person.penis != 'micro':
				person.penis = globals.penissizearray[globals.penissizearray.find(person.penis)-1]
				text = text + "$name's cock shrinks in size. "
		if person.balls != 'none':
			if rand_range(1,10) > 5 && person.balls != 'micro':
				person.balls = globals.penissizearray[globals.penissizearray.find(person.balls)-1]
				text = text + "$name's balls shrink in size. "
	else:
		text = 'Elixir of Youth had no visible effect on $name. '
	if person == globals.player:
		text = text.replace("$name's", 'Your')
		text = text.replace("$name", 'You')
	return text

func amnesiapoteffect():
	if person == globals.player:
		return('You decide this potion is not going to benefit you at all.')
	var text = ''
	text = person.dictionary('After chugging down the Amnesia Potion, $name looks lightheaded and confused. "W-what was that? I feel like I have forgotten something..." $He is lost, unable to recall the memories of the time before $his confinement as your servant. ')
	if person.effects.has('captured'):
		person.add_effect(globals.effectdict.captured, true)
		text = text + person.dictionary('Memories from before $his confinement no longer influence $him to resist you. ')
	if person.loyal < 50 && person.memory != 'clear':
		text = text + person.dictionary("$He grows closer to you, having no one else $he can rely on. ")
		person.loyal += rand_range(15,25) - person.conf/10
	###---Added by Expansion---### Vice Removal
	if person.mind.vice != "none":
		if person.mind.vice_known == true:
			text += person.dictionary("\n$His mental regression seems to have removed $his [color=aqua]"+ str(person.mind.vice.capitalize()) +" Vice[/color] as well. ")
		person.mind.vice = "none"
		person.mind.vice_removed = true
		person.mind.vice_known = true
	if !person.mind.approaches.pushed.empty():
		text += person.dictionary("\n$He seems to have forgotten about any [color=aqua]Pushed[/color] [color=red]Approaches[/color] also. ")
		person.mind.approaches.pushed.clear()
	###---End Expansion---###
	for i in person.relations:
		person.relations[i] = 0
		if i == globals.player.id:
			person.relations[i] = 300
	person.memory = 'clear'
	return text

func lactationpoteffect():
	var text = ''
	if person.lactation == false:
		person.lactation = true
		###---Added by Expansion---### Lactation Knowledge
		person.knowledge.append('lactating')
		###---End Expansion---###
		if person == globals.player:
			text = person.dictionary("A few hours after drinking the Nursing Potion, your tits start secreting milk. ")
		else:
			text = person.dictionary("A few hours after drinking the Nursing Potion, $name's tits started secreting milk. ")
	else:
		if person == globals.player:
			text = person.dictionary('The Nursing Potion has no apparent effect on you, as you are already lactating. ')
		else:
			text = person.dictionary('The Nursing Potion has no apparent effect on $name, as $he is already lactating. ')
	return text

func oblivionpoteffect():
	var text = ''
	if person != globals.player:
		text = person.dictionary('$name drinks the oblivion potion, forgetting all $his fixations. ')
		person.levelupreqs.clear()
	else:
		text = person.dictionary('You drink the oblivion potion, but it seems to not have any effect on you. ')
	return text

func misscariageeffect():
	person.abortion()
#	person.preg.baby = null
#	person.preg.duration = 0
	return person.dictionary("Drinking the miscarriage potion ends $name's pregnancy as $his body magically absorbs what had been growing inside it.")

func stimulanteffect():
	if person == globals.player:
		return('You decide this potion is not going to benefit you at all.')
	if person.effects.has('stimulated') == false:
		person.add_effect(globals.effectdict.stimulated)
		return('After ingesting the potion, $name starts to act a lot more sensitive to being touched than before. ')
	else:
		return("Apparently, $name isn't greatly affected by drinking the potion as the previous effect hasn't worn off yet.")

func deterrenteffect():
	if person == globals.player:
		return('You decide this potion is not going to benefit you at all.')
	if person.effects.has('numbed') == false:
		person.add_effect(globals.effectdict.numbed)
		return('After ingesting the potion, $name starts to act somewhat more dull then before. ')
	else:
		return("Apparently, $name isn't greatly affected by drinking the potion as the previous effect hasn't worn off yet.")
	

func beautyeffect():
	var text = ''
	if person == globals.player:
		text = person.dictionary('You apply the Beauty Mixture to your face, which makes your skin smoother and hides visible flaws.')
	else:
		text = person.dictionary('You order $name to apply Beauty Mixture to $his face, which will make $his skin smoother and hides visible flaws.')
	
	person.add_effect(globals.effectdict.beautypot)
	###---Added by Expansion---### ElPresidente
	person.beautybase += 5
	###---End Expansion---###
	return text

var currentpotion = ''

func bandageeffect():
	if person.effects.has('bandaged') == false:
		globals.get_tree().get_current_scene().infotext(person.dictionary("Bandage used on $name."),'green')
		person.health += person.stats.health_max/3
		person.add_effect(globals.effectdict.bandaged)
	else:
		globals.get_tree().get_current_scene().infotext(person.dictionary("Bandage used on $name with reduced efficiency."),'green')
		person.health += person.stats.health_max/5

###---Added by Expansion---###
func hyperlactationpoteffect():
	var text = ""
	text += person.dictionary("You order [color=aqua]$name[/color] to drink the bottle of [color=aqua]lactation potion[/color]. ")
	if rand_range(0,100) <= 50 || person.obed >= 50:
		text += person.dictionary("$He gulps it down eagerly. ")
	else:
		text += person.dictionary("$He warily takes the bottle and sips from it. ")
	
	if person.lactation == true:
		person.lactating.hyperlactation = true
		if !person.knowledge.has('lactating'):
			person.knowledge.append('lactating')
		text += person.dictionary("$He swallows and looks at you uncertainly. Almost immediately, $he lets out a deep, guttural moan that sounds like a violent orgasm. ")
		if person.send >= 4:
			text += person.dictionary("$His knees start to shake and $he barely stays upright as $his nipples start to trickle milk. ")
		else:
			text += person.dictionary("$His knees start to shake and $he falls onto all fours as $his nipples start to trickle milk. ")
		if person.vagina != "none":
			text += person.dictionary("$He violently orgasms again and you hear a wet gushing noise before $his pussy gushes and sprays ")
			if person.penis != "none":
				text += person.dictionary("followed by a spray of semen from $his cock. ")
			else:
				text += ". "
		if person.penis != "none" && person.vagina == 'none':
			text += person.dictionary("$He violently orgasms again and you see $his cock convulse and spray semen onto the ground in front of $him. ")
		text += person.dictionary("\n[color=aqua]$name[/color] looks back at you weakly as $his tits continuously stream milk down them like a faucet. $He definitely appears to be [color=aqua]Hyperlactating[/color]. ")
	else:
		person.lactation = true
		person.knowledge.append('lactating')
		text += person.dictionary("$He swallows and looks at you uncertainly. Several minutes go by before $he grabs and rubs $his nipples with a wince of pain.\n\n$He pulls $his fingers away to discover that $he is now lactating, though it does not seem to be an abnormal amount. ")
	return text

func milkeffect():
	var text = ""
	text += person.dictionary("You order [color=aqua]$name[/color] to drink the bottle of [color=aqua]milk[/color]. ")
	if rand_range(0,100) <= 50 || person.obed >= 50:
		text += person.dictionary("$He gulps it down eagerly. ")
	else:
		text += person.dictionary("$He warily takes the bottle and sips from it. ")
	text += person.dictionary("The sweet flavor seems to immediately shock some [color=aqua]Energy[/color] back into $him. ")
	person.energy += round(rand_range(15,30))
	
	if person.checkFetish('drinkmilk', 1.5) == true:
		text += person.dictionary("$He actually seems to enjoy the taste of the [color=aqua]milk[/color]. $He takes a moment to enjoy the bottle and relaxes slightly, relieving some stress. ")
		person.stress -= round(rand_range(15,30))
	else:
		text += person.dictionary("$He almost gags after realizing what the liquid is. $He sees you watching $him and chokes down the rest of the liquid but gains some stress from the experience. ")
		person.stress += round(rand_range(5,10))
	return text

func semeneffect():
	var text = ""
	text += person.dictionary("You order [color=aqua]$name[/color] to drink the bottle of [color=aqua]semen[/color]. ")
	if rand_range(0,100) <= 50 || person.obed >= 50:
		text += person.dictionary("$He gulps it down eagerly. ")
	else:
		text += person.dictionary("$He warily takes the bottle and sips from it. ")
	text += person.dictionary("The salty flavor seems to immediately shock some [color=aqua]Energy[/color] back into $him. ")
	person.energy += round(rand_range(15,30))
	
	if person.checkFetish('drinkcum', 1.25) == true:
		text += person.dictionary("$He actually seems to enjoy the taste of the [color=aqua]semen[/color]. $He takes a moment to enjoy the bottle and relaxes slightly, relieving some stress. ")
		person.lewdness += round(rand_range(3,7))
		person.stress -= round(rand_range(5,10))
	else:
		text += person.dictionary("$He almost gags after realizing what the liquid is. $He sees you watching $him and chokes down the rest of the [color=aqua]semen[/color] but gains some stress from the experience. ")
		person.lewdness += round(rand_range(1,3))
		person.stress += round(rand_range(5,10))
	text += person.dictionary("$He obviously feels slightly lewder from having drank the sexual fluid. ")
	return text

func lubeeffect():
	var text = ""
	text += person.dictionary("You order [color=aqua]$name[/color] to drink the bottle of [color=aqua]lube[/color]. ")
	if rand_range(0,100) <= 50 || person.obed >= 50:
		text += person.dictionary("$He gulps it down eagerly. ")
	else:
		text += person.dictionary("$He warily takes the bottle and sips from it. ")
	text += person.dictionary("The salty flavor seems to immediately shock some [color=aqua]Energy[/color] back into $him. ")
	person.energy += round(rand_range(15,30))
	
	if person.checkFetish('drinkcum', 1.25) == true:
		text += person.dictionary("$He actually seems to enjoy the taste of the [color=aqua]lube[/color]. $He takes a moment to enjoy the bottle and relaxes slightly, relieving some stress. ")
		person.lewdness += round(rand_range(3,7))
		person.stress -= round(rand_range(5,10))
	else:
		text += person.dictionary("$He almost gags after realizing what the liquid is. $He sees you watching $him and chokes down the rest of the [color=aqua]lube[/color] but gains some stress from the experience. ")
		person.lewdness += round(rand_range(1,3))
		person.stress += round(rand_range(5,10))
	text += person.dictionary("$He obviously feels slightly lewder from having drank the sexual fluid. ")
	return text

func pisseffect():
	var text = ""
	text += person.dictionary("You order [color=aqua]$name[/color] to drink the bottle of [color=aqua]piss[/color]. ")
	if rand_range(0,100) <= 50 || person.obed >= 50:
		text += person.dictionary("$He gulps it down eagerly. ")
	else:
		text += person.dictionary("$He warily takes the bottle and sips from it. ")
	text += person.dictionary("The potent flavor seems to immediately shock a little [color=aqua]Energy[/color] back into $him. ")
	person.energy += round(rand_range(5,10))
	
	if person.checkFetish('drinkpiss', 1.25) == true:
		text += person.dictionary("$He actually seems to enjoy the taste of the [color=aqua]piss[/color] and takes another gulp. $He runs the liquid over $his lips sensually, obviously deriving immense perverse pleasure from the degredation. ")
		person.lewdness += round(rand_range(7,15))
		person.stress -= round(rand_range(5,10))
	else:
		text += person.dictionary("$He almost gags after realizing what the liquid is. $He sees you watching $him and chokes down the rest of the [color=aqua]piss[/color] but gains some stress from the experience. ")
		person.lewdness += round(rand_range(3,5))
		person.stress += round(rand_range(10,20))
	return text

func sedativeeffect():
	var number = round(rand_range(25,50))
	var text = person.dictionary("You order [color=aqua]$name[/color] to drink the bottle of [color=aqua]sedative[/color]. ")
	if rand_range(0,100) <= 50 || person.obed >= 50:
		text += person.dictionary("$He gulps it down eagerly. ")
	else:
		text += person.dictionary("$He warily takes the bottle and sips from it. ")
	text += person.dictionary("You see $his eyes start to glaze over and energy seems to drain from $his body. $He loses [color=red]" + str(number) + " Energy[/color]. ")
	
	if person.energy - number <= 0 && rand_range(0,100) <= globals.expansionsettings.sedativewitlosschance:
		person.wits -= round(rand_range(3,7))
		text += person.dictionary("$He opens $his mouth as if $he is going to speak, then starts to drool slightly. You touch $his face and $his dull eyes drift toward your face. The heavy dose of sedatives in $his mentally weakened state seems to have permanently lowered $his [color=aqua]Wits[/color]. ")	
	person.energy -= number
	return text

func sexchangepoteffect():
	#Created by Rendrassa
	var text = ''
	match person.sex:
		'male':
			person.penis = ""
			person.balls = ""
			person.vagina = globals.randomitemfromarray(globals.vagsizearray)
			person.vagvirgin = true
			text = person.dictionary("$name's penis shrinks into a clitoris as vaginal lips form beneath it. ")
			person.sex = 'female'
			person.dailyevents.append('sex_changed_potion')
		'female':
			person.vagina = ""
			person.penis = globals.randomitemfromarray(globals.penissizearray)
			person.balls = globals.randomitemfromarray(globals.penissizearray)
			text = person.dictionary("$name's clitoris morphs into a fully functional penis with a pair of testicles forming beneath it. ")
			person.sex = 'male'
			person.dailyevents.append('sex_changed_potion')
		'futanari','dickgirl':
			text = person.dictionary("The potion's magic fills $name with toxicity but there is no visible effect on $his body. ")
	#Abnormal Sex
	if text == "":
		text = "The potion failed. It cannot understand the complexities of $name's sexuality. "
	if person == globals.player:
		text = text.replace("$name's", 'Your')
		text = text.replace("$name", 'You')
	return text

###---Expansion End---###


#recipes
func recipedecrypt(item):
	var text = ''
	var recipe = item.recipe
	var canmake = true
	for i in get(recipe):
		var ingredient = globals.itemdict[i]
		var amount = get(recipe)[i]
		text += ingredient.name + ' - '+ str(amount) + ', '
		if ingredient.amount < amount:
			canmake = false
	var dict = {}
	dict.text = text
	dict.canmake = canmake
	return dict

func recipemake(item):
	var recipe = item.recipe
	for i in get(recipe):
		var ingredient = globals.itemdict[i]
		var amount = get(recipe)[i]
		ingredient.amount -= amount
	if globals.state.spec == 'Alchemist':
		item.amount += 2
	else:
		item.amount += 1


#unstackable item management

var backpack = false

func equipitem(itemid, person = person, notplayer = false): 
	var item 
	if notplayer == true:
		item = globals.main.get_node('explorationnode').enemygear[itemid]
	else:
		item = globals.state.unstackables[itemid]
	###---Added by Expansion---### NPC Expanded Item Fix
	if itemid == null || item == null:
		print('Equip item failure.')
		return
	###---End Expansion---###
	self.person = person
	
	if checkreqs(item) == false && notplayer == false:
		globals.main.infotext(person.dictionary("$name does not pass the requirements for ") + item.name, 'red')
		return 'failure'
	
	if person.gear[item.type] != null:
		unequipitem(person.gear[item.type], person)
	
	person.gear[item.type] = item.id
	item.owner = person.id
	
	for i in item.effects:
		if i.type == 'onequip':
			call(i.effect, i.effectvalue)

func unequipitem(itemid, person = person, notplayer = false):
	###---Added by Expansion---### NPC Expanded Item Fix
	var item
	if notplayer:
		item = globals.main.get_node('explorationnode').enemygear[itemid]
	else:
		item = globals.state.unstackables[itemid]
	
	if itemid == null  || item == null:
		print('Unequip item failure.')
		return
	###---End Expansion---###
	self.person = person
	
	person.gear[item.type] = null
	for i in item.effects:
		if i.type == 'onequip':
			if typeof(i.effectvalue) == TYPE_STRING:
				call(i.effect, toggleStrNeg(i.effectvalue))
			else:
				call(i.effect, -i.effectvalue)
	person.health += 0
	if notplayer:
		globals.main.get_node('explorationnode').enemygear.erase(itemid)
	elif backpack == true:
		item.owner = 'backpack'
	else:
		item.owner = null

func unequipitemraw(item, person = person):
	###---Added by Expansion---### NPC Expanded Item Fix
	if item == null:
		print('Unequip item failure.')
		return
	###---End Expansion---###
	self.person = person
	person.gear[item.type] = null
	for i in item.effects:
		if i.type == 'onequip':
			if typeof(i.effectvalue) == TYPE_STRING:
				call(i.effect, toggleStrNeg(i.effectvalue))
			else:
				call(i.effect, -i.effectvalue)
	person.health += 0
	item.owner = null

func unequipall(person):
	for i in person.gear.values():
		if i != null:
			unequipitem(i, person)

###---Added by Expansion---### Ank Bugfix 5.25 v4
func toggleStrNeg(value):
	if value.ends_with('-'):
		return value.erase(value.length()-1, 1)
	else:
		return value + '-'
###---End Expansion---###


func sortitems(first, second):
	var type = ['potion','ingredient']
	if type.find(first.type) > type.find(second.type):
		return false
	elif type.find(first.type) == type.find(second.type):
		if first.name >= second.name:
			return false
		else:
			return true
	else:
		return true

func sortbytype(first, second):
	var type = ['potion','ingredient']
	if type.find(globals.itemdict[first].type) > type.find(globals.itemdict[second].type):
		return false
	elif type.find(globals.itemdict[first].type) == type.find(globals.itemdict[second].type):
		if first >= second:
			return false
		else:
			return true
	else:
		return true

func foodpurchase(item):
	var amount = globals.itemdict.food.amount
	amount = min(amount, ceil((globals.resources.foodcaparray[globals.state.mansionupgrades.foodcapacity] - globals.resources.food) / 20.0))
	globals.resources.gold -= amount*globals.itemdict.food.cost
	globals.resources.food += amount*20
	globals.itemdict.food.amount = 0

###---Added by Expansion---### Ank BugFix v4a
func teleportunlock(item):
	globals.resources.gold -= item.cost
	globals.state.portals[item.code.replace('teleport','')].enabled = true
	if item.code != 'teleportumbra':
		globals.get_tree().get_current_scene().popup("Portal to " + item.code.replace('teleport','').capitalize() + ' has been unlocked.')
	else:
		globals.get_tree().get_current_scene().get_node("outside").sebastianquest(4)
		globals.get_tree().get_current_scene().get_node("outside/shoppanel/inventory")._on_inventoryclose_pressed()
		globals.get_tree().get_current_scene().get_node("outside").shopclose()
###---End Expansion---###

func aydabrandy(item):
	globals.resources.gold -= item.cost
	globals.state.sidequests.ayda = 9
	main.get_node('outside/shoppanel/inventory').itemsshop()
	#globals.main.infotext('Quest advanced','yellow')

func aydabook(item):
	globals.resources.gold -= item.cost
	globals.state.sidequests.ayda = 12
	main.get_node('outside/shoppanel/inventory').itemsshop()
	#globals.main.infotext('Quest advanced','yellow')

func aydajewel(item):
	globals.state.sidequests.ayda = 15
	globals.main.infotext('Quest advanced','yellow')
	main.popup("You hide the rare jewelry in your pocket. ")

func zoebook(item):
	main.popup("The Mysterious Book Acquired. ")
	globals.itemdict['zoebook'].amount += 1
