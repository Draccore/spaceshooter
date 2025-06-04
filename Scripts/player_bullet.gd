extends CharacterBody2D

var spawnPos : Vector2
var spawnRot : float
var dir : float
var speed : float
var player_velocity : Vector2 = Vector2.ZERO
var min_speed : float = 200   
var max_speed : float = 1000  

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot

func _physics_process(delta: float) -> void:
	var fire_direction = Vector2(0, -1).rotated(dir).normalized()
	# Project player velocity onto the fire direction
	var player_forward_vel = fire_direction * player_velocity.dot(fire_direction)
	# Compute bullet's intended velocity
	var total_velocity = fire_direction * speed + player_forward_vel
	var speed_magnitude = total_velocity.length()
	
	# Clamp the magnitude
	if speed_magnitude < min_speed:
		total_velocity = total_velocity.normalized() * min_speed
	elif speed_magnitude > max_speed:
		total_velocity = total_velocity.normalized() * max_speed
	
	velocity = total_velocity
	move_and_slide()
