extends Node
var cur_event:int = 0
signal event_trigger(ev:Event)
func _process(delta: float) -> void:
	# inside of process
	var events = get_children()
	if events.is_empty():
		return
	for ev in events:
		if ev.event_time <= Conductor.time:
			ev.trigger()
			event_trigger.emit(ev)
			ev.free()
		else:
			break
