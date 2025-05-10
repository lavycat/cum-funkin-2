class_name Game extends Node2D
static var song_name:String = "no-villains"
static var song_diff:String = "hard"
static var song_varaion:String = ""
static var instance:Game = null
@onready var tracks: Node = %tracks
@export var play_field: PlayField
@onready var hud: Control = $CanvasLayer/hud
var stage:Stage = null
var camera:Camera2D = null
var camera_lerp_zoom:float = 1.0
var camera_lerp_position:Vector2 = Vector2(849.0 / 2,400)
var camera_position_auto_lerp:bool = true
var dad:Character
var bf:Character
var gf:Character
@onready var event_man: Node = %events


static var chart = null
var loading:bool = true
var song_started:bool = false
var botplay:bool = false:
	set(v):
		botplay = v
		play_field.player_strum.cpu = botplay
		play_field.player_strum.input = not botplay
		
func load_character(p:String) -> String:
	var path:String = p
	if ResourceLoader.exists(p):
		ResourceLoader.load_threaded_request(p,"PackedScene")
	else:
		path = "res://scenes/game/characters/dad.tscn"
		ResourceLoader.load_threaded_request(path,"PackedScene")
	return path
var stage_path:String = ""
var dad_path:String
var bf_path:String
var gf_path:String


var can_pause:bool = false
func _enter_tree() -> void:
	Save.load_data()
	
	Game.instance = self
	Conductor.time = 0
	if !chart:
		chart = ChartParser.load_chart(song_name,song_diff)
	
	Conductor.bpm = chart.bpm
	play_field.chart = chart
	var stage_name = chart.stage
	stage_path = "res://scenes/game/stages/%s.tscn"%stage_name
	if not ResourceLoader.exists(stage_path):
		stage_name = "stage"
		stage_path = "res://scenes/game/stages/%s.tscn"%stage_name
	var err = ResourceLoader.load_threaded_request(stage_path,"PackedScene")
	if err != OK:
		print(error_string(err))
	
	## load characters 
	var character_base_path:String = "res://scenes/game/characters/"
	gf_path = "%s%s.tscn"%[character_base_path,chart.gf]
	dad_path = "%s%s.tscn"%[character_base_path,chart.dad]
	bf_path = "%s%s.tscn"%[character_base_path,chart.bf]
	
	bf_path = load_character(bf_path)
	dad_path = load_character(dad_path)
	gf_path = load_character(gf_path)
	
	
	
	
func start():
	tracks.load_song(song_name)
	Conductor.player = tracks.player
	
	
	Conductor.measure_hit.connect(on_measure_hit)
	play_field.note_hit.connect(note_hit)
	play_field.note_miss.connect(note_miss)
	play_field.dad_strum.chars = [dad]
	play_field.player_strum.chars = [bf]
	
	add_child(stage)
	add_child(gf)
	add_child(bf)
	add_child(dad)
	
	
	bf.position = stage.bf_position.position
	gf.position = stage.gf_position.position
	dad.position = stage.dad_position.position
	if stage:
		camera = stage.cam
		camera_lerp_zoom = stage.default_cam_zoom
	for ev in chart.events:
		var evv := Event.new()
		setup_script(evv)
		var ev_path:String = "res://scripts/game/events/%s.gd"%ev.name
		if ResourceLoader.exists(ev_path):
			var scriptt = load(ev_path)
			evv.set_script(scriptt)
		evv.event_values = ev.values
		evv.event_time = ev.time
		evv.event_name = ev.name
		evv.name = "%s %d"%[ev.name,ev.time*1000]
		event_man.add_child(evv)

func setup_script(script:FunkinScript):
	play_field.dad_strum.note_hit.connect(script.note_hit)
	play_field.player_strum.note_hit.connect(script.note_hit)
	pass
	
func _ready() -> void:
	var id:int = 0
	
var loads:Array[bool] = []
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_bot_toggle"):
		botplay = not botplay
	if Input.is_action_just_pressed("debug_skip_time"):
		Conductor.player.seek(Conductor.time + 10.0)
		
	if loading:
		Conductor.time = -Conductor.beat_length*3.0
		var stage_status = ResourceLoader.load_threaded_get_status(stage_path)
		if stage_status == ResourceLoader.THREAD_LOAD_LOADED:
			loads.append(true)
			var scn = ResourceLoader.load_threaded_get(stage_path)
			stage = scn.instantiate()
			
		var dad_status = ResourceLoader.load_threaded_get_status(dad_path)
		if dad_status == ResourceLoader.THREAD_LOAD_LOADED:
			loads.append(true)
			var scn = ResourceLoader.load_threaded_get(dad_path)
			dad = scn.instantiate()
		
		var bf_status = ResourceLoader.load_threaded_get_status(bf_path)
		if bf_status == ResourceLoader.THREAD_LOAD_LOADED:
			loads.append(true)
			var scn = ResourceLoader.load_threaded_get(bf_path)
			bf = scn.instantiate()
		
		var gf_status = ResourceLoader.load_threaded_get_status(gf_path)
		if gf_status == ResourceLoader.THREAD_LOAD_LOADED:
			loads.append(true)
			var scn = ResourceLoader.load_threaded_get(gf_path)
			gf = scn.instantiate()
		if loads.size() == 4:
			loading = false
			start()

	if not song_started:
		Conductor.time += delta
		if Conductor.time >= 0.0:
			tracks.player.play()
			song_started = true
	hud.scale = lerp(hud.scale,Vector2.ONE,3.0 * delta)
	if camera:
		camera.zoom = lerp(camera.zoom,Vector2(camera_lerp_zoom,camera_lerp_zoom),delta*3.0)
		if camera_position_auto_lerp:
			camera.position = camera_lerp_position

func on_measure_hit(m:int):
	hud.scale += Vector2(0.03,0.03)
	if camera:
		camera.zoom += Vector2(0.015,0.015)
## for hardcoding prefer to use note scripts
func note_hit(note:Note):
	note.note_hit(note)
func note_miss(note:Note):
	note.note_miss(note)
