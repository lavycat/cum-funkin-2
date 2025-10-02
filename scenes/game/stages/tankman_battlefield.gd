extends Stage
@onready var tank_rolling: AnimatedSprite2D = $Parallax2D7/tank_rolling
@onready var boppers:Array[Node] = [$Parallax2D7/tower, $CanvasLayer/Parallax2D8/SparrowAtlas, $CanvasLayer/Parallax2D9/SparrowAtlas2, $CanvasLayer/Parallax2D11/SparrowAtlas4, $CanvasLayer/Parallax2D10/SparrowAtlas3, $CanvasLayer/Parallax2D12/SparrowAtlas5]
const tankX:float = 400 - 160
var tank_angle:float = randi_range(-90,45)
var tank_speed:float = randf_range(5,7)
func move_tank(delta:float) -> void:
	if not tank_rolling:
		return
	var da_angle_offset:float = 1
	tank_angle += delta*tank_speed
	tank_rolling.rotation_degrees = tank_angle - 90 + 15
	tank_rolling.position.x = tankX + cos(deg_to_rad((tank_angle*da_angle_offset) + 180))*1500
	tank_rolling.position.y = 1400+160 + sin(deg_to_rad((tank_angle * da_angle_offset) + 180)) * 1100;
	pass
func _process(delta: float) -> void:
	move_tank(delta)
func beat_hit(beat:int):
	for b in boppers:
		b.play()
