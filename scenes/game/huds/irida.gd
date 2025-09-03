extends Hud
@onready var icons: Node2D = $bar/icons
@onready var healthbarbg: TextureRect = $bar/healthbarbg
@onready var healthbar: ProgressBar = $bar/healthbar
var lerped_health: float = 1.0
var health_bar_style_bg:StyleBox
var health_bar_style_fill:StyleBox
var is_dark:bool = false
@onready var scoretxt: Label = $bar/scoretxt
@onready var bar: Control = $bar
@onready var time_text: Label = $timebar/time_text

@onready var timebar: TextureProgressBar = $timebar
func reload_icons():
		var bf = icons.get_node("bf")
		var dad = icons.get_node("dad")
		bf.texture = game.bf.icon
		dad.texture = game.dad.icon
		if game.opponent_mode:
			health_bar_style_bg.bg_color = game.bf.icon_color
			health_bar_style_fill.bg_color = game.dad.icon_color
		else:
			health_bar_style_bg.bg_color = game.dad.icon_color
			health_bar_style_fill.bg_color = game.bf.icon_color


func _ready() -> void:
	health_bar_style_bg = healthbar.get_theme_stylebox("background")
	health_bar_style_fill = healthbar.get_theme_stylebox("fill")
	health_bar_style_bg.bg_color = Color.WHITE

	timebar.position.y = 572.0 if Save.json.down_scroll else 52.0
	reload_icons()
	bar.position.y = 100 if Save.json.down_scroll else 620
func time_convert(time_in_sec:int) -> String:
	var seconds = time_in_sec%60
	var minutes = (time_in_sec/60)%60


	#returns a string with the format "HH:MM:SS"
	return "%01d:%02d" % [minutes, seconds]
func _process(delta: float) -> void:
	if is_dark:
		healthbarbg.texture = load("res://assets/images/game/ui/irida/bardark.png")
	else:
		healthbarbg.texture = load("res://assets/images/game/ui/irida/bar.png")
		
	var opacity = Save.json.get("health_bar_opacity",1.0)
	var is_down_scroll = Save.json.get("down_scroll")
	healthbarbg.flip_v = is_down_scroll
	healthbar.position.y = -16
	healthbar.modulate.a = opacity
	healthbarbg.modulate.a = opacity
	icons.modulate.a = opacity
	timebar.value = (Conductor.time / Conductor.player.stream.get_length()) * 100.0
	lerped_health = lerpf(lerped_health, game.health, 1.0 - exp(-15.0 * delta))
	healthbar.value = lerped_health
	if game.opponent_mode:
		healthbar.fill_mode = ProgressBar.FillMode.FILL_BEGIN_TO_END
	
	var percent = 1.0 - (healthbar.value / healthbar.max_value)
	if game.opponent_mode:
		percent = (healthbar.value / healthbar.max_value)
	#icons.scale = lerp(icons.scale,Vector2.ONE,1 - exp(-9.0*delta))
	for i in icons.get_children():
		i.scale = lerp(i.scale,Vector2.ONE,1 - exp(-9.0*delta)) 
	time_text.text = "%s - %s"%[time_convert(max(Conductor.time,0)),time_convert(Conductor.player.stream.get_length())]
func update_score_txt(stats:Stats):
	scoretxt.text = "Score - %d | Accuracy - %0.2f%% | Misses - %d"%[stats.score,stats.get_accuracy(),stats.misses]
func note_hit(n:Note):
	if game.opponent_mode:
		update_score_txt(game.dad_field.stats)
	else:
		update_score_txt(game.player_field.stats)
	pass


func note_miss(n:Note):
	update_score_txt(n.play_field.stats)
func beat_hit(b:int):
	for i in icons.get_children():
		i.scale = Vector2(1.2,1.2)


func _on_touch_screen_button_pressed() -> void:
	print("SUCK MY DICK WITH A SMILE FOR HOURS AT A TIME")
