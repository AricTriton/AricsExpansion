func resort():
	var strictsearch = get_node("racelock").is_pressed()
	#var gender = person.sex
	###---Added by Expansion---### centerflag982 - added dickgirl check
	#if gender == 'futanari' || gender == 'dickgirl':
	#	gender = 'female'
	var race = person.race.replace("Beastkin ", "").replace("Halfkin ", "").replace(" ","")
	var searchText = get_node("search").get_text()
	var noImages = true
	
	for i in get_node("ScrollContainer/GridContainer").get_children():
		i.hide()
		if i == get_node("ScrollContainer/GridContainer/Button"):
			continue
		if strictsearch == true:
			if i.get_meta('type').findn(race) < 0:
				continue 
		elif !searchText.empty() && i.get_meta('type').findn(searchText) < 0:
			continue
		i.show()
		noImages = false
	get_node("noimagestext").visible = noImages
	call_deferred("_on_scroll", get_node("ScrollContainer/_v_scroll").value)

###---Added by Expansion---### Images Expanded | Added Naked/Preg path changes
func setslaveimage(path):
	if mode == 'portrait':
		person.imageportait = path
		path = path.replace(globals.setfolders.portraits, globals.setfolders.fullbody)
		if $assignboth.pressed && globals.canloadimage(path):
			person.imagefull = path
			globals.expansion.updateBodyImage(person)
	elif mode == 'body':
		person.imagefull = path
		globals.expansion.updateBodyImage(person)
		path = path.replace(globals.setfolders.fullbody, globals.setfolders.portraits)
		if $assignboth.pressed && globals.canloadimage(path):
			person.imageportait = path
	self.visible = false
	updatepage()
###---End Expansion---###

func _on_reverseportrait_pressed():
	if person.unique != null:
		var temp = globals.characters.characters.get(person.unique)
		if temp != null:
			person.imageportait = temp.imageportait
		self.visible = false
		person.imagefull = null
		updatepage()
