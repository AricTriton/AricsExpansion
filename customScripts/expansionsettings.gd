### <CustomFile> ###

###---Variables: These can safely be altered---### Still in Progress, will be edited through In-Game Settings UI eventually

var modversion = "1.8d"

#---Aric's and Game's Base Values potentially changed by Ralph's
var use_ralphs_tweaks = false					# Set this to true if you want to use the settings within applyRalphsTweaks as well as the Hybrid system.
var unique_trait_generation = false				# Set this to true if you want a 1 in 5 chance for babies to gain unique traits such as sturdy.
var consolidatebeastDNA = false					# Set this to true if you don't like npcs with a mix of Beastkin/Halfkin race%'s (no half cat half foxes, etc.) #ralphB
var gratitude_for_all = false					# Set this to true so that babies aged up to Child or Teen have as much chance to spawn with the Grateful trait as ones aged up to Adult (Ralph sets this to False, but up to you) #ralphC
var sillymode = true							# Set it to false if you don't abide, so far it only affects random travel event text #ralphD

#---Base Game descriptions and the sort changed by Capitulize
var use_caps_tweaks = false						# Set this to true if you want to use Capitulize's tweaks (namely furry shit)

#---Debug Tools (True/False)
var perfectinfo = false
var enablecheatbutton = false

#-- Use abilities on auto attack, left to right. Hint: reorder/activate abilities in the character info menu when out.
var autoattackability = false

#-- New Game Options
#Control MC and Starting Slave Purebred vs Hybrid
var player_secondaryrace = 'human' 					#In New Game -> Customized Start, control whether your MC is purebred or a hybrid.  Set to 'elf' or any other race as listed in genealogies to get a hybrid of your selected race and 'elf' or any other race set here. As of Aric's v1.7 genealogies = ['human','gnome','elf','tribal_elf','dark_elf','orc','goblin','dragonkin','dryad','arachna','lamia','fairy','harpy','seraph','demon','nereid','scylla','slime','bunny','dog','cow','cat','fox','horse','raccoon'] #ralphE
var player_secondaryracepercent = 0					#Set this between 0 and 50. Example: start New Game -> select Customized Start, select Demon for your race, set player_secondaryrace = 'taurus' and player_secondaryracepercent = 25 -> your MC will be a hybrid of 75% Demon and 25% Taurus. #ralphE
var startslave_secondaryrace = 'human' 				#Same as above, but for the Starting Slave #ralphE
var startslave_secondaryracepercent = 0				#Same as above, but for the Starting Slave #ralphE

#---Content Filters | Partially Enabled (Set to true/false)
var brutalcontent = true
var messycontent = true

#Bloody Good Taste (British the Descriptions)
var ihavebloodygoodtaste = false

#Unwanted Fetishes - Disables them from showing in the Fetish Talk menu
var unwantedfetishes = []		#Copy/Paste any you don't want into the 'unwantedfetishes' array below: ['incest','lactation','drinkmilk','bemilked','milking','exhibitionism','drinkcum','wearcum','wearcumface','creampiemouth','creampiepussy','creampieass','pregnancy','oviposition','drinkpiss','wearpiss','pissing','otherspissing','bondage','dominance','submission','sadism','masochism']

#------Player Specific Info
#Base Bonus or Penalty for Attraction Checks for MCs. Makes others like your MC more.
var playerattractionmodifier = 20

#Set to True for the Player to follow Slave's Clothing Dress/Redress System
var player_treats_clothing_like_slave = false

#------Person Expanded (True/False)
#If set to true, Unique Slaves will join your party without having to ask for consent first
var uniqueslavesautopartyconsent = false

#---Vocal Traits
#Lip Size Increase Change (Chance is array-5*10, ie: plump and bigger give 10)
var vocal_traits_autochange = true
var vocal_traits_delaytimer = true
var lipstraitbasechance = 20

#Default to Nickname + First Name (Function from MinorTweaks, Renamed for Clarity)
var use_nickname_plus_first_name = false

#Show Once Per Day Conversations Available Notifications in Inspect
var show_onceperday_notification = true

#Automated choice for captives 0 = leave, 1 = rape, 2 = kill
var capturedSelect = 2
var rescuedSelect = 0
var foundSelect = 0

#Chance enemies will be captured instead of killed when defeated
var captureChance = 100

#Price modifiers
var slavePriceMod = 1				#Multiply slave cost
var upgradeCostMod = 1				#Multiply mansion upgrade gold cost
var upgradePointsCostMod = 1		#Multiply mansion upgrade point cost
var itemCostMod = 1					#Multiply item cost (excluding food)

