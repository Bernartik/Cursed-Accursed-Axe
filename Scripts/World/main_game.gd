extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.reset_score();
	Global.global_camera.set_camera_center();
	
	EventBus.connect("game_is_over", end_game);
	EventBus.disable_game_ui.emit(false);

func end_game(_over : bool) -> void:
	Global.update_player_high_score();
	Global.game_handler.open_menu("gameover");
