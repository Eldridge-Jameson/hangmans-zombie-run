extends State

func physics_process(delta: float) -> String:
	host.apply_fall_g()
	host.walk()
	
	if !host.check_stopped():
		if host.check_grounded():
			host.set_velocity_y(0)
			if host.check_tracking():
				return "Track"
			return "Patrol"
		
		host.move()
	return ""
