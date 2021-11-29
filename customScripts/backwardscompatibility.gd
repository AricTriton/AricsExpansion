### <CustomFile> ###

#Functions that should only one once per Mod Version Update to update features
func backwardsCompatibility(person):

	#Restrained Boolean to String
	if typeof(person.restrained) == TYPE_BOOL:
		person.restrained = "none"

	if !person.npcexpanded.has('mansionbred'):
		person.npcexpanded['mansionbred'] = false

	#Pregnancy Expanded
	person.pregexp.desiredoffspring = round(person.pregexp.desiredoffspring)

	if !person.pregexp.has('gestationspeed'):
		person.pregexp['gestationspeed'] = 1
	if !person.pregexp.has('babysize'):
		person.pregexp['babysize'] = 0
	if !person.pregexp.has('titssizebonus'):
		person.pregexp['titssizebonus'] = 0
	if !person.pregexp.has('incestbaby'):
		person.pregexp['incestbaby'] = false

	#Lactating Expanded
	if !person.lactating.has('milkedtoday'):
		person.lactating['milkedtoday'] = false
	if !person.lactating.has('milkmax'):
		person.lactating['milkmax'] = 0
	if !person.lactating.has('milkstorage'):
		person.lactating['milkstorage'] = 0
	if !person.lactating.has('pressure'):
		person.lactating['pressure'] = 0
	if !person.lactating.has('daysunmilked'):
		person.lactating['daysunmilked'] = 0

	#Sex Expanded
	if !person.sexexpanded.has('pressure'):
		person.sexexpanded['pressure'] = 0

	#Personalities Expanded
	if !person.mind.has('accepted'):
		person.mind['accepted'] = []
	if !person.mind.has('secrets'):
		person.mind['secrets'] = []
	if !person.mind.has('secretslog'):
		person.mind['secretslog'] = ""
	if !person.mind.has('willpower'):
		person.mind['willpower'] = 100

	#---v09
	#Add Slime Pliability/Elasticity
	if person.race.find('Slime') >= 0:
		person.sexexpanded.pliability = 5
		person.sexexpanded.elasticity = 5

	if !person.sexexpanded.has('sexualitylocked'):
		person.sexexpanded['sexualitylocked'] = false

	#Farm Expanded
	if !person.farmexpanded.has('container'):
		person.farmexpanded['container'] = 'default'

	if !person.farmexpanded.has('timesmilked'):
		person.farmexpanded['timesmilked'] = 0
	if !person.farmexpanded.has('resistance'):
		person.farmexpanded['resistance'] = -1	
	if !person.farmexpanded.has('stallbedding'):
		person.farmexpanded['stallbedding'] = 'dirt'
	if !person.farmexpanded.has('workstation'):
		person.farmexpanded['workstation'] = 'free'
	if !person.farmexpanded.has('restrained'):
		person.farmexpanded['restrained'] = false
	if !person.farmexpanded.has('dailyaction'):
		person.farmexpanded['dailyaction'] = 'none'
	if !person.farmexpanded.has('giveaphrodisiac'):
		person.farmexpanded['giveaphrodisiac'] = false
	if !person.farmexpanded.has('aphrodisiac'):
		person.farmexpanded['aphrodisiac'] = 0
	if !person.farmexpanded.has('breeding'):
		person.farmexpanded['breeding'] = {status = 'none', partner = -1, forced = false, snails = false, eggsbirthed = 0}
	if !person.farmexpanded.has('extractmilk'):
		person.farmexpanded['extractmilk'] = {enabled = false, restrained = false, method = 'leak', container = 'cup', sessions = 0, totalextracted = 0, resistance = -1, opinion = [], fate = "undecided"}
	if !person.farmexpanded.has('extractcum'):
		person.farmexpanded['extractcum'] = {enabled = false, restrained = false, method = 'leak', container = 'cup', sessions = 0, totalextracted = 0, resistance = -1, opinion = [], fate = "undecided"}
	if !person.farmexpanded.has('extractpiss'):
		person.farmexpanded['extractpiss'] = {enabled = false, restrained = false, method = 'leak', container = 'cup', sessions = 0, totalextracted = 0, resistance = -1, opinion = [], fate = "undecided"}

	var extractions = ['extractmilk','extractcum','extractpiss']
	for i in extractions:
		if person.farmexpanded[i].resistance == -1:
			person.farmexpanded[i].resistance = round(rand_range(person.dignity * 0.25 , person.dignity * 1))
	
	if !person.npcexpanded.has('restrained'):
		person.npcexpanded['restrained'] = []
	if !person.npcexpanded.has('contentment'):
		person.npcexpanded['contentment'] = 0

	if !person.lactating.has('hyperlactation'):
		person.lactating['hyperlactation'] = false

	#Jobs Expanded
	if !person.jobskills.has('milking'):
		person.jobskills['milking'] = 0

	#Bodies Expanded
	if person.vagina != "none" && person.lubrication == -1:
		person.lubrication = round(rand_range(1,4))
	if !person.npcexpanded.has('body'):
		person.npcexpanded['body'] = {penis = {traits = []}, vagina = {traits = [], inside = [], pliability = 0, elasticity = 0}, asshole = {traits = [], inside = [], pliability = 0, elasticity = 0},}

	if !person.consentexp.has('livestock'):
		person.consentexp['livestock'] = false
	
	versionv0_9_5(person)
	
	#v0.9.6
	if !person.npcexpanded.has('racialbonusesapplied'):
		person.npcexpanded['racialbonusesapplied'] = false
	if !person.stats.has('cour_racial'):
		person.stats['cour_racial'] = 0
	if !person.stats.has('conf_racial'):
		person.stats['conf_racial'] = 0
	if !person.stats.has('wit_racial'):
		person.stats['wit_racial'] = 0
	if !person.stats.has('charm_racial'):
		person.stats['charm_racial'] = 0
	
	#v0.9.7
	#Job Skills
	for i in ['trainer','trainee','sexworker','entertainer','pet','combat']:
		if !person.jobskills.has(i):
			person.jobskills[i] = 0
	
	#Movement Icon Change from Traits
	for i in ['Movement: Walking','Movement: Flying','Movement: Crawling','Movement: Immobilized']:
		if person.traits.has(i):
			person.trait_remove(i)
	
	#v0.9.8
	for i in ['temptraits','onlyonce']:
		if !person.npcexpanded.has(i):
			person.npcexpanded[i] = []
	
	#v1.1
