extends Control

func _ready() -> void:
	EventBus.connect("game_handler_requests_node", emit_menu_node);

func emit_menu_node() -> void:
	EventBus.cur_menu_node.emit(self);

func open_scene(_menu : PackedScene) -> Node2D:
	var new_menu := _menu.instantiate();
	mouse_filter = MOUSE_FILTER_PASS;
	add_child(new_menu);
	return new_menu;

func close_scene(_menu : Menu) -> void:
	var find_menu_index := get_children().find(_menu);
	if (find_menu_index != -1):
		get_children()[find_menu_index].queue_free();
	mouse_filter = MOUSE_FILTER_IGNORE;
