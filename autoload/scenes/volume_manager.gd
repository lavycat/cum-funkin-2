extends Node2D
var volume_ln:float = 1.0
var volume_mute:bool = false
const volume_inc:float = 0.1

const save_path:String = "user://volume.bin"



func _ready() -> void:
	_load()
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("volume_down"):
		volume_ln -= volume_inc
	if event.is_action_pressed("volume_up"):
		volume_ln += volume_inc
		if volume_mute:
			volume_mute = false
	if event.is_action_pressed("volume_mute"):
		volume_mute = !volume_mute
	volume_ln = clampf(volume_ln,0.0,1.0)
	volume_ln = snappedf(volume_ln,volume_inc)
	adjust_volume()
func save() -> void:
	Save.json.set("volume",volume_ln)
	Save.save_data()
func _load():
	await Save.ready
	volume_ln = Save.json.volume
	adjust_volume()
func adjust_volume():
	AudioServer.set_bus_volume_linear(0,volume_ln)
	AudioServer.set_bus_mute(0,volume_mute)
	save()
	
