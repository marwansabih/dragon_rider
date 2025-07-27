class_name Gargoyle

extends Sprite2D

@export var stone_class: PackedScene

var first_stone_circle = []
var first_stone_circle_rotating = false
var delta_phi = 0.5 /360 * PI * 2
var firing_enabled = false
var fired_stones = []
var firing_threshold_angle = 0.1
var target_position

func _ready() -> void:
	generate_stone_circle()


func generate_stone_circle() -> void:
	for i in 18:
		var angle: float = - i * PI/9
		var dir = Vector2(0,-1).rotated(angle)
		var stone_position: Vector2 = 180 * dir
		await get_tree().create_timer(0.2).timeout
		var stone: Sprite2D = stone_class.instantiate()
		stone.position = stone_position
		first_stone_circle.append(stone)
		add_child(stone)
	first_stone_circle_rotating = true
	await get_tree().create_timer(0.5).timeout
	start_shooting(Vector2(100,100))

func _physics_process(delta: float) -> void:
	if first_stone_circle_rotating:
		rotate_circle()

func rotate_circle():
	for stone: Sprite2D in first_stone_circle:
		var dir = stone.position.normalized()
		stone.position = stone.position.rotated(-delta_phi)
		
		if firing_enabled and not fired_stones.has(stone):
			var angle_from_top = dir.angle_to(Vector2(-1, 0))
			if abs(angle_from_top) < firing_threshold_angle:
				fire_stone(stone)

func start_shooting(target: Vector2) -> void:
	target_position = target
	firing_enabled = true

func fire_stone(stone: Sprite2D) -> void:
	fired_stones.append(stone)
	first_stone_circle.erase(stone)

	var global_pos = stone.global_position
	var direction = (target_position - global_pos).normalized()
	var speed = 300.0
	var distance = global_pos.distance_to(target_position)
	var duration = distance / speed

	var tween = create_tween()
	tween.tween_property(stone, "global_position", target_position, duration)
	tween.tween_callback(stone.queue_free)
