extends CanvasLayer
@onready var fps: Label = $VBoxContainer/fps
@onready var ram: Label = $VBoxContainer/ram
var peak_mem:int = 0
func to_hum(s:int):
	return String.humanize_size(s)
func update_ui():
	var conductor_info:String = "time: %0.2f -- step: %d -- beat: %d -- bpm: %0.2f"%[Conductor.time,Conductor.step,Conductor.beat,Conductor.bpm]
	fps.text = "FPS: %d -- %0.2f ms\n%s"%[Engine.get_frames_per_second(),get_process_delta_time()*1000.0,conductor_info]
	var total_memory = Performance.get_monitor(Performance.RENDER_TEXTURE_MEM_USED)
	peak_mem = max(total_memory,peak_mem)
	ram.text = "mem: %s / %s"%[to_hum(total_memory),to_hum(peak_mem)]
func _physics_process(delta: float) -> void:
	if visible:
		update_ui()

func _input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return
	event = event as InputEventKey
	if event.is_pressed() and not event.is_echo():
		if event.keycode == KEY_F3:
			visible = !visible
		pass
	pass
