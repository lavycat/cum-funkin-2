extends Stage
var train_timer:float = 0
const TRAIN_TICK:float = 1.0/24.0
var train_moving:bool = false
var train_finishing:bool = false
var started_moving:bool = false
var train_cars:int = 8
var train_cooldown:int = 0
@onready var train: Sprite2D = $Train
@onready var train_sound: AudioStreamPlayer = $train_sound
func beat_hit(beat:int):
	if not train_moving:
		train_cooldown += 1
	if beat%8 == 4 and randi_range(0,100) > 30 and not train_moving and train_cooldown > 8:
		train_cooldown = randi_range(-4,0)
		train_start()
func _process(delta: float) -> void:
	if train_moving:
		train_timer += delta
		if train_timer >= TRAIN_TICK:
			update_train_pos()
			train_timer = 0
func train_start():
	train_moving = true
	train_sound.play()
func train_reset():
	game.gf.play_anim("hair_fall")
	train.position.x = 1480
	train_moving = false
	train_finishing = false
	started_moving = false
func update_train_pos():
	if train_sound.get_playback_position() >= 4.7:
		started_moving = true
		game.gf.play_anim("hair_blow")
		if train.position.x < -4000 and train_finishing:
			train_reset()
	if started_moving:
		train.position.x -= 400
		if train.position.x < -2000 and not train_finishing:
			train.position.x = -1150
			train_cars -= 1
			if train_cars <= 0:
				train_finishing = true
			
