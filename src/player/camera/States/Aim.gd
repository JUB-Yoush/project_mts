extends CameraState

onready var tween:Tween = $Tween

export var fov: = 40.0
export var offset_camrea:= Vector3(0.75,-0.7,0.0)

func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_aim"):
		_state_machine.transition_to("Camera/Default")
		
	_parent.unhandled_input(event)

func process(delta: float) -> void:
	_parent.process(delta)
	camera_rig.aim_target.update(camera_rig.aim_ray)


func enter(msg:Dictionary = {}) -> void:
	## move camera to over shoulder view when entering
	_parent._is_aiming = true
	camera_rig.aim_target.visible = true
	camera_rig.spring_arm.translation = camera_rig._position_start + offset_camrea
	
	tween.interpolate_property(camera_rig.camera,"fov",camera_rig.camera.fov,fov,
	0.5,Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()

func exit() -> void:
	## reset
	camera_rig.aim_target.visible = false
	_parent._is_aiming = false
	camera_rig.spring_arm.translation = camera_rig.spring_arm. _postion_start
	
	tween.interpolate_property(camera_rig.camera,"fov",camera_rig.camera.fov,_parent.fov_default,
	0.5,Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
