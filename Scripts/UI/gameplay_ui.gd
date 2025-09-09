extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.connect("disable_game_ui", disable_ui);

func disable_ui(_should_disable : bool) -> void:
	if (_should_disable):
		hide();
	else:
		show();
