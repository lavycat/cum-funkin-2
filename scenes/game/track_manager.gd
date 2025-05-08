extends Node
var stream:AudioStreamSynchronized = AudioStreamSynchronized.new()
var player:AudioStreamPlayer
func _enter_tree() -> void:
	player = AudioStreamPlayer.new()
	add_child(player)
func load_song(song:String):
	var song_path:String = "res://assets/songs/%s"%song
	var penis_arr = ResourceLoader.list_directory(song_path + "/tracks")
	stream.stream_count = penis_arr.size()
	var cock_count:int = 0
	for i in penis_arr:
		var ethos:String = song_path + "/tracks/"
		var pathos:String = ethos + i
		var aethos:AudioStream = load(pathos)
		stream.set_sync_stream(cock_count,aethos)
		cock_count += 1
		if player:
			player.stream = stream
