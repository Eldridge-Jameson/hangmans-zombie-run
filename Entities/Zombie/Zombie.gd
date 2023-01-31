extends KinematicBody2D

const fall_g = 20

const maxRise = -400
const maxFall = 400

const walkSpeed = 30

onready var StateMachine = $StateMachine
onready var AnimPlayer = $AnimationPlayer
onready var FOV = $FieldOfView


var player:KinematicBody2D = null

var velocity:Vector2 = Vector2.ZERO

var moveDirection:int = -1

export var faceRight:bool = false
var stunned:bool = false
var stopped:bool = true

var stateList:PoolStringArray = [
	"Patrol",
	"Track",
	"Fall"
]

# - - -
# Fundamental Functions
# - - -

func _ready():
	StateMachine.init(stateList)
	face_direction()

func _physics_process(delta: float):
	StateMachine.physics_process(delta)

func _input(event: InputEvent):
	StateMachine.input(event)

func kill():
	queue_free()

func stop():
	stopped = true



# - - -
# Checker Functions
# - - -

func check_grounded() -> bool:
	return is_on_floor()

func check_hit_wall() -> bool:
	return is_on_wall()

func check_tracking() -> bool:
	return player != null

func check_stopped():
	return stopped


# - - -
# Movement Functions
# - - -

func move():
	move_and_slide(velocity, Vector2.UP)



func set_moveDirection():
	if check_hit_wall():
		moveDirection *= -1
		faceRight = !faceRight

# Get player position and change moveDirection to face toward them.
func move_toward_player():
	if player.position.x < position.x:
		moveDirection = -1
		faceRight = false
		return
	if player.position.x > position.x:
		moveDirection = 1
		faceRight = true
		return
	moveDirection = 0



func add_velocity(newVelocity:Vector2):
	velocity += Vector2(newVelocity.x * moveDirection, newVelocity.y)

func set_velocity(newVelocity: Vector2):
	velocity = newVelocity

func set_velocity_x(x: int):
	velocity.x = x

func set_velocity_y(y: int):
	velocity.y = y



func apply_fall_g():
	add_velocity(Vector2(0, fall_g))
	bound_y()



# - - -
# Tracking Functions
# - - -

func set_player(p):
	player = p



# - - -
# Restraining Functions
# - - -

func bound_y():
	if velocity.y > maxFall:
		velocity.y = maxFall
	if velocity.y < maxRise:
		velocity.y = maxRise

func clamp_patrol():
	return

func clamp_track():
	if player.position.x < position.x + walkSpeed \
	and player.position.x > position.x - walkSpeed:
		velocity.x = 0

# - - -
# Macros
# - - -

func walk():
	face_direction()
	set_velocity_x(walkSpeed * moveDirection)



# - - -
# Animation Functions
# - - -

func play(anim: String):
	AnimPlayer.play(anim)

func face_direction():
	if faceRight:
		moveDirection = abs(moveDirection)
		play("Right")
		return
	if !faceRight:
		moveDirection = abs(moveDirection) * -1
		play("Left")



# - - -
# Signal Functions
# - - -

func _on_FieldOfView_body_entered(body):
	player = body

func _on_TrackingRadius_body_exited(body):
	player = null

#func _on_Hurtbox_body_entered(body):
#	if body.name == "Player" and StateMachine.current_state_string == "Track":
#		body.kill()

func _on_VisibilityNotifier2D_screen_entered():
	stopped = false

func _on_VisibilityNotifier2D_screen_exited():
	stopped = true


func _on_Hurtbox_area_entered(area):
	if area.name == "Hitbox" and area.get_parent().name == "Player":
		area.get_parent().kill()
