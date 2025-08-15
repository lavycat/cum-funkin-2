
class_name Game extends Node2D
var play_fields:Array[PlayField] = []
var chart:Chart
@onready var tracks: Node = %tracks
@onready var dad_field: PlayField = $UI/playfields/dad_field
@onready var player_field: PlayField = $UI/playfields/player_field
@onready var playfields: Node2D = %UI/playfields
@onready var hud: Control = %UI/hud
@onready var ratings_layer: CanvasLayer = $ratings
@onready var combo_layer: CanvasLayer = $combo
@onready var ui: CanvasLayer = %UI

var song_started:bool = false
@onready var events: EventManager = $events
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
		health = clampf(v, 0.0, max_health)
var max_health:float = 2.0
var accuracy_points:float = 0
var accuracy_points_max:float = 0

var accuracy:float = -1


static var instance:Game
static var song_name = "glitcher"
static var level_songs:Array[StringName] = []
static var level_index:int = 0
static var level_name:StringName = ""
static var level_score:int = 0
static var is_story_mode:bool = false
var paused:bool = false
var pause_menu:PackedScene = load("res://scenes/game/pause_menu.tscn")
var pause_ui:CanvasLayer = null
func load_character(p:String,fb:String):
	if ResourceLoader.exists("res://scenes/game/characters/%s.tscn"%p):
		return ResourceLoader.load("res://scenes/game/characters/%s.tscn"%p,"").instantiate()
	else:
		return load("res://scenes/game/characters/%s.tscn"%fb).instantiate()
func _enter_tree() -> void:
	chart = Global.chart
	if is_story_mode:
		song_name = level_songs[level_index]
		chart = ChartParser.load_chart(level_songs[level_index],"hard")
	instance = self
	var p = "res://scenes/game/stages/%s.tscn"%chart.stage
	if not ResourceLoader.exists(p):
		print("stage not found loading default")
		p = "res://scenes/game/stages/stage.tscn"
	stage = load(p).instantiate()
	gf = load_character(chart.gf,"gf")
	dad = load_character(chart.dad,"dad")
	bf = load_character(chart.bf,"bf")

func _ready() -> void:
	Conductor.follow_player = true
	Conductor.measure_hit.connect(measure_hit)
	Conductor.time = -Conductor.beat_length*5.0
	Conductor.offset = Save.json.offset
	play_fields = [dad_field,player_field]
	tracks.load_song(song_name)
	Conductor.player = tracks.player
	Conductor.player.pitch_scale = Conductor.rate
	Engine.time_scale = Conductor.rate
	print(is_story_mode)
	for i in play_fields:
		i.position.y = hud.size.y*0.15 if not Save.json.down_scroll else hud.size.y*0.85
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
	player_field.characters.append(bf)
	dad_field.characters.append(dad)
	
	camera_lerp_position = dad.camera_position.global_position
	camera.position = camera_lerp_position
	camera.reset_smoothing()
	for i in play_fields:
		i.note_hit.connect(note_hit)
		i.note_miss.connect(note_miss)

	var loaded_event_names: PackedStringArray = []
	var loaded_events: Dictionary[String, Event]
	for event_data: Chart.EventData in chart.events:
		if loaded_event_names.has(event_data.name):
			continue

		loaded_event_names.push_back(event_data.name)
		var event_path: String = "res://scripts/game/events/%s.gd" % event_data.name
		if not ResourceLoader.exists(event_path):
			continue

		var event: Event = Event.new()
		var event_script: Script = load(event_path)
		event.set_script(event_script)
		event.name = event_data.name
		events.add_child(event)
		loaded_events[event.name] = event

	for event_data: Chart.EventData in chart.events:
		if not loaded_events.has(event_data.name):
			continue
		loaded_events[event_data.name].register(event_data.time, event_data.values)
	events.event_data = chart.events
	hud.queue_free()
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
	if note.play_field.id == 1:
		health -= 0.08
		accuracy_points_max += 1
		accuracy = (accuracy_points / accuracy_points_max) * 100.0
		bf.sing(note.column,true)
