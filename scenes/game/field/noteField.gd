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
func queue_notes():
	var time_range_sec = 2.0 / scroll_speed
	
	for i in range(note_index,note_data.size()):
		var data = note_data[i]
		var diff = abs(Conductor.time - data.time)
		var ids:int = 0
		if data.time < Conductor.time:
			note_index += 1
			continue
		if diff >= time_range_sec:
			break
		
		note_index += 1
		var n:Note = Note.new()
		var note_script_path = "res://scripts/game/notes/%s.gd"%data.type
		if ResourceLoader.exists(note_script_path):
			n.set_script(load(note_script_path))
		else:
			n.set_script(load("uid://blp8wbqjjdsaf"))
		n.time = data.time
		n.column = data.column
		n.type = data.type
		n.length = data.length
		
		n.note_field = self
		game.scripts.append(n)
		
		add_child(n)
		n.play_anim("note")
		n.visible = false
		note_spawn.emit(n)
#var max_note_per_update:int = INF
func _physics_process(delta: float) -> void:
	pass
	
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
				strum_line.note_miss.emit(i)
				i.missed = true
		if Conductor.time - (i.time + i.length) > i.hit_range * Conductor.rate:
			i.queue_free()
		if i.was_hit:
			strum_line.note_hit.emit(i)
			if not strum_line.cpu:
				if !strum_line.pressed[i.column]:
					if i.sustain.released_timer > Conductor.step_length and !i.missed:
						i.missed = true
						i.was_hit = false
						strum_line.note_miss.emit(i)
					else:
						if i.sustain:
							i.sustain.released_timer += delta
				else:
					if i.sustain:
						i.sustain.released_timer = 0
						
			strum_line.receptors[i.column].play_anim("confirm",true)
			if i.length <= 0.0:
				i.queue_free()
				break
			#i.position.y = 0
			
			if i.sustain.length <= 0:
				i.queue_free()
			else:
				i.sprite.visible = false
				if not i.missed:
					i.sustain.length = (i.length + i.time) - Conductor.time
		count += 1
		
		
func _exit_tree() -> void:
	note_data.clear()
func _enter_tree() -> void:
	note_hold_cache = {}
