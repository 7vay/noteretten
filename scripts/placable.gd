extends StaticBody2D

class_name Placeable

@export var shape: CollisionShape2D
@export var sprite: Sprite2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func set_moving(moving: bool) -> void:
	if moving:
		collision_shape.disabled = true
		sprite.modulate = Color(255, 255, 255, 120)
	else:
		collision_shape.disabled = false
		sprite.modulate = Color(255, 255, 255, 255)

func set_disabled(disabled: bool) -> void:
	if disabled:
		sprite.modulate = Color(255, 0, 0, 120)
	else:
		sprite.modulate = Color(255, 255, 255, 255)
		
func is_placable_at(position: Vector2) -> void:
	pass
