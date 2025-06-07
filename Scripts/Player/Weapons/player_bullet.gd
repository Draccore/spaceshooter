extends CharacterBody2D

var spawnPos : Vector2
var spawnRot : float
var dir : float
var speed : float
var player_velocity : Vector2 = Vector2.ZERO

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
	await get_tree().create_timer(10).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	# Calculate bullet's forward direction based on its rotation
	var fire_direction = Vector2(0, -1).rotated(dir).normalized()
	
	# Project player velocity onto the bullet's forward direction
	var player_forward_speed = player_velocity.dot(fire_direction)
	
	# Adjust bullet speed based on player movement relative to firing direction
	var adjusted_speed: float
	if player_forward_speed < 0:
		# Moving backward relative to facing, reduce bullet speed but clamp minimum to 25% base speed
		adjusted_speed = max(speed + player_forward_speed, speed * 0.5)
	else:
		# Moving forward or stationary, increase bullet speed by forward velocity
		adjusted_speed = speed + player_forward_speed
	
	# Set bullet velocity vector
	velocity = fire_direction * adjusted_speed
	
	move_and_slide()
