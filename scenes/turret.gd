extends StaticBody2D

# Laser properties
@export var laser_color: Color = Color.RED
@export var laser_width: float = 3.0
@export var laser_max_distance: float = 1000.0
@export var laser_duration: float = 0.2  # How long the laser stays visible
@export var laser_collision_mask: int = 0b00000000_00000000_00000000_00000111  # Which collision layers to check

# Optional spawn point offset from this body's position
@export var spawn_offset: Vector2 = Vector2.ZERO

# Reference to current laser visual
var current_laser_line: Line2D = null

func fire_laser(direction: Vector2) -> Dictionary:
	"""
	Fires a laser beam from this StaticBody2D
	
	Args:
		direction: Direction vector for the laser (will be normalized)
	
	Returns:
		Dictionary with hit information:
		{
			"hit": bool,
			"hit_point": Vector2,
			"hit_normal": Vector2,
			"collider": Node2D or null,
			"distance": float
		}
	"""
	
	# Normalize direction
	direction = direction.normalized()
	
	# Calculate start position
	var start_pos = global_position + spawn_offset
	var end_pos = start_pos + (direction * laser_max_distance)
	
	# Perform raycast
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(start_pos, end_pos)
	query.collision_mask = laser_collision_mask
	query.exclude = [self]  # Don't hit ourselves
	
	var result = space_state.intersect_ray(query)
	
	# Prepare hit information
	var hit_info = {
		"hit": false,
		"hit_point": end_pos,
		"hit_normal": Vector2.ZERO,
		"collider": null,
		"distance": laser_max_distance
	}
	
	# Check if we hit something
	if result:
		hit_info.hit = true
		hit_info.hit_point = result.position
		hit_info.hit_normal = result.normal
		hit_info.collider = result.collider
		hit_info.distance = start_pos.distance_to(result.position)
		
		# Call hit function on the collider if it exists
		if result.collider.has_method("hit"):
			result.collider.hit()
	
	# Create visual laser beam
	_create_laser_visual(start_pos, hit_info.hit_point)
	
	return hit_info


func _create_laser_visual(start_pos: Vector2, end_pos: Vector2):
	"""
	Creates the visual representation of the laser beam
	"""
	# Remove previous laser if it exists
	if current_laser_line:
		current_laser_line.queue_free()
	
	# Create new Line2D for the laser
	current_laser_line = Line2D.new()
	current_laser_line.width = laser_width
	current_laser_line.default_color = laser_color
	current_laser_line.add_point(to_local(start_pos))
	current_laser_line.add_point(to_local(end_pos))
	
	# Add glow effect
	current_laser_line.texture_mode = Line2D.LINE_TEXTURE_STRETCH
	
	# Add to scene
	add_child(current_laser_line)
	
	# Create tween to fade out the laser
	var tween = create_tween()
	tween.tween_method(_fade_laser, 1.0, 0.0, laser_duration)
	tween.tween_callback(_remove_laser)

func _fade_laser(alpha: float):
	"""
	Fades the laser beam over time
	"""
	if current_laser_line:
		var fade_color = laser_color
		fade_color.a = alpha
		current_laser_line.default_color = fade_color

func _remove_laser():
	"""
	Removes the laser visual after duration
	"""
	if current_laser_line:
		current_laser_line.queue_free()
		current_laser_line = null

# Utility function to check what's in front of us
func scan_ahead(direction: Vector2, distance: float = 100.0) -> Dictionary:
	"""
	Scans ahead without creating a visual laser
	
	Args:
		direction: Direction to scan
		distance: How far to scan
	
	Returns:
		Dictionary with scan results
	"""
	direction = direction.normalized()
	var start_pos = global_position + spawn_offset
	var end_pos = start_pos + (direction * distance)
	
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(start_pos, end_pos)
	query.collision_mask = laser_collision_mask
	query.exclude = [self]
	
	var result = space_state.intersect_ray(query)
	
	if result:
		return {
			"hit": true,
			"hit_point": result.position,
			"hit_normal": result.normal,
			"collider": result.collider,
			"distance": start_pos.distance_to(result.position)
		}
	else:
		return {
			"hit": false,
			"hit_point": end_pos,
			"hit_normal": Vector2.ZERO,
			"collider": null,
			"distance": distance
		}

# Example usage functions
func _ready():
	# Example: fire laser every 3 seconds
	var timer = Timer.new()
	timer.wait_time = 1.0
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	timer.start()

func _on_timer_timeout():
	# Example: fire laser to the right
	var hit_info = fire_laser(Vector2.LEFT)
	if hit_info.hit:
		print("Laser hit: ", hit_info.collider.name, " at distance: ", hit_info.distance)
