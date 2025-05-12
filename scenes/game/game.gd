class_name Game extends Node2D
var play_fields:Array[PlayField] = []
var chart:Dictionary
@onready var tracks: Node = %tracks
@onready var dad_field: PlayField = $CanvasLayer/hud/playfields/dad_field
@onready var player_field: PlayField = $CanvasLayer/hud/playfields/player_field
@onready var hud: Control = $CanvasLayer/hud
var song_started:bool = false
@onready var events: Node = $events
var camera_lerp_position:Vector2 = Vector2.ZERO
var camera:Camera2D = null
var stage:Stage
var dad:Character
var gf:Character
var bf:Character

static var instance:Game
func _enter_tree() -> void:
	instance = self
	if Global.chart != null:
		chart = Global.chart
	else:
		chart = ChartParser.load_chart("no-villains","hard")
	Global.chart = chart
	stage = load("res://scenes/game/stages/stage.tscn").instantiate()
	gf = load("res://scenes/game/characters/%s.tscn"%chart.gf).instantiate()
	dad = load("res://scenes/game/characters/%s.tscn"%chart.dad).instantiate()
	bf = load("res://scenes/game/characters/%s.tscn"%chart.bf).instantiate()

func _ready() -> void:
	Conductor.time = -Conductor.beat_length*5.0
	Conductor.offset = Save.data.song_offset
	play_fields = [dad_field,player_field]
	tracks.load_song("no-villains")
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
	camera.make_current()
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
	Conductor.time = -Conductor.beat_length*3.0
	
		
func note_hit(note:Note):
	match note.note_field.play_field.id:
		0:
			dad.sing(note.column)
		1:
			bf.sing(note.column)
		2:
			gf.sing(note.column)
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_skip_time"):
		Conductor.player.seek(Conductor.time + 10.0)
	if camera:
		camera.position = camera_lerp_position
	if not song_started:
		Conductor.time += delta
		if Conductor.time >= 0.0:
			song_started = true
			Conductor.player.play()
	
