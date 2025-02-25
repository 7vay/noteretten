extends StaticBody2D

@export var dropped_item_manager: DroppedItemManager

@onready var health: Health = $Health

func _on_hitbox_on_damage(damage) -> void:
	health.damage(damage)

func _on_died() -> void:
	dropped_item_manager.drop_item(position, preload("res://scripts/item/implementation/stone.tres"))
	queue_free()
