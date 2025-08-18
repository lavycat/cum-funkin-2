extends Node2D
var cur_mod:int = 0
@onready var mods: Node2D = $CanvasLayer/mods
func get_mod(i:int) -> Node:
	return mods.get_child(i)
func change_mod(d:int = 0):
	cur_mod = wrap(cur_mod + d,0,mods.get_child_count())
	AudioManager.play_sfx(AudioManager.SFX_SCROLL)
	pass
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_down"):
		change_mod(1)
	if event.is_action_pressed("ui_up"):
		change_mod(-1)
	if event.is_action_pressed("ui_right"):
		get_mod(cur_mod).change_mod(1)
	if event.is_action_pressed("ui_left"):
		get_mod(cur_mod).change_mod(-1)
func _process(delta: float) -> void:
	mods.position.y = lerpf(mods.position.y,-get_mod(cur_mod).position.y + 360,1.0 - exp(-delta*5))
	pass
