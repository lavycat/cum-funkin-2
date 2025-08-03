extends Stage


@onready var start: ColorRect = %start
@onready var intro: VideoStreamPlayer = %intro
@onready var flash: ColorRect = %flash


func _ready() -> void:
	super()

	await RenderingServer.frame_post_draw
	Conductor.time = 0.0
	intro.play()


func _on_intro_finished() -> void:
	flash.color.a = 1.0
	var tween := create_tween()
	tween.tween_property(flash, ^"color:a", 0.0, 0.8)

	start.queue_free()
	intro.queue_free()


func event_triggered(event: Event, time: float, values: Array) -> void:
	match event.name:
		"__BLANK_EVENT_NAME__":
			process_blank_event(event, time, values)


func process_blank_event(event: Event, time: float, values: Array) -> void:
	match values[0]:
		"UC-introFlash":
			_on_intro_finished()
