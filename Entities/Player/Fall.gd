extends State

func enter():
	host.play("Jump_" + String(Global.get_life()))

func input(event: InputEvent) -> String:
	return ""

func physics_process(delta: float) -> String:
	host.apply_fall_g()
	
	if host.check_moveInput():
		host.run()
	
	if host.check_grounded():
		if host.check_moveInput():
			return "Run"
		return "Idle"
	
	if host.check_ledge() and StateMachine.get_previous() != "Ledge" \
		and host.check_floor_under_ledge():
		host.set_velocity(Vector2(0, host.get_fall_g()))
		return "Ledge"
	
	host.move()
	return ""
