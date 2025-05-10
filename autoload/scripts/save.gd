extends Node
const SAVE_PATH:String = "user://save.tres"
var data:SaveData = SaveData.new()

func load_data():
	if not ResourceLoader.exists(SAVE_PATH):
		data = SaveData.new()
		save_data()
	else:
		data = load(SAVE_PATH)
	
func save_data():
	ResourceSaver.save(data,SAVE_PATH)
func _enter_tree() -> void:
	load_data()
