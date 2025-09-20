class_name ChartParser extends RefCounted

static func load_chart(song:String,diff:String):
	var ret: Chart = Chart.new()
	var legacy_path = "res://assets/songs/%s/charts/%s.json"%[song,diff]
	var cne_meta_path = "res://assets/songs/%s/charts/meta.json"%[song]
	var vslice_path = "res://assets/songs/%s/charts/%s-chart.json"%[song,song]
	var vslice_meta_path = "res://assets/songs/%s/charts/%s-metadata.json"%[song,song]

	if ResourceLoader.exists(legacy_path):
		var json = load(legacy_path).data
		if json.has("song"):
			ret = load_psych(json)
		elif json.has("codenameChart"):
			var meta_json = load(cne_meta_path).data
			var chart_json = load(legacy_path).data
			
			ret = load_cne(meta_json,chart_json,diff)

	elif ResourceLoader.exists(vslice_path):
		var meta_json = load(vslice_meta_path)
		var chart_json = load(vslice_path)
		ret = load_vslice(meta_json.data,chart_json.data,diff)

	else:
		printerr("failed to find chart")

	ret.events.sort_custom(func(a,b):
		return a.time < b.time)
	ret.notes.sort_custom(func(a,b):
		return a.time < b.time)

	return ret
static func add_event(chart:Chart,time:float,name:String,vals:Array):
	var ev:Chart.EventData = Chart.EventData.new()
	ev = Chart.EventData.new()
	ev.time = time
	ev.name = name
	ev.values.append_array(vals)
	chart.events.append(ev)
static func load_cne(meta:Dictionary,json:Dictionary,diff:String):
	var c = Chart.new()
	c.bpm = meta.bpm
	Conductor.add_change(0,c.bpm,0)
	c.scroll_speed = json.scrollSpeed
	c.stage = json.stage
	if json.has("events"):
		for i in json.events:
			var t = i.time*0.001
			var n = i.name
			var p = i.params
			if n == "Camera Movement":
				n = "camera_pan"
			add_event(c,t,n,p)
	for i in json.strumLines:
		var side:int = i.type
		match side:
			0:
				c.dad = i.characters[0]
			1:
				c.bf = i.characters[0]
			2:
				c.gf = i.characters[0]
		var note_types:Array = json.noteTypes
		for n in i.notes:
			var noteid:int = n.id
			var notetime:float = n.time * 0.001
			var noteslen:float = n.sLen * 0.001
			var notetype:String = "default"
			if n.type != 0:
				notetype = note_types[floori(n.type-1)]
			var ndata = Chart.NoteData.new()
			ndata.time = notetime
			ndata.column = noteid
			ndata.length = noteslen
			ndata.field_id = side
			c.notes.append(ndata)
	return c
static func load_vslice(meta:Dictionary,json:Dictionary,diff:String):
	var c = Chart.new()
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
			if i.v is float:
				v.append(!int(i.v) as int)
			else:
				for q in i.v.values():
					print(i.v.values().size())
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
		var note_length = i.get("l",0)*0.001
		var note_field = 0 if note_dir > 3 else 1
		var note := Chart.NoteData.new()
		note.time = note_time
		note.column = note_dir%4
		note.length = note_length
		note.field_id = note_field
		note.type = i.get("k","default")
		c.notes.append(note)
	return c
static func load_psych(data:Dictionary):
	var is_psych_1:bool = false
	var raw = data.song
	if data.has("song"):
		if data.song is String:
			is_psych_1 = true
			raw = data
	var chart = Chart.new()
	if ResourceLoader.exists("res://assets/songs/%s/charts/events.json"%[raw.song]):
		var event_json = load("res://assets/songs/%s/charts/events.json"%[raw.song]).data
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
			if n.get("mustHitSection") and !is_psych_1:
				note_direction += 4
			if note_data[2] is String:
				continue
			var note_length:float = note_data[2] / 1000.0
			var note_type:String = "default"
			if note_data.size() == 4:
				note_type = str(note_data[3])
			var note = Chart.NoteData.new()
			note.time = note_time
			note.column = note_direction%4
			note.length = note_length
			note.field_id = (note_direction / 4)%2
			if is_psych_1:
				note.field_id = 0 if note_direction > 3 else 1
			note.type = note_type
			chart.notes.append(note)
	return chart
