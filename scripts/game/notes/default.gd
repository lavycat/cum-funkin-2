extends Note
func note_hit(note:Note):
	for i in note_field.strum_line.chars:
		if i:
			i.sing(note.column)
func note_miss(note:Note):
	for i in note_field.strum_line.chars:
		if i:
			i.sing(note.column,true)
