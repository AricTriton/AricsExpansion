func getcost(item, mode):
	var cost = 0
	if mode == 'buy':
		cost = item.cost
	else:
		var merchant = false
		for i in globals.state.playergroup:
			if globals.state.findslave(i).spec == 'merchant':
				merchant = true
		if typeof(item) == TYPE_STRING:
			item = globals.itemdict[item]
		if globals.itemdict.has(item.code): 
			if globals.itemdict[item.code].type != 'gear':
				cost = item.cost*variables.sellingitempricemod
				if merchant == true:
					cost *= 1.25
				if item.type == 'potion' && globals.state.spec == "Alchemist":
					cost *= 2
			else:
				var itemtype = globals.itemdict[item.code]
				cost = itemtype.cost*variables.sellingitempricemod
				if item.has('enchant') && item.enchant != '':
					cost = cost*variables.enchantitemprice

	if item.code != "food":
		cost *= globals.expansionsettings.itemCostMod
	return round(cost)