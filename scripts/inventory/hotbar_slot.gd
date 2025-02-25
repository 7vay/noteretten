extends Control

@onready var inventory_item: InventoryItem = $InventoryItem
@onready var rect: TextureRect = $TextureRect

var texture = preload("res://assets/sprites/inventory/inventory_slot.png")
var hovered_texture = preload("res://assets/sprites/inventory/inventory_slot_hover.png")

var index: int

func set_item(item: ItemResource):
	if not item:
		inventory_item.hide()
		inventory_item.set_texture(null)
		inventory_item.set_quantity(0)
	else:
		inventory_item.show()
		inventory_item.set_texture(item.texture)
		inventory_item.set_quantity(item.quantity)

func set_selected(is_selected: bool):
	if is_selected:
		rect.texture = hovered_texture
	else:
		rect.texture = texture
