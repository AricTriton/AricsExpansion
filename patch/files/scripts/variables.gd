extends Node

var basehealth = 50.0
var ogrebasehealth = 65.0
var healthperend = 25.0
var ogrehealthperend = 40.0
###---Added by Expansion---### Difficulty Adjustment
var geardropchance = 30.0
var timeformeetinteraction = 20.0
###---End Expansion---###
var enchantitemprice = 1.5
var sellingitempricemod = 0.2
var basefoodconsumption = 10.0
var skillpointsperlevel = 2.0
var timeforinteraction = 20.0
var bonustimeperslavefororgy = 10.0
var consumerope = 1.0
var ropewearoutrate = 10.0
var learnpointsperstat = 3.0
var attributepointsperupgradepoint = 1.0
var specializationchance = 5.0
#ralphC - Mana Eater Mechanics (incl Succubus, Golem, etc.)
var basemanafoodconsumption = 10.0 #ralphC
var orgasmmana = 3 #ralphC - 3 is default
var succubusagemod = { #ralphC - [child,teen,adult] Succubus base mana food consumption multiplier
	child = 1.0, teen = 2.0, adult = 3.0
}
var succubushungerlevel = [1.5,3.0,7.0] #ralphC - [munchies = 1.5, sex crazed 3, death 7] see mansion.gd
#/ralphC

###---Added by Expansion---### Difficulty Adjustment
var playerstartbeauty = 70.0
var characterstartbeauty = 50.0
###---End Expansion---###
var basesexactions = 1.0
var basenonsexactions = 1.0
var dailyactionsperslave = 2.0
var playerbonusstatpoint = 2.0
var banditishumanchance = 70.0

#Pregnancies

###---Added by Expansion---### Pregnancy Expanded
var pregduration = 14.0
var growuptimechild = 2.0
var growuptimeteen = 4.0
var growuptimeadult = 6.0
###---End Expansion---###
var traitinheritchance = 80.0
var babynewtraitchance = 20.0

#slave stats & combat

var damageperstr = 4.0
var damagepermaf = 3.0
var damageperagi = 2.0
var speedperagi = 3.0
var speedbase = 10.0
var baseattack = 5.0
var basecarryweight = 10.0
var carryweightperstrplayer = 4.0
var baseslavecarryweight = 3.0
var slavecarryweightperstr = 5.0


#slave prices constants

var priceperlevel = 40.0
var priceperbasebeauty = 2.5
var priceperbonusbeauty = 1.5
var pricebonusvirgin = 0.15
var pricebonusfuta = 0.1
###---Added by Expansion---### centerflag982
var pricebonusdickgirl = 0.05
###---End Expansion---###					
var pricebonusbadtrait = -0.1
var pricebonustoxicity = -0.33
var priceuncivilized = -0.5
var priceminimum = 5.0
var priceminimumsell = 10.0


#sidecharacters

var oldemily = false

###---Added by Expansion---### AgePriceMods Returned
# grade and age mods will be added as bonus to base price which starts at 1 [baseprice*(1+value)]
var gradepricemod = {
	"slave": -0.2, poor = 0.0, commoner = 0.2, rich = 0.5, noble = 1.0
}

var agepricemods = {
	child = 0.2, teen = 0.1, adult = 0.0
}
###---End Expansion---###


var luxuryreqs = {"slave" : 0, poor = 5, commoner = 15, rich = 25, noble = 40}

#upgrades

###---Added by Expansion---### Farm Expanded
var resident_farm_limit = [2,5,8,12,15,18,21,24,27,30,35,40,45,50,55,60,65,70,75,80,85,90,95,100,150,200,250,300,350,400,500]
###---End Expansion---###

