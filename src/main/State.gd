extends Node
class_name State, "res://assets/2d/icons/state.svg"

# abstract generic state class, holds things all states have
onready var _state_machine: = _get_state_machine(self)

var _parent:State = null

func _ready() -> void:
	# onready but in a function lol
	yield(owner,"ready")
	var parent := get_parent()
	if not parent.is_in_group("state_machine"):
		_parent = parent
	

func unhandled_input(event: InputEvent) -> void:
	pass
	
func process(delta: float) -> void:
	pass

func physics_process(delta: float) -> void:
	pass

func enter(msg: = {}) -> void:
	return

func exit() -> void:
	return

func _get_state_machine(node:Node)-> Node:
	if node != null and not node.is_in_group("state_machine"):
		return _get_state_machine(node.get_parent())
	return node
