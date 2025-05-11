class_name Game extends Node2D
var play_fields:Array[PlayField] = []
var chart:Dictionary
@onready var tracks: Node = %tracks
@onready var dad_field: PlayField = $CanvasLayer/hud/playfields/dad_field
@onready var player_field: PlayField = $CanvasLayer/hud/playfields/player_field
@onready var hud: Control = $CanvasLayer/hud

var song_started:bool = false
func _enter_tree() -> void:
	if Global.chart != null:
		chart = Global.chart
	else:
		chart = ChartParser.load_chart("manual-blast","hard")
	Global.chart = chart
func _ready() -> void:
	Conductor.offset = Save.data.song_offset
	Conductor.time = -Conductor.beat_length*3.0
	play_fields = [dad_field,player_field]
	tracks.load_song("manual-blast")
	Conductor.player = tracks.player
	for i in play_fields:
		i.position.y = hud.size.y*0.14 if not Save.data.down_scroll else hud.size.y*0.86
		i.position.x = hud.size.x*0.5
		
		if i.id == 0:
			i.position.x += hud.size.x*-0.25
		else:
			i.position.x += hud.size.x*0.25
			
		
		
		var n = chart.notes.filter(func(a): return a.field_id == i.id)
		i.notes = n

	
func _process(delta: float) -> void:
	if not song_started:
		Conductor.time += delta
		if Conductor.time >= 0:
			song_started = true
			Conductor.player.play()
	
