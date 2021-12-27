
func _on_PlayerConfirmButton_pressed():
	slavetemp = globals.slavegen.newslave(slavetemp['race'], slavetemp['age'], slavetemp['sex'])
	var text1 = get_tree().get_nodes_in_group('PCCustoms')
	for i in text1:
		i.clear()
	get_node("PlayerCustomizations").show()
	get_node("PlayerCustomizations/PCHairColor").set_text(slavetemp['haircolor'])
	get_node("PlayerCustomizations/PCEyeColor").set_text(slavetemp['eyecolor'])
	var text = ['short', 'average', 'tall', 'towering'] ### height array
	for i in text:
		get_node("PlayerCustomizations/PCHeight").add_item(i)
		if i == slavetemp['height']:
			get_node("PlayerCustomizations/PCHeight").select(get_node("PlayerCustomizations/PCHeight").get_item_count()-1)
	if (slavetemp['sex'] == 'male'): ### hairstyle array
		text = ['straight', 'ponytail']
	else:
		text = ['straight', 'ponytail', 'twintails', 'braid', 'twobraids', 'bun']
	for i in text:
		get_node("PlayerCustomizations/PCHairstyle").add_item(i)
		if (i == slavetemp['hairstyle']):
			get_node("PlayerCustomizations/PCHairstyle").select(get_node("PlayerCustomizations/PCHairstyle").get_item_count()-1)
	if (slavetemp['sex'] == 'male'): ### tits
		text = ['flat', 'masculine']
	else:
	###---Added by Expansion---### New Sizes
		text = ['flat','small','average','big','huge','incredible','massive','gigantic']
	###---End Expansion---###
	for i in text:
		get_node("PlayerCustomizations/PCChest").add_item(i)
		if (i == slavetemp['tits']['size']):
			get_node("PlayerCustomizations/PCChest").select(get_node("PlayerCustomizations/PCChest").get_item_count()-1)
	if (slavetemp['sex'] == 'male'): ### rear
		text = ['flat', 'masculine']
	else:
		text = ['flat', 'small', 'average', 'big', 'huge']
	for i in text:
		get_node("PlayerCustomizations/PCButt").add_item(i)
		if (i == slavetemp['ass']):
			get_node("PlayerCustomizations/PCButt").select(get_node("PlayerCustomizations/PCButt").get_item_count()-1)
	if (slavetemp['sex'] == 'female'): ### penis
		text = ['none']
	else:
		###---Added by Expansion---### New Sizes
		text = ['micro','tiny','small','average','large','massive']
		###---End Expansion---###
	for i in text:
		get_node("PlayerCustomizations/PCPenis").add_item(i)
		if (i == slavetemp['penis']['size']):
			get_node("PlayerCustomizations/PCPenis").select(get_node("PlayerCustomizations/PCPenis").get_item_count()-1)
	if (slavetemp['sex'] == 'male'): ### hair length
		text = ['ear', 'neck', 'bald']
	else:
		text = ['ear', 'neck', 'shoulder', 'waist', 'ass', 'bald']
	for i in text:
		get_node("PlayerCustomizations/PCHairLength").add_item(i)
		if (i == slavetemp['hairlength']):
			get_node("PlayerCustomizations/PCHairLength").select(get_node("PlayerCustomizations/PCHairLength").get_item_count()-1)
	if (slavetemp['race'] == 'Orc'): ### SkinColor
		text = ['green']
	elif (slavetemp['race'] in ['Tribal Elf','Dark Elf']):
		text = ['tan', 'brown', 'dark']
	else:
		text = [ 'pale', 'fair', 'olive', 'tan' ]
	for i in text:
		get_node("PlayerCustomizations/PCSkin").add_item(i)
		if (i == slavetemp['skin']):
			get_node("PlayerCustomizations/PCSkin").select(get_node("PlayerCustomizations/PCSkin").get_item_count()-1)
