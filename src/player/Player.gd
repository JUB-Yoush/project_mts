extends KinematicBody

onready var camera:CameraRig = $CameraRig
onready var inputVisual: = get_parent().get_node("DebugArrows/InputVisual")
onready var veloVisual: = get_parent().get_node("DebugArrows/VeloVisual")


var velocity: = Vector3.ZERO


var speed:= 7.0
var steer_angle: = 2.0
var turn_str: = 0.05
var skate_force: = Vector2.ZERO


func _ready() -> void:
	inputVisual.transform.basis = Basis.IDENTITY

static func get_input_vector() -> Vector3:
	var iv =  Input.get_vector("move_left", "move_right", "move_front", "move_back")
	return Vector3(iv.x,0.0,iv.y)


func _physics_process(delta: float) -> void:
	veloVisual.transform = transform
	inputVisual.transform = transform
	
	## MAKE UP UP FIRST DUDE COMAOASDIFJUPAWEIAPJSDF
	
	#you always start by moving forward regardless of inputted direction.
	# inputting past 90deg to the left or right  when stopped will turn you around to face backwards and then move in that direction
	# the allowed inputs are greater when you're moving, maybe like a 30deg radius around the opposite direction of where you're current velocity is
	# but if you hit backwards while moving you'll break
	#you start by moving forward then begin to rotate towards the input direction, it will stop rotating once they're about the same 
	#the speed at which you rotate is based on your current speed, going faster means you turn slower
	
	var input_vector: = get_input_vector()
	
	inputVisual.visible = (input_vector != Vector3.ZERO)
	
	var forwards:Vector3 = camera.global_transform.basis.z * input_vector.z
	var right:Vector3 = camera.global_transform.basis.x * input_vector.x
	
	var move_direction := forwards + right
	move_direction.y = 0.0
	if move_direction.length() > 1.0:
		move_direction = move_direction.normalized()
	#print(move_direction)
	update_visualizers(move_direction)
	update_skate_force(move_direction)
	var skate_force_v3 := Vector3(skate_force.x,0,skate_force.y)
	velocity =  skate_force_v3 * speed
	velocity = move_and_slide(velocity)
	#turn_str = turn_str/velocity.length()
	print(turn_str)
	#turn_str = (turn_str / velocity.length() * 10)
	# velocity:
	# you always start moving forward, and you turn towards the input based on a turning power untill they're "the same" (they're floats)
	
func update_skate_force(move_direction:Vector3):	
	if skate_force == Vector2.ZERO:skate_force = Vector2.UP.rotated(rotation.y)
	var move_direction_v2 := Vector2(move_direction.x,move_direction.z).normalized()
	
	#print(skate_force - move_direction_v2)
	#if (skate_force - move_direction_v2) > Vector2(0.005,0.005):
	skate_force.x = lerp(skate_force.x,move_direction_v2.x,turn_str)
	skate_force.y = lerp(skate_force.y,move_direction_v2.y,turn_str)
	
	#skate_force.y += (move_direction_v2.y/1)
	veloVisual.rotation.y = Vector2(-skate_force.x,skate_force.y).angle() 
	rotation.y = Vector2(-skate_force.x,skate_force.y).angle() 
	skate_force.x *-1
	skate_force.normalized()
	#prints("md:",move_direction,"sf:",skate_force)
	
func update_visualizers(move_direction:Vector3):
	var yfliped_move_vector = Vector2(move_direction.x, -move_direction.z)
	var visual_move_direction_angle = Vector2(yfliped_move_vector.x,yfliped_move_vector.y).angle()
	inputVisual.rotation.y = visual_move_direction_angle
	#print(visual_move_direction_angle)
