class_name Dragon
extends Sprite2D

var health = 1000
var org_modulate: Color
var up_dash_active = false
var down_dash_active = false
var dash_distance = 0
var game_started = false

func _ready() -> void:
	$Area2D.area_entered.connect(take_hit)
	org_modulate = modulate
	$HealthBar.max_value = health
	$HealthBar.value = health

func take_hit(area_entered):
	if not $AudioStreamPlayer2D.playing:
		$AudioStreamPlayer2D.play()
	var spear = area_entered.get_parent()
	if not spear and not is_instance_valid(spear):
		return
	if spear.shooter == "dragon":
		return
	modulate = Color.RED
	await get_tree().create_timer(0.2).timeout
	modulate = org_modulate
	health -= 50
	$HealthBar.value = health
	if health <= 0:
		queue_free()
		GlobalVariables.game_lost.emit()
	if not spear and not is_instance_valid(spear):
		return
	spear.queue_free()

func activate_dash():
	if position.y <= 324:
		down_dash_active = true
	if position.y > 324:
		up_dash_active = true
	dash_distance = 240

func _physics_process(delta: float) -> void:
	if not GlobalVariables.game_started:
		return
	"""
	if dash_distance == 0:
		down_dash_active = false
		up_dash_active = false
	if down_dash_active:
		position.y += 60
		position.y = min(648-100, position.y)
		dash_distance -= 60
		return
	if up_dash_active:
		position.y -= 60
		position.y = max(100, position.y)
		dash_distance -= 60
		return
	"""
	if Input.is_key_pressed(KEY_W) and position.y > 64:
		position.y -= 15
	if Input.is_key_pressed(KEY_S) and position.y < 584:
		position.y += 15
	if Input.is_key_pressed(KEY_D) and position.x < 576 - 100:
		#GlobalVariables.dragon_speed += 0.5
		position.x += 15
	if Input.is_key_pressed(KEY_A) and position.x > 100:
		#GlobalVariables.dragon_speed -= 0.5
		position.x -= 15
