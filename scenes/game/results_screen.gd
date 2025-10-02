extends Node2D
@onready var speaker: SparrowAtlas = $CanvasLayer/ui/speaker
@onready var scoreing_stuff: SparrowAtlas = $"CanvasLayer/ui/speaker/scoreing stuff"
@onready var scoreing_stuff_2: SparrowAtlas = $"CanvasLayer/ui/speaker/scoreing stuff2"
@onready var results: SparrowAtlas = $CanvasLayer/ui/results

func _ready() -> void:
	results.play("results instance 1")
	speaker.frame = 0
	scoreing_stuff.frame = 0
	scoreing_stuff_2.frame = 0
	speaker.hide()
	print("asdasd")
func _process(delta: float) -> void:
	if results.frame > 3 and speaker.frame < 1:
		speaker.play("sound system")
		speaker.show()
	if speaker.frame > 8 and scoreing_stuff.frame < 1:
		scoreing_stuff.play("Categories")
		scoreing_stuff.show()
	if scoreing_stuff.frame > 14 and scoreing_stuff_2.frame < 1:
		scoreing_stuff_2.play("tally score")
		scoreing_stuff_2.show()
