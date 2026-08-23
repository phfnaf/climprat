extends Node

var current_state = null
var player = null

func init(player_node):
	player = player_node
	# Начинаем с состояния "idle"
	change_to("Idle")

func change_to(state_name):
	if current_state:
		current_state.exit()  # Вызываем функцию выхода из старого состояния
	current_state = get_node(state_name)
	current_state.enter()    # Вызываем функцию входа в новое состояние

func physics_update(delta):
	if current_state:
		current_state.physics_update(delta)

func input(event):
	if current_state:
		current_state.input(event)
