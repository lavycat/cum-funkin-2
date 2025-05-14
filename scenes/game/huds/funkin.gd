extends Hud

@onready var timebar: ProgressBar = $timebar
@onready var healthbar: ProgressBar = $healthbar

func _process(delta: float) -> void:
	timebar.value = (Conductor.time / Conductor.player.stream.get_length()) * 100.0
	healthbar.value = game.health
