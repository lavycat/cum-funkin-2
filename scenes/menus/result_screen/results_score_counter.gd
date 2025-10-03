extends CanvasGroup
signal finished
var score:int = 99999999999
const DIGITS:Array[String] = ["ZERO","ONE","TWO","THERE","FOUR","FIVE","SIX","SEVEN","EIGHT","NINE"]
var displaying:bool = false
var score_str:String:
	get:
		return str(score).pad_zeros(10)
func update_score():
	displaying = true
	var duration:float = 0
	for i in score_str.length():
		if i >= get_child_count():
			break
		duration += 0.02/(i + 1)
		var timer = get_tree().create_timer(duration,false)
		await timer.timeout
		get_child(i).frame = 0
		get_child(i).play(DIGITS[score_str[i].to_int()] + " DIGITAL")
	finished.emit()
		
		
