extends Stage
#@onready var light: Sprite2D = $Light
#func _process(delta: float) -> void:
	#light.rotation_degrees = sin(Conductor.time*4.0)*15.0
@onready var chair_dstg: Character = $chair/chair_dstg

@onready var normal: Node2D = $normal
@onready var cut: VideoStreamPlayer = $CanvasLayer/cut
@onready var camera_tween:Tween
@onready var chair: Node2D = $chair
@onready var chair_marbin: Character = $"chair/chair marbin"
@onready var tas:Array = [$dad, $bf, $dad2, $dad3, $dad4, $dad5]
var gf_notes:Array[Chart.NoteData] = []
func flixel_tween_to_godot(tween_type:String,tween:Tween) -> Tween:
	var mapping:Dictionary[String,Array] = {
		"linear": [Tween.TRANS_LINEAR,Tween.EASE_OUT],
		"backIn": [Tween.TRANS_BACK,Tween.EASE_IN],
		"backOut": [Tween.TRANS_BACK,Tween.EASE_OUT],
		"backInOut": [Tween.TRANS_BACK,Tween.EASE_IN_OUT],
		"expoIn": [Tween.TRANS_EXPO,Tween.EASE_IN],
		"expoOut": [Tween.TRANS_EXPO,Tween.EASE_OUT],
		"expoInOut": [Tween.TRANS_EXPO,Tween.EASE_IN_OUT],
		"cubeIn": [Tween.TRANS_CUBIC,Tween.EASE_IN],
		"cubeOut": [Tween.TRANS_EXPO,Tween.EASE_OUT],
		"cubeInOut": [Tween.TRANS_EXPO,Tween.EASE_IN_OUT],
	}
	var d = mapping.get(tween_type,[Tween.TRANS_LINEAR,Tween.EASE_IN])
	if d == [Tween.TRANS_LINEAR,Tween.EASE_IN]:
		print("UNIMPLMENTED FLIXEL EASE - %s"%tween_type)
	tween.set_trans(d[0])
	tween.set_ease(d[1])
	
	return tween
	pass

func event_triggered(event:Event, time: float, values: Array) -> void:
	match event.name:
		"CameraZoom":
			var amount:float = values[0].to_float()
			var tweentype:String = values[2]
			var duration:float = Conductor.step_length * values[1]
			var t = create_tween()
			flixel_tween_to_godot(tweentype,t)
			t.tween_property(game.camera,"zoom",Vector2(amount,amount),duration)

			
			
			game.default_camera_zoom = Vector2(amount,amount)
			
		"CameraTween":
			var target:int = values[0]
			var chars:Array[Character] = [game.dad,game.bf]
			var campos = Vector2(values[1],values[2])
			var duration:float = Conductor.step_length * values[3]
			var tween_type:String = values[4]
			if !camera_tween:
				camera_tween = create_tween().set_parallel()
			camera_tween = flixel_tween_to_godot(tween_type,camera_tween)
			#camera_tween.tween_property(game.camera,"offset",campos,duration)
			print(campos)
			pass
		"Set Camera Zoom":
			game.default_camera_zoom = values[0]
		"camera_pan":
			if values[0] == 0:
				if game.gf.player.has_animation("BopLookLeft"):
					game.gf.play_anim("BopLookLeft")
				if game.gf.player.has_animation("idle"):
					game.gf.dance_steps = ["idle"]
			if values[0] == 1:
				if game.gf.player.has_animation("BopLookRight"):
					game.gf.play_anim("BopLookRight")
				if game.gf.player.has_animation("LookingMarvinIdle"):
					game.gf.dance_steps = ["LookingMarvinIdle"]
				
			
		"Camera Flash":
			var idk = values[0]
			var col = Color(values[1] as int).inverted()
			var duration = Conductor.beat_length * values[2]
			var cam:String = values[3]
			if cam == "camHUD":
				var rect := ColorRect.new()
				rect.size = Vector2(1280,720)
				rect.color = col
				game.hud.add_child(rect)
				var t := create_tween()
				t.tween_property(rect,"color:a",0,duration)
				t.tween_callback(rect.queue_free)
			else:
				var rect := ColorRect.new()
				rect.size = Vector2(1280,720)
				rect.color = col
				game.hud.add_sibling(rect)
				rect.z_index = -3
				var t := create_tween()
				t.tween_property(rect,"color:a",0,duration)
				t.tween_callback(rect.queue_free)
				
			
			pass
		_:
			pass
			#print("%s -> %s"%[event.name,values])
	pass
func _ready() -> void:
	normal.visible = false
	game.gf.modulate.a = 0
	await RenderingServer.frame_post_draw
	game.hud.modulate.a = 0
	#game.dad_field.rotation_degrees = 90

	
	
	
	for i in game.chart.notes:
		if i.field_id == 2:
				gf_notes.append(i)
func _process(delta: float) -> void:
	game.dad_field.transform = game.dad_field.transform.looking_at(game.player_field.position)
	if not gf_notes.is_empty():
		for n in gf_notes:
			if n.time - Conductor.time < 0.0:
				game.gf.sing(n.column)
				if (n.time + n.length) < Conductor.time:
					gf_notes.erase(n)

var video_start_time:float = 0
func step_hit(step:int):
	match step:
		74:
			game.bf.can_dance = false
			game.bf.play_anim("nightmare",true)
		158:
			var t = create_tween().set_parallel()
			game.gf.modulate = Color.AQUA
			game.gf.modulate.a = 0
			t.tween_property(game.gf,"modulate:a",0.99,Conductor.beat_length).set_delay(Conductor.step_length*2)
			
			t.tween_property(game.hud,"modulate:a",1,Conductor.beat_length)
			game.bf.can_dance = true
			
		434:
			game.gf.modulate = Color.WHITE
			
			create_tween().tween_property(game.hud,"modulate:a",0,Conductor.beat_length*2)
			normal.visible = true
			game.gf.visible = true
		508:
			create_tween().tween_property(game.hud,"modulate:a",1,Conductor.beat_length)
			
		2300,2560:
			create_tween().tween_property(game.hud,"modulate:a",0,Conductor.beat_length*2)
		2425,2814:
			create_tween().tween_property(game.hud,"modulate:a",1,Conductor.beat_length)
			
		3136:
			cut.modulate.a = 0
			cut.play()
			var t := create_tween().set_parallel()
			t.tween_property(game.hud,"modulate:a",0,3.5)
			t.tween_property(cut,"modulate:a",1,0.8).set_delay(2.7)
			await t.finished
			
			for i:Node in tas:
				i.queue_free()
			game.bf.queue_free()
			game.bf = chair_marbin
			game.dad.queue_free()
			game.dad = chair_dstg
			game.gf.hide()
			normal.queue_free()
			chair.visible = true
			video_start_time = Conductor.time
		3440:
			var t := create_tween()
			t.tween_property(game.hud,"modulate:a",1,0.7)
			game.camera.reset_smoothing()
		
		3458:
			cut.hide()
			
			
		
