extends PanelContainer

class_name InventoryScreen

@export var inventory: Inventory
@export var placeable_manager: PlaceableManager

@onready var inventory_button: Control = $MarginContainer/HBoxContainer/InventoryButton
@onready var building_button: Control = $MarginContainer/HBoxContainer/BuildingButton
@onready var inventory_container: InventoryInterface = $GridContainer
@onready var building_container: VFlowContainer = $VFlowContainer

func _ready() -> void:
	set_page(1)
	inventory_button.connect("button_clicked", _inventory_button_clicked)
	building_button.connect("button_clicked", _building_button_clicked)

func set_page(index: int) -> void:
	match index:
		1:
			inventory_container.show()
			building_container.hide()
		2:
			inventory_container.hide()
			building_container.show()

func _inventory_button_clicked():
	set_page(1)

func _building_button_clicked():
	set_page(2)

func _on_buy_button_clicked() -> void:
	var resource = load("res://scripts/placables/implementation/power_generator_resource.tres")
	print(typeof(resource))
	placeable_manager.set_current_placeable(resource)
