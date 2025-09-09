extends Node2D

# holds labelholders, spawns or destroys them when needed
var load_label : PackedScene = preload("res://Scenes/UI/label_pixel.tscn");


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.connect("pixel_text_created", create_labelholder);
	EventBus.connect("pixel_text_destroyed", destroy_labelholder);

func create_labelholder(_text : Node2D) -> void:
	var label_inst : Node2D = load_label.instantiate();
	_text.set_label(label_inst);
	add_child(label_inst);

func destroy_labelholder(_text : Node2D) -> void:
	_text.real_label_is_ready = false;
	_text.real_label.queue_free();
