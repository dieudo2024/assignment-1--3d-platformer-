extends Node

## How far below the world a player has to fall before we consider them
## "off the course" and respawn them at the start.
const FALL_LIMIT: float = -20.0

var spawn_transform: Transform3D = Transform3D.IDENTITY
var player: CharacterBody3D = null

## Called once by the main scene on _ready() so we know where "home" is.
func register_spawn_point(spawn_node: Node3D) -> void:
	spawn_transform = spawn_node.global_transform

## Called once by the main scene (or the player itself) so respawn() has
## something to move.
func register_player(p: CharacterBody3D) -> void:
	player = p

## Call this from anywhere (fall detection, a hazard's Area3D, etc.)
## to send the player back to the start of the course.
func respawn_player() -> void:
	if player == null:
		return
	player.velocity = Vector3.ZERO
	player.global_transform = spawn_transform
