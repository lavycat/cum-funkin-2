extends Stage
#@onready var light: Sprite2D = $Light
#func _process(delta: float) -> void:
	#light.rotation_degrees = sin(Conductor.time*4.0)*15.0
	
@onready var cut: VideoStreamPlayer = $CanvasLayer/cut
var gf_notes:Array[Chart.NoteData] = []
func flixel_tween_to_godot(tween_type:String,tween:Tween) -> Tween:
	match tween_type:
		pass
	return tween
	pass
	
func event_triggered(event:Event, time: float, values: Array) -> void:
	match event.name:
		"CameraZoom":
			var amount:float = values[0].to_float()
			var tweentype:String = values[2]
			var duration:float = Conductor.step_length * values[1]
			var t = create_tween()
			t.tween_property(game.camera,"zoom",Vector2(amount,amount),duration)
			
			t.set_ease(Tween.EASE_OUT)
			t.set_trans(Tween.TRANS_CUBIC)
			
			
			game.default_camera_zoom = Vector2(amount,amount)
			
			
		"Set Camera Zoom":
			game.default_camera_zoom = values[0]
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
			print("%s -> %s"%[event.name,values])
	pass
func _ready() -> void:
	for i in game.chart.notes:
		if i.field_id == 2:
				gf_notes.append(i)
func _process(delta: float) -> void:
	for n in gf_notes:
		if n.time - Conductor.time < 0.0:
			game.gf.sing(n.column)
			if (n.time + n.length) < Conductor.time:
				gf_notes.erase(n)


func step_hit(step:int):
	
	match step:
		3136:
			cut.play()
		pass
	pass
