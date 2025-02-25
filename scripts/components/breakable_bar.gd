extends Control

@export var health: Health
@onready var health_bar: TextureProgressBar = $HealthBar
@onready var damage_bar: TextureProgressBar = $DamageBar
@onready var timer: Timer = $Timer

func _ready() -> void:
	health_bar.max_value = health.max_health
	damage_bar.max_value = health.max_health
	set_health(health.max_health)
	health.update_health.connect(set_health)

func set_health(new_health: int) -> void:
	timer.start(0.2)
	health_bar.value = new_health
	if new_health == health.max_health:
		hide()
	else:
		show()

func _on_timeout() -> void:
	damage_bar.value = health.health
