extends Resource

class_name ItemResource

@export var item_name: String
@export var texture: Texture2D
@export_range(1, 64) var max_stack_size: int
var quantity: int = 1
