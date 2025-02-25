extends GridContainer

class_name InventoryInterface

@onready var inventory: Inventory = $"..".inventory
@onready var current_item: CurrentInventoryItem = $"../CurrentInventoryItem"

var slot = preload("res://scenes/inventory/inventory_slot.tscn").instantiate()

func _ready():
	var item = load("res://scripts/item/implementation/drill.tres")
	#inventory.add_item(item)

	columns = inventory.slots_per_row
	inventory.connect("inventory_updated", _on_inventory_updated)
	inventory.connect("slot_updated", _on_slot_updated)
	_on_inventory_updated()

func _on_inventory_updated():
	clear_grid_container()
	for i in range(inventory.inventory.size()):
		var slotCopy = slot.duplicate()
		slotCopy.connect("select_slot", select_slot)
		slotCopy.index = i
		add_child(slotCopy)
		slotCopy.set_item(inventory.inventory[i])

func _on_slot_updated(index: int, item: ItemResource):
	var children = get_children()
	for child in children:
		if child.index == index:
			child.set_item(item)

func clear_grid_container():
	var children = get_children()
	for child in children:
		remove_child(child)
		child.queue_free()

func select_slot(slot: InventorySlot):
	if current_item.item:
		inventory.set_item(slot.index, current_item.item)
		# slot.item will return the new value, so this will not work
		# we need to save the var locally first
		if slot.item:
			current_item.set_item(slot.item)
		current_item.set_item(null)
	else:
		current_item.set_item(slot.item)
		print(inventory.set_item(slot.index, null))
