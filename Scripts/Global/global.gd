extends Node
## Handles and holds variables that need to be accessible on a global level

## The game's sprite upscale ratio for visuals
var upscale_ratio := 2;

# Important nodes that may require access
var game_handler : GameHandler;
var effect_holder : Node2D;
var global_camera : GlobalCamera;
var player_character : Entity;


# Preload things global can spawn
var sound_load := preload("res://Scenes/Audio/sound_player.tscn");
#var effect_load := preload("res://Scenes/Visuals/visual_effect.tscn");


# extra stuff
var player_score := 0;
var player_high_score := 0;
var player_got_high_score := false;

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS;
	
	EventBus.connect("game_handler_ready", set_game_handler);
	EventBus.connect("vfx_handler_ready", set_vfx_handler);
	EventBus.connect("global_game_camera_ready", set_global_camera);
	EventBus.connect("player_character_ready", set_player_character);
	EventBus.connect("entity_died", increment_score);
	EventBus.connect("entity_died", did_player_die);
	EventBus.connect("entity_got_hurt", did_player_take_damage);
	
	sound_play("monstervania", -29, true);


## Sets the Game Handler.
func set_game_handler(_handler : GameHandler) -> void:
	game_handler = _handler;

## Sets the VFX handler.
func set_vfx_handler(_handler : Node2D) -> void:
	effect_holder = _handler;

## Sets the Global Camera.
func set_global_camera(_camera : GlobalCamera) -> void:
	global_camera = _camera;

## Sets the Player Character.
func set_player_character(_player : Entity) -> void:
	player_character = _player;

func increment_score(_entity : Entity) -> void:
	if (_entity != player_character):
		player_score += _entity.score_value * 100;

func did_player_die(_entity : Entity) -> void:
	if (_entity == player_character):
		pass

func did_player_take_damage(_entity : Entity) -> void:
	if (_entity == player_character):
		EventBus.player_took_damage.emit(_entity);

func reset_score() -> void:
	player_got_high_score = false;
	player_score = 0;

func update_player_high_score() -> void:
	player_got_high_score = false;
	if (player_score > player_high_score):
		player_got_high_score = true;
		player_high_score = player_score;

## Plays a Sound.
func sound_play(_sound : String, _volume_db : float = 0.0, _looping : bool = false) -> void:
	var sound_instance := sound_load.instantiate();
	sound_instance.sound = load("res://Audio/"+_sound+".wav");
	sound_instance.volume_db = _volume_db;
	sound_instance.is_looping = _looping;
	add_child(sound_instance);
	update_sound_stack();

## Reduces sound volume if there's multiple of the same sound playing at once
func update_sound_stack() -> void:
	for sound1 in get_children():
		for sound2 in get_children():
			if (sound1 == sound2 || sound1.get_stream() != sound2.get_stream()):
				continue;
			if (sound1.get_playback_position() == sound2.get_playback_position()):
				sound2.set_volume_db(sound2.get_volume_db() - 2.0);


## Spawns a visual effect.
func spawn_vfx(_effect : PackedScene, _pos : Vector2, _dir : int = 1) -> void:
	if (effect_holder != null && _effect != null):
		var effect_instance : HitEffect = _effect.instantiate();
		effect_instance.set_position(_pos);
		effect_instance.position.x += effect_instance.effect_offset.x * _dir;
		effect_instance.position.y += effect_instance.effect_offset.y;
		effect_instance.flip_h = false if _dir == 1 else true;
		effect_holder.add_child(effect_instance);
	
