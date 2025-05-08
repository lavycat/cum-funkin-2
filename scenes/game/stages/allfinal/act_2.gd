extends Node2D
var game:Game = null
@onready var boyfrie: Character = $boyfrie
@onready var dad: Character = $dad

func _ready() -> void:
	game = Game.instance
	game.bf.queue_free()
	game.gf.queue_free()
	game.bf = boyfrie
	game.dad.queue_free()
	game.dad = dad
	game.play_field.dad_strum.chars = [dad]
	game.play_field.player_strum.chars = [boyfrie]
	
