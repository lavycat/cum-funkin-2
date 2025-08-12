extends Node2D
const levels_folder:StringName = &"res://assets/levels/"
var levels:Array[Level] = []
var cur_level:int = 0
@onready var level_titles: Node2D = $level_titles

func _ready() -> void:
	for l in ResourceLoader.list_directory(levels_folder):
		var lv = load(levels_folder + l)
		levels.append(lv)
	print(levels)
	for l in levels.size():
		add_level(l)
@onready var tracks: Label = $tracks

func add_level(i:int):
	var lv := levels[i]
	var spr := Sprite2D.new()
	spr.texture = lv.level_image
	spr.position.y = 540 + i*120
	spr.position.x = 640
	level_titles.add_child(spr)
func select_level(i:int):
	Game.level_songs = levels[i].songs
	Game.is_story_mode = true
	Game.level_name = levels[i].name
	get_tree().change_scene_to_packed(load("res://scenes/game/game.scn"))
	pass
func _process(delta: float) -> void:
	level_titles.position.y = lerpf(level_titles.position.y,-cur_level*120,1.0 - exp(-6.0 * delta))
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_down"):
		change_level(1)
	if event.is_action_pressed("ui_up"):
		change_level(-1)
	if event.is_action_pressed("ui_accept"):
		select_level(cur_level)
func change_level(i:int = 0):
	cur_level = wrap(cur_level + i,0,levels.size())
	tracks.text = ""
	for s in levels[cur_level].songs:
		tracks.text += "%s\n"%s
		
	pass
