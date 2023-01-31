extends Control

func _ready():
	Global.init()

func _input(event: InputEvent):
	if Input.is_action_just_pressed("accept"):
		get_tree().change_scene("res://HUD/ControlScreen.tscn")

func _on_Timer_timeout():
	$Label.visible = !$Label.visible
