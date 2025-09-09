extends Node2D

# Holds pixel text on non-uspcaled port
# so they can be at a differet resolution from the game
var text_displayed : String = "";
var font_type : int = 0;
var text_alignment : int = 0;
var font_alagard : FontFile = preload("res://Fonts/alagard.ttf");
var font_dos : FontFile = preload("res://Fonts/Perfect DOS VGA 437 Win.ttf");

var label : Label;
var label_center : CenterContainer;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label_center = get_node("Center");
	label = get_node("Center/Label");


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.text = text_displayed;
	match(font_type):
		0:
			label.set("theme_override_fonts/font", font_alagard);
		1:
			label.set("theme_override_fonts/font", font_dos);
	match(text_alignment):
			0:
				label_center.position.x = label.size.x / 2;
			1:
				label_center.position.x = -label.size.x / 2;
			2:
				label_center.position.x = 0;
