extends Area2D

class_name Hurtbox

var hitboxes:= []

func _process(delta: float) -> void:
	global_position = get_global_mouse_position()

func _on_area_exited(area: Area2D):
	if area is Hitbox:
		hitboxes.erase(area)

func _on_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		hitboxes.append(area)
