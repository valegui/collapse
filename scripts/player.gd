extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

#@onready var box = $Box
var original_position = Global.player_original_position
@onready var sfx: AudioStreamPlayer = $SoundEffects
var alive = true
var box_visible = false
var is_hit = false

func _ready():
	is_hit = false
	position = original_position

func _physics_process(delta: float) -> void:
	print(position)
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Hit
	if is_hit:
		sfx.set_stream(load("res://Hit4.wav"))
		sfx.play()
		game_restart()
	

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		sfx.set_stream(load("res://Jump4.wav"))
		sfx.play()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimatedSprite2D.stop()

	move_and_slide()

func hit():
	is_hit = true
	
func game_restart():
	is_hit = false
	get_tree().call_group("box", "appear", position)
	position = Global.player_original_position
	
