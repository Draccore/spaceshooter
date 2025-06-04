extends PlayerState

func enter_state(player_node):
	super(player_node) # Correct way to call the parent class method
	player.engine_effect_animation.play("Base_Engine_Idle")

func exit_state():
	pass

func handle_input(_delta):
	#if Input.get_vector("Left", "Right", "Up", "Down"):
		#player.change_state("Moving_State")
	if Input.is_action_pressed("Shoot"):
		player.change_state("Attacking_State")
