extends State

func enter():
	host.jump()
	host.play("Jump_" + String(Global.get_life()))

func input(event: InputEvent) -> String:
	return ""

func physics_process(delta: float) -> String:
	host.apply_rise_g()
	
	if host.check_moveInput():
		host.run()
	
	if host.check_falling() or !Input.is_action_pressed("jump"):
		return "Fall"
	
	host.move()
	return ""
