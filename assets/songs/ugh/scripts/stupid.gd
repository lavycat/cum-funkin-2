extends FunkinScript
func note_hit(note:Note):
	if note.type == "ugh":
		game.dad.play_anim("ugh",true)
