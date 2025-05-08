class_name StrumLine extends Node
var actions:PackedStringArray = [
	"note_left",
	"note_down",
	"note_up",
	"note_right"
]
signal note_hit(note:Note)
signal note_miss(note:Note)


@onready var receptors_node: Node2D = $receptors
@onready var notes:NoteField = %notes
var play_field:PlayField

var receptors:Array[Receptor] = []
var pressed:Array[bool] = [false,false,false,false]
var chars:Array[Character] = []
@export var cpu:bool = true
@export var input:bool = false

func _ready() -> void:
	notes.strum_line = self
	for i in receptors_node.get_children():
		if i is Receptor:
			receptors.append(i)
			i.play_anim("static")
	
func column_from_event(event:InputEvent) -> int:
	var column = 0
	for i in actions:
		if event.is_action(i):
			return column
		column += 1
		
	return -1

func _unhandled_input(event: InputEvent) -> void:
	if event.is_echo() or !input:
		return
	var column = column_from_event(event)
	if column == -1:
		return
	var dacolumn = receptors[column]
	pressed[column] = !event.is_released()
	if event.is_pressed():
		var note_array = notes.get_children()
		note_array = note_array.filter(func(note): return note.column == column and not note.missed and abs(note.time - Conductor.time) < note.hit_range)
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
	
	
func note_input(note:Note):
	note_hit.emit(note)
	note.was_hit = true
	pass
func _process(delta: float) -> void:
	for i in notes.get_children():
		if i.time <= Conductor.time and !i.was_hit and cpu:
			i.was_hit = true
func _physics_process(delta: float) -> void:
	var i:int = 0
	for dacolumn in receptors:
		if input:
			if !pressed[i]:
				dacolumn.play_anim("static")
			if dacolumn.animation.contains("static") and pressed[i]:
				dacolumn.play_anim("press")
				
		if dacolumn.animation.contains("confirm") and cpu:
			if !dacolumn.is_playing():
				dacolumn.play_anim("static")
		i += 1
