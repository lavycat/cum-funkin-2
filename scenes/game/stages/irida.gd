extends Stage
@onready var sub_viewport: SubViewport = $"real/0X1/SubViewport"
@onready var bg: TextureRect = $"real/0X1/Bg"
const BG_RENDER_SIZE = 4096
var performance_mode:bool = true

func _ready() -> void:
	performance_mode = Save.json.get("shaders").to_lower() != "all"
	sub_viewport.size = Vector2(BG_RENDER_SIZE,BG_RENDER_SIZE)
	bg.texture = sub_viewport.get_texture()
	sub_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	sub_viewport.render_target_clear_mode = SubViewport.CLEAR_MODE_ONCE
func _physics_process(delta: float) -> void:
	if not performance_mode:
		sub_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
		sub_viewport.render_target_clear_mode = SubViewport.CLEAR_MODE_ONCE
