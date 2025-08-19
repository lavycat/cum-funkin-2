extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func change_scene(scene:PackedScene):
	animation_player.play("trans_in")
	await animation_player.animation_finished
	get_tree().unload_current_scene()
	get_tree().change_scene_to_packed(scene)
	animation_player.play("trans_out")
