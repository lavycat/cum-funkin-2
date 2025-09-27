extends Character
var pico_chart:Chart
var cur_note:int = 0
func _ready() -> void:
	pico_chart = ChartParser.load_chart("stress","picospeaker")
	pico_chart.notes.sort_custom(func(a,b): return a.time < b.time )
func _process(delta: float) -> void:
	super(delta)
	if cur_note >= pico_chart.notes.size():
		return
	var nd:Chart.NoteData = pico_chart.notes[cur_note]
	if nd.time < Conductor.time:
		sing(nd.column - randi_range(0,1))
		cur_note += 1
	
		
	
