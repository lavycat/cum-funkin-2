extends Node2D
@onready var graid: TextureRect = $SubViewportContainer/SubViewport/graid
var twen:Tween
func _ready() -> void:
	twen = create_tween().set_parallel()
	
