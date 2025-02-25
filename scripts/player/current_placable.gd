extends Node2D

class_name CurrentPlaceable

@onready var sprite: Sprite2D = $Sprite2D
@onready var area: Area2D = $Area2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D

var current_placeable: PlaceableResource
var at_cursor: Array[BoundingBox] = []

func _process(delta: float) -> void:
	global_position = snapped(get_global_mouse_position(), Vector2(16,16))
	#print(at_cursor)
	if not is_placeable():
		sprite.modulate = Color(0.9, 0.2, 0.2, 0.6)
	else:
		sprite.modulate = Color(0.9, 0.9, 0.9, 0.6)

func set_placeable(placeable: PlaceableResource) -> void:
	if not placeable:
		current_placeable = null
		sprite.texture = null
		collision_shape.shape = null
		return
	
	var new_placeable = placeable.placeable.instantiate()
	current_placeable = placeable
	sprite.texture = new_placeable.sprite.texture
	collision_shape.shape = new_placeable.shape.shape
	
func _on_area_enter(area: Area2D):
	if area is BoundingBox:
		at_cursor.append(area)

func _on_area_exit(area: Area2D):
	if area is BoundingBox:
		at_cursor.erase(area)

func is_placeable() -> bool:
	return at_cursor.all(_can_be_placed_on)

func _can_be_placed_on(box: BoundingBox) -> bool:
	return box.on_try_placing()
