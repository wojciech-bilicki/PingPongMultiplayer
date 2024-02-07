extends Control

const MAX_PLAYER = 2

@export var address = "127.0.0.1"
@export var port = 8080

@onready var host_button = $HostButton
@onready var join_button = $JoinButton
@onready var start_server_button = $StartServerButton
@onready var line_edit = $LineEdit


var peer

# Called when the node enters the scene tree for the first time.
func _ready():
	host_button.pressed.connect(on_host_button_pressed)
	join_button.pressed.connect(on_join_button_pressed)
	start_server_button.pressed.connect(on_start_server_button_pressed)
	
	multiplayer.peer_connected.connect(on_peer_connected)
	multiplayer.peer_disconnected.connect(on_peer_disconnected)
	multiplayer.connected_to_server.connect(on_connected_to_server)
	multiplayer.connection_failed.connect(on_connection_failed)
	
func on_host_button_pressed():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, MAX_PLAYER)
	if error != OK:
		print('cannot host: ' + error)
		return
	
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	print("waiting for players")
	send_player_info(line_edit.text, multiplayer.get_unique_id())
	
	
func on_join_button_pressed():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)

func on_start_server_button_pressed():
	start_game.rpc()

@rpc("any_peer", "call_local")
func start_game():
	var scene = load("res://Scenes/main.tscn").instantiate()
	get_tree().root.add_child(scene)
	hide()

@rpc("any_peer")
func send_player_info(name, id):
	if !GameManager.Players.has(id):
		GameManager.Players[id] = {
			"name": name,
			"id": id,
			"score": 0
		}
	
	if multiplayer.is_server():
		for i in GameManager.Players:
			send_player_info.rpc(GameManager.Players[i].name, i)
		

func on_peer_connected(id):
	print('Player connected ' + str(id))
	
func on_peer_disconnected(id):
	print('Player disconnected ' + str(id))

func on_connected_to_server():
	print('Connected to server')
	send_player_info.rpc_id(1, line_edit.text, multiplayer.get_unique_id())
	
func on_connection_failed():
	print('Couldnt connect')
