@tool
class_name PlayField extends Node2D
@export_enum("4k:4","5K:5","6K:6","7K:7") var key_count:int = 4
@export_enum("dad","player") var id:int = 0

@export var show_splash:bool = false
@export var display_rating:bool = false
@export var auto_play:bool = false

var stats:Stats = Stats.new()

var directions = ["left","down","up","right"]

var note_field:NoteField = null
var notes:Array = []
var strums:Array[Receptor] = []

var buttons:Array[TouchScreenButton] = []
var pressed:Array[bool] = [false,false,false,false]
var actions:Array[String] = ["4k_left","4k_down","4k_up","4k_right"]
var characters:Array[Character] = []

var combo_tex = load("res://assets/ui/funkin/num-sheet.png")
var rating_tex = load("res://assets/ui/funkin/ratings_sheet.png")
var ms_font = load("res://assets/fonts/funkin_combo.tres")
signal note_spawned(note:Note)
signal note_hit(note:Note)
signal note_miss(note:Note)

func _ready() -> void:
	var strumline:Node2D = load("res://scenes/game/field/strum_lines/4k.tscn").instantiate()
	add_child(strumline)
	for i in strumline.get_children():
		if i is Receptor:
			strums.append(i)
	if Engine.is_editor_hint():
		return
	note_field = NoteField.new()
	note_field.play_field = self
	var sc = Save.json.scroll_speed if not Save.json.use_chart_scroll_speed else Global.chart.scroll_speed
	note_field.scroll_speed = sc
	note_field.down_scroll = Save.json.down_scroll
	add_child(note_field)
	var i:int = 0
	for t:TouchScreenButton in buttons:
		t.pressed.connect(func():
			pressed[i] = true
			print("pre")
			)
		t.released.connect(func():
			pressed[i] = true
			)
		i += 1
func find_action_index(ev: InputEvent) -> int:
	for i in actions.size():
		if ev.is_action(actions[i]):
			return i

	return -1
func note_input(note:Note):
	note_hit.emit(note)
	note.note_hit(note)
	var r = Rating.rate_note(note,note.play_field.auto_play)
	stats.notes_hit += 1
	stats.accuracy_points += r.acc
	stats.score += r.score
	stats.ratings.set(r.name,stats.ratings.get(r.name,0))
	stats.combo += 1
	if display_rating and not note.was_hit:
		show_combo(stats.combo)
		pop_up_score(r)
	note.was_hit = true
	note.length = (note.time + note.length) - Conductor.time
	strums[note.column].play_anim("confirm",true)
	for i in characters:
		i.sing(note.column)

func pop_up_score(rating:Rating):
	var ms_txt: Label = Label.new()
	ms_txt.label_settings = LabelSettings.new()
	ms_txt.label_settings.font_size = 64
	ms_txt.label_settings.outline_size = 24
	ms_txt.label_settings.outline_color = Color.BLACK
	ms_txt.label_settings.font = ms_font
	ms_txt.text = "%0.2f MS"%(rating.hit_ms)
	ms_txt.position.y = -128
	ms_txt.position.x -= ms_txt.size.x / 2

	var rat := VelocitySprite.new()
	rat.add_child(ms_txt)
	rat.texture = rating_tex
	rat.vframes = 4
	rat.frame = rating.rank
	rat.scale = Vector2(0.7, 0.7)
	rat.position = Vector2(0,-360)
	rat.acceleration.y = 550;
	rat.velocity.x -= randi_range(0, 10)
	rat.velocity.y -= randi_range(140,175)

	var t: Tween = create_tween().set_trans(Tween.TRANS_SINE)
	t.tween_property(rat,"modulate:a",0,0.2).set_delay(Conductor.beat_length)
	t.tween_callback(rat.queue_free)
	add_child(rat)
func show_combo(c:int):
	var cstr = str(c).pad_zeros(3)
	var count:int = 0
	for i in cstr.split():
		var spr: VelocitySprite = VelocitySprite.new()
		spr.texture = combo_tex
		spr.hframes = 10
		spr.frame = int(i)
		spr.position = Vector2(0,-360)
		spr.position.y += 90
		spr.position.x += 50 * count - 50
		spr.scale = Vector2(0.55,0.55)
		add_child(spr)
		spr.acceleration.y = randi_range(200, 300);
		spr.velocity.y -= randi_range(140, 160);
		spr.velocity.x = randf_range(-5, 5);
		var t: Tween = create_tween()
		t.tween_property(spr,"modulate:a",0,0.2).set_delay(Conductor.beat_length)
		t.tween_callback(spr.queue_free)
		count += 1
