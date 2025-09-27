extends Event


func trigger(event_time: float, event_values: Array) -> void:
	var vals: Array = event_values
	var chars: Array[Character] = [game.dad,game.bf,game.gf]
	for i: Character in chars:
		if not i:
			return

	for i: Character in chars:
		i.camera_focus = false
	if vals[0] > chars.size() - 1:
		return

	var charrrr: Character = chars[vals[0]]
	charrrr.camera_focus = true
	game.camera_lerp_position = charrrr.camera_position.global_position
