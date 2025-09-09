extends Menu

func _ready() -> void:
	get_node("AnimationPlayer").play("fade_in");


func _on_button_quit_pressed() -> void:
	Global.game_handler.close_scene();
	Global.game_handler.open_scene("start");
	Global.game_handler.close_menu();


func _on_button_retry_pressed() -> void:
	Global.game_handler.close_scene();
	Global.game_handler.open_scene("game");
	Global.game_handler.close_menu();
