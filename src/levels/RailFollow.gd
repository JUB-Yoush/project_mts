extends PathFollow


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
onready var area := $RailFollowArea
onready var remoteTransform = $RemoteTransform
onready var player:Player = get_parent().get_parent().get_parent().get_node("Player")
var railgrind_speed:float = 0.2
var rail_delta:float
var player_riding:bool = false
var original_rotation = rotation
var game_speed:float = 1
#when body entered:
# make sure body is player
# check that the player is hitting from the bottom (maybe make a feet hitbox?)
# use remote transform to change the players tranformation
# check the players velocity to check what direction they should travel in
# move them until they jump to cancel it or they reach the end of the rail



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area.connect("area_entered",self,"on_area_entered")
	area.connect("area_exited",self,"on_area_exited")
	
	player.connect("left_rail",self,"on_player_left_rail")
	pass # Replace with function body.


func on_area_entered(area:Area):
	if player_riding == false:
		#print('moogus')
		#print('on_area_entered')
		#player = area.get_parent()
		player_riding = true
		# get the offset as the collision happens, and then compare it with the collison a little later
		#player.connect("left_rail",self,"on_player_left_rail")
		
		var old_offset := unit_offset
		yield(get_tree().create_timer(0.02),"timeout")
		set_offset(get_parent().curve.get_closest_offset(get_parent().followTarget.get_translation()))
		rail_delta = sign(unit_offset - old_offset)
		if rail_delta != 0:
			player.set_state(player.States.ON_RAIL)
			remoteTransform.remote_path = NodePath("../../../../Player")
		else:
			on_player_left_rail()
			print(rail_delta)
		
		
		
		
		

func on_area_exited(area:Area):
		#print('on_area_exited')
		#player_riding = false
		#remoteTransform.remote_path = ""
		pass
	

func on_player_left_rail():
	print('player left rail')
	player_riding = false
	remoteTransform.remote_path = ""
	#player.disconnect("left_rail",self,"on_player_left_rail")
	pass


func _physics_process(delta: float) -> void:
	#print(player_riding)
	if player.is_aiming:
		game_speed = 0.2
	else:
		game_speed = 1
		pass
	rotation = original_rotation
	if player_riding:
		offset += ((rail_delta/5 * railgrind_speed) * player.velocity.length()) * game_speed
		
		
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


