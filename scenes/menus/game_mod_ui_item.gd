extends Node2D
@onready var text: Label = $text
@export var game_mod:StringName = ""
@export_enum("range","enum","bool") var mod_type:String = "range"
@export var range_step:float = 0.1
@export var range_min:float = 0.1
@export var range_max:float = 0.1
var bool_value = false

var range_value:float = 0
var check:AnimatedSprite2D = null
func _ready() -> void:
	match mod_type:
		"range":
			range_value = Global.game_modifiers.get(game_mod)
		"bool":
			check = get_node("check")
			bool_value = Global.game_modifiers.get(game_mod)
			if bool_value:
				check.play("checkbox anim")
			else:
				check.play("checkbox anim reverse")
func _physics_process(delta: float) -> void:
	match mod_type:
		"range":
			text.text = "%s < %s >"%[name,range_value]
		"bool":
			text.text = "%s"%name
			check.position.x = text.size.x + 64
func change_mod(i:int):
	match mod_type:
		"range":
			range_value += i * range_step
			range_value = clamp(range_value,range_min,range_max)
			range_value = snappedf(range_value,range_step)
			Global.game_modifiers.set(game_mod,range_value)
		"bool":
			bool_value = !bool_value
			Global.game_modifiers.set(game_mod,bool_value)
			if bool_value:
				check.play("checkbox anim")
			else:
				check.play("checkbox anim reverse")
	pass
