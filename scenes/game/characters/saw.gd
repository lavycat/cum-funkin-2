extends AnimatedSprite2D
@onready var dbtg:AnimatedSprite2D = get_parent()
func _ready() -> void:
	dbtg.animation_changed.connect(copy_anim)
func copy_anim():
	play(dbtg.animation)
