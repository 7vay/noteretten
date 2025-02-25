extends Area2D

class_name Hitbox

signal on_damage

func damage(damage: float):
	on_damage.emit(damage)
