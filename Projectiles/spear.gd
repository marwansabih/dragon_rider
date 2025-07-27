class_name  Spear

extends RigidBody2D

var shooter : String

func _ready() -> void:
	$Area2D.add_to_group("projectile")
	$VisibleOnScreenEnabler2D.screen_exited.connect(
		func(): queue_free()
	)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var v := state.linear_velocity
	if v.length_squared() > 0.01:               # avoid NaNs when it stops
		rotation = v.angle()
