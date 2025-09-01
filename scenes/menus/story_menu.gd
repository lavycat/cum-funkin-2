extends Node2D
@export var weeks:Array[StringName]
@onready var level_titles: Node2D = $level_titles
@onready var score: Label = $score
@onready var week: Label = $week
const levels_folder:StringName = &"res://assets/levels/"
var levels:Array[Level] = []
var cur_level:int = 0
var week_score:int = 0
var week_score_lerped:int = 0
var cur_diff:int = 1
var difficulties:Array[StringName] = ["easy","normal","hard"]
@onready var difficulty: TextureRect = $difficulty
@onready var tracks: Label = $tracks

func _ready() -> void:
	for l in weeks:
		var lv = load(levels_folder + l + ".tres")
		levels.append(lv)
	print(levels)
	for l in levels.size():
		add_level(l)
	change_level()
	change_diff()

func add_level(i:int):
	var lv := levels[i]
	var spr := Sprite2D.new()
	spr.texture = lv.level_image
	spr.position.y = 540 + i*120
	spr.position.x = 640
	level_titles.add_child(spr)
func select_level(i:int):
	Game.song_difficulty = difficulties[cur_diff]
	Game.level_songs = levels[i].songs
	Game.is_story_mode = true
	Game.level_name = levels[i].name
	Game.level_index = 0
	AudioManager.fade_out_global_music()
	SceneManager.change_scene(load("res://scenes/game/game.scn"))
	pass
func _process(delta: float) -> void:
	level_titles.position.y = lerpf(level_titles.position.y,-cur_level*120,1.0 - exp(-6.0 * delta))
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		SceneManager.change_scene(load("res://scenes/menus/main_menu.tscn"))
	if event.is_action_pressed("ui_right"):
		change_diff(1)
	if event.is_action_pressed("ui_left"):
		change_diff(-1)
	if event.is_action_pressed("ui_down"):
		change_level(1)
	if event.is_action_pressed("ui_up"):
		change_level(-1)
	if event.is_action_pressed("ui_accept"):
		select_level(cur_level)
func change_level(i:int = 0):
	cur_level = wrap(cur_level + i,0,levels.size())
	week.text = levels[cur_level].name
	tracks.text = "TRACKS\n\n"
	for s in levels[cur_level].songs:
		tracks.text += "%s\n"%s
func change_diff(p:int = 0):
	cur_diff = wrap(cur_diff + p,0,difficulties.size())
	difficulty.texture = load("res://assets/images/menus/difficulties/%s.png"%difficulties[cur_diff])
	difficulty.position.y += 60
	difficulty.modulate.a = 0
	
	var tw = create_tween().set_parallel()
	tw.tween_property(difficulty,"position:y",514,0.3).set_trans(Tween.TRANS_EXPO)
	tw.tween_property(difficulty,"modulate:a",1,0.15)
	pass
