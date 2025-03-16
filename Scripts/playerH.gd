extends CharacterBody3D

@onready var camera_pivot: Node3D = $CameraPivot
@onready var animation_tree: AnimationTree = $AnimationTree

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
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
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
