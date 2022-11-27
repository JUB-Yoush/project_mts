extends KinematicBody
class_name Player

onready var camera:CameraRig = $CameraRig
onready var crosshair:Sprite = $CameraRig/InterpolatedCamera/Crosshair
onready var inputVisual: = get_parent().get_node("DebugArrows/InputVisual")
onready var veloVisual: = get_parent().get_node("DebugArrows/VeloVisual")
onready var aim_camera_state = $CameraRig/StateMachine/Camera/Aim

var velocity: = Vector3.ZERO


var speed:= 10.0
var gravity:= 20.0 
var fly_speed:= 30.0
var jump_impulse := 10.0
var air_drift:= 2.0

const MAX_SPEED: = 23.0
var steer_angle: = 2.0
var turn_str: = 0.05
var y_velo:float
var skate_force: = Vector2.ZERO
var input_vector:Vector3
var move_direction:Vector3

signal left_rail

enum States{
	MOVING,
	IN_AIR,
	ON_RAIL,
	AIMING,
	FLIGHT
}

var _state = States.MOVING

func _ready() -> void:
	inputVisual.transform.basis = Basis.IDENTITY

static func get_input_vector() -> Vector3:
	var iv =  Input.get_vector("move_left", "move_right", "move_front", "move_back")
	return Vector3(iv.x,0.0,iv.y)

func make_relative_input_vector(input_vector:Vector3) -> Vector3:
	var forwards:Vector3 = camera.global_transform.basis.z * input_vector.z
	var right:Vector3 = camera.global_transform.basis.x * input_vector.x
	var md = forwards + right
	md.y = 0.0
	if md.length() > 1.0:
		md = md.normalized()
	return md
	

func _physics_process(delta: float) -> void:
	match _state:
		States.MOVING:
			state_moving(delta)
		States.IN_AIR:
			state_in_air(delta)
		States.ON_RAIL:
			state_on_rail(delta)
		States.AIMING:
			state_aiming(delta)
		States.FLIGHT:
			state_flight(delta)

	
	
# STATE SETTER------------------
func set_state(new_state:int):	
	#print(new_state)
	# this method is used to undo any state specific stuff before you get placed into another state
	match _state:
		States.MOVING:
			pass
		States.IN_AIR:
			pass
		States.ON_RAIL:
			emit_signal("left_rail")
		States.AIMING:
			crosshair.visible = false
			pass
		States.FLIGHT:
			$CollisionShape.disabled = false
			
	
	_state = new_state
	
# -------------------- states----------------------------
func state_moving(delta:float):
	input_vector = get_input_vector()
	var move_direction := make_relative_input_vector(input_vector)
	

	update_skate_force(move_direction)
	update_turn_force(move_direction)
	update_visualizers(move_direction)

	var skate_force_v3 := Vector3(skate_force.x ,velocity.y,skate_force.y )
	velocity =  skate_force_v3 
	
	velocity.x = velocity.x * speed
	velocity.z = velocity.z * speed

	if is_on_floor() and Input.is_action_pressed("jump"):
	
		velocity.y += jump_impulse
		

	if is_on_floor() and velocity.y == 0: velocity.y = 0
	else: velocity.y -= gravity * delta
		

	velocity = move_and_slide(velocity,Vector3.UP)
	
	
	if not is_on_floor(): 
		set_state(States.IN_AIR)
	
	if Input.is_action_just_pressed("toggle_flight"):
		$CollisionShape.disabled = true
		set_state(States.FLIGHT)
	
#---
func state_in_air(delta:float):
	update_visualizers(move_direction)
	velocity.y -= gravity * delta
	
	input_vector = get_input_vector()
	var move_direction := make_relative_input_vector(input_vector)
	
	move_and_slide(velocity + (move_direction * air_drift),Vector3.UP)
	
	if is_on_floor(): set_state(States.MOVING)
	
	if Input.is_action_just_pressed("toggle_flight"):
		set_state(States.FLIGHT)
	
#---
func state_on_rail(delta:float):
	if Input.is_action_just_pressed("jump"):
		set_state(States.IN_AIR)
		#velocity.y += jump_impulse
	pass
#---
func state_aiming(delta:float):
	crosshair.visible = true
	pass




func state_flight(delta:float):
	input_vector = get_input_vector()
	var move_direction := make_relative_input_vector(input_vector)
	$CollisionShape.disabled = true
	var y_move = Input.get_action_strength("q") - Input.get_action_strength("e")
	velocity = move_direction 
	velocity.y = y_move
	velocity = velocity * fly_speed
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("toggle_flight"):
		set_state(States.IN_AIR)
		
	
#--------------------------------------------------

func update_skate_force(move_direction:Vector3):	
	if skate_force == Vector2.ZERO:skate_force = Vector2.UP.rotated(rotation.y)
	var move_direction_v2 := Vector2(move_direction.x,move_direction.z).normalized()
	
	# move towards the input based on the turn_str
	skate_force.x = lerp(skate_force.x,move_direction_v2.x,turn_str)
	skate_force.y = lerp(skate_force.y,move_direction_v2.y,turn_str)
	
	#turn to face the directon you're going
	rotation.y = Vector2(-skate_force.x,skate_force.y).angle() 
	skate_force.x *-1
	skate_force.normalized()
	

func update_turn_force(move_direction:Vector3):
	# make you turn less when you're going faster

	pass


func update_visualizers(move_direction:Vector3):
	inputVisual.visible = (input_vector != Vector3.ZERO)
	veloVisual.transform = transform
	inputVisual.transform = transform
	veloVisual.rotation.y = Vector2(-skate_force.x,skate_force.y).angle() 
	var yfliped_move_vector = Vector2(move_direction.x, -move_direction.z)
	var visual_move_direction_angle = Vector2(yfliped_move_vector.x,yfliped_move_vector.y).angle()
	inputVisual.rotation.y = visual_move_direction_angle
	#print(visual_move_direction_angle)

func aim():
	if Input.is_action_pressed("toggle_aim"):
		CameraRig._state_machine.transition_to("Camera/Aim")
	
