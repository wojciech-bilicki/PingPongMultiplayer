extends Node2D


@export var player_points = 0
@export var enemy_points = 0

@onready var ball = $Ball
@onready var UI = $UI

@export var player_scene:PackedScene =  preload("res://Scenes/Paddle/paddle.tscn")

func _ready():
	var index = 0
	for i in GameManager.Players:
		var current_player = player_scene.instantiate()
		current_player.name = str(GameManager.Players[i].id)
		add_child(current_player)
		for spawn in get_tree().get_nodes_in_group("PlayerSpawns"):
			
			if spawn.name == str(index):
				
				current_player.global_position = spawn.global_position
		index += 1

func enemy_scored():
	update_enemy_scored.rpc()

@rpc("any_peer", "call_local")
func update_enemy_scored():
	enemy_points += 1
	UI.update_enemy_points(enemy_points)
	reset_game_state()

func player_scored():
	update_player_scored.rpc()

@rpc("any_peer", "call_local")
func update_player_scored():
	player_points += 1
	UI.update_player_point(player_points)
	reset_game_state()
	
func reset_game_state():

	ball.reset_ball()
