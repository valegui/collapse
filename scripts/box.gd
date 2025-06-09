extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	angular_velocity = 0.0
	

func appear(pos):
	linear_velocity = Vector2.ZERO
	position = Vector2(pos.x, pos.y)
	visible = true
	
