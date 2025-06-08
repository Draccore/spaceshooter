extends Node2D


func _ready():
	var spawner = $EnemySpawner
	spawner.start_spawning()
