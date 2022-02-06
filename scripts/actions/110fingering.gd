
func requirements():
	var valid = true
	if takers.size() < 1 || givers.size() < 1 || givers.size() + takers.size() > 3:
		valid = false
	for i in givers:
		if i.limbs == false:
			valid = false
	for i in takers:
#		if i.vagina != null || i.person.vagina == 'none':
#			valid = false
		if i.person.vagina == 'none':
			valid = false
	return valid
