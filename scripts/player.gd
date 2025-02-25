extends CharacterBody2D

class_name Player

const speed := 500000

@onready var particles: GPUParticles2D = $RunningParticles
@onready var animation_player := $AnimationPlayer
@onready var animation_sprite := $AnimatedSprite2D
@onready var hand := $Hand

@export var hurtbox: Hurtbox
@export var camera: Camera2D

@export var hotbar: Hotbar
@export var inventory_screen: InventoryScreen
@onready var inventory = inventory_screen.inventory
@onready var player_state_machine: Node = $PlayerStateMachine

var placing := false

func _ready():
	inventory.connect("slot_updated", _update_hand_on_inventory)
	hotbar.connect("update_selected", _update_hand_on_select)

func _physics_process(delta: float) -> void:
	player_state_machine.on_physics_process(delta)
	#var direction_x := Input.get_axis("move_left", "move_right")
	#var direction_y := Input.get_axis("move_up", "move_down")
	#
#	velocity = Vector2(direction_x, direction_y).normalized() * speed * delta
#	
#	if direction_x == 0 && direction_y == 0:
#		animation_sprite.play("idle")
#		particles.emitting = false
#	else: 
	#	animation_sprite.play("running")
#		particles.emitting = true
	#if get_local_mouse_position() > 0:
	#	scale.x = 1
	#else:
	#	scale.x = -1
	#move_and_slide()

func _input(event: InputEvent):
	if event.is_action_pressed("ui_inventory"):
		inventory_screen.visible = !inventory_screen.visible
		return
	if event.is_action_pressed("hotbar_bar_slot_1"):
		hotbar.select(0)
		return
	if event.is_action_pressed("hotbar_bar_slot_2"):
		hotbar.select(1)
		return
	if event.is_action_pressed("hotbar_bar_slot_3"):
		hotbar.select(2)
		return
	if event.is_action_pressed("hotbar_bar_slot_4"):
		hotbar.select(3)
		return
	if event.is_action_pressed("hotbar_bar_slot_5"):
		hotbar.select(4)
		return
	if event.is_action_pressed("hotbar_bar_slot_6"):
		hotbar.select(5)
		return
	if event.is_action_pressed("hotbar_bar_slot_7"):
		hotbar.select(6)
		return
	if event.is_action_pressed("hotbar_bar_slot_8"):
		hotbar.select(7)
		return
	if event.is_action_pressed("hotbar_bar_slot_9"):
		hotbar.select(8)
		return
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			hotbar.select(hotbar.selected + 1)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			hotbar.select(hotbar.selected - 1)
	
	if event.is_action_pressed("primary_action"):
		hand.start_using_item()
	if event.is_action_released("primary_action"):
		hand.stop_using_item()

func _update_hand_on_inventory(index: int, item: ItemResource):
	if index == hotbar.selected:
		if item is InteractableItemResource:
			hand.set_item(item)
		else: 
			hand.set_item(null)

func _update_hand_on_select(index: int):
	var item = inventory.inventory[index]
	if item is InteractableItemResource:
		hand.set_item(item)
	else: 
		hand.set_item(null)
