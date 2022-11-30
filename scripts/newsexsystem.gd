var analcategories = ['assfingering','rimjob','missionaryanal','doggyanal','lotusanal','revlotusanal','doubledildoass','inerttaila','analvibrator','enemaplug','insertinturnsass','cowgirlanal','reversecowgirlanal','doublepen','triplepen']
var penetratecategories = ['missionary','missionaryanal','doggy','doggyanal','lotus','lotusanal','revlotus','revlotusanal','doubledildo','doubledildoass','inserttailv','inserttaila','tribadism','frottage','cowgirl','reversecowgirl','doublepen','triplepen','deepthroat']
var takercategories = ['cunnilingus','rimjob','handjob','titjob','tailjob','blowjob','footjob'] #ralphC - added footjob

var succubuscounter = 0 #ralphC - count orgasms drained by succubi

class member:
	var name
	var person
	var mood
	var submission
	var loyalty
	var lust = 0 setget lust_set
	var sens = 0 setget sens_set
	var sensmod = 1.0
	var lube = 0
	var pain = 0
	var role
	var sex
	var orgasms = 0
	var lastaction
	var request
	var requestsdone = 0

	var number = 0
	var sceneref

	var svagina = 0
	var smouth = 0
	var sclit = 0
	var sbreast = 0
	var spenis = 0
	var sanus = 0
	var lewd
	var activeactions = []

	var orgasm = false
	var virginitytaken = false

	var effects = []
	var isHandCuffed = false
	var subduedby = []
	var subduing

	var energy = 100


	var vagina
	var penis
	var balls
	var clit
	var breast
	var feet
	var acc1
	var acc2
	var acc3
	var acc4
	var acc5
	var acc6
	var mouth
	var anus
	var tail
	var strapon
	var nipples
	var posh1
	var mode = 'normal'
	var limbs = true
	var consent = true
	var npc = false

	###---Added by Expansion---###
	var sexuality
	var sexualityshift = 0
	var vaginasize
	var assholesize
	var vagTorn = false
	var assTorn = false
	var virginity_multiplier = 0
	var actionshad = {addtraits = [], removetraits = [], samesex = 0, samesexorgasms = 0, oppositesex = 0, oppositesexorgasms = 0, punishments = 0, group = 0, incest = 0, incestorgasms = 0}
	var succubusdraincount = 0 #ralphC
	###---Expansion End---###
	
	func _init(source, fileref, isAnimal = false):
		sceneref = fileref
		person = source
		name = source.name_short()

		loyalty = source.loyal
		submission = source.obed
		lust = source.lust*10
		sens = lust/2

		sex = source.sex
		svagina = source.sensvagina
		smouth = source.sensmouth
		spenis = source.senspenis
		sanus = source.sensanal
		lewd = source.lewdness
		consent = source.consent

		###---Added by Expansion---###
		sexuality = source.sexuality
		#Wear and Tear
		vaginasize = person.vagina
		assholesize = person.asshole
		vagTorn = person.dailyevents.has('vagTorn')
		assTorn = person.dailyevents.has('assTorn')
		###---Expansion End---###

		if source.traits.has("Sex-crazed"):
			effects.append("sexcrazed")
		if isAnimal:
			limbs = false
		elif source != globals.player:
			if !source.consent:
				consent = false
				effects.append('forced')
				person.metrics.roughsex += 1
			if fileref.calcResistWill(self) > 0:
				effects.append('resist')
			for i in person.gear.values():
				if i == null:
					continue
				var tempitem = globals.state.unstackables.get(i)
				if tempitem != null && tempitem.code == 'acchandcuffs':
					isHandCuffed = true
					break

	###---Added by Expansion---###
	# calculates the amount of sexualityshift that will be gained by scaling down the total shift from an action
	# groupSize should not include the person shifting sexuality in the count
	func calcShift(tempShift, groupSize):
		groupSize = float(max(groupSize, 1))
		return tempShift/groupSize * min(0.9 + 0.1*groupSize, 2.0)

	# Reduce the given person's health by the given amount, subject to a number of limitations:
	#   1. The healthPenaltyWhenTorn flag can disable the functionality altogether.
	#   2. If the person is seriously injured, they already have more pressing things to worry about than this, and
	#      they should not die from just the penetration. Do not let health dip below 50% because of this.
	#   3. Limit how much damage a person can take in one round to 4. This prevents a group of givers from
	#      practically killing a taker in one round.
	# healthLostThisRound states how much health has already been lost this round. The function will return the new
	# value.
	func reduceHealthBy(person, amount, healthLostThisRound):
		var canLose

		if globals.expansionsettings.healthPenaltyWhenTorn:
			amount = min(amount, 4 - healthLostThisRound)

			canLose = max(person.health - round(.5 * person.stats.health_max), 0)
			amount = min(amount, canLose)

			person.health = person.health - amount
			return healthLostThisRound + amount
		return 0

	func getHPText(person):
		return "(Health: " + str(person.health) + "/" + str(person.stats.health_max) + ")"
	###---End of Expansion---###

	func lust_set(value):
		lust = min(value, 1000)

	func sens_set(value):
		var change 
		var isKobold = person.race.find('Kobold') >= 0 # Capitulize - Kobolds are pretty horny
		if (isKobold):
			change = (value - sens)*1.2
		else:
			change = value - sens
		sens += change*sensmod
		if sens >= 1000:
			if ((lastaction.givers.has(self) && lastaction.scene.givertags.has('noorgasm')) || (lastaction.takers.has(self) && lastaction.scene.takertags.has('noorgasm'))):
				return
			if(isKobold):
				sens = 150
				sensmod -= sensmod*0.15
			else:
				sens = 100
				sensmod -= sensmod*0.2
			orgasm()

	func lube():
		if person.vagina != 'none':
			lube = lube + (sens/200)
			lube = min(5+lewd/20,lube)

	#ralphC
	#increments the orgasm count credited to succubi
	func succubus_spunked(groupOther):
		var succubusdrain = false
		for i in groupOther:
			if i.person.race_display == "Succubus":
				succubusdrain = true
				i.person.mana_hunger -= variables.orgasmmana
		if succubusdrain:
			succubusdraincount += 1 #will be used to decrement orgasms for totalmana calc
			sceneref.succubuscounter += 1
	#/ralphC

	func orgasm():
		var text = ''
		orgasm = true
		person.sexexp.orgasms[lastaction.scene.code] = person.sexexp.orgasms.get(lastaction.scene.code,0) + 1
		for k in lastaction.givers + lastaction.takers:
			if self != k:
				person.sexexp.orgasmpartners[k.person.id] = person.sexexp.orgasmpartners.get(k.person.id,0) + 1

		var scene
		var temptext = ''
		var penistext = ''
		var vaginatext = ''
		var anustext = ''
		orgasms += 1
		person.metrics.orgasm += 1
		if sceneref.participants.size() == 2 && person != globals.player:
			if person.traits.has("Monogamous") && (sceneref.participants[0].person == globals.player || sceneref.participants[1].person == globals.player):
				person.loyal += rand_range(1.4,5.6)
			else:
				person.loyal += rand_range(1,4)
		elif person != globals.player:
			person.loyal += rand_range(1,2)
		
		###---Added by Expansion---### Sexuality Scale and Incest/Family Matters
		var relative = 'unrelated'
		var groupOther = lastaction.givers if lastaction.takers.has(self) else lastaction.takers
		var tempShift = 0
		for i in groupOther:
			#Sexuality Shift
			tempShift += 1 if sceneref.ispairsamesex(person, i.person) else -1
			if person != globals.player:
				#Incest
				if globals.state.relativesdata.has(i.person.id) && globals.state.relativesdata.has(person.id):
					var temp = globals.expansion.relatedCheck(person, i.person)
					if temp != "unrelated":
						relative = temp
		if lastaction.takers.has(self):
			sexualityshift += calcShift(.25 * tempShift, groupOther.size())
			if relative != 'unrelated':
				actionshad.incestorgasms += 1
				if person.checkFetish('incest'):
					text += "[name2] starts to {^go faster:go harder:move faster:pant:pant heavily} as [his2] impending orgasm approaches. "
					text += "[color=yellow]" + person.quirk("-Oh " + relative + ", I'm...I'm... ")
				else:
					text += "[name2] starts to {^panic:hyperventilate:resist:slow down} as [his2] impending orgasm approaches, but it is too late. "
					text += "[color=yellow]" + person.quirk("-This is wrong! My " + relative + " isn't supposed to be able to make me cum! ")
				text += globals.randomfromarray(["Fuuuuuck!","Oh...oh! I'm cumming!!!","Fuck! I'm cuuuuuummming!","No, no, nooo-NGH","NNNGH!","MMM!","Cu-cu-CUMMING!"]) + "[/color]\n"
			text = sceneref.decoder(text, groupOther, [self])
		else:
			sexualityshift += calcShift(.15 * tempShift, groupOther.size())
			if relative != 'unrelated':
				actionshad.incestorgasms += 1
				if person.checkFetish('incest'):
					text += "[name1] starts to {^go faster:go harder:move faster:pant:pant heavily} as [his1] impending orgasm approaches. "
					text += "[color=yellow]" + person.quirk("-Oh " + relative + ", I'm...I'm... ")
				else:
					text += "[name1] starts to {^panic:hyperventilate:resist:slow down} as [his1] impending orgasm approaches, but it is too late. "
					text += "[color=yellow]" + person.quirk("-This is wrong! My " + relative + " isn't supposed to be able to make me cum! ")
				text += globals.randomfromarray(["Fuuuuuck!","Oh...oh! I'm cumming!!!","Fuck! I'm cuuuuuummming!","No, no, nooo-NGH","NNNGH!","MMM!","Cu-cu-CUMMING!"]) + "[/color]\n"
			text = sceneref.decoder(text, [self], groupOther)
		###---Expansion End---###
		
		#anus in use, find scene
		if anus != null:
			scene = anus
			for i in scene.givers:
				globals.addrelations(person, i.person, rand_range(30,50))
			#anus in giver slot
			if scene.givers.find(self) >= 0:
				if randf() < 0.4:
					anustext = "[name1] feel[s/1] a {^sudden :intense ::}{^jolt of electricity:warmth:wave of pleasure} inside [him1] and [his1]"
				else:
					anustext = "[names1]"
				if scene.scene.takerpart == 'penis':
					anustext += " [anus1] {^squeezes:writhes around:clamps down on} [names2] [penis2] as [he1] reach[es/1] {^climax:orgasm}. "
				else:
					anustext += " [anus1] {^convulses:twitches:quivers} {^in euphoria:in ecstasy:with pleasure} as [he1] reach[es/1] {^climax:orgasm}. "
					###---Added by Expansion---### Stretching
					if globals.assholesizearray.find(assholesize) > globals.assholesizearray.find(person.asshole):
						if person.sexexpanded.elasticity + rand_range(0,5) < 5:
							assholesize = globals.assholesizearray[globals.assholesizearray.find(assholesize)-1]
							anustext += "\n[color=green][names1] [anus1] {^tightens:squeezes:contracts} while orgasming, then does not expand back to its {^stretched:looser:worn out} size after {^convulsing:spasming:tightening}. It has slightly recovered.[/color]"
						if assTorn == true && rand_range(0,100) <= globals.expansionsettings.tornassautorecovery * (1 + person.sexexpanded.elasticity):
							assTorn = false
							anustext += "[color=green]As [his1] [anus1] retightened during [his1] orgasm, [his1] [anus1] seems to have recovered from its earlier tearing.[/color] "
					###---End Expansion---###
				anustext = sceneref.decoder(anustext, [self], scene.takers)
			#anus is in taker slot
			elif scene.takers.find(self) >= 0:
				if randf() < 0.4:
					anustext = "[name2] feel[s/2] a {^sudden :intense ::}{^jolt of electricity:warmth:wave of pleasure} inside [him2] and [his2]"
				else:
					anustext = "[names2]"
				if scene.scene.giverpart == 'penis':
					anustext += " [anus2] {^squeezes:writhes around:clamps down on} [names1] [penis1] as [he2] reach[es/2] {^climax:orgasm}."
				else:
					anustext += " [anus2] {^convulses:twitches:quivers} {^in euphoria:in ecstasy:with pleasure} as [he2] reach[es/2] {^climax:orgasm}."
					###---Added by Expansion---### Stretching
					if globals.assholesizearray.find(assholesize) > globals.assholesizearray.find(person.asshole):
						if person.sexexpanded.elasticity + rand_range(0,5) < 5:
							assholesize = globals.assholesizearray[globals.assholesizearray.find(assholesize)-1]
							anustext += "\n[color=green][names2] [anus2] {^tightens:squeezes:contracts} while orgasming, then does not expand back to its {^stretched:looser:worn out} size after {^convulsing:spasming:tightening}. It has slightly recovered.[/color]"
						if assTorn == true && rand_range(0,100) <= globals.expansionsettings.tornassautorecovery * (1 + person.sexexpanded.elasticity):
							assTorn = false
							anustext += "[color=green]As [his2] [anus2] retightened during [his2] orgasm, [his2] [anus2] seems to have recovered from its earlier tearing.[/color] "
					###---End Expansion---###
				anustext = sceneref.decoder(anustext, scene.givers, [self])
			#no default conditon
		#vagina present
		if person.vagina != 'none':
			lube()
			#vagina in use, find scene
			if vagina != null:
				scene = vagina
				for i in scene.givers:
					globals.addrelations(person, i.person, rand_range(30,50))
				#vagina in giver slot
				if scene.givers.find(self) >= 0:
					if randf() < 0.4:
						vaginatext = "[name1] feel[s/1] a {^sudden :intense ::}{^jolt of electricity:warmth:wave of pleasure} inside [him1] and [his1]"
					else:
						vaginatext = "[names1]"
					if scene.scene.takerpart == 'penis':
						vaginatext += " [pussy1] {^squeezes:writhes around:clamps down on} [names2] [penis2] as [he1] reach[es/1] {^climax:orgasm}."
					else:
						vaginatext += " [pussy1] {^convulses:twitches:quivers} {^in euphoria:in ecstasy:with pleasure} as [he1] reach[es/1] {^climax:orgasm}."
					###---Added by Expansion---### Stretching
						if globals.vagsizearray.find(vaginasize) > globals.vagsizearray.find(person.vagina):
							if person.sexexpanded.elasticity + rand_range(0,5) < 5:
								vaginasize = globals.vagsizearray[globals.vagsizearray.find(vaginasize)-1]
								vaginatext += "\n[color=green][names1] [pussy1] {^tightens:squeezes:contracts} while orgasming, then does not expand back to its {^stretched:looser:worn out} size after {^convulsing:spasming:tightening}. It has slightly recovered.[/color]"
							if vagTorn == true && rand_range(0,100) <= globals.expansionsettings.tornvagautorecovery * (1 + person.sexexpanded.elasticity):
								vagTorn = false
								vaginatext += "[color=green]As [his1] [pussy1] tightened during [his1] orgasm, [his1] [pussy1] seems to have recovered from its earlier tearing.[/color] "
					###---End Expansion---###
					vaginatext = sceneref.decoder(vaginatext, [self], scene.takers)
				#vagina is in taker slot
				elif scene.takers.find(self) >= 0:
					if randf() < 0.4:
						vaginatext = "[name2] feel[s/2] a {^sudden :intense ::}{^jolt of electricity:warmth:wave of pleasure} inside [him2] and [his2]"
					else:
						vaginatext = "[names2]"
					if scene.scene.giverpart == 'penis':
						vaginatext += " [pussy2] {^squeezes:writhes around:clamps down on} [names1] [penis1] as [he2] reach[es/2] {^climax:orgasm}."
					else:
						vaginatext += " [pussy2] {^convulses:twitches:quivers} {^in euphoria:in ecstasy:with pleasure} as [he2] reach[es/2] {^climax:orgasm}."
						###---Added by Expansion---### Stretching
						if globals.vagsizearray.find(vaginasize) > globals.vagsizearray.find(person.vagina):
							if person.sexexpanded.elasticity + rand_range(0,5) < 5:
								vaginasize = globals.vagsizearray[globals.vagsizearray.find(vaginasize)-1]
								vaginatext += "\n[color=green][names2] [pussy2] {^tightens:squeezes:contracts} while orgasming, then does not expand back to its {^stretched:looser:worn out} size after {^convulsing:spasming:tightening}. It has slightly recovered.[/color]"
							if vagTorn == true && rand_range(0,100) <= globals.expansionsettings.tornvagautorecovery * (1 + person.sexexpanded.elasticity):
								vagTorn = false
								vaginatext += "[color=green]As [his1] [pussy1] tightened during [his1] orgasm, [his1] [pussy1] seems to have recovered from its earlier tearing.[/color] "
					###---End Expansion---###
					vaginatext = sceneref.decoder(vaginatext, scene.givers, [self])
				#no default conditon
		#penis present
		if person.penis != 'none':
			#penis in use, find scene
			if penis != null:
				scene = penis
				for i in scene.takers:
					globals.addrelations(person, i.person, rand_range(30,50))
				#penis in giver slot
				if scene.givers.find(self) >= 0:
					if randf() < 0.4:
						penistext = "[name1] feel[s/1] {^a wave of:an intense} {^pleasure:euphoria} {^run through:course through:building in} [his1] [penis1] and [his1]"
					else:
						penistext = "[name1] {^thrust:jerk}[s/1] [his1] hips forward and a {^thick :hot :}{^jet:load:batch} of"
					if scene.scene.takerpart == '':
						penistext += " {^semen:seed:cum} {^pours onto:shoots onto:falls to} the {^ground:floor} as [he1] ejaculate[s/1]."
					elif ['anus','vagina','mouth'].has(scene.scene.takerpart):
						if (scene.scene.get('takerpart2') && scene.scene.givers.size() == 2 && scene.scene.givers[1] == self) || (scene.scene.get('takerpart3') && scene.scene.givers.size() == 3 && scene.scene.givers[2] == self):
							temptext = scene.scene.takerpart2.replace('anus', '[anus2]').replace('vagina','[pussy2]')
							if scene.scene.takerpart2 == 'anus':
								for i in scene.takers:
									i.person.cum.ass += person.pregexp.cumprod
							elif scene.scene.takerpart2 == 'mouth':
								for i in scene.takers:
									i.person.cum.mouth += person.pregexp.cumprod
							if scene.scene.get('takerpart3') && scene.scene.givers[2] == self:
								temptext = scene.scene.takerpart3.replace('anus', '[anus2]').replace('vagina','[pussy2]')
								if scene.scene.takerpart3 == 'anus':
									for i in scene.takers:
										i.person.cum.ass += person.pregexp.cumprod
								elif scene.scene.takerpart3 == 'mouth':
									for i in scene.takers:
										i.person.cum.mouth += person.pregexp.cumprod
										i.person.cum.face += round(person.pregexp.cumprod*.25) # /Capitulize
						else:
							temptext = scene.scene.takerpart.replace('anus', '[anus2]').replace('vagina','[pussy2]')
							if scene.scene.takerpart == 'vagina':
								for i in scene.takers:
									###---Added by Expansion---### Cum Tracking
									i.person.cum.pussy += person.pregexp.cumprod
									i.person.checkFetish('creampiepussy')
									###---End Expansion---###
									if sceneref.impregnationcheck(i.person, person) == true:
										globals.impregnation(i.person, person)
										i.person.checkFetish('pregnancy')
							###---Added by Expansion---### Cum Tracking
							elif scene.scene.takerpart == 'anus':
								for i in scene.takers:
									i.person.cum.ass += person.pregexp.cumprod
									i.person.checkFetish('creampieass')
							elif scene.scene.takerpart == 'mouth':
								for i in scene.takers:
									i.person.cum.mouth += person.pregexp.cumprod
									i.person.checkFetish('creampiemouth')
							###---End Expansion---###
						if scene.scene.code in ['doublepen','triplepen']: # Capitulize
							for i in scene.takers:
								i.person.cum.body += round(person.pregexp.cumprod*.25) # /Capitulize
						penistext += " {^semen:seed:cum} {^pours:shoots:pumps:sprays} into [names2] " + temptext + " as [he1] ejaculate[s/1]."
					elif scene.scene.takerpart == 'nipples':
						penistext += " {^semen:seed:cum} fills [names2] hollow nipples. "
						###---Added by Expansion---### Cum Tracking
						for i in scene.takers:
							i.person.cum.body += person.pregexp.cumprod
							i.person.checkFetish('wearcum')
						###---End Expansion---###
					elif scene.scene.takerpart == 'penis':
						penistext += " {^semen:seed:cum} {^pours:shoots:sprays}, covering [names2] [penis2]. "
						###---Added by Expansion---### Cum Tracking
						for i in scene.takers:
							i.person.cum.body += person.pregexp.cumprod
							i.person.checkFetish('wearcum')
						###---End Expansion---###
					penistext = sceneref.decoder(penistext, [self], scene.takers)
					#ralphC - if any of the TAKERS is a Succubus, count this orgasm so it can be deducted from totalmana calc
					succubus_spunked(scene.takers)
					#/ralphC
				#penis in taker slot
				elif scene.takers.find(self) >= 0:
					if randf() < 0.4:
						penistext = "[name2] feel[s/2] {^a wave of:an intense} {^pleasure:euphoria} {^run through:course through:building in} [his2] [penis2] and [his2]"
					else:
						penistext = "[name2] {^thrust:jerk}[s/2] [his2] hips forward and a {^thick :hot :}{^jet:load:batch} of"
					if scene.scene.code in ['handjob','titjob']:
						penistext += " {^sticky:white:hot} {^semen:seed:cum} {^sprays onto:shoots all over:covers} [names1] face[/s1] as [he2] ejaculate[s/2]."
						###---Added by Expansion---### Cum Tracking
						for i in scene.givers:
							i.person.cum.face += round(person.pregexp.cumprod*.5)
							i.person.checkFetish('wearcumface')
							i.person.cum.body += round(person.pregexp.cumprod*.75)
							i.person.checkFetish('wearcum')
						###---End Expansion---###
					elif scene.scene.code == 'tailjob':
						penistext += " {^sticky:white:hot} {^semen:seed:cum} {^sprays onto:shoots all over:covers} [names1] tail[/s1] as [he2] ejaculate[s/2]."
						###---Added by Expansion---### Cum Tracking
						for i in scene.givers:
							i.person.cum.body += person.pregexp.cumprod
							i.person.checkFetish('wearcum')
						###---End Expansion---###
					elif scene.scene.code == 'tribadismonpenis': # Capitulize
						penistext += " {^sticky:white:hot} {^semen:seed:cum} {^sprays onto:shoots all over:covers} [names1] {^groins:vaginas:slits} as [he2] ejaculate[s/2]."
						###---Added by Expansion---### Cum Tracking
						for i in scene.givers:
							i.person.cum.body += round(person.pregexp.cumprod*.75) # /Capitulize
						###---End Expansion---###
					elif scene.scene.giverpart == '':
						penistext += " {^semen:seed:cum} {^pours onto:shoots onto:falls to} the {^ground:floor} as [he2] ejaculate[s/2]."
					elif scene.scene.giverpart == 'penis':
						penistext += " {^semen:seed:cum} {^pours:shoots:sprays}, covering [names1] [penis1]. "
						###---Added by Expansion---### Cum Tracking
						for i in scene.givers:
							i.person.cum.body += person.pregexp.cumprod
							i.person.checkFetish('wearcum')
						###---End Expansion---###
					elif ['anus','vagina','mouth'].has(scene.scene.giverpart):
						temptext = scene.scene.giverpart.replace('anus', '[anus1]').replace('vagina','[pussy1]')
						penistext += " {^semen:seed:cum} {^pours:shoots:pumps:sprays} into [names1] " + temptext + " as [he2] ejaculate[s/2]. "
						if scene.scene.giverpart == 'vagina':
							for i in scene.givers:
								###---Added by Expansion---### Cum Tracking
								i.person.cum.pussy += person.pregexp.cumprod
								i.person.checkFetish('creampiepussy')
								###---End Expansion---###
								if sceneref.impregnationcheck(i.person, person) == true:
									globals.impregnation(i.person, person)
						###---Added by Expansion---### Sex Expanded
						elif scene.scene.giverpart == 'anus':
							for i in scene.givers:
								i.person.cum.ass += person.pregexp.cumprod
								i.person.checkFetish('creampieass')
						elif scene.scene.giverpart == 'mouth':
							for i in scene.givers:
								#i.person.cum.mouth += person.pregexp.cumprod
								i.person.checkFetish('creampiemouth')
								if !i.person.sexuals.actions.has('blowjob'):
									i.person.sexuals.actions['blowjob'] = 0
								if i.person.sexuals.actions['blowjob'] < i.person.cum.mouth:
									penistext += "So much "+globals.expansion.nameCum()+" {^pours:shoots:pumps:sprays} into [names1] mouth as [he1] can't handle the pressure in [his1] inside. "
									i.person.checkFetish('wearcumface')
									if i.person.checkFetish('drinkcum') == true || rand_range(0,1) >= .5:
										penistext += "[name1] tries to keep [his1] mouth closed, but [his1] cheeks bulge out to [his1] full capacity. [names1] eyes go wide with panic as "+globals.expansion.nameCum()+" begins to {^jet:spray:stream:gush:trickle} out of [his1] nose and down [his1] face.\n "
										i.person.cum.mouth += person.pregexp.cumprod
										i.person.cum.face += round(person.pregexp.cumprod*.25)
									else:
										penistext += "[name1] tries to keep [his1] mouth closed, but [he1] starts to gag as the "+globals.expansion.nameCum()+" floods [his1] helpless throat. [name1] struggles to pull [his1] head off of [names2] [penis2] and spends a moment gagging and wretching horribly from the torrent.\n "
										i.person.cum.mouth += round(person.pregexp.cumprod*.25)+1
										i.person.cum.face += round(person.pregexp.cumprod*.75)
								else:
									penistext += "[name1] stays skillfully on [names2] [penis2] until it finishes flooding [his1] mouth with "+globals.expansion.nameCum()+". [name1] then opens [his1] mouth to show off the "+globals.expansion.nameCum()+" inside and "
									if i.person.checkFetish('drinkcum') == true:
										penistext += "happily {^gulps:slurps:sucks:drinks:guzzles} every drop of it. "
										i.person.cum.mouth += round(person.pregexp.cumprod*.25)+1
										#Add CumDrink
									elif i.person.checkFetish('wearcumface') == true:
										penistext += "lets it {^drool:drain:slip:drinks:guzzles} out of [his1] mouth all over [his1] lips and chin. "
										i.person.cum.mouth += round(person.pregexp.cumprod*.25)+1
										i.person.cum.face += round(person.pregexp.cumprod*.75)
									elif i.person.checkFetish('wearcum') == true:
										penistext += "lets it {^drool:drain:slip:drinks:guzzles} out of [his1] mouth all over [his1] "+globals.expansion.getChest(i.person)+" and "+globals.expansion.nameBelly()+". "
										i.person.cum.mouth += round(person.pregexp.cumprod*.25)+1
										i.person.cum.body += round(person.pregexp.cumprod*.75)
									else:
										penistext += " spits it on the ground. "
						###---End Expansion---###
					penistext = sceneref.decoder(penistext, scene.givers, [self])
					#ralphC - if any of the GIVERS is a Succubus, count this orgasm so it can be deducted from totalmana calc
					succubus_spunked(scene.givers)
					#/ralphC
			#orgasm without penis, secondary ejaculation
			else:
				if randf() < 0.4:
					penistext = "[name2] {^twist:quiver:writhe}[s/2] in {^pleasure:euphoria:ecstacy} as"
				else:
					penistext = "[name2] {^can't hold back any longer:reach[es/2] [his2] limit} and"
				penistext += " {^a jet of :a rope of :}{^semen:cum} {^fires:squirts:shoots} from {^the tip of :}[his2] {^neglected :throbbing ::}[penis2]."
				penistext = sceneref.decoder(penistext, [], [self])
		var tempPool = PoolStringArray()
		if !vaginatext.empty():
			tempPool.append(vaginatext)
		if !anustext.empty():
			tempPool.append(anustext)
		if !penistext.empty():
			tempPool.append(penistext)
		if tempPool.size() > 0:
			text += tempPool.join(" ")
		#final default condition
		else:
			if randf() < 0.4:
				temptext = "[name2] feel[s/2] {^a sudden :an intense ::}{^jolt of electricity:heat:wave of pleasure} and [his2]"
			else:
				temptext = "[names2]"
			temptext += " {^entire :whole :}body {^twists:quivers:writhes} in {^pleasure:euphoria:ecstacy} as [he2] reach[es/2] {^climax:orgasm}."
			text += sceneref.decoder(temptext, [], [self])


		if lastaction.scene.code in sceneref.punishcategories:
			if lastaction.takers.has(self):
				person.dailyevents.append('masochism')
				if randf() >= 0.85 || person.effects.has("entranced"):
					actionshad.addtraits.append("Masochist")
			else:
				person.dailyevents.append('sadism')

		if lastaction.scene.get('takertags') != null && lastaction.scene.takertags.has('shame'):
			if lastaction.takers.has(self):
				person.dailyevents.append('submission')
			else:
				person.dailyevents.append('dominance')

	#	if member.lastaction.scene.code in punishcategories && member.lastaction.givers.has(member) && member.person.asser >= 60:
	#		if randf() >= 0.85 || member.person.effects.has("entranced"):
	#			member.actionshad.addtraits.append("Dominant")
		if lastaction.scene.code in sceneref.analcategories && (lastaction.takers.has(self) || lastaction.scene.code == 'doubledildoass'):
			if randf() >= 0.85 || person.effects.has('entranced'):
				actionshad.addtraits.append("Enjoys Anal")
		if sceneref.isencountersamesex(lastaction.givers, lastaction.takers, self) == true:
			actionshad.samesexorgasms += 1
		else:
			actionshad.oppositesexorgasms += 1

		###---Added by Expansion---### Incest Orgasm Aftermath
		if lastaction.takers.has(self) && person != globals.player:
			for i in lastaction.givers:
				if i != self:
					if globals.state.relativesdata.has(i.person.id) && globals.state.relativesdata.has(person.id):
						if str(globals.expansion.relatedCheck(person, i.person)) != "unrelated":
							relative = str(globals.expansion.relatedCheck(person, i.person))
			if relative != "unrelated" && relative != null:
				if globals.fetishopinion.find(person.fetish.incest) < 3:
					text += person.dictionary("\n[he2] looks disgusted by [himself2] as [he2] {^huffs:pants:gasps:moans:twitches}. [color=yellow]")
					person.stress += round(rand_range(actionshad.incestorgasms,actionshad.incestorgasms*2))
				else:
					text += "\n[he2] looks {^happy:satisfied:overjoyed} as [he2] {^huffs:pants:gasps:moans:twitches}. "
					person.stress -= round(rand_range(actionshad.incestorgasms*.5,actionshad.incestorgasms))
				var tempfetish
				if person.fetish.incest == "uncertain":
					tempfetish = "weird"
				elif person.fetish.incest == "acceptable":
					tempfetish = "strangely even sexier than I thought it would be"
				else:
					tempfetish = person.fetish.incest
				text += "\n[color=yellow]" + person.quirk("-My [color=aqua]" + str(relative) + "[/color] made me cum! That is so " +str(tempfetish)+ "![/color]\n")
			text = sceneref.decoder(text, [self], lastaction.takers)
		elif lastaction.givers.has(self) && person != globals.player:
			for i in lastaction.takers:
				if i != self && self != globals.player:
					if globals.state.relativesdata.has(i.person.id) && globals.state.relativesdata.has(person.id):
						if str(globals.expansion.relatedCheck(person, i.person)) != "unrelated":
							relative = str(globals.expansion.relatedCheck(person, i.person))
							continue
			if relative != "unrelated"  && relative != null:
				if globals.fetishopinion.find(person.fetish.incest) < 3:
					text += person.dictionary("\n[he1] looks disgusted by [himself1] as [he1] {^huffs:pants:gasps:moans:twitches}. ")
					person.stress += round(rand_range(actionshad.incestorgasms,actionshad.incestorgasms*2))
				else:
					text += "\n[he1] looks {^happy:satisfied:overjoyed} as [he1] {^huffs:pants:gasps:moans:twitches}. "
					person.stress -= round(rand_range(actionshad.incestorgasms*.5,actionshad.incestorgasms))
				var tempfetish
				if person.fetish.incest == "uncertain":
					tempfetish = "weird"
				elif person.fetish.incest == "acceptable":
					tempfetish = "strangely even sexier than I thought it would be"
				else:
					tempfetish = person.fetish.incest
				text += "[color=yellow]" + person.quirk("\n-My [color=aqua]" + str(relative) + "[/color] made me cum! That is so " +str(tempfetish)+ "![/color]\n")
			text = sceneref.decoder(text, lastaction.givers, [self])
		###---Expansion End---###

		#return
		yield(sceneref.get_tree().create_timer(0.1), "timeout")
		###---Added by Expansion---### Decoder
		sceneref.get_node("Panel/sceneeffects").bbcode_text += "[color=#ff5df8]" + text + "[/color]\n"
		###---End Expansion---###

	func actioneffect(acceptance, values, scenedict):
		for key in ['lewd', 'lust', 'sens', 'pain', 'obed', 'stress']:
			values[key] = float(values.get(key, 0))
		lastaction = scenedict
		
		if scenedict.scene.code in globals.punishcategories:
			person.asser += rand_range(1,2) if scenedict.givers.has(self) else rand_range(-1,-2)
		
		if acceptance == 'good':
			values.sens *= rand_range(1.1,1.4)
			values.lust *= 2
			
			if lewd < 50 || scenedict.scene.code in ['doublepen', 'triplepen', 'nipplefuck', 'spitroast', 'spitroastass', 'inserttailv', 'inserttaila', 'doubledildo', 'doubledildoass', 'tailjob', 'footjob', 'deepthroat', 'tribadismonpenis']:
				lewd += rand_range(1,3)
			
			for i in scenedict.givers + scenedict.takers:
				if i != self:
					globals.addrelations(person, i.person, rand_range(4,8))
		elif acceptance == 'average':
			values.sens *= 1.1
			#values.lust *= 1
			
			if lewd < 50 || scenedict.scene.code in ['doublepen','triplepen','nipplefuck', 'spitroast', 'spitroastass', 'inserttailv', 'inserttaila', 'doubledildo', 'doubledildoass', 'tailjob', 'footjob', 'deepthroat', 'tribadismonpenis']:
				lewd += rand_range(1,2)
			
			for i in scenedict.givers + scenedict.takers:
				if i != self:
					globals.addrelations(person, i.person, rand_range(2,4))
			if values.pain > 0.0:
				person.stress += rand_range(0,2)
		else:
			values.sens *= 0.6
			values.lust *= 0.3
			for i in scenedict.givers + scenedict.takers:
				if i != self:
					globals.addrelations(person, i.person, -rand_range(3,5))
			if values.pain > 0.0:
				if effects.has('resist'):
					person.stress += rand_range(5,10)
				else:
					person.stress += rand_range(2,4)
		
		if self in scenedict.takers:
			if scenedict.scene.giverpart == 'mouth':
				for giver in scenedict.givers:
					if giver.person.mods.has("augmenttongue"):
						values.sens *= 1.3
						break
		else:
			if scenedict.scene.takerpart == 'mouth' || (scenedict.scene.get('takerpart2') != null && scenedict.scene.takerpart2 == 'mouth' && scenedict.givers.size() == 2 && self == scenedict.givers[1]):
				for taker in scenedict.takers:
					if taker.person.mods.has("augmenttongue"):
						values.sens *= 1.3
						break

		if values.has('tags'):
			if values.tags.has('punish'):
				if (effects.has('resist') || effects.has('forced')) && (!person.traits.has('Masochist') && !person.traits.has('Likes it rough') && !person.traits.has('Sex-crazed') && person.spec != 'nympho'):
					for i in scenedict.givers:
						globals.addrelations(person, i.person, -rand_range(5,10))
					if values.stress == 0.0:
						values.stress = rand_range(3,5)
					if person.effects.has("captured") && rand_range(0,50) <= values.obed + 5:
						person.effects.captured.duration -= 1
					values.lust /= 4
					values.sens /= 4
				else:
					if person.asser < 35 && randf() < 0.1:
						actionshad.addtraits.append('Likes it rough')
					if !person.traits.has('Masochist') && !person.traits.has('Sex-crazed') && person.spec != 'nympho':
						if values.stress == 0.0:
							values.stress = rand_range(2,4)
					else:
						values.stress = 0.0
			if values.tags.has('pervert') && !person.traits.has('Pervert'):
				if person.traits.has('Sex-crazed') || person.spec in ['geisha','nympho']:
					if lust >= 750 && randf() < 0.2:
						actionshad.addtraits.append("Pervert")
				elif acceptance == 'good':
					if lust >= 750 && randf() < 0.2:
						actionshad.addtraits.append("Pervert")
					else:
						values.stress += rand_range(2,4)
				else:
					values.sens /= 1.75
					values.stress += rand_range(2,4)
			if values.tags.has('group'):
				actionshad.group += 1
		
		###---Added by Expansion---### Various Sex Action Checks and Text
		var tempShift = 0
		var healthLostThisRound = 0
		for i in scenedict.takers + scenedict.givers:
			if i == self:
				continue
			var text = ''
			#Checks Attraction, SexMatch
			#Max of 110 Currently. Add "Size Queen/Etc" for Fetishes/Likes in the Future, then Sens/Lust multipliers as well
