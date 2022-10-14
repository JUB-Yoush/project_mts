tool
extends Spatial

class_name CameraRig

var player:RigidBody

onready var camera: InterpolatedCamera = $InterpolatedCamera
onready var spring_arm: SpringArm = $SpringArm
onready var aim_ray: RayCast = $InterpolatedCamera/AimRay
onready var aim_target:Sprite3D = $AimTarget

onready var _position_start:Vector3 = translation


func _ready() -> void:
	set_as_toplevel(true)
	yield(owner,"ready")
	player = owner

func _get_configuration_warning() -> String:
	return "Missing player node" if not player else ""
