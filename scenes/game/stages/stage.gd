class_name Stage extends FunkinScript
@export var cam:Camera2D = null
@export var default_cam_zoom:float = 1.05
@onready var dad_position: Marker2D = $dad_position
@onready var gf_position: Marker2D = $gf_position
@onready var bf_position: Marker2D = $bf_position

func _ready() -> void:
	cam.zoom = Vector2(default_cam_zoom,default_cam_zoom)
