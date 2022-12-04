extends Path

onready var player = get_parent().get_node("Player")
onready var railFollow = $RailFollow
onready var followTarget := $FollowTarget
var player_riding:= false


func _physics_process(delta: float) -> void:
	followTarget.global_transform.origin = player.global_transform.origin
	if not railFollow.player_riding: 
		railFollow.set_offset(curve.get_closest_offset(followTarget.get_translation()))
		#railFollow.offset = curve.get_closest_offset(transform.origin - player.transform.origin)
		
	#print(railFollow.offset)
	#print(player.rotation - rotation)
	#railFollow.offset = curve.get_closest_offset(player.global_translation)
	

