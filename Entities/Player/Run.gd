extends State

func enter():
	host.set_velocity_y(host.get_fall_g())
	host.play("Run_" + String(Global.get_life()))

func input(event: InputEvent) -> String:
	if Input.is_action_just_pressed("jump"):
		return "Jump"
	if !host.check_moveInput():
		return "Idle"
	return ""

func physics_process(delta: float) -> String:
	host.run()
	
	if host.check_wall():
		host.set_velocity_x(0)
	
	if !host.check_grounded():
		return "Fall"
	
	host.move()
	return ""
