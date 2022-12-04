extends Node

onready var mailboxes := $MailBox
var mailbox_count:int
var mail_delivered:int
var quota_reached:bool

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mail_delivered = mailboxes.get_child_count()
	

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
	quota_reached = (mail_delivered == mailbox_count/2)
	print('yay mail')

func on_player_reached_goal():
	if quota_reached:
		print('yaa you did it level over')
		#display the results screen
	else:
		print('not enough')
