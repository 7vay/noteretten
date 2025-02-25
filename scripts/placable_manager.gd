extends Node2D

class_name PlaceableManager

@onready var current_placeable: CurrentPlaceable = $CurrentPlaceable

func place(position: Vector2, scene: PackedScene):
	var placeable = scene.instantiate()
	add_child(placeable)
	placeable.position = snapped(position, Vector2(16,16))

func set_current_placeable(placeable: PlaceableResource):
	current_placeable.set_placeable(placeable)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("primary_action"):
		if current_placeable.current_placeable and current_placeable.is_placeable():
			place(get_local_mouse_position(), current_placeable.current_placeable.placeable)
	if event.is_action_pressed("secondary_action"):
		set_current_placeable(null)
	if event.is_action_pressed("placeable_rotate"):
		current_placeable.scale.x = -current_placeable.scale.x
		
