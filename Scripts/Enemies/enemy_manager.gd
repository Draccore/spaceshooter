extends Node

var player: Node2D = null
var enemies: Array = []

var active_enemies: Array = []
var semi_active_enemies: Array = []
var idle_enemies: Array = []

const ACTIVE_RANGE_SQ := 1600.0 * 1600.0
const SEMI_ACTIVE_RANGE_SQ := 1200.0 * 1200.0
const CLUSTER_DISTANCE := 100.0  # Max distance between enemies to be clustered

var enemy_clusters: Array = []  # Array of Arrays of enemies
var frame_counter := 0

func set_player(player_node: Node2D) -> void:
	player = player_node
	print("EnemyManager: Player assigned successfully.")

func register_enemy(enemy: Node2D) -> void:
	if enemy and not enemies.has(enemy):
		enemies.append(enemy)

func unregister_enemy(enemy: Node2D) -> void:
	enemies.erase(enemy)

func _process(delta: float) -> void:
	if player == null:
		return

	frame_counter += 1

	# Update groups once per second
	if frame_counter % 60 == 0:
		_update_enemy_groups()

	# Re-cluster active enemies
	_cluster_enemies()

	var clustered_enemies := []

	for cluster in enemy_clusters:
		for enemy in cluster:
			if not is_instance_valid(enemy):
				continue

			clustered_enemies.append(enemy)

			var offset = Vector2(randf_range(-8, 8), randf_range(-8, 8))
			var target_pos = player.global_position + offset

			var raw_dir = target_pos - enemy.global_position
			var dist_to_target = raw_dir.length()
			var deadzone = 5.0

			var direction = raw_dir.normalized() if dist_to_target > deadzone else Vector2.ZERO


			if dist_to_target <= deadzone:
				enemy.velocity = Vector2.ZERO

			enemy.cluster_update(target_pos, direction, delta)

	# Ensure all active enemies are updated
	for enemy in active_enemies:
		if is_instance_valid(enemy) and not clustered_enemies.has(enemy):
			enemy.update_ai(player.global_position, delta)

	# Stagger semi-active updates for performance
	if frame_counter % 2 == 0:
		for i in range(0, semi_active_enemies.size(), 4):
			var enemy = semi_active_enemies[i]
			if is_instance_valid(enemy):
				enemy.update_ai(player.global_position, delta)

func _update_enemy_groups() -> void:
	active_enemies.clear()
	semi_active_enemies.clear()
	idle_enemies.clear()

	for enemy in enemies:
		if not is_instance_valid(enemy):
			continue

		var dist_sq = enemy.global_position.distance_squared_to(player.global_position)

		if dist_sq <= ACTIVE_RANGE_SQ:
			active_enemies.append(enemy)
		elif dist_sq <= SEMI_ACTIVE_RANGE_SQ:
			semi_active_enemies.append(enemy)
		else:
			idle_enemies.append(enemy)
			enemy.velocity = Vector2.ZERO  # Optional: freeze physics to save perf

func _cluster_enemies() -> void:
	enemy_clusters.clear()

	for enemy in active_enemies:
		if not is_instance_valid(enemy):
			continue

		var placed = false
		for cluster in enemy_clusters:
			if enemy.global_position.distance_to(cluster[0].global_position) <= CLUSTER_DISTANCE:
				cluster.append(enemy)
				placed = true
				break

		if not placed:
			enemy_clusters.append([enemy])
