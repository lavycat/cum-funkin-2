class_name FreeplayItem extends Node2D
const CAPSULE_HEIGHT:int = 148
var target_position:Vector2 = Vector2.ZERO
var do_lerp:bool = true
@export var data:FreeplayItemData
@onready var bpm_number: Node2D = $bpm_number
@onready var week_numbe: Node2D = $week_numbe
@onready var song_text: Label = $capsule/Control/song_text
@onready var icon: SparrowAtlas = $icon
@onready var capsule: SparrowAtlas = $capsule

func _ready() -> void:
	bpm_number.num = data.bpm
	week_numbe.num = data.week_number
	song_text.text = data.name
	icon.sprite_frames = data.icon
func _process(delta: float) -> void:
	if do_lerp:
		position.x = lerp(position.x,target_position.x,delta*18.0)
		position.y = lerp(position.y,target_position.y,delta*24.2)
		
func get_pos(index:int) -> Vector2:
	var y:float = (((index+1) * (CAPSULE_HEIGHT + 10)) + 120) + 18 - (100 if index < -1 else 0);
	var x:float = 240 + ((60 * (sin(index+1)))) + 80;
	return Vector2(x,y)
func select():
	capsule.play("selected")
	pass
func deselect():
	capsule.play("unselected")
func confirm():
	icon.play("confirm")
