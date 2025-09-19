extends CanvasLayer
@onready var fps: Label = $VBoxContainer/fps
var peak_mem:int = 0
func to_hum(s:int):
	return String.humanize_size(s)
func update_ui():
	var conductor_info:String = "time: %0.2f -- step: %d -- beat: %d -- bpm: %0.2f\n"%[Conductor.time,Conductor.step,Conductor.beat,Conductor.bpm]
	var engine_info:String = "Godot Engine v%s\n"%Engine.get_version_info().string
	var graphics_info:String = "api: %s -- gpu: %s -- primitives: %d"%[RenderingServer.get_current_rendering_driver_name(),RenderingServer.get_video_adapter_name(),Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME)]
	fps.text = engine_info
	fps.text += "FPS: %d -- %0.2f ms\n%s"%[Engine.get_frames_per_second(),get_process_delta_time()*1000.0,conductor_info]
	var total_memory = Performance.get_monitor(Performance.RENDER_TEXTURE_MEM_USED)
	peak_mem = max(total_memory,peak_mem)
	fps.text += "mem: %s / %s\n"%[to_hum(total_memory),to_hum(peak_mem)]
	fps.text += graphics_info
	
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
