class_name PlayField extends Node2D
@onready var strumlines: Node2D = $strumlines
var strumline_list:Array[StrumLine] = []
var player_strum:StrumLine
var dad_strum:StrumLine
var chart:Dictionary
var note_index:int
func _ready() -> void:
	
	for i:StrumLine in strumlines.get_children():
		var use_chart = Save.get_data("gameplay","use_chart_scroll_speed",true)
		i.notes.scroll_speed = Save.get_data("gameplay","scroll_speed",1.0)
		if use_chart:
			i.notes.scroll_speed = chart.scroll_speed
		strumline_list.append(i)
	dad_strum = strumline_list[0]
	player_strum = strumline_list[1]
func _process(delta: float) -> void:
	spawn_notes(1.0)
func spawn_notes(speed:float = 1.0):
	var time_range_sec = 2.0 / speed
	
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
