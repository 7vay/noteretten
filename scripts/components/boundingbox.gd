extends Area2D

class_name BoundingBox

@export var on_placing: BoundingBoxType = BoundingBoxType.CANCEL

enum BoundingBoxType {
	CANCEL,
	DROP,
	DESTROY
}

func on_try_placing() -> bool:
	if on_placing == BoundingBoxType.CANCEL:
		return false
	else:
		if on_placing == BoundingBoxType.DROP:
			#drop the item
			pass
		return true
