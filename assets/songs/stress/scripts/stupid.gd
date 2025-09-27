extends FunkinScript
func note_hit(note:Note):
	if note.type == "hehPrettyGood":
		game.dad.play_anim("pretty_good",true)
