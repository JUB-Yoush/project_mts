extends Node

onready var mailboxes := $Mailboxes
var mailbox_count:int
var mail_delivered:int
var quota_reached:bool
var time := 0.0
onready var player:Player = get_node("Player")
func _ready() -> void:
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
	$CanvasLayer/UI/Panel/VBoxContainer/MailLabel.text = ("MAIL: %d/%d" % [mail_delivered,mailbox_count])
	quota_reached = (mail_delivered == mailbox_count/2)
	print('yay mail')

func on_player_reached_goal():
	if quota_reached:
		print('yaa you did it level over')
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
