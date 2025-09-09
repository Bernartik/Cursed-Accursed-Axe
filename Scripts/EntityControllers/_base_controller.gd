extends Node
class_name EntityController

## Assigned Entity to be controlled
var assigned_entity : Entity;

func _ready() -> void:
	assigned_entity = get_parent();
