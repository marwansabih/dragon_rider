extends Node2D

@export var game_screen_class: PackedScene
@export var game_over_screen_class: PackedScene
@export var game_won_screen_class: PackedScene
@export var start_screen_class: PackedScene

var start_sceen: StartScreen
var game_screen: GameScreen
var game_over_screen: GameOverScreen
var game_won_screen

func _ready() -> void:
	self.start_sceen = start_screen_class.instantiate()
	add_child(start_sceen)
	start_sceen.button.pressed.connect(start_new_game)
	GlobalVariables.game_lost.connect(
		handle_game_lost
	)
	GlobalVariables.game_won.connect(
		handle_game_won
	)
	GlobalVariables.beetle_hit.connect(
		play_beetle_hurt
	)

func play_beetle_hurt():
	if not $AudioStreamPlayer2D.playing:
		$AudioStreamPlayer2D.play()
	
func handle_game_won():
	remove_child(game_screen)
	game_screen.queue_free()
	game_won_screen = game_won_screen_class.instantiate()
	add_child(game_won_screen)

func handle_game_lost():
	remove_child(game_screen)
	game_screen.queue_free()
	game_over_screen = game_over_screen_class.instantiate()
	add_child(game_over_screen)
	game_over_screen.retry_button.pressed.connect(
		start_new_game
	)
	
func start_new_game():
	if start_sceen:
		remove_child(start_sceen)
		start_sceen.queue_free()
		start_sceen = null
	if game_over_screen:
		remove_child(game_over_screen)
		game_over_screen.queue_free()
		game_over_screen = null
	game_screen = game_screen_class.instantiate()
	add_child(game_screen)
