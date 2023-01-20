var picturesLoaded = false
var backgrounds = {}

func initiatePictureLoad():
	var locationFolders = []
	var dir1 = Directory.new()
	var dir2 = Directory.new()
	var dir3 = Directory.new()
	dir1.open("user://mods/AricsExpansion/fpm_BG_Sprites")
	dir1.list_dir_begin()

	while true:
		var file = dir1.get_next()
		if file == "":
			break
		elif not file.begins_with(".") && dir1.current_is_dir():
			locationFolders.append(file)
	
	dir1.list_dir_end()
	
	for n in locationFolders.size():
		dir1.open("user://mods/AricsExpansion/fpm_BG_Sprites/" + locationFolders[n])
		dir1.list_dir_begin()
		backgrounds[locationFolders[n]] = {}
		
		while true:
			var locationVariant = dir1.get_next()
			if locationVariant == "":
				break
			elif not locationVariant.begins_with(".") && dir1.current_is_dir():
				dir2.open("user://mods/AricsExpansion/fpm_BG_Sprites/" + locationFolders[n] + "/" + locationVariant)
				dir2.list_dir_begin()
				
				var pngArray = []
				while true:
					var png = dir2.get_next()
					if png == "":
						break
					elif not png.begins_with(".") && dir2.current_is_dir():
						dir3.open("user://mods/AricsExpansion/fpm_BG_Sprites/" + locationFolders[n] + "/" + locationVariant + "/" + png)
						dir3.list_dir_begin()
						
						var subPngArray = []
						while true:
							var subPng = dir3.get_next()
							if subPng == "":
								break	
							elif not subPng.begins_with(".") && subPng.get_extension() == "png":
								subPngArray.append(globals.loadimage("user://mods/AricsExpansion/fpm_BG_Sprites/" + locationFolders[n] + "/" + locationVariant + "/" + png + "/" + subPng))
								
						dir3.list_dir_end()
						if subPngArray.size() != 0:
							backgrounds[locationFolders[n]][locationVariant + "_" + png] = subPngArray
						
					elif not png.begins_with(".") && png.get_extension() == "png":
						pngArray.append(globals.loadimage("user://mods/AricsExpansion/fpm_BG_Sprites/" + locationFolders[n] + "/" + locationVariant + "/" + png))
				
				dir2.list_dir_end()
				if pngArray.size() != 0:
					backgrounds[locationFolders[n]][locationVariant] = pngArray
		dir1.list_dir_end()
