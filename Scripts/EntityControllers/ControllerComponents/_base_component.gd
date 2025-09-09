extends Node
class_name ControllerComponent

var controller : EntityController;

func _ready() -> void:
	controller = get_parent();
