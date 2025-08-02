extends Node
class_name EventManager


var index: int = 0
var event_data: Array[Chart.EventData] = []

signal event_trigger(ev:Event)


func _process(delta: float) -> void:
	var events: Array = get_children()
	if events.is_empty():
		return

	while (index < event_data.size() - 1) and event_data[index].time <= Conductor.time:
		var event_data: Chart.EventData = event_data[index]
		for ev: Event in events:
			if ev.name == event_data.name:
				ev.trigger(event_data.time, event_data.values)
				event_trigger.emit(ev)
		index += 1
