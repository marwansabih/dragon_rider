class_name Vulpture

extends Sprite2D
signal took_hit(damage)

var spear_class: PackedScene

var next_goal_y = null
var next_goal_x = null
var org_modulate
var timer : Timer
var health = 400
var game_started = false
var stage = 1

func _ready() -> void:
	$VisibleOnScreenNotifier2D.screen_exited.connect(
		func(): self.queue_free()
	)
	org_modulate = modulate
	$Area2D.area_entered.connect(take_hit)
	$Timer.start()
	self.timer = $Timer
	$StartXFlight.timeout.connect(set_next_x_goal)
	$StartXFlight.wait_time = randf_range(2,3)
	$StartXFlight.start()
	
func set_next_x_goal():
	next_goal_x = randi_range(765+75, 1151-75)
	$StartXFlight.stop()

func take_hit(area: Area2D):
	if not area.is_in_group("projectile"):
		return
	var spear = area.get_parent()
	if not spear or not is_instance_valid(spear):
		return

	if spear.shooter != "dragon":
		return
	if not $AudioStreamPlayer2D.playing:
		$AudioStreamPlayer2D.play()
	modulate = Color.RED
	await get_tree().create_timer(0.2).timeout
	modulate = org_modulate
	if spear and is_instance_valid(spear):
		spear.queue_free()
	health -= 20
	took_hit.emit(20)
	if health <= 200 and stage < 2:
		stage += 1
	if health <= 0:
		queue_free()
		GlobalVariables.game_won.emit()
	


func _physics_process(delta: float) -> void:
	if not GlobalVariables.game_started:
		return
	#self.position.x -= GlobalVariables.dragon_speed
	if not next_goal_y or abs(next_goal_y - self.position.y) < 6:
		next_goal_y = randi_range(75, 648 - 75)
	var factor = sign(next_goal_y - self.position.y)
	self.position.y += factor*3
	if next_goal_x:
		factor = sign(next_goal_x - self.position.x)
		self.position.x += factor*5
	if not next_goal_x:
		return
	if abs(next_goal_x - self.position.x) < 6:
		next_goal_x = null
		$StartXFlight.wait_time = randf_range(2,3)
		$StartXFlight.start()
