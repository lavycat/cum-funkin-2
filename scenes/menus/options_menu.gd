extends Node2D
@export var page_scenes:Array[PackedScene] = []
@onready var pages: VBoxContainer = $pages
@onready var camera: Camera2D = $camera

var in_page:bool = false
var cur_page:int = 0
var page:Node
var cur_option:int = 0
var option_count:int = 0
func get_page_name(i:int):
	pages.get_child(i).name

func _ready() -> void:
	change_selection()
	pass
func _input(event: InputEvent) -> void:
	if not in_page:
		if event.is_action_pressed("ui_down",true):
			AudioManager.play_sfx(0)
			change_selection(1)
		if event.is_action_pressed("ui_up",true):
			AudioManager.play_sfx(0)
			change_selection(-1)
		if event.is_action_pressed("ui_accept"):
			select_page(cur_page)
		if event.is_action_pressed("ui_cancel"):
			SceneManager.change_scene(load("res://scenes/menus/main_menu.tscn"))
	if in_page:
		if event.is_action_pressed("ui_cancel"):
			return_to_main()
func select_page(i:int):
	if i > page_scenes.size():
		return
	page = page_scenes[i].instantiate()
	var t = create_tween().set_parallel()
	var q:int = 0
	for p:Label in pages.get_children():
		t.tween_property(p,"position:x",1280 if q %2 == 0 else -1280,0.8).set_trans(Tween.TRANS_CUBIC).set_delay(q*0.1)
		q += 1
	in_page = true
	await t.finished
	add_child(page)
func return_to_main():
	in_page = false
	page.queue_free()
	var t = create_tween().set_parallel()
	var q:int = 0
	for p:Label in pages.get_children():
		t.tween_property(p,"position:x",0,0.8).set_trans(Tween.TRANS_CUBIC).set_delay(q*0.1)
		q += 1
func change_selection(i:int = 0):
	if in_page:
		cur_option = wrapf(cur_option + i,0,option_count)
	else:
		cur_page = wrapf(cur_page + i,0,3)
		for l in pages.get_children():
			l.label_settings.font_color = Color.WHITE
		pages.get_child(cur_page).label_settings.font_color = Color.YELLOW
	
	pass
