@tool
class_name PackerAtlas extends AnimatedSprite2D
@export var tex:Texture2D = null
@export_tool_button("Parse","Reload") var parse_burtton = parse_packer
func parse_packer():
	var txt = tex.resource_path.replace(tex.resource_path.get_extension(),"txt")
	var text = FileAccess.get_file_as_string(txt)
	var frames:SpriteFrames = SpriteFrames.new()
	frames.remove_animation("default")
	for line in text.split("\n"):
		if line.is_empty():
			continue
		var split = line.split("=")
		var frame:int = 0
		var frame_name:String = split[0]
		frame_name = frame_name.strip_edges()
		frame_name = frame_name.substr(0,frame_name.find("_"))
		var rect_str:PackedStringArray = split[1].split(" ")
		print(rect_str)
		var frame_rect:Rect2i = Rect2i(rect_str[1].to_int(),rect_str[2].to_int(),rect_str[3].to_int(),rect_str[4].to_int())
		## real shit
		var atlas:AtlasTexture = AtlasTexture.new()
		atlas.atlas = tex
		atlas.region = frame_rect
		if not frames.has_animation(frame_name):
			frames.add_animation(frame_name)
			frames.set_animation_speed(frame_name,24)
		frames.add_frame(frame_name,atlas)
	ResourceSaver.save(frames,txt.get_basename() + ".res")
	sprite_frames = frames
	