#				text += "[color=aqua]Sexuality Check:[/color] "
			if globals.expansion.getSexualAttraction(person,i.person) == true:
				tempShift += rand_range(.1,.15) if sceneref.ispairsamesex(person, i.person) else -rand_range(.1,.15)
				values.sens *= rand_range(.95,1.05)
				values.lust *= rand_range(.95,1.05)
			else:
				tempShift += rand_range(.05,.5) if sceneref.ispairsamesex(person, i.person) else -rand_range(.05,.5)
				values.sens *= rand_range(.4,.6)
				values.lust *= rand_range(.4,.6)
			#---End Sexuality Check

			#Incest Check
			var relation = globals.expansion.relatedCheck(person, i.person)
			if relation != 'unrelated' && person != globals.player:
				self.actionshad.incest += 1
				#Below is Temporary
				var compare = (globals.fetishopinion.find(person.fetish.incest)-3)*100 + (i.person.beauty-40)*3 + (person.lewdness + person.lust)*1.5
				text += " "
#					var compare = int((500+abs(person.relations[i.person.id]))/globals.fetishopinion.find(person.fetish.incest))
				if compare >= 500:
					values.sens *= rand_range(1.2,1.5)
					values.lust *= rand_range(1.2,1.5)
					globals.addrelations(person, i.person, rand_range(5,10))
