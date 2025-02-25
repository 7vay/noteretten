extends ItemResource

class_name InteractableItemResource

@export var cooldown: int = 5
@export var range: int = 20

func start_using(player: Player):
	pass

func stop_using(player: Player):
	pass

func on_cooldown(player: Player):
	pass
