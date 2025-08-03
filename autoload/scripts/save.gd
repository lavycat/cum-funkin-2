extends Node
const SAVE_PATH:String = "user://save.tres"
var data:SaveData = SaveData.new()

func load_data():
	if not ResourceLoader.exists(SAVE_PATH):
		data = SaveData.new()
	else:
		data = load(SAVE_PATH)
	save_data()
	load_binds()
func load_binds():
	for k in data.key_binds:
		InputMap.action_erase_events(k)
		var val = data.key_binds.get(k)
		for v in val:
			var ev := InputEventKey.new()
			ev.keycode = OS.find_keycode_from_string(v)
			InputMap.action_add_event(k,ev)
			
			print(OS.get_keycode_string(KEY_Z))
			print(OS.get_keycode_string(KEY_X))
			print(OS.get_keycode_string(KEY_COMMA))
			print(OS.get_keycode_string(KEY_PERIOD))
			
		
func save_data():
	ResourceSaver.save(data,SAVE_PATH)
func _ready() -> void:
	load_data()
