extends Node

var rate:float = 1.0:
	set(v):
		rate = v
		Engine.time_scale = rate
		if player:
			player.pitch_scale = rate

var changes:Array[Dictionary] = []

var last_change:Dictionary = {"bpm": 100,"time": 0,"step": 0}
var offset:float = 0.0
var time:float = 0.0:
	get:
		return time
var play_head:float = 0.0
var freeze_play_head:bool = false
var bpm:float = 1
var beat:float = 0
var step:float = 0
var measure:float = 0
var cock:float = 0.0
var beat_length:float = 0.0
var step_length:float = 0.0
var last_music_time:float = 0.0

signal beat_hit(beat:int)
signal step_hit(step:int)
signal measure_hit(measure:int)

var player:AudioStreamPlayer = null
var steps = [0,0,0]
var beats_index = 0
func add_change(time:float,bpm:float,step:float):
	changes.append({"bpm":bpm,"time":time,"step":step})
func _process(delta: float) -> void:
	update_song_position()
	beat_length = 60/bpm
	step_length = beat_length*0.25
	for i in changes:
		if time > i.time:
			last_change = i
	bpm = last_change.bpm
	var last_step = floor(step)
	var last_beat = floor(beat)
	var last_measure = floor(measure)
	step = last_change.step + (time - last_change.time) / step_length
	beat = step / 4.0
	measure = beat / 4.0
	if floor(step) > last_step:
		for i in range(last_step,floor(step)):
			step_hit.emit(i)
	if floor(beat) > last_beat:
		for i in range(last_beat,floor(beat)):
			beat_hit.emit(i)
	if floor(measure) > last_measure:
		for i in range(last_measure,floor(measure)):
			measure_hit.emit(floor(measure))
		

	
	
func update_song_position():
	var delta = get_process_delta_time()
	if player:
		player.pitch_scale = rate
		if player.playing:
			var music_time:float = player.get_playback_position()
			if music_time != last_music_time:
				time = music_time
				last_music_time = time
			else:
				time += delta
				
	if !freeze_play_head:
		play_head = time - offset
