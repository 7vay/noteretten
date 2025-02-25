extends State

class_name Walking

@onready var animated_sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var player: Player = $"../.."
@onready var particles: GPUParticles2D = $"../../RunningParticles"
@onready var idle: Idle = $"../Idle"

var speed: int = 10000

func on_enter():
	animated_sprite.play("walking")
	particles.emitting = true

func on_exit():
	false

func on_physics_process(delta: float):
	var direction_x := Input.get_axis("move_left", "move_right")
	var direction_y := Input.get_axis("move_up", "move_down")
	
	if direction_x == 0 && direction_y == 0:
		update_state.emit(idle)
	
	player.velocity = Vector2(direction_x, direction_y).normalized() * speed * delta

	if player.get_local_mouse_position().x > 0:
		player.scale.x = 1
	else:
		player.scale.x = -1
	player.move_and_slide()


func on_input(event: InputEvent):
	if event.is_action("move_left"):
		update_state.emit()
	if event.is_action("move_right"):
		update_state.emit()
	if event.is_action("move_up"):
		update_state.emit()
	if event.is_action("move_down"):
		update_state.emit()
