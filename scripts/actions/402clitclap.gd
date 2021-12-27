
func requirements():
	var valid = true
	for i in takers:
#		if i.acc6 != null:
#			valid = false
		if i.person.vagina == 'none':
			valid = false
	if takers.size() != 1 || givers.size() != 1:
		valid = false
	return valid
