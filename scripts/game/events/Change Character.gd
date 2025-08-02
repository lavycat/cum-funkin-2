extends Event


var requested_paths: Array[String] = []
var preloaded_characters: Dictionary[String, PackedScene] = {}
var loading: bool = false


func register(event_time: float, event_values: Array) -> void:
	var character_name: String = event_values[1]
	var char_path: String = "res://scenes/game/characters/%s.tscn" % character_name
	if not ResourceLoader.exists(char_path):
		char_path = "res://scenes/game/characters/dad.tscn"

	requested_paths.push_back(char_path)
	ResourceLoader.load_threaded_request(char_path)
	loading = true


func _process(delta: float) -> void:
	if not loading:
		return

	loading = false
	for path: String in requested_paths:
		var status := ResourceLoader.load_threaded_get_status(path)
		if status == ResourceLoader.THREAD_LOAD_LOADED:
			preloaded_characters[path.get_file().get_basename()] = ResourceLoader.load_threaded_get(path)
			requested_paths.erase(path)
		elif status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			loading = true

func trigger(event_time: float, event_values: Array) -> void:
	var char_from: Character = null
	var char_scene: PackedScene = preloaded_characters[event_values[1]]
	var char_to: Character = char_scene.instantiate()
	match event_values[0]:
		"dad":
			char_from = game.dad
			char_to.position = char_from.position
			game.add_child(char_to)
			char_from.queue_free()
			game.dad = char_to
		"bf":
			char_from = game.bf
			char_to.position = char_from.position
			game.add_child(char_to)
			char_from.queue_free()
			game.bf = char_to
		"gf":
			char_from = game.gf
			char_to.position = char_from.position
			game.add_child(char_to)
			char_from.queue_free()
			game.gf = char_to

	game.hud.callv("reload_icons", [])
