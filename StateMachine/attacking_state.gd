extends PlayerState

## Load nodes and Scenes
var bullet = preload("res://Scenes/player_bullet.tscn")
@onready var left_spawn_pos = $"../Weapon/LeftMarker"
@onready var right_spawn_pos = $"../Weapon/RightMarker"

## Stats for bullet
@export var speed = 200
@export var cooldown = 0.5
@export var damage = 10

## Stats for player attack
@export var attack_speed = 1   # 1 = default

## Can attack yes/no
var attack_ready = true

func enter_state(player_node):
	super(player_node)
	## Attack Speed
	player.weapon_animation.speed_scale = attack_speed

func handle_input(_delta):
	if Input.is_action_pressed("Shoot"):
		if attack_ready == true:
			pass
			#shoot()
		player.weapon_animation.play("Auto_Cannon")

func shoot_left():
	## Func for spawning bullet
		# Instance = spawn bullet
		# Example (instance.(property) = (property value))
	var instance = bullet.instantiate()
	instance.dir = player.rotation + PI/2
	instance.spawnPos = left_spawn_pos.global_position
	instance.spawnRot = player.rotation
	instance.speed = speed
		## Spawn bullet
	player.main.add_child.call_deferred(instance)
		# Sets attack_ready to false and starts timer for attack cooldown

func shoot_right():
		## Func for spawning bullet
		# Instance = spawn bullet
		# Example (instance.(property) = (property value))
	var instance = bullet.instantiate()
	instance.dir = player.rotation + PI/2
	instance.spawnPos = right_spawn_pos.global_position
	instance.spawnRot = player.rotation
	instance.speed = speed
		## Spawn bullet
	player.main.add_child.call_deferred(instance)
		# Sets attack_ready to false and starts timer for attack cooldown

func attack_finished():
	player.weapon_sprite.frame = 0
	player.change_state("Idle_State")
