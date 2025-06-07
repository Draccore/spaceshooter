extends PlayerState

# ---[ Load nodes and scenes ]---
var bullet_scene = preload("res://Scenes/player_bullet.tscn")
@onready var left_spawn_pos = $"../Weapon/LeftMarker"
@onready var right_spawn_pos = $"../Weapon/RightMarker"

var attack_ready := true

func enter_state(player_node):
	super(player_node)
	player.weapon_animation.speed_scale = PlayerStats.WPN_ATTACK_SPEED

func handle_input(_delta):
	if Input.is_action_pressed("Shoot"):
		player.weapon_animation.play("Auto_Cannon")

func shoot_left():
	_spawn_bullet(left_spawn_pos.global_position)

func shoot_right():
	_spawn_bullet(right_spawn_pos.global_position)

func _spawn_bullet(spawn_pos: Vector2):
	var instance = bullet_scene.instantiate()
	instance.dir = player.rotation + PI / 2
	instance.spawn_pos = spawn_pos
	instance.spawn_rot = player.rotation
	instance.speed = PlayerStats.WPN_SPEED
	instance.player_velocity = player.velocity
	player.main.add_child.call_deferred(instance)

func attack_finished():
	player.weapon_sprite.frame = 0
	player.change_state("Idle_State")
