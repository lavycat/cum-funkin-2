extends Node
class_name EventManager


var index: int = 0
var event_data: Array[Chart.EventData] = []

signal event_trigger(ev: Event, time: float, values: Array)

func _process(delta: float) -> void:
	var events: Array = get_children()
	if events.is_empty():
		return

	while (index < event_data.size()) and event_data[index].time <= Conductor.time:
		var event_data: Chart.EventData = event_data[index]
		var found: bool = false
		for ev: Event in events:
			if ev.name == event_data.name:
				ev.trigger(event_data.time, event_data.values)
				event_trigger.emit(ev, event_data.time, event_data.values)
				found = true
				break
		if not found:
			var ev: Event = Event.new()
			if event_data.name.is_empty():
				ev.name = "__BLANK_EVENT_NAME__"
			else:
				ev.name = event_data.name
			add_child(ev)
			ev.trigger(event_data.time, event_data.values)
			event_trigger.emit(ev, event_data.time, event_data.values)

		index += 1
