extends CharacterBody3D

@onready var camera_pivot: Node3D = $CameraPivot
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var raycast_pivot: Node3D = $Pivot
@onready var ray_cast_3d: RayCast3D = $Pivot/RayCast3D
@onready var bottom: Marker3D = $Marker3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if ray_cast_3d and ray_cast_3d.get_collider():
			if ray_cast_3d.get_collider().name != "Terrain3D":
				var point = ray_cast_3d.get_collision_point()
				var diff = point.y - bottom.global_position.y
				if diff <= .5:
					var tw: Tween = create_tween()
					tw.tween_property(self, "global_position", Vector3(point.x, point.y - .5, point.z), delta * 3)
					tw.play()
			
		raycast_pivot.look_at(global_position + velocity, Vector3.UP)
		camera_pivot.get_node("SpringArm3D").spring_length = lerp(camera_pivot.get_node("SpringArm3D").spring_length, 3.0, delta * 5)
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		camera_pivot.get_node("SpringArm3D").spring_length = lerp(camera_pivot.get_node("SpringArm3D").spring_length, 2.0, delta * 5)
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	handle_animations(input_dir)

# dedicated function to handle animations based on input.
func handle_animations(input: Vector2) -> void:
	animation_tree.set("parameters/conditions/idle", is_on_floor() && input == Vector2.ZERO)
	animation_tree.set("parameters/conditions/walk", is_on_floor() && input != Vector2.ZERO)
	animation_tree.set("parameters/conditions/jump", not is_on_floor())


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x / 100.0
		camera_pivot.rotation.x += event.relative.y / 100.0
		camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, -.78, .78)
