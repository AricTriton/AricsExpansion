
const StaffJobs = ['cooking', 'maid', 'nurse', 'headgirl', 'jailer', 'farmmanager']
###---Added by Expansion---### For new jobs
var mansionStaff = {'headslave' : null, 'jailer' : null, 'alchemyAssistant' : null, 'librarian' : null, 'labAssistant' : null, 'farmManager' : null, 'cook' : null, 'nurse' : null, 'maid' : []}
###---End Expansion---###

func joblist():
	currentslave = globals.currentslave
	var array = []
	var basic = get_node("jobs/VBoxContainer")
	for i in basic.get_children():
		if i != get_node("jobs/VBoxContainer/Button"):
			i.visible = false
			i.queue_free()
	get_node("tooltiptext").set_bbcode("")
	show()
	takenjobs.clear()
	for i in jobdict.values():
		array.append(i)
	array.sort_custom(self, 'sortjobs')
	for i in array:
		if globals.evaluate(i.unlockreqs) == true:
			var newbutton = get_node("jobs/VBoxContainer/Button").duplicate()
			var locked
			for k in globals.state.portals.values():
				if i.tags.find(k.code) >= 0 && k.enabled == false && globals.state.location != k.code:
					locked = true
			if locked == true:
				continue
			newbutton.visible = true
			newbutton.set_text(i.name)
			basic.add_child(newbutton)
			if currentslave.work == i.code:
				basic.move_child(newbutton,0)
			#dict[i.type].add_child(newbutton)
			if currentslave.work == i.code:
				newbutton.set('custom_colors/font_color', Color(0,1,0,1))
			if globals.evaluate(i.reqs) == false:
				newbutton.set_disabled(true)
				newbutton.set_tooltip(currentslave.dictionary("$name is not suited for this work"))
			###---Added by Expansion---### Movement Support
			if globals.currentslave.movement == 'none' && i.code != 'fucktoy':
				newbutton.set_disabled(true)
				newbutton.set_tooltip(currentslave.dictionary("$name can't move $his body at the moment. The best $he can do is lie there and be fucked. "))
			if globals.currentslave.movement == 'crawl' && !i.location.has('mansion'):
				newbutton.set_disabled(true)
				newbutton.set_tooltip(currentslave.dictionary("$name is forced to crawl at the moment and can not crawl away from the Mansion. "))
			if i.code == 'trainee':
				var trainer
				var totaltrainees = 0
				for checked in globals.slaves:
					if checked.work == 'trainer' && checked.away.duration == 0:
						trainer = checked
					elif checked.work == 'trainee' && checked.away.duration == 0:
						totaltrainees += 1
				if trainer == null:
					newbutton.set_disabled(true)
					newbutton.set_tooltip(currentslave.dictionary("There is no Trainer available in the Training Grounds. "))
				elif totaltrainees >= trainer.level * 2:
					newbutton.set_disabled(true)
					newbutton.set_tooltip(trainer.dictionary("There are too many Trainees assigned to $name. $He can only teach " + str(trainer.level*2) + " slaves total, which is twice $his level. "))
				elif globals.currentslave.level >= trainer.level:
					newbutton.set_disabled(true)
					newbutton.set_tooltip(currentslave.dictionary("$He is of equal or higher level than ") + trainer.dictionary("$name, the Trainer. ") + currentslave.dictionary("$He will get nothing out of training there right now. "))
				elif globals.currentslave.metrics.win >= trainer.metrics.win:
					newbutton.set_disabled(true)
					newbutton.set_tooltip(currentslave.dictionary("$He has won as many or more battles than ") + trainer.dictionary("$name, the Trainer. ") + currentslave.dictionary("$He will get nothing out of training there right now. "))
			###---End Expansion---###
			if i.tags.find('sex') >= 0 && i.code != 'fucktoy':
				if !globals.currentslave.bodyshape in ['humanoid', 'bestial', 'shortstack', 'reptilianshortstack', 'reptilian', 'furryshortstack', 'avian', 'raptorshortstack']:
					newbutton.set_disabled(true)
					newbutton.set_tooltip(currentslave.dictionary("This occupation only allows humanoid currentslaves. "))
				elif currentslave.tags.find('nosex') >= 0:
					newbutton.set_disabled(true)
					newbutton.set_tooltip(currentslave.dictionary("$name refuses to participate in sexual activities at this moment. "))
				elif currentslave.traits.has("Monogamous") || currentslave.traits.has("Prude"):
					newbutton.set_disabled(true)
					newbutton.set_tooltip(currentslave.dictionary("$name refuses to whore $himself."))
			if i.tags.find('social') >= 0:
				if currentslave.traits.has('Uncivilized') || currentslave.traits.has('Regressed'):
					newbutton.set_disabled(true)
					newbutton.set_tooltip(currentslave.dictionary("$name is not suited to work in social circles. "))
			if i.tags.find("management") >= 0:
				if currentslave.traits.has("Passive"):
					newbutton.set_disabled(true)
					newbutton.set_tooltip(currentslave.dictionary("$name is not suited for leading roles. "))
					
			###---Added by Expansion---### Ank BugFix v4a
			if !newbutton.disabled && i.maxnumber >= 1:
				var counter = 0
				for tempslave in globals.slaves:
					if tempslave.work == i.code:
						takenjobs[i] = tempslave
						counter += 1
				if counter >= i.maxnumber:
					#newbutton.set_disabled(true)
					
					newbutton.set_tooltip("This occupation is already taken")
			###---End Expansion---###
			newbutton.set_meta("job", i)
			newbutton.connect('pressed', self, 'choosejob', [newbutton])
			newbutton.connect("mouse_entered",self,'jobtooltipshow',[newbutton])
			#newbutton.connect("mouse_exit",self,'jobtooltiphide')

