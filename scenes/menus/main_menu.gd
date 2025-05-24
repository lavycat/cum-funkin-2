extends Node2D
var options:Array[String] = ["story_mode","freeplay","options","credits"]
var option_sprs:Array[AnimatedSprite2D] = []
var cur_selected:int = 0
var flicker_speed:float = 0.045
var is_flickering:bool = false
var flicker_time:float = 0
var is_selecting:bool = false
@onready var camera: Camera2D = $camera

func _ready() -> void:
	Engine.time_scale = 1
	AudioManager.fade_in_global_music()
	if not AudioManager.global_music.playing:
		AudioManager.play_global_music()
	for i in options.size():
		var o = options[i]
		var spr := AnimatedSprite2D.new()
		spr.sprite_frames = load("res://assets/images/menus/main_menu/menu_%s.xml"%o)
		spr.position.x = 640
		spr.position.y += 160*i
		$options.add_child(spr)
		option_sprs.append(spr)
	update_camera()
	camera.reset_smoothing()
	change_selceted(0)
func _process(delta: float) -> void:
	if is_flickering:
		flicker_time += delta
		if flicker_time > flicker_speed:
			flicker_time = 0
			option_sprs[cur_selected].visible = not option_sprs[cur_selected].visible
	pass
func _unhandled_input(event: InputEvent) -> void:
	if is_selecting:
		return
	if event.is_action_pressed("ui_down"):
		change_selceted(1)
	if event.is_action_pressed("ui_up"):
		change_selceted(-1)
	if event.is_action_pressed("ui_accept"):
		select_item(options[cur_selected])
	
func update_camera():
	camera.position = option_sprs[cur_selected].position
func select_item(option:String):
	is_flickering = true
	is_selecting = true
	AudioManager.play_sfx(AudioManager.SFX_CONFIRM)
	for q in option_sprs:
		if q == option_sprs[cur_selected]:
			continue
		create_tween().tween_property(q,"modulate:a",0,0.33).set_delay(0.33)
	await get_tree().create_timer(0.9).timeout
	match option:
		"freeplay":
			AudioManager.fade_out_global_music()
			get_tree().change_scene_to_file("res://scenes/game/game.scn")
		_:
			get_tree().reload_current_scene()
func change_selceted(d:int):
	if d != 0:
		AudioManager.play_sfx(AudioManager.SFX_SCROLL)
	cur_selected = wrap(cur_selected + d,0,options.size())
	for i in option_sprs.size():
		var spr = option_sprs[i]
		spr.play(options[i] + " basic")
	option_sprs[cur_selected].play(options[cur_selected] + " white")
	update_camera()
