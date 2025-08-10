extends Node
var root:Window = null

var chart:Chart = null
var preloaded_characters:Dictionary = {}
var in_menu:bool = false
func preload_all_characters():
	const characters_folder:String = "res://scenes/game/characters/"
	for i in ResourceLoader.list_directory(characters_folder):
		if i.ends_with("tscn"):
			preloaded_characters.set(characters_folder + i,load(characters_folder + i))
func _enter_tree() -> void:
	root = get_tree().get_root()
	RenderingServer.set_default_clear_color(Color.BLACK)
	print("Audio Driver -> %s" % AudioServer.get_driver_name())
func _notification(what: int) -> void:
	match what:
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			if Save.json.auto_pause:
				Engine.max_fps = 5
		NOTIFICATION_APPLICATION_FOCUS_IN:
			if Save.json.auto_pause:
				Engine.max_fps = Save.json.fps
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_reload"):
		get_tree().reload_current_scene()
	if event.is_action_pressed("full_screen",true,true):
		if root.mode == Window.MODE_FULLSCREEN:
			root.mode = Window.MODE_WINDOWED
		else:
			root.mode = Window.MODE_FULLSCREEN