#						if scenedict.givers.find(self) >= 0:
#							text += "[color=green]{^[name2] [doesn't] even mind:[name2] may even love:[name1] [is1] into it despite the fact} that [name1] [is2] [his2] [relation]."
#						else:
#							text += "[color=green]{^[name1] doesn't even mind:[name1] may even love:[name2] [is2] into it despite the fact} that [name2] [is1] [his1] [relation]."
				elif compare >= 250:
					values.sens *= rand_range(1.1,1.4)
					values.lust *= rand_range(1.1,1.4)
					globals.addrelations(person, i.person, rand_range(4,8))
#						if scenedict.givers.find(self) >= 0:
#							text += "[color=green]{^[name1] [seems] to enjoy:[name1] really likes:[name1] [is1] into the fact} that [name2] [is2] [his2] [relation]."
#						else:
#							text += "[color=green]]{^[name2] seems to enjoy:[name2] really likes:[name2] [is2] into the fact:[name2] really likes} that [name1] [is1] [his1] [relation]."
				elif compare >= 0:
					values.sens *= rand_range(0.9,1.2)
					values.lust *= rand_range(0.9,1.2)
					person.stress += rand_range(0,3)
					globals.addrelations(person, i.person, rand_range(2,4))
#						if scenedict.givers.find(self) >= 0:
#							text += "[color=green]{^[name1] may even enjoy:[name1] may even like:[name1] [doesn't] seem to mind:[name1] might be okay with the fact} that [name2] [is2] [his1] [relation]."
#						else:
#							text += "[color=green]{^[name2] may even enjoy:[name2] may even like:[name2] doesn't seem to mind:[name2] might be okay with the fact} that [name1] [is1] [his2] [relation]."
				elif compare >= -250:
					values.sens *= rand_range(0.6,1.1)
					values.lust *= rand_range(0.6,1.1)
					person.stress += rand_range(2,3)
					globals.addrelations(person, i.person, -rand_range(3,5))
#						if scenedict.givers.find(self) >= 0:
#							text += "[color=green]{^[name1] doesn't seem to enjoy:[name1] doesn't like like:[name1] [is1] disgusted by the fact:[name1] [is] really uncomfortable with the fact that:If only [name1] could ignore the fact} that [name2] [is2] [his1] [relation]."
#						else:
#							text += "[color=green]{^[name2] doesn't seem to enjoy:[name2] doesn't like like:[name2] [is2] disgusted by the fact:[name2] is really uncomfortable with the fact that:If only [name2] could ignore the fact} that [name1] [is1] [his2] [relation]."
				else:
					values.sens *= rand_range(0.6,1.1)
					values.lust *= rand_range(0.4,1.1)
					person.stress += rand_range(2,5)
					globals.addrelations(person, i.person, -rand_range(5,10))
#						if scenedict.givers.find(self) >= 0:
#							text += "[color=green]{^[name1] can't enjoy it because:[name1] [is1] revolted by the situation and [himself1] as:[name1] [is] completely disgusted as:[name1] [is] entirely uncomfortable because:[name1] can't get over the fact that:[name1] [is1] revolted because} [name2] [is2] [his1] [relation]."
#						else:
#							text += "[color=green]{^[name2] can't enjoy it because:[name2] [is2] revolted by the situation and [himself2] as:[name2] is completely disgusted as:[name2] is entirely uncomfortable because:[name2] can't get over the fact that:[name2] [is2] revolted because} [name1] [is1] [his2] [relation]."
				#End Incest Check

				text = text.replace('[relation]',relation)
