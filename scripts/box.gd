extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position.y += get_gravity().y * delta


func appear(pos):
	position = pos
	visible = true
	
