extends CanvasLayer

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _process(_delta: float) -> void:
	sprite.position = get_viewport().get_mouse_position()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	elif event is InputEventKey and event.pressed and event.keycode == KEY_F11:
		var is_full = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
		DisplayServer.window_set_mode(
			DisplayServer.WINDOW_MODE_WINDOWED if is_full else DisplayServer.WINDOW_MODE_FULLSCREEN
		)
