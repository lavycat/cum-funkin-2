extends Node
const SAVE_PATH:String = "user://save.json"
var json:Dictionary = default_json
const default_json = {
	"fps": 144,
	"vsync": false,
	# all,minimal,none
	"shaders": "all",
	# canvas item, viewport
	"scaling_mode": "canvas_item",
	"down_scroll": false,
	"scroll_speed": 1.0,
	"use_chart_scroll_speed": true,
	"auto_pause": true,
	"stage_darkness": 0.0,
	"offset": 0.0,
	"volume":1.0,
	"key_binds": {
		"4k_left": ["D","left"],
		"4k_down": ["F","down"],
		"4k_up": ["J","up"],
		"4k_right": ["K","right"]
	},
	"scores": {
		"song_scores":{},
		"level_scores":{}
	}
}
func load_data():
		
	if not ResourceLoader.exists(SAVE_PATH):
		json = default_json.duplicate(true)
	else:
		json = JSON.parse_string(FileAccess.get_file_as_string(SAVE_PATH))
		for i in default_json:
			if not json.has(i):
				json.set(i,default_json.get(i))
		
	save_data()
	load_binds()
	update_data()
func load_binds():
	for k in json.key_binds:
		InputMap.action_erase_events(k)
		var val = json.key_binds.get(k)
		for v in val:
			var ev := InputEventKey.new()
			ev.keycode = OS.find_keycode_from_string(v)
			InputMap.action_add_event(k,ev)
			
		
func save_data():
	var f = FileAccess.open(SAVE_PATH,FileAccess.WRITE)
	f.store_string(JSON.stringify(json,"\t"))
	f.flush()
func update_data():
	Engine.max_fps = json.fps
	var v_mode = DisplayServer.VSYNC_ADAPTIVE if json.vsync else DisplayServer.VSYNC_DISABLED
	DisplayServer.window_set_vsync_mode(v_mode)
	var window = get_window()
	match json.scaling_mode:
		"canvas_item":
			window.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
		_: 
			window.content_scale_mode = Window.CONTENT_SCALE_MODE_VIEWPORT
			
	
func _ready() -> void:
	load_data()
