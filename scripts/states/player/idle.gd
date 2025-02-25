extends State

class_name Idle

@export var player: Player

@onready var animated_sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var walking: Walking = $"../Walking"
@onready var particles: GPUParticles2D = $"../../RunningParticles"

func on_enter():
	animated_sprite.play("idle")
	particles.emitting = false

func on_exit():
	pass

func on_physics_process(delta: float):
	var direction_x := Input.get_axis("move_left", "move_right")
	var direction_y := Input.get_axis("move_up", "move_down")
	
	if player.get_local_mouse_position().x > 0:
		player.scale.x = 1
	else:
		player.scale.x = -1
	player.move_and_slide()
	
	if direction_x != 0 or direction_y != 0:
		update_state.emit(walking)
