extends AnimatedSprite2D

var assigned_entity : Entity;
var load_outline_enemy := preload("res://Shaders/outline.tres");
var load_outline_player := preload("res://Shaders/outline_player.tres");

func _ready() -> void:
	assigned_entity = get_parent();
	set_outline_color(assigned_entity);
	EventBus.connect("player_character_ready", set_outline_color);


func flip_sprite(_flip_dir : int) -> void:
	position.x = abs(position.x) * _flip_dir;
	flip_h = true if _flip_dir == -1 else false;
	

func set_outline_color(_entity : Entity):
	if (assigned_entity == Global.player_character):
		set_material(load_outline_player);
	else:
		set_material(load_outline_enemy);
