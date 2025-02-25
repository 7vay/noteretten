extends Control

class_name InventoryItem

@onready var rect = $TextureRect
@onready var label = $Quantity

func _ready():
	rect.texture = null
	label.text = ""
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM

func set_texture(texture: Texture2D):
	rect.texture = texture

func set_quantity(quantity: int):
	if quantity > 1:
		label.text = str(quantity)
	else:
		label.text = ""
