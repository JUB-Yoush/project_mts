extends CameraState


#onready var player:Player = get_tree().get_root().get_node("Player")

#default camera statemachine camerarig player scene
#onready var player:Player = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("Player")


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_aim"):
		_state_machine.transition_to("Camera/Aim")
		
		
	else:
		_parent.unhandled_input(event)


func process(delta: float) -> void:
	_parent.process(delta)