func reset_characters():
	match id:
		0:
			characters = [Game.instance.dad]
		1:
			characters = [Game.instance.bf]
		_:
			characters = [Game.instance.gf]

func _input(event: InputEvent) -> void:
	if auto_play:
		return
	if event.is_echo():
		return

	var p: int = find_action_index(event)
	if p == -1:
		return

	pressed[p] = event.is_pressed()
	if not event.is_pressed():
		return

	var start: float = Time.get_ticks_usec()
	var note_array: Array = note_field.get_children()
	var last_note: Note = null
	for note: Note in note_array:
		if last_note != null and not is_equal_approx(last_note.time, note.time):
			break
		if Conductor.time < note.time - note.hit_range:
			break
		if note.column != p:
			continue
		if note.missed:
			continue
		if note.was_hit:
			continue
		last_note = note
		note_input(note)


func note_update(delta:float):
	for note:Note in note_field.get_children():
		var strum = strums[note.column]
		if (note.time - Conductor.time) < 0.0 and not note.was_hit and auto_play:
			pressed[note.column] = true
			strum.play_anim("confirm",true)
			for i in characters:
				if i:
					i.sing(note.column)
			note_hit.emit(note)
			note.note_hit(note)
			var r = Rating.rate_note(note,note.play_field.auto_play)
			stats.score += r.score
			stats.accuracy_points += r.acc
			stats.notes_hit += 1
			stats.ratings.set(r.name,stats.ratings.get(r.name,0))
			stats.combo += 1
			if display_rating:
				pop_up_score(r)
				show_combo(stats.combo)
			note.was_hit = true
		if Conductor.time - note.time > note.hit_range * max(1.0, Conductor.rate):

			if note.sustain and note.was_hit:
				if note.sustain.released_timer > Conductor.step_length*2:
					note_miss.emit(note)
					note.note_miss(note)
					note.missed = true
					stats.misses += 1
					stats.combo = 0

					note.queue_free()

			if not note.was_hit:
				note.missed = true
				stats.misses += 1
				stats.combo = 0
				note_miss.emit(note)
				note.note_miss(note)
				note.queue_free()
		if note.was_hit and not note.missed:
			if note.sustain:
					note_hit.emit(note)
					for i in characters:
						if i:
							if i.sing_timer > Conductor.step_length:
								i.sing(note.column)
					note.note_hit(note)
					if pressed[note.column]:
						if not strum.animation.contains("confirm"):
							strum.play_anim("confirm",true)
			if not note.sustain:
				if auto_play:
					pressed[note.column] = false
				note_hit.emit(note)
				note.note_hit(note)
				note.free()
				continue
			if note.sustain.length < -delta:
				note_hit.emit(note)
				note.note_hit(note)
				if auto_play:
					pressed[note.column] = false
				note.free()
func _physics_process(delta: float) -> void:
	spawn_notes()
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	note_update(delta)
	for i in strums.size():
		var strum:Receptor = strums[i]
		if not pressed[i]:
			if not auto_play:
				strum.play_anim("static")
			if strum.animation.contains("confirm") and not strum.is_playing():
				strum.play_anim("static")
		if strum.animation.contains("static") and pressed[i]:
			strum.play_anim("press")
var note_index:int = 0
var spawn_range:float = 1.5
func spawn_data(n:Chart.NoteData):
	var note = Note.new()
	note.time = n.time
	note.column = n.column
	note.length = n.length
	note.type = n.type
	note.note_field = note_field
	note.play_field = self
	note.style = note.get_style(note)
	note_field.add_child(note)
	note.play_anim("note")
	note.visible = false
	note_spawned.emit(note)
	note_index += 1
func spawn_notes():
	for i in range(note_index,notes.size()):
		var n = notes[i]
		var true_spawn_range = spawn_range / (note_field.scroll_speed)
		var diff = abs(Conductor.time - n.time)
		if n.time < Conductor.time + Conductor.offset:
			spawn_data(n)
			continue
		if diff > true_spawn_range:
			break
		spawn_data(n)
