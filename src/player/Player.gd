extends KinematicBody
class_name Player

onready var camera:CameraRig = $CameraRig
onready var inputVisual: = get_parent().get_node("DebugArrows/InputVisual")
onready var veloVisual: = get_parent().get_node("DebugArrows/VeloVisual")


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

enum States{
	MOVING,
	IN_AIR,
	ON_RAIL,
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
	
	#you always start by moving forward regardless of inputted direction.
	# inputting past 90deg to the left or right  when stopped will turn you around to face backwards and then move in that direction
	# the allowed inputs are greater when you're moving, maybe like a 30deg radius around the opposite direction of where you're current velocity is
	# but if you hit backwards while moving you'll break
	#you start by moving forward then begin to rotate towards the input direction, it will stop rotating once they're about the same 
	#the speed at which you rotate is based on your current speed, going faster means you turn slower
	
	# Current issues:
	# - 
	
	
	#---JUMPING---
	# retain velocity
	# very minimal movement influence
	
	match _state:
		States.MOVING:
			state_moving(delta)
		States.IN_AIR:
			state_in_air(delta)
		States.ON_RAIL:
			state_on_rail(delta)
		States.FLIGHT:
			state_flight(delta)

	
	
	
# -------------------- states----------------------------
func state_moving(delta:float):
	input_vector = get_input_vector()
	var move_direction := make_relative_input_vector(input_vector)
	

	update_skate_force(move_direction)
	update_turn_force(move_direction)
	update_visualizers(move_direction)

	var skate_force_v3 := Vector3(skate_force.x * speed,velocity.y,skate_force.y * speed)
	velocity =  skate_force_v3 

	if is_on_floor() and Input.is_action_pressed("jump"):
		velocity.y += jump_impulse
		

	if is_on_floor() and velocity.y == 0: velocity.y = 0
	else: velocity.y -= gravity * delta
		

	velocity = move_and_slide(velocity,Vector3.UP)
	
	
	if not is_on_floor(): _state = States.IN_AIR
	
	if Input.is_action_just_pressed("toggle_flight"):
		$CollisionShape.disabled = true
		_state = States.FLIGHT
	
#---
func state_in_air(delta:float):
	update_visualizers(move_direction)
	velocity.y -= gravity * delta
	
	input_vector = get_input_vector()
	var move_direction := make_relative_input_vector(input_vector)
	
	move_and_slide(velocity + (move_direction * air_drift),Vector3.UP)
	
	if is_on_floor(): _state = States.MOVING
	
	if Input.is_action_just_pressed("toggle_flight"):
		$CollisionShape.disabled = true
		_state = States.FLIGHT
	
#---
func state_on_rail(delta:float):
	if Input.is_action_pressed("jump"):
		_state = States.IN_AIR
		velocity.y += jump_impulse
	pass
#---
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
		print('bean')
		_state = States.IN_AIR
		$CollisionShape.disabled = false
	pass
	
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
	#prints("md:",move_direction,"sf:",skate_force)

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
