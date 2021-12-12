### <CustomFile> ###

###---Variables: These can safely be altered---### Still in Progress, will be edited through In-Game Settings UI eventually

var modversion = 1.4

#---Debug Tools (True/False)
var perfectinfo = false
var enablecheatbutton = false


#---Content Filter | Partially Enabled (True/False)
var brutalcontent = true
var messycontent = true
#Bloody Good Taste (British the Descriptions)
var ihavebloodygoodtaste = false

#---Ralph Edition Changes | Makes the game a little more difficult
#Mage Specialization Manacost Reduction
var mage_mana_reduction = false		# Original - true

#Spellcost Changes
var spellcost = 2 					# Original - 1, This is a multiplicative that applies to all spellcosts.
var mindread_manacost = 1			# Original - 3
var sedation_manacost = 20			# Original - 10
var dream_manacost = 5				# Original - 20
var entrancement_manacost = 10		# Original - 15
var fear_manacost = 20				# Original - 10
var mutate_manacost = 10			# Original - 15
var invigorate_manacost = 20		# Original - 5
var summontentacle_manacost = 20	# Original - 35

#Spell Tweak Effects
var reduce_rebellion_with_fear = 3	# Original - 1, This divides by the players magic affinity to determine how much rebellion is reduced.
var summontentacle_lewdness = 5		# Original - 0, Make... them... lewd...

#Reputation Tweak
var reputation_loss = -18			# Original - 4, How much your reputation suffers when you sell a bad slave to Sebastian.

#Food Tweak Effects
var food_experience = 1				# Original = 2, How much experience a slave earns from cooking, equal to the amount of slaves the player owns multiplied by this number.
var food_difficulty = true			# Original = false, 
var food_market_cost = 40			# Original = 10

var func_forage_tweaks = [3,2,5,1.5,2]			# Original - [4,20,25,1.2,5]
												# In order: represents how much base food is divided, 
												# how much additional food is multipled in min(food, max(person.sstr+person.send, -1)*[this number]+5), 
												# how much additional food is added in min(food, max(person.sstr+person.send, -1)*2+[this number]),
												# how much being a ranger multiplies the food gained,
												# and how much experience is gained by dividing by the amount of food gained total.

var func_hunt_tweaks = [1,3,8,1.4,1.5,3,5,3]	# Original - [2,5,10,1.3,1.25,30,40,7]
												# In order: represents the minimum random range that a person can obtain base food,
												# the minimum random range a person can obtain food multiplied by endurance,
												# the maximum random range a person can obtain food multiplied by endurance,
												# how much food is multiplied by being an Arachna,
												# how much food is multiplied by being a ranger or trapper,
												# how much additional food is multiplied in round(min(food, max(person.sstr+person.send, -1)*[this number]+5))
												# how much additional food is added in round(min(food, max(person.sstr+person.send, -1)*3+[this number]))
												# and how much experience is gained by dividing the amount of food gained total.


#---Person Expanded (True/False)
#If set to true, Unique Slaves will join your party without having to ask for consent first
var uniqueslavesautopartyconsent = false

#Lip Size Increase Change (Chance is array-5*10, ie: plump and bigger give 10)
var lipstraitbasechance = 25

#Base Bonus or Penalty for Attraction Checks for PCs
var playerattractionmodifier = 20

#Default to Nickname + First Name (Function from MinorTweaks, Renamed for Clarity)
var use_nickname_plus_first_name = false

#Show Once Per Day Conversations Available Notifications in Inspect
var show_onceperday_notification = true


#---Genitals Expanded
#Chance of Holes staying Stretched during Sex. Chance + (Elasticity*10)
var stretchchancevagina = 50
var stretchchanceanus = 50

#These chances (times the person's elasticity 1-5) occur during sex. 0-20 Max
var tornvagautorecovery = 20
var tornassautorecovery = 20

#The Tighten Chances are multiplied by their Age (inversely), ie: Adults=*1, Teens=*2
var vaginaltightenchance = 25
var analtightenchance = 20

#Chance of gaining Vaginal Wetness trait
var vaginalwetnesstraitchance = 15

#The average capacity that the hole's size adds or subtracts from
var baseholecapacity = 5


