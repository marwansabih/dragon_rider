extends Node2D

@export var cloud_class : PackedScene

var clouds = []

func _ready() -> void:
	place_random_clouds()


func place_random_clouds() -> void:
	for i in 10:
		var x = i * 100 
		place_random_cloud(x)
	$Timer.timeout.connect(create_cloud)
	$Timer.start()

func place_random_cloud(x: int) -> void:
	var y = randi_range(100, 548)
	var cloud: Sprite2D = cloud_class.instantiate()
	cloud.position = Vector2(x,y)
	add_child(cloud)

func create_cloud() -> void:
	var scale = 5.0 / GlobalVariables.dragon_speed
	$Timer.wait_time = randf_range(0.2 * scale,1 * scale)
	var cloud: Sprite2D = cloud_class.instantiate()
	var y = randi_range(100, 548)
	cloud.position = Vector2(1151,y)
	add_child(cloud)
