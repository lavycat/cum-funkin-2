extends Stage
@onready var sub_viewport: SubViewport = $"real/0X1/SubViewport"
@onready var bg: TextureRect = $"real/0X1/Bg"
const BG_RENDER_SIZE = 360
func _ready() -> void:
	sub_viewport.size = Vector2(BG_RENDER_SIZE,BG_RENDER_SIZE)
	bg.texture = sub_viewport.get_texture()
func _physics_process(delta: float) -> void:
	sub_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	sub_viewport.render_target_clear_mode = SubViewport.CLEAR_MODE_ALWAYS
