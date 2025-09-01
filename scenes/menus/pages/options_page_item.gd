extends Node2D
@onready var controls_text: Label = $"../../controls_text"

@export_enum("check_box","enum","range","input") var option_type:String = "range"
@export var option:String = ""
@onready var label:Label = $"text"
@export var enum_values:Array[String] = []
@export var range_max:float = 1
@export var range_min:float = 0
@export var range_step:float = 0.1
@export var input_action:StringName = ""
var bool_value:bool = false
var range_value:float = 0
var enum_value:String = ""
var page:Node
var input_waiting:bool = false
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
				enum_value = str(real_val.to_int())
			else:
				for e in enum_values:
					if e == real_val:
						var index = enum_values.find(e)
						enum_value = enum_values[index]
						break
				enum_value = real_val
					
			update()
		"range":
			if Save.json.get(option) != null:
				var real_val:float = clamp(snapped(Save.json.get(option),range_step),range_min,range_max)
				range_value = real_val
			update()
		"input":
			if OS.has_feature("mobile") and is_instance_valid(controls_text):
				controls_text.queue_free()
				queue_free()
			if not input_action.is_empty():
				var k = Save.json.key_binds.get_or_add(input_action)
				label.text = '%s [%s]'%[input_action,k[0]]
			
			pass
			
			
func change_value(i:int = 0):
	match option_type:
		"check_box":
			bool_value = !bool_value
			Save.json.set(option,bool_value)
			update()
			Save.update_data()
			Save.save_data()
			
		"enum":
			enum_value = enum_values[wrap(enum_values.find(enum_value) + i,0,enum_values.size())]
			var t = typeof(Save.json.get(option))
			Save.json.set(option,type_convert(enum_value,t))
			
			update()
			Save.update_data()
			Save.save_data()
		"range":
			range_value = clamp(snapped(range_value + range_step*i,range_step),range_min,range_max)
			var t = typeof(Save.json.get(option))
			Save.json.set(option,type_convert(range_value,t))
			Save.save_data()
			
			update()
			Save.update_data()
		"input":
			input_waiting = true
			page.set_process_input(false)
			label.text = "%s [?]"%input_action
			
			
			
			

			
		
	
func update():
	match option_type:
			"check_box":
				if bool_value:
					check_box_spr.play("checkbox anim")
				else:
					check_box_spr.play("checkbox anim reverse")
			"enum":
				label.text = "%s <%s>"%[name,enum_value]
			"range":
				label.text = "%s <%s>"%[name,range_value]
			"input":
				var k = Save.json.key_binds.get_or_add(input_action)
				label.text = '%s [%s]'%[input_action,k[0]]
				
	
	pass
var controler_mode:bool = true
func _process(delta: float) -> void:
	pass
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and not event.is_echo() and input_waiting:
		event = event as InputEventKey
		var d = Save.json.key_binds.get(input_action)
		d[0] = OS.get_keycode_string(event.key_label)
		Save.json.key_binds.set(input_action,d)
		update()
		Save.save_data()
		Save.update_data()
		input_waiting = false
		page.set_process_input(true)
		
