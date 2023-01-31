extends Area2D

onready var AnimPlayer = $AnimationPlayer

var active:bool = false

func _on_Checkpoint_body_entered(body):
	if body.name == "Player" and !active:
		Global.update_spawn(position)
		active = true
		AnimPlayer.play("Activate")
		AnimPlayer.queue("On")

func deactivate():
	active = false
	AnimPlayer.play_backwards("Activate")
	AnimPlayer.queue("Off")
