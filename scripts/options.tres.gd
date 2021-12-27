
<AddTo 23>
func ruletoggle(rule):
	###---Added by Expansion---### centerflag982
	if rule == 'dickgirl':
		if (globals.rules['dickgirl'] == false):
			get_node("TabContainer/Game/dickgirlsliderlabel").set_text('Random dickgirl occurrence: 0% of remaining females, 0% of people are dickgirls')
			get_node("TabContainer/Game/dickgirlslider").set_editable(false)
		else:
			dickgirlslider(globals.rules['dickgirl_chance'])
			get_node("TabContainer/Game/dickgirlslider").set_editable(true)
	###---End Expansion---###

<AddTo 2>
func _ready():
	###---Added by Expansion---### centerflag982 
	dickgirlslider(globals.rules.dickgirl_chance)
	get_node("TabContainer/Game/dickgirlslider").set_editable(globals.rules.dickgirl)
	###---End Expansion---###

<RemoveFrom 3 3>
func _ready():
#	for i in ['furry','furrynipples','futa','futaballs','slaverguildallraces','children','receiving','permadeath','noadults']:

<AddTo 3>
func _ready():
	for i in ['furry','furrynipples','futa','futaballs','dickgirl','slaverguildallraces','children','receiving','permadeath','noadults']:

<AddTo -1>
func _on_malesslider_value_changed( value ):
	dickgirlslider(globals.rules['dickgirl_chance'])

<AddTo -1>
func _on_futaslider_value_changed( value ):
	dickgirlslider(globals.rules['dickgirl_chance'])

###---Added by Expansion---### centerflag982 
func dickgirlslider(value):
	globals.rules.dickgirl_chance = value
	get_node("TabContainer/Game/dickgirlslider").set_value(globals.rules['dickgirl_chance'])
	if (globals.rules['dickgirl']):
		get_node("TabContainer/Game/dickgirlsliderlabel").set_text('Random dickgirl occurrence: ' + str(globals.rules['dickgirl_chance']) + '% of remaining females, '
			+ str(round((100-globals.rules['male_chance'])*(100-globals.rules['futa_chance'])*globals.rules['dickgirl_chance']/1000)/10) + '% of people are dickgirls')
	else:
		get_node("TabContainer/Game/dickgirlsliderlabel").set_text('Random dickgirl occurrence: 0% of females, 0% of people are dickgirls')
###---End Expansion---###

func _on_dickgirlslider_value_changed( value ):
	globals.rules['dickgirl_chance'] = value
	get_node("TabContainer/Game/dickgirlsliderlabel").set_text('Random dickgirl occurrence: ' + str(globals.rules['dickgirl_chance']) + '% of remaining females, '
			+ str(round((100-globals.rules['male_chance'])*(100-globals.rules['futa_chance'])*globals.rules['dickgirl_chance']/1000)/10) + '% of people are dickgirls')
