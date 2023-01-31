extends State

func physics_process(delta: float) -> String:
	if !host.check_grounded():
		return "Fall"
	if !host.check_tracking():
		return "Patrol"

	if !host.check_stopped():
		host.move_toward_player()
		host.walk()
		host.clamp_track()
	
		host.move()
	return ""
