extends CharacterBody2D

# === Constants ===
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# === Exported / Onready Variables ===
@onready var sfx: AudioStreamPlayer = $SoundEffects
@onready var corpse_scene = preload("res://scenes/corpse.tscn")
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# === Variables ===
var is_hit: bool = false
var last_position: Vector2
var corpse_instance: RigidBody2D = null

# === Initialization ===
func _ready() -> void:
	is_hit = false
	position = Global.player_original_position
	last_position = global_position
	add_to_group("player")


# === Physics Update ===
func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle hit
	if is_hit:

		play_sound("res://Hit4.wav")
		die()

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		play_sound("res://Jump4.wav")

	# Handle horizontal movement
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		animated_sprite.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animated_sprite.stop()

	move_and_slide()

# === Sound Playback ===
func play_sound(path: String) -> void:
	sfx.stream = load(path)
	sfx.play()

# === Death Logic ===
func die() -> void:
	var parent = get_parent()
	last_position = global_position
	is_hit = false
	
	# Spawn corpse before freeing self
	spawn_corpse(parent, last_position)
	
	queue_free()
	
	# Spawn new player at the same position
	var new_player = preload("res://scenes/player.tscn").instantiate()
	parent.add_child(new_player)
	new_player.global_position = Global.player_original_position
	new_player.name = "Player"
	new_player.collision_mask = 14

# === Corpse Spawning ===
func spawn_corpse(parent_node: Node, position: Vector2) -> void:
	var corpses = get_tree().get_nodes_in_group("corpse")
	var last_corpse = null
	if corpses.size() > 0:
		last_corpse = corpses[0]
		last_corpse.queue_free()
	if corpse_instance:
		corpse_instance.queue_free()

	corpse_instance = corpse_scene.instantiate()
	parent_node.add_child(corpse_instance)
	corpse_instance.add_to_group("corpse")
	corpse_instance.name = "Corpse"
	corpse_instance.global_position = position
	corpse_instance.visible = true

# === Trigger Hit ===
func hit() -> void:
	is_hit = true