#Do they have to be Rebellious to refuse stripping?
var only_rebels_can_refuse_strip_rule = true

#---Vices (Formerly Flaws)
#Vices Effects (Adds Penalties and Bonuses to End of Day Luxury Calculations when enabled.)
#Turning this off disables the entire Vice system in regards to Luxury Penalties or Bonuses
var vices_luxury_effects = true

#Chance for Vices to trigger when not Discovered. Set to 0 to disable the system entirely
var vices_undiscovered_trigger_chance = 10

#Does the Vice has to present itself (via the EOD check above) before it can be discovered via Mind Reading?
var vices_discovery_has_to_present_first = false

#Base Chance added to Vice Discovery in Mind Reading if it presented itself in an End of Day before
var vices_discovery_presentation_bonus = 20

#---Genitals Expanded
#Disable Tearing System
var disablevaginatearing = false
var disableanaltearing = false

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

#Warn on Missing Researcher
var show_warning_if_missing_researcher = true


#------Pregnancy Expanded
#Set to False to disable Swollen Settings (Pregnancy and Cum Inflation)
var swollenenabled = true
var wantedpregnancychance = 50

#Chance to Puke
var chancemorningsickness = 30

#Chance to Increase Tits
var chancetitsgrow = 35


#------Lactation Expanded
var lactationstops = false
var leakcauseslactationchance = 50

#Turn off to disable Lactation Stress
var lactationstressenabled = true

#Increase/Decrease Milk Storage to Pressure
var lacation_pressurepermilkstored = .25

#------Farm Expanded
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
#FetishDifficulty is what Fetish*10 is multiplied by for the Chance of Success
var fetishdifficulty = 2

#Base Fetish Increase Chance
var fetish_base_increase_chance = 20

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
var minimum_npcs_to_detain = 50
var townguardefficiency = 15

#Laws: Public Nudity Bonus and Penalty
var enable_public_nudity_system = true

#NPC Town Guard Execution Chance
var randomexecutions = 25


#---Races Expanded
#Aric's Tweaks for Deviates Additions
var racialstatbonuses = true


#---Genealogy
var genealogy_equalizer = 10
var randompurebreedchance = 20					# Ralph's - 10
var randommixedbreedchance = 40					# Ralph's - 20
var randompurebreedchanceuncommon = -1			# Ralph's - 60
var secondaryhumanoidracialchance = 75
var secondaryuncommonracialchance = 15			# Ralph's - 0
var secondarybeastracialchance = 25

#Ovulation Chances
var ovulationenabled = true
var multipleBabyChance = 25 # chance to add another baby to pregnancy

#These Cycles are dependant on the Birth Type
var livebirthcycle = 14
var eggcycle = 14

#Percentage of the time fertile
var fertileduringcycle = 0.6
var semenlifespan = 5

#--- Ralph's Tweaks
#Mage Specialization Manacost Reduction
var mage_mana_reduction = true
												# Ralph's - [false, "Combat spell deal 20% more damage"]

#Spellcost Changes
var spellcost = 1 								# Ralph's - 2, This is a multiplicative that applies to all spellcosts.

#Spell Tweak Effects
var reduce_rebellion_with_fear = 1				# Ralph's - 3, This divides by the players magic affinity to determine how much rebellion is reduced.
var summontentacle_lewdness = 5					# Ralph's - 5, Make... them... lewd...

#Reputation Tweak
var reputation_loss = -4						# Ralph's - -18, How much your reputation suffers when you sell a bad slave to Sebastian.

#Food Tweak Effects
var food_experience = 2							# Ralph's = 1, How much experience a slave earns from cooking, equal to the amount of slaves the player owns multiplied by this number.

var func_forage_tweaks = [4,20,25,1.2,5]		
												# Ralph's - [3,2,5,1.5,2]
												# In order: represents how much base food is divided, 
												# how much additional food is multipled in min(food, max(person.sstr+person.send, -1)*[this number]+5), 
												# how much additional food is added in min(food, max(person.sstr+person.send, -1)*2+[this number]),
												# how much being a ranger multiplies the food gained,
												# and how much experience is gained by dividing by the amount of food gained total.

