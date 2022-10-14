extends CameraState


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_aim"):
		_state_machine.transition_to("Camera/Aim")
	else:
		_parent.unhandled_input(event)

func process(delta: float) -> void:
	_parent.process(delta)


