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
	for note:Note in get_children():
		var strum = play_field.strums[note.column]
		note.scale = Vector2(note.style.note_scale,note.style.note_scale)
		if down_scroll:
			note.position.y = strum.position.y + (Conductor.time - note.time) * (450.0 * scroll_speed)
		else:
			note.position.y = strum.position.y + -(Conductor.time - note.time) * (450.0 * scroll_speed)
		note.position.x = strum.position.x
		if (note.time - Conductor.time) < 0.0 and not note.was_hit and play_field.auto_play:
			play_field.pressed[note.column] = true
			strum.play_anim("confirm",true)
			note.was_hit = true
		if Conductor.time - (note.time) > note.hit_range * Conductor.rate and not note.was_hit:
			note.missed = true
			play_field.note_miss.emit(note)
		if note.was_hit:
			note.sprite.visible = false
			note.position.y = 0
			if not note.sustain:
				if play_field.auto_play:
					play_field.pressed[note.column] = false
				play_field.note_hit.emit(note)
				note.queue_free()
			if note.sustain:
				note.sustain.length = (note.time + note.length) - Conductor.time
				if play_field.pressed[note.column]:
					note.sustain.released_timer = 0
					if not strum.animation.contains("confirm"):
						strum.play_anim("confirm",true)
					else:
						if note.sustain.released_timer > Conductor.step_length:
							note.missed = true
						note.sustain.released_timer += delta
				
				if note.sustain.length <= 0:
					if play_field.auto_play:
						play_field.pressed[note.column] = false
					play_field.note_hit.emit(note)
					note.queue_free()

				

		
