extends CanvasLayer

@onready var panel: Control = $Panel
@onready var restart_button: Button = $Panel/VBoxContainer/RestartButton

func _ready() -> void:
	add_to_group("end_game_ui")
	panel.visible = false
	restart_button.pressed.connect(_on_restart_pressed)

func show_win() -> void:
	panel.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true

func _on_restart_pressed() -> void:
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().reload_current_scene()
