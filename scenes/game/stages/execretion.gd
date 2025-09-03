extends Stage
@onready var normal: Node2D = $normal
@onready var poop: Node2D = $poop
@onready var logo: Sprite2D = $overlay/logo
@onready var poop_group_one:Array[Node2D] = [$poop/_Parallax2D_21/debris, $poop/_Parallax2D_22/debris2, $poop/_Parallax2D_23/debris3, $poop/_Parallax2D_24/pipe, $poop/_Parallax2D_27/plant]
@onready var poop_group_two:Array[Node2D] = [$poop/_Parallax2D_25/block1, $poop/_Parallax2D_26/block2]
@onready var poop_group_three:Array[Node2D] = [$poop/_Parallax2D_17/bg, $poop/_Parallax2D_18/light, $poop/_Parallax2D_19/cliff, $poop/_Parallax2D_20/waterfall2,$poop/_Parallax2D_29/waterfall1]

@onready var moses: Node2D = $moses
@onready var mose_poop: Character = $moses/mose_poop
@onready var mose_rose: Character = $moses/mose_rose

@onready var dark: Node2D = $dark
@onready var dark_pw: Character = $dark/dark_pw

@onready var castle: Node2D = $castle
@onready var pw_final: Character = $castle/pw_final
@onready var rose_final: Character = $castle/rose_final



@onready var poopp: VideoStreamPlayer = $overlay/poop
@onready var poop_2: VideoStreamPlayer = $overlay/poop2

func funni_float():
	var p = game.dad.duplicate()
	p.modulate = Color.GOLD
	p.modulate.a = 0.2
	create_tween().tween_property(p,"position:y",p.position.y - 900,0.67).set_trans(Tween.TRANS_EXPO).finished.connect(p.queue_free)
	create_tween().tween_property(p,"modulate:a",0,0.8).set_trans(Tween.TRANS_EXPO)
	
	add_child(p)
	p.z_index = -1
	p.set_process(false)
	p.sing(2)
func flash_game(c:Color = Color.WHITE,hud:bool = true):
	var cr := ColorRect.new()
	cr.size = Vector2(1280,720)
	cr.color = c
	game.ui.add_child(cr,false,Node.INTERNAL_MODE_BACK if hud else Node.INTERNAL_MODE_FRONT)
	create_tween().tween_property(cr,"color:a",0,0.6)
	pass
func song_start():
	print("hi")
	poopp.play()
func _ready() -> void:
	await RenderingServer.frame_post_draw
	Conductor.time = 0
func _process(delta: float) -> void:
	if Conductor.step > 4292:
		game.default_camera_zoom = Vector2(0.4,0.4)
		game.camera_lerp_position.y = 300
func step_hit(step:int):
	match step:
		120:
			poopp.queue_free()
			pass
		784:
			normal.hide()
		790:
			game.bf.play_anim("rose screm",true)
		864:
			$poop/_Parallax2D_28/floor.modulate.a = 0
			for i in poop_group_one:
				i.modulate.a = 0
			for i in poop_group_two:
				i.modulate.a = 0
			for i in poop_group_three:
				i.modulate.a = 0
			poop.show()
			create_tween().tween_property($poop/_Parallax2D_28/floor,"modulate:a",1,0.5).set_trans(Tween.TRANS_EXPO)
			
		880:

			for i in poop_group_one:
				i.modulate.a = 0
				create_tween().tween_property(i,"modulate:a",1,0.5).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		876,892:
			funni_float()
			
		896:
			for i in poop_group_two:
				create_tween().tween_property(i,"modulate:a",1,0.5).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		912:
			var t = create_tween()
			t.tween_property(logo,"position:x",640,0.4).set_trans(Tween.TRANS_CUBIC)
			t.tween_property(logo,"position:x",1920,1.2).set_delay(.15).set_trans(Tween.TRANS_BACK)
			
			for i in poop_group_three:
				create_tween().tween_property(i,"modulate:a",1,0.5).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
				
		1108:
			game.camera.global_position = game.bf.camera_position.global_position + Vector2(200,0)
			create_tween().tween_property(game,"default_camera_zoom",Vector2(1.2,1.2),0.3).set_trans(Tween.TRANS_EXPO)
			game.bf.play_anim("Ew",true)
		1118:
			create_tween().tween_property(game,"default_camera_zoom",Vector2(0.4,0.4),0.25)
		2316:
			poop_2.play()
		2398:
			poop_2.queue_free()
			flash_game(Color.GOLD)
			game.default_camera_zoom = Vector2(0.4,0.4)
		2656:
			
			flash_game(Color.BLACK)
			var cr := ColorRect.new()
			cr.size = Vector2(9000,3000)
			cr.position = Vector2(-3000,-1500)
			
			poop.add_child(cr)
			cr.name = "cr"
			game.dad.modulate = Color.BLACK
			game.bf.modulate = Color.BLACK
		3510:
			moses.show()
			poop.hide()
			flash_game(Color.BLACK)
			game.dad.queue_free()
			game.dad = mose_poop
			game.bf.queue_free()
			game.bf = mose_rose
			for i in game.play_fields:
				i.reset_characters()
			game.default_camera_zoom = Vector2(0.8,0.8)
			game.camera_lerp_position = game.bf.camera_position.global_position
			game.dad.modulate.a = 0
			game.bf.modulate.a = 0
			moses.modulate.a = 1
			for i in moses.get_children():
				if i != game.dad and i != game.bf:
					i.modulate.a = 0
				
			create_tween().tween_property(game.bf,"modulate:a",1,3).set_trans(Tween.TRANS_EXPO)
		3660:
			create_tween().tween_property(game.dad,"modulate:a",1,1.5).set_trans(Tween.TRANS_CUBIC)
		3800:
			flash_game(Color.BLACK)
			for i in moses.get_children():
				if i != game.dad and i != game.bf:
					create_tween().tween_property(i,"modulate:a",1,0.75).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT)
		3980:
			flash_game(Color.BLACK)
			moses.hide()
			dark.show()
			
			game.dad = dark_pw
			for i in game.play_fields:
				i.reset_characters()
			game.default_camera_zoom = Vector2(0.5,0.5)
			pass
		4260:
			var cr := ColorRect.new()
			cr.size = Vector2(1280,720)
			game.hud.add_child(cr)
			cr.color = Color.BLACK
			cr.color.a = 0
			create_tween().tween_property(cr,"color:a",1,0.5).set_trans(Tween.TRANS_CIRC).finished.connect(func(): 
				dark.hide()
				cr.queue_free()
			)
			pass
		4292:
			flash_game(Color.RED)
			castle.show()
			game.dad.queue_free()
			game.dad = pw_final
			game.dad.dance()
			game.bf.queue_free()
			game.bf = rose_final
			game.default_camera_zoom = Vector2(0.4,0.4)
			game.camera_lerp_position = game.bf.camera_position.global_position
			#game.camera.limit_bottom = 1200
			#game.camera.limit_right = 2200
			
			for i in game.play_fields:
				i.reset_characters()
			pass
