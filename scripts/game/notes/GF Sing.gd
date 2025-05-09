extends Note
static func get_style():
	return "COCK"
	pass
func note_hit(note:Note):
	if game.gf:
		game.gf.sing(note.column)
func note_miss(note:Note):
	if game.gf:
		game.gf.sing(note.column,true)
