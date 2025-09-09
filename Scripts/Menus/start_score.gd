extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HighScore.text_displayed = str(Global.player_high_score);
