class_name NoteStyle extends Resource
@export_subgroup("note")

@export var note_scale:float = 0.7
@export var note_frames:SpriteFrames = load('uid://bfqsvmhr2k32a')
@export_subgroup("sustain")
@export var sustain_width:float = 50.0
## NOTE stretch is the faster of the 2, tile requires more cpu and gpu to run as it makes more canvas items
@export_enum("stretch","tile") var rendering_method = "tile"
@export_subgroup("splash")
@export var splash_style:SplashStyle = SplashStyle.new()
