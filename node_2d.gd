extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	var full_rep = int(1280/sprite_2d.texture.get_width()*1.5) + 2
	RenderingServer.canvas_set_item_repeat(sprite_2d.get_canvas_item(),sprite_2d.texture.get_size(),full_rep)

	pass


func _process(delta: float) -> void:
	if Input.is_action_just_pressed(&"4k_up"):
		print("I love knocking out teeth - Mafioso")
