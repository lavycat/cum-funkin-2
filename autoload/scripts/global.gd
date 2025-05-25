extends Node
var root:Window = null

var paths: PackedStringArray = []
var chart = null
func _enter_tree() -> void:
	root = get_tree().get_root()
	RenderingServer.set_default_clear_color(Color.BLACK)
	Engine.max_fps = Save.data.frame_rate
func _notification(what: int) -> void:
	match what:
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			if Save.data.auto_pause:
				Engine.max_fps = 5
		NOTIFICATION_APPLICATION_FOCUS_IN:
			if Save.data.auto_pause:
				Engine.max_fps = Save.data.frame_rate
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_reload"):
		get_tree().reload_current_scene()
	if event.is_action_pressed("full_screen",true,true):
		if root.mode == Window.MODE_FULLSCREEN:
			root.mode = Window.MODE_WINDOWED
		else:
			root.mode = Window.MODE_FULLSCREEN
