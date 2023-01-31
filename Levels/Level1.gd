extends Node2D

var gameover = false

func _ready():
	$Timer.start(Global.timer_value)
	$Player.connect("death", self, "_on_Player_death")
	$Player.connect("gameover", self, "_on_Player_gameover")
	pass

func _enter_tree():
	if Global.get_spawnActive():
		$Player.global_position = Global.spawnpoint

func _physics_process(delta: float):
	$HUD.change_time($Timer.time_left)
	pass



func _on_Goal_body_entered(body):
	for i in $Zombies.get_children():
		i.stop()
	
	if body == $Player:
		$Player.win()
		$HUD.play("Fade to Black")
		
		var t = Timer.new()
		t.set_wait_time(5)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		t.queue_free()
		
		get_tree().change_scene("res://Endings/Ending_" + String(Global.get_life()) + ".tscn")

func _on_Player_death():
	Global.timer_value = $Timer.time_left
	pass

func _on_Player_gameover():
	if !gameover:
		gameover = true
		$HUD.play("Fade to Red")
		
	var t = Timer.new()
	t.set_wait_time(5)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	
	get_tree().change_scene("res://Endings/Death_Zombie.tscn")

func _on_Timer_timeout():
	$Player.timeout()
	
	if !gameover:
		gameover = true
		$HUD.play("Fade to Green")
	
	var t = Timer.new()
	t.set_wait_time(5)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	
	get_tree().change_scene("res://Endings/Death_Timeout.tscn")