var func_hunt_tweaks = [2,5,10,1.3,1.25,30,40,7]
												# Ralph's - [1,3,8,1.4,1.5,3,5,3]
												# In order: represents the minimum random range that a person can obtain base food,
												# the minimum random range a person can obtain food multiplied by endurance,
												# the maximum random range a person can obtain food multiplied by endurance,
												# how much food is multiplied by being an Arachna,
												# how much food is multiplied by being a ranger or trapper,
												# how much additional food is multiplied in round(min(food, max(person.sstr+person.send, -1)*[this number]+5))
												# how much additional food is added in round(min(food, max(person.sstr+person.send, -1)*3+[this number]))
												# and how much experience is gained by dividing the amount of food gained total.

#Start Slave Hobby Changes
var magic_hobby_maf_max = 2						# Ralph's - 1, The value responsible for how much the maximum magic affinity a starter slave with the magic hobby has. #ralphE

#Sell Slave Prices
var mansion_bred_and_breeder = 2				# Ralph's - 1.5, The multiplicative value that modifies the price.
var calculate_price_bonus_divide = 1			# Ralph's - 2, The divider value that modifies the bonus value that multiplies the price when calculating.
var quicksell_slave_pressed = 0.5				# Ralph's - 0.9, The multiplier value that affects the sellprice of a slave when quicksell is pressed. (Ralph tweaked so you only get docked 10% when you quicksell vs 50% deduction in vanilla) #ralphC

#Capture Changes
var times_rescued_multiplier = 0				# Ralph's - 10, The multiplicative value that is used with how many times an npc has been rescued when determining whether they will join you willingly after saving them from bandits.

#Random Awareness
var random_enemy_awareness = [0,0]				# Ralph's - [-7,7], This value applies a random awareness negative or positive to determine whether you are ambushed or not. [0,0] means no change.

#Constructor Changes
var same_type_weight = 2						# Ralph's - 4, The divider value that divides the genealogy of the person's temporary race to determine the sametypeweight used in the constructor.
	

#Ralph's tweaks partial settings, true is default for all settings
var ralphs_tweaks_partial = {
	disable_mage_mana_reduction = true,
	increase_spell_cost = true,
	tweak_spell_costs = true,
	increase_black_market_reputation_loss = true,
	reduce_breeder_profit = true,
	reduce_slave_price_bonus = true,
	randomize_travel_awareness = true,
	increase_food_cost = true,
	clear_player_racial_bonus = true,
	tweak_invigorate = true,
	restrict_convert_to_upgrade_point = true,
}

"""
Applies Ralph's tweaks to the game, making it a slightly more challenging experience.
Feel free to change as you see fit!
"""
func applyRalphsTweaks():
	applyVariableTweaks()

	if ralphs_tweaks_partial.disable_mage_mana_reduction:
		mage_mana_reduction = false
		globals.expandedplayerspecs.Mage = "Combat spell deal +20% more damage"

	# Ralph likes his increased mana costs
	if ralphs_tweaks_partial.increase_spell_cost:
		spellcost = 2

	applySpellManacostTweaks()

	#Spell Tweak Effects
	reduce_rebellion_with_fear = 3
	summontentacle_lewdness = 5

	#Reputation Tweak
	if ralphs_tweaks_partial.increase_black_market_reputation_loss:
		reputation_loss = -18

	#Food Tweak Effects
	food_experience = 1
	
	applyItemMarketCostTweaks()
	
	func_forage_tweaks = [3,2,5,1.5,2]

	func_hunt_tweaks = [1,3,8,1.4,1.5,3,5,3]

	#Start Slave Hobby Changes
	magic_hobby_maf_max = 1
	
	#Sell Slave Prices
	if ralphs_tweaks_partial.reduce_breeder_profit:
		mansion_bred_and_breeder = 1.5
		globals.expandedplayerspecs.Breeder = "Pregnancy chance for everyone increased by 25%\nHalved grow-up times for offspring\nBred Slaves sell for +20% more gold and provide 20% more upgrade points as normal slaves.\n[color=aqua]Start with the Nursery unlocked[/color]"
	if ralphs_tweaks_partial.reduce_slave_price_bonus:
		calculate_price_bonus_divide = 2
	quicksell_slave_pressed = 1.11
	
	#Capture Changes
	times_rescued_multiplier = 10
	
	#Random Awareness
	if ralphs_tweaks_partial.randomize_travel_awareness:
		random_enemy_awareness = [-7,7]	
	
	#Genealogy Changes
	randompurebreedchance = 10
	randommixedbreedchance = 30
	randompurebreedchanceuncommon = 60
	secondaryuncommonracialchance = 0
	
	#Constructor Changes
	same_type_weight = 4
	
	applyConstructorTweaks()
	
	applyCombatDataTweaks()
	
	applyRaceTweaks()

