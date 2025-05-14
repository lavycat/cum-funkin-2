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

var camera:Camera2D = null
var stage:Stage
var dad:Character
var gf:Character
var bf:Character


var health:float = 1.0:
	set(v):
		health = clamp(v,0,max_health)
var max_health:float = 2.0

static var instance:Game
static var song_name = "2hot"
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
	stage = load("res://scenes/game/stages/stage.tscn").instantiate()
	gf = load_character(chart.gf,"gf")
	dad = load_character(chart.dad,"dad")
	bf = load_character(chart.bf,"bf")
		

func _ready() -> void:
	
	Conductor.measure_hit.connect(measure_hit)
	Conductor.time = -Conductor.beat_length*5.0
	Conductor.offset = Save.data.song_offset
	play_fields = [dad_field,player_field]
	tracks.load_song(song_name)
	Conductor.player = tracks.player
	for i in play_fields:
		i.position.y = hud.size.y*0.15 if not Save.data.down_scroll else hud.size.y*0.85
		i.position.x = hud.size.x*0.5
		
		if i.id == 0:
			i.position.x += hud.size.x*-0.25
		else:
			i.position.x += hud.size.x*0.25
			
		
		
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
	for i in play_fields:
		i.note_hit.connect(note_hit)
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
	print(scripts)
	for i in scripts:
		var script = FunkinScript.new()
		script.set_script(load(scripts_dir + i))
		add_child(script)
	
	Conductor.time = -Conductor.beat_length*3.0
	
		
func note_hit(note:Note):
	match note.note_field.play_field.id:
		0:
			if not note.was_hit:
				health -= 0.02
				dad.sing(note.column)
			else:
				dad.sing_timer = 0
		1:
			if not note.was_hit:
				health += 0.02
				bf.sing(note.column)
			else:
				bf.sing_timer = 0
		2:
			if not note.was_hit:
				gf.sing(note.column)
			else:
				gf.sing_timer = 0
	
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
	
func measure_hit(measure:int):
	if measure > 0:
		hud.scale += Vector2(0.03,0.03)
		camera.zoom += Vector2(0.015,0.015)
