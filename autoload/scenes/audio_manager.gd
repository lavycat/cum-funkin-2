extends Node
@onready var scroll: AudioStreamPlayer = $scroll
@onready var confirm: AudioStreamPlayer = $confirm
@onready var cancel: AudioStreamPlayer = $cancel
@onready var global_music: AudioStreamPlayer = $global_music

enum {
	SFX_SCROLL = 0,
	SFX_CONFIRM = 1,
	SFX_CANCEL = 2
}
func play_sfx(type:int):
	match type:
		SFX_SCROLL:
			scroll.play()
		SFX_CONFIRM:
			confirm.play()
		SFX_CANCEL:
			cancel.play()
func play_global_music(stream:AudioStream = load("uid://dcigb5llb235d"),time:float = 0):
	global_music.stream = stream
	global_music.play(time)
func fade_out_global_music(t:float = 0.33):
	create_tween().tween_property(global_music,"volume_linear",0,t)
func fade_in_global_music(t:float = 0.33):
	create_tween().tween_property(global_music,"volume_linear",1,t)
