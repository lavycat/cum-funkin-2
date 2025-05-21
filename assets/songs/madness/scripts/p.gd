extends FunkinScript
func note_hit(note:Note):
	if note.play_field.id == 0:
		if not note.was_hit:
			Conductor.rate -= 0.25 * Conductor.rate
		else:
			Conductor.rate -= 0.55*get_process_delta_time()
		
	else:
		if not note.was_hit:
			Conductor.rate += 0.076 * Conductor.rate
		else:
			Conductor.rate += 0.086*get_process_delta_time()
	Conductor.rate = max(1.0,Conductor.rate)
