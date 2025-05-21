extends CanvasLayer
var options:Array[String] = [
	"resume",
	"restart song",
	"exit"
]
var cur_option:int = 0
@onready var options_container: Control = $options_container
@onready var bg: ColorRect = $bg

func _ready() -> void:
	var i = 0
	for o in options:
		var t := Label.new()
		t.text = o.to_upper()
		t.label_settings = LabelSettings.new()
		t.label_settings.font = load("res://assets/fonts/alphabet_bold.png")
		t.label_settings.font_size = 72
		options_container.add_child(t)
		t.position.x += (30 * i) + 90
		t.position.y += 160 * i
		
		i += 1
	var t = create_tween()
	t.tween_property(bg,"color:a",0.6,0.3).set_trans(Tween.TRANS_CIRC)
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_down"):
		change_option(1)
	if Input.is_action_just_pressed("ui_up"):
		change_option(-1)
	if Input.is_action_just_pressed("ui_pause"):
		select_option(cur_option)

	options_container.position.y = lerpf(options_container.position.y,360 + (160.0 * -cur_option),delta * 9) 
func change_option(p:int):
	cur_option = wrap(cur_option + p,0,options.size())
func select_option(o:int):
	var option_str = options[o]
	match option_str.to_lower():
		"restart song":
			get_tree().reload_current_scene()
		_:
			if Game.instance.song_started:
				Conductor.player.play(Conductor.time)
			Game.instance.paused = false
			Game.instance.process_mode = Node.PROCESS_MODE_INHERIT
			queue_free()
			
	pass
