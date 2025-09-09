extends Node
class_name GameHandler

## Position of the Viewport's Center
var viewport_center : Vector2i;

# SCENES TO LOAD
var scene_load_dict := {
	"test": preload("res://Scenes/World/world_test.tscn"),
	"game": preload("res://Scenes/World/main_game.tscn"),
	"start": preload("res://Scenes/Menus/start.tscn")
}

var menu_load_dict := {
	"gameover": preload("res://Scenes/Menus/game_over.tscn")
}

# MENUS TO LOAD



## Keeps track of the current active scene
var cur_scene_node : Node2D;
## Keeps track of the current active menu
var cur_menu_node : Control;

## Keeps track of the currently opened scenes
var cur_scenes : Array[Node2D];
## Keeps track of the currently opened menus
var cur_menus : Array[Control];

func _ready() -> void:
	viewport_center = (get_viewport().size / Global.upscale_ratio) * 0.5;
	#print(str(viewport_center))
	EventBus.game_handler_ready.emit(self);
	EventBus.connect("cur_scene_node", set_scene_node); # get the scene holder
	EventBus.connect("cur_menu_node", set_menu_node); # get the menu holder
	
	EventBus.game_handler_requests_node.emit(); # request for important nodes, they'll signal back
	
	# open the initial scene
	open_scene_instant("start");

## Sets the Scene Holder node
func set_scene_node(_node : Node2D) -> void:
	cur_scene_node = _node;

## Sets the Menu Holder node
func set_menu_node(_node : Control) -> void:
	cur_menu_node = _node;

## Opens a new scene, and returns it.
func open_scene(_scene : String) -> Node2D:
	var scene_new : Node2D;
	get_node("FadeAnim").play("fade_out");
	
	if (scene_load_dict.has(_scene)):
		scene_new = cur_scene_node.open_scene(scene_load_dict.get(_scene));
		scene_new.visible = false;
		EventBus.scene_set_visible.emit(false);
		scene_new.position = viewport_center;
		cur_scenes.append(scene_new);
	else:
		print("SCENE IS NOT DEFINED");
	
	return scene_new;

## Closes the current scene
func close_scene() -> void:
	var cur_scene_close : Node2D = cur_scenes.pop_back();
	cur_scene_node.close_scene(cur_scene_close);

## done due to jam time concerns
## opens the scene without fade anim
func open_scene_instant(_scene : String) -> Node2D:
	var scene_new : Node2D;
	
	if (scene_load_dict.has(_scene)):
		scene_new = cur_scene_node.open_scene(scene_load_dict.get(_scene));
		scene_new.position = viewport_center;
		cur_scenes.append(scene_new);
	else:
		print("SCENE IS NOT DEFINED");
	
	return scene_new;

## Opens a new menu, and returns it.
func open_menu(_menu : String) -> Menu:
	var menu_new : Menu;
	
	if (menu_load_dict.has(_menu)):
		menu_new = cur_menu_node.open_scene(menu_load_dict.get(_menu));
		#menu_new.visible = false;
		#EventBus.scene_set_visible.emit(false);
		#menu_new.position = viewport_center;
		cur_menus.append(menu_new);
	else:
		print("MENU IS NOT DEFINED");
	
	if (menu_new.should_pause_game):
		get_tree().paused = true;
	return menu_new;

# closes the most recently opened menu
func close_menu() -> void:
	var cur_menu_close : Menu = cur_menus.pop_back();
	if (cur_menu_close != null): 
		if (cur_menu_close.should_pause_game):
			get_tree().paused = false;
	cur_menu_node.close_scene(cur_menu_close);
	


func _on_fade_anim_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "fade_out"):
		cur_scenes.back().visible = true;
		EventBus.scene_set_visible.emit(true);
		get_node("FadeAnim").play("fade_in");
		EventBus.player_mouse_controls_disabled.emit();
	if (anim_name == "fade_in"):
		EventBus.player_mouse_controls_enabled.emit();
