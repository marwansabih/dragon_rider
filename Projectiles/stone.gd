class_name Stone

extends Sprite2D

var velocity_magnitud: int = 20
var velocity_dir: Vector2
var shooter: String

func _ready() -> void:
	$Area2D.add_to_group("projectile")
	$VisibleOnScreenNotifier2D.screen_exited.connect(
		func(): queue_free()
	)

func _physics_process(delta: float) -> void:
	if velocity_dir:
		var delta_pos = velocity_dir * velocity_magnitud
		position += delta_pos
