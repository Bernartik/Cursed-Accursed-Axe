extends Control

var swap_timer := 0;
var swap_color := false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ScoreText.text_displayed = str(Global.player_score);
	$HighScore.visible = true if Global.player_got_high_score else false;

func _process(_delta: float) -> void:
	swap_timer += 1;
	swap_color = !swap_color if swap_timer % 40 == 0 else swap_color;
	swap_timer %= 40;
	$HighScore.text_color = Color(0.92,0.92,0.91) if swap_color else Color(0.87,0.51,0.64);