#			sceneref.get_node("Panel/sceneeffects").bbcode_text += sceneref.decoder(text, scenedict.givers, scenedict.takers) + '\n'

			var number = 0
			var difference = 0
			var display = 0
			var clamper = 0
			var roughSex = effects.has('resist') || effects.has('forced')
			#Mouth Effects
			if scenedict.scene.code in ['blowjob','spitroast','spitroastass','deepthroat']:
				number = 1+((globals.lipssizearray.find(i.person.lips)-3)*.1)
				values.sens *= number
				values.lust *= number
				if scenedict.givers.has(self) && scenedict.givers.size() <= 1:
					globals.addrelations(person, i.person, round(rand_range(number,number*2)))
					if globals.lipssizearray.find(i.person.lips)-3 > 0:
						text += "\n[color=green][name1] {^[is1] enjoying:[is1] loving:[is1] relishing:loves} [names2] " +str(i.person.lips)+ " lips.[/color] "
			#Tit Size Effects
			elif scenedict.scene.code in ['titjob','fondletits']:
				number = 1+((globals.titssizearray.find(i.person.titssize)-3)*.1)+globals.fastif(i.person.titsextradeveloped == true, i.person.titsextra*.1, 0)
				values.sens *= number
				values.lust *= number
				globals.addrelations(person, i.person, round(rand_range(number,number*2)))
				if scenedict.givers.has(self) && (globals.titssizearray.find(i.person.titssize)-3) > 0 && scenedict.givers.size() <= 1:
					text += "\n[color=green][name1] {^[is1] enjoying:[is1] loving:[is1] relishing:loves} [names2] " +str(i.person.titssize)+ " {^udders:boobies:breasts:boobs:tits} {^: and they are driving [him1] wild:and [he1] can't stop playing with them}.[/color] "

			#Penis in Pussy Effects
			elif scenedict.scene.code in ['missionary','doggy','lotus','revlotus','spitroast','insertinturns']:
				if scenedict.givers.has(self) && scenedict.takers.has(i):
					var temppenissize = globals.penissizearray.find(person.penis) if person.penis != 'none' else 4 # handle strapon with default size
					difference = temppenissize - globals.vagsizearray.find(i.vaginasize)
					number = 1+(difference*.1)
					values.sens *= number
					values.lust *= number
					if difference > 0 && scenedict.givers.size() <= 1:
						text += "\n[color=green][name1] {^[is1] enjoying:[is1] loving:[is1] relishing:love[s/1]} the feeling of [his1] [penis1] stretching [names2] [pussy2].[/color]"
					elif difference < 0 && scenedict.givers.size() <= 1:
						text += "\n[color=red][name1] {^can barely feel:can't feel:can't fill} [names2] [pussy2] with [his1] [penis1].[/color]"
					#Display
					if globals.state.perfectinfo == true && scenedict.givers.size() <= 1:
						display = difference * 10
						if display > 0:
							text += " [color=aqua]Arousal increased by " + str(display) + "%[/color]"
						elif display < 0:
							text += " [color=red]Arousal decreased by " + str(-display) + "%[/color]"
				elif scenedict.takers.has(self) && scenedict.givers.has(i):
					var temppenissize = globals.penissizearray.find(i.person.penis) if i.person.penis != 'none' else 4 # handle strapon with default size
					difference = temppenissize - globals.vagsizearray.find(vaginasize)
					if vagTorn:
						# If torn, no pleasure boost from a big penetration. It hurts, regardless of size, but some may like it more than others.
						if person.traits.has('Masochist'):
							number = 1.2 if person.traits.has('Likes it rough') else 1.1
							display = 20 if person.traits.has('Likes it rough') else 10
							values.sens *= number
							values.lust *= number
							if scenedict.takers.size() <= 1:
								text += "\n[color=green][names2] [pussy2] [is2] {^stretched out:sore:aching:raw:hurting}, but [he2] {^seem[s/2] to get off on it:appear[s/2] to enjoy it:savour[s/2] the pain}.[/color] "
						elif person.traits.has('Likes it rough'):
							display = -10
							values.sens *= .9
							values.lust *= .9
							if scenedict.takers.size() <= 1:
								text += "\n[color=red][names2] [pussy2] [is2] {^stretched out:sore:aching:raw:hurting}, but [he2] {^do[es/2] [his2] best to take it:gasp[s/2] and put[s/2] up with it:just squeak[s/2] and moan[s/2] a bit}.[/color] "
						else:
							display = -30
							values.sens *= .7
							values.lust *= .7
							if scenedict.takers.size() <= 1:
								text += "\n[color=red][names2] [pussy2] [is2] {^stretched out:sore:aching:raw:hurting} and [his2] pleasure {^has lessened:[is2] reduced:[is2] diminished}.[/color] "
					else:
						# Not torn. Adjust pleasure and mood text based on size.
						number = 1 + (difference * .1)
						display = difference * 10
						values.sens *= number
						values.lust *= number
						if scenedict.takers.size() <= 1:
							if difference > 0:
								if roughSex:
									text += "\n[color=green]Despite [his2] best efforts, [name2] can't help but {^enjoy:be excited by:relish} the feeling of [names1] [penis1] stretching [his2] [pussy2].[/color] "
								else:
									text += "\n[color=green][names2] {^[is2] enjoying:[is2] loving:[is2] relishing:love[s/2]} the feeling of [names1] [penis1] stretching [his2] [pussy2].[/color] "
							elif difference < -1:
								text += "\n[color=red][names2] [pussy2] can barely feel [names1] undersized [penis1].[/color] "

					#Stretching
					if difference >= 5 + rand_range(-5,0) + person.sexexpanded.pliability:
						if globals.vagsizearray.back() != vaginasize:
							clamper = globals.vagsizearray.find(vaginasize)+1
							clamper = clamp(clamper,0,globals.vagsizearray.size()-1)
							vaginasize = globals.vagsizearray[clamper]
							if scenedict.takers.size() <= 1:
								text += "\n[color=green][name2] {^moans:gasps:spasms:twitches:bites [his2] lip} as [his2] [pussy2] [is2] {^stretched:gaped:spread apart:forced to stretch} by [names1] [penis1].[/color] "
							var stretch = globals.vagsizearray.find(vaginasize) - globals.vagsizearray.find(person.vagina)
							# Increased chance to tear if taker is unwilling.
							number = rand_range(0, 2)
							if roughSex:
								number -= 1
							if globals.expansionsettings.disablevaginatearing == false && person.sexexpanded.pliability - stretch + number < 0:
								if vagTorn == false:
									vagTorn = true
									healthLostThisRound = reduceHealthBy(person, 1, healthLostThisRound)
									person.dailyevents.append('vagTorn')
									if !person.traits.has('Masochist') && !person.traits.has('Likes it rough'):
										globals.addrelations(person, i.person, -round(rand_range(difference*5,difference*10)))
									if scenedict.givers.size() <= 1:
										text += "\n[color=red][name2] {^shout[s/2]:scream[s/2]:cr[ies/y2]:sob[s/2]:squeal[s/2]:whimper[s/2]} as [his2] [pussy2] suddenly {^rips:tears:breaks:starts bleeding}, sending waves of pain through [his2] body " + getHPText(person) + ".[/color] "
									person.stress += round(rand_range(difference,temppenissize))
								else:
									healthLostThisRound = reduceHealthBy(person, 2, healthLostThisRound)
									if scenedict.takers.size() <= 1:
										text += "\n[color=red][name2] {^shout[s/2]:scream[s/2]:cr[ies/y2]:sob[s/2]:squeal[s/2]:whimper[s/2]} as [his2] [pussy2] {^rips:tears:breaks} even further, causing [him2] excruciating pain " + getHPText(person) + ".[/color] "
									person.stress += round(rand_range(difference*2,temppenissize*2))
					#Display
					if globals.state.perfectinfo == true && scenedict.takers.size() <= 1:
						if display > 0:
							text += " [color=aqua]Arousal increased by " + str(display) + "%[/color]"
						elif display < 0:
							text += " [color=red]Arousal decreased by " + str(-display) + "%[/color]"

			#Penis in Asshole Effects
			elif scenedict.scene.code in ['missionaryanal', 'doggyanal','lotusanal','revlotusanal','spitroastass','insertinturnsass']:
				if scenedict.givers.has(self) && scenedict.takers.has(i):
					var temppenissize = globals.penissizearray.find(person.penis) if person.penis != 'none' else 4 # handle strapon with default size
					difference = temppenissize - globals.assholesizearray.find(i.assholesize)
					number = 1+(difference*.1)
					values.sens *= number
					values.lust *= number
					if difference > 0 && scenedict.givers.size() <= 1:
						text += "\n[color=green][name1] {^[is1] enjoying:[is1] loving:[is1] relishing:love[s/1]} the feeling of [his1] [penis1] stretching [names2] [anus2].[/color] "
					elif difference < 0 && scenedict.givers.size() <= 1:
						text += "\n[color=red][name1] {^can barely feel:can't feel:can't fill} [names2] [anus2] with [his1] [penis1].[/color] "
					#Display
					if globals.state.perfectinfo == true && scenedict.givers.size() <= 1:
						display = difference * 10
						if display > 0:
							text += " [color=aqua]Arousal increased by " + str(display) + "%[/color]"
						elif display < 0:
							text += " [color=red]Arousal decreased by " + str(-display) + "%[/color]"
				elif scenedict.takers.has(self) && scenedict.givers.has(i):
					var temppenissize = globals.penissizearray.find(i.person.penis) if i.person.penis != 'none' else 4 # handle strapon with default size
					difference = temppenissize - globals.assholesizearray.find(assholesize)
					if assTorn:
						# If torn, no pleasure boost from a big penetration. It hurts, regardless of size, but some may like it more than others.
						if person.traits.has('Masochist'):
							number = 1.2 if person.traits.has('Likes it rough') else 1.1
							display = 20 if person.traits.has('Likes it rough') else 10
							values.sens *= number
							values.lust *= number
							if scenedict.takers.size() <= 1:
								text += "\n[color=green][names2] [anus2] [is2] {^stretched out:sore:aching:raw:hurting}, but [he2] {^seem[s/2] to get off on it:appear[s/2] to enjoy it:savour[s/2] the pain}.[/color] "
						elif person.traits.has('Likes it rough'):
							display = -10
							values.sens *= .9
							values.lust *= .9
							if scenedict.takers.size() <= 1:
								text += "\n[color=red][names2] [anus2] [is2] {^stretched out:sore:aching:raw:hurting}, but [he2] {^do[es/2] [his2] best to take it:gasp[s/2] and put[s/2] up with it:just squeak[s/2] and moan[s/2] a bit}.[/color] "
						else:
							display = -30
							values.sens *= .7
							values.lust *= .7
							if scenedict.takers.size() <= 1:
								text += "\n[color=red][names2] [anus2] [is2] {^stretched out:sore:aching:raw:hurting} and [his2] pleasure {^has lessened:[is2] reduced:[is2] diminished}.[/color] "
					else:
						# Not torn. Adjust pleasure and mood text based on size.
						number = 1 + (difference * .1)
						display = difference * 10
						values.sens *= number
						values.lust *= number
						if scenedict.takers.size() <= 1:
							if difference > 0:
								if roughSex:
									text += "\n[color=green]Despite [his2] best efforts, [name2] can't help but {^enjoy:be excited by:relish} the feeling of [names1] [penis1] stretching [his2] [anus2].[/color] "
								else:
									text += "\n[color=green][names2] {^[is2] enjoying:[is2] loving:[is2] relishing:love[s/2]} the feeling of [names1] [penis1] stretching [his2] [anus2].[/color] "
							elif difference < -1:
								text += "\n[color=red][names2] [anus2] can barely feel [names1] undersized [penis1].[/color] "

					#Stretching
					if difference >= 5 + rand_range(-5,0) + person.sexexpanded.pliability:
						if globals.assholesizearray.back() != assholesize:
							clamper = globals.assholesizearray.find(assholesize)+1
							clamper = clamp(clamper,0,globals.assholesizearray.size()-1)
							assholesize = globals.assholesizearray[clamper]
							if scenedict.takers.size() <= 1:
								text += "\n[color=green][name2] {^starts:begins} {^moaning:gasping:spasming} as [his2] [anus2] [is2] {^stretched:gaped:spread apart:forced to stretch} by [names1] [penis1].[/color] "
							var stretch = globals.assholesizearray.find(assholesize) - globals.assholesizearray.find(assholesize)
							# Increased chance to tear if taker is unwilling.
							number = rand_range(0, 2)
							if roughSex:
								number -= 1
							if globals.expansionsettings.disableanaltearing == false && person.sexexpanded.pliability - stretch + number < 0:
								if assTorn == false:
									assTorn = true
									healthLostThisRound = reduceHealthBy(person, 1, healthLostThisRound)
									person.dailyevents.append('assTorn')
									if !person.traits.has('Masochist') && !person.traits.has('Likes it rough'):
										globals.addrelations(person, i.person, -round(rand_range(difference*5,difference*10)))
									if scenedict.takers.size() <= 1:
										text += "\n[color=red][name2] {^shout[s/2]:scream[s/2]:cr[ies/y2]:sob[s/2]:squeal[s/2]:whimper[s/2]} as [his2] [anus2] suddenly {^rips:tears:breaks:starts bleeding}, sending waves of pain through [his2] body " + getHPText(person) + ".[/color]"
									person.stress += round(rand_range(difference,temppenissize))
								else:
									healthLostThisRound = reduceHealthBy(person, 2, healthLostThisRound)
									if scenedict.takers.size() <= 1:
										text += "\n[color=red][name2] {^shout[s/2]:scream[s/2]:cr[ies/y2]:sob[s/2]:squeal[s/2]:whimper[s/2]} as [his2] [anus2] {^rips:tears:breaks} even further, causing [him2] excruciating pain " + getHPText(person) + ".[/color] "
									person.stress += round(rand_range(difference*2,temppenissize*2))
					#Display
					if globals.state.perfectinfo == true && scenedict.takers.size() <= 1:
						if display > 0:
							text += " [color=aqua]Arousal increased by " + str(display) + "%[/color]"
						elif display < 0:
							text += " [color=red]Arousal decreased by " + str(-display) + "%[/color]"
				
			#Milking during Sex
			elif scenedict.scene.code in ['milker','sucknipples']:
				#Add Milk Bottle Production
				if scenedict.takers.has(self):
					if person.lactation == true:
						if person.lactating.milkstorage > 0 || person.lactating.pressure > 0:
							number = ceil(rand_range(person.lactating.milkstorage * 0.1, person.lactating.milkstorage * 0.3))
							if person.lactating.pressure > 0:
								number += person.lactating.pressure
								person.lactating.pressure = 0
							number = clamp(number, 0, person.lactating.milkstorage)
							person.lactating.milkstorage -= number
							person.lactating.milkedtoday = true
							person.lactating.daysunmilked = 0
							person.dailyevents.append('lactation')
							if number > 0:
								if globals.fetishopinion.find(person.fetish.lactation) > 3:
									values.lust *= 1+(number*.1)
								else:
									person.stress = round(person.stress+(number*.1))
								values.sens *= 1+(number*.1)
								values.lust *= 1+(number*.1)
								globals.addrelations(person, i.person, round(rand_range(number,number*2)))
								text += "\n[color=green][name2] {^moans:gasps:spasms:twitches} as {^[his2]} {^boobs:tits:udders:breasts} lactated "+str(number)+" milk while {^being sucked:being pumped:being milked:being fucked}.[/color]"

			text = globals.fastif(person==globals.player, text.replace("[doesn't]","don't"), text.replace("[doesn't]","doesn't"))
			text = globals.fastif(person==globals.player, text.replace("[seems]","seem"), text.replace("[seems]","seems"))
			sceneref.get_node("Panel/sceneeffects").bbcode_text += sceneref.decoder(text, scenedict.givers, scenedict.takers)

		sexualityshift += calcShift(tempShift, scenedict.takers.size() + scenedict.givers.size() - 1)
		###---Expansion End---###
		
		self.lewd += values.lewd
		self.lust += values.lust
		self.sens += values.sens
		person.obed += values.obed
		person.stress += values.stress
		
		if values.get('obed', 0) > 0 && effects.has('resist') && sceneref.calcResistWill(self) < 0 && person != globals.player:
			var text = ''
			text += "\n[color=green]Afterward, {^[name2] seems to have:it looks as though [name2] [has2]} {^learned [his2] lesson:reformed [his2] rebellious ways:surrendered} and shows {^complete:total} {^submission:obedience:compliance}"
			if person.traits.find("Masochist") >= 0:
				text += ", but there is also {^an unusual:a strange} {^flash:hint:look} of desire in [his2] eyes"
			text += '. [/color]'
			#yield(sceneref.get_tree().create_timer(0.1), "timeout")
			effects.erase('resist')
			sceneref.get_node("Panel/sceneeffects").bbcode_text += sceneref.decoder(text, scenedict.givers, scenedict.takers) + '\n'

<RemoveFrom 5 5>
func dog():
#	person.penis = globals.weightedrandom([['average',1],['big',1]])

<AddTo 5>
func dog():
	person.penis = 'large'
	person.balls = 'large'
	globals.expansion.quickStrip(person) # --Ank: not sure if this is needed

<RemoveFrom 7 7>
func horse():
#	person.penis = 'big'

<AddTo 7>
func horse():
	person.penis = 'massive'
	person.balls = 'large'
	globals.expansion.quickStrip(person) # --Ank: not sure if this is needed

func startsequence(actors, mode = null, secondactors = [], otheractors = []):
	participants.clear()
	secondactorcounter.clear()
	$Panel/sceneeffects.clear()
	get_node("Control").hide()
	for person in actors:
		for i in actors + secondactors:
			if person != i:
				person.sexexp.watchers[i.id] = person.sexexp.watchers.get(i.id, 0) + 1
		person.recordInteraction()
		person.metrics.sex += 1
		###---Added by Expansion---### Person Update
		globals.expansion.updatePerson(person)
		#Temporarily Removes Clothes
		globals.expansion.quickStrip(person)
		###---Expansion End---###
		participants.append( member.new(person, self) )

	$Panel/aiallow.pressed = aiobserve
	get_node("Panel/sceneeffects").set_bbcode("You bring selected participants into your bedroom. ")
	for i in otheractors:
		while otheractors[i] > 0:
			if self.has_method(i):
				secondactorcounter[i] = secondactorcounter.get(i, 0) + 1
				call(i)
				participants[participants.size()-1].npc = true
			otheractors[i] -= 1
	
	var counter = 0
	for i in participants:
		i.person.attention = 0
		i.number = counter
		counter += 1
	turns = variables.timeforinteraction
	if actors.size() > 4:
		turns += variables.bonustimeperslavefororgy * actors.size()
		for person in actors:
			person.metrics.orgy += 1
	changecategory('caress')
	clearstate()
	rebuildparticipantslist()

func rebuildparticipantslist():
	var newnode
	var effects
	if selectmode == 'ai':
		clearstate()
	for i in get_node("Panel/ScrollContainer/VBoxContainer").get_children() + get_node("Panel/GridContainer/GridContainer").get_children() + get_node("Panel/givetakepanel/ScrollContainer/VList").get_children() + $Panel/GridContainer2/GridContainer.get_children():
		if !i.get_name() in ['Panel', 'Button', 'ControlLine']:
			i.hide()
			i.queue_free()
	for i in participants:
		newnode = get_node("Panel/ScrollContainer/VBoxContainer/Panel").duplicate()
		newnode.visible = true
		get_node("Panel/ScrollContainer/VBoxContainer").add_child(newnode)
		newnode.get_node("name").set_text(i.person.dictionary('$name'))
		newnode.get_node("name").connect("pressed",self,"slavedescription",[i])
		newnode.set_meta("person", i)
		newnode.get_node("sex").set_texture(globals.sexicon[i.person.sex])
		newnode.get_node("sex").set_tooltip(i.person.sex)
		newnode.get_node('arousal').value = i.sens
		newnode.get_node("portrait").texture = globals.loadimage(i.person.imageportait)
		newnode.get_node("portrait").connect("mouse_entered",self,'showbody',[i])
		newnode.get_node("portrait").connect("mouse_exited",self,'hidebody')
		
		if i.request != null:
			newnode.get_node('desire').show()
			newnode.get_node('desire').hint_tooltip = i.person.dictionary(requests[i.request])
		
		for k in i.effects:
			###---Added by Expansion---### Ank BugFix v4a
			if newnode.has_node(k):
				newnode.get_node(k).visible = true
			###---End Expansion---###
		
#		if ai.has(i):
#			newnode.get_node('name').set('custom_colors/font_color', Color(1,0.2,0.8))
#			newnode.get_node('name').hint_tooltip = 'Leads'
		
		newnode = get_node("Panel/givetakepanel/ScrollContainer/VList/ControlLine").duplicate()
		var giveNode = newnode.get_node("ButtonGiver")
		var takeNode = newnode.get_node("ButtonReceiver")
		giveNode.set_pressed(givers.has(i))
		takeNode.set_pressed(takers.has(i))
		giveNode.text = i.person.name_short()
		takeNode.text = i.person.name_short()
		giveNode.connect("pressed",self,'switchsides',[i, 'give'])
		takeNode.connect("pressed",self,'switchsides',[i, 'take'])
		newnode.visible = true
		get_node("Panel/givetakepanel/ScrollContainer/VList").add_child(newnode)

	
	#check for double dildo scenes between participants
	var actionarray = []
	for i in categories:
		for k in categories[i]:
			actionarray.append(k)
	actionarray.sort_custom(self, 'sortactions')
	
	var actionreplacetext = ''
	
	for i in givers:
		if i.effects.has('tied'):
			actionreplacetext = i.person.dictionary("$name is tied and can't act.")
		elif !i.subduedby.empty():
			actionreplacetext = i.person.dictionary("$name is struggling and can't act.")
		elif i.effects.has('resist'):
			actionreplacetext = i.person.dictionary("$name resists and won't follow any orders.")
		elif i.subduing != null && ((takers.size() == 1 && takers[0] != i.subduing) || takers.size() > 1 ):
			actionreplacetext = i.person.dictionary("$name is busy holding down ") + i.subduing.person.dictionary("$name \nand can only act on $him. ")
	
	var array = []
	var bottomrow =  ['rope', 'subdue', 'strapon']

	if actionreplacetext.empty():
		for i in actionarray:
			var result = checkaction(i)
			if result[0] == 'false' || i.code in ['wait'] || (selectedcategory != i.category && !i.code in bottomrow ):
				continue
			if i.code in bottomrow :
				newnode = get_node("Panel/GridContainer2/GridContainer/Button").duplicate()
				get_node("Panel/GridContainer2/GridContainer").add_child(newnode)
			else:
				newnode = get_node("Panel/GridContainer/GridContainer/Button").duplicate()
				get_node("Panel/GridContainer/GridContainer").add_child(newnode)
			newnode.visible = true
			newnode.set_text(i.getname())
			var tooltip = i.getname()
			if result.size() == 2 && !result[1].empty():
				tooltip += ' - ' + result[1]
			if i.code == 'rope':
				tooltip += '\nFree Ropes left: ' + str(globals.state.getCountStackableItem('rope'))
			if result[0] == 'disabled':
				newnode.disabled = true
			else:
				var conflicts = getConflictsWithOngoing(i)
				if !conflicts.empty():
					tooltip += '\nConflicts:'
					for idx in range(conflicts.size()):
						if idx % 3 == 0:
							tooltip += '\n     '
						tooltip += conflicts[idx].action.scene.getname() + ', '
					tooltip = tooltip.substr(0, tooltip.length() - 2)
			newnode.hint_tooltip = tooltip
			
			newnode.connect("pressed",self,'startscene',[i])
			if i.canlast == true && newnode.disabled == false:
				newnode.get_node("continue").visible = true
				newnode.get_node("continue").connect("pressed",self,'startscenecontinue',[i])
			for j in ongoingactions:
				if j.scene.code != i.code:
					continue
				if j.givers.size() != i.givers.size() || j.takers.size() != i.takers.size():
					continue
				if getIntersection(j.givers, i.givers).size() != j.givers.size():
					continue
				if getIntersection(j.takers, i.takers).size() == j.takers.size():
					newnode.get_node("continue").pressed = true
		if selectmode != 'ai':
			var noPlayerFound = true
			for member in givers:
				if member.person == globals.player:
					noPlayerFound = false
					break
			if !givers.empty() && noPlayerFound:
				newnode = get_node("Panel/GridContainer2/GridContainer/Button").duplicate()
				get_node("Panel/GridContainer2/GridContainer").add_child(newnode)
				newnode.visible = true
				if givers.size() == 1:
					newnode.set_text(givers[0].person.dictionary("Let $name Lead"))
				else:
					newnode.set_text("Let Actors Lead")
				newnode.connect("pressed",self,'activateai')
				for i in givers:
					if i.effects.has('resist') || i.effects.has('forced'):
						newnode.hint_tooltip = i.person.dictionary('$name refuses to participate. ')
						newnode.disabled = true
						break
					if i.effects.has('tied') || !i.subduedby.empty():
						newnode.hint_tooltip = i.person.dictionary("$name is immobile and can't do anything. ")
						newnode.disabled = true
						break
		else:
			newnode = get_node("Panel/GridContainer/GridContainer/Button").duplicate()
			get_node("Panel/GridContainer/GridContainer").add_child(newnode)
			newnode.visible = true
			newnode.set_text("Stop")
			newnode.connect("pressed",self,'activateai')
	else:
		newnode = Label.new()
		get_node("Panel/GridContainer/GridContainer").add_child(newnode)
		newnode.visible = true
		#newnode.disabled = true
		newnode.set_text(actionreplacetext)
	$Panel/GridContainer/GridContainer.move_child($Panel/GridContainer/GridContainer/Button, $Panel/GridContainer/GridContainer.get_child_count()-1)
	$Panel/GridContainer2/GridContainer.move_child($Panel/GridContainer2/GridContainer/Button, $Panel/GridContainer2/GridContainer.get_child_count()-1)

	var text = ''
	if givers.empty():
		text += '[...] '
	else:
		for i in givers:
			text += '[color=yellow]' + i.name + '[/color], '
	text += 'will do it ... to '

	if takers.empty():
		text += "[...]"
	else:
		for i in takers:
			text += '[color=aqua]' + i.name + '[/color], '
		text = text.substr(0, text.length() -2)+ '. '

	###---Added by Expansion---### Incest Text Reveal
	#Wear and Tear Variables
