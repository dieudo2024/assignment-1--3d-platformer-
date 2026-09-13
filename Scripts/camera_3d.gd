extends Camera3D

@onready var _player := $"../../.." as CharacterBody3D
@onready var _camera_pivot := $"../.." as Node3D
@onready var _spring_arm := $".." as SpringArm3D

var is_camera_captured: bool = true

@export_range(0.001, 0.05) var mouse_sensitivity: float = 0.003
@export var tilt_limit: float = deg_to_rad(75)

# Zoom limits for SpringArm3D length
@export var min_zoom: float = 2.0
@export var max_zoom: float = 8.0
@export var zoom_step: float = 0.5

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	is_camera_captured = true

func _unhandled_input(event: InputEvent) -> void:
	# Toggle cursor visibility with Escape key
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		is_camera_captured = false

	# Re-capture cursor with left click
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if not is_camera_captured:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			is_camera_captured = true

	# Mouse look rotation
	if event is InputEventMouseMotion and is_camera_captured:
		# Rotate horizontal axis (Yaw) on CameraPivot
		_camera_pivot.rotate_y(-event.relative.x * mouse_sensitivity)
		
		# Rotate vertical axis (Pitch) on CameraPivot
		_camera_pivot.rotation.x -= event.relative.y * mouse_sensitivity
		_camera_pivot.rotation.x = clampf(_camera_pivot.rotation.x, -tilt_limit, tilt_limit)

	# Scroll wheel camera zoom (SpringArm3D distance)
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_spring_arm.spring_length = clampf(_spring_arm.spring_length - zoom_step, min_zoom, max_zoom)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_spring_arm.spring_length = clampf(_spring_arm.spring_length + zoom_step, min_zoom, max_zoom)
