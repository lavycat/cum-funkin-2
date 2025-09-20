@tool
class_name SparrowAtlas extends AnimatedSprite2D
var xml:String:
	get:
		return tex.resource_path.get_basename() + ".xml"
@export var tex:Texture2D = null
@export_range(1,120) var fps:int = 24
@export var loop:bool = false
@export_tool_button("Parse", "Reload") var parse: Callable = parse_button
func parse_xml():
	var parser := XMLParser.new()
	parser.open(xml)
	sprite_frames = SpriteFrames.new()
	sprite_frames.remove_animation("default")
	while parser.read() == OK:
		var node_type = parser.get_node_type()
		if node_type == XMLParser.NODE_ELEMENT:
			var node_name = parser.get_node_name()
			if node_name == "SubTexture":
				var w:int = parser.get_named_attribute_value_safe("width").to_int()
				var h:int = parser.get_named_attribute_value_safe("height").to_int()
				var x:int = parser.get_named_attribute_value_safe("x").to_int()
				var y:int = parser.get_named_attribute_value_safe("y").to_int()
				var name:String = parser.get_named_attribute_value("name").left(-4)
				var is_rotated:bool = parser.get_named_attribute_value_safe("rotated") == "true"
				var frame:int = parser.get_named_attribute_value("name").substr(name.length()).to_int()
				## add them frames
				var atlas_tex := AtlasTexture.new()
				atlas_tex.atlas = tex
				
				atlas_tex.region = Rect2(x,y,w,h)
				
				var has_offsets = parser.has_attribute("frameX") or parser.has_attribute("frameY") or\
				parser.has_attribute("frameWidth") or parser.has_attribute("frameHeight")
				var offsets := Rect2(parser.get_named_attribute_value_safe("frameX").to_int(),\
				parser.get_named_attribute_value_safe("frameY").to_int(),\
				parser.get_named_attribute_value_safe("frameWidth").to_int(),\
				parser.get_named_attribute_value_safe("frameHeight").to_int())
				if has_offsets:
						atlas_tex.margin = Rect2(-offsets.position,offsets.size - atlas_tex.region.size)
						
						
				if not sprite_frames.has_animation(name):
					sprite_frames.add_animation(name)
					sprite_frames.set_animation_loop(name,loop)
					sprite_frames.set_animation_speed(name,fps)
				sprite_frames.add_frame(name,atlas_tex,1.0,frame)

func parse_button() -> void:
	parse_xml()
	ResourceSaver.save(sprite_frames, tex.resource_path.get_basename() + ".res")
