extends Node

var selectedcategory
var selectedupgrade

###---Added by Expansion---### Removed 'farmmana' from Farm as it was causing Bugs and not in mansionupgrades.gd. Add other Buttons here
var categories = {
	mansion = {upgrades = ['mansioncommunal','mansionpersonal','mansionbed', 'mansionluxury']},
	facilities = {upgrades = ['mansionalchemy', 'mansionlibrary', 'mansionparlor', 'mansionkennels', 'mansionnursery', 'dimensionalcrystal', 'mansionlab','traininggrounds']},
	jail = {upgrades = ['jailcapacity','jailtreatment','jailincenses']},
	storage = {upgrades = ['foodcapacity', 'foodpreservation']},
	farm = {upgrades = ['farmcapacity', 'farmhatchery', 'farmtreatment','bottler','vatspace','vatmilk','vatsemen','vatlube','vatpiss']},
}

var purchaseupgrade

func _ready():
	purchaseupgrade = get_node("upgradepanel/purchaseupgrade")
	purchaseupgrade.connect("pressed",self,'purchasconfirm')
	for i in get_node("categories/VBoxContainer").get_children():
		if i.get_class() == "Button":
			i.connect("pressed",self,'categoryselect', [i])

func show():
#	###---Added by Expansion---### Alexsis
#	if get_parent().get_name() == "mansion":
#		get_tree().get_current_scene()._on_mansion_pressed()
#		yield(get_tree().get_current_scene(), 'animfinished')
#	###---End Expansion---###
	self.visible = true
	get_node("upgradepoints").set_text("Available upgrade points:"+str(globals.resources.upgradepoints))
	selectedupgrade = null
	selectedcategory = null
	get_node("categories/VBoxContainer/farm").visible = globals.state.farm >= 3
	get_node("upgradepanel").visible = false
	for i in get_node("upgrades/VBoxContainer").get_children():
		if i != get_node("upgrades/VBoxContainer/button"):
			i.visible = false
			i.queue_free()
	for i in get_node("categories/VBoxContainer").get_children():
		if i != get_node("categories/VBoxContainer/Label"):
			i.set_pressed(false)

func categoryselect(button):
	selectedcategory = button
	for i in get_node("categories/VBoxContainer").get_children():
		if i != button && i.get_class() != 'Label':
			i.set_pressed(false)
	button.set_pressed(true)
	for i in get_node("upgrades/VBoxContainer").get_children():
		if i != get_node("upgrades/VBoxContainer/button"):
			i.visible = false
			i.queue_free()
	var category = button.get_name()
	selectedupgrade = button
	for i in categories[category].upgrades:
		var upgrade = globals.mansionupgradesdict[i]
		var newbutton = get_node("upgrades/VBoxContainer/button").duplicate()
		var currentupgradelevel = globals.state.mansionupgrades[upgrade.code]
		get_node("upgrades/VBoxContainer").add_child(newbutton)
		newbutton.set_text(upgrade.name)
		if upgrade.levels == currentupgradelevel:
			newbutton.set('custom_colors/font_color', Color(0,0.4,0))
			#newbutton.set('custom_colors/font_color_hover', Color(0.2,0.8,0.2))
			#newbutton.set('custom_colors/font_color_pressed', Color(0.2,0.8,0.2))
		newbutton.visible = true
		newbutton.set_meta("upgrade", upgrade)
		newbutton.connect("pressed",self,'upgradeselected',[upgrade])
		###---Added by Expansion---### Disable the buttons until available
		if upgrade.code == 'dimensionalcrystal':
			if globals.state.sidequests.dimcrystal == 0:
				newbutton.set_disabled(true)
				newbutton.set_tooltip("You aren't sure where this even is currently. Maybe time will reveal it?")
#TBK- remove nursery reqs			if globals.state.mansionupgrades.mansionnursery < 1:
#				newbutton.set_disabled(true)
#				newbutton.set_tooltip("The nursery needs to be purchased first.")
		#Ensure that the number of Vats is less than the VatSpace purchased
		var vatupgrades = ['vatmilk','vatsemen','vatlube','vatpiss']
		if upgrade.code in vatupgrades:
			if globals.state.mansionupgrades[upgrade.code] == 0:
				var vattemp = 0
				for vats in [globals.state.mansionupgrades.vatmilk, globals.state.mansionupgrades.vatsemen, globals.state.mansionupgrades.vatlube, globals.state.mansionupgrades.vatpiss]:
					if vats > 0:
						vattemp += 1
				if vattemp >= globals.state.mansionupgrades.vatspace:
					newbutton.set_disabled(true)
					newbutton.set_tooltip("You need to clear out more space on your farm to install a new Vat.")
		###---End Expansion---###


