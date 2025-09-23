extends Stage
func event_triggered(event:Event, time: float, values: Array) -> void:
	if event.name.to_lower() == "set_camera_bop":
		print(values)
		game.camera_bump_modulo = values[0]
		game.game_bump = Vector2(0.015,0.015) * Vector2(values[1],values[1])
		game.hud_bump = Vector2(0.03,0.03) * Vector2(values[1],values[1])
		