func note_hit(note:Note):
	match note.note_field.play_field.id:
		1:
			if not note.was_hit:
				health += 0.02
			else:
				health += 0.08 * get_process_delta_time()
		2:
				gf.sing(note.column)
				gf.sing_timer = 0

@onready var rating_tex = load("res://assets/ui/funkin/ratings_sheet.png")
@onready var combo_tex = load("res://assets/ui/funkin/num-sheet.png")
@onready var ms_font = load("res://assets/fonts/funkin_combo.tres")

func pop_up_score(rating:Rating):
	var ms_txt: Label = Label.new()
	ms_txt.label_settings = LabelSettings.new()
	ms_txt.label_settings.font_size = 64
	ms_txt.label_settings.outline_size = 24
	ms_txt.label_settings.outline_color = Color.BLACK
	ms_txt.label_settings.font = ms_font
	ms_txt.text = "%0.2f MS"%(rating.hit_ms)
	ms_txt.position.y = -128
	ms_txt.position.x -= ms_txt.size.x / 2

	var rat := VelocitySprite.new()
	rat.add_child(ms_txt)
	rat.texture = rating_tex
	rat.vframes = 4
	rat.frame = rating.rank
	rat.scale = Vector2(0.7, 0.7)
	rat.position = camera.get_target_position()
	rat.acceleration.y = 550;
	rat.velocity.x -= randi_range(0, 10)
	rat.velocity.y -= randi_range(140,175)

	var t: Tween = create_tween().set_trans(Tween.TRANS_SINE)
	t.tween_property(rat,"modulate:a",0,0.2).set_delay(Conductor.beat_length)
	t.tween_callback(rat.queue_free)
	ratings_layer.add_child(rat)


func _process(delta: float) -> void:
	queue_redraw()
	if is_equal_approx(health,0):
		get_tree().reload_current_scene()
	if Conductor.player.get_playback_position() == 0 and song_started:
		if player_field.stats.score > HighScore.get_song_score(song_name,"hard"):
			HighScore.save_song_score(player_field.stats.score,song_name,"hard")
		if is_story_mode:
			level_score += player_field.stats.score
			if level_index == level_songs.size() - 1:
				HighScore.save_level_score(level_score,level_name,"hard")
				return_to_menu()
			else:
				get_tree().reload_current_scene()
				level_index += 1
		else:
			return_to_menu()
	hud.scale = lerp(hud.scale,Vector2.ONE,1 - exp(-3.0 * delta))
	camera.zoom = lerp(camera.zoom,default_camera_zoom,1 - exp(-3.0 * delta))
	if camera:
		camera.position = camera_lerp_position
	if not song_started:
		Conductor.time += delta
		if Conductor.time >= 0.0:
			song_started = true
			Conductor.player.play()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_pause") and not paused:
		pause_ui = pause_menu.instantiate()
		tracks.process_mode = Node.PROCESS_MODE_ALWAYS
		await RenderingServer.frame_post_draw
		add_child(pause_ui)
		paused = true
	if OS.is_debug_build():
		if event.is_action_pressed("debug_skip_time"):
			Conductor.player.seek(Conductor.time + 10.0)
			Conductor.time = Conductor.time + 10.0
			for p:PlayField in playfields.get_children():
				if p.auto_play:
					continue
				p.spawn_notes()
				for i in p.note_field.get_children():
					i.free()

		if event.is_action_pressed("debug_bot_toggle"):
			player_field.auto_play = not player_field.auto_play
func measure_hit(measure:int):
	if measure > 0:
		hud.scale += Vector2(0.03,0.03)
		camera.zoom += Vector2(0.015,0.015)
func return_to_menu():
	if not is_story_mode:
		AudioManager.fade_in_global_music()
		get_tree().change_scene_to_file("res://scenes/menus/free_play.tscn")
	if is_story_mode:
		AudioManager.fade_in_global_music()
		get_tree().change_scene_to_file("res://scenes/menus/story_menu.tscn")
		pass
func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_WINDOW_FOCUS_OUT:
			if not paused and Save.json.auto_pause:
				pause_ui = pause_menu.instantiate()
				tracks.process_mode = Node.PROCESS_MODE_ALWAYS
				await RenderingServer.frame_post_draw
				add_child(pause_ui)
				paused = true
