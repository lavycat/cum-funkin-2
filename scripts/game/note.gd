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

var sustain:Sustain
var hold_timer:float = 0.0
var hit_range = 0.180

var was_hit:bool = false
var missed:bool = false
var sprite:AnimatedSprite2D
## returns the name of the notestyle for the note script defaults to empty string 
static func get_style():
	return "funkin"
static func load_style():
	load("res://assets/images/game/notestyles/%s.tres"%get_style())
func _enter_tree() -> void:
	direction = directions[column]
	sprite = AnimatedSprite2D.new()
	style = NoteStyle.new()
	sprite.sprite_frames = style.note_frames
	sustain = Sustain.new()
	sustain.length = length
	sustain.note = self
	add_child(sprite)
	add_child(sustain,false,Node.INTERNAL_MODE_FRONT)
func play_anim(anim:String = ""):
	sprite.play("%s %s"%[direction,anim])
func note_hit(note:Note):
	pass
		
func _process(delta: float) -> void:
	if sustain:
		if was_hit:
			sustain.length = (time + length) - Conductor.time
			if not play_field.pressed[column]:
				sustain.released_timer += delta
			if play_field.pressed[column]:
				sustain.released_timer = 0

			if sustain.released_timer > Conductor.step_length*2:
				missed = true
	if Conductor.time - (time) > hit_range * Conductor.rate and not was_hit:
		missed = true
		play_field.note_miss.emit(self)
	if Conductor.time - 0.5 > time + length:
		queue_free()
