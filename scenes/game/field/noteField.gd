class_name NoteField extends Node2D
var note_data:Array = []
var note_index:int = 0
var strum_line:StrumLine = null
var game:
	get:
		return Game.instance
signal note_update(note:Note)
signal note_spawn(note:Note)
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
		
	
var scroll_speed = 1.0:
	get:
		return scroll_speed / Conductor.rate
var down_scroll:bool = true
func _process(delta: float) -> void:
	
	var count:int = 0
	for i in get_children():
		note_update.emit(i)
		i.visible = true
		# TODO REFACTOR FOR NOTE_STYLES
		var note_scale = i.style.note_scale
		var note_receptor = strum_line.receptors[i.column]
		i.position.x  = note_receptor.position.x
		var length_diff = i.length - i.sustain.length if i.length > 0.0 else 0
		if down_scroll:
			i.position.y = note_receptor.position.y + (Conductor.time - i.time - length_diff) * (450.0 * scroll_speed)
		else:
			i.position.y = note_receptor.position.y + -(Conductor.time - i.time - length_diff) * (450.0 * scroll_speed)

			
		i.scale = Vector2(note_scale,note_scale) * scale
		
		if Conductor.time - i.time > i.hit_range * Conductor.rate and not i.was_hit:
			if not i.missed:
				strum_line.play_field.note_miss.emit(i)
				i.missed = true
		if not i.missed and i.was_hit:
			if i.sustain:
				i.sustain.length = (i.length + i.time) - Conductor.time
		if Conductor.time - (i.time + i.length) > i.hit_range * Conductor.rate:
			i.queue_free()
		if i.was_hit:
			if i.hold_timer > Conductor.step_length + delta:
				strum_line.receptors[i.column].play_anim("confirm",true)
				strum_line.play_field.note_hit.emit(i)
				i.hold_timer = 0.0
			else:
				i.hold_timer += delta
			if not strum_line.cpu:
				if !strum_line.pressed[i.column]:
					if i.sustain.released_timer > Conductor.step_length and !i.missed:
						i.missed = true
						i.was_hit = false
						strum_line.play_field.note_miss.emit(i)
					else:
						if i.sustain:
							i.sustain.released_timer += delta
				else:
					if i.sustain:
						i.sustain.released_timer = 0
						
			if i.length <= 0.0:
				i.queue_free()
				break
			#i.position.y = 0
			
			if i.sustain.length - delta <= 0:
				i.queue_free()
			else:
				i.sprite.visible = false
				
		count += 1
		
		
func _exit_tree() -> void:
	note_data.clear()
func _enter_tree() -> void:
	note_hold_cache.clear()
