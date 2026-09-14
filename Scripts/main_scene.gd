extends Node3D

@onready var player: CharacterBody3D = $CharacterBody3D
@onready var spawn_point: Marker3D = $Start_platform/Marker3D

func _ready() -> void:
	GameManager.register_player(player)
	GameManager.register_spawn_point(spawn_point)
