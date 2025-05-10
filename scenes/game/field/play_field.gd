class_name PlayField extends Node2D
@onready var strumlines: Node2D = $strumlines
var strumline_list:Array[StrumLine] = []

var chart:Dictionary
var note_index:int
var spawn_distance:float = 2.0

var score:float = 0
var misses:int = 0
var acc:float = 1.0

signal note_hit(note:Note)
signal note_miss(note:Note)
signal note_spawn(note:Note)
@onready var player_strum: StrumLine = $strumlines/player_strum
@onready var dad_strum: StrumLine = $strumlines/dad_strum



func _ready() -> void:
	
	for i:StrumLine in strumlines.get_children():
		i.play_field = self
		var use_chart = Save.data.use_chart_scroll_speed
		i.notes.scroll_speed = Save.data.scroll_speed
		if use_chart:
			i.notes.scroll_speed = chart.scroll_speed
		
		strumline_list.append(i)
func _process(delta: float) -> void:
	spawn_notes(1.0)
func spawn_notes(speed:float = 1.0):
	var time_range_sec = spawn_distance / speed * Conductor.rate
	
	for i in range(note_index,chart.notes.size()):
		var data = chart.notes[i]
		var diff = abs(Conductor.time - data.time)
		var ids:int = 0
		var field = strumlines.get_child(data.field_id).notes
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
		
		n.note_field = field
		
		field.add_child(n)
		n.play_anim("note")
		n.visible = false
		note_spawn.emit(n)
