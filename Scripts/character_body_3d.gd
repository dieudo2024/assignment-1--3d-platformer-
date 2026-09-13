extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 7.0
const ROTATION_SPEED = 12.0

@onready var camera_pivot: Node3D = $CameraPivot
@onready var aux_scene: Node3D = $AuxScene

func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get WASD input direction
	var input_dir: Vector2 = Input.get_vector("left", "right", "up", "down")
	
	# Calculate move direction relative to CameraPivot orientation
	var camera_basis = camera_pivot.global_transform.basis
	var forward = -camera_basis.z
	var right = camera_basis.x
	forward.y = 0
	right.y = 0
	forward = forward.normalized()
	right = right.normalized()
	
	var direction: Vector3 = (forward * -input_dir.y + right * input_dir.x).normalized()

	if direction != Vector3.ZERO:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		# Rotate $AuxScene mesh smoothly toward target movement direction
		var target_angle = atan2(-direction.x, -direction.z)
		aux_scene.rotation.y = lerp_angle(aux_scene.rotation.y, target_angle, ROTATION_SPEED * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	animate()
	move_and_slide()

func animate() -> void:
	var anim_tree = aux_scene.get_node_or_null("AnimationTree")
	if not anim_tree:
		return
		
	var is_moving = Vector2(velocity.x, velocity.z).length() >= 0.05
	
	anim_tree["parameters/conditions/is_idle"] = not is_moving
	anim_tree["parameters/conditions/is_walking"] = is_moving
	anim_tree["parameters/conditions/is_not_grounded"] = not is_on_floor()
	anim_tree["parameters/conditions/is_grounded"] = is_on_floor()
	anim_tree["parameters/conditions/is_jumping"] = is_on_floor() and Input.is_action_just_pressed("ui_accept")