# Apply variables.gd changes here
func applyVariableTweaks():
	#Levelling Changes
	variables.skillpointsperlevel = 1.0				# Original - 2.0

	#Baby Stuff
	variables.growuptimechild = 1.0					# Original - 2.0, How long it takes a baby to become said thing.
	variables.growuptimeteen = 2.0					# Original - 4.0
	variables.growuptimeadult = 3.0					# Original - 6.0
	variables.babynewtraitchance = 33.0				# Original - 20.0, Chance a baby will gain an entirely new trait.

# Apply Manacost Tweaks here
func applySpellManacostTweaks():
	if !ralphs_tweaks_partial.tweak_spell_costs:
		return
	globals.spelldict.mindread.manacost = 1			# Original - globals.spelldict.mindread.manacost = 3
	globals.spelldict.sedation.manacost = 20		# Original - globals.spelldict.sedation.manacost = 10
	globals.spelldict.dream.manacost = 5			# Original - globals.spelldict.dream.manacost = 20
	globals.spelldict.entrancement.manacost = 10	# Original - globals.spelldict.entrancement.manacost = 15
	globals.spelldict.fear.manacost = 20			# Original - globals.spelldict.fear.manacost = 10
	globals.spelldict.mutate.manacost = 10			# Original - globals.spelldict.mutate.manacost = 15
	globals.spelldict.invigorate.manacost = 20		# Original - globals.spelldict.invigorate.manacost = 5
	globals.spelldict.summontentacle.manacost = 20	# Original - globals.spelldict.summontentacle.manacost = 35

# Apply Market Item Tweaks here
func applyItemMarketCostTweaks():
	if ralphs_tweaks_partial.increase_food_cost:
		globals.itemdict.food.cost = 40					# Original - 10

# Apply Constructor Changes here.
func applyConstructorTweaks():
	globals.constructor.humanoid_races_array = ['Human','Elf','Dark Elf','Tribal Elf','Orc','Ogre','Giant','Gnome','Goblin','Kobold','Demon']			# Original - ['Human','Elf','Dark Elf','Tribal Elf','Orc','Ogre','Giant','Gnome','Goblin','Kobold','Demon','Dragonkin']
	globals.constructor.uncommon_races_array = ['Dragonkin','Fairy','Seraph','Dryad','Lamia','Harpy','Arachna','Nereid','Scylla','Lizardfolk','Avali']	# Original - ['Fairy','Seraph','Dryad','Lamia','Harpy','Arachna','Nereid','Scylla','Lizardfolk','Avali']

# Apply Combat Data Tweaks here
func applyCombatDataTweaks():
	globals.combatdata.enemygrouppools.monstergirl.awareness = 15	# Original - -10

