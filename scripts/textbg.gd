@tool
extends Node2D
@export var font:Font
@export var size:int = 72
@export var color:Color
@export_multiline var text:String = "":
	set(v):
		text = v
		queue_redraw()
func _draw() -> void:
	draw_string(font,Vector2.ZERO,text,HORIZONTAL_ALIGNMENT_LEFT,-1,size,color,3,TextServer.DIRECTION_AUTO,TextServer.ORIENTATION_HORIZONTAL,32)

	
