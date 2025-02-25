extends Control

class_name InventorySlot

@onready var inventory_item: InventoryItem = $InventoryItem
@onready var rect: TextureRect = $TextureRect

var normal_texture = preload("res://assets/sprites/inventory/inventory_slot.png")
var hovered_texture = preload("res://assets/sprites/inventory/inventory_slot_hover.png")

var item: ItemResource
var index = 0

signal select_slot

func set_item(item: ItemResource):
	if not item:
		inventory_item.hide()
		inventory_item.set_texture(null)
		inventory_item.set_quantity(0)
	else:
		inventory_item.show()
		inventory_item.set_texture(item.texture)
		inventory_item.set_quantity(item.quantity)
	self.item = item

func _on_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		select_slot.emit(self)

func _on_mouse_entered() -> void:
	rect.texture = hovered_texture

func _on_mouse_exited() -> void:
	rect.texture = normal_texture
