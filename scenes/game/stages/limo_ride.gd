extends Stage
func event_triggered(event:Event, time: float, values: Array) -> void:
	if event.name.to_lower() == "set_camera_bop":
		print(values)
		pass
	pass
