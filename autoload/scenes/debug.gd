extends CanvasLayer
@onready var fps: Label = $VBoxContainer/fps
@onready var ram: Label = $VBoxContainer/ram
var peak_mem:int = 0

func update_ui():
	fps.text = "FPS: %d"%Engine.get_frames_per_second()
	var total_memory = Performance.get_monitor(Performance.RENDER_TEXTURE_MEM_USED)
	peak_mem = max(total_memory,peak_mem)
	ram.text = "MEMORY: %s/%s"%[String.humanize_size(total_memory),String.humanize_size(peak_mem)]
func _physics_process(delta: float) -> void:
	update_ui()
