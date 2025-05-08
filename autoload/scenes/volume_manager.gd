extends Node2D
var volume_ln:float = 1.0
var volume_mute:bool = false
const volume_inc:float = 0.05

const save_path:String = "user://volume.bin"



func _enter_tree() -> void:
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
	volume_ln = snappedf(volume_ln,0.05)
	adjust_volume()
func save() -> void:
	var p = FileAccess.open(save_path,FileAccess.WRITE)
	p.store_buffer([int(volume_ln * 100.0),int(volume_mute)])
	p.flush()
	p.close()
func _load():
	if !FileAccess.file_exists(save_path):
		save()
	var p = FileAccess.open(save_path,FileAccess.READ)
	var buf = p.get_buffer(2)
	volume_ln = buf[0] / 100.0
	volume_mute = buf[1]
	adjust_volume()
func adjust_volume():
	AudioServer.set_bus_volume_linear(0,volume_ln)
	AudioServer.set_bus_mute(0,volume_mute)
	save()
	
