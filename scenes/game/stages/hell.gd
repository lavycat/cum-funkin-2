extends Stage

@onready var hell_1: Node2D = $hell1
@onready var hell_2: Node2D = $hell2
@onready var hell_3: Node2D = $hell3
@onready var cut: VideoStreamPlayer = $overlay/cut
@onready var marv: Character = $hell2/marv
@onready var marv_3: Character = $void/marv3
@onready var pic: SparrowAtlas = $void2/CanvasLayer/pic
@onready var question: Sprite2D = $overlay/Question
@onready var axe: SparrowAtlas = $hell1/axe

@onready var flash_rect: ColorRect = $overlay/flash_rect
@onready var jeff: SparrowAtlas = $void/jeff
@onready var da_void: Node2D = $void
@onready var void_2: Node2D = $void2
@onready var jerry: Character = $hell2/jerry

@onready var jerry_sketch: Character = $hell3/jerry_sketch
@onready var marv_sketch: Character = $hell3/marv_sketch
var final:bool = false
@onready var subtitle: Label = $overlay/CanvasLayer/subtitle
var subbtitles:Array = []
var cur_sub:int = 0
var in_the_void:bool = false
func lyric(from:int, to:int, t:String,c:Color = Color.YELLOW):
	var sub_data:Dictionary = {"from":from,"to":to,"text":t,"color":c}
	subbtitles.append(sub_data)
func gen_rand_string(length:int) -> String:
	var lets:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*()"
	var str:String = ""
	for i:int in length:
		randomize()
		str += lets[randi_range(0,lets.length()-1)]
		
	return str
func note_hit(note:Note):
	if final:
		if !note.was_hit and note.play_field.id == 0:
			var d = note.sprite.duplicate()
			add_child(d)
			d.position.x = randf_range(600,2400)
			d.position.y = randf_range(700,800)
			create_tween().tween_property(d,"modulate:a",0,0.6).set_trans(Tween.TRANS_EXPO).finished.connect(d.queue_free)
			create_tween().tween_property(d,"position:y",d.position.y + 900,0.8).set_trans(Tween.TRANS_EXPO).finished.connect(d.queue_free)
			
			
			
			
func _process(delta: float) -> void:
	if in_the_void:
		if game.bf:
			game.camera.position = game.bf.camera_position.global_position
	if final:
		game.camera.position = game.dad.camera_position.global_position
		game.default_camera_zoom = Vector2(0.8,0.8)
	if pic and pic.is_playing():
		subtitle.text = gen_rand_string(32)
		subtitle.label_settings.font_color = Color.RED
	if subbtitles.is_empty():
		return
	if cur_sub >= subbtitles.size():
		return
	if subbtitles[cur_sub] is Dictionary:
		var s = subbtitles[cur_sub]
		if Conductor.step > s.to:
			cur_sub += 1
		if s.from < Conductor.step and s.to > Conductor.step:
			subtitle.text = s.text
			subtitle.label_settings.font_color = s.color
		else:
			subtitle.text = ""
func _ready() -> void:
			
	#$overlay/CanvasLayer/SubViewportContainer/SubViewport/MeshInstance3D.mesh.material.albedo_texture = get_window().get_viewport().get_texture()
	lyric(320,354,"JERRY: ARE YOU FUCKING HIGH!!")
	lyric(1424,1436,"JERRY: I")
	lyric(1440,1448,"JERRY: HATE")
	lyric(1448,1458,"JERRY: GREEN BEANS")
	lyric(1458,1464,"JERRY: DADDY")
	
	lyric(1470,1474,"MARVIN: YOU",Color.RED)
	lyric(1474,1484,"MARVIN: BITCH",Color.RED)
	
	
	
	lyric(1488,1500,"JERRY: HE'S TRY'IN")
	lyric(1500,1516,"JERRY: MY WEINER")
	
	lyric(1652,1664,"JERRY: GET THAT BITCH")
	
	lyric(2184,2184+2,"The", Color.DARK_RED)
	lyric(2184 + 2,2184 + 4,"The Deed", Color.DARK_RED)
	lyric(2184 + 4,2184 + 8,"The Deed Is", Color.DARK_RED)
	lyric(2184 + 8,2184+16,"The Deed Is Done", Color.DARK_RED)
	
	lyric(2200,2232,"I Drank")
	lyric(2232,2268,"An 8 Ball Of Coke")
	lyric(2268,2288,"And Now")
	lyric(2288,2304,"Im")
	lyric(2304,2328,"Wretched And Broke")
	lyric(2328,2352,"As I Stare")
	lyric(2352,2368,"Into The")
	lyric(2368,2380,"Endless")
	lyric(2380,2392,"Aethos")
	
	lyric(2392,2412,"I Slap")
	lyric(2412,2428,"My Diaper")
	lyric(2428,2448,"With Woe")
	lyric(2448,2448+12,"Ohhhhh")
	
	lyric(2656,2656+16,"My",Color.RED)
	lyric(2672,2672+16,"My Final",Color.RED)
	lyric(2688,2688+16,"My Final Show",Color.RED)
	lyric(2704,2704+16,"My Final Show Down",Color.RED)
	
	lyric(2732,2732+16,"That 8 Ball Of Coke")
	lyric(2760,2764+16,"It Really Does Something To Ya")
	lyric(2788,2796+4,"But Now")
	lyric(2796+6,2800+16,"I See The Truth")
	lyric(2824,2824+16,"My Eyes Are Open")
	lyric(2848,2848+24,"And I Feel The Ascension Coming")
	lyric(2884,2894,"Daddy")
	lyric(2894,2892+12,"Daddy, I Told You")
	lyric(2892+14,2930,"I Hated Green Beans")
	lyric(2930,2964,"I Hated Green Beans, And You Still Gave Them To Me")
	lyric(2964,2976,"But Now Ya See")
	game.gf.visible = false
