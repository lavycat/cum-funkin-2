extends Node2D
@onready var speaker: SparrowAtlas = $CanvasLayer/ui/speaker
@onready var scoreing_stuff: SparrowAtlas = $"CanvasLayer/ui/speaker/scoreing stuff"
@onready var score: SparrowAtlas = $CanvasLayer/ui/speaker/score
@onready var results: SparrowAtlas = $CanvasLayer/ui/results
@onready var top_bar_black: Sprite2D = $CanvasLayer/ui/TopBarBlack
@onready var score_counter: CanvasGroup = $CanvasLayer/ui/speaker/score_counter
@onready var character: Node2D = $CanvasLayer/ui/character
@export var stats:Stats = Stats.new()
signal exited
var character_folder:String = "bf"
var game:Game = Game.instance
var rating_shit_started:bool = false
var cur_scoreing_label:Label = null
var rating_shit_finished:bool = false
var input_active:bool = false
var rank:String = "perfect"
func get_rank() -> String:
	if stats.get_accuracy() == 100.0:
		return "perfect"
	if stats.get_accuracy() > 90.0:
		return "excellent"
	if stats.get_accuracy() > 80.0:
		return "great"
	if stats.get_accuracy() > 70.0:
		return "good"
	return "loss"
	
func rating_shit():
	if rating_shit_started:
		return
	var properties:Array[String] = ["notes_hit","max_combo","ratings"]
	var ratings:Array[String] = ["sick","good","bad","shit","miss"]
	for i in scoreing_stuff.get_child_count():
		var c = scoreing_stuff.get_child(i)
		cur_scoreing_label = c
		var val:int = 0
		if i < 2:
			val = stats.get(properties[i])
		else:
			val = stats.ratings.get(ratings[i-2])
			
		if c is Label:
			var cal:Callable = func(value:int):
				c.text = str(value)
			var t = create_tween().tween_method(cal,0,val,.3)
			cur_scoreing_label = c
			c.text = ""
			c.show()
			await t.finished
			if i == scoreing_stuff.get_child_count()-1:
				rating_shit_finished = true

func _ready() -> void:
	rank = get_rank()
	load_character()
	print(rank)
	top_bar_black.position.x = -1280
	create_tween().tween_property(top_bar_black,"position:x",0,.75).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	results.play("results instance 1")
	speaker.frame = 0
	scoreing_stuff.frame = 0
	score.frame = 0
	speaker.hide()
func _process(_delta: float) -> void:
	score_counter.score = stats.score
	if results.frame > 3 and speaker.frame < 1:
		speaker.play("sound system")
		speaker.show()
	if speaker.frame > 8 and scoreing_stuff.frame < 1:
		scoreing_stuff.play("Categories")
		scoreing_stuff.show()
		
	if scoreing_stuff.frame > 14 and score.frame < 1:
		rating_shit()
		rating_shit_started = true
		if rating_shit_finished:
			score.play("tally score")
			score.show()
		
	if score.frame > 3:
		score_counter.show()
		if not score_counter.displaying:
			score_counter.update_score()
			await score_counter.finished
			input_active = true
			speaker.add_sibling(character)
			speaker.move_to_front()
			
			
func load_character():
	character.queue_free()
	var character_scene:PackedScene = load("res://scenes/menus/result_screen/characters/bf/%s.tscn"%rank)
	character = character_scene.instantiate()
func _input(event: InputEvent) -> void:
	if not input_active:
		return
	if Input.is_action_just_pressed("ui_accept"):
		exited.emit()
