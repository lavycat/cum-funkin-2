extends Note
func note_hit(note:Note):
	game.gf.sing(note.column)
	game.bf.sing(note.column)
	
func note_miss(note:Note):
	if game.gf:
		game.gf.sing(note.column,true)
	if game.bf:
		game.bf.sing(note.column,true)
