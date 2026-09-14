extends Area3D

var _triggered: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if _triggered:
		return
	if body is CharacterBody3D:
		_triggered = true
		await get_tree().create_timer(0.5).timeout
		var ui := get_tree().get_first_node_in_group("end_game_ui")
		if ui:
			ui.show_win()
