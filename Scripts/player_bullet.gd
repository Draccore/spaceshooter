extends CharacterBody2D

var spawnPos : Vector2
var spawnRot : float
var dir : float
const speed = 500

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot

func _physics_process(delta: float) -> void:
	velocity = Vector2(0, -speed).rotated(dir)
	move_and_slide()
