extends Stage
#@onready var light: Sprite2D = $Light
#func _process(delta: float) -> void:
	#light.rotation_degrees = sin(Conductor.time*4.0)*15.0
	
@onready var cut: VideoStreamPlayer = $CanvasLayer/cut
var gf_notes:Array[Chart.NoteData] = []
	
func event_triggered(event:Event, time: float, values: Array) -> void:
	print(event.name)
	pass
func _ready() -> void:
	for i in game.chart.notes:
		if i.field_id == 2:
				gf_notes.append(i)
func _process(delta: float) -> void:
	for n in gf_notes:
		if n.time - Conductor.time < 0.0:
			game.gf.sing(n.column)
			if (n.time + n.length) < Conductor.time:
				gf_notes.erase(n)


func step_hit(step:int):
	
	match step:
		3136:
			cut.play()
		pass
	pass
