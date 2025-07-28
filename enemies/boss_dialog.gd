class_name BossDialog

extends PanelContainer

func _ready() -> void:
	position = Vector2(700, 180)
	$TTL.timeout.connect(
		func(): self.queue_free()
	)

func set_text(text):
	$TTL.start()
	$Label.text = text
