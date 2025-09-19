extends Event


var preloaded_characters: Dictionary[String, PackedScene] = {}


func register(event_time: float, event_values: Array) -> void:
	var character_name: String = event_values[1]
	var char_path: String = "res://scenes/game/characters/%s.tscn" % character_name
	if not ResourceLoader.exists(char_path):
		char_path = "res://scenes/game/characters/dad.tscn"
	var char := char_path.get_file().get_basename()
	if not game.cache.has(char_path):
		game.cache.set(char_path,load(char_path))
	preloaded_characters[char] = load(char_path)


func trigger(event_time: float, event_values: Array) -> void:
	if not preloaded_characters.has(event_values[1]):
		printerr("Couldn't find character '%s'!" % event_values[1])
		return

	var char_from: Character = null
	var char_scene: PackedScene = preloaded_characters[event_values[1]]
	var char_to: Character = char_scene.instantiate()
	match event_values[0]:
		"dad",0.0:
			char_from = game.dad
			char_to.position = char_from.position
			game.stage.add_child(char_to)
			char_from.queue_free()
			game.dad = char_to
			game.dad_field.reset_characters()
		"bf",1.0:
			
			char_from = game.bf
			char_to.position = char_from.position
			game.stage.add_child(char_to)
			char_from.queue_free()
			game.bf = char_to
			game.player_field.reset_characters()
		"gf",2.0:
			char_from = game.gf
			char_to.position = char_from.position
			game.stage.add_child(char_to)
			char_from.queue_free()
			game.gf = char_to

	game.hud.callv("reload_icons", [])
