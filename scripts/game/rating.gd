class_name Rating extends Resource
var score:float = 350
var acc:float = 1.0
var name:String = "sick"
var hit_ms:float = 0
var rank:int = 0
static func rate_note(note:Note,cpu:bool = false) -> Rating:
	var rate = Conductor.rate if Conductor.rate >= 1 else 1
	var note_diff:float = abs(note.time - Conductor.time)*1000.0 / rate
	var r := Rating.new()
	r.hit_ms = (note.time - Conductor.time)*1000.0 / rate
	if cpu:
		r.hit_ms = 0
		return r
	if note_diff > 45:
		r.name = "good"
		r.score = 200
		r.acc = 0.66
		r.rank = 1
	if note_diff > 90:
		r.name = "bad"
		r.score = 100
		r.acc = 0.33
		r.rank = 2

	if note_diff > 135:
		r.name = "shit"
		r.score = 50
		r.acc = 0.0
		r.rank = 3

	return r
	
	pass
