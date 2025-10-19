extends Node2D


@onready var game: Node2D = $CanvasLayer/game
@onready var menu: Node2D = $CanvasLayer/menu
var controls_shown:int = CONTROLS_SHOWN_MENU

enum {
	CONTROLS_SHOWN_NONE,
	CONTROLS_SHOWN_GAME,
	CONTROLS_SHOWN_MENU,
}
func _physics_process(_delta: float) -> void:
	match  controls_shown:
		CONTROLS_SHOWN_NONE:
			game.visible = false
			menu.visible = false
		CONTROLS_SHOWN_GAME:
			menu.visible = false
			game.visible = true
		CONTROLS_SHOWN_MENU:
			menu.visible = true
			game.visible = false
	