# Apply Race Tweaks here.
func applyRaceTweaks():
	#Human
	globals.races.Human.description = "Humans are a highly successful militaristic people whose members can be found throughout much of the world, their presence often receiving a mixed reception. Slavery is a common part of human society, viewed as a civilized form of alternative punishment, with many laws and businesses based around the concept. Because of this slave driven culture, you have found that humans tend to be the most widely accessible residents, servants, and slaves.\n\n"
	globals.races.Human.stats = {str_max = 3, agi_max = 3, maf_max = 3, end_max = 3}
	
	#Elf
	globals.races.Elf.stats = {str_max = 2, agi_max = 5, maf_max = 4, end_max = 2}
	
	#Tribal Elf
	globals.races["Tribal Elf"].description = "Elves are famous among the various races for the legends and stories of ancient times, when elves held a similar status to modern humans. These tales speak of elves as arrogant, and in command of powerful nature magic, but ultimately spelling their own downfall in some great act of folly.\n\nTribal elves are rumored to have separated split from their elven cousins long ago and generally live in warmer regions.\n\nBreeding Note:\nElves in general owe some of their amazing finesse and grace of movement to their fine bone structure in addition to a simple advantage of reflex. Compared to other elves, tribal elves make for mediocre spell casters, but tribal elves that inherit bloodlines infused with fire, wind, or nature magic can harness this power more directly provided another race acts as a catalyst."
	globals.races["Tribal Elf"].stats = {str_max = 3, agi_max = 5, maf_max = 3, end_max = 2}

	#Dark Elf
	globals.races["Dark Elf"].stats = {str_max = 2, agi_max = 5, maf_max = 5, end_max = 2}
	
	#Orc
	globals.races.Orc.stats = {str_max = 6, agi_max = 2, maf_max = 1, end_max = 4}

	#Gnome
	globals.races.Gnome.startingrace = true
	globals.races.Gnome.stats = {str_max = 2, agi_max = 3, maf_max = 5, end_max = 3}
	
	#Goblin
	globals.races.Goblin.description = "Goblins are a race of cave dwellers, loosely resembling short, green-skinned elves. They have existed for a very long time, but despite their prevalence rarely played any influential role. While they have often been considered nothing more than common monsters, they have surprising skill and understanding, putting them on par with many humanoid races in term of sentience and physical capability despite their stature."
	globals.races.Goblin.startingrace = false
	globals.races.Goblin.stats = {str_max = 3, agi_max = 4, maf_max = 3, end_max = 3}
	
	#Fairy
	globals.races.Fairy.stats = {str_max = 1, agi_max = 5, maf_max = 6, end_max = 1}
	
	#Seraph
	globals.races.Seraph.description = "Seraphs were named because of their similarity in appearance to angels, the winged servants of divinity spoken of in myth. The reclusiveness of seraphs has led to a lack of research, but common theories are that they are a subspecies of harpy, an artificial race created accidentally many generations ago, or the descendants of an alien race that migrated from somewhere within the outer planes.\n\nSimilar to demons, seraphs seem to exhibit many behavioral traits in line with their mythic counterparts, such as a prudish nature and a slight inclination towards public service, though it’s unknown if these traits are universal, or if they come down to an individual basis."
	globals.races.Seraph.startingrace = false
	globals.races.Seraph.stats = {str_max = 3, agi_max = 3, maf_max = 5, end_max = 3}
	
	#Demon
	globals.races.Demon.description = "Though they share a name and certain physical traits, modern demons bear mostly superficial resemblance to their ancient counterparts, who were driven into the great depths of the underground, and even into other dimensions. It is speculated that modern demons are either the offspring of humans and actual monsters, the byproduct of extensive magical corruption similar to gnomes, or as more recent research suggests the descendants of an entirely separate race that migrated from the outer planes.\n\nThough demons are often feared and reviled, those with outstanding talent or skill often receive recognition for their abilities, so it is not entirely uncommon to see demons among the elite, or in high profile positions."
	globals.races.Demon.stats = {str_max = 3, agi_max = 4, maf_max = 4, end_max = 3}
	
	#Dryad
	globals.races.Dryad.stats = {str_max = 3, agi_max = 1, maf_max = 4, end_max = 5}
	
	#Dragonkin
	globals.races.Dragonkin.stats = {str_max = 4, agi_max = 3, maf_max = 3, end_max = 6}
	
	#Taurus
	globals.races.Taurus.description = "Taurus are a purely artificial race, created on the orders of a group of noblemen looking for bodyguards. The experiment seems to have been an attempt at recreating the size and strength of orcs and beastkin in a more easily controlled package, but was ultimately considered only partially successful, as the new species had a tendency of taking too many bovine behavioral traits, becoming too passive, or in some cases, too aggressive.\n\nStill, they, especially the females, remain popular among certain individuals for their appearance and outstanding natural lactation."
	globals.races.Taurus.stats = {str_max = 4, agi_max = 2, maf_max = 1, end_max = 6}
	
	#Slime
	globals.races.Slime.stats = {str_max = 4, agi_max = 4, maf_max = 4, end_max = 4}
	
	#Lamia
	globals.races.Lamia.stats = {str_max = 3, agi_max = 4, maf_max = 4, end_max = 3}
	
	#Harpy
	globals.races.Harpy.stats = {str_max = 3, agi_max = 6, maf_max = 2, end_max = 2}
	
	#Arachna
	globals.races.Arachna.stats = {str_max = 4, agi_max = 5, maf_max = 2, end_max = 4}
	
	#Centaur
	globals.races.Centaur.stats = {str_max = 6, agi_max = 3, maf_max = 1, end_max = 4, energy_max = 140}
	
	#Nereid
	globals.races.Nereid.stats = {str_max = 3, agi_max = 3, maf_max = 5, end_max = 3}
	
	#Scylla
	globals.races.Scylla.description = "Scylla are rather unusual in appearance, possessing a number of tentacle-like appendages they use in the place of legs. They generally prefer damp and aquatic regions. In general, their behavior is not much different from lamia. Their appearance is extremely rare, to the point of being treated as mere myth or drunken fancy by some."
	globals.races.Scylla.stats = {str_max = 4, agi_max = 3, maf_max = 5, end_max = 3}
	
	#Beastkin Cat
	globals.races["Beastkin Cat"].stats = {str_max = 3, agi_max = 5, maf_max = 2, end_max = 3}
	
	#Beastkin Fox
	globals.races["Beastkin Fox"].stats = {str_max = 2, agi_max = 4, maf_max = 6, end_max = 2}
	
	#Beastkin Wolf
	globals.races["Beastkin Wolf"].stats = {str_max = 5, agi_max = 5, maf_max = 1, end_max = 3}
	
	#Beastkin Bunny
	globals.races["Beastkin Bunny"].startingrace = true
	globals.races["Beastkin Bunny"].stats = {str_max = 2, agi_max = 6, maf_max = 2, end_max = 3}
	
	#Beastkin Tanuki
	globals.races["Beastkin Tanuki"].stats = {str_max = 3, agi_max = 3, maf_max = 5, end_max = 3}
	
	#Gnoll
	globals.races["Gnoll"].stats = {str_max = 5, agi_max = 4, maf_max = 2, end_max = 5}

	#Ogre
	globals.races["Ogre"].stats = {str_max = 7, agi_max = 2, maf_max = 1, end_max = 7}

	#Giant
	globals.races["Giant"].stats = {str_max = 9, agi_max = 2, maf_max = 3, end_max = 5}

	#Lizardfolk
	globals.races["Lizardfolk"].stats = {str_max = 5, agi_max = 4, maf_max = 3, end_max = 5}

	#Kobold
	globals.races["Kobold"].stats = {str_max = 2, agi_max = 6, maf_max = 3, end_max = 5}

	#Avali
	globals.races["Avali"].stats = {str_max = 1, agi_max = 8, maf_max = 8, end_max = 3}

	#Beastkin Mouse
	globals.races["Beastkin Mouse"].stats = {str_max = 2, agi_max = 6, maf_max = 5, end_max = 2}

	#Beastkin Squirrel
	globals.races["Beastkin Squirrel"].stats = {str_max = 3, agi_max = 5, maf_max = 3, end_max = 5}

	#Beastkin Otter
	globals.races["Beastkin Otter"].stats = {str_max = 4, agi_max = 4, maf_max = 2, end_max = 6}

	#Beastkin Bird
	globals.races["Beastkin Bird"].stats = {str_max = 2, agi_max = 5, maf_max = 3, end_max = 6}


