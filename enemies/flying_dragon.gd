class_name FlyingDragon

extends Sprite2D

var spear_class: PackedScene

var next_goal_y = null
var next_goal_x = null
var org_modulate
var timer : Timer
var health = 20
var shooter = "bettle"

func _ready() -> void:
	$VisibleOnScreenNotifier2D.screen_exited.connect(
		func(): self.queue_free()
	)
	org_modulate = modulate
	$Area2D.area_entered.connect(take_hit)
	#$Timer.start()
	#self.timer = $Timer
	#set_next_x_goal()
	$Area2D.add_to_group("projectile")
	
func set_next_x_goal():
	next_goal_x = randi_range(300, 1151-75)

func take_hit(area: Area2D):
	GlobalVariables.beetle_hit.emit()
	if not area.is_in_group("projectile"):
		return
	var spear = area.get_parent()
	if not spear or not is_instance_valid(spear):
		return
	if not spear is Sprite2D:
		return
	if spear.shooter != "dragon":
		return
	modulate = Color.RED
	await get_tree().create_timer(0.2).timeout
	modulate = org_modulate
	if spear and is_instance_valid(spear):
		spear.queue_free()
	health -= 20
	if health <= 0:
		queue_free()
	


func _physics_process(delta: float) -> void:
	self.position.x -= (GlobalVariables.dragon_speed +10)
	if next_goal_x:
		var factor = sign(next_goal_x - self.position.x)
		self.position.x += factor * 5
	if not next_goal_x:
		return
	if abs(next_goal_x - self.position.x) < 6:
		next_goal_x = null
		#$StartXFlight.wait_time = randf_range(2,3)
		#$StartXFlight.start()
		$StartXFlight.stop()