func beat_hit(beat:int):
	match beat:
		206:
			print(game.dad.scene_file_path)
			axe.play("chop")
		415:
			hell_2.visible = true
			hell_1.visible = false
			hell_1.queue_free()
			game.bf.queue_free()
			game.bf = marv
			game.dad.free()
			game.dad = jerry
			game.hud.reload_icons()
			for i in game.play_fields:
				i.reset_characters()
			flash(0.5)
		541:
			var t = create_tween().set_parallel()
			flash_rect.color = Color.BLACK
			flash_rect.color.a = 0
			
			t.tween_property(game.hud,"modulate:a",0,0.6)
			t.tween_property(flash_rect,"color:a",1,0.6)
		549:
			
			in_the_void = true
			game.gf.visible = false
			da_void.visible = true
			hell_2.visible = false
			game.dad = jerry_sketch
			game.bf = marv_3
			cut.play()
			hell_2.queue_free()
			for i in game.play_fields:
				i.reset_characters()
			
		597:
			cut.queue_free()
			create_tween().tween_property(jeff,"position:y",720,1.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			flash_rect.color = Color.BLACK
			flash_rect.color.a = 0
			jeff.play("Jeffy")
		609:
			game.hud.visible = true
			game.hud.modulate.a = 0
			game.hud.icons.visible = false
			game.hud.healthbarbg.visible = false
			game.hud.healthbar.visible = false
			create_tween().tween_property(game.hud,"modulate:a",1,1.25)
			game.player_field.position.x = 640
			if Save.json.down_scroll:
				game.hud.timebar.position.y -= 90
			else:
				game.hud.timebar.position.y += 90
				
			game.dad_field.position.x = -1280
		679:
			flash(0.75)
			in_the_void = false
			da_void.queue_free()
			var t = create_tween().set_parallel()
			void_2.visible = true
			pic.rotation_degrees = 45
			t.tween_property(pic,"position:y",480,1.5).set_delay(Conductor.beat_length*2).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
			t.tween_property(pic,"rotation_degrees",0,1.5).set_delay(Conductor.beat_length*2).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
			
			game.hud.visible = false
		720:
			var tt = create_tween().set_parallel()
			tt.tween_property(pic,"scale",Vector2(1.1,1.1),Conductor.beat_length*18).set_delay(Conductor.beat_length).set_trans(Tween.TRANS_LINEAR)
		738:
			var tt = create_tween().set_parallel()
			tt.tween_property(pic,"scale",Vector2(1,1),1.3).set_delay(Conductor.beat_length).set_trans(Tween.TRANS_SINE)
			flash_rect.color = Color(0,0,0,0)
			tt.tween_property(flash_rect,"color",Color.BLACK,1.5).set_delay(Conductor.beat_length).set_trans(Tween.TRANS_SINE)
		822:
			flash(0.15)
			pic.play("breakdown")
		827:
			void_2.queue_free()
			
			game.bf = marv_sketch
			hell_3.visible = true
			pic.visible = false
			flash(0.1)
			game.hud.modulate.a = 1
			game.hud.visible = true
			final = true
			game.dad_field.position.x = 320
			game.dad_field.reparent(hell_3)
			game.dad_field.position.x = 1080
			game.dad_field.position.y = 650
			for i in game.dad_field.strums:
				i.hide()
			game.dad_field.z_index = -1
			game.hud.bar.visible = false
			
			game.dad_field.note_field.down_scroll = false
			game.dad_field.spawn_range = 5
			subtitle.text = ""
			for i in game.play_fields:
				i.reset_characters()
		892:
			flash_rect.color = Color.BLACK
			flash_rect.color.a = 0
			create_tween().tween_property(flash_rect,"color",Color.BLACK,2)
			create_tween().tween_property(game.hud,"modulate",Color.TRANSPARENT,3)
			
		900:
			final = false
			flash_rect.color = Color.BLACK
			flash(0.67,Color.BLACK)
			hell_3.queue_free()
			question.modulate = Color.WHITE
		908:
			create_tween().tween_property(question,"modulate",Color.BLACK,9)
			
			
			
			
func flash(s:float,c:Color = Color.RED):
	flash_rect.color = c
	flash_rect.color.a = 1
	create_tween().tween_property(flash_rect,"color:a",0,s)
