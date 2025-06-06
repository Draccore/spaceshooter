extends CharacterBody2D

@onready var player_sprite: Sprite2D = $Ship
@onready var engine_effect_animation: AnimationPlayer = $EngineEffect/EngineEffectAnimation
@onready var weapon_animation: AnimationPlayer = $Weapon/WeaponAnimation
@onready var weapon_sprite: Sprite2D = $Weapon
@onready var main = get_tree().get_root().get_node("Main")

## Ship Sprites
@onready var full_health_sprite = preload("res://Sprites/Ships/Main Ship - Base - Full health.png")
@onready var slight_damage_sprite = preload("res://Sprites/Ships/Main Ship - Base - Slight damage.png")
@onready var damaged_sprite = preload("res://Sprites/Ships/Main Ship - Base - Damaged.png")
@onready var very_damaged_sprite = preload("res://Sprites/Ships/Main Ship - Base - Very damaged.png")

var input = Vector2.ZERO
var direction

## Variables for code
var current_state

func _ready():
	change_state("Idle_State") # Start in the Idle state
	PlayerStats.reset_hp()
	set_engine(PlayerStats.selected_engine)

## Handles the changing of states
func change_state(new_state_name: String):
	if current_state:
		current_state.exit_state() # Exit the current state
	current_state = get_node(new_state_name)
	if current_state: # Ensure the new state exists
		current_state.enter_state(self) # Enter the new state 

func _physics_process(delta: float) -> void:
	## Rotate player to face mouse and set direction to mouse
	var direction = (get_angle_to(get_global_mouse_position()))
	rotate(direction)

	## Get Input
	var input = Vector2(
		Input.get_action_strength("Right") - Input.get_action_strength("Left"),
		Input.get_action_strength("Down") - Input.get_action_strength("Up")
	).normalized()

	# Add Acceleration or friction if input is active or not
	var lerp_weight = delta * (PlayerStats.get_stat("accel") if input else PlayerStats.get_stat("friction"))
	# Calculate velocity using lerp
	velocity = lerp(velocity, input * PlayerStats.get_stat("speed"), lerp_weight)
	# Update Animationa
	if input != Vector2.ZERO:
		engine_effect_animation.play("Base_Engine_Powering")
	else:
		engine_effect_animation.play("Base_Engine_Idle")
	
	##State
	# Ensure a State is active
	if current_state:
		current_state.handle_input(delta)
	## Function to enable movement
	move_and_slide()
	
	## Update sprite and hp
	# Define thresholds from highest to lowest
	var sprite_thresholds = [
		{ "threshold": 0.75, "sprite": full_health_sprite },
		{ "threshold": 0.5, "sprite": slight_damage_sprite },
		{ "threshold": 0.25, "sprite": damaged_sprite },
		{ "threshold": 0.0, "sprite": very_damaged_sprite },
	]
	
	# Calculate health percentage safely
	var hp_percentage = clamp(inverse_lerp(0, PlayerStats.get_stat("max_hp"), PlayerStats.HP), 0.0, 1.0)
	
	# Choose appropriate sprite
	for entry in sprite_thresholds:
		if hp_percentage >= entry.threshold:
			player_sprite.texture = entry.sprite
			break

	# Example: test key to lose HP
	if Input.is_action_just_pressed("ui_accept"):
		PlayerStats.HP -= 5

# Call this to change engine visuals
func set_engine(engine_name: String):
	# Store the choice (could also do this in PlayerStats)
	PlayerStats.selected_engine = engine_name
	# Update sprite
	$Engine.texture = PlayerStats.engines[engine_name]["sprite"]
	# Optionally update stats, particles, etc.