#	versionv1_1(person)
	
	#Only Activate if mandatory for Compatibility
#	if person.expansionversion < 1.1:
#		babyTermination(person)
	
	person.expansionversion = globals.expansionsettings.modversion

func unique_Fullblooded(person):
	if person.unique != '' && !person.race.find('Halfkin') >= 0:
		globals.constructor.forceFullblooded(person)
	return

func versionv0_9_5(person):
	
	if !person.metrics.has('animalpartners'):
		person.metrics['animalpartners'] = 0
	
	if !person.preg.has('bonus_fertility'):
		person.preg['bonus_fertility'] = 0
	if !person.preg.has('is_preg'):
		person.preg['is_preg'] = false
	if !person.preg.has('baby_type'):
		person.preg['baby_type'] = 'birth'
	if !person.preg.has('ovulation_type'):
		person.preg['ovulation_type'] = 0
	if !person.preg.has('ovulation_stage'):
		person.preg['ovulation_stage'] = 0
	if !person.preg.has('ovulation_day'):
		person.preg['ovulation_day'] = 0
#	if !person.preg.has('baby_count'):
#		person.preg['baby_count'] = 0
	if !person.preg.has('womb'):
		person.preg['womb'] = []
	if !person.preg.has('offspring_count'):
		person.preg['offspring_count'] = 0
	if !person.preg.has('unborn_baby'):
		person.preg['unborn_baby'] = []
	
	return

func babyTermination(person):
	#Terminate Babies (for compatibility)	
	if person.preg.baby != null:
		print(person.name + " sacrificed their baby for the good of the mod update")
		person.preg.baby = null
		person.preg.duration = 0
	return