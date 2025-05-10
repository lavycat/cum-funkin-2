extends Node
var root:Window = null

var paths: PackedStringArray = []

func _enter_tree() -> void:
	root = get_tree().get_root()
	RenderingServer.set_default_clear_color(Color.BLACK)
	await Save.tree_entered
	var vsync = Save.data.vsync
	
	Engine.max_fps = Save.data.frame_rate
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED if not vsync else DisplayServer.VSYNC_ENABLED)
	var scroll_speed = Save.data.scroll_speed
	var use_scroll_speed = Save.data.use_chart_scroll_speed

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_reload"):
		get_tree().reload_current_scene()
	if event.is_action_pressed("full_screen",true,true):
		if root.mode == Window.MODE_FULLSCREEN:
			root.mode = Window.MODE_WINDOWED
		else:
			root.mode = Window.MODE_FULLSCREEN
