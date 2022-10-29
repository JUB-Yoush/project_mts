extends KinematicBody

onready var camera:CameraRig = $CameraRig
onready var dirRay:RayCast = $DirRay
var velocity: = Vector3.ZERO

var speed:= 3;
var steer_angle: = 3


static func get_input_vector() -> Vector3:
	var iv =  Input.get_vector("move_left", "move_right", "move_front", "move_back")
	return Vector3(iv.x,0.0,iv.y)


func _physics_process(delta: float) -> void:
	#y effects speed
	#x effects rotation
	var input_vector: = get_input_vector()
	var forwards:Vector3 = camera.global_transform.basis.z * input_vector.z
	var right:Vector3 = camera.global_transform.basis.x * input_vector.x
	var rot_change: = steer_angle * input_vector.x
	rotation_degrees.y += -rot_change
	velocity = move_and_slide(Vector3.FORWARD * speed)
