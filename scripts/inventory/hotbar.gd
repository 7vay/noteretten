extends Control

class_name Hotbar

@export var inventory: Inventory

@onready var container: HBoxContainer = $HBoxContainer

var selected := 0
var slot = preload("res://scenes/inventory/hotbar_slot.tscn")

signal update_selected

func _ready():
	inventory.connect("inventory_updated", _on_inventory_updated)
	inventory.connect("slot_updated", _on_slot_updated)
	_on_inventory_updated()

func _on_inventory_updated():
	clear_grid_container()
	for i in range(inventory.slots_per_row):
		var slotCopy = slot.instantiate()
		slotCopy.index = i
		container.add_child(slotCopy)
		slotCopy.set_item(inventory.inventory[i])
	select(selected)

func _on_slot_updated(index: int, item: ItemResource):
	var children = container.get_children()
	for child in children:
		if child.index == index:
			child.set_item(item)

func clear_grid_container():
	var children = container.get_children()
	for child in children:
		container.remove_child(child)
		child.queue_free()

func select(index: int):
	if index < 0:
		index = inventory.slots_per_row - 1
	elif index > inventory.slots_per_row - 1:
		index = 0
	selected = index
	update_selected.emit(selected)
	for i in range(container.get_children().size()):
		if i == index:
			container.get_children()[i].set_selected(true)
		else: 
			container.get_children()[i].set_selected(false)
