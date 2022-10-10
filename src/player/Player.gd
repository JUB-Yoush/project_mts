extends RigidBody

var input_dir:= Vector3.ZERO
export var speed:= 10.0
export var max_speed := 50
var velocity := Vector3.ZERO
export var acceleration = 10
export (float, 0.01,1.0) var stop_speed = 0.1

func _ready() -> void:
	linear_damp = 1.0
	if friction >= 0: friction = 0

func _physics_process(delta: float) -> void:
	var id =  Input.get_vector("move_left", "move_right", "move_up", "move_down")
	input_dir = Vector3(id.x,0.0,id.y)
	print(input_dir)
	velocity = lerp(velocity,input_dir*speed,acceleration * delta)
	#if input_dir == Vector3.ZERO:
		
	add_central_force(velocity)
	

func _intergrate_forces(state):
	#limit max speed
	if state.linear_velocity.length()>max_speed:
		state.linear_velocity=state.linear_velocity.normalized()*max_speed
	#artificial stopping movement i.e not using physics
	if input_dir.length() < 0.2:
		state.linear_velocity.x = lerp(state.linear_velocity.x,0,stop_speed)
		state.linear_velocity.z = lerp(state.linear_velocity.z,0,stop_speed)
	
