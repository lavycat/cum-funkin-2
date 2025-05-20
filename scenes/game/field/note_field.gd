class_name NoteField extends Node2D
var play_field:PlayField = null
var scroll_speed:float = 1.0:
	get:
		return scroll_speed / Conductor.rate
var down_scroll:bool = false


static var note_hold_cache:Dictionary = {}
static func get_cached_hold_texture(n:Note):
	if not note_hold_cache.has(n.type):
		note_hold_cache.set(n.type,[])
		var dirs = ["left","down","up","right"]
		for d in dirs:
			var tex = n.style.note_frames.get_frame_texture("%s hold"%d,0).get_image()
			tex.rotate_90(COUNTERCLOCKWISE)
			var p = ImageTexture.create_from_image(tex)
			note_hold_cache.get(n.type).append(p)
	if not note_hold_cache.get(n.type).is_empty():
		return note_hold_cache.get(n.type)[n.column]

func _ready() -> void: 
	note_hold_cache = {}
func _process(delta: float) -> void:
	if not visible:
		return
	for note:Note in get_children():
		
		var strum = play_field.strums[note.column]
		note.visible = true
		note.scale = Vector2(note.style.note_scale,note.style.note_scale)
		var length_diff:float = note.length - note.sustain.length if note.length > 0.0 else 0
		if down_scroll:
			note.position.y = strum.position.y + (Conductor.time - note.time - length_diff) * (450.0 * scroll_speed)
		else:
			note.position.y = strum.position.y + -(Conductor.time - note.time - length_diff) * (450.0 * scroll_speed)
		if note.sustain:
			if note.was_hit:
				if not note.missed:
					note.position.y = min(note.position.y,0)
		note.position.x = strum.position.x
		if note.missed:
			note.modulate.v = 0.6
		if note.was_hit and not note.missed:
			note.sprite.visible = false
