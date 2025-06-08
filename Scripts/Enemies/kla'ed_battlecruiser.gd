extends CharacterBody2D

@export var speed: float = 150.0                 # Max movement speed of the enemy
@export var attack_range: float = 200.0          # Distance at which enemy starts attacking
@export var acceleration: float = 500.0          # How fast enemy accelerates toward target velocity
@export var friction: float = 800.0              # How fast enemy slows down when stopping
@export var player_path: NodePath = "/root/Main/Player"  # Path to the player node

var is_attacking = false                          # Tracks if enemy is in attack mode

func _physics_process(delta):
	var player = get_node_or_null(player_path)
	if not player:
		return  # No player found, skip processing
	
	var to_player = player.global_position - global_position
	var distance = to_player.length()
	var direction = to_player.normalized()
	
	const STOP_THRESHOLD := 10.0  # Buffer zone to smoothly stop near player
	
	if distance > attack_range + STOP_THRESHOLD:
		# Enemy far from player: accelerate toward full speed
		is_attacking = false
		var desired_velocity = direction * speed
		velocity = velocity.move_toward(desired_velocity, acceleration * delta)
		
	elif distance > attack_range:
		# Enemy within stopping buffer zone: decelerate smoothly to avoid bouncing
		is_attacking = false
		var speed_factor = (distance - attack_range) / STOP_THRESHOLD
		var desired_velocity = direction * speed * speed_factor
		velocity = velocity.move_toward(desired_velocity, acceleration * delta)
		
	else:
		# Enemy within attack range: slow down to stop and attack
		is_attacking = true
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		# TODO: Insert attack logic here
	
	move_and_slide()  # Move enemy according to current velocity
	
	# Smoothly rotate enemy to face player with limited rotation speed
	var target_angle = direction.angle()
	const MAX_ROT_SPEED := 5.0  # radians per second
	
	rotation += clamp(
		angle_difference(rotation, target_angle),
		-MAX_ROT_SPEED * delta,
		MAX_ROT_SPEED * delta
	)


# Returns shortest angular difference between two angles (radians)
func angle_difference(from_angle: float, to_angle: float) -> float:
	var diff = fposmod(to_angle - from_angle + PI, 2 * PI) - PI
	return diff
