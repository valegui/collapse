extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass
	

func appear(pos):
	position = Vector2(pos.x, pos.y)
	visible = true
	
