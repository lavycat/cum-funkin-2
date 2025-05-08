extends Character
func _process(delta: float) -> void:
	if camera_focus:
		game.camera_lerp_zoom = 0.4
	else:
		if game.stage:
			game.camera_lerp_zoom = game.stage.default_cam_zoom
	super(delta)
