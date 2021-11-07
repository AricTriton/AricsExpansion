
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
