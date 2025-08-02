class_name Chart extends Resource
class NoteData extends Resource:
	var time:float
	var column:int
	var length:float
	var field_id:int
	var type:String
class EventData extends Resource:
	var name:String = "unknown"
	var time:float
	var values:Array[Variant]
var dad:String = "dad"
var bf:String = "bf"
var gf:String = "gf"
var bpm:float = 120
var bpm_changes:Array = []
var scroll_speed:float = 1.0
var stage:String = "stage"
var notes:Array[NoteData] = []
var events:Array[EventData] = []
