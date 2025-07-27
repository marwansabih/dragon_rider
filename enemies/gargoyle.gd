class_name Gargoyle

extends Sprite2D

@export var stone_class: PackedScene

class StoneCircle:
	var circle: Array = []
	var rotation_factor = 1
	var radius: int = 180
	var circle_rotating: bool = false
	var firiging_enabled: bool = false

	
var first_stone_circle = StoneCircle.new()
var second_stone_circle = StoneCircle.new()

var delta_phi = 0.5 /360 * PI * 2

var firing_threshold_angle = 0.1
var stone_generation_time = 0.2
var target_position
var max_health = 3000
var health = 3000
var game_screen: GameScreen
var player: Dragon
var stage = 1


var org_modulate: Color

signal took_hit(damage)



func _ready() -> void:
	org_modulate = modulate
	position = Vector2(0.75 * 1152.0, 324)
	$Area2D.area_entered.connect(take_hit)
	generate_stone_circle(
		first_stone_circle,
		180
	)

func generate_stone_circle(
	stone_circle: StoneCircle,
	radius: int,
	rotation_factor=1
) -> void:
	stone_circle.radius = radius
	stone_circle.rotation_factor = rotation_factor
	for i in 18:
		var angle: float = - i * PI/9 * rotation_factor
		var dir = Vector2(0,-1).rotated(angle)
		var stone_position: Vector2 = radius * dir
		await get_tree().create_timer(stone_generation_time).timeout
		var stone: Stone = stone_class.instantiate()
		stone.shooter = "gargoyle"
		stone.position = stone_position + global_position
		stone_circle.circle.append(stone)
		game_screen.add_child(stone)
	stone_circle.circle_rotating = true
	await get_tree().create_timer(0.5).timeout
	stone_circle.firiging_enabled = true

func _physics_process(delta: float) -> void:
	if first_stone_circle.circle_rotating:
		rotate_circle(first_stone_circle)
	if second_stone_circle.circle_rotating:
		rotate_circle(second_stone_circle)
	

func take_hit(area: Area2D):
	if not area.is_in_group("projectile"):
		return
	var spear = area.get_parent()

	if spear.shooter != "dragon":
		return
	#if not $AudioStreamPlayer2D.playing:
	#	$AudioStreamPlayer2D.play()
	modulate = Color.RED
	await get_tree().create_timer(0.2).timeout
	modulate = org_modulate
	if spear and is_instance_valid(spear):
		spear.queue_free()
	health -= 20
	took_hit.emit(20)
	if health <= max_health * 2/3 and stage == 1:
		delta_phi *= 3
		stone_generation_time /= 2
		stage += 1
	if health <= max_health * 1/4 and stage == 2:
		stage = 3
		generate_stone_circle(
			second_stone_circle,
			250,
			-1
		)
	if health <= 0:
		queue_free()
		GlobalVariables.game_won.emit()

func setup(game_screen: GameScreen):
	self.game_screen = game_screen
	self.player = game_screen.dragon

func rotate_circle(
	stone_circle: StoneCircle
):
	if not stone_circle.circle:
		stone_circle.circle_rotating = false
		stone_circle.firiging_enabled = false
		generate_stone_circle(
			stone_circle,
			stone_circle.radius,
			stone_circle.rotation_factor
		)
	for stone: Sprite2D in stone_circle.circle:
		var delta_pos = stone.position - global_position 
		stone.position = global_position + delta_pos.rotated(-delta_phi)
		stone.rotation -= -delta_phi
		
		
		if stone_circle.firiging_enabled:
			var dir = delta_pos.normalized()
			var angle_from_top = dir.angle_to(Vector2(-1, -1))
			if abs(angle_from_top) < firing_threshold_angle:
				fire_stone(stone, stone_circle)


func fire_stone(stone: Stone, stone_circle: StoneCircle) -> void:
	stone_circle.circle.erase(stone)
	var global_pos = stone.global_position
	var direction = (player.position - global_pos).normalized()
	stone.velocity_dir = direction
	
