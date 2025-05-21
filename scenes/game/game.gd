class_name Game extends Node2D
var play_fields:Array[PlayField] = []
var chart:Dictionary
@onready var tracks: Node = %tracks
@onready var dad_field: PlayField = $UI/playfields/dad_field
@onready var player_field: PlayField = $UI/playfields/player_field
@onready var playfields: Node2D = $UI/playfields
@onready var hud: Control = $UI/hud
@onready var ui: CanvasLayer = %UI
var song_started:bool = false
@onready var events: Node = $events
var camera_lerp_position:Vector2 = Vector2.ZERO
var default_camera_zoom:Vector2 = Vector2.ONE
static var cache:Dictionary = {}
var camera:Camera2D = null
var stage:Stage
var dad:Character
var gf:Character
var bf:Character


var health:float = 1.0:
	set(v):
		health = clamp(v,0,max_health)
var max_health:float = 2.0
var score:float = 0
var combo:int = 0
var misses:int = 0
var accuracy_points:float = 0
var accuracy_points_max:float = 0

var accuracy:float = -1


static var instance:Game
static var song_name = "glitcher"
var paused:bool = false
var pause_menu:PackedScene = load("res://scenes/game/pause_menu.tscn")
var pause_ui:CanvasLayer = null
func load_character(p:String,fb:String):
	if ResourceLoader.exists("res://scenes/game/characters/%s.tscn"%p):
		return load("res://scenes/game/characters/%s.tscn"%p).instantiate()
	else:
		return load("res://scenes/game/characters/%s.tscn"%fb).instantiate()
func _enter_tree() -> void:
	instance = self
	if Global.chart != null:
		chart = Global.chart
	else:
		chart = ChartParser.load_chart(song_name,"hard")
	Global.chart = chart
	var p = "res://scenes/game/stages/%s.tscn"%chart.stage
	if not ResourceLoader.exists(p):
		print("stage not found loading default")
		p = "res://scenes/game/stages/stage.tscn"
	stage = load(p).instantiate()
	gf = load_character(chart.gf,"gf")
	dad = load_character(chart.dad,"dad")
	bf = load_character(chart.bf,"bf")
	set_up_cache()
	
	

		

func _ready() -> void:
	
	Conductor.measure_hit.connect(measure_hit)
	Conductor.time = -Conductor.beat_length*5.0
	Conductor.offset = Save.data.song_offset
	play_fields = [dad_field,player_field]
	tracks.load_song(song_name)
	Conductor.player = tracks.player
	for i in play_fields:
		i.position.y = hud.size.y*0.15 if not Save.data.down_scroll else hud.size.y*0.85
		i.position.x = hud.size.x*0.25
		i.position.x += hud.size.x * 0.5 * i.id
			
		
		
		var n = chart.notes.filter(func(a): return a.field_id == i.id)
		i.notes = n
		
	add_child(stage)
	camera = stage.cam
	camera.zoom = Vector2(stage.default_cam_zoom,stage.default_cam_zoom)
	default_camera_zoom = camera.zoom
	camera.make_current()
	camera.position = camera_lerp_position
	add_child(gf)
	add_child(dad)
	add_child(bf)
	bf.position = stage.bf_position.position
	dad.position = stage.dad_position.position
	gf.position = stage.gf_position.position
	camera_lerp_position = dad.camera_position.global_position
	camera.position = camera_lerp_position
	camera.reset_smoothing()
	for i in play_fields:
		i.note_hit.connect(note_hit)
		i.note_miss.connect(note_miss)
		
	for ev in chart.events:
		var evv := Event.new()
		var ev_path:String = "res://scripts/game/events/%s.gd"%ev.name
		if ResourceLoader.exists(ev_path):
			var scriptt = load(ev_path)
			evv.set_script(scriptt)
		evv.event_values = ev.values
		evv.event_time = ev.time
		evv.event_name = ev.name
		evv.name = "%s %d"%[ev.name,ev.time*1000]
		events.add_child(evv)
	hud = load("res://scenes/game/huds/funkin.tscn").instantiate()
	ui.add_child(hud)
	playfields.reparent(hud,false)
	var scripts_dir = "res://assets/songs/%s/scripts/"%song_name
	var scripts = ResourceLoader.list_directory(scripts_dir)
	for i in scripts:
		var script = FunkinScript.new()
		script.set_script(load(scripts_dir + i))
		add_child(script)
	
	Conductor.time = -Conductor.beat_length*3.0
	
