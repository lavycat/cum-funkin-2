extends Stage
@onready var color_bg: ColorRect = $CanvasLayer/bg
@onready var intro: AnimatedSprite2D = $CanvasLayer/intros/intro

@onready var act_1_overlay: Sprite2D = $CanvasLayer/Act1
@onready var act_1: Node2D = $"act 1"
var act_2:Node2D
@onready var act_2_intro: Node2D = $CanvasLayer/intros/act2_intro

var loading_act2:bool = false

var loading_act3:bool = false
var act_3:Node2D
func _ready() -> void:
	intro.visible = true
	await intro.animation_finished
	intro.queue_free()
	act_1_overlay.visible = true
	color_bg.color = Color.RED
	var t = create_tween().tween_property(color_bg,"color:a",0,0.8)
	await t.finished
@onready var act_4_intro: Node2D = $CanvasLayer/intros/act_4_intro

func step_hit(step:int):
	match step:
		1059:
			loading_act2 = true
			ResourceLoader.load_threaded_request("res://scenes/game/stages/allfinal/act_2.tscn","",true)
			act_1.queue_free()
			intro_act_2()
		1063:
			var intro_eyes:AnimatedSprite2D = act_2_intro.get_child(1)
			intro_eyes.visible = true
			intro_eyes.play("EyesBG")
			var t = create_tween().set_parallel()
			t.tween_property(intro_eyes,"scale",Vector2(1.8,1.8),0.8).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
			t.tween_property(intro_eyes,"position:y",240,0.8).set_trans(Tween.TRANS_CIRC)
			t.tween_property(intro_eyes,"position:x",640,0.8).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
		1072:
			var intro_eyes:AnimatedSprite2D = act_2_intro.get_child(1)
			var intro_gf:AnimatedSprite2D = act_2_intro.get_child(0)
			
			intro_gf.visible = false
			intro_eyes.visible = false
			color_bg.visible = false
			intro_gf.queue_free()
			intro_eyes.queue_free()
		2224:
			intro_act_3()
			
		3514:
			act_3.queue_free()
			var pp = act_4_intro.get_child(0)
			pp.play("thingy")
			pp.visible = true
			color_bg.color.a = 1.0
			color_bg.visible = true
			await pp.animation_finished
			pp.queue_free()
			color_bg.visible = false
func intro_act_2():
	color_bg.color = Color.BLACK
	var intro_gf:AnimatedSprite2D = act_2_intro.get_child(0)
	var intro_eyes:AnimatedSprite2D = act_2_intro.get_child(1)
	intro_gf.visible = true
	intro_gf.modulate.a = 1
	var t = create_tween().set_parallel()
	t.tween_property(intro_gf,"modulate:a",0,1.2)
	t.tween_property(intro_gf,"scale",Vector2(0.01,0.01),3.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	t.tween_property(intro_gf,"position:y",240,0.1)
	t.tween_property(intro_gf,"rotation_degrees",5,3.0)
	await t.finished
func intro_act_3():
	act_2.queue_free()
	loading_act3 = true
	ResourceLoader.load_threaded_request("res://scenes/game/stages/allfinal/act_3.tscn","",true)
	
	
	
	## intro
	
	
func _process(delta: float) -> void:
	if loading_act2:
		var act2_staus = ResourceLoader.load_threaded_get_status("res://scenes/game/stages/allfinal/act_2.tscn")
		if act2_staus == ResourceLoader.THREAD_LOAD_LOADED:
			act_2 = ResourceLoader.load_threaded_get("res://scenes/game/stages/allfinal/act_2.tscn").instantiate()
			add_child(act_2)
			loading_act2 = false
	if loading_act3:
		var act3_staus = ResourceLoader.load_threaded_get_status("res://scenes/game/stages/allfinal/act_3.tscn")
		if act3_staus == ResourceLoader.THREAD_LOAD_LOADED:
			act_3 = ResourceLoader.load_threaded_get("res://scenes/game/stages/allfinal/act_3.tscn").instantiate()
			add_child(act_3)
			loading_act3 = false
			