###---Added by Expansion---### Pregnancy Expanded (Deviate)
var list = {
	'Character Creation & Stats' : {
		basehealth = {descript = "Character's health before modifiers", min = 1.0, max = 1000.0},
		ogrebasehealth = {descript = "Ogre character's health before modifiers", min = 1.0, max = 1000.0},
		healthperend = {descript = "Bonus health per point of endurance", min = 0.0, max = 1000.0},
		ogrehealthperend = {descript = "Enhanced health per point of endurance", min = 0.0, max = 1000.0},
		playerbonusstatpoint = {descript = "Bonus player stat points during char creation", min = 0.0, max = 1000.0},
		playermaxstats = {descript = "Max points per player stat during char creation", min = 4.0, max = 1000.0},
		storymodeanyrace = {descript = "Choose any race when starting story mode"},
		basefoodconsumption = {descript = "Basic food consumption for characters per day", min = 0.0, max = 100.0},
		skillpointsperlevel = {descript = "Attribute points gained on level-up", min = 0.0, max = 100.0},
		learnpointsperstat = {descript = "Number of skill points required to increase mental stat by 1", min = 1.0, max = 100.0},
		attributepointsperupgradepoint = {descript = "Number of attribute points required to increase upgrade points by 1", min = 1.0, max = 100.0},
		specializationchance = {descript = "Percent chance of characters having a specialization", min = 0.0, max = 100.0},
		banditishumanchance = {descript = "Percent chance of bandits being human", min = 0.0, max = 100.0},
		playerstartbeauty = {descript = "Player's starting beauty stat", min = 0.0, max = 100.0},
		characterstartbeauty = {descript = "Starting slave's starting beauty stat", min = 0.0, max = 100.0},
		oldemily = {descript = "Use old Emily sprite"},
		luxuryreqs = {descript = "Luxury required to satisfy slaves per grade", min = 0.0, max = 60.0},
	},
	'Interactions' : {
		basesexactions = {descript = "Number of sex actions per day (before bonus from endurance)", min = 0.0, max = 1000.0},
		basenonsexactions = {descript = "Number of non-sex actions per day (before bonus from endurance)", min = 0.0, max = 1000.0},
		dailyactionsperslave = {descript = "Max number of interactions with a slave in a day", min = 1.0, max = 1000.0},
		timeforinteraction = {descript = "Number of actions you can perform during sex interaction sequence", min = 10.0, max = 1000.0},
		bonustimeperslavefororgy = {descript = "Bonus number of actions gained for each slave in an sex orgy interaction sequence", min = 1.0, max = 1000.0},
		timeformeetinteraction = {descript = "Number of actions you can perform during meet interaction sequence", min = 10.0, max = 1000.0},
	},
	'Pregnancies' : {
		pregduration = {descript = "Basic pregnancy duration in days", min = 1.0, max = 1000.0},
		growuptimechild = {descript = "Time required for baby to mature", min = 1.0, max = 1000.0},
		growuptimeteen = {descript = "Time required for baby to mature", min = 1.0, max = 1000.0},
		growuptimeadult = {descript = "Time required for baby to mature", min = 1.0, max = 1000.0},
		traitinheritchance = {descript = "Chance to inherit a parent's trait", min = 0.0, max = 100.0},
		babynewtraitchance = {descript = "Chance to gain a new trait", min = 0.0, max = 100.0},
	},
	'Combat' : {
		damageperstr = {descript = "Raw damage per strength", min = 0.0, max = 100.0},
		damagepermaf = {descript = "Raw damage per magic affinity", min = 0.0, max = 100.0},
		damageperagi = {descript = "Raw damage per agility", min = 0.0, max = 100.0},
		speedperagi = {descript = "Raw speed per agility", min = 0.0, max = 100.0},
		speedbase = {descript = "Base speed for all characters", min = 0.0, max = 100.0},
		baseattack = {descript = "Base attack for all characters", min = 0.0, max = 100.0},
	},
	'Slave Price' : {
		priceperlevel = {descript = "Slave price modifier per level", min = 0.0, max = 1000.0},
		priceperbasebeauty = {descript = "Slave price modifier per beauty", min = 0.0, max = 1000.0},
		priceperbonusbeauty = {descript = "Slave price modifier per bonus beauty"},
		pricebonusvirgin = {descript = "Slave price modifier for virgins", min = -10.0, max = 10.0},
		pricebonusfuta = {descript = "Slave price modifier for futa", min = -10.0, max = 10.0},
		pricebonusbadtrait = {descript = "Slave price modifier for bad traits", min = -10.0, max = 10.0},
		pricebonustoxicity = {descript = "Slave price modifier for high toxicity", min = -10.0, max = 10.0},
		priceuncivilized = {descript = "Slave price modifier for uncivilized trait", min = -10.0, max = 10.0},
		priceminimum = {descript = "Minimum slave buy price", min = 0.0, max = 1000.0},
		priceminimumsell = {descript = "Minimum slave sell price", min = 0.0, max = 1000.0},
		gradepricemod = {descript = "Slave price modifier per grade", min = -10.0, max = 10.0},
		agepricemods = {descript = "Slave price modifier per age", min = -10.0, max = 10.0},
	},
	'Items & Backpack' : {
		geardropchance = {descript = "Percent chance of getting enemy's gear on defeat", min = 0.0, max = 100.0},
		consumerope  = {descript = "Number of ropes to be consumed when capturing a slave in the wild", min = 0.0, max = 5.0},
		ropewearoutrate = {descript = "Rate of increase after use of the percent chance of rope wearing out when used", min = 0.0, max = 100.0},
		sellingitempricemod = {descript = "Selling price modifier for all items", min = 0.1, max = 1.0},
		enchantitemprice = {descript = "Selling price modifier for enchanted gear", min = 1.0, max = 10.0},
		basecarryweight = {descript = "Base carry weight", min = 0.0, max = 1000.0},
		carryweightperstrplayer = {descript = "Bonus carry weight from player strength", min = 0.0, max = 1000.0},
		baseslavecarryweight = {descript = "Bonus carry weight for having a slave in party", min = 0.0, max = 1000.0},
		slavecarryweightperstr = {descript = "Bonus carry weight per slave's point of strength", min = 0.0, max = 1000.0},
	},
}
###---End Expansion---###
var playermaxstats = 7

var storymodeanyrace = false
