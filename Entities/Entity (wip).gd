extends KinematicBody2D
class_name Entity

const rise_g = 10
const fall_g = 20

const maxRise = 400
const maxFall = 2 * maxRise

var velocity:Vector2 = Vector2.ZERO
var moveDirection:int = 1
var faceRight:bool = true

func check_maxSpeed_Horizontal(bound:int) -> bool:
	return velocity.x < bound and velocity.x > -bound

func check_maxSpeed_Vertical() -> bool:
	return velocity.x < maxRise and velocity.x > maxFall



func check_moving_x() -> bool:
	return velocity.x != 0

func check_grounded() -> bool:
	return is_on_floor()

func check_falling() -> bool:
	return velocity.y > 0



func move():
	move_and_slide(velocity, Vector2.UP)

func set_moveDirection():
	moveDirection = 0
	if Input.is_action_pressed("left"):
		moveDirection -= 1
	if Input.is_action_pressed("right"):
		moveDirection += 1