#	var vagused
#	var assused
	var lastaction
	for i in givers:
		for k in takers:
			#Giver Attraction
			if globals.expansion.getSexualAttraction(i.person,k.person) == true:
				text += '\n[color=yellow]' + i.name + '[/color] is attracted to [color=aqua]' + k.name + '[/color] and will enjoy interactions with ' + k.person.dictionary(' $him.')
			else:
				text += '\n[color=yellow]' + i.name + "[/color] is [color=red]not[/color] attracted to " + '[color=aqua]' + k.name + "[/color] and will not enjoy interactions with " + k.person.dictionary(' $him.')
			#Giver Incest
			var related = str(globals.expansion.relatedCheck(i.person, k.person))
			if related != 'unrelated':
				if i.person != globals.player:
					text += '\n[color=yellow]' + i.name + i.person.dictionary('[/color] feels that being with $his [color=aqua]') + related + '[/color], [color=aqua]' + k.name + '[/color], would be ' + str(i.person.fetish.incest) + '.'
			#Taker Attraction
			if globals.expansion.getSexualAttraction(k.person,i.person) == true:
				text += '\n[color=aqua]' + k.name + '[/color] is attracted to [color=aqua]' + i.name + '[/color] and will enjoy interactions with ' + i.person.dictionary(' $him.')
			else:
				text += '\n[color=aqua]' + k.name + "[/color] is [color=red]not[/color] attracted to " + '[color=aqua]' + i.name + "[/color] and will not enjoy interactions with " + i.person.dictionary(' $him.')
			#Taker Incest
			related = str(globals.expansion.relatedCheck(k.person, i.person))
			if related != 'unrelated':
				if k.person != globals.player:
					text += '\n[color=aqua]' + k.name + k.person.dictionary('[/color] feels that being with $his [color=aqua]') + related + '[/color], [color=aqua]' + i.name + '[/color], would be ' + str(k.person.fetish.incest) + '.'
		#---Wear and Tear
		if i.vagTorn == true:
			text += i.person.dictionary("\n[color=red]$name's [color=aqua]pussy[/color] has been stretched beyond its limit. Penetration arousal gains reduced.[/color]")
		if i.assTorn == true:
			text += i.person.dictionary("\n[color=red]$name's [color=aqua]asshole[/color] has been stretched beyond its limit. Penetration arousal gains reduced.[/color]")
	for i in takers:
		#---Wear and Tear
		if i.vagTorn == true:
			text += i.person.dictionary("\n[color=red]$name's [color=aqua]pussy[/color] has been stretched beyond its limit. Penetration arousal gains reduced.[/color]")
		if i.assTorn == true:
			text += i.person.dictionary("\n[color=red]$name's [color=aqua]asshole[/color] has been stretched beyond its limit. Penetration arousal gains reduced.[/color]")
#		text += "\n"
	###---Expansion End---###

	text += "\n\n"
	for i in ongoingactions:
		text += decoder(i.scene.getongoingname(i.givers,i.takers), i.givers, i.takers) + ' [url='+str(ongoingactions.find(i))+'][Interrupt][/url]\n'
	
	get_node("Panel/passbutton").set_disabled( givers.empty() && selectmode != 'ai' )
	
	if selectmode == 'ai':
		$Panel/passbutton.set_text("Observe")
	else:
		$Panel/passbutton.set_text("Pass")
	
	get_node("TextureFrame/Label").set_text(str(turns))
	
	get_node("Panel/sceneeffects1").set_bbcode(text)
	
	globals.state.actionblacklist = filter
	
	if turns == 0:
		endencounter()

var categoriesorder = ['caress', 'fucking', 'tools', 'SM', 'humiliation']

var requests = {
	pet = "$name wishes to be touched.",
	petgive = '$name wishes to touch.',
	fuck = '$name wishes to be penetrated.',
	fuckgive = '$name wishes to penetrate.',
	pussy = "$name wishes to have $his pussy used.",
	penis = '$name wishes to use $his penis.',
	anal = '$name wishes to have $his ass used.',
	punish = '$name wishes to be punished.',
	humiliate = '$name wishes to be humiliated.',
	group = '$name wishes to have multiple partners.',
	cumonface = '$name wants to feel cum on $his face.',
	cuminmouth = '$name wants to taste cum in $his mouth.',
	cumonbody = '$name wants to feel cum on $his body.',
	cuminpussy = '$name wants to feel cum inside $his pussy.',
	cuminass = '$name wants to feel cum inside $his asshole.',
	punishother = '$name needs to punish someone.',
	humiliateother = '$name wishes to humiliate someone.',
	stop = '$name just wants this to stop.'
}

func generaterequest(member):
	var rval = requests.keys()

#	for i in requests:
#		rval.append(i)

	###---Added by Expansion---### Fetishes
	var refFetish = member.person.fetish
	var checkmod
	
	#Creampie Mouth | Cum Drinking
	if member.person.cum.mouth > 0:
		rval.erase('cuminmouth')
	else:
		checkmod = globals.fetishopinion.find(refFetish.creampiemouth)-3
		if member.person.checkFetish('creampiemouth', checkmod, false, false):
			while checkmod > 0:
				rval.append('cuminmouth')
				checkmod -= 1
		checkmod = globals.fetishopinion.find(refFetish.drinkcum)-3
		if member.person.checkFetish('drinkcum', checkmod, false, false):
			while checkmod > 0:
				rval.append('cuminmouth')
				checkmod -= 1
	
	#Creampie Pussy | Pregnancy
	if member.person.vagina == "none" || member.person.vagvirgin == true || member.person.cum.pussy > 0:
		rval.erase('cuminpussy')
	else:
		checkmod = globals.fetishopinion.find(refFetish.creampiepussy)-3
		if member.person.checkFetish('creampiepussy',checkmod, false, false):
			while checkmod > 0:
				rval.append('cuminpussy')
				checkmod -= 1
		checkmod = globals.fetishopinion.find(refFetish.pregnancy)-3
		if member.person.checkFetish('pregnancy',checkmod, false, false):
			while checkmod > 0:
				rval.append('cuminpussy')
				checkmod -= 1
	
	#Creampie Ass
	if member.person.assvirgin == true || member.person.cum.ass > 0:
		rval.erase('cuminass')
	else:
		checkmod = globals.fetishopinion.find(refFetish.creampieass)-3
		if member.person.checkFetish('creampieass', checkmod, false, false):
			while checkmod > 0:
				rval.append('cuminass')
				checkmod -= 1

	#Cum on Face
	if member.person.cum.face > 0:
		rval.erase('cumonface')
	else:
		checkmod = globals.fetishopinion.find(refFetish.wearcumface)-3
		if member.person.checkFetish('wearcumface', checkmod, false, false):
			while checkmod > 0:
				rval.append('cumonface')
				checkmod -= 1

	#Cum on Body
	if member.person.cum.body > 0:
		rval.erase('cumonbody')
	else:
		checkmod = globals.fetishopinion.find(refFetish.wearcum)-3
		if member.person.checkFetish('wearcum', checkmod, false, false):
			while checkmod > 0:
				rval.append('cumonbody')
				checkmod -= 1

	#Trait Additions
	if member.person.assvirgin == true:
		rval.erase('anal')
	elif member.person.traits.has('Enjoys Anal'):
		rval.append('anal')
	
	var checkmod2
	#Dominance
	checkmod = globals.fetishopinion.find(refFetish.dominance)-3
	checkmod2 = globals.fetishopinion.find(refFetish.submission)-3
	if checkmod >= checkmod2:
		if member.person.traits.has('Dominant'):
			rval.erase('humiliate')
			rval.append('humiliateother')
		elif checkmod > checkmod2:
			rval.erase('humiliate')
		if member.person.checkFetish('dominance', checkmod, false, false):
			var temp = checkmod # still need checkmod for submission checks
			while temp > 0:
				rval.append('humiliateother')
				temp -= 1

	#Submission
	if checkmod <= checkmod2:
		if member.person.traits.has('Submissive'):
			rval.erase('humiliateother')
			rval.append('humiliate')
		elif checkmod < checkmod2:
			rval.erase('humiliateother')
		if member.person.checkFetish('submission', checkmod2, false, false):
			while checkmod2 > 0:
				rval.append('humiliate')
				checkmod2 -= 1

	
	#Sadism
	checkmod = globals.fetishopinion.find(refFetish.sadism)-3
	checkmod2 = globals.fetishopinion.find(refFetish.masochism)-3
	if checkmod >= checkmod2:
		if member.person.traits.has('Likes it rough'):
			if member.person.traits.has('Sadist'):
				rval.append('punishother')
		elif member.person.traits.has('Sadist'):
			rval.erase('punish')
			rval.append('punishother')
		elif checkmod > checkmod2:
			rval.erase('punish')
		if member.person.checkFetish('sadism', checkmod, false, false):
			var temp = checkmod
			while temp > 0:
				rval.append('punishother')
				temp -= 1
	
	#Masochism
	if checkmod <= checkmod2:
		if member.person.traits.has('Masochist'):
			rval.erase('punishother')
			rval.append('punish')
		elif checkmod < checkmod2:
			rval.erase('punishother')
		if member.person.checkFetish('masochism', checkmod2, false, false):
			while checkmod2 > 0:
				rval.append('punish')
				checkmod2 -= 1


	#This function requires consent, so 'stop' is not relevant
	rval.erase('stop')

	#Vanilla with Additions
	if member.person.vagina == 'none' || member.person.vagvirgin == true:
		rval.erase('fuck')
	if member.person.vagina == 'none':
		rval.erase('pussy')
	if member.person.assvirgin == true:
		rval.erase('anal')
	if member.person.penis == 'none':
		rval.erase('penis')
		if member.strapon == null:
			rval.erase('fuckgive')
	if member.person.traits.has('Monogamous') || participants.size() == 2 || (!member.person.traits.has('Fickle') && member.lewd < 50):
		rval.erase('group')
	###---End Expansion---###


	rval = rval[randi()%rval.size()]
	###---Added by Expansion---### Centered/Set Alerted Text
	$Panel/sceneeffects.bbcode_text += ("\n[center][color=#f4adf4]Desire! -  " + member.person.dictionary(requests[rval]) + '[/color][/center]\n')
	###---End Expansion---###
	member.request = rval

func checkrequest(member):

	if member.request == null:
		return false

	var conditionsatisfied = false

	var lastaction = member.lastaction

	match member.request:
		'pet':
			if lastaction.takers.has(member) && lastaction.scene.get('takertags') != null && lastaction.scene.takertags.has('pet'):
				conditionsatisfied = true
		'petgive':
			if lastaction.givers.has(member) && lastaction.scene.get('givertags') != null && lastaction.scene.givertags.has('pet'):
				conditionsatisfied = true
		'fuck':
			if lastaction.takers.has(member) && lastaction.scene.get('takertags') != null && lastaction.scene.takertags.has('penetration'):
				conditionsatisfied = true
		'fuckgive':
			if lastaction.givers.has(member) && lastaction.scene.get('takertags') != null && lastaction.scene.takertags.has('penetration'):
				conditionsatisfied = true
		'pussy':
			if lastaction.scene.get('givertags') != null && (lastaction.scene.givertags.has('vagina') || lastaction.scene.takertags.has('vagina')) :
				conditionsatisfied = true
		'penis':
			if lastaction.scene.get('givertags') != null && (lastaction.scene.givertags.has('penis') || lastaction.scene.takertags.has('penis')) :
				conditionsatisfied = true
		'anal':
			if lastaction.scene.get('givertags') != null && (lastaction.scene.givertags.has('anal') || lastaction.scene.takertags.has('anal')) :
				conditionsatisfied = true
		'punish':
			if lastaction.takers.has(member) && lastaction.scene.get('takertags') != null && lastaction.scene.takertags.has('punish'):
				conditionsatisfied = true
				for i in range(2):
					member.person.dailyevents.append('masochism')
		'humiliate':
			if lastaction.takers.has(member) && lastaction.scene.get('takertags') != null && lastaction.scene.takertags.has('shame'):
				conditionsatisfied = true
				for i in range(2):
					member.person.dailyevents.append('submission')
		'group':
			if (lastaction.givers.has(member) && lastaction.takers.size() > 1) || (lastaction.takers.has(member) && lastaction.givers.size() > 1):
				conditionsatisfied = true

		###---Added by Expansion---### Fetishes
		'stop':
			#normal reward does not seem appropriate, maybe add something else
			return false
			#if !lastaction.takers.has(member) && !lastaction.givers.has(member):
			#	conditionsatisfied = true
		'cumonface':
			if member.person.cum.face > 0:
				conditionsatisfied = true
				for i in range(2):
					member.person.dailyevents.append('wearcumface')
		'cuminmouth':
			if member.person.cum.mouth > 0:
				conditionsatisfied = true
				for i in range(2):
					member.person.dailyevents.append('creampiemouth')
					member.person.dailyevents.append('drinkcum')
		'cumonbody':
			if member.person.cum.body > 0:
				conditionsatisfied = true
				for i in range(2):
					member.person.dailyevents.append('wearcum')
		'cuminpussy':
			if member.person.cum.pussy > 0:
				conditionsatisfied = true
				for i in range(2):
					member.person.dailyevents.append('creampiepussy')
				member.person.dailyevents.append('pregnancy')
		'cuminass':
			if member.person.cum.ass > 0:
				conditionsatisfied = true
				for i in range(2):
					member.person.dailyevents.append('creampieass')
		'punishother':
			if lastaction.givers.has(member) && lastaction.scene.get('takertags') != null && lastaction.scene.takertags.has('punish'):
				conditionsatisfied = true
				for i in range(2):
					member.person.dailyevents.append('sadism')
		'humiliateother':
			if lastaction.givers.has(member) && lastaction.scene.get('takertags') != null && lastaction.scene.takertags.has('shame'):
				conditionsatisfied = true
				for i in range(2):
					member.person.dailyevents.append('dominance')
		###---End Expansion---###

	if conditionsatisfied == true:
		member.request = null
		member.requestsdone += 1
		#$Panel/sceneeffects.bbcode_text += '[color=green]Wish satisfied.[/color]\n'
		#globals.resources.mana += 10
		if member.person.traits.has("Monogamous") && lastaction.takers.size() == 1 && lastaction.givers.size() == 1 && (lastaction.givers[0].person == globals.player || lastaction.takers[0].person == globals.player):
			member.person.loyal += rand_range(7,14)
		else:
			member.person.loyal += rand_range(5,10)
		member.lewd += rand_range(3,6)
		member.sensmod += 0.2
	return conditionsatisfied

