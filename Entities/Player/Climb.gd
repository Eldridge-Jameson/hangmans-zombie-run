extends State

func enter():
	host.play("Climb_" + String(Global.get_life()))

func physics_process(delta: float) -> String:
	return ""
