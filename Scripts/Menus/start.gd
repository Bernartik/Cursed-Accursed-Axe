extends Node2D

func _ready() -> void:
	Global.global_camera.call_deferred("set_camera_center");
	EventBus.disable_game_ui.emit(true);

func _on_button_start_pressed() -> void:
	Global.game_handler.close_scene();
	Global.game_handler.open_scene("game");
	Global.game_handler.close_menu();