func checkaction(action):
	action.givers = givers
	action.takers = takers
	###---Added by Expansion---###
	var related
	###---Expansion End---###
	if action.requirements() == false || filter.has(action.code):
		return ['false']
#	elif doubledildocheck() && action.category in ['caress','fucking'] && !action.code in ['doubledildo','doubledildoass','tribadism','frottage']:
#		return ['false']
	if action.category in ['SM','tools','humiliation']:
		for k in givers+takers:
			if k.limbs == false:
				return ['false']
	var disabled = false
	var hint_tooltip = ''
	for k in givers:
		related = false
		if k.person == globals.player || k.person.unique in ['dog','horse']:
			continue
		if action.giverconsent != 'any' && k.effects.has('resist'):
			disabled = true
			hint_tooltip = k.person.dictionary("$name refuses to perform this action (high resistance: low obedience, loyalty, or lust)")
			continue
		elif action.giverconsent == 'advanced' && k.lewd < 50:
			disabled = true
			hint_tooltip = k.person.dictionary("$name refuses to perform this action (low lewdness)")
			continue
	###---Added by Expansion---### Incest Check
		for i in takers:
			if i != k:
				if globals.expansion.relatedCheck(k.person,i.person) != "unrelated":
					related = true
		if related == true && k.person.consentexp.incest == false && k.person != globals.player:
			if k.mode != 'forced' && !k.effects.has('tied'):
				disabled = true
				hint_tooltip = k.person.dictionary("$name refuses to perform this incestuous action with a family member (incest consent not given)")
				continue
	###---Expansion End---###
	for k in takers:
		if k.person == globals.player || k.person.unique in ['dog','horse']:
			continue
		if action.takerconsent == 'any' && k.effects.has('resist') && action.code != 'subdue':
			if k.subduedby.empty() && !k.effects.has('tied') || (action.code == 'deepthroat' && k.acc1 == null):
				hint_tooltip = k.person.dictionary("$name refuses to perform this action (high resistance: low obedience, loyalty, or lust)")
				disabled = true
			else:
				hint_tooltip = k.person.dictionary("$name refuses to perform this action, but is being restrained")
		elif action.takerconsent != 'any' && k.effects.has('resist'):
			disabled = true
			hint_tooltip = k.person.dictionary("$name refuses to perform this action (high resistance: low obedience, loyalty, or lust)")
		elif action.takerconsent == 'advanced' && k.lewd < 50:
			disabled = true
			hint_tooltip = k.person.dictionary("$name refuses to perform this action (low lewdness)")
	if disabled:
		return ['disabled',hint_tooltip]
	else:
		return ['allowed',hint_tooltip]

func startscene(scenescript, cont = false, pretext = ''):
	var textdict = {mainevent = pretext, repeats = '', orgasms = '', speech = ''}
	var pain = 0
	var effects
	scenescript.givers = givers
	scenescript.takers = takers
	turns -= 1
	
	for i in givers + takers:
		if i.effects.has('resist') && scenescript.code != 'subdue':
			var result = resistattempt(i)
			textdict.mainevent += result.text
			if result.consent == false:
				get_node("Panel/sceneeffects").bbcode_text += (textdict.mainevent + "\n" + textdict.repeats)
				rebuildparticipantslist()
				return
	
	for i in givers + takers:
		if isencountersamesex(givers,takers,i) == true:
			i.actionshad.samesex += 1
		else:
			i.actionshad.oppositesex += 1
		var refXp = i.person.sexexp
		refXp.actions[scenescript.code] = refXp.actions.get(scenescript.code,0) + 1
		for k in givers + takers:
			if k != i:
				refXp.partners[k.person.id] = refXp.partners.get(k.person.id,0) + 1
	
	for i in participants:
		i.orgasm = false
		if !givers.has(i) && !takers.has(i):
			i.person.sexexp.seenactions[scenescript.code] = i.person.sexexp.seenactions.get(scenescript.code,0) + 1
	
	
	#temporary support for scenes converted to centralized output and those not
	#should be unified in the future
	var centralized = false
	if scenescript.has_method('initiate'):
		textdict.mainevent += decoder(scenescript.initiate(), givers, takers)
	else:
		centralized = true
		textdict.mainevent += output(scenescript, scenescript.initiate, givers, takers) + output(scenescript, scenescript.ongoing, givers, takers)
		
	
	if centralized == false:
		if scenescript.has_method('reaction'):
			for i in takers:
				textdict.mainevent += '\n' + decoder(scenescript.reaction(i), givers, [i])
	elif scenescript.reaction != null:
			for i in takers:
				textdict.mainevent += '\n' + output(scenescript, scenescript.reaction, givers, [i])
	
	###---Added by Expansion---### Vagina/Ass Size Assignment on Virginity Loss
	#remove virginity if relevant
	if scenescript.virginloss == true:
		for i in givers:
			if scenescript.giverpart == 'vagina':
				###---Added by Expansion---### DimCrystal Virginity
				if i.person.vagvirgin == true:
					i.person.vagvirgin = false
					i.virginity_multiplier += 5
				###---End Expansion---###
				if i.person.vagina == 'normal':
					i.person.vagina = globals.randomfromarray(globals.vagsizearray)
			elif scenescript.giverpart == 'anus':
				###---Added by Expansion---### DimCrystal Virginity
				if i.person.assvirgin == true:
					i.person.assvirgin = false
					i.virginity_multiplier += 5
				###---End Expansion---###
				if i.person.asshole == 'normal':
					i.person.asshole = globals.randomfromarray(globals.assholesizearray)
		for i in takers:
			if scenescript.takerpart == 'vagina':
				###---Added by Expansion---### DimCrystal Virginity
				if i.person.vagvirgin == true:
					i.person.vagvirgin = false
					i.virginity_multiplier += 5
				###---End Expansion---###
				if i.person.vagina == 'normal':
					i.person.vagina = globals.randomfromarray(globals.vagsizearray)
			elif scenescript.takerpart == 'anus':
				###---Added by Expansion---### DimCrystal Virginity
				if i.person.assvirgin == true:
					i.person.assvirgin = false
					i.virginity_multiplier += 5
				###---End Expansion---###
				if i.person.asshole == 'normal':
					i.person.asshole = globals.randomfromarray(globals.assholesizearray)
	###---End Expansion---###
	
	
	var dict = {'scene' : scenescript, 'takers' : takers.duplicate(), 'givers' : givers.duplicate()}
	
	if scenescript.code in ['strapon', 'nippleclap', 'clitclap', 'ringgag', 'blindfold', 'nosehook', 'vibrator', 'analvibrator', 'rope', 'milker', 'subdue', 'relaxinginsense']:
		cont = true

	var conflicts = getConflictsWithOngoing(scenescript)
	for c in conflicts:
		stopongoingaction(c.action)

	if scenescript.giverpart != '':
		for i in givers:
			#print(i.name + " " + str(i[scenescript.giverpart]) + str(scenescript.giverpart))
			i[scenescript.giverpart] = dict
	
	if scenescript.takerpart != '':
		for i in takers:
			i[scenescript.takerpart] = dict
	
	if scenescript.get('takerpart2'):
		for i in takers:
			i[scenescript.takerpart2] = dict
	
	for i in givers: 
		if scenescript.has_method('givereffect'):
			effects = scenescript.givereffect(i)
			i.actioneffect(effects[0], effects[1], dict)
		i.lube()
		
	for i in takers:
		if scenescript.has_method('takereffect'):
			effects = scenescript.takereffect(i)
			i.actioneffect(effects[0], effects[1], dict)
		i.lube()
	
	var sceneexists = false
	var temptext = ''
	for i in ongoingactions:
		temptext = ''
		if i.givers == givers && i.takers == takers && i.scene == scenescript:
			sceneexists = true
		elif i.scene.has_method('getongoingdescription'):
			temptext = decoder(i.scene.getongoingdescription(i.givers, i.takers), i.givers, i.takers)
		else:
			temptext = output(i.scene, i.scene.ongoing, i.givers, i.takers)
		if temptext != '':
			textdict.repeats += '\n' + temptext
	textdict.repeats = textdict.repeats.replace("[color=yellow]", '').replace('[color=aqua]', '').replace('[/color]','')
	
	
	for i in ongoingactions:
		for k in i.givers + i.takers:
			k.person.sexexp.actions[i.scene.code] += 1
			for j in i.givers + i.takers:
				if j != k:
					if k.person.sexexp.partners.has(j.person.id):
						k.person.sexexp.partners[j.person.id] += 1
					else:
						k.person.sexexp.partners[j.person.id] = 1
		for k in participants:
			if !i.givers.has(k) && !i.takers.has(k):
				if k.person.sexexp.seenactions.has(i.scene.code):
					k.person.sexexp.seenactions[i.scene.code] += 1
				else:
					k.person.sexexp.seenactions[i.scene.code] = 1
		if i.scene.has_method("givereffect"):
			for member in i.givers:
				effects = i.scene.givereffect(member)
				member.actioneffect(effects[0], effects[1], i)
		if i.scene.has_method("takereffect"):
			for member in i.takers:
				effects = i.scene.takereffect(member)
				member.actioneffect(effects[0], effects[1], i)
	
	
	var request
	
	for i in participants:
		if i in givers+takers:
			i.lastaction = dict
			request = checkrequest(i)
			if request == true:
				textdict.orgasms += decoder("[color=aqua]Desire fulfilled! [name1] grows lewder and more sensitive. [/color]\n", [i], [i])
#			if i.sens >= 1000:
#				textdict.orgasms += triggerorgasm(i)
#				i.orgasm = true
#			else:
#				i.orgasm = false
		else:
			for j in ongoingactions:
				if i in j.givers + j.takers:
					i.lastaction = j
#					if i.sens >= 1000:
#						textdict.orgasms += triggerorgasm(i)
#						i.orgasm = true
#					else:
#						i.orgasm = false
		if not i.lastaction in ongoingactions:
			i.lastaction = null
		
	
	if cont == true && sceneexists == false: 
		ongoingactions.append(dict)
		for i in givers + takers:
			i.activeactions.append(dict)
	else:
		for i in givers:
			if scenescript.giverpart != '':
				i[scenescript.giverpart] = null
		for i in takers:
			if scenescript.takerpart != '':
				i[scenescript.takerpart] = null
	
	var x = (givers.size()+takers.size())/2
	
	while x > 0:
		if randf() < 0.3: #0.3
			var charspeech = characterspeech(dict)
			if charspeech.text != '':
				textdict.speech += charspeech.character.name + ': ' + decoder(charspeech.text, [charspeech.character], [charspeech.partner]) + '\n'
		x -= 1
	
	
	var text = textdict.mainevent + "\n" + textdict.repeats + '\n' + textdict.speech + textdict.orgasms
#	temptext = ''
#	while text.length() > 0:
#		if !text.begins_with('%'):
#			if text.find('%') >= 0:
#				temptext = text.substr(0,text.find('%'))
#			else:
#				temptext = text
#			text = text.replace(temptext, '')
#			$Panel/sceneeffects.append_bbcode(temptext)
#		else:
#			var string = text.substr(text.find("%"), 2)
#			add_portrait_to_text(participants[int(string.substr(1,1))])
#			text.erase(0,2)
		#print($Panel/sceneeffects.text)
		#get_node("Panel/sceneeffects").add_text()
	#$Panel/sceneeffects.bbcode_enabled = true
	get_node("Panel/sceneeffects").bbcode_text += '\n' + text
	
	
	
	var temparray = []
	
	for i in participants:
		#High Chance to Request to Stop if Forced
		if i.effects.has('forced'):
			if i.request == 'stop':
				if !i.effects.has('resist'):
					i.request = null
			elif i.effects.has('resist') && !i.person.traits.has('Likes it rough') && randf() < 0.66:
				$Panel/sceneeffects.bbcode_text += ("[color=#f4adf4]Desire: " + i.person.dictionary(requests.stop) + '[/color]\n')
				i.request = 'stop'
			continue
		elif i.person == globals.player || i.person.unique in ['dog','horse'] || i.effects.has('resist'):
			continue
		temparray.append(i)
	
	
	if randf() < 0.15 && temparray.size() > 0:
		generaterequest(temparray[randi()%temparray.size()])
	
	rebuildparticipantslist()

func characterspeech(scene, details = []):
	var partner
	var partnerside
	var array = [] #serves as RNG pool for partners and speech

	for i in scene.takers+scene.givers:
		if i.person != globals.player:
			array.append(i)
	var character = array[randi()%array.size()] #who speaks
	
	if character in scene.takers:
		partnerside = 'givers'
	else:
		partnerside = 'takers'
	
	if !scene[partnerside].empty():
		partner = scene[partnerside][randi()%scene[partnerside].size()]
	
	var dict = {}
	var cp = character.person
	###---Added by Expansion---### Expanded Dialogue, Added Incest Support
	var prevailing_lines_expanded = ['mute', 'silence', 'orgasm', 'resistorgasm', 'pain', 'painlike', 'resist', 'blowjob', 'incest', 'incestlike','incestorgasm']

	if cp.traits.has('Mute'):
		dict.mute = [expandedspeechdict.mute, 1]
	if cp.traits.has('Sex-crazed'):
		dict.sexcrazed = [expandedspeechdict.sexcrazed, 1]
	if cp.traits.has('Enjoys Anal'):
		dict.enjoysanal = [expandedspeechdict.enjoysanal, 1]
	if cp.traits.has('Likes it rough'):
		dict.rough = [expandedspeechdict.rough, 1]
	if cp.rules.silence == true:
		dict.silence = [expandedspeechdict.silence, 1]
	if character.effects.has('resist'):
		dict.resist = [expandedspeechdict.resist, 1]
		if scene.scene.code in ['missionaryanal', 'doggyanal', 'lotusanal','revlotusanal', 'inserttaila', 'insertinturnsass']  && partnerside == 'givers':
			dict.analrape = [expandedspeechdict.analrape, 1]
	if character.orgasm == true:
		if character.effects.has('resist'):
			dict.resistorgasm = [expandedspeechdict.resistorgasm, 1]
		else:
			dict.orgasm = [expandedspeechdict.orgasm, 1]
	if scene.scene.code in ['blowjob'] && partnerside == 'takers':
		dict.mouth = [expandedspeechdict.blowjob, 1]
	if scene.scene.code in ['blowjob','spitroast'] && partnerside == 'givers':
		dict.mouth = [expandedspeechdict.blowjobtake, 1]
	if scene.scene.code in ['missionary', 'doggy', 'lotus', 'revlotus', 'inserttailv', 'insertinturns'] && partnerside == 'givers':
		dict.vagina = [expandedspeechdict.vagina, 1]
	if scene.scene.code in ['missionaryanal', 'doggyanal', 'lotusanal','revlotusanal', 'inserttaila', 'insertinturnsass'] && partnerside == 'givers':
		dict.anal = [expandedspeechdict.anal, 1]
	if partner != null && (!cp.traits.has('Homosexual') && !cp.traits.has("Bisexual")) && globals.kinseyscale.find(character.sexuality) < 3 && character.sex != 'male' && partner.sex != 'male' && partnerside == 'givers':
		dict.nonlesbian = [expandedspeechdict.nonlesbian, 1]
	if scene.scene.get("takertags") && scene.scene.takertags.has("pain") && partnerside == 'givers' && !cp.traits.has('Likes it rough') && !cp.traits.has("Masochist"):
		if character.effects.has('resist'):
			dict.pain = [expandedspeechdict.pain, 2.5]
		else:
			dict.painlike = [expandedspeechdict.painlike, 2.5]
	#Incest Support / Family Matters
	var relation = 'unrelated' if partner == null else globals.expansion.relatedCheck(cp, partner.person)
	if relation != 'unrelated' && cp != globals.player:
		if globals.fetishopinion.find(cp.fetish.incest)-4 > 0:
			dict.incestlike = [expandedspeechdict.incestlike, 2.5]
		else:
			dict.incest = [expandedspeechdict.incest, 2.5]
	if character.orgasm == true && relation != 'unrelated' && cp != globals.player:
		dict.incestorgasm = [expandedspeechdict.incestorgasm, 3]
	dict.moans = [expandedspeechdict.moans, 0.25]

	for i in prevailing_lines_expanded:
		if dict.has(i):
			array = [dict[i]]
			dict.clear() 
			break
	###---End Expansion---###
	if !dict.empty():
		array = dict.values()
	var text = globals.weightedrandom(array)
	if text != null:
		text = text[randi()%text.size()]
	
	if text != null && partner != null:
		if partner.person == globals.player || cp.traits.has("Monogamous"):
			text = text.replace('[name2]', cp.getMasterNoun())
		else:
			text = text.replace('[name2]', partner.name)
		###---Added by Expansion---### Changed from lime to yellow to match the rest of the text
		text = '[color=yellow]' + text + '[/color]'
		###---End Expansion---###
	else:
		text = ''
	
	###---Added by Expansion---### Quirked
	text = text.replace('[relation]', relation)
	
	cp.quirk(text)
	###---End Expansion---###

	return {'text' : text, 'character' : character, 'partner' : partner, lastrelation = relation}

