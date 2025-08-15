class_name Stats extends Resource
# TODO: MAKE ACCURACY TYPES SUCH AS WIFE3
@export var accuracy_type:int = 0
@export var score:int
@export var notes_hit:int = 0
@export var misses:int = 0
@export var accuracy_points:float = 0

@export var combo:int = 0
@export var ratings:Dictionary[StringName,int] = {
	"sick" = 0,
	"good" = 0,
	"bad" = 0,
	"shit" = 0,
}
## returns accuracy as a percent
func get_accuracy() -> float:
	return (accuracy_points / (notes_hit + misses)) * 100.0
	return -1
