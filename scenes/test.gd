extends Node2D
@export var styles:Array[NoteStyle] = []
@onready var texture_rect: TextureRect = $TextureRect
var cur_style:int = 0
func get_style(i:int) -> NoteStyle:
	return styles.get(i)
func _process(delta: float) -> void:
	texture_rect.texture = get_style(cur_style).note_frames.get_frame_texture("right hold",0)
	if Input.is_action_just_pressed("ui_right"):
		cur_style += 1
	if Input.is_action_just_pressed("ui_left"):
		cur_style -= 1
	cur_style = wrap(cur_style,0,styles.size())
	var ci = texture_rect.get_canvas_item()
	RenderingServer.canvas_item_clear(ci)
	var tx_size:Vector2 = texture_rect.texture.get_size()
	
	var tx_src:Rect2 = Rect2(0,0,0,0)
	if texture_rect.texture is AtlasTexture:
		tx_size = texture_rect.texture.region.size
		tx_src = texture_rect.texture.region
		
	var its:int = texture_rect.size.y / tx_size.y
	for s in its:
		var size := tx_size
		RenderingServer.canvas_item_add_texture_rect_region(ci,Rect2(Vector2(0,tx_size.y*s),tx_size),texture_rect.texture.get_rid(),tx_src)
		pass
	
	pass