var expandedspeechdict = {
	resist = ["Stop it!", "No... I don't want to!", "Why are you doing this...", "You, bastard...", "Let me go!"],
	resistorgasm = ["Ahh-hh... No...", "*Sob* why... this feels so good...", "No, Please stop, before I... Ahh... No *sob*","No! Stop! Why...Why is my body not listeninnnnAAAH!"],
	mute = ['...', '...!', '......', '*gasp*'],
	blowjob = ["Does it feel good? *slurp*", "Mh-m... this smell...", "Does this feel good, [name2]?", "You like my mouth, [name2]?"],
	blowjobtake = ["Like my cock, [name2]?" , "Yes, suck it, dear...", "Mmmm, suck it like that."],
	inexperienced = ["I've never done this...", "What's this?", "Not so fast, [name2], I'm new to this..."],
	#virgin = ["Aaah! My first time...", "My first time...", "My first time... you took it..."],
	vagina = ["Ah! Yes! Fuck my pussy!", "Yes, fill me up, [name2]!", "More, give me more, [name2]!", "Ah, this is so good, [name2]..."],
	anal = ["My {^ass:butt}... feels good...", "Ah... My {^ass:butt}...", "Keep {^fucking:ravaging:grinding} my {^ass:butt}, [name2]..."],
	orgasm = ["Cumming, I'm cumming!..", "Ah, Ahh, AAAHH!","[name2], please hold me, I'm cumming!"],
	analrape = ["Stop! Where are you putting it!?", "No, please, not there!", "No, not my {^ass:butt}... I beg you..."],
	sexcrazed = ["Your {^dick:cock:penis}... Yes...", "Give me your {^dick:cock:penis}, [name2]... I need it", "Fuck me, [name2], I begging you!.."],
	nonlesbian = ["No, we shouldn't...", "No, we are both girls...","[name2], Ah, stop, I'm not into girls..."],
	enjoysanal = ["Please, put my {^butt:ass} into a good use, [name2]...", "I want it in my {^butt:ass}..."],
	rough = ["[name2], do me harder...", "Yes... Please, abuse me!"],
	pain = ["Ouch! It hurts...", "Please, no more...", "*sob*", 'It hurts...', '[name2], please, stop...'],
	painlike = ["Umh... Yes, hit me harder...", "Yes, [name2], punish me...", "Ah... this strings... nicely..."],
	silence = ['Mmhmm...', '*gasp*', 'Mhm!!','MMMM!'],
	moans = ["Ah...", "Oh...", "Mmmh...", "[name2]..."],
	incestlike = ["I can't believe that I am {^fucking:having sex with:being intimate with} my [relation], I feel so lucky!", "Oh...[relation]","Mmmh...[relation]", "[name2]...{^fuck me:rail me:overwhelm me} like only my [relation] can..."],
	incest = ["Wait, [relation], we should {^stop:hold off:stop this:not do this}! Even if it...does...{^feel good:make me feel good:make me tingly}","[relation], {^this is wrong:we can't do this:this is illegal:this is against the gods}!", "This...this isn't suppose to feel good, [relation]!","Please, [relation], stop this...{^before it's too late:before I can't:because I can't}."],
	incestorgasm = ["Oh...oh [relation]! Slow...slow down, or I'll...I'll -NNNGGGH!","I'm...I'm going to cu-cu-CUUUM! Fuck, [relation]!", "Wait...wait! [relation]! NNNGH! *huff huff* NGGGGGGHHH!!!","I'm cumming, [relation]!","I...can't stop! I going t-t-to...CUUUM!"]
}

###---Added by Expansion---### Modified by Deviate
func impregnationcheck(person1, person2):
	var valid = true
	if person1.unique in ['dog','horse']:
		person2.metrics.animalpartners += 1
	elif person2.unique in ['dog','horse']:
		person1.metrics.animalpartners += 1
	return valid
###---End of Expansion---###

###---Added by Expansion---###
# returns true if person1 feels that person2 is the same sex; this subjectiveness can be relevant when person2 is futanari or dickgirl
func ispairsamesex(person1, person2):
	var sex1 = person1.sex
	var sex2 = person2.sex
	if sex1 == 'futanari' || sex1 == 'dickgirl':
		if globals.expansionsettings.futasexualityshift == 'bi':
			return globals.kinseyscale.find(person1.sexuality) < 3
		sex1 = globals.expansionsettings.futasexualityshift
	if sex2 == 'futanari' || sex2 == 'dickgirl':
		if globals.expansionsettings.futasexualityshift == 'bi':
			return globals.kinseyscale.find(person1.sexuality) < 3
		return sex1 == globals.expansionsettings.futasexualityshift
	return sex1 == sex2
###---End of Expansion---###

func isencountersamesex(givers, takers, actor = null):
	var groupOther
	if givers.has(actor):
		groupOther = takers
	elif takers.has(actor):
		groupOther = givers
	else:
		return false
	var score = 0
	for i in groupOther:
		score += 1 if ispairsamesex(actor.person, i.person) else -1
	return score > 0

func endencounter():
	var mana = 0
	var totalmana = 0
	var manaDict = {}
	var text = ''
	###---Added by Expansion---### Clamper
	var clamper = 0
	var rewardtext = ''
	###---End Expansion---###
	for i in participants:
		if i.person.unique in ['dog','horse']:
			continue
		i.person.lewdness = i.lewd
		if i.orgasms > 0:
			#ralphC
			if i.person.race_display == 'Succubus':
				i.person.lust = round(i.person.lust * 0.75) #ralphC - Succubus orgasms don't give enough relief to prevent going sex-crazed if too hungery
			else:
				i.person.lust = 0 
			#/ralphC
		else:
			i.person.lust = i.sens/10
		i.person.lastsexday = globals.resources.day

		###---Added by Expansion---### Incest, Tearing, and Swollen tracking
		#Orgasm Variable Text
		var position = ""
		if i.person == globals.player:
			text += "You had [color=aqua]" + str(i.orgasms) + "[/color] orgasms."
		else: # !(i.person.unique in ['dog','horse']):
			text += "\n$name "
			if i.orgasms >= 1 + i.person.send + i.person.sstr:
				position = "ground"
				text += globals.randomfromarray(['lies','is curled up','is in the fetal position','tries to move but falls back']) + " on the " + globals.randomfromarray(['floor ','ground ','fluid-soaked floor ','fluid-soaked ground ','stained floor ','stained ground ']) + globals.randomfromarray(['twitching ','spasming ','moaning ','motionless '])
			elif i.orgasms >= 1 + round(i.person.send * .5):
				position = "knees"
				text += globals.randomfromarray(['manages to get on $his hands and knees','is on $his knees','manages to squat','weakly stands up']) + " from the " + globals.randomfromarray(['floor ','ground ','fluid-soaked floor ','fluid-soaked ground ','stained floor ','stained ground '])
			elif i.orgasms == 0:
				position = "standing"
				text += globals.randomfromarray(['angrily stands up','seems upset as $he stands','frustratedly pushes $himself up','grumpily stands up']) + " from the " + globals.randomfromarray(['floor ','ground '])
			else:
				position = "standing"
				text += globals.randomfromarray(['stands up','slowly stands','pushes $himself up','stands up']) + " from the " + globals.randomfromarray(['floor ','ground ','fluid-soaked floor ','fluid-soaked ground ','stained floor ','stained ground '])
			text += "after having had [color=aqua]" + str(i.orgasms) + "[/color] orgasms."


		#Cum Drip Text
		if i.person.cum.mouth > 0:
			text += i.person.dictionary("\n$name has ")
			text += globals.randomitemfromarray(['semen','cum','jizz','spunk']) + " in $his mouth. $He "
			if i.person.mind.demeanor in ['open','excitable'] || i.person.mind.demeanor == "reserved" && rand_range(0,1) > .5:
				text += globals.randomitemfromarray(['looks you in the eye ','stares up at you ','looks at you '])
			else:
				text += globals.randomitemfromarray(['glances down ','looks down meekly ','looks to the side '])
			if globals.fetishopinion.find(i.person.fetish.drinkcum)-4 >= 0 || rand_range(0,1) > .5:
				text += globals.randomitemfromarray(['and swallows.','and gulps it down.','and smiles, then swallows it all.'])
			elif globals.fetishopinion.find(i.person.fetish.wearcum)-4 >= 0 || globals.fetishopinion.find(i.person.fetish.wearcumface)-4 >= 0 || rand_range(0,1) > .5:
				text += globals.randomitemfromarray(['and lets it drain out onto $his chin and body.','and pushes it out with $his tongue onto $his own cheeks and chest.','and opens $his mouth, drooling it onto $his chin and chest.'])
				i.person.cum.face += round(i.person.cum.mouth/2)
				i.person.cum.body += round(i.person.cum.mouth/2)
			else:
				text += globals.randomitemfromarray(['and spits it onto the ground.','and spits it out.','and gags, spitting it out.','tries to swallow but gags, then spits it out.'])
			i.person.cum.mouth = 0
			text += " "
		if i.person.cum.face > 0 || i.person.cum.body > 0:
			text += "$name is splattered with " + str(globals.expansion.nameCum()) + " all over $his "
			if i.person.cum.face > 0:
				text += "face"
				if i.person.cum.body > 0:
					text += " and "
			if i.person.cum.body > 0:
				text += "body"
			text += ". "

		if i.person.cum.pussy > 5 - globals.vagsizearray.find(i.person.vagina) || i.person.cum.ass > 5 - globals.assholesizearray.find(i.person.asshole):
			text += "\nAs $he "
			if position == "ground":
				text += globals.randomitemfromarray(['lies','spasms','twitches','squirms']) + " on the " + globals.randomitemfromarray(['floor','ground','fluid-soaked floor','fluid-soaked ground','stained floor','stained ground'])
			else:
				text += globals.randomitemfromarray(['moves','shifts','adjusts'])
			text += " $his "
			if i.person.cum.pussy > 0:
				text += globals.randomitemfromarray(['','twitching ','soaked ','spasming ','quivering ',str(i.person.vagina)]) + ' ' + globals.expansion.namePussy()
				if i.person.cum.ass > 0:
					text += " and "
			if i.person.cum.ass > 0:
				if i.person.cum.pussy == 0:
					text += globals.randomitemfromarray(['','twitching ','soaked ','spasming ','quivering ',str(i.person.asshole)])
				text += globals.expansion.nameAsshole()
			text += globals.randomitemfromarray([' squirts out ',' oozes out ',' drools ',' drains ',' spurts out '])
			if i.person.cum.pussy >= globals.expansion.getCapacity(i.person, i.person.vagina) || i.person.cum.ass == globals.expansion.getCapacity(i.person, i.person.asshole):
				text += globals.randomitemfromarray(['a shit-ton','a crazy amount','a ton','a lot'])
			else:
				text += globals.randomitemfromarray(['a glob','a trickle','a bit','a little'])
			#Lose Cum, Dirty House
			var cumloss = clamp(round(rand_range(i.person.cum.pussy*.25,i.person.cum.pussy*.75)), 0, i.person.cum.pussy)
			i.person.cum.pussy -= cumloss
			if cumloss > 0:
				globals.state.condition = -(round(cumloss*.5))
			if i.person.cum.pussy < 0:
				i.person.cum.pussy = 0
			cumloss = clamp(round(rand_range(i.person.cum.ass*.25,i.person.cum.ass*.75)), 0, i.person.cum.ass)
			i.person.cum.ass -= cumloss
			if cumloss > 0:
				globals.state.condition = -(round(cumloss*.5))
			text += " of " + globals.expansion.nameCum() + "."
#		text += "\n"

		#Stretching and Wear&Tear Text
		var stretched
		var difference = 0
		var sizeup = 0
		#Vagina Stretching
		if i.vaginasize != i.person.vagina:
			stretched = true
			difference = globals.vagsizearray.find(i.vaginasize) - globals.vagsizearray.find(i.person.vagina)
			sizeup = 0
			while difference > 0:
				if rand_range(0,100) <= globals.expansionsettings.stretchchancevagina - (i.person.sexexpanded.elasticity*10):
					clamper = globals.vagsizearray.find(i.person.vagina)+1
					clamper = clamp(clamper,0,globals.vagsizearray.size()-1)
					i.person.vagina = globals.vagsizearray[clamper]
					sizeup += 1
				difference -= 1
		#Wear and Tear
		if i.person.vagina != 'none' && (stretched == true && i.vagTorn == true):
			text += "\n$name " + globals.randomitemfromarray(['rubs','holds','sticks a finger in','looks at','strokes']) + " $his " + globals.expansion.namePussy()
			if i.vagTorn == true:
				text += " and " + globals.randomitemfromarray(['cries','moans','sobs','gasps','shrieks','whimpers','tears up','looks horrified','looks pissed']) + ". "
			else:
				text += ". "
			text += "[color=red]$His " + globals.expansion.namePussy()
			if sizeup >= 3:
				text +=  " was " + globals.randomitemfromarray(['horribly','badly','really','terribly']) + " stretched out "
			else:
				text +=  " was stretched out " + globals.randomitemfromarray(['slightly','a little','somewhat','during sex'])
			text += " and is now only " + str(i.person.vagina)
			if i.vagTorn == true:
				text += ", broken, and sore.[/color]"
			else:
				text += ".[/color]"
	
		#Asshole Stretching
		stretched = false
		if i.assholesize != i.person.asshole:
			stretched = true
			difference = globals.assholesizearray.find(i.assholesize) - globals.assholesizearray.find(i.person.asshole)
			sizeup = 0
			while difference > 0:
				if rand_range(0,100) <= globals.expansionsettings.stretchchanceanus - (i.person.sexexpanded.elasticity*10):
					clamper = globals.assholesizearray.find(i.person.asshole)+1
					clamper = clamp(clamper,0,globals.assholesizearray.size()-1)
					i.person.asshole = globals.assholesizearray[clamper]
					sizeup += 1
				difference -= 1
		#Wear and Tear
		if i.assTorn == true && stretched == true:
			text += "\n$name " + globals.randomitemfromarray(['rubs','holds','sticks a finger in','looks at','strokes']) + " $his " + globals.expansion.nameAsshole()
			if i.assTorn == true:
				text += " and " + globals.randomitemfromarray(['cries','moans','sobs','gasps','shrieks','whimpers','tears up','looks horrified','looks pissed']) + ". "
			else:
				text += ". "
			text += "[color=red]$His " + globals.expansion.nameAsshole()
			if sizeup >= 3:
				text +=  " was " + globals.randomitemfromarray(['horribly','badly','really','terribly']) + " stretched out "
			else:
				text +=  " was stretched out " + globals.randomitemfromarray(['slightly','a little','somewhat','during sex'])
			text += " and is now only " + str(i.person.asshole)
			if i.assTorn == true:
				text += ", broken, and sore.[/color]"
			else:
				text += ".[/color]"

		#Incest Text
		if i.actionshad.incestorgasms > 0 && i.person != globals.player:
			text += "\n[color=aqua]" + str(i.actionshad.incestorgasms) + "[/color] of $name's orgasms were due to incest. "
			if i.actionshad.incestorgasms + i.person.dailyevents.count('incest') + rand_range(0,10) >= 5*(6-globals.fetishopinion.find(i.person.fetish.incest)):
				if i.person.fetish.incest != 'mindblowing':
					i.person.fetish.incest = globals.fetishopinion[globals.fetishopinion.find(i.person.fetish.incest)+1]
					text += "\n$name approaches you and speaks softly, as though sharing a secret with you."
					text += i.person.quirk("[color=yellow]\n-I enjoyed this more than I thought I would. I don't think incest is necessarily " + globals.fetishopinion[globals.fetishopinion.find(i.person.fetish.incest)-1] + " anymore. It is actually " + str(i.person.fetish.incest) + ".[/color]")
			elif i.actionshad.incestorgasms + i.person.dailyevents.count('incest') + rand_range(0,10) <= 5*(6-globals.fetishopinion.find(i.person.fetish.incest)):
				if i.person.fetish.incest != globals.fetishopinion[0]:
					i.person.fetish.incest = globals.fetishopinion[globals.fetishopinion.find(i.person.fetish.incest)-1]
					text += "$name approaches you and looks fairly upset."
					text += i.person.quirk("[color=yellow]\n-Today was completely inappropriate. Incest isn't " + globals.fetishopinion[globals.fetishopinion.find(i.person.fetish.incest)+1] + ". It is actually really " + str(i.person.fetish.incest) + ".[/color]")

			if globals.fetishopinion.find(i.person.fetish.incest) >= 4 && i.person.consentexp.incest == false:
				if i.person.loyal + (25*globals.fetishopinion.find(i.person.fetish.incest)) >= 100:
					text += "\n$name smiles mischieviously."
					text += i.person.quirk("[color=yellow]\n-You know...I don't mind if you ever want me to do that again...[/color]") + "\n[color=green]You now have $name's consent[/color] for incestuous actions."
					i.person.consentexp.incest = true
