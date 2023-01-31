extends Node
class_name State

onready var StateMachine = get_parent()
onready var host = StateMachine.get_parent()
var nextState:String = ""

func enter():
	pass

func exit():
	pass

func input(event: InputEvent) -> String:
	return ""

func process(delta: float) -> String:
	return ""

func physics_process(delta: float) -> String:
	return ""
