extends Event
var char_path:String = ""
var penis:Character
var loading:bool = false
func _enter_tree() -> void:
	var v2 = event_values[1]
	char_path = "res://scenes/game/characters/%s.tscn"%v2
	if not ResourceLoader.exists(char_path):
		print("character not found -> %s"%char_path)
		char_path = "res://scenes/game/characters/dad.tscn"
	ResourceLoader.load_threaded_request(char_path)
	loading = true
	
func _process(delta: float) -> void:
	if loading:
		var s = ResourceLoader.load_threaded_get_status(char_path)
		if s == ResourceLoader.THREAD_LOAD_LOADED:
			penis = ResourceLoader.load_threaded_get(char_path).instantiate()
			loading = false
func trigger():
	var char_from = null
	var char_to = penis
	var v1 = event_values[0]
	match v1:
		"dad":
			char_from = game.dad
			char_to.position = char_from.position
			game.add_child(char_to)
			char_from.queue_free()
			game.dad = char_to
			game.play_field.dad_strum.chars = [game.dad]
		"bf":
			char_from = game.bf
			char_to.position = char_from.position
			game.add_child(char_to)
			char_from.queue_free()
			game.bf = char_to
			game.play_field.dad_strum.chars = [game.bf]
		"gf":
			char_from = game.gf
			char_to.position = char_from.position
			game.add_child(char_to)
			char_from.queue_free()
			game.gf = char_to
			game.play_field.dad_strum.chars = [game.gf]
			
	
	
	pass