#		text += "" + str(globals.expansion.swollenCalc(i.person))

#		Old Text
#		text += i.person.dictionary("$name: Orgasms - ") + str(i.orgasms)
		###---Expansion End---###

		###---Added by Expansion---### Sexuality Shifts
		for trait in i.actionshad.addtraits:
			i.person.add_trait(trait)

		var shift = round(i.sexualityshift/5)
		shift = clamp(shift, -1, 1)		
		var index = 0
		if i.person.sexexpanded.sexualitylocked == false && shift != 0 && i.person != globals.player && !(i.person.unique in ['dog','horse']):
			#---Rape Checks, Chance to Reverse Sexuality Switch
			if i.person.effects.has('resist') || i.person.consent == false:
				var switchshift = true
				for traitcheck in ["Masochist","Deviant","Pervert","Submissive","Sex-crazed","Likes it rough"]:
					if i.person.traits.has(traitcheck):
						switchshift = false
						break
				if switchshift == true:
					shift *= -1
					text += i.person.quirk("\n[color=yellow]-I can't believe that you actually raped me! I feel so violated! You " + str(globals.player.sex) + "s are disgusting.[/color]")
			if shift > 0:
				if globals.kinseyscale.find(i.person.sexuality) + shift > globals.kinseyscale.size()+1:
					i.person.sexuality = 'gay'
					shift = 0
				else:
					index = globals.kinseyscale.find(i.person.sexuality)+shift
					i.person.sexuality = globals.getfromarray(globals.kinseyscale,index)
				if shift > 0:
					text += "\n\n$name looks around the area that you "+globals.randomitemfromarray(['fucked','had sex in','got nasty','did the deed','pounded it out','knocked boots'])+" in and seems to think for a moment."
					text += i.person.quirk("\n[color=yellow]-I "+globals.randomitemfromarray(['feel','think that I am','can tell that I am','am so much','definitely am','feel much'])+" more attracted to " +str(i.person.sex)+"s now after this experience. I feel " +globals.expansion.getSexuality(i.person)+" now.[/color]")
			else:
				if globals.kinseyscale.find(i.person.sexuality) + shift < 0:
					i.person.sexuality = 'straight'
					shift = 0
				else:
					index = globals.kinseyscale.find(i.person.sexuality)+shift
					i.person.sexuality = globals.getfromarray(globals.kinseyscale,index)
				var sexname = 'none'
				if i.person.sex in ['futanari','dickgirl']:
					if globals.expansionsettings.futasexualityshift == 'bi':
						sexname = i.person.sex
					elif globals.expansionsettings.futasexualityshift == 'male':
						sexname = 'female'
					else:
						sexname = 'male'
				elif i.person.sex == 'male':
					sexname = 'female'
				elif i.person.sex == 'female':
					sexname = 'male'
				if shift < 0:
					text += "\n\n$name looks around the area that you " +globals.randomitemfromarray(['fucked','had sex in','got nasty','did the deed','pounded it out','knocked boots'])+" in and seems to think for a moment."
					text += i.person.quirk("\n[color=yellow]-I "+globals.randomitemfromarray(['feel','think that I am','can tell that I am','am so much','definitely am','feel much'])+" more attracted to " +sexname+"s now after this experience. I feel " +globals.expansion.getSexuality(i.person)+" now.[/color]")
		elif i.person == globals.player && globals.expansionsettings.player_sexuality_shift == true && shift != 0:
			if shift > 0:
				if globals.kinseyscale.find(i.person.sexuality) + shift > globals.kinseyscale.size()+1:
					i.person.sexuality = 'gay'
					shift = 0
				else:
					index = globals.kinseyscale.find(i.person.sexuality)+shift
					i.person.sexuality = globals.getfromarray(globals.kinseyscale,index)
					
				if shift > 0:
					text += "\nYou feel more attracted to " +str(i.person.sex)+ "s after this experience. You now feel [color=aqua]" +globals.expansion.getSexuality(i.person)+"[/color]."
			else:
				if globals.kinseyscale.find(i.person.sexuality) + shift < 0:
					i.person.sexuality = 'straight'
					shift = 0
				else:
					index = globals.kinseyscale.find(i.person.sexuality)+shift
					i.person.sexuality = globals.getfromarray(globals.kinseyscale,index)
				if shift < 0:
					var sexname = 'none'
					if i.person.sex in ['futanari','dickgirl']:
						if globals.expansionsettings.futasexualityshift == 'bi':
							sexname = i.person.sex
						elif globals.expansionsettings.futasexualityshift == 'male':
							sexname = 'female'
						else:
							sexname = 'male'
					elif i.person.sex == 'male':
						sexname = 'female'
					elif i.person.sex == 'female':
						sexname = 'male'
					text += "\nYou feel more attracted to " +sexname+ "s after this experience. You now feel [color=aqua]" +globals.expansion.getSexuality(i.person)+"[/color]."
		###---End Expansion---###

		if i.actionshad.group*0.01 > randf():
			i.person.trait_remove("Monogamous")
			i.person.add_trait("Fickle")

		if i.orgasms >= 1:
			var essence = i.person.getessence()
			if essence != null && i.person.smaf*20 > rand_range(0,100):
				###---Added by Expansion---### Ease of Reading
				rewardtext += "\nIngredient Gained from [color=aqua]"+i.name+"[/color]: [color=yellow]" + globals.itemdict[essence].name + "[/color]"
				###---End Expansion---###
				globals.itemdict[essence].amount += 1
			mana += (i.orgasms - i.succubusdraincount) * variables.orgasmmana + rand_range(1,2) #ralphC - replaced 3 with variables.orgasmmana and deducted succubusdraincount
		else:
			mana += i.sens/500
		###---Added by Expansion---### Hybrid Support
		if i.person.race.find('Dark Elf') >= 0:
			mana *= 1.2
		###---End Expansion---###
		if i.person.spec == 'nympho':
			mana += i.actionshad.samesex + i.actionshad.oppositesex
		if i.person == globals.player:
			mana /= 2
		if i.requestsdone > 0:
			mana += i.requestsdone*10
			###---Added by Expansion---### Removed , added \n
			text += "\nDesires fullfiled: [color=aqua]" + str(i.requestsdone) + '[/color]'
			###---End Expansion---###
		if i.person.race_display == "Succubus": #ralphC - Succubus orgasms don't produce mana
			mana = 0  #ralphC
		###---Added by Expansion---### Person Expanded; Strip/Redress
		text += i.person.updateClothing()
		#DimCrystal Ability
		if globals.state.thecrystal.abilities.has('empowervirginity') && globals.state.thecrystal.empoweredvirginity == true && i.person != globals.player:
			if i.virginity_multiplier > 0:
				text += "\n\n[color=lime]Magically Empowered Virginity was Lost![/color]\nMana Multiplier: Personal Produced Amount x[color=aqua]" + str(i.virginity_multiplier) + "[/color]"
				mana = round(mana * i.virginity_multiplier)
			else:
				text += "\n[color=red]No Virginity was Lost. The Crystal's disappointment at the lack of character development drains half of the mana produced.[/color]"
				mana = round(mana*.5)
		###---End Expansion---###
		mana = round(mana)
		manaDict[i.person] = mana
		totalmana += mana
		text = i.person.dictionary(text + "\n")

	###---Added by Expansion---### Colored Mana / Reward Text Ease of Reading
	var manaScaling = 1.0 - 0.9 * totalmana / (500.0 + totalmana)
	totalmana = 0
	for person in manaDict:
		mana = round(manaScaling * manaDict[person])
		totalmana += mana
		person.metrics.manaearn += mana
	
	if succubuscounter > 0: #ralphC
		text += "\n[color=red]Succubi managed to siphon off mana from [/color]"+str(succubuscounter)+" orgasms.\n" #ralphC
		succubuscounter = 0 #ralphC
	text += "\n[color=green][center]---Rewards Earned---[/center][/color]"
	text += "\nEarned Mana: [color=aqua]" + str(totalmana) + "[/color]"
	text += rewardtext
						  
	globals.resources.mana += totalmana 
	###---End Expansion---###
	for action in ongoingactions:
		stopongoingaction(action)
	ongoingactions.clear()

	get_node("Control").show()
	get_node("Control/Panel/RichTextLabel").set_bbcode(text)

func askslaveforaction(chosen):
	#choosing target
	var targets = []
	clearstate()
	var chosensex = chosen.person.sex
	var debug = ""
	var group = false
	var target
	
	###---Added by Expansion---### Hybrid Support
	if chosen.person.race.find('Elf') >= 0:
		chosen.person.obed += rand_range(3,6)
	###---End Expansion---###
	
	debug += 'Chosing targets... \n'
	
	for i in participants:
		if i != chosen:
			if i.person == globals.player && aiobserve == true:
				continue
			debug += i.name
			var value = 10
			if chosen.person.traits.has("Monogamous") && i.person != globals.player:
				value = 0
			elif chosen.person.traits.has("Fickle") || chosen.person.traits.has('Slutty'):
				value = 25
			if chosen.person.traits.has('Devoted') && i.person == globals.player:
				value += 50
			
			if i.npc == true && chosen.npc == true:
				value -= 50
			
			if chosen.person.sexexp.orgasms.has(i.person.id):
				value += chosen.person.sexexp.orgasms[i.person.id]*4
			if chosen.person.sexexp.watchers.has(i.person.id):
				value += (chosen.person.sexexp.watchers[i.person.id]-1)*2
			if chosen.person.sexexp.partners.has(i.person.id):
				value += chosen.person.sexexp.partners[i.person.id]/0.2
			if isencountersamesex([chosen], [i], chosen) && chosen.person.traits.has('Bisexual') == false && chosen.person.traits.has('Homosexual') == false:
				value = max(value/5,1)
			elif isencountersamesex([chosen], [i], chosen) == false && chosen.person.traits.has('Homosexual'):
				value = max(value/5,1)
			debug += " - " + str(value) + '\n'
			value = min(value, 120)
			if value > 0:
				targets.append([i, value])
	###---Added by Expansion---### Ank BugFix v4a
	if targets.empty():
		givers = [chosen]
		takers = []
		var action = categories.other[0]
		action.givers = givers
		action.takers = takers
		startscene( action, false, decoder('[color=green][name1] does not wish to interact with anyone available.[/color]\n\n', givers, takers))
		return
	###---End Expansion---###
	target = globals.weightedrandom(targets)
	debug += 'final target - ' + target.name
	
	
	debug += '\nChosing dom: \n'
	var dom = [['giver',40],['taker', 10]]
	
	if target.person.sex != chosen.person.sex && chosen.person.sex == 'female' && (chosen.person.asser < 75 || !chosen.person.traits.has("Dominant")):
		dom[0][1] = 0
	
	if chosen.person.asser >= 75:
		dom[1][1] = 0
	elif chosen.person.asser <= 25:
		dom[0][1] = 0
	debug += str(dom) + "\n"
	dom = globals.weightedrandom(dom)
	
	debug += 'final dom: ' + dom + '\n'
	
	var groupchosen = [chosen] 
	var grouptarget = [target]
	
	if participants.size() >= 3:
		if randf() >= 0.5 && chosen.person.traits.has("Monogamous") == false:
			group = true
	var freeparticipants = []
	
	if group == true:
		debug += "Group action attempt:\n"
		for i in participants:
			if i.person == globals.player && aiobserve == true:
				continue
			if i != chosen && i != target && randf() >= 0.5:
				freeparticipants.append(i)
		
		while freeparticipants.size() > 0:
			var targetgroup
			var newparticipant = freeparticipants[randi()%freeparticipants.size()]
			var samesex = isencountersamesex([newparticipant], [chosen], chosen)
			if chosen.person.traits.has("Bisexual"):
				targetgroup = 'any'
			elif (chosen.person.traits.has("Homosexual") && samesex) || !samesex:
				targetgroup = 'target'
			elif chosen.person.traits.has("Homosexual"):
				targetgroup = 'any'
			else:
				targetgroup = 'chosen'
			if (targetgroup == 'any' && randf() >= 0.5) || targetgroup == 'chosen':
				groupchosen.append(newparticipant)
			else: 
				grouptarget.append(newparticipant)
			
			freeparticipants.erase(newparticipant)
	
	#choosing action
	var chosenpos = ''
	var actions = []
	var chosenaction = null
	debug += 'chosing action: \n' 
	for i in categories:
		for j in categories[i]:
			clearstate()
			debug += j.code + ": "
			if j.code == 'wait':
				continue
			if (j.code in takercategories) == (dom == 'taker'):
				givers = groupchosen.duplicate()
				takers = grouptarget.duplicate()
			else:
				takers = groupchosen.duplicate()
				givers = grouptarget.duplicate()
			var result = checkaction(j)
			if result[0] == 'allowed':
				var value = 0
				if chosen.person.sexexp.actions.has(j.code):
					value += chosen.person.sexexp.actions[j.code]/2
				if chosen.person.sexexp.orgasms.has(j.code):
					value += chosen.person.sexexp.orgasms[j.code]*4
				if chosen.person.sexexp.seenactions.has(j.code):
					value += chosen.person.sexexp.seenactions[j.code]/10
				
				if i in ['caress','fucking']:
					value += 10
				
				if !chosen.person.traits.has("Enjoys Anal") && j.code in analcategories:
					if chosenpos == 'giver' && !takercategories.has(j.code):
						value -= 5
					elif chosenpos == 'taker' && takercategories.has(j.code):
						value -= 5
				
				
				if chosen.person.traits.has('Masochist') && j.code in punishcategories && chosenpos == 'taker':
					value *= 2.5
				if chosen.person.traits.has('Dominant') && j.code in punishcategories && chosenpos == 'giver':
					value *= 2.5
				if target.person.obed < 80  && j.code in punishcategories && chosenpos == 'giver':
					value *= 3
				if chosen.person.penis == 'none' && dom == 'giver' && j.code == 'strapon':
					value *= 10
				if chosen.person.traits.has("Pervert") && ((givers.has(chosen) && j.giverconsent == 'advanced') || (takers.has(chosen) && j.takerconsent == 'advanced')):
					value += 15
				
				if chosen.person.vagvirgin == true && j.category == 'fucking' && !j.code in analcategories:
					value -= 25
				if chosen.person.assvirgin == true && j.category == 'fucking' && j.code in analcategories:
					value -= 25
				
				if j.category == 'fucking':
					value += max(15 - turns, 0)
					if chosen.lube < 5:
						value -= (5 - chosen.lube)*2
				
				debug += str(value) + '\n'
				if value > 0:
					actions.append([j, value])
	if actions.empty():
		actions.append([categories.other[0], 1])
	chosenaction = globals.weightedrandom(actions)
	clearstate()
	if (chosenaction.code in takercategories) == (dom == 'taker'):
		givers = groupchosen.duplicate()
		takers = grouptarget.duplicate()
	else:
		takers = groupchosen.duplicate()
		givers = grouptarget.duplicate()
	var cont = false
	chosenaction.givers = givers
	chosenaction.takers = takers
	var text = '[color=green][name1] initiates ' + chosenaction.getname() + ' with [name2].[/color]\n\n'
	if chosenaction.canlast == true && randf() >= 0.2:
		cont = true
	$PopupPanel/RichTextLabel.bbcode_text = debug
	#$PopupPanel.popup()
	startscene(chosenaction, cont, decoder(text, groupchosen, grouptarget))

