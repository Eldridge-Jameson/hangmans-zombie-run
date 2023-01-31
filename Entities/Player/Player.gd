extends KinematicBody2D

signal death
signal gameover

const rise_g = 10
const fall_g = 20
const maxRise = -400
const maxFall = 400
const wallcast_length = 16

onready var StateMachine = $StateMachine
onready var AnimPlayer = $AnimationPlayer
onready var Collision = $Collision
onready var Hitbox = $Hitbox
onready var Hurtbox = $Hurtbox
onready var WallCastLow = $WallCastLow
onready var WallCastHigh = $WallCastHigh
onready var LedgeCast = $LedgeCast

var velocity:Vector2 = Vector2.ZERO
var climbPosition:Vector2 = Vector2.ZERO

var moveDirection:int = 1
var runSpeed:int = 100
var walkSpeed:int = 50
#Set jump relative to G to counteract the first-frame call to host.apply_rise_g().
var jump:int = -rise_g - 275
var accel:int = 5
var decel:int = -5

var faceRight:bool = true


var stateList:PoolStringArray = [
	"Idle",
	"Run",
	"Jump",
	"Fall",
	"Ledge",
	"Climb",
	"Punch",
	"Die",
	"Win"
]

# - - -
# Fundamental Functions
# - - -

func _ready():
	match Global.life:
		0: runSpeed = 80
		4: jump = -rise_g - 275
		1: pass
		2: pass
		3: runSpeed = 65
		4: jump = -rise_g - 230
		5: pass
		6:
			runSpeed = 50
			jump = -rise_g - 200
	
	StateMachine.init(stateList)

func _physics_process(delta: float):
	StateMachine.physics_process(delta)

func _input(event: InputEvent):
	StateMachine.input(event)

func kill():
	StateMachine.change_state("Die")
	
	if Global.get_life() < 6:
		var t = Timer.new()
		t.set_wait_time(2)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		t.queue_free()
	
		Global.increment_life()
		emit_signal("death")
		get_tree().reload_current_scene()
		return
	else:
		emit_signal("gameover")

func timeout():
	StateMachine.change_state("Die")

func win():
	Hurtbox.get_child(0).disabled = true

# - - -
# Getter Functions
# - - -

func get_fall_g():
	return fall_g

func get_ledge_position() -> Vector2:
	return Vector2(WallCastLow.global_position.x + (12 * moveDirection), \
	LedgeCast.get_collision_point().y + 8)



# - - -
# Setter Functions
# - - -

func set_velocity(newVelocity: Vector2):
	velocity = newVelocity

func set_velocity_x(x: int):
	velocity.x = x

func set_velocity_y(y: int):
	velocity.y = y


func set_Collision_active(check: bool):
	Collision.disabled = !check

func set_Hurtbox_active(check: bool):
	Hurtbox.get_child(0).disabled = !check

func set_Hitbox_active(check: bool):
	Hitbox.get_child(0).disabled = !check



func set_climb_position():
	climbPosition = Vector2(global_position.x + (12 * moveDirection), LedgeCast.global_position.y - 6)
	pass



# - - -
# Checker Functions
# - - -

func check_moveInput() -> bool:
	return Input.is_action_pressed("left") != Input.is_action_pressed("right")



func check_maxSpeed_Horizontal(bound:int) -> bool:
	return velocity.x < bound and velocity.x > -bound

func check_maxSpeed_Vertical() -> bool:
	return velocity.x < jump and velocity.x > maxFall



func check_moving_x() -> bool:
	return velocity.x != 0

func check_grounded() -> bool:
	return is_on_floor()

func check_wall() -> bool:
	return is_on_wall()

func check_falling() -> bool:
	return velocity.y > 0

func check_ledge() -> bool:
	return LedgeCast.is_colliding() and WallCastLow.is_colliding() and !WallCastHigh.is_colliding()

func check_floor_under_ledge() -> bool:
	return !$FloorCast.is_colliding()


# - - -
# Movement Functions
# - - -

func move():
	move_and_slide(velocity, Vector2.UP)

func set_moveDirection():
	moveDirection = 0
	if Input.is_action_pressed("left"):
		moveDirection -= 1
		flip_h(true)
	if Input.is_action_pressed("right"):
		moveDirection += 1
		flip_h(false)

func add_velocity(newVelocity:Vector2, direction:int):
	velocity += Vector2(newVelocity.x * direction, newVelocity.y)



func jump():
	set_velocity_y(jump)
	bound_y()

func apply_rise_g():
	add_velocity(Vector2(0, rise_g), moveDirection)
	bound_y()

func apply_fall_g():
	add_velocity(Vector2(0, fall_g), moveDirection)
	bound_y()


# - - -
# Restraining Functions
# - - -

func bound_x():
	if velocity.x > runSpeed:
		velocity.x = runSpeed
	if velocity.x < -runSpeed:
		velocity.x = -runSpeed

func bound_y():
	if velocity.y > maxFall:
		velocity.y = maxFall
	if velocity.y < maxRise:
		velocity.y = maxRise

func clamp_x() -> bool:
	if velocity.x < -decel and velocity.x > decel:
		velocity.x = 0
		return true
	return false



# - - -
# Macros
# - - -

func accelerate():
	add_velocity(Vector2(accel, 0), moveDirection)
	bound_x()

func decelerate():
	if clamp_x():
		return
	if velocity.x < 0:
		add_velocity(Vector2(decel, 0), -1)
		return
	add_velocity(Vector2(decel, 0), 1)

func run():
	set_moveDirection()
	accelerate()

func walk():
	pass

func ledge_grab():
	pass

# - - -
# Animation Functions
# - - -

func play(anim: String):
	AnimPlayer.play(anim)

func flip_h(check: bool):
	$Sprite.flip_h = check
	
	if check:
		Collision.position.x = 1
		Hitbox.position.x = 1
		Hurtbox.position.x = -12
		LedgeCast.position.x = -16
		WallCastLow.cast_to.x = -16
		WallCastHigh.cast_to.x = -16
		return
	
	Collision.position.x = -1
	Hitbox.position.x = -1
	Hurtbox.position.x = 12
	LedgeCast.position.x = 16
	WallCastLow.cast_to.x = 16
	WallCastHigh.cast_to.x = 16

#Signal function to check when player is done climbing.
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Climb_" + String(Global.get_life()):
		global_position = climbPosition
		StateMachine.change_state("Idle")
