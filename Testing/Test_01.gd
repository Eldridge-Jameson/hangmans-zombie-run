extends Node2D

func _ready():
	pass

func _enter_tree():
	if Global.get_spawnActive():
		$Player.global_position = Global.spawnpoint
