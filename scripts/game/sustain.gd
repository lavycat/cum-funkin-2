class_name Sustain extends Line2D
var length:float = 0.0:
	set(v):
		length = max(v,0)
var note:Note
var tail:Sprite2D
var released_timer:float = 0.0
func _enter_tree() -> void:
	z_index = -1
	if length <= 0.0:
		queue_free()
	for i in 2:
		add_point(Vector2.ZERO)
	width = 50
	var frames = note.style.note_frames
	texture_repeat = CanvasItem.TEXTURE_REPEAT_MIRROR
	texture_mode = Line2D.LINE_TEXTURE_TILE
	texture = NoteField.get_cached_hold_texture(note)
	tail = Sprite2D.new()
	var tail_tex = frames.get_frame_texture("%s tail"%note.direction,0)
	tail.texture = tail_tex
	add_child(tail)
	
func _process(delta: float) -> void:
	pass
	var length_px = (((450.0 * note.note_field.scroll_speed) * length) / note.scale.y)
	var tail_height = tail.texture.get_height()/2.0 * tail.scale.y
	length_px -= tail_height
	tail.flip_v = note.note_field.down_scroll
	set_point_position(1,Vector2(0,length_px))
	if note.note_field.down_scroll:
		set_point_position(1,Vector2(0,-length_px))
		tail.flip_v = true
	tail.position.y =  get_point_position(1).y
	modulate.a = 1.0 - (released_timer / Conductor.step_length) * 0.6
	
		
		
