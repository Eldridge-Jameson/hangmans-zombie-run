extends CanvasLayer

func change_time(time:int):
	$ColorRect/Label.text = String(time)

func play(anim: String):
	$AnimationPlayer.play(anim)
