extends InteractableItemResource

class_name DrillResource

@export var damage_per_use: int = 1
@export var animationPlayer: SpriteFrames

func start_using(player: Player):
	player.animation_player.play("start_drilling")

func stop_using(player: Player):
	player.animation_player.play("end_drilling")

func on_cooldown(player: Player):
	for hitbox in player.hurtbox.hitboxes:
		if hitbox is Hitbox and player.position.distance_to(hitbox.position) < range:
			print(player.position.distance_to(hitbox.position))
			hitbox.damage(1)
			player.camera.shake()