#---Sexuality Expanded (and Futas)
#Can the Player's sexuality shift (from what is picked at Character Creation)?
var player_sexuality_shift = true

#Are Futas considered Male, Female, or Both/Bi (for Attraction)
var futasexualitymatch = 'both'

#How the game considers Futa for Sexuality Shifts on the Kinsey Scale. Accepts Male, Female, Bi
var futasexualityshift = 'bi'


#------Facilities Expanded
var show_facilities_details_in_mansion = true

#---Dimensional Crystal
#Character Level to enable Crystal Change Dialogue | 0 to Disable for any but Headgirl
var changecrystalreq = 4

#Automatic Crystal Lifeforce Chance
var crystallifeforcerestorechance = 80
var crystal_shatter_chance = 80


#---Pregnancy Expanded
#Set to False to disable Swollen Settings (Pregnancy and Cum Inflation)
var swollenenabled = true
var wantedpregnancychance = 50

#Chance to Puke
var chancemorningsickness = 30

#Chance to Increase Tits
var chancetitsgrow = 35


#---Lactation Expanded
var lactationstops = false
var leakcauseslactationchance = 50

#Turn off to disable Lactation Stress
var lactationstressenabled = true


#---Farm Expanded
#Livestock Consent Base Chance (+ 50% loyalty, 25% obediance, + various factors)
var baselivestockconsentchance = 10
var foodconvertchance = 70

#Futa's Cum is Dilluted (in Farm)
var futacumproductionamt = 3
var futacumweakened = true
var futacumweakenedpercentage = 0.7

#Farm Struggle Modifiers
var cagestrugglemod = -5
var rackstrugglemod = -2
var freestrugglemod = 2
var restrainedstrugglemod = -3

#Damage Chances
var cagedamagechance = 50
var proddamagechance = 35
var witlosschance = 75
var restgainchance = 50

#Egg Labor
var chancetokillsnail = 35
var snailegglaborbadresult = true
var snailegglabordetails = true
var snailegglabordifficulty = 3
var snailegglaborpainchance = 20
var snailegglaborpleasurechance = 25
var snailegglaborvariable = 2

#Livestock Consent
var livestockautoconsentchance = 20
var livestockcanloseconsent = true
var livestockloseconsentchance = 20


#---Fetishes
#Unwanted Fetishes - Disables them from showing in the Fetish Talk menu
#Copy/Paste any you don't want into the 'unwantedfetishes' array below: ['incest','lactation','drinkmilk','bemilked','milking','exhibitionism','drinkcum','wearcum','wearcumface','creampiemouth','creampiepussy','creampieass','pregnancy','oviposition','drinkpiss','wearpiss','pissing','otherspissing','bondage','dominance','submission','sadism','masochism']
var unwantedfetishes = []

#FetishDifficulty is what Fetish*10 is multiplied by for the Chance of Success
var fetishdifficulty = 2

#Fetishes can Lower
var fetishescanlower = false

#Fetish Acceptance Multipliers
var lactationacceptancemultiplier = 2
var beingmilkedacceptancemultiplier = 2


#---Items Expanded
#Sedative Wit Loss Chance
var sedativewitlosschance = 75


#---Towns Expanded
#The Base Chance that local town guards will have arrested/killed escaped enemies to clear room in the array
var minimum_npcs_to_detain = 5
var townguardefficiency = 15

#NPC Town Guard Execution Chance
var randomexecutions = 25


#---Races Expanded
#Aric's Tweaks for Deviates Additions
var racialstatbonuses = true


#---Genealogy
var genealogy_equalizer = 10
var randompurebreedchance = 10
var randommixedbreedchance = 30
var randompurebreedchanceuncommon = 60 #ralph2
var secondaryhumanoidracialchance = 75
var secondaryuncommonracialchance = 0 #ralph
var secondarybeastracialchance = 25

#Ovulation Chances
var ovulationenabled = true

#These Cycles are dependant on the Birth Type
var livebirthcycle = 14
var eggcycle = 14

#Percentage of the time unfertile
var fertileduringcycle = 0.6
var semenlifespan = 5

#Deviate's Ovulation Cycle Below - Unused?
var ovulationtype1stage1 = 8
var ovulationtype1stage2 = 15
var ovulationtype2stage1 = 12
var ovulationtype2stage2 = 15