"""
Applies Capitulize's tweaks to the game, mostly description and furry based changes.
"""
func applyCapitulizeTweaks():
	#--- Race Changes
	#Dragonkin
	globals.races.Dragonkin.skin = ['none']
	globals.races.Dragonkin.eyeshape = ['slit']
	globals.races.Dragonkin.bodyshape = ['reptilian']
	globals.races.Dragonkin.ears = ['short_reptilian','pointy', 'frilled','none','long_round_reptilian','long_droopy_reptilian','long_pointy_reptilian']
	globals.races.Dragonkin.skincov = ['fullscales']
	globals.races.Dragonkin.surname = globals.names.reptiliansurname
	
	#---Trait Tweaks
	
	#Strength
	globals.origins.traitlist["Weak"].description = "$name is rather weak compared to others. \n\n[color=aqua]Strength -2, Strength Max -2[/color]"
	globals.origins.traitlist["Weak"].effect.str_max = -2
	globals.origins.traitlist["Strong"].description = "$name has been blessed with greater strength than most. $He also appears to be harder to tame. \n\n[color=aqua]Strength +2, Strength Max +2, Obedience growth -20%[/color]"
	globals.origins.traitlist["Strong"].effect.str_max = 2
	#Agility
	globals.origins.traitlist["Clumsy"].description = "$name's reflexes are somewhat slower, than the others. \n\n[color=aqua]Agility -2, Agility Max -2, physical occupations are less effective[/color]"
	globals.origins.traitlist["Clumsy"].effect.agi_max = -2
	globals.origins.traitlist["Quick"].description = "$name is very active whenever $he does something. However, it also makes $his nervous system less stable. \n\n[color=aqua]Agility +2, Agility Max +2, Stress change +20%[/color]"
	globals.origins.traitlist["Quick"].effect.agi_max = 2
	#Magic Affinity
	globals.origins.traitlist["Magic Deaf"].description = "$name's senses are very dull when it comes to magic. \n\n[color=aqua]Magic Affinity -2, Magic Affinity Max -2[/color]"
	globals.origins.traitlist["Magic Deaf"].effect.maf_max = -2
	globals.origins.traitlist["Responsive"].description = "$name is in touch with raw energy, making $him potentially useful in magic area. \n\n[color=aqua]Magic Affinity +2, Magic Affinity Max +2, Toxicity change +20%[/color]"
	globals.origins.traitlist["Responsive"].effect.maf_max = 2
	#Endurance
	globals.origins.traitlist["Frail"].description = "$name's body is much less durable than most. $His physical potential is severely impaired. \n\n[color=aqua]Endurance -2, Endurance Max -2,[/color]"
	globals.origins.traitlist["Frail"].effect.end_max = -2
	globals.origins.traitlist["Robust"].description = "$name's physique is way better than most. \n\n[color=aqua]Endurance +2, Endurance Max +2, Fear change -20%[/color]"
	globals.origins.traitlist["Robust"].effect.end_max = 2

	#---Variable Tweaks
	
	variables.banditishumanchance = 25.0				# Original - 70.0
	
