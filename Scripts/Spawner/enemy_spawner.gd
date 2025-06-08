extends Node

# --- Exported variables for customization in the Inspector ---
@export var enemy_scenes: Array[PackedScene] = []      # Array of enemy PackedScenes to spawn
@export var time_between_waves := 5.0                  # Delay (in seconds) between waves
@export var spawn_interval := 0.5                       # Time interval between individual enemy spawns in a wave

@export var camera_path: NodePath = "/root/Main/Player/Camera2D"  # Path to the Camera2D node, adjust as needed

# --- Internal state variables ---
var current_wave := 0               # Tracks the current wave number
var spawning := false               # Are we currently spawning enemies?
var time_since_start := 0.0         # Time since the game started
var enemies_left_to_spawn := []     # Queue of enemies waiting to be spawned
var spawn_timer := 0.0              # Timer to handle spawning intervals
var wave_timer := 0.0               # Timer to handle breaks between waves
var in_break := false               # Are we currently in a break between waves?

# --- Predefined manual waves with enemy counts and delays ---
var manual_waves: Array = [
	{
		"enemies": [{"enemy": 0, "count": 5}],    # Spawn 5 of enemy type 0
		"spawn_delay": 0.0,
		"name": "Wave 1 - Basic Fighters"
	},
	{
		"enemies": [{"enemy": 0, "count": 3}, {"enemy": 0, "count": 2}],
		"spawn_delay": 2.0,
		"name": "Wave 2 - Mixed Squadron"
	},
	{
		"enemies": [{"enemy": 0, "count": 5}],
		"spawn_delay": 3.0,
		"name": "Wave 3 - Heavy Attackers"
	}
]

# --- Instantiates and adds an enemy instance to the current scene at the specified position ---
func spawn_enemy(scene: PackedScene, pos: Vector2) -> void:
	var enemy_instance = scene.instantiate()
	enemy_instance.global_position = pos
	get_tree().current_scene.add_child(enemy_instance)


# --- Main loop called every frame ---
func _process(delta: float) -> void:
	time_since_start += delta

	if spawning:
		# Handle timing between enemy spawns in the current wave
		spawn_timer += delta
		if spawn_timer >= spawn_interval:
			spawn_timer = 0.0

			if enemies_left_to_spawn.size() > 0:
				# Pop next enemy spawn data and spawn it
				var spawn_data = enemies_left_to_spawn.pop_front()
				spawn_enemy(spawn_data["scene"], spawn_data["pos"])
			else:
				# Finished spawning current wave, start break
				spawning = false
				in_break = true
				wave_timer = 0.0

	elif in_break:
		# Count down the break time between waves
		wave_timer += delta
		if wave_timer >= time_between_waves:
			# Break over, start next wave asynchronously
			in_break = false
			await start_next_wave()


# --- Public method to kick off the first wave ---
func start_spawning() -> void:
	await start_next_wave()


# --- Setup and begin spawning the next wave of enemies ---
func start_next_wave() -> void:
	current_wave += 1
	print("Starting wave %d" % current_wave)

	# Clear any leftover spawn data
	enemies_left_to_spawn.clear()

	if current_wave <= manual_waves.size():
		# Use manual wave data if within predefined waves
		var wave_config = manual_waves[current_wave - 1]

		# Wait for any spawn delay specified in the wave config
		await get_tree().create_timer(wave_config["spawn_delay"]).timeout

		# Queue each enemy spawn with random positions
		for entry in wave_config["enemies"]:
			var enemy_scene = enemy_scenes[entry["enemy"]]
			for i in range(entry["count"]):
				enemies_left_to_spawn.append({
					"scene": enemy_scene,
					"pos": get_random_spawn_position()
				})
	else:
		# Auto-generated waves for later waves; increases difficulty progressively
		var difficulty = current_wave
		var enemy_count = 5 + difficulty * 2
		for i in range(enemy_count):
			var enemy_scene = get_scaled_enemy(current_wave)
			enemies_left_to_spawn.append({
				"scene": enemy_scene,
				"pos": get_random_spawn_position()
			})

	spawning = true


# --- Calculates a random position outside the camera view with an additional safety margin ---
func get_random_spawn_position() -> Vector2:
	# Get the Camera2D node from the exported path
	var camera = get_node(camera_path)

	# Get the viewport rectangle size (in pixels)
	var viewport_rect = get_viewport().get_visible_rect()

	# Calculate camera center and half-size in world coordinates, accounting for zoom
	var cam_center = camera.global_position
	var half_size = (viewport_rect.size / 2) * camera.zoom

	# Calculate top-left and bottom-right corners of the visible area
	var top_left = cam_center - half_size
	var bottom_right = cam_center + half_size

	# Margins to ensure enemies spawn outside the camera's view plus extra buffer
	var base_margin := 100       # Base margin outside camera view
	var extra_safe_margin := 200 # Extra safe margin to avoid spawning near edges

	var total_margin = base_margin + extra_safe_margin

	# Choose a random side (top, bottom, left, right) to spawn outside the viewport
	var side = randi() % 4
	var pos = Vector2()

	match side:
		0:  # Spawn above the top edge
			pos.x = randf_range(top_left.x, bottom_right.x)
			pos.y = top_left.y - total_margin
		1:  # Spawn below the bottom edge
			pos.x = randf_range(top_left.x, bottom_right.x)
			pos.y = bottom_right.y + total_margin
		2:  # Spawn to the left of the left edge
			pos.x = top_left.x - total_margin
			pos.y = randf_range(top_left.y, bottom_right.y)
		3:  # Spawn to the right of the right edge
			pos.x = bottom_right.x + total_margin
			pos.y = randf_range(top_left.y, bottom_right.y)

	return pos


# --- Returns an enemy PackedScene based on the wave number, with randomized scaling of difficulty ---
func get_scaled_enemy(wave: int) -> PackedScene:
	var roll = randf()
	if wave < 5:
		# Early waves: always spawn first enemy type
		return enemy_scenes[0]
	elif wave < 8:
		# Mid waves: 70% chance of first enemy type, 30% second enemy type
		return enemy_scenes[0] if roll < 0.7 else enemy_scenes[0]
	else:
		# Later waves: mixed chance among three enemy types
		if roll < 0.5:
			return enemy_scenes[0]
		elif roll < 0.8:
			return enemy_scenes[0]
		else:
			return enemy_scenes[0]
