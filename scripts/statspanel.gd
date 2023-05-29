
# fix zero traits slave guild issue
<AddTo 15>
func show():
	text = ""

# show absolute amount of xp
<AddTo 42>
func show():
	get_node("levelprogress/Label").set_text("Experience: %d/%d (%d%%)" % [person.not_percent_xp, person.not_percent_max_xp, person.xp])
