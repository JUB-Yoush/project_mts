extends Node

onready var mailboxes := $Mailboxes
var mailbox_count:int
var mail_delivered:int = 0
var quota_reached:bool
var mailbox_score_value:int = 150
var score:int
var time := 0.0
var player_respawn_position:Position3D
onready var player:Player = get_node("Player")
func _ready() -> void:
	player_respawn_position = $SpawnPos
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mailbox_count = mailboxes.get_child_count()
	time = 0
	$CanvasLayer/UI/Panel/VBoxContainer/MailLabel.text = ("MAIL: %d/%d" % [mail_delivered,mailbox_count])

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) 
				
	if event.is_action_pressed("toggle_mouse_captured"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) 
		get_tree().set_input_as_handled()

func on_mailbox_delivered():
	mail_delivered += 1
	score += mailbox_score_value
	$CanvasLayer/UI/Panel/VBoxContainer/MailLabel.text = ("MAIL: %d/%d" % [mail_delivered,mailbox_count])
	var zeroes = 8 - str(score).length()
	var score_str = ""
	for x in range (zeroes):
		 score_str += "0"
	score_str += str(score)
	$CanvasLayer/UI/Panel/VBoxContainer/ScoreLabel.text = ("SCORE: %s" % [score_str])
	quota_reached = (mail_delivered >= mailbox_count/2)
	print(mail_delivered >= mailbox_count/2)
	if quota_reached:
		$Goal.visible = true
	#print('yay mail')

func on_player_reached_goal():
	if quota_reached:
		print('yaa you did it level over')
		$CanvasLayer/UI.display_results()
		#display the results screen
	else:
		print('not enough')

func _process(delta: float) -> void:
	if player.is_aiming:
		time += (delta*5)
	else: 
		time+= delta 
	var ms = fmod(time,1)*1000
	var seconds = fmod(time,60)
	var minutes = fmod(time, 3600) / 60
	$CanvasLayer/UI/Panel/VBoxContainer/TimeLabel.text = ("TIME: %02d:%02d.%02d" % [minutes, seconds,ms])
	#var str_elapsed = "%02d : %02d.%02d" % [minutes, seconds,ms]
	#print("elapsed : ", str_elapsed)

func player_passed_checkpoint(position:Position3D):
	player_respawn_position = position
	pass

func respawn_player():
	player.velocity = Vector3.ZERO
	player.global_transform = player_respawn_position.global_transform
