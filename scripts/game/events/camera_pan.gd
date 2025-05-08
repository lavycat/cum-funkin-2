extends Event

func trigger():
	var vals = self.event_values
	var chars = [game.dad,game.bf]
	for i in chars:
		if not i:
			return
	for i in chars:
		i.camera_focus = false
	var charrrr = chars[vals[0]]
	charrrr.camera_focus = true
	game.camera_lerp_position = charrrr.camera_position.global_position
