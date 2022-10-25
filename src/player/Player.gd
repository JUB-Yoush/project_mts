extends RigidBody

export var jump_velocity = 10

export var speed:= 20.0
export var max_speed := 50

export var acceleration = 10
var accel_multiplier = 1.0
export (float, 0.01,1.0) var stop_speed = 0.1
onready var camera:CameraRig = $CameraRig
onready var groundRay:RayCast = $GroundRay


var move_direction:Vector3
var movement_force := Vector3.ZERO
var input_dir:= Vector3.ZERO
var is_on_floor = false

func _ready() -> void:
	linear_damp = 1.0
	if friction >= 0: friction = 0
	
func _physics_process(delta: float) -> void:
	#get input vector2, map to Vector3
	var id =  Input.get_vector("move_left", "move_right", "move_front", "move_back")
	input_dir = Vector3(id.x,0.0,id.y)
	# change input direction relative to the camera
	var forwards:Vector3 = camera.global_transform.basis.z * input_dir.z
	var right:Vector3 = camera.global_transform.basis.x * input_dir.x
	move_direction = forwards + right
	if move_direction.length() > 1.0:
		move_direction = move_direction.normalized()
	#print(move_direction)
	#make a force based on direction
	movement_force = lerp(movement_force,move_direction*speed,acceleration *accel_multiplier * delta)
	add_central_force(movement_force)
	
	if groundRay.is_colliding():
		is_on_floor = true
		#friction = 0.2
		accel_multiplier = 1.0
	
	if Input.is_action_just_pressed("jump") and is_on_floor:
		accel_multiplier = 2
		is_on_floor = false
		apply_central_impulse(Vector3.UP * jump_velocity)
	
#	if Input.is_action_just_pressed("rotate"):
	#rotate(global_transform.origin + move_direction,3.0)
	#look_at(global_transform.origin + move_direction,Vector3.UP)
	
	

	

func _input(event: InputEvent) -> void:
	look_at(global_transform.origin + move_direction,Vector3.UP)
	
func _intergrate_forces(state):
	#limit max speed
	if state.linear_velocity.length()>max_speed:
		state.linear_velocity=state.linear_velocity.normalized()*max_speed
	#artificial stopping movement i.e not using physics
	if move_direction.length() < 0.2:
		state.linear_velocity.x = lerp(state.linear_velocity.x,0,stop_speed)
		state.linear_velocity.z = lerp(state.linear_velocity.z,0,stop_speed)
	
