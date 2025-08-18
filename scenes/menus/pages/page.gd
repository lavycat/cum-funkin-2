extends Node2D
@onready var options: Node2D = $options
@onready var templates: Node2D = $templates
@onready var camera: Camera2D = $camera

var cur_option:int = 0
var options_main:Node2D
func get_option(i:int) -> Node2D:
	return options.get_child(cur_option)
func _process(delta: float) -> void:
	camera.position.y = get_option(cur_option).position.y
func _ready() -> void:
	templates.queue_free()
	for i in options.get_children():
		i.page = self
	change_option()
		
	camera.make_current()
func change_option(i:int = 0) -> void:
	cur_option = wrap(cur_option + i,0,options.get_child_count())
func _input(event: InputEvent) -> void:
	if get_option(cur_option).input_waiting:
		print("p")
		return
	if event.is_action_pressed("ui_down"):
		AudioManager.play_sfx(0)
		change_option(1)
	var option = get_option(cur_option)
	if event.is_action_pressed("ui_up"):
		AudioManager.play_sfx(0)
		change_option(-1)
	if option.option_type != "check_box" or option.option_type != "input":
		if event.is_action_pressed("ui_left"):
			AudioManager.play_sfx(0)
			option.change_value(-1)
		if event.is_action_pressed("ui_right"):
			AudioManager.play_sfx(0)
			option.change_value(1)
	if event.is_action_pressed("ui_accept"):
		if option.option_type == "check_box" or option.option_type == "input":
			AudioManager.play_sfx(0)
			
			option.change_value(1)
