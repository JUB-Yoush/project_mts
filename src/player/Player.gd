extends KinematicBody

onready var camera:CameraRig = $CameraRig

var velocity: = Vector3.ZERO

var speed:= 7
var steer_angle: = 2


static func get_input_vector() -> Vector3:
	var iv =  Input.get_vector("move_left", "move_right", "move_front", "move_back")
	return Vector3(iv.x,0.0,iv.y)


func _physics_process(delta: float) -> void:
	#you always start by moving forward.
	# inputting past 90deg to the left or right  when stopped will turn you around to face backwards and then move in that direction
	# the allowed inputs are greater when you're moving, maybe like a 30deg radius around the opposite direction of where you're current velocity is
	#you start by moving forward then begin to rotate towards the input direction
	#the speed at which you rotate is based on your current speed, going faster means you turn slower
	
	
	var input_vector: = get_input_vector()
	var forwards:Vector3 = camera.global_transform.basis.z * input_vector.z
	var right:Vector3 = camera.global_transform.basis.x * input_vector.x
	var relative_input_vector: = forwards + right
	relative_input_vector.normalized()
	var rot_change: = steer_angle * relative_input_vector.x
	rotation_degrees.y += -rot_change
	velocity.x = -cos(rotation.y)
	velocity.z = sin(rotation.y)
	velocity.normalized()
	prints(input_vector,relative_input_vector)
	velocity = move_and_slide(velocity* (speed * -input_vector.z))
