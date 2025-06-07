extends CharacterBody2D

@onready var player_sprite: Sprite2D = $Ship
@onready var engine_effect_animation: AnimationPlayer = $EngineEffect/EngineEffectAnimation
@onready var weapon_animation: AnimationPlayer = $Weapon/WeaponAnimation
@onready var weapon_sprite: Sprite2D = $Weapon
@onready var main = get_tree().get_root().get_node("Main")

# Ship Sprites
@onready var full_health_sprite = preload("res://Sprites/Player/Main Ship/Main Ship - Bases/PNGs/Main Ship - Base - Full health.png")
@onready var slight_damage_sprite = preload("res://Sprites/Player/Main Ship/Main Ship - Bases/PNGs/Main Ship - Base - Slight damage.png")
@onready var damaged_sprite = preload("res://Sprites/Player/Main Ship/Main Ship - Bases/PNGs/Main Ship - Base - Damaged.png")
@onready var very_damaged_sprite = preload("res://Sprites/Player/Main Ship/Main Ship - Bases/PNGs/Main Ship - Base - Very damaged.png")

var current_state

func _ready():
	change_state("Idle_State")
	PlayerStats.reset_hp()
	set_engine(PlayerStats.selected_engine)

func change_state(new_state_name: String):
	if current_state:
		current_state.exit_state()
	current_state = get_node(new_state_name)
	if current_state:
		current_state.enter_state(self)

func _physics_process(delta: float) -> void:
	if !is_inside_tree() or get_viewport() == null or get_world_2d() == null:
		return

	update_ship_sprite()
	face_mouse()
	handle_input_and_movement(delta)
	handle_state(delta)
	handle_debug_keys()

func face_mouse():
	var angle = get_angle_to(get_global_mouse_position())
	rotate(angle)

func get_input_vector() -> Vector2:
	return Vector2(
		Input.get_action_strength("Right") - Input.get_action_strength("Left"),
		Input.get_action_strength("Down") - Input.get_action_strength("Up")
	).normalized()

func handle_input_and_movement(delta: float):
	var input = get_input_vector()
	var lerp_weight = delta * (PlayerStats.get_stat("accel") if input != Vector2.ZERO else PlayerStats.get_stat("friction"))
	velocity = lerp(velocity, input * PlayerStats.get_stat("speed"), lerp_weight)

	if input != Vector2.ZERO:
		engine_effect_animation.play(get_meta("engine_effect_anim_power"))
	else:
		engine_effect_animation.play(get_meta("engine_effect_anim_idle"))

	move_and_slide()

func handle_state(delta: float):
	if current_state:
		current_state.handle_input(delta)

func handle_debug_keys():
	if Input.is_action_just_pressed("Escape"):
		get_tree().change_scene_to_file("res://Scenes/pausemenu.tscn")
	if Input.is_action_just_pressed("ui_accept"):
		PlayerStats.HP -= 5

func set_engine(engine_name: String):
	PlayerStats.selected_engine = engine_name
	$Engine.texture = PlayerStats.engines[engine_name]["sprite"]
	set_meta("engine_effect_anim_power", PlayerStats.engines[engine_name].get("effect_animation_power", "base_engine_power"))
	set_meta("engine_effect_anim_idle", PlayerStats.engines[engine_name].get("effect_animation_idle", "base_engine_idle"))
	engine_effect_animation.play(get_meta("engine_effect_anim_idle"))

func update_ship_sprite():
	var sprite_thresholds = [
		{ "threshold": 0.75, "sprite": full_health_sprite },
		{ "threshold": 0.5, "sprite": slight_damage_sprite },
		{ "threshold": 0.25, "sprite": damaged_sprite },
		{ "threshold": 0.0, "sprite": very_damaged_sprite },
	]
	var hp_percentage = clamp(inverse_lerp(0, PlayerStats.get_stat("max_hp"), PlayerStats.HP), 0.0, 1.0)
	for entry in sprite_thresholds:
		if hp_percentage >= entry.threshold:
			player_sprite.texture = entry.sprite
			break

func apply_selected_engine():
	var engine_name = PlayerStats.selected_engine
	# Apply engine stats, sprite, etc. to the player based on engine_name
	# Example:
	var engine_data = PlayerStats.engines[engine_name]
	# Use engine_data to set speed, accel, friction, sprite, etc.
