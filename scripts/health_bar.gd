extends CanvasLayer

@export var player: Player
var test_max_health:= 10
var test_health:= 8

func _ready() -> void:
	set_health()

func set_health():
	for i in int(test_max_health / 2):
		var rect = TextureRect.new()
		rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		if float(test_health) / 2 - i >= 1:
			rect.texture = load("res://assets/sprites/heart_full.png")
		elif float(test_health) / 2 - i > 0:
			rect.texture = load("res://assets/sprites/heart_half.png")
		else:
			rect.texture = load("res://assets/sprites/heart_empty.png")
		$HBoxContainer.add_child(rect)
