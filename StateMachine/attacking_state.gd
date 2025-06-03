extends PlayerState


func enter_state(player_node):
	super(player_node)
	print("attacking")

func handle_input(_delta):
	if Input.is_action_pressed("Shoot"):
		print("shooting")
	else:
		player.change_state("Idle_State")
