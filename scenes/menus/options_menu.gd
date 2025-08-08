extends Node2D
@export var page_scenes:Array[PackedScene] = []
@onready var checkbox: Node2D = $checkbox
@onready var pages: VBoxContainer = $pages

var in_page:bool = false
var cur_page:int = 0
var cur_option:int = 0
var option_count:int = 0
func get_page_name(i:int):
	pages.get_child(i).name

func _ready() -> void:
	change_selection()
	pass
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_down",true):
		change_selection(1)
	if event.is_action_pressed("ui_up",true):
		change_selection(-1)
func change_selection(i:int = 0):
	if in_page:
		cur_option = wrapf(cur_option + i,0,option_count)
	else:
		cur_page = wrapf(cur_page + i,0,3)
		print(cur_page)
		for l in pages.get_children():
			l.label_settings.font_color = Color.WHITE
		pages.get_child(cur_page).label_settings.font_color = Color.YELLOW
	
	pass
