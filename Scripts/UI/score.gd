extends Control


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_node("TextPixel").text_displayed = "SCORE: " + str(Global.player_score);
