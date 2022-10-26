extends KinematicBody

var max_speed: = 10
var move_speed: = 10
var gravity: = -80.0
var jump_impulse: = 25.0
onready var camera:CameraRig = $CameraRig

var velocity: = Vector3.ZERO

static func get_input_direction() -> Vector3:
	#map a 2d input vector to 3d space
	var iv =  Input.get_vector("move_left", "move_right", "move_front", "move_back")
	return Vector3(iv.x,0.0,iv.y)

func _physics_process(delta: float) -> void:
	var input_direction: = get_input_direction()
	var forwards:Vector3 = camera.global_transform.basis.z * input_direction.z
	var right:Vector3 = camera.global_transform.basis.x * input_direction.x
	var move_direction := forwards + right
	if move_direction.length() > 1.0:
		move_direction = move_direction.normalized()
	move_direction.y = 0.0

	if move_direction:
		look_at(global_transform.origin + move_direction,Vector3.UP)
	
	velocity = calculate_velocity(velocity,move_direction,delta)
	velocity = move_and_slide(velocity,Vector3.UP)
	print(velocity)
	

func calculate_velocity(velocity_current:Vector3,move_direction:Vector3,delta:float) -> Vector3:
	var velocity_new:= velocity_current
	velocity_new = move_direction * move_speed
	if velocity_new.length() > max_speed:
		velocity_new = velocity_new.normalized() * max_speed
	velocity_new.y = velocity_current.y + gravity * delta
	return velocity_new
