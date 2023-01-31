extends State

func physics_process(delta: float) -> String:
	if !host.check_grounded():
		return "Fall"
	if host.check_tracking():
		return "Track"
	
	if !host.check_stopped():
		host.set_moveDirection()
		host.walk()
	
		host.move()
	return ""
