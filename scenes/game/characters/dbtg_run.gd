extends Character
func  _process(delta: float) -> void:
	super(delta)
	$sprite.frame  = $sprite2.frame%9
