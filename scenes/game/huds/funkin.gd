extends Hud
@onready var icons: Node2D = $bar/icons
@onready var healthbarbg: ColorRect = $bar/healthbarbg
@onready var healthbar: ProgressBar = $bar/healthbar
var health_bar_style_bg:StyleBox
var health_bar_style_fill:StyleBox
@onready var scoretxt: Label = $bar/scoretxt
@onready var bar: Control = $bar

@onready var timebar: ProgressBar = $timebar
func reload_icons():
	var bf = icons.get_node("bf")
	var dad = icons.get_node("dad")
	bf.texture = game.bf.icon
	dad.texture = game.dad.icon
	health_bar_style_bg.bg_color = game.dad.icon_color
	health_bar_style_fill.bg_color = game.bf.icon_color
	

func _ready() -> void:
	
	health_bar_style_bg = healthbar.get_theme_stylebox("background")
	health_bar_style_fill = healthbar.get_theme_stylebox("fill")
	health_bar_style_bg.bg_color = Color.WHITE
	reload_icons()
	bar.position.y = 100 if Save.data.down_scroll else 620
func _process(delta: float) -> void:
	timebar.value = (Conductor.time / Conductor.player.stream.get_length()) * 100.0
	healthbar.value = lerp(healthbar.value,game.health,delta*19.0)
	var percent = 1.0 - (healthbar.value / healthbar.max_value)
	icons.position.x = percent * 601
	icons.scale = lerp(icons.scale,Vector2.ONE,delta*9.0)
func update_score_txt():
	scoretxt.text = "Score - %d | Accuracy - %0.2f%% | Misses - %d"%[game.score,game.accuracy,game.misses]
func note_hit(n:Note):
	if n.play_field.id == 1:
		update_score_txt()
		
		
func note_miss(n:Note):
	if n.play_field.id == 1:
		print(n.play_field.id)
	update_score_txt()
func beat_hit(b:int):
	icons.scale = Vector2(1.2,1.2)
