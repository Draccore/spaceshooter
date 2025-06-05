extends PlayerState

## Load nodes and Scenes
var bullet = preload("res://Scenes/player_bullet.tscn")
@onready var left_spawn_pos = $"../Weapon/LeftMarker"
@onready var right_spawn_pos = $"../Weapon/RightMarker"


## Can attack yes/no
var attack_ready = true

func enter_state(player_node):
	super(player_node)
	## Attack Speed
	player.weapon_animation.speed_scale = PlayerStats.WPN_ATTACK_SPEED

func handle_input(_delta):
	if Input.is_action_pressed("Shoot"):
		player.weapon_animation.play("Auto_Cannon")

func shoot_left():
	## Func for spawning bullet
		# Instance = spawn bullet
		# Example (instance.(property) = (property value))
	var instance = bullet.instantiate()
	instance.dir = player.rotation + PI/2
	instance.spawnPos = left_spawn_pos.global_position
	instance.spawnRot = player.rotation
	instance.speed = PlayerStats.WPN_SPEED
	instance.player_velocity = player.velocity
		## Spawn bullet
	player.main.add_child.call_deferred(instance)

func shoot_right():
		## Func for spawning bullet
		# Instance = spawn bullet
		# Example (instance.(property) = (property value))
	var instance = bullet.instantiate()
	instance.dir = player.rotation + PI/2
	instance.spawnPos = right_spawn_pos.global_position
	instance.spawnRot = player.rotation
	instance.speed = PlayerStats.WPN_SPEED
	instance.player_velocity = player.velocity
		## Spawn bullet
	player.main.add_child.call_deferred(instance)

func attack_finished():
	player.weapon_sprite.frame = 0
	player.change_state("Idle_State")