func choosejob(button):
	var oldJob = currentslave.work
	chosenbutton = button
	var curjob = button.get_meta('job')
	if takenjobs.has(curjob):
		get_parent().yesnopopup(takenjobs[curjob].name_short() + takenjobs[curjob].dictionary(" currently assigned to this occupation. Replace $him?"), 'confirmjob', self)
		return
	currentslave.work = curjob.code
	
	#QMod - Staff Jobs
	if oldJob in StaffJobs: #Clear old job
		match oldJob:
			'cooking':
				mansionStaff.cook = null
			'nurse':
				mansionStaff.nurse = null
			'headgirl':
				mansionStaff.headslave = null
			'jailer':
				mansionStaff.jailer = null
			'farmmanager':
				mansionStaff.farmManager = null
			'maid':
				mansionStaff.maid.erase(currentslave)
	if currentslave.work in StaffJobs: #Assign new job
		match currentslave.work:
			'cooking':
				mansionStaff.cook = currentslave
			'nurse':
				mansionStaff.nurse = currentslave
			'headgirl':
				mansionStaff.headslave = currentslave
			'jailer':
				mansionStaff.jailer = currentslave
			'farmmanager':
				mansionStaff.farmManager = currentslave
			'maid':
				mansionStaff.maid.append(currentslave)
###---Added by Expansion---### Confirm Button

#	for i in get_tree().get_nodes_in_group("joblist"): 
#		i.set_text(currentslave[i.get_name()])

	###Later on, add in the "Lock Requirements" of If Lock != etc etc under Tags || if location+jobname != globals.state.lockedjobsarray, then clear from there
#	for i in curjob.location:
#		get_node("joblist/joblocation").add_item(i)
#		if currentslave.joblocation == i:
#			get_node("joblist/joblocation").select(get_node("joblist/joblocation").get_item_count()-1)

	_on_jobcancel_pressed()
	get_tree().get_current_scene().slavepanel.slavetabopen()
	if get_tree().get_current_scene().get_node("slavelist").is_visible():
		get_tree().get_current_scene().slavelist()
###---End Expansion---###

func jobtooltipshow(button):
	var job = button.get_meta('job')
	var text = '[center]' + job.name + '[/center]\n' + job.description
	###---Added by Expansion---### Job Locations Expansion
	for i in job.location:
		if i in ['wimborn','gorn','frostford']:
			text += "\n\nWork town: " + str(i).capitalize()
			for j in globals.state.reputation:
				if j == i:
					text += "\nAffiliation: " + get_parent().reputationword(globals.state.reputation[i])
	###---End Expansion---###
	get_node("tooltiptext").set_bbcode(currentslave.dictionary(text))

func confirmjob():
	var job = chosenbutton.get_meta('job')
	if takenjobs[job].away.duration > 0:
		takenjobs[job].away.prev_work = takenjobs[job].work
	takenjobs[job].work = 'rest'
	takenjobs.erase(job)
	choosejob(chosenbutton)

func _on_jobcancel_pressed():
	self.visible = false

###---Added by Expansion---### Confirm Button
func _on_jobconfirm_pressed():
	self.visible = false
	get_tree().get_current_scene().slavepanel.slavetabopen()
	if get_tree().get_current_scene().get_node("slavelist").is_visible():
		get_tree().get_current_scene().slavelist()
###---End Expansion---###
