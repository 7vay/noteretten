extends Node

class_name DroppedItemManager

const DROPPED_ITEM = preload("res://scenes/items/dropped_item.tscn")

func drop_item(pos: Vector2, item: ItemResource):
	var drop = DROPPED_ITEM.instantiate()
	drop.item = item
	drop.position = pos
	add_child(drop)
