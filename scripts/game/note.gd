class_name Note extends FunkinScript
var type:String
var column:int
var time:float
var length:float

var direction:String


const directions:Array = [
	"left",
	"down",
	"up",
	"right"
]
## TODO restructure for a note style system
var style:NoteStyle = NoteStyle.new()
var play_field:PlayField
var note_field:NoteField
var clipper:ColorRect
var sustain:Sustain
var hold_timer:float = 0.0
var hit_range = 0.180

var was_hit:bool = false
var missed:bool = false
var sprite:AnimatedSprite2D
## returns the name of the notestyle for the note script defaults to empty string
static func get_style(note:Note) -> NoteStyle:
	return note.play_field.note_style
func _enter_tree() -> void:
	connect_notes = false
	super()
	direction = directions[column]
	sprite = AnimatedSprite2D.new()
	sprite.sprite_frames = style.note_frames
	sustain = Sustain.new()
	sustain.length = length
	sustain.note = self
	clipper = ColorRect.new()
	clipper.size.y = 1440
	clipper.size.x = 50
	clipper.position.x -= 25
	clipper.clip_children = CanvasItem.CLIP_CHILDREN_ONLY
	clipper.clip_contents = true
	add_child(clipper)
	clipper.add_child(sustain)
	clipper.scale.y = -1.0 if note_field.down_scroll else 1.0
	add_child(sprite)
	
func play_anim(anim:String = ""):
	sprite.play("%s %s"%[direction,anim])
func note_hit(note:Note):
	pass

func _process(delta: float) -> void:
	if sustain and was_hit:
		clipper.position.y = -position.y
		sustain.length = (time + length) - Conductor.time
		if not play_field.pressed[column]:
			sustain.released_timer += delta
		if play_field.pressed[column] or play_field.auto_play:
			sustain.released_timer = 0

	if missed:
		return