func addConstantsSupport():
	variables.list["Aric's Expansion Mod"] = {
		autoattackability = {descript = "Use abilities on auto attack, left to right. Hint: reorder/activate abilities in the character info menu when out.", object = self},
		brutalcontent = {descript = "Content Filter, set this to false if you don't want to see extreme violent content, like executions", object = self},
		ihavebloodygoodtaste = {descript = "Set this to true to include British themed descriptions", object = self},
		vices_luxury_effects = {descript = "Vice Effects (Adds Penalties and Bonuses to End of Day Luxury Calculations", object = self},
		uniqueslavesautopartyconsent = {descript = "If set to true, Unique Slaves will join your party without having to ask for consent first", object = self},
		vocal_traits_autochange = {descript = "Enable or Disable the Vocal Traits system (allowing Lisp or Mute to be added or removed based on Lip sizes).", object = self},
		vocal_traits_delaytimer = {descript = "Enable or Disable the Vocal Traits Delay Timer (Sets a minimum of 1-7 days between automatic changes).", object = self},
		lipstraitbasechance = {descript = "Lip Size Increase Change (Chance is array-5*10, ie: plump and bigger give 10)", min = 0.0, max = 50.0, object = self},
		playerattractionmodifier = {descript = "Base Bonus or Penalty for Attraction Checks for PCs", min = -100.0, max = 100.0, object = self},
		use_nickname_plus_first_name = {descript = "Default to Nickname + First Name (Function from MinorTweaks, Renamed for Clarity)", object = self},
		show_onceperday_notification = {descript = "Show Once Per Day Conversations Available Notifications in Inspect", object = self},
		lactationstops = {descript = "Set this to true if you want lactation to stop after a while", object = self},
		leakcauseslactationchance = {descript = "Chance that the Leak spell causes lactation", min = 0.0, max = 100.0, object = self},
		lactationstressenabled = {descript = "Set this to true if you want lactation to cause stress", object = self},
		enable_public_nudity_system = {descript = "Laws: Public Nudity Bonus and Penalty", object = self},
		randomexecutions = {descript = "NPC Town Guard Execution Chance", min = 0.0, max = 100.0, object = self},
		racialstatbonuses = {descript = "Set this to false to remove racial stat bonuses from new or existing persons", object = self},
		show_facilities_details_in_mansion = {descript = "Set this to false to hide the new facilities on the mansion info panel", object = self},
		perfectinfo = {descript = "Debug Tool, set this to true to expose calculations and data that may sometimes be hidden", object = self},
		enablecheatbutton = {descript = "Debug Tool, set this to true to enable a mod specific cheat menu.", object = self},
	}
	variables.list["AE Mod - Sexual"] = {
		stretchchancevagina = {descript = "Chance of Holes staying Stretched during Sex. Chance + (Elasticity*10)", min = 0.0, max = 100.0, object = self},
		stretchchanceanus = {descript = "Chance of Holes staying Stretched during Sex. Chance + (Elasticity*10)", min = 0.0, max = 100.0, object = self},
		tornvagautorecovery = {descript = "These chances (times the person's elasticity 1-5) occur during sex. 0-20 Max", min = 0.0, max = 100.0, object = self},
		tornassautorecovery = {descript = "These chances (times the person's elasticity 1-5) occur during sex. 0-20 Max", min = 0.0, max = 100.0, object = self},
		vaginaltightenchance = {descript = "The Tighten Chances are multiplied by their Age (inversely), ie: Adults=*1, Teens=*2", min = 0.0, max = 100.0, object = self},
		analtightenchance = {descript = "The Tighten Chances are multiplied by their Age (inversely), ie: Adults=*1, Teens=*2", min = 0.0, max = 100.0, object = self},
		vaginalwetnesstraitchance = {descript = "Chance of gaining Vaginal Wetness trait", min = 0.0, max = 100.0, object = self},
		baseholecapacity = {descript = "The average capacity that the hole's size adds or subtracts from", min = 0.0, max = 100.0, object = self},
		player_sexuality_shift = {descript = "Can the Player's sexuality shift (from what is picked at Character Creation)?", object = self},
		fetishdifficulty = {descript = "FetishDifficulty is what Fetish*10 is multiplied by for the Chance of Success", min = 0.1, max = 10.0, object = self},
		fetishescanlower = {descript = "Fetishes can Lower", object = self},
		lactationacceptancemultiplier = {descript = "Fetish Acceptance Multipliers", min = 0.1, max = 10.0, object = self},
		beingmilkedacceptancemultiplier = {descript = "Fetish Acceptance Multipliers", min = 0.1, max = 10.0, object = self},
	}
	variables.list["AE Mod - Pregnancy"] = {
		ovulationenabled = {descript = "Set this to false if you want pregnancy to be possible every day", object = self},
		multipleBabyChance = {descript = "chance to add another baby to pregnancy", min = 0.0, max = 100.0, object = self},
		livebirthcycle = {descript = "Duration in days of live birth ovulation cycle", min = 1.0, max = 100.0, object = self},
		eggcycle = {descript = "Duration in days of egg laying ovulation cycle", min = 1.0, max = 100.0, object = self},
		fertileduringcycle = {descript = "Percentage of the ovulation cycle the person is fertile", min = 0.0, max = 1.0, object = self},
		semenlifespan = {descript = "The base number of days semen exists in the womb", min = 1.0, max = 100.0, object = self},
		wantedpregnancychance = {descript = "", min = 0.0, max = 100.0, object = self},
		chancemorningsickness = {descript = "Max chance to puke during pregnancy, peaks at start", min = 0.0, max = 100.0, object = self},
		chancetitsgrow = {descript = "Max chance for tits to increase in size during pregnancy, peaks towards end", min = 0.0, max = 100.0, object = self},
	}
	variables.list["AE Mod - Farm"] = {
		baselivestockconsentchance = {descript = "Livestock Consent Base Chance (+ 50% loyalty, 25% obediance, + various factors)", min = 0.0, max = 100.0, object = self},
		chancetokillsnail = {descript = "", min = 0.0, max = 100.0, object = self},
		snailegglaborbadresult = {descript = "", object = self},
		snailegglabordetails = {descript = "Set this to false if you don't wamt to see the details", object = self},
		livestockautoconsentchance = {descript = "", min = 0.0, max = 100.0, object = self},
		livestockcanloseconsent = {descript = "", min = 0.0, max = 100.0, object = self},
		livestockloseconsentchance = {descript = "", min = 0.0, max = 100.0, object = self},
	}
	variables.list["AE Mod - Ralph's Tweaks"]  = {
		use_ralphs_tweaks = {descript = "REQUIRES RESTART! Set this to true if you want to use the settings within ApplyTweaks as well as the Hybrid system.", object = self},
		ralphs_tweaks_partial = {descript = "REQUIRES RESTART! Set values to false to disable parts of Ralph's tweaks", object = self},
		unique_trait_generation = {descript = "Set this to true if you want a 1 in 5 chance for babies to gain unique traits such as sturdy.", object = self},
		consolidatebeastDNA = {descript = "Set this to true if you don't like npcs with a mix of Beastkin/Halfkin race%'s (no half cat half foxes, etc.)", object = self},
		gratitude_for_all = {descript = "Set this to true so that babies aged up to Child or Teen have as much chance to spawn with the Grateful trait as ones aged up to Adult (Ralph sets this to False, but up to you)", object = self},
		sillymode = {descript = "Set it to false if you don't abide, so far it only affects random travel event text", object = self},

		basemanafoodconsumption = {descript = "The amount of mana per day required by mana eating races/hybrids. This is multiplied for some based on age, etc. Default: 10", min = 0.0, max = 100.0},
		orgasmmana = {descript = "The amount of mana produced by a single orgasm. Default: 3", min = 1.0, max = 100.0},
	}
	
