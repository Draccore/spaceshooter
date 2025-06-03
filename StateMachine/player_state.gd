extends Node
# This is the base class for all the player states.
class_name PlayerState
# Reference to the player node that is controlled by this state
var player
# Called when entering this state.
func enter_state(player_node):
	player = player_node

# Called when exiting this state.
func exit_state():
	pass

func hande_input(_delta):
	pass # No input handling in the base state,
	# each specific state will implement its own input handling
