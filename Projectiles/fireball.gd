class_name Fireball

extends Sprite2D

var shooter : String
var active: bool = false
var fireball_direction: Vector2

func _ready() -> void:
	$VisibleOnScreenNotifier2D.screen_exited.connect(
		func(): queue_free()
	)
	$Area2D.add_to_group("projectile")

func _physics_process(delta: float) -> void:
	if active:
		position += 10 * fireball_direction
