extends CanvasLayer
var options:Array[String] = [
	"resume",
	"restart song",
	"exit"
]
var cur_option:int = 0
@onready var options_container: Control = $options_container
@onready var bg: ColorRect = $bg
var selecting:bool = false
@onready var mod: CanvasModulate = $mod

func _ready() -> void:
	MobileControls.controls_shown = MobileControls.CONTROLS_SHOWN_MENU
	var i = 0
	for o in options:
		var t := Label.new()
		t.text = o.to_upper()
		t.label_settings = LabelSettings.new()
		t.label_settings.font = load("res://assets/fonts/bold.png")
		t.label_settings.font_size = 72
		options_container.add_child(t)
		t.position.x += (30 * i) + 90
		t.position.y += 160 * i
		
		i += 1
	
	var t = create_tween()
	t.tween_property(bg,"color:a",0.6,0.3).set_trans(Tween.TRANS_CIRC)

func _process(delta: float) -> void:
	options_container.position.y = lerpf(options_container.position.y,360 + (160.0 * -cur_option),delta * 9) 
func _unhandled_input(event: InputEvent) -> void:
	if selecting:
		return
	if event.is_action_pressed("ui_down"):
		change_option(1)
	if event.is_action_pressed("ui_up"):
		change_option(-1)
	if event.is_action_pressed("ui_accept"):
		select_option(cur_option)

func change_option(p:int):
	if p != 0:
		AudioManager.play_sfx(AudioManager.SFX_SCROLL)
	cur_option = wrap(cur_option + p,0,options.size())
func select_option(o:int):
	var option_str = options[o]
	selecting = true
	match option_str.to_lower():
		"restart song":
			Engine.time_scale = Conductor.rate
			Conductor.player.pitch_scale = Conductor.rate
			if Input.is_key_pressed(KEY_SHIFT):
				Game.cache.clear()
			get_tree().reload_current_scene()
		"exit":
			Engine.time_scale = Conductor.rate
			Conductor.player.pitch_scale = Conductor.rate
			Game.instance.return_to_menu()
		_:
			Conductor.follow_player = true
			if Game.instance.song_started:
				Conductor.player.play(Conductor.time)
			MobileControls.controls_shown = MobileControls.CONTROLS_SHOWN_GAME
			queue_free()
			Game.instance.process_mode = Node.PROCESS_MODE_INHERIT
			Game.instance.paused = false
			
	pass
