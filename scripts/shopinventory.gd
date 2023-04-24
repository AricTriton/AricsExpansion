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


func _on_SpinBox_value_changed(value):
	var text = ""
	var item = selecteditem.get_meta('item')
	var amount = $amountselect/SpinBox.value

	var max_item_amount = int(selecteditem.get_node('number').text)
	if isBuying:
		max_item_amount = floor(globals.resources.gold / selecteditem.get_meta('price'))
	if $amountselect/SpinBox.value > max_item_amount:
		$amountselect/SpinBox.value = max_item_amount
		amount = max_item_amount

	if isBuying:
		var cost = getcost(item, 'buy')
		text += "You will purchase [color=green]" + item.name + "[/color] for " + str(cost) + " gold each. "
		text += "\nCost for [color=yellow]" + str(amount) + "[/color] is [color=yellow]" + str(cost*amount) + "[/color] gold"
	else:
		var cost = getcost(item, 'sell')
		text += "You will sell [color=green]" + item.name + "[/color] for " + str(cost) + " gold each. "
		text += "\nOffer for [color=yellow]" + str(amount) + "[/color] is [color=yellow]" + str(cost*amount) + "[/color] gold"
	$amountselect/RichTextLabel.bbcode_text = text