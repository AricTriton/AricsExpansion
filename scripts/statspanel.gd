
func _ready():
	for i in globals.statsdict:
		get(i).get_parent().get_node("Control").connect("mouse_entered", self, 'showtooltip', [i])
		get(i).get_parent().get_node("Control").connect("mouse_exited", globals, 'hidetooltip')
	

func showtooltip(value):
	var text = globals.statsdescript[value]
	globals.showtooltip(text)

func statup(stat):
	person[stat] += 1
	person.skillpoints -= 1
	show()

static func add_color_tag(text, color: String) -> String:
	return "[color=%s]%s[/color]" % [color, text]

func show():
	var mode_adv = mode in ['full','slaveadv']
	var mode_full = mode in ['full']
  
	show_stats(mode_adv, mode_full)
	show_traits(mode_adv, mode_full)
	show_stats_text(mode_adv, mode_full)
  get_node("levelprogress/Label").set_text("Experience: %d/%d (%d%%)" % [person.not_percent_xp, person.not_percent_max_xp, person.xp])

func show_stats(mode_adv: bool, mode_full: bool) -> void:
	for i in globals.statsdict:
		var stat_text = str(person[i])
		if i in ['sstr','sagi','smaf','send']:
			if person.stats[globals.maxstatdict[i].replace("_max",'_mod')] >= 1:
				stat_text = add_color_tag(stat_text, "green")
			elif person.stats[globals.maxstatdict[i].replace("_max",'_mod')] < 0:
				stat_text = add_color_tag(stat_text, "red")
		
		if mode_adv:
			stat_text += "/" + str(min(person.stats[globals.maxstatdict[i]], person.originvalue[person.origins]))
		get(i).set_bbcode(stat_text)

	for i in [cour, conf, wit, charm]:
		i.get_parent().visible = mode_adv


func show_traits(mode_adv: bool, mode_full: bool) -> void:
	var traits_text = ""

	if !person.traits.empty():
		var traits_array = PoolStringArray()

		for i in person.get_traits():
			var trait_text = "[url=%s]%s[/url]" % [i.name, i.name]

			if i.tags.find('sexual') >= 0:
				trait_text = add_color_tag(trait_text, "#ff5ace")
			elif i.tags.find('detrimental') >= 0:
				trait_text = add_color_tag(trait_text, "#ff4949")
			traits_array.append(trait_text)
		
		traits_text += "$name has trait(s): %s." % traits_array.join(", ")

	if person.spec != null:
		traits_text += "\n\nSpecialization: %s." % add_color_tag(globals.jobs.specs[person.spec].name, "aqua")

	get_node("text_container/traittext").set_bbcode(person.dictionary(traits_text))


func show_stats_text(mode_adv: bool, mode_full: bool) -> void:
	var level_data = PoolStringArray()
	if mode_full:
		if person == globals.player:
			level_data.append(person.dictionary('$name $surname'))
			level_data.append(person.dictionary('Race:  $race\n').capitalize())
		level_data.append("[url=race]%s[/url]" % add_color_tag(person.race, "aqua"))
		level_data.append("Health : %d/%d" % [round(person.health), round(person.stats.health_max)])
		level_data.append("Energy : %d/%d" % [round(person.energy), round(person.stats.energy_max)])
	level_data.append("Level : %d" % person.level)
	level_data.append("Attribute Points : %d" % person.skillpoints)

	var obedience_string = "Obedient"
	if person.effects.has('captured'):
		obedience_string = add_color_tag("Rebellious", "#ff4949")
	elif person.obed < 40:
		obedience_string = add_color_tag("Obeys poorly", "#ff4949")
	
	if mode_adv:
		level_data.append("Obedience: %d (%s)" % [round(person.obed), obedience_string])
	else:
		level_data.append("Obedience: %s" % obedience_string)
	
	get_node("text_container/leveltext").set_bbcode(person.dictionary(level_data.join("\n")))
