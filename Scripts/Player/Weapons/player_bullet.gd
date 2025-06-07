extends CharacterBody2D

var spawn_pos: Vector2
var spawn_rot: float
var dir: float
var speed: float
var player_velocity: Vector2 = Vector2.ZERO

func _ready():
	global_position = spawn_pos
	global_rotation = spawn_rot
	# Bullet lifetime: 10 seconds
	await get_tree().create_timer(10).timeout
	queue_free()

func _physics_process(_delta: float) -> void:
	# Get bullet forward direction from its rotation/dir
	var fire_direction := Vector2(0, -1).rotated(dir).normalized()
	# Project player velocity onto bullet's forward vector
	var player_forward_speed := player_velocity.dot(fire_direction)
	# Adjust bullet speed based on player movement: faster if moving forward, slower if backward
	var adjusted_speed := speed + player_forward_speed
	if player_forward_speed < 0:
		adjusted_speed = max(adjusted_speed, speed * 0.5)
	# Apply velocity
	velocity = fire_direction * adjusted_speed
	move_and_slide()
