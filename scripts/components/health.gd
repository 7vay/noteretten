extends Node2D

class_name Health

signal died
signal update_health

@export var max_health := 100.0
var health: float

func _ready() -> void:
	health = max_health

func damage(damage: float):
	health -= damage
	update_health.emit(health)
	print(health)
	if damage >= health:
		health = 0
		kill()

func kill():
	print("Breakable removed")
	died.emit()
