extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

onready var energyLabel: = $Panel/VBoxContainer/EnergyLabel
onready var stateLabel: = $Panel/VBoxContainer/StateLabel
onready var player = get_parent().get_parent().get_node("Player")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.connect("energy_changed",self,"on_player_energy_changed")
	player.connect("state_changed",self,"on_player_state_changed")
	pass # Replace with function body.


func on_player_energy_changed(energy:float):
	energyLabel.text = "ENERGY: %.1f/100.0" %energy

func on_player_state_changed(state:int):
	stateLabel.text = "STATE: %d" %state
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
