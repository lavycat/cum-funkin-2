extends Node2D
@export var list:FreePlayList
@onready var songs: Node2D = $songs
@onready var camera: Camera2D = $camera
var cur_song:String = ""
var cur_selected:int = 0

func _ready() -> void:
	for i in list.songs.size():
		var s = list.songs[i]
		var t := Label.new()
		t.text = s.name.to_upper()
		t.label_settings = LabelSettings.new()
		t.label_settings.font = preload("res://assets/fonts/bold.png")
		t.label_settings.font_size = 72
		t.position.x += (15 * i) + 90
		t.position.y += 160*0.7 * i
		songs.add_child(t)
	change_selected(0)
		
		
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_down"):
		change_selected(1)
	if event.is_action_pressed("ui_up"):
		change_selected(-1)
	if event.is_action_pressed("ui_accept"):
		cur_song = list.songs[cur_selected].name
		Game.song_name = cur_song
		Global.chart = null
		Global.chart = ChartParser.load_chart(cur_song,"hard")
		
		AudioManager.fade_out_global_music()
		get_tree().change_scene_to_file("res://scenes/game/game.scn")
func change_selected(p:int):
	AudioManager.play_sfx(AudioManager.SFX_SCROLL)
	cur_selected = wrap(cur_selected + p,0,songs.get_child_count())
	update_camera()
func update_camera():
	camera.position.y = songs.get_child(cur_selected).position.y + songs.get_child(cur_selected).size.y / 2
	pass
