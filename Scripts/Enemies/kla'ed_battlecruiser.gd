extends CharacterBody2D

@export var speed: float = 150.0
@export var player_path: NodePath = "root/Player" # <-- Change to match your scene

func _physics_process(delta):
	var player = get_node(player_path)
	if player:
		var to_player = player.global_position - global_position
		var direction = to_player.normalized()
		velocity = direction * speed
		move_and_slide()
		
		# Rotate towards player
		rotation = lerp_angle(rotation, direction.angle(), delta * 5.0)