func note_miss(note:Note):
	misses += 1
	accuracy_points_max += 1
	accuracy = (accuracy_points / accuracy_points_max) * 100.0
	bf.sing(note.column,true)
	if combo > 0:
		combo = 0
		show_combo(combo)
	pass
func note_hit(note:Note):
	match note.note_field.play_field.id:
		0:
			dad.sing(note.column)
			dad.sing_timer = 0
		1:
			
			bf.sing(note.column)
			bf.sing_timer = 0

			if not note.was_hit:
				health += 0.02
				var r = Rating.rate_note(note,note.play_field.auto_play)
				pop_up_score(r)
				score += r.score
				combo += 1
				accuracy_points_max += 1
				accuracy_points += r.acc
				accuracy = (accuracy_points / accuracy_points_max) * 100.0
				show_combo(combo)
			else:
				health += 0.08 * get_process_delta_time()

		2:
				gf.sing(note.column)
				gf.sing_timer = 0
var rating_tex = load("res://assets/ui/funkin/ratings_sheet.png")
var combo_tex = load("res://assets/ui/funkin/num-sheet.png")
func pop_up_score(rating:Rating):
	var rat := VelocitySprite.new()
	rat.texture = rating_tex
	rat.vframes = 4
	rat.frame = rating.rank
	rat.scale = Vector2(0.7,0.7)
	$ratings.add_child(rat)
	rat.position = camera.get_target_position()
	rat.acceleration.y = 550;
	rat.velocity.y -= randi_range(140,175)
	rat.velocity.x -= randi_range(0, 10);
	var t =create_tween().set_parallel()
	t.tween_property(rat,"modulate:a",0,0.2).set_trans(Tween.TRANS_SINE).set_delay(Conductor.beat_length)
	
	await t.finished
	rat.free()
func show_combo(c:int):
	var cstr = str(c).pad_zeros(3)
	var count:int = 0
	for i in cstr.split():
		var spr = VelocitySprite.new()
		spr.texture = combo_tex
		spr.hframes = 10
		spr.frame = int(i)
		spr.position = camera.get_target_position()
		spr.position.y += 90
		spr.position.x += 50 * count - 50
		spr.scale = Vector2(0.55,0.55)
		$combo.add_child(spr)
		spr.acceleration.y = randi_range(200, 300);
		spr.velocity.y -= randi_range(140, 160);
		spr.velocity.x = randf_range(-5, 5);
		var t = create_tween().set_parallel()
		t.tween_property(spr,"modulate:a",0,0.2).set_delay(Conductor.beat_length)
		count += 1
		t.finished.connect(spr.queue_free,CONNECT_ONE_SHOT)
func _process(delta: float) -> void:
	hud.scale = lerp(hud.scale,Vector2.ONE,delta*3.0)
	camera.zoom = lerp(camera.zoom,default_camera_zoom,delta*3.0)
	
	if Input.is_action_just_pressed("debug_skip_time"):
		Conductor.player.seek(Conductor.time + 10.0)
	if camera:
		camera.position = camera_lerp_position
	if not song_started:
		Conductor.time += delta
		if Conductor.time >= 0.0:
			song_started = true
			Conductor.player.play()	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_pause") and not paused and song_started:
		pause_ui = pause_menu.instantiate()
		pause_ui.set_process_unhandled_input(false)
		Conductor.player.stop()
		process_mode = Node.PROCESS_MODE_DISABLED
		await RenderingServer.frame_post_draw
		add_child(pause_ui)
		paused = true
		pass
func measure_hit(measure:int):
	if measure > 0:
		hud.scale += Vector2(0.03,0.03)
		camera.zoom += Vector2(0.015,0.015)
func set_up_cache():
	cache.set("stage",load(stage.scene_file_path))
	cache.set("dad",load(dad.scene_file_path))
	cache.set("bf",load(bf.scene_file_path))
	cache.set("gf",load(gf.scene_file_path))
