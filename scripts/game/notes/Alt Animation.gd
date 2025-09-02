extends Note
func note_hit(note:Note):
	for i in note.play_field.characters:
		if i:
			i.sing(note.column,false,true)
