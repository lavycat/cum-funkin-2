class_name Character extends FunkinScript
@export_category("nodes")
@export var player:AnimationPlayer
@export var sprite:AnimatedSprite2D
@export var camera_position:Marker2D
@export_category("character")
@export var sing_length:float = 4.0
@export var dance_steps:Array[String] = ["idle"]
@export var is_player:bool = false
@export_category("icon")
@export var icon_color:Color = Color.WHITE
@export var icon:Texture = load("res://assets/images/game/icons/icon-dad.png")
var dance_step:int = 0
var sing_timer:float = 0.0
var cur_anim:String = ""
var auto_dance:bool = true
var camera_focus = false
var sing_suffix:String = ""
var can_dance:bool = true
var can_sing:bool = true
func _ready() -> void:
	dance()
	if is_player:
		scale.x *= -1
func play_anim(anim:String,force:bool = false):
	cur_anim = anim
	player.play(anim)
	player.seek(0,true,true)
func sing(dir:int,miss:bool = false):
	if not can_sing:
		return
	sing_timer = 0
	var directions = ["left","down","up","right"]
	if is_player:
		directions = ["right","down","up","left"]
	var miss_str = "_miss"
	if not miss:
		miss_str = ""
	var anim_to_play:String = "sing_%s%s"%[directions[dir],miss_str]
	if not sing_suffix.is_empty():
		anim_to_play += "_%s"%sing_suffix
	
	play_anim(anim_to_play,true)
func dance():
	if not can_dance:
		return
	play_anim(dance_steps[dance_step],true)
	dance_step = wrap(dance_step + 1,0,dance_steps.size())
func _process(delta: float) -> void:
	if cur_anim.contains("sing"):
		if game.paused:
			return
		sing_timer += delta
		if sing_timer > Conductor.step_length * sing_length:
			if auto_dance:
				dance()
func beat_hit(b:int):
	if not cur_anim.contains("sing") and (not player.is_playing() or dance_steps.size() > 1) and auto_dance:
		dance()
	
