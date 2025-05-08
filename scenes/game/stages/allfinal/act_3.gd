extends FunkinScript


@onready var bf: Character = $Bf
@onready var gf: Character = $gf
@onready var head: AnimatedSprite2D = $"08-08/cum/head"
@onready var eyes: AnimatedSprite2D = $"08-08/cum/eyes"
@onready var head_2: AnimatedSprite2D = $"08-08/cum/head2"
@onready var body: AnimatedSprite2D = $"08-08/cum/body"
var cur_idle:String = "torso idle 1"
func _ready() -> void:
	game.bf = bf
	game.dad = gf
	game.play_field.player_strum.chars = [game.bf]
	game.play_field.dad_strum.chars = [game.dad]
	
	game.camera_lerp_zoom = 0.65
	
func step_hit(step:int):
	match step:
		2976:
			head.play("ultra m lyrics 1")
		3232:
			head.visible = false
			head_2.visible = true
			head_2.play("ultra m lyrics 2")
			head.queue_free()
		3483:
			head_2.play("ultra m head laugh")
			body.play("torso change pose")
			cur_idle = "torso idle 2"
			
func beat_hit(beat):
	if not body.is_playing():
		body.play(cur_idle)
