extends Node2D
@export var list:Array[String] = []
@onready var songs: Node2D = $songs
@onready var camera: Camera2D = $camera
@onready var bg: Sprite2D = $Parallax2D/bg
@onready var label: Label = $Parallax2D/ColorRect/Label
@onready var button: Button = $Parallax2D/Button
var gamemods_scene:PackedScene = load("res://scenes/menus/game_play_mods_menu.tscn")
var gamemods:Node2D = null
var cur_song:String = ""
var diffculties:PackedStringArray = []
var cur_diff:String = "hard"
var song_metas:Array[SongMeta] = []
var song_score:int = 0
var song_score_lerped:int = 0

static var cur_selected:int = 0
var cur_color:Color = Color.WHITE
var game_mods_open:bool = false
func get_song_meta(i:int) -> SongMeta:
	if song_metas.size() > i:
		return song_metas[i]
	const songs_folder = "res://assets/songs/"
	var meta_path:String = songs_folder + list[i] + "/meta.tres"
	if ResourceLoader.exists(meta_path):
		return load(meta_path)
	else:
		return SongMeta.new()
func _ready() -> void:
	for i in list.size():
		song_metas.append(get_song_meta(i))
		var s = list[i]
		var t := Label.new()
		t.text = s.to_upper()
		t.label_settings = LabelSettings.new()
		t.label_settings.font = load("res://assets/fonts/funkin.ttf")
		t.label_settings.font_size = 72
		t.label_settings.outline_size = 24
		t.label_settings.outline_color = Color.BLACK
		
		
		t.position.x += (20*i) + 90
		t.position.y += (120 * i) + 30 + pow(346,1.5)
		var icon := Sprite2D.new()
		var meta = get_song_meta(i)
		icon.texture = meta.icon
		icon.hframes = meta.icon_frames
		icon.position.x = t.size.x + 75
		icon.position.y = t.size.y / 1.5
		
		t.add_child(icon)
		songs.add_child(t)
	change_selected(0)
		
func open_game_mods_menu():
	
		if not game_mods_open:
			game_mods_open = true
			gamemods = gamemods_scene.instantiate()
			button.hide()
			add_child(gamemods)
		else:
			game_mods_open = false
			button.show()
			
			gamemods.queue_free()
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_open_gamemods"):
		open_game_mods_menu()
		
	if game_mods_open:
		if event.is_action_pressed("ui_cancel"):
			open_game_mods_menu()
		return
	if event.is_action_pressed("ui_cancel"):
		AudioManager.play_sfx(AudioManager.SFX_CANCEL)
		SceneManager.change_scene(load("res://scenes/menus/main_menu.tscn"))
	if event.is_action_pressed("ui_right"):
		change_diff(1)
	if event.is_action_pressed("ui_left"):
		change_diff(-1)
	
	if event.is_action_pressed("ui_down"):
		change_selected(1)
	if event.is_action_pressed("ui_up"):
		change_selected(-1)
	if event.is_action_pressed("ui_accept"):
		Game.is_story_mode = false
		Game.song_name = cur_song
		Global.chart = null
		Global.chart = ChartParser.load_chart(cur_song,cur_diff)
		SceneManager.change_scene(load("res://scenes/game/game.scn"))
		AudioManager.fade_out_global_music()
func change_diff(p:int):
	cur_diff = diffculties[wrap(diffculties.find(cur_diff) + p,0,diffculties.size())]
	update_label()
func change_selected(p:int):
	AudioManager.play_sfx(AudioManager.SFX_SCROLL)
	cur_selected = wrap(cur_selected + p,0,songs.get_child_count())
	cur_song = list[cur_selected]
	diffculties = get_song_meta(cur_selected).difficulties
	change_diff(0)
	if diffculties.has("normal"):
		cur_diff = diffculties[diffculties.find("normal")]
	update_camera()
	update_color()
	update_label()
func update_label():
	song_score = HighScore.get_song_score(cur_song,cur_diff)
	label.text = "%s\nHighScore -> %d\n < %s >"%[cur_song,song_score_lerped,cur_diff]
func update_color():
	cur_color = get_song_meta(cur_selected).color
func _process(delta: float) -> void:
	update_label()
	if abs(song_score_lerped - song_score) < 100:
		song_score_lerped = song_score
	song_score_lerped = lerpf(song_score_lerped,song_score,1.0 - exp(-15.0 * delta))
	bg.modulate = lerp(bg.modulate,cur_color,1.0 - exp(-delta*9.0))
func update_camera():
	camera.position.y = songs.get_child(cur_selected).position.y + songs.get_child(cur_selected).size.y / 2
	camera.position.x = songs.get_child(cur_selected).position.x + 600
