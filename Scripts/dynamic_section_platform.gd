extends AnimatableBody3D

## Direction + distance (in world units) the platform travels from its
## starting point. E.g. Vector3(0, 0, 6) moves it 6m back and forth along Z.
@export var move_offset: Vector3 = Vector3(0, 0, 6)

## How fast the platform oscillates. Higher = faster back-and-forth.
@export var speed: float = 1.0

## Optional time offset (in seconds) so multiple platforms aren't in sync.
@export var phase_offset: float = 0.0

var _start_position: Vector3
var _time: float = 0.0

func _ready() -> void:
	_start_position = global_position
	# Required so CharacterBody3D correctly inherits this platform's velocity
	# (i.e. the player gets carried along instead of sliding off).
	sync_to_physics = true

func _physics_process(delta: float) -> void:
	_time += delta
	# sin() gives smooth back-and-forth motion between -move_offset and +move_offset
	var factor := sin((_time + phase_offset) * speed)
	global_position = _start_position + move_offset * factor
