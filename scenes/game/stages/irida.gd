extends Stage
@onready var sub_viewport: SubViewport = $"real/0X1/SubViewportContainer/SubViewport"
func _physics_process(delta: float) -> void:
	sub_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	sub_viewport.render_target_clear_mode = SubViewport.CLEAR_MODE_ONCE
