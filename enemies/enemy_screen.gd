class_name EnemyScreen
extends Node2D

@export var flying_vulpture_class : PackedScene
@export var flying_dragon_class: PackedScene
@export var gargoyle_class: PackedScene
@export var spear_class: PackedScene

var game_screen: GameScreen

func setup(game_screen: GameScreen):
	self.game_screen = game_screen
	#create_enemy("vulpture")
	create_enemy("gargoyle")
	"""
	$Timer.timeout.connect(
		create_enemy.bind("vulpture")
	)
	$Timer.start()
	$TimerFlyingDragon.timeout.connect(
		create_enemy.bind("flying_dragon")
	)
	$TimerFlyingDragon.start()
	"""
	
func create_enemy(
	name: String
) -> void:
	if name == "vulpture":
		var vultpure: Vulpture = flying_vulpture_class.instantiate()
		var x = 864
		var y = 324
		vultpure.position = Vector2(x,y)
		game_screen.add_child(vultpure)
		#vultpure.timer.timeout.connect(fire_spear.bind(vultpure))
		vultpure.timer.timeout.connect(attack_behaviour.bind(vultpure))
		vultpure.timer.start()
		$Healthbar.max_value = vultpure.health
		$Healthbar.value = vultpure.health
		vultpure.took_hit.connect(
			update_enemy_bar
		)
		#$Timer.wait_time = randf_range(15,20)
		#$Timer.start()
	if name == "gargoyle":
		var gargoyle: Gargoyle = gargoyle_class.instantiate()
		game_screen.add_child(gargoyle)
		gargoyle.setup(game_screen)
		$Healthbar.max_value = gargoyle.health
		$Healthbar.value = gargoyle.health
		gargoyle.took_hit.connect(
			update_enemy_bar
		)
		
		
	if name == "flying_dragon":
		var flying_dragon: FlyingDragon = flying_dragon_class.instantiate()
		var x = 1151 - 75
		var y = randi_range(75, 648 - 75)
		flying_dragon.position = Vector2(x,y)
		game_screen.add_child(flying_dragon)
		
func update_enemy_bar(damage):
	$Healthbar.value -= damage
	print($Healthbar.value)

func attack_behaviour(vulpture: Vulpture):
	if vulpture.stage == 1:
		fire_spear(vulpture)
	if vulpture.stage == 2:
		fire_tripple_spear(vulpture)
	
	
func fire_spear(vulpture: Sprite2D):
	if not GlobalVariables.game_started:
		return
	
	if not $AudioStreamPlayer2D.playing:
		$AudioStreamPlayer2D.play()
	var spear: RigidBody2D = spear_class.instantiate()
	spear.mass = 1
	spear.shooter = "vulpture"
	add_child(spear)
	spear.position = vulpture.position + Vector2(-25,-50)
	var x = vulpture.position.x
	var direction: Vector2 = get_direction(vulpture)

	spear.rotation = direction.angle()
	spear.apply_central_impulse(direction)

func fire_tripple_spear(vulpture: Sprite2D):
	if not GlobalVariables.game_started:
		return
	
	if not $AudioStreamPlayer2D.playing:
		$AudioStreamPlayer2D.play()
	var direction: Vector2 = get_direction(vulpture)
	var direction_up = direction.rotated(PI/8)
	var direction_down = direction.rotated(-PI/8)
	for dir in [direction, direction_down, direction_up]:
		var spear: RigidBody2D = spear_class.instantiate()
		spear.mass = 1
		spear.shooter = "vulpture" 
		add_child(spear)
		spear.position = vulpture.position + Vector2(-25,-50)
		var x = vulpture.position.x

		spear.rotation = dir.angle()
		spear.apply_central_impulse(dir)
		#await get_tree().create_timer(0.1).timeout

func get_direction(vulpture) -> Vector2:
	if not game_screen.dragon:
		return Vector2(-500, -500)

	var start_pos = vulpture.position + Vector2(-25, -50)
	var target_pos = game_screen.dragon.position

	var g = ProjectSettings.get_setting("physics/2d/default_gravity")

	var dx = target_pos.x - start_pos.x
	var dy = -target_pos.y + start_pos.y  # correct direction (taking into account that dy starts from top)
	var vx = -1000.0  # leftward horizontal speed
	var t = abs(dx / vx)  # time to reach target at this vx

	var vy = (dy + 0.5 * g * t * t) / t  # vertical speed with gravity
	
	var predicted = start_pos + Vector2(vx, vy) * t - Vector2(0, 0.5 * g * t * t)

	return Vector2(vx, -vy)
	
