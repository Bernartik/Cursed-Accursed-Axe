extends Node2D

func _ready() -> void:
	EventBus.connect("game_handler_requests_node", emit_scene_node);

func emit_scene_node() -> void:
	EventBus.cur_scene_node.emit(self);

func open_scene(_scene : PackedScene) -> Node2D:
	var new_scene := _scene.instantiate();
	add_child(new_scene);
	return new_scene;

func close_scene(_scene : Node2D) -> void:
	var find_scene_index := get_children().find(_scene);
	if (find_scene_index != -1):
		get_children()[find_scene_index].queue_free();
