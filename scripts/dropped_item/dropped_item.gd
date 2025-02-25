extends Node2D

@export var item: ItemResource
@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	sprite.texture = item.texture

func pickup(player: Player):
	player.inventory.add_item(item)
	queue_free()

func _on_body_entered(body: Node2D):
	if body is Player:
		pickup(body)
