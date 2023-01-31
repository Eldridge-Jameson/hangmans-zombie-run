extends Node2D


func _on_Goal_body_entered(body):
	
	if body == $Player:
		get_tree().change_scene("res://Endings/Ending_" + String(Global.get_life()) + ".tscn")
