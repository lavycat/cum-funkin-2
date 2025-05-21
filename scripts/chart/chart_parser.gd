class_name ChartParser extends RefCounted
static var fall_back = {
	"dad": "null",
	"bf": "null",
	"gf": "null",
	"bpm": 100,
	"bpm_changes": [],
	"scroll_speed": 1.0,
	"stage": "null",
	"notes":[],
	"events":[]
}

static func load_chart(song:String,diff:String):
	var ret = {}
	var legacy_path = "res://assets/songs/%s/charts/%s.json"%[song,diff]
	var vslice_path = "res://assets/songs/%s/charts/%s-chart.json"%[song,song]
	var vslice_meta_path = "res://assets/songs/%s/charts/%s-metadata.json"%[song,song]
	
	print(vslice_path)
	if ResourceLoader.exists(legacy_path):
		var json = load(legacy_path).data
	
		if json.has("song"):
			ret = load_psych(json)
	
	elif ResourceLoader.exists(vslice_path):
		var meta_json = load(vslice_meta_path)
		var chart_json = load(vslice_path)
		ret = load_vslice(meta_json.data,chart_json.data,diff)
		
	else:
		print("failed to find chart")
		return fall_back
		
	
	return ret
static func add_event(chart:Dictionary,time:float,name:String,vals:Array):
	var ev = {"name":name,"time":time,"values":vals}
	chart.events.append(ev)
static func load_vslice(meta:Dictionary,json:Dictionary,diff:String):
	var c = fall_back.duplicate()
	## META PARSE
	var playdata = meta.playData
	c.dad = playdata.characters.opponent
	c.bf = playdata.characters.player
	c.gf = playdata.characters.girlfriend
	c.stage = playdata.stage
	for i in meta.timeChanges:
		Conductor.add_change(i.t,i.bpm,i.get("b",0)*4.0)
	## CHART PARSE
	
	## EVENTS
	for i in json.events:
		var n:String
		var v:Array = []
		if i.e == "FocusCamera":
			n = "camera_pan"
			for q in i.v.values():
				q = int(!q)
				v.append(q)
		else:
			v = i.get("v",{}).values()
			n = i.e.to_snake_case()
		add_event(c,i.t/1000.0,n,v)
	var notes = json.notes.get(diff)
	var scrollspeed = json.scrollSpeed.get(diff)
	c.scroll_speed = scrollspeed
	for i in notes:
		var note_time = i.t/1000.0
		var note_dir = int(i.d)
		var note_length = i.l/1000.0
		var note_field = 0 if note_dir > 3 else 1
		var note = {
			"time": note_time,
			"column": note_dir%4,
			"length": note_length,
			"field_id": note_field,
			"type": i.get("k","default")
		}
		c.notes.append(note)
	return c
	pass
static func load_psych(data:Dictionary):
	var raw = data.song
	var chart = fall_back.duplicate()
	if ResourceLoader.exists("res://assets/songs/%s/charts/events.json"%[raw.song]):
		var event_json = load("res://assets/songs/%s/charts/events.json"%[raw.song]).data
		print(event_json)
	if raw.get("events",{}):
		var evs_arr = raw.events
		for i in evs_arr:
			var ev_time:float = i[0]
			for ev in i[1]:
				var ev_name = ev[0]
				var ev_v1 = ev[1]
				var ev_v2 = ev[2]
				add_event(chart,ev_time / 1000.0,ev_name,[ev_v1,ev_v2])
				
		
	var speed = raw.get("speed")
	chart.scroll_speed = speed
	
	chart.dad = raw.get("player2","dad")
	chart.bf = raw.get("player1","bf")
	chart.gf = raw.get("gfVersion","gf")
	chart.stage = raw.get("stage","stage")
	chart.bpm = raw.get("bpm")
	print(chart)
	
	
	var section_time:float = 0
	var section_bpm:float = chart.bpm
	var bpm_steps:int = 0
	var bpm_time:float = 0
	Conductor.add_change(bpm_time,section_bpm,bpm_steps)
	
	for n in raw.notes:
		
		var is_bpm_change = n.get("changeBPM")
		if is_bpm_change:
			section_bpm = n.bpm
			Conductor.add_change(bpm_time,section_bpm,bpm_steps)
		var must_hit_section = n.get("mustHitSection",false)
		add_event(chart,bpm_time,"camera_pan",[int(must_hit_section)])
		
		bpm_time += 60.0/section_bpm * 4.0
		bpm_steps += 16
			
		
		var section_notes = n.get("sectionNotes")
		for note_data in section_notes:
			var note_time:float = note_data[0] /  1000
			var note_direction:int = note_data[1]
			if note_direction == -1:
				add_event(chart,note_time,note_data[2],[note_data[3],note_data[4]])
				continue
			if n.get("mustHitSection"):
				note_direction += 4
			if note_data[2] is String:
				continue
			var note_length:float = note_data[2] / 1000.0
			var note_type:String = "default"
			if note_data.size() == 4:
				note_type = str(note_data[3])
			var note = {
				"time": note_time,
				"column": note_direction%4,
				"length": note_length,
				"field_id": (note_direction / 4)%2,
				"type": note_type
			}
			chart.notes.append(note)
	chart.events.sort_custom(func(a,b):
		return a.time <  b.time)
	chart.notes.sort_custom(func(a,b):
		return a.time <  b.time)
	return chart
