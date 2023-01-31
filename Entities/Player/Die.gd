extends State

func enter():
	host.play("Die_" + String(Global.get_life()))

func physics_process(delta: float) -> String:
	if host.check_moving_x():
		host.decelerate()
		
	host.move()
	return ""
