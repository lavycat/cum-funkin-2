extends Stage
@onready var vido: VideoStreamPlayer = $cutscene/vido
@onready var normal: Node2D = $normal
@onready var evil: Node2D = $evil
@onready var colorfg: ColorRect = $cutscene/colorfg
@onready var front_jeff: AnimatedSprite2D = $cutscene2/front_jeff

@onready var cutscene_2: Node2D = $cutscene2
var og_pos:Array[Vector2]
var loading_front_jeff:bool = false
var loading_front_marv:bool = false
@onready var house: AnimatedSprite2D = $normal/AnimatedSprite2D2

var loading_jeff:bool = false
var loading_marv:bool = false
var cur_rate:float = 0
@onready var dick: Character = $art_style_change_for_no_reason/Bf
@onready var balls: Character = $art_style_change_for_no_reason/Bf2
@onready var art_style_change_for_no_reason: Node2D = $art_style_change_for_no_reason


func _ready() -> void:
	cur_rate = Conductor.rate
	for i in game.play_field.dad_strum.receptors:
		og_pos.append(i.position)
func step_hit(step:int):
	match step:
		826:
			house.play("chop")
		1660:
			evil_request()
		1664:
			evil_switch()
		2176:
			game.hud.modulate.a = 0
		2200:
			play_aethos_vid()
		2456:
			create_tween().tween_property(game.hud,"modulate:a",1.0,0.5).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
			game.play_field.dad_strum.visible = false
			create_tween().tween_property(game.play_field.player_strum,"position:x",640,0.7).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SPRING)
		2720:
			fake_out()
		2960:
			fake_out_stop()
		3290:
			loving_famaily.scale = Vector2.ONE
			create_tween().tween_property(colorfg,"color:a",0,0.3)
		3293:
			loving_famaily.play("breakdown")
		3304:
			create_tween().tween_property(loving_famaily,"scale",Vector2(1.5,1.5),.33).set_trans(Tween.TRANS_CIRC)
			var p = create_tween().tween_property(loving_famaily,"scale",Vector2(2,2),.33).set_trans(Tween.TRANS_CIRC).set_delay(0.33)
			await p.finished
			loving_famaily.queue_free()
			game.bf.queue_free()
			
			art_style_change_for_no_reason.visible = true
			game.dad = dick
			game.bf = balls
			game.play_field.dad_strum.chars = [game.dad]
			game.play_field.player_strum.chars = [game.bf]
			game.camera_lerp_position =  game.dad.camera_position.global_position
			colorfg.visible = false
			game.visible = true
			game.hud.visible = true
			
			
			
		
	pass
@onready var loving_famaily: AnimatedSprite2D = $"cutscene/fake out/loving_famaily"

func fake_out():
	front_jeff.queue_free()
	game.visible = false
	game.hud.visible = false
	
	
	var t = create_tween()
	t.tween_property(loving_famaily,"position:y",360,2.7).set_trans(Tween.TRANS_CIRC)
	t.tween_property(loving_famaily,"scale",Vector2(2.0,2.0),30.0).set_trans(Tween.TRANS_CIRC).set_delay(2.7)
func fake_out_stop():
	colorfg.color = Color.TRANSPARENT
	var t = create_tween().set_parallel()
	t.tween_property(colorfg,"color",Color.BLACK,2.75)
	t.tween_property(loving_famaily,"scale",Vector2.ONE,10.0)
	
	
func evil_request():
	ResourceLoader.load_threaded_request("uid://drffwqgwf5qd","PackedScene")
	ResourceLoader.load_threaded_request("uid://cdinouskd6508","PackedScene")
func evil_switch():
	normal.queue_free()
	evil.visible = true
	colorfg.visible = true
	create_tween().tween_property(colorfg,"color:a",0,0.8)
	loading_jeff = true
	loading_marv = true
	
	
func _process(delta: float) -> void:
	var p:int = 0
	if vido.is_playing():
		vido.stream_position = 0
	for i in game.play_field.dad_strum.receptors:
		seed(p*32.0 + Conductor.beat*48.0)
		i.position = og_pos[p] + (Vector2(2.0,2.0) * randf_range(-2.0,1.0))
		p += 1
	if loading_jeff or loading_marv:
		var s = ResourceLoader.load_threaded_get_status("uid://drffwqgwf5qd")
		var m = ResourceLoader.load_threaded_get_status("uid://cdinouskd6508")
		if m == ResourceLoader.THREAD_LOAD_LOADED:
			var newd = ResourceLoader.load_threaded_get("uid://cdinouskd6508").instantiate()
			newd.position = game.bf.position
			game.bf.queue_free()
			game.bf = newd
			game.add_child(game.bf)
			game.play_field.player_strum.chars = [game.bf]
			loading_marv = false
		if s == ResourceLoader.THREAD_LOAD_LOADED:
			var newd = ResourceLoader.load_threaded_get("uid://drffwqgwf5qd").instantiate()
			newd.position = game.dad.position
			game.dad.queue_free()
			game.dad = newd
			game.add_child(game.dad)
			game.play_field.dad_strum.chars = [game.dad]
			loading_jeff = false
	if loading_front_jeff:
		var front_jeff_id = "uid://blghwg6fl26dl"
		var m = ResourceLoader.load_threaded_get_status(front_jeff_id)
		if m == ResourceLoader.THREAD_LOAD_LOADED:
			front_jeff.sprite_frames = ResourceLoader.load_threaded_get(front_jeff_id)
	if loading_front_marv:
		var s = ResourceLoader.load_threaded_get_status("uid://csuisqyg1c8qp")
		if s == ResourceLoader.THREAD_LOAD_LOADED:
			var newd = ResourceLoader.load_threaded_get("uid://csuisqyg1c8qp").instantiate()
			newd.position = game.bf.position
			game.bf.queue_free()
			game.bf = newd
			game.add_child(game.bf)
			game.play_field.player_strum.chars = [game.bf]
			
func play_aethos_vid():
	game.gf.queue_free()
	ResourceLoader.load_threaded_request("uid://blghwg6fl26dl")
	ResourceLoader.load_threaded_request("uid://csuisqyg1c8qp")
	loading_front_jeff = true
	loading_front_marv = true
	evil.queue_free()
	game.dad.queue_free()
	cur_rate = Conductor.rate
	Conductor.rate = 1.0
	vido.play()
	await vido.finished
	Conductor.rate = cur_rate
	cutscene_2.visible = true
	game.bf.position = front_jeff.position
	game.bf.position.y += 900
	game.bf.position.x += 100
	game.camera_lerp_position = game.bf.camera_position.global_position
	front_jeff.play("Jeffy")
	pass
