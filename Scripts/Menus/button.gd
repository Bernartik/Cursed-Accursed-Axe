extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("mouse_entered", button_hovered);
	connect("pressed", button_is_pressed);


func button_hovered() -> void:
	Global.sound_play("buttonhover", -28);

func button_is_pressed() -> void:
	Global.sound_play("button2", -24);
	Global.sound_play("button1", -20);
