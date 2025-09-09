extends EntityController
class_name EnemyController

## Enemies should have a reference of who/where their target (the player) is.
var target_entity : Entity;

func _ready() -> void:
	super();
	set_target_player();

func set_target_player() -> void:
	if (Global.player_character != null):
		target_entity = Global.player_character;
