extends Node2D
@export_enum("check_box","enum","range") var option_type:String = "range"
@export var option:String = ""
@onready var label:Label = $"text"
@export var enum_values:Array[String] = []
@export var range_max:float = 1
@export var range_min:float = 0
@export var range_step:float = 0.1
var bool_value:bool = false
var range_value:float = 0
var enum_value:String = ""


# INFO - possible null sprite for check box option
var check_box_spr:AnimatedSprite2D
func _ready() -> void:
	match option_type:
		"check_box":
			if not option.is_empty():
				bool_value = Save.json.get(option)
			check_box_spr = get_node("check_box")
			label.text = name
			await RenderingServer.frame_post_draw
			check_box_spr.position.x = label.size.x + 96
			update()
		"enum":
			var real_val:String = str(Save.json.get(option))
			if real_val.is_valid_float() or real_val.is_valid_int():
				for e in enum_values:
					if real_val.to_int() == e.to_int():
						enum_value = e
						break
			else:
				for e in enum_values:
					if e == real_val:
						var index = enum_values.find(e)
						enum_value = enum_values[index]
			update()
			pass
			
			
func change_value(i:int = 0):
	match option_type:
		"check_box":
			bool_value = !bool_value
			Save.json.set(option,bool_value)
			update()
			Save.update_data()
		"enum":
			enum_value = enum_values[wrap(enum_values.find(enum_value) + i,0,enum_values.size())]
			var t = typeof(Save.json.get(option))
			Save.json.set(option,type_convert(enum_value,t))
			update()
			Save.update_data()
			
			
			

			
		
	
func update():
	match option_type:
			"check_box":
				if bool_value:
					check_box_spr.play("checkbox anim")
				else:
					check_box_spr.play("checkbox anim reverse")
			"enum":
				label.text = "%s <%s>"%[name,enum_value]
				
	
	pass
func _process(delta: float) -> void:
	pass