func upgradeselected(upgrade):
	var text = ''
	var noprice = false
	var canpurchase = true
	var currentupgradelevel = globals.state.mansionupgrades[upgrade.code]
	var cost
	var limit = upgrade.levels
	get_node("upgradepanel").popup()
	for i in get_node("upgrades/VBoxContainer").get_children():
		if i != get_node("upgrades/VBoxContainer/button") && i.get_meta('upgrade') != upgrade:
			i.set_pressed(false)
	text = upgrade.description
	if upgrade.code in ['mansioncommunal', 'mansionpersonal','mansionbed','jailcapacity'] && globals.state.nopoplimit == true:
		limit = 999
		
	if limit == 1:
		if currentupgradelevel == 1:
			noprice = true
			canpurchase = false
			text += "\n[color=green]You’ve already purchased this upgrade..[/color]"
	else:
		if currentupgradelevel < limit:
			###---Added by Expansion---### Description Expansion past 2
			if currentupgradelevel >= 5 && upgrade.has("description6"):
				text = upgrade.description6
			elif currentupgradelevel >= 4 && upgrade.has("description5"):
				text = upgrade.description5
			elif currentupgradelevel >= 3 && upgrade.has("description4"):
				text = upgrade.description4
			elif currentupgradelevel >= 2 && upgrade.has("description3"):
				text = upgrade.description3
			elif currentupgradelevel >= 1 && upgrade.has("description2"):
				text = upgrade.description2
			###---End Expansion---###
			text += "\n\nCurrent level: " + str(currentupgradelevel) + "/" + str(limit)
		else:
			noprice = true
			canpurchase = true
			text += "\n\n[color=green]You cannot upgrade this any further.[/color]"
	purchaseupgrade.set_meta('upgrade',upgrade)
	
	if upgrade.has("valuename"):
		text += "\n\n\t\t\t\t" + upgrade.valuename + '\nCurrent level: '
		if upgrade.has("valuenumber"):
			text += upgrade.valuenumber[currentupgradelevel]
		else:
			text += str(currentupgradelevel)
		if limit > currentupgradelevel:
			text += "\nNext Level: "
			if upgrade.has("valuenumber"):
				text += upgrade.valuenumber[currentupgradelevel+1]
			else:
				text += str(currentupgradelevel+1)
	if !noprice:
		if typeof(upgrade.cost) == TYPE_INT:
			cost = upgrade.cost
		else:
			cost = upgrade.cost[currentupgradelevel]
		cost *= globals.expansionsettings.upgradeCostMod
		purchaseupgrade.set_meta('cost', cost)
		text += "\n\nPrice: [color=yellow]" + str(cost) + ' gold[/color]'
		###---Added by Expansion---### Added Aqua Color to Upgrade Points
		var upgradePointCost = upgrade.pointscost * globals.expansionsettings.upgradePointsCostMod
		purchaseupgrade.set_meta('pointsCost', upgradePointCost)
		text += "\n\nRequired Upgrade Points: [color=aqua]" + str(upgradePointCost) + '[/color]'
		###---End Expansion---###
		if globals.resources.gold < cost || globals.resources.upgradepoints < upgradePointCost:
			canpurchase = false
	get_node("upgradepanel/RichTextLabel").set_bbcode(text)
	
	
	if canpurchase == false || noprice:
		purchaseupgrade.set_disabled(true)
	else:
		purchaseupgrade.set_disabled(false)

func _on_cancelupgrade_pressed():
	get_node("upgradepanel").visible = false
	for upgradeButton in get_node("upgrades/VBoxContainer").get_children():
		upgradeButton.set_pressed(false)
		upgradeButton.release_focus()

func purchasconfirm():
	var upgrade = purchaseupgrade.get_meta("upgrade")
	var currentupgradelevel = globals.state.mansionupgrades[upgrade.code]
	globals.resources.gold -= purchaseupgrade.get_meta("cost")
	globals.resources.upgradepoints -= purchaseupgrade.get_meta("pointsCost")
	globals.state.mansionupgrades[upgrade.code] += 1
	if upgrade.code == 'mansionlab':
		globals.main.get_node("Navigation/laboratory").set_disabled(false)
	categoryselect(selectedcategory)
	upgradeselected(upgrade)
	get_node("upgradepoints").set_text("Free upgrade points:"+str(globals.resources.upgradepoints))




