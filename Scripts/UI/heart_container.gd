extends HBoxContainer

var heart_texture := preload("res://Sprites/UI/healthpoint1.png");
var heart_texture_empty := preload("res://Sprites/UI/healthpoint2.png");

func _ready() -> void:
	EventBus.connect("player_character_ready", set_player_max_hearts);
	EventBus.connect("player_took_damage", update_player_cur_hearts);

func update_player_cur_hearts(_player : Entity) -> void:
	var hearts := get_children();
	#print(_player.health_cur)
	for i in range(hearts.size()):
		if (i >= _player.health_cur):
			hearts[i].texture = heart_texture_empty;
		else:
			hearts[i].texture = heart_texture;

func set_player_max_hearts(_player : Entity) -> void:
	if (get_child_count() < _player.health_max):
		while (get_child_count() < _player.health_max):
			var new_heart := TextureRect.new();
			add_child(new_heart);
	elif (get_child_count() > _player.health_max):
		while (get_child_count() > _player.health_max):
			get_children().pop_back().queue_free();
	
	update_player_cur_hearts(_player);
