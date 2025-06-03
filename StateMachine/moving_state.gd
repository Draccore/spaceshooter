extends PlayerState

func enter_state(player_node):
	super(player_node) # Correct way to call the parent class method

func handle_input(delta):
	### Get Input
	#var direction = Vector2(
		#Input.get_action_strength("Right") - Input.get_action_strength("Left"),
		#Input.get_action_strength("Down") - Input.get_action_strength("Up")
	#).normalized()
	#
	## Add Acceleration or friction if input is active or not
	#var lerp_weight = delta * (player.ACCEL if direction else player.FRICTION)
	## Calculate velocity using lerp
	#player.velocity = lerp(player.velocity, direction * player.MAX_SPEED, lerp_weight)
	
	#if !direction:
		#player.change_state("Idle_State")
	pass
