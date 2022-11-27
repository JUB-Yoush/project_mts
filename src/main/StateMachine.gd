extends Node
class_name StateMachine, "res://assets/2d/icons/state_machine.svg"
onready var player:Player = get_parent().get_parent()
signal transitioned(state_path)
export var inital_state:= NodePath()

onready var state: State = get_node(inital_state) setget set_state
var _state_name:=""
var is_active:bool = true setget set_is_active

func set_state(value:State) -> void:
	state = value
	_state_name = state.name
	
func set_is_active(bit:bool):
	is_active = bit
	
func _init() -> void:
	add_to_group("state_machine")

func _ready() -> void:
	yield(owner,"ready")
	state.enter()

func _unhandled_input(event: InputEvent) -> void:
	state.unhandled_input(event)

func _process(delta: float) -> void:
	
	state.process(delta)
	
func _physics_process(delta: float) -> void:
	#print(state.name)
	state.physics_process(delta)
	

func transition_to(target_state_path:String,msg: = {}) -> void:
	if not has_node(target_state_path):
		return
	var target_state = get_node(target_state_path)
	
	state.exit()
	self.state = target_state
	if target_state.name == "Aim":
		player.set_state(player.States.AIMING)
	state.enter(msg)
	emit_signal("transitioned",target_state_path)
	


