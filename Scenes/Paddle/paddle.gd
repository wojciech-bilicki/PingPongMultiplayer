extends RigidBody2D

@export var speed = 500
@export var goal_velocity: Vector2


func _ready():
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())

func _physics_process(delta):

	if $MultiplayerSynchronizer.get_multiplayer_authority() != multiplayer.get_unique_id():
		linear_velocity = goal_velocity
		return
		
	var movement = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		movement = Vector2.UP
	elif Input.is_action_pressed("move_down"):
		movement = Vector2.DOWN
	
	linear_velocity = movement * speed;
	goal_velocity = linear_velocity
