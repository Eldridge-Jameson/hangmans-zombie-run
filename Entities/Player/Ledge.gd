extends State

func enter():
	host.position = host.get_ledge_position()
	host.set_climb_position()
	host.play("Ledge_" + String(Global.get_life()))

func input(event: InputEvent) -> String:
	if Input.is_action_just_pressed("jump"):
		return "Climb"
	if Input.is_action_just_pressed("down"):
		return "Fall"
	return ""

func physics_process(delta: float) -> String:
	return ""
