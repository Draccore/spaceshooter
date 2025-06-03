extends CharacterBody2D

## Variables for stats
const FRICTION : float = 5
const ACCEL : float = 5
var MAX_SPEED : float = 600

var input = Vector2.ZERO

## Variables for code
var current_state
@onready var player_sprite: Sprite2D = $Sprite2D

func _ready():
	change_state("Idle_State") # Start in the Idle state

## Handles the changing of states
func change_state(new_state_name: String):
	if current_state:
		current_state.exit_state() # Exit the current state
	current_state = get_node(new_state_name)
	if current_state: # Ensure the new state exists
		current_state.enter_state(self) # Enter the new state 

func _physics_process(delta: float) -> void:
	## Rotate player to face mouse and set direction to mouse
	rotate(get_angle_to(get_global_mouse_position()))
	var direction = (get_angle_to(get_global_mouse_position()))
	
		## Get Input
	var input = Vector2(
		Input.get_action_strength("Right") - Input.get_action_strength("Left"),
		Input.get_action_strength("Down") - Input.get_action_strength("Up")
	).normalized()
	
	# Add Acceleration or friction if input is active or not
	var lerp_weight = delta * (ACCEL if input else FRICTION)
	# Calculate velocity using lerp
	velocity = lerp(velocity, input * MAX_SPEED, lerp_weight)
	
	
	##State
	# Ensure a State is active
	if current_state:
		current_state.handle_input(delta)
	## Function to enable movement
	move_and_slide()
