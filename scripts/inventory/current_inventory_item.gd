extends Control

class_name CurrentInventoryItem

var item: ItemResource = null
var index: int
var inventory_item = preload("res://scenes/inventory/inventory_item.tscn").instantiate()

func _ready() -> void:
	#hide()
	mouse_filter = MOUSE_FILTER_IGNORE
	add_child(inventory_item)

func _process(delta: float) -> void:
	inventory_item.global_position = get_global_mouse_position()
	inventory_item.global_position.x -= inventory_item.size.x / 2
	inventory_item.global_position.y -= inventory_item.size.y / 2
	
func set_item(new_item: ItemResource):
	if new_item != null:
		inventory_item.set_texture(new_item.texture)
		inventory_item.set_quantity(new_item.quantity)
	else:
		inventory_item.set_texture(null)
		inventory_item.set_quantity(0)
	item = new_item 
