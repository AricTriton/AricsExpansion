### <CustomFile> ###

var progressmax = 10
var progress = 0
var pain = 0
var painmax = 10
var pleasure = 0
var contraction = 8
var pushmod = 0
var embarrassment = []


func sceneBirthingStart(person):
	if person = null:
		return
	
	globals.expansionbirthing.progressmax = 10
	globals.expansionbirthing.progress = 0
	globals.expansionbirthing.pain = 0
	globals.expansionbirthing.painmax = clamp((2+person.ssend)*3), 6, 20)
	globals.expansionbirthing.pleasure = 0
	globals.expansionbirthing.pushmod = 0
	globals.expansionbirthing.embarrassment = []
	
	newContraction(globals.expansionbirthing.progress)
	
	return sceneBirthingBody(person, 'none')

func sceneBirthingBody(person, action):
	var text = ""
	var progress = globals.expansionbirthing.progress
	var contraction = globals.expansionbirthing.contraction
	var action = action
	
	#Intro Text (Racial Status, Embarrassments, Scene Info, Contraction hints, etc)
	#If Embarrassments in Array, List Embarrassments
	#Show current Progress/Push Prep(PushMod)/Pain & PainMax/Pleasure
	if progress >= progressmax*.8:
		text = "You see the baby's head beginning to push through $his " + globals.expansion.getGenitals(person)+ ". It is crowning and won't be long now!"

	#Send Text to Scene Processor after this
	text = person.dictionary(text)

	#Choice Prompt (You Encourage: Push, Pleasure (Build Lust/Orgasm to lower pain), Reassure (Build Loyalty), Rest, Prepare to Push (build PushMod) or Watch/None || Also Finish (End Scene/Give Up)
	
	return checkBirthingResult(person, action)
	

func sceneBirthingResult(person, action = ''):
	var text = ""
	var contraction = globals.expansionbirthing.contraction
	var progress = globals.expansionbirthing.progress
	
	var action = action
	
	if action == "watch" || action == "" || action == "none":
		if rand_range(0,100) <= 15 + (progress*10):
			action = "push"
		else:
			action = "rest"
	
	if action == "push":
		if contraction < 1:
			if person.send + globals.expansionbirthing.pushmod >= globals.expansionbirthing.pain || person.sstr + globals.expansionbirthing.pushmod > globals.expansionbirthing.pain || rand_range(0,100) >= globals.expansionbirthing.pain*10:
				globals.expansionbirthing.progress += 1
				globals.expansionbirthing.pushmod = 0
				#text = "$name pushes along with the contraction and the baby begins to shift down $his vaginal tube. "
			else:
				globals.expansionbirthing.pushmod += 1
				text += "$name pushes as hard as $his body will let $him, but $he is too exhausted, in pain, and overwhelmed to be able to be able to put any real effort behind it. "
		else:
			globals.expansionbirthing.pain += 1
			text += "$He pushes as hard as $he can, but without $his belly contracting to help, $he just causes $himself more pain and exhaustion. "
			if globals.expansionbirthing.pushmod > 0:
				globals.expansionbirthing.pain += 1
				globals.expansionbirthing.pushmod = round(globals.expansionbirthing.pushmod*.5)
				text += "The effort and frustration from $his previous failed attempts to make progress causes $him even more frustration. "
				text += checkAccident(globals.expansionbirthing.pain)
		return checkBirthingEnd (person, action)
	
	if contraction < 1:
		globals.expansionbirthing.pain += 1
		text += "$He is forced to grit $his teeth and squeal/scream/moan/etc as $he is overtaken by the waves of pain from $his body contracting and $his belly squeezing. "
		if globals.expansionbirthing.pushmod > 0:
			if rand_range(0,100) <= globals.expansionbirthing.pushmod * 10:
				globals.expansionbirthing.progress += 1
				globals.expansionbirthing.pain += 1
				#Negative Consequence/Accident
				text += "$His belly shifts as the baby slides deeper towards the entrance due to $his previous attempts to push, despite his current failed timing. $He is unable to stop it and it seems to cause $him greater pain, though some progress has been made. "	
	else:
		if action == "pleasure":
			text += "You rub $his clit vigorously/fuck $him/etc. "
			globals.expansionbirthing.pleasure += 1
			if globals.expansionbirthing.pleasure >= globals.expansionbirthing.pain:
				globals.expansionbirthing.pain = round(globals.expansionbirthing.pain*.25)
				globals.expansionbirthing.pleasure = 0
				text += "$His body resolves immediately and $he moans/squeals then violently, sloppily squirts all over your hand. It seems to have drastically lowered $his pain. "
			else:
				globals.expansionbirthing.pain -= 1
				text += "$He seems to enjoy it and it helps the pain slightly. "
		elif action == "rest":
		
		elif action == "prepare":
		
		elif action == "encourage":
		
		elif action == "finish":
	
	#Reset Loop
	return checkBirthingEnd (person, action)

func checkBirthingEnd(person, action):
	if globals.expansionbirthing.progress >= globals.expansionbirthing.progressmax:
		#Birthing Happy End
	elif globals.expansionbirthing.pain >= globals.expansionbirthing.painmax:
		#Birthing KO End
	else:
		if globals.expansionbirthing.contraction < 1:
			newContraction(globals.expansionbirthing.progress)
		else:
			globals.expansionbirthing.contraction -= round(rand_range(1,globals.expansionbirthing.contraction*5))
		return sceneBirthingBody(person,action)

func resetContraction(progress):
	var contraction = clamp(rand_range(0,8) - globals.expansionbirthing.progress, 0, 8)
	globals.expansionbirthing.contraction = contraction
	return

funct checkAccident(pain):
	pass
	#Add in various text for accidents, humiliations, etc.
	#Milk Squirt, Pussy Squirt, Pissing, Shitting

	