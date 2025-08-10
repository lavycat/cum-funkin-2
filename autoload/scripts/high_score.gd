extends Node
var scores:Dictionary = {
	## songname/diff - scoredata
	"song_scores":{},
	## levelname/diff - scoredata
	"level_scores":{}
}
func _ready() -> void:
	scores = Save.json.get("scores")
	pass
func save_song_score(score:int,song:String,diff:String):
	Save.json.set("scores",scores)
	Save.save_data()
	scores.song_scores.set("%s/%s"%[song,diff],score)
func save_level_score(score:int,level:String,diff:String):
	Save.json.set("scores",scores)
	Save.save_data()
	scores.level_scores.set("%s/%s"%[level,diff],score)

func get_song_score(song:String,diff:String):
	return scores.song_scores.get("%s/%s"%[song,diff],0)
func get_level_score(level:String,diff:String):
	return scores.level_scores.get("%s/%s"%[level,diff],0)
