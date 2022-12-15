extends CameraState

export var fov_default = 60
export var is_y_inverted:= false
export var auto_rotate_speed := 0.01
export var deadzone_backwards: = 0.3
export var sensitivity_gamepad_default:= Vector2(2.5,2.5)
export var sensitivity_gamepad_aiming:= Vector2(2.5*5,2.5*5)
export var sensitivity_mouse_default: =Vector2(0.1,0.1)
export var sensitivity_mouse_aiming: =Vector2(0.5,0.5)

var sensitivity_mouse_current:Vector2
var sensitivity_gamepad_current:Vector2

var max_look_aim:float = 1.5
var max_look_default:float = 1.25

var max_look:float

var _input_relative = Vector2.ZERO
var _is_aiming := false

func process(delta: float) -> void:
	
	camera_rig.global_transform.origin = camera_rig.player.global_transform.origin + camera_rig._position_start
	#print('e')
	var look_direction: = get_look_direction()
	var move_direction: = get_move_direction()
	if _input_relative.length() > 0.0:
		update_rotation(_input_relative * sensitivity_mouse_current * delta)
		_input_relative = Vector2.ZERO
	
	if look_direction.length() > 0.0:
		update_rotation(look_direction * sensitivity_gamepad_current * delta)
	
	var is_moving_towards_camera:bool = (
		move_direction.x >= -deadzone_backwards and move_direction.x <= deadzone_backwards
	)
	if not is_moving_towards_camera and not _is_aiming:
		#auto_rotate(move_direction)
		pass
		
	
	camera_rig.rotation.y = wrapf(camera_rig.rotation.y, -PI,PI)

func unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		_input_relative += event.get_relative()

func auto_rotate(move_direction:Vector3) -> void:
	var offset: float = camera_rig.player.rotation.y - camera_rig.rotation.y
	var target_angle: float = (
		camera_rig.player.rotation.y -2 * PI if offset > PI
		else camera_rig.player.rotation.y + 2 * PI if offset < -PI
		else camera_rig.player.rotation.y
	
	)
	camera_rig.rotation.y = lerp(camera_rig.rotation.y,target_angle,auto_rotate_speed)

func update_rotation(offset: Vector2) -> void:
	camera_rig.rotation.y -= offset.x
	camera_rig.rotation.x += offset.y * -1.0 if is_y_inverted else offset.y
	camera_rig.rotation.x = clamp(camera_rig.rotation.x, -0.75,max_look)
	camera_rig.rotation.z = 0
	return
	

static func get_look_direction() -> Vector2:
	return  Input.get_vector("look_left", "look_right", "look_up", "look_down")


static func get_move_direction() -> Vector3:
	var iv =  Input.get_vector("move_left", "move_right", "move_front", "move_back")
	return Vector3(iv.x,0.0,iv.y)
