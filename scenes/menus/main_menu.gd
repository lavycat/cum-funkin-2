extends Node2D
var options:Array[String] = ["story_mode","freeplay","options","credits"]
var option_sprs:Array[AnimatedSprite2D] = []
var cur_selected:int = 0
@onready var camera: Camera2D = $camera

func _ready() -> void:
	AudioManager.fade_in_global_music()
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
	pass
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_down"):
		change_selceted(1)
	if event.is_action_pressed("ui_up"):
		change_selceted(-1)
	if event.is_action_pressed("ui_accept"):
		select_item(options[cur_selected])
	
func update_camera():
	camera.position = option_sprs[cur_selected].position
func select_item(option:String):
	match option:
		"freeplay":
			AudioManager.fade_out_global_music()
			get_tree().change_scene_to_file("res://scenes/game/game.scn")
func change_selceted(d:int):
	if d != 0:
		AudioManager.play_sfx(AudioManager.SFX_SCROLL)
	cur_selected = wrap(cur_selected + d,0,options.size())
	for i in option_sprs.size():
		var spr = option_sprs[i]
		spr.play(options[i] + " basic")
	option_sprs[cur_selected].play(options[cur_selected] + " white")
	update_camera()
