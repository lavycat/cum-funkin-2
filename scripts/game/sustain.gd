class_name Sustain extends TextureRect
var length:float = 0.0
var note:Note
var tail:Sprite2D
var released_timer:float = 0.0
var dirty:bool = true
var rendering_method:String
func _enter_tree() -> void:
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	if length <= 0.0:
		queue_free()
		return
	var frames = note.style.note_frames
	texture = frames.get_frame_texture("%s hold"%note.direction,0)
	tail = Sprite2D.new()
	tail.centered = false
	var tail_tex = frames.get_frame_texture("%s tail"%note.direction,0)
	tail.texture = tail_tex
	add_child(tail)

	size.x = tail.texture.get_width()
	rendering_method = note.get_style(note).rendering_method
	
func texture_tile_hack(tex:Texture2D):
	if not tex:
		return
	if not tex is AtlasTexture or rendering_method != "tile":
		return
	var ci = get_canvas_item()
	RenderingServer.canvas_item_clear(ci)
	
	var tx_size:Vector2 = texture.region.size
	var tx_src:Rect2 = texture.region
	var its:int = size.y / tx_size.y
	for s in its:
		if s > 0:
			tx_src.size.y *= -1
		var size := tx_size
		RenderingServer.canvas_item_add_texture_rect_region(ci,Rect2(Vector2(0,tx_size.y*s),tx_size),texture.get_rid(),tx_src)

func _process(delta: float) -> void:
	var length_px = (((450.0 * note.note_field.scroll_speed) * length) / note.scale.y)
	var length_px_true = (((450.0 * note.note_field.scroll_speed) * note.length) / note.scale.y)
	var tail_height = tail.texture.get_height() * tail.scale.y
	stretch_mode = TextureRect.STRETCH_TILE
	texture_repeat = CanvasItem.TEXTURE_REPEAT_MIRROR
	position.y = (length_px - tail_height)
	scale.y = -1
	size.y = length_px_true - tail_height
	tail.position.y = -tail_height
	tail.flip_v = true
	modulate.a = max(1.0 - (released_timer / Conductor.step_length*0.5),0.6)
func _draw() -> void:
	texture_tile_hack(texture)
