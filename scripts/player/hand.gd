extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var cooldown: Timer = $Cooldown
@onready var player: Player = $".."

var item_in_hand: InteractableItemResource

func _ready() -> void:
	sprite.rotate(-2)

func set_item(item: InteractableItemResource) -> void:
	item_in_hand = item
	if item:
		sprite.texture = item.texture
	else:
		sprite.texture = null

func _physics_process(delta: float) -> void:
	pass
	#look_at(get_global_mouse_position())

func start_using_item() -> void:
	if item_in_hand:
		cooldown.one_shot = false
		cooldown.wait_time = item_in_hand.cooldown * 0.1
		cooldown.start()
		item_in_hand.start_using(player)

func stop_using_item() -> void:
	if item_in_hand:
		cooldown.stop()
		item_in_hand.stop_using(player)

func _on_timeout() -> void:
	if item_in_hand:
		item_in_hand.on_cooldown(player)
