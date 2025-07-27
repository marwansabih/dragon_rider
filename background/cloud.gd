extends Sprite2D

func _ready() -> void:
	$VisibleOnScreenNotifier2D.screen_exited.connect(
		func() : queue_free()
	)

func _physics_process(delta: float) -> void:
	position.x -= GlobalVariables.dragon_speed
