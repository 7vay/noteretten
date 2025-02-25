extends Node

class_name Inventory

var inventory: Array[ItemResource] = []
const slots_per_row = 9

@export var rows = 4

signal inventory_updated
signal slot_updated

func _ready():
	set_rows(self.rows)
	inventory_updated.emit()

func add_item(item: ItemResource):
	for i in range(inventory.size()):
		if inventory[i] == null:
			inventory[i] = item
			slot_updated.emit(i, item)
			break

func set_item(slot: int, item: ItemResource) -> bool:
	if item and inventory[slot] == item:
		if item.quantity < item.max_stack_size:
			inventory[slot].quantity += 1
			slot_updated.emit(slot, item)
			return true
	else:
		inventory[slot] = item
		slot_updated.emit(slot, item)
		return true
	return false

func remove_item():
	pass

func set_rows(rows: int):
	self.rows = rows
	inventory.resize(rows * slots_per_row)
