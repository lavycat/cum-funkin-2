@tool
class_name PlayField extends Node2D
@export_enum("4k:4","5K:5","6K:6","7K:7") var key_count:int = 4
@export_enum("dad","player") var id:int = 0
var directions = ["left","down","up","right"]
@export var auto_play:bool = false
var note_field:NoteField = null
var notes:Array = []
var strums:Array[Receptor] = []
var pressed:Array[bool] = [false,false,false,false]
var actions:Array[String] = ["note_left","note_down","note_up","note_right"]
signal note_spawned(note:Note)
signal note_hit(note:Note)
signal note_miss(note:Note)
signal note_free(note:Note)


func _ready() -> void:
	for i in key_count:
		var r = Receptor.new()
		add_child(r)
		r.sprite_frames = load("res://assets/ui/funkin/strums.xml")
		r.direction = directions[i]
		r.scale = Vector2(0.7,0.7)
		r.position.x -= 165
		r.position.x += 110 * i
		strums.append(r)
		r.play_anim("static")
	note_field = NoteField.new()
	note_field.play_field = self
	var sc = Save.data.scroll_speed if not Save.data.use_chart_scroll_speed else Global.chart.scroll_speed
	note_field.scroll_speed = sc
	note_field.down_scroll = Save.data.down_scroll
	
	add_child(note_field)
func find_action_index(ev:InputEvent):
	var ii = 0
	for i in actions:
		if ev.is_action(i):
			return ii
		ii += 1
	return -1
func note_input(note:Note):
	note_hit.emit(note)
	note.was_hit = true
	strums[note.column].play_anim("confirm",true)
func _input(event: InputEvent) -> void:
	var p = find_action_index(event)
	if event.is_echo() or p == -1 or auto_play:
		return
	pressed[p] = event.is_pressed()
	if event.is_pressed():
		var note_array = note_field.get_children()
		note_array = note_array.filter(func(note): return note.column == p and not note.missed and abs(note.time - Conductor.time) < note.hit_range)
		for note:Note in note_array:
			if note_array.size() > 1:
				var last_note = null
				for fucknote in note_array:
					if last_note != null:
						if is_equal_approx(last_note.time,fucknote.time):
							note_input(fucknote)
					last_note = fucknote
			note_input(note)
			break
		
		
	
func _process(delta: float) -> void:
	spawn_notes()
	for i in strums.size():
		var strum:Receptor = strums[i]
		if auto_play:
			if not pressed[i] and strum.animation.contains("confirm"):
				if not strum.is_playing():
					strum.play_anim("static")
		else:
			if not pressed[i]:
				strum.play_anim("static")
			if strum.animation.contains("static") and pressed[i] and not strum.is_playing():
				strum.play_anim("press")
var note_index:int = 0
var spawn_range:float = 2.0
func spawn_notes():
	for i in range(note_index,notes.size()):
		var n = notes[i]
		var true_spawn_range = spawn_range / (note_field.scroll_speed)
		var diff = abs(Conductor.time - n.time) 
		if n.time < Conductor.time:
			note_index += 1
			continue
		if diff > true_spawn_range:
			break
		var note = Note.new()
		note.time = n.time
		note.column = n.column
		note.length = n.length
		note.type = n.type
		note.note_field = note_field
		note_field.add_child(note)
		note.play_anim("note")
		note_spawned.emit(note)
		note_index += 1
		
	pass
