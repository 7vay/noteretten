extends Control

@export var normal_texture: Texture2D
@export var hovered_texture: Texture2D

@onready var texture_rect: TextureRect = $TextureRect

signal button_clicked

func _ready() -> void:
	texture_rect.texture = normal_texture

func _on_mouse_entered() -> void:
	texture_rect.texture = hovered_texture

func _on_mouse_exited() -> void:
	texture_rect.texture = normal_texture

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			button_clicked.emit()
