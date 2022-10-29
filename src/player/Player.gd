extends KinematicBody

onready var camera:CameraRig = $CameraRig

var velocity: = Vector3.ZERO

var speed:= 7
var steer_angle: = 2


static func get_input_vector() -> Vector3:
	var iv =  Input.get_vector("move_left", "move_right", "move_front", "move_back")
	return Vector3(iv.x,0.0,iv.y)


func _physics_process(delta: float) -> void:
	#y effects speed
	#x effects rotation
	var input_vector: = get_input_vector()
	var forwards:Vector3 = camera.global_transform.basis.z * input_vector.z
	var right:Vector3 = camera.global_transform.basis.x * input_vector.x
	var relative_input_vector: = forwards + right
	var rot_change: = steer_angle * relative_input_vector.x
	rotation_degrees.y += -rot_change
	velocity.x = -cos(rotation.y)
	velocity.z = sin(rotation.y)
	velocity.normalized()
	print(velocity)
	print(rotation_degrees.y)
	#prints(cos(rotation_degrees.y),sin(rotation_degrees.y))
	velocity = move_and_slide(velocity * speed)
