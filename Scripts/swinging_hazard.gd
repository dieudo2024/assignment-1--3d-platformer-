extends Node3D

## Max swing angle in degrees, each direction from center.
@export var swing_angle_degrees: float = 45.0

## How fast it swings back and forth.
@export var speed: float = 2.0

var _time: float = 0.0

func _physics_process(delta: float) -> void:
	_time += delta
	rotation.z = deg_to_rad(swing_angle_degrees) * sin(_time * speed)
