extends PathFollow


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
onready var area := $RailFollowArea
onready var remoteTransform = $RemoteTransform
onready var player :Player
var railgrind_speed:float = 0.2
var rail_delta:float
#when body entered:
# make sure body is player
# check that the player is hitting from the bottom (maybe make a feet hitbox?)
# use remote transform to change the players tranformation
# check the players velocity to check what direction they should travel in
# move them until they jump to cancel it or they reach the end of the rail



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area.connect("area_entered",self,"on_area_entered")
	pass # Replace with function body.


func on_area_entered(area:Area):
	player = area.get_parent()
	# get the offset as the collision happens, and then compare it with the collison a little later
	var old_offset := unit_offset
	yield(get_tree().create_timer(0.02),"timeout")
	set_offset(get_parent().curve.get_closest_offset(get_parent().followTarget.get_translation()))
	rail_delta = unit_offset - old_offset 
	print(rail_delta)
	
	
	get_parent().player_riding = true
	player._state = Player.States.ON_RAIL
	remoteTransform.remote_path = NodePath("../../../Player")
		
		
func _physics_process(delta: float) -> void:
	if get_parent().player_riding:
		#prints(player_xz_velocity)
		offset += rail_delta * player.velocity.length() #+ railgrind_speed
	else:
		remoteTransform.remote_path = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


