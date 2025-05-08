extends Node
var root:Window = null

var paths: PackedStringArray = []


func _collect_all_of_them(path: String = 'res://') -> void:
	var dir := DirAccess.open(path)
	for file in dir.get_files():
		if ResourceLoader.exists(path + file):
			ResourceLoader.load_threaded_request(path + file,"",true)
			paths.append(path + file)
	for new in dir.get_directories():
		_collect_all_of_them(path + new + '/')

func _enter_tree() -> void:
	root = get_tree().get_root()
	RenderingServer.set_default_clear_color(Color.BLACK)
	await Save.tree_entered
	var framerate = Save.get_data("video","fps_cap",60)
	var vsync = Save.get_data("video","vsync",false)
	
	Engine.max_fps = framerate
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED if not vsync else DisplayServer.VSYNC_ENABLED)
	var scroll_speed = Save.get_data("gameplay","scroll_speed",1.0)
	var use_scroll_speed = Save.get_data("gameplay","use_chart_scroll_speed",true)
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_reload"):
		get_tree().reload_current_scene()
	if event.is_action_pressed("full_screen",true,true):
		if root.mode == Window.MODE_FULLSCREEN:
			root.mode = Window.MODE_WINDOWED
		else:
			root.mode = Window.MODE_FULLSCREEN
