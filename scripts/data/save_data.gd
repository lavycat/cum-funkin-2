class_name SaveData extends Resource
@export var frame_rate:int = 144
@export var vsync:bool = false
@export var auto_pause:bool = false
@export var scroll_speed:float = 1.0
@export var use_chart_scroll_speed:bool = true
@export var down_scroll:bool = false
@export var song_offset:float = 0.0

@export var key_binds:Dictionary = {
	"4k_left": ["D","left"],
	"4k_down": ["F","down"],
	"4k_up": ["J","up"],
	"4k_right": ["K","right"]
}
