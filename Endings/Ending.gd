extends Control

func _input(event: InputEvent):
	if Input.is_action_just_pressed("accept"):
		get_tree().change_scene("res://HUD/MainMenu.tscn")
