extends Control

@export var normal_texture: Texture2D
@export var hovered_texture: Texture2D

@onready var icon: TextureRect = $Icon
@onready var background: TextureRect = $Background

var normal_background_texture: Texture2D = preload("res://assets/sprites/inventory/buy_button.png")
var hovered_background_texture: Texture2D = preload("res://assets/sprites/inventory/buy_button_hovered.png")

signal button_clicked

func _ready() -> void:
	icon.texture = normal_texture
	background.texture = normal_background_texture

func _on_mouse_entered() -> void:
	icon.texture = hovered_texture
	background.texture = hovered_background_texture

func _on_mouse_exited() -> void:
	icon.texture = normal_texture
	background.texture = normal_background_texture

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			button_clicked.emit()
