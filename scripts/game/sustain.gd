class_name Sustain extends TextureRect
var length:float = 0.0
var note:Note
var tail:Sprite2D
var clip:ColorRect
var released_timer:float = 0.0

func _enter_tree() -> void:
	z_index = 0
	if length <= 0.0:
		queue_free()
	var frames = note.style.note_frames
	texture = frames.get_frame_texture("%s hold"%note.direction,0)
	tail = Sprite2D.new()
	tail.centered = false
	var tail_tex = frames.get_frame_texture("%s tail"%note.direction,0)
	tail.texture = tail_tex
	add_child(tail)
	
	size.x = tail.texture.get_width()
	
func _process(delta: float) -> void:
	var length_px = (((450.0 * note.note_field.scroll_speed) * length) / note.scale.y)
	var tail_height = tail.texture.get_height() * tail.scale.y

	#position.x = -size.x / 2
	tail.flip_v = Save.data.down_scroll
	#if note.note_field.down_scroll:
		#scale.y = -1
	size.y = length_px - tail_height
	tail.position.y = length_px - tail_height
	tail.position.x = 0
	
	if length_px <= tail_height/2:
		self_modulate.a = 0
		
		
	modulate.a = max(1.0 - (released_timer / Conductor.step_length*0.5),0.6)
	
		
		
