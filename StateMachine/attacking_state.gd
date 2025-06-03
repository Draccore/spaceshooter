extends PlayerState

var bullet = preload("res://Scenes/player_bullet.tscn")


func enter_state(player_node):
	super(player_node)
	print("attacking")

func handle_input(_delta):
	if Input.is_action_pressed("Shoot"):
		shoot()
	else:
		player.change_state("Idle_State")

func shoot():
	var instance = bullet.instantiate()
	instance.dir = player.rotation
	instance.spawnPos = player.global_position
	instance.spawnRot = player.rotation
	player.main.add_child.call_deferred(instance)
	print("shoot")
