extends Path

onready var player = get_parent().get_node("Player")
onready var railFollow = $RailFollow
onready var startPos: = $StartPosition
onready var endPos: = $EndPosiiton
var length_vector:Vector3
var player_riding:= false

func _ready() -> void:
	length_vector = endPos.global_translation - startPos.global_translation
	print(length_vector)

func _physics_process(delta: float) -> void:
	#print(curve.get_closest_offset(player.global_translation))
	if not player_riding: 
		railFollow.offset = curve.get_closest_offset(player.global_translation)
	print(railFollow.offset)
	#railFollow.offset = curve.get_closest_offset(player.global_translation)
	

