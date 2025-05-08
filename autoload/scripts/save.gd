extends Node
const SAVE_PATH:String = "user://save.cfg"
var data:ConfigFile = ConfigFile.new()

func load_data():
	if not FileAccess.file_exists(SAVE_PATH):
		data = ConfigFile.new()
		save_data()
	var err = data.load(SAVE_PATH)

func get_data(section:String,val:String,fallback:Variant = null):
	if not data.has_section_key(section,val):
		data.set_value(section,val,fallback)
		save_data()
		load_data()
	var sigma = data.get_value(section,val,fallback)
	return sigma
	
func save_data():
		data.save(SAVE_PATH)
func _enter_tree() -> void:
	load_data()
