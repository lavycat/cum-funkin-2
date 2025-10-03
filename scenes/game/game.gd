
class_name Game extends Node2D
signal song_start
signal song_end
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
var showing_results:bool = false
@onready var events: EventManager = $events
var camera_lerp_position:Vector2 = Vector2.ZERO
var default_camera_zoom:Vector2 = Vector2.ONE
static var cache:Dictionary[String,PackedScene] = {}
var camera:Camera2D = null
var camera_bump_modulo:int = 4
var stage:Stage
var dad:Character
var gf:Character
var bf:Character

var camera_bumps:bool = true
var game_bump:Vector2 = Vector2(0.015,0.015)
var hud_bump:Vector2 = Vector2(0.03,0.03)

var game_modifiers:GameModifiers = GameModifiers.new()
var opponent_mode:bool = false
var health:float = 1.0:
	set(v):
		health = clampf(v, 0.0, max_health)
var max_health:float = 2.0

static var instance:Game
static var song_name = "glitcher"
static var song_difficulty:StringName = "hard"
static var song_variation:StringName = ""

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
		if cache.has(p):
			return cache.get(p).instantiate()
		else:
			cache.set(p,ResourceLoader.load("res://scenes/game/characters/%s.tscn"%p,"",ResourceLoader.CACHE_MODE_REPLACE))
			return ResourceLoader.load("res://scenes/game/characters/%s.tscn"%p,"").instantiate()
	else:
		return load("res://scenes/game/characters/%s.tscn"%fb).instantiate()
func _enter_tree() -> void:
	chart = Global.chart
	if is_story_mode:
		song_name = level_songs[level_index]
		chart = ChartParser.load_chart(level_songs[level_index],song_difficulty)
		Global.chart = chart

	instance = self
	var p = "res://scenes/game/stages/%s.tscn"%chart.stage
	if not ResourceLoader.exists(p):
		print("stage not found loading default")
		p = "res://scenes/game/stages/stage.tscn"
	if not cache.has(p):
		cache.set(p,ResourceLoader.load(p,"",ResourceLoader.CACHE_MODE_REPLACE))
		stage = load(p).instantiate()
	else:
		stage = cache.get(p).instantiate()
	gf = load_character(chart.gf,"gf")
	dad = load_character(chart.dad,"dad")
	bf = load_character(chart.bf,"bf")
	print(cache)
func apply_game_mods():
	var mods = game_modifiers
	opponent_mode = mods.opponent_mode
	Conductor.rate = mods.play_back_rate
	if opponent_mode:
		player_field.auto_play = true
		player_field.display_rating = false
		player_field.show_splashs = false
		
		dad_field.auto_play = mods.bot_play
		dad_field.display_rating = true
		dad_field.show_splashs = true
		
	else:
		player_field.auto_play = mods.bot_play
		
	pass
var meta:SongMeta
func load_meta(song:String) -> SongMeta:
	const songs_folder = "res://assets/songs/"
	var meta_path:String = songs_folder + song + "/meta.tres"
	if ResourceLoader.exists(meta_path):
		return load(meta_path)
	else:
		return SongMeta.new()
func _ready() -> void:
	meta = load_meta(song_name)
	Global.game_meta = meta
	game_modifiers = Global.game_modifiers
	if is_story_mode:
		game_modifiers = GameModifiers.new()
	apply_game_mods()
	MobileControls.controls_shown = MobileControls.CONTROLS_SHOWN_GAME
	Conductor.follow_player = true
	Conductor.measure_hit.connect(measure_hit)
	Conductor.beat_hit.connect(beat_hit)
	Conductor.step_hit.connect(step_hit)
	
	Conductor.time = -Conductor.beat_length*5.0
	Conductor.offset = Save.json.offset
	play_fields = [dad_field,player_field]
	tracks.load_song(song_name)
	Conductor.player = tracks.player
	Conductor.player.pitch_scale = Conductor.rate
	Engine.time_scale = Conductor.rate
	for i in play_fields:
		i.position.y = hud.size.y*0.15 if not Save.json.down_scroll else hud.size.y*0.85
		i.position.x = hud.size.x*0.25
		i.position.x += hud.size.x * 0.5 * i.id
		var n = chart.notes.filter(func(a): return a.field_id == i.id)
		i.notes = n
		i.preload_note_scripts()

	add_child(stage)
	camera = stage.cam
	camera.zoom = Vector2(stage.default_cam_zoom,stage.default_cam_zoom)
	default_camera_zoom = camera.zoom
	camera.make_current()
	camera.position = camera_lerp_position
	stage.add_child(gf)
	stage.add_child(dad)
	stage.add_child(bf)
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
	if is_instance_valid(meta.hud_scene):
		hud = meta.hud_scene.instantiate()
	else:
		hud = load("res://scenes/game/huds/funkin.tscn").instantiate()
	ui.add_child(hud)
	playfields.reparent(hud,false)
	
	if Global.game_meta.player_strum_style:
		player_field.strum_style = Global.game_meta.player_strum_style
		player_field.reload_strum_style()
	if Global.game_meta.cpu_strum_style:
		dad_field.strum_style = Global.game_meta.cpu_strum_style
		dad_field.reload_strum_style()
	## note_styles
	if Global.game_meta.player_note_style:
		player_field.note_style = Global.game_meta.player_note_style
	if Global.game_meta.cpu_note_style:
		dad_field.note_style = Global.game_meta.cpu_note_style
		
	var scripts_dir = "res://assets/songs/%s/scripts/"%song_name
	var scripts = ResourceLoader.list_directory(scripts_dir)
	for i in scripts:
		var script = FunkinScript.new()
		script.set_script(load(scripts_dir + i))
		add_child(script)
	

	Conductor.time = -Conductor.beat_length*3.0

	
