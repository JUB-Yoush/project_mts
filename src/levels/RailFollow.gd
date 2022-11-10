extends PathFollow


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
onready var area := $RailFollowArea
onready var remoteTransform = $RemoteTransform
onready var player :Player
var player_xz_velocity:Vector2
var railgrind_speed:float

#when body entered:
# make sure body is player
# check that the player is hitting from the bottom (maybe make a feet hitbox?)
# use remote transform to change the players tranformation
# check the players velocity to check what direction they should travel in
# move them until they jump to cancel it or they reach the end of the rail



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area.connect("body_entered",self,"on_body_entered")
	pass # Replace with function body.


func on_body_entered(body:PhysicsBody):
	if body.is_in_group("player"):
		print('player touched me')
		player = body
		get_parent().player_riding = true
		player._state = Player.States.ON_RAIL
		remoteTransform.remote_path = NodePath("../../../Player")
		
		
func _physics_process(delta: float) -> void:
	if get_parent().player_riding:
		player_xz_velocity = Vector2(player.velocity.x,player.velocity.z)
		prints(player_xz_velocity)
		offset += player_xz_velocity.y /5

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
