extends Camera2D

@export var player: Player
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func shake() -> void:
	animation_player.play("shake")
