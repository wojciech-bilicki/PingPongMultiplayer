extends CharacterBody2D

class_name Ball

@export var INITIAL_BALL_SPEED = 20

@export var speed_multiplier = 1.02

var ball_speed = INITIAL_BALL_SPEED
@export var goal_velocity = Vector2()


func _ready():
	reset_ball()

func _physics_process(delta):
	
	if !is_multiplayer_authority():
		return
		velocity = goal_velocity
	else:
		goal_velocity = velocity

	var collision = move_and_collide(velocity * ball_speed * delta)
	
	if collision:
		bounce.rpc(collision.get_normal())
	

@rpc("any_peer", "call_local")
func bounce(normal: Vector2):
	velocity =  velocity.bounce(normal) * speed_multiplier

func reset_ball():
	var start_velocity = Vector2.ZERO
	if is_multiplayer_authority():
		randomize()
		start_velocity.x = [-1, 1][randi() % 2] * INITIAL_BALL_SPEED
		start_velocity.y = [-.8, .8][randi() % 2] * INITIAL_BALL_SPEED
		start_ball.rpc(start_velocity)
		
@rpc("any_peer", "call_local")		
func start_ball(start_velocity: Vector2):
	global_position = Vector2.ZERO
	velocity = start_velocity
	goal_velocity = start_velocity
