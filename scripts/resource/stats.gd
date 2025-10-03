## this class contain data related to stats from a play field used mainly for ui/huds and results screen
class_name Stats extends Resource
# TODO: MAKE ACCURACY TYPES SUCH AS WIFE3
enum AccuracyType {
	SIMPLE,
	RATING_BASED,
	WIFE_3,
}
@export var accuracy_type:int = AccuracyType.RATING_BASED
@export var score:int
@export var notes_hit:int = 0
@export var misses:int = 0
@export var accuracy_points:float = 0

@export var combo:int = 0
@export var max_combo:int = 0
@export var ratings:Dictionary[StringName,int] = {
	"sick" = 0,
	"good" = 0,
	"bad" = 0,
	"shit" = 0,
	"miss" = 0,
}
@export var diffculty:StringName = "hard":
	get:
		return Game.song_difficulty
@export var various:StringName = "":
	get:
		return Game.song_variation


## returns accuracy as a percent
func get_accuracy() -> float:
	if accuracy_points != 0:
		match accuracy_type:
			AccuracyType.SIMPLE:
				return notes_hit / (notes_hit + misses) * 100.0
			AccuracyType.RATING_BASED:
				return (accuracy_points / (notes_hit + misses)) * 100.0
			AccuracyType.WIFE_3:
				# NOTE WIFE 3 NOT IMPLEMENTED
				return NAN
			_:
				return 0
	else:
		return 0
