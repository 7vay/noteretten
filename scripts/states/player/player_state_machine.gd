extends Node

@export var initial_state: State

var current_state: State

func _ready() -> void:
	for child in get_children():
		if child is State:
			child.update_state.connect(set_state)
	if initial_state:
		set_state(initial_state)

func set_state(state: State):
	if current_state:
		current_state.on_exit()
	
	current_state = state
	current_state.on_enter()
	print("swiched current state")
	print(current_state.name)

func on_physics_process(delta: float) -> void:
	if current_state:
		#pass
		current_state.on_physics_process(delta)
