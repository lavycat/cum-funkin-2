extends Node
var root:Window = null

var chart:Chart = null
var preloaded:Array[Resource] = [preload("res://assets/images/menus/djs/bf/dj.png")]
var in_menu:bool = false
# NOTE -> made for freeplay to override them for a gameplay intance use Game class!
var game_modifiers:GameModifiers = GameModifiers.new()
var game_meta:SongMeta = SongMeta.new()



func _enter_tree() -> void:
	game_modifiers = GameModifiers.new()
	Input.use_accumulated_input = true
	root = get_tree().get_root()
	RenderingServer.set_default_clear_color(Color.BLACK)
	print("Audio Driver -> %s" % AudioServer.get_driver_name())
	print("Rendering Driver -> %s"%RenderingServer.get_current_rendering_driver_name())
func time_convert(time_in_sec:int) -> String:
	var seconds = time_in_sec%60
	var minutes = (time_in_sec/60)%60
	#returns a string with the format "HH:MM:SS"
	return "%01d:%02d" % [minutes, seconds]
func _ready() -> void:
	DiscordRPC.app_id = 1419266924252106847
	DiscordRPC.large_image = "default"
	DiscordRPC.refresh()
	print("DISCORD RPC WORKING: %s"%DiscordRPC.get_is_discord_working())
func _notification(what: int) -> void:
	match what:
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			if Save.json.auto_pause:
				Engine.max_fps = 30
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
func rand_bool(chance:int = 50) -> bool:
	randomize()
	return randf_range(0,1) < chance/100.0
