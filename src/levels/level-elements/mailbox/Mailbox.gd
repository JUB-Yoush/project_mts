extends Spatial

onready var nearArea = $NearArea
onready var tossArea = $TossArea

var player_in_nearArea:bool = false
var delivered_to:= false
signal got_mail

func _ready() -> void:
	nearArea.connect("body_entered",self,"on_nearArea_body_entered")
	nearArea.connect("body_exited",self,"on_nearArea_body_exited")
	tossArea.connect("area_entered",self, "on_tossArea_body_entered")
	connect("got_mail",get_tree().get_current_scene(),"on_mailbox_delivered")

	

# -- delivering mail by going up to the mailbox n such 
func on_nearArea_body_entered(body:PhysicsBody):
	if body.is_in_group("player"):
		var player:Player = body
		player.connect("near_delivery",self, "player_near_delivery")
		player_in_nearArea = true
	
func on_nearArea_body_exited(body:PhysicsBody):
	if body.is_in_group("player"):
		var player:Player = body
		player.disconnect("near_delivery",self, "player_near_delivery")
		player_in_nearArea = false
	
func player_near_delivery():
	#print("mail delivered (bro trust me)")
	delivered_to = true
	emit_signal("got_mail")
	pass
# ------------------------------------

# --- tossing like a cool kid
func on_tossArea_body_entered(area:Area):
	if area.is_in_group("mail") and !delivered_to:
		print('e')
		delivered_to = true
		emit_signal("got_mail")
	