var filter_audio:AudioEffectFilter = AudioServer.get_bus_effect(0,1) as AudioEffectFilter
func note_miss(note:Note):
	filter_audio.resonance = 1
	if not opponent_mode:
		if note.play_field.id == 1:
			health -= 0.08
	else:
		if note.play_field.id == 0:
			health -= 0.08
func note_hit(note:Note):
	match note.note_field.play_field.id:
		0:
			if opponent_mode:
				if not note.was_hit:
					health += 0.02
				else:
					health += 0.08 * get_process_delta_time()
		1:
			if not opponent_mode:
				if not note.was_hit:
					health += 0.02
				else:
					health += 0.08 * get_process_delta_time()

func _process(delta: float) -> void:
	if filter_audio:
		filter_audio.resonance = lerpf(filter_audio.resonance,0,delta * 9.0)
		if filter_audio.resonance > 0:
			AudioServer.set_bus_effect_enabled(0,1,true)
		if filter_audio.resonance < 0.1:
			AudioServer.set_bus_effect_enabled(0,1,false)
	queue_redraw()
	if is_equal_approx(health,0):
		get_tree().reload_current_scene()
	if song_started:
		DiscordRPC.details = "Playing: %s -> %s/%s"%[song_name.to_pascal_case(),Global.time_convert(Conductor.time),Global.time_convert(Conductor.player.stream.get_length())]
		DiscordRPC.refresh()
	if Conductor.player.get_playback_position() == 0 and song_started:
		var save_stats = player_field.stats
		if opponent_mode:
			save_stats = dad_field.stats
		if save_stats.score > HighScore.get_song_score(song_name,song_difficulty):
			HighScore.save_song_score(save_stats.score,song_name,song_difficulty)
		if is_story_mode:
			level_score += player_field.stats.score
			if level_index == level_songs.size() - 1:
				HighScore.save_level_score(level_score,level_name,song_difficulty)
				return_to_menu(true)
			else:
				get_tree().reload_current_scene()
				level_index += 1
		else:
			return_to_menu(true)
	hud.scale = lerp(hud.scale,Vector2.ONE,1 - exp(-3.0 * delta))
	camera.zoom = lerp(camera.zoom,default_camera_zoom,1 - exp(-3.0 * delta))
	if camera:
		camera.position = camera_lerp_position
	if not song_started:
		Conductor.time += delta
		if Conductor.time >= 0.0:
			song_start.emit()
			song_started = true
			Conductor.player.play()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_pause") and not paused:
		if showing_results:
			return
		process_mode = Node.PROCESS_MODE_DISABLED
		pause_ui = pause_menu.instantiate()
		await RenderingServer.frame_post_draw
		add_child(pause_ui)
		paused = true
	if event.is_action_pressed("ui_cancel"):
		return_to_menu()
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
			if opponent_mode:
				dad_field.auto_play = not dad_field.auto_play
			else:
				player_field.auto_play = not player_field.auto_play
func beat_hit(beat:int):
	if camera_bumps and Save.json.get("cam_bumps",false):
		if beat % camera_bump_modulo == 0:
			hud.scale += hud_bump
			camera.zoom += game_bump
	pass
func measure_hit(measure:int):
	pass
func step_hit(step:int):
	pass
	
	
func return_to_menu(open_results:bool = false):
	if open_results:
		if paused:
			return
		showing_results = true
		var scene:PackedScene = load("res://scenes/menus/result_screen/results_screen.tscn")
		var result_screne:Node2D = scene.instantiate()
		result_screne.stats = dad_field.stats if opponent_mode else player_field.stats
		
		add_child(result_screne)
		set_process(false)
		await result_screne.exited
	set_process(true)
	
	DiscordRPC.details = "In Menus"
	DiscordRPC.refresh()
	cache.clear()
	tracks.player.stop()
	Conductor.rate = 1
	MobileControls.controls_shown = MobileControls.CONTROLS_SHOWN_MENU
	AudioServer.set_bus_effect_enabled(0,1,false)
	if not is_story_mode:
		AudioManager.fade_in_global_music()
		SceneManager.change_scene(load("res://scenes/menus/free_play.tscn"))
	if is_story_mode:
		AudioManager.fade_in_global_music()
		SceneManager.change_scene(load("res://scenes/menus/story_menu.tscn"))
func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_WINDOW_FOCUS_OUT:
			if not paused and Save.json.auto_pause:
				pause_ui = pause_menu.instantiate()
				tracks.process_mode = Node.PROCESS_MODE_ALWAYS
				await RenderingServer.frame_post_draw
				add_child(pause_ui)
				paused = true
