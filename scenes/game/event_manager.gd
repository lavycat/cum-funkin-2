extends Node
var cur_event:int = 0
signal event_trigger(ev:Event)
func _process(delta: float) -> void:
	# inside of process
	var events = get_children()
	if events.is_empty():
		return
	while cur_event < events.size() and events[cur_event].event_time <= Conductor.time:
		events[cur_event].trigger()
		event_trigger.emit(events[cur_event])
		cur_event += 1
