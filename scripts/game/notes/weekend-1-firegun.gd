extends Note

func note_hit(note:Note):
	game.bf.modulate.a = 0
	get_tree().create_tween().tween_property(game.bf,"modulate:a",1,0.6).set_trans(Tween.TRANS_EXPO)
	pass
func note_miss(note:Note):
	pass
