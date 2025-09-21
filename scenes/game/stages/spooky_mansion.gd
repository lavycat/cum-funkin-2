extends Stage
var lightning_strike_beat:int = 0
var lightning_strike_offset:int = 8;
@onready var bg: SparrowAtlas = $bg
@onready var thunder: AudioStreamPlayer = $thunder

func lightning_strike(play_sound:bool,beat:int):
	if play_sound:
		thunder.play()
	bg.play("halloweem bg lightning strike")
	lightning_strike_beat = beat
	lightning_strike_offset = randi_range(8,24)
	game.bf.play_anim("scared",true)
	game.gf.play_anim("scared",true)
func beat_hit(beat:int):
	if game.song_name == "spookeez":
		if beat == 4:
			lightning_strike(false,beat)
	if Global.rand_bool(10):
		lightning_strike(true,beat)
