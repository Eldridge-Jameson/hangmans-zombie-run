extends Node

var spawnpoint: Vector2 = Vector2.ZERO

var life:int = 0
var timer_value:int = 180

var spawnActive:bool = false



func init():
	spawnpoint = Vector2.ZERO
	life = 0
	timer_value = 180
	spawnActive = false



# - - -
# Getter Functions
# - - -

func get_life() -> int:
	return life

func get_spawnActive() -> bool:
	return spawnActive



# - - -
# Spawnpoint and Life Functions
# - - -

func increment_life():
	life += 1

func update_spawn(new: Vector2):
	spawnpoint = new
	spawnActive = true

