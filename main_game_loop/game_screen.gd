class_name GameScreen

extends Node2D

@export var enemy_screen_class: PackedScene
@export var spear_class: PackedScene
@export var fireball_class: PackedScene

var dragon : Dragon

var seconds_left :int = 3
var fireball : Fireball


func _ready() -> void:
	var enemy_screen: EnemyScreen = enemy_screen_class.instantiate()
	add_child(enemy_screen)
	enemy_screen.setup(self)
	dragon = $Dragon
	update_time_left()
	$SpearTimer.start()
	#$SpearTimer.timeout.connect(fire_spear)
	$GlobalTimer.start()
	$GlobalTimer.timeout.connect(update_time_left)
	shoot_fireball()
	$AudioStreamPlayer2D.play()
	
func update_time_left():
	$TimeLeft.text = "Time to start: " + str(seconds_left)
	if seconds_left == 0:
		GlobalVariables.game_started = true
		$TimeLeft.hide()
	seconds_left -= 1

func _input(event: InputEvent) -> void:
	if not GlobalVariables.game_started:
		return
	
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if fireball.scale.x < 1.5:
				return
			var fireball_pos = dragon.position + Vector2(100,10)
			fireball.fireball_direction = (get_global_mouse_position() - fireball_pos).normalized()
			fireball.active = true
			fireball = null
			shoot_fireball()

func _physics_process(delta: float) -> void:
	if not GlobalVariables.game_started:
		return
	if fireball:
		fireball.position = dragon.position + Vector2(100,10)
		var fireball_pos = dragon.position + Vector2(100,10)
		var dir = (get_global_mouse_position() - fireball_pos).normalized()
		fireball.rotation = dir.angle()
		if fireball.scale.x > 1.5:
			#if not $AudioStreamPlayer2D2.playing:
			#$AudioStreamPlayer2D2.play()
			#fireball.fireball_direction = (get_global_mouse_position() - fireball_pos).normalized()
			#fireball.active = true
			#fireball = null
			#shoot_fireball()
			return
		fireball.scale += Vector2(0.07, 0.07)

func fire_spear():
	var spear: RigidBody2D = spear_class.instantiate()
	if not spear:
		return
	spear.shooter = "dragon"
	add_child(spear)
	spear.position = $Dragon.position + Vector2(25,-50)
	var direction: Vector2 = (get_global_mouse_position() - spear.position).normalized()
	spear.rotation = direction.angle()
	var total_impulse = 1060
	spear.apply_central_impulse(total_impulse*direction)
	
func shoot_fireball():
	self.fireball = fireball_class.instantiate()
	add_child(fireball)
	fireball.position = dragon.position + Vector2(100,10)
	fireball.shooter = "dragon"
	fireball.scale = Vector2(0.2, 0.2)
