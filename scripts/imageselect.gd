###---Added by Expansion---### centerflag982 - added dickgirl check
func resort():
	var strictsearch = get_node("racelock").is_pressed()
	var gender = person.sex
	var race = person.race
	var counter = 0
	if gender == 'futanari' || gender == 'dickgirl':
		gender = 'female'
	race = race.replace("Beastkin ", "").replace("Halfkin ", "")

	
	
	
	for i in get_node("ScrollContainer/GridContainer").get_children():
		i.hide()
		if i == get_node("ScrollContainer/GridContainer/Button"):
			continue
		if strictsearch == true:
			if i.get_meta('type').findn(race) < 0:
				continue 
		if strictsearch == false && get_node("search").get_text() != '' && i.get_node("Label").get_text().findn(get_node("search").get_text()) < 0:
			continue
		i.show()
		counter += 1
	if counter < 1:
		get_node("noimagestext").visible = true
	else:
		get_node("noimagestext").visible = false
###---End Expansion---###

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
