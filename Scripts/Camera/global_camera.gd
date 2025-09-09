extends Camera2D
class_name GlobalCamera

# set position to the center of the viewport
var viewport_center_pos : Marker2D;
var shake_strength := 0;
var shake_duration := 0;

var camera_offset := Vector2.ZERO;
## The base offset for the camera
var camera_base_offset := Vector2(0, -30);

## Offset for camera follow distance
var camera_follow_offset := Vector2(16,32);
## Reference for camera follow distance change
var camera_follow_reference := Vector2.ZERO;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.connect("game_handler_requests_node", set_camera_center);
	EventBus.connect("player_character_ready", set_camera_on_player);
	EventBus.global_game_camera_ready.emit(self);


func _physics_process(delta: float) -> void:
	# camera offset code
	camera_offset = camera_base_offset;
	if (shake_duration > 0):
		shake_duration -= 1;
		camera_offset += Vector2(
			randf_range(-shake_strength,shake_strength),
			randf_range(-shake_strength,shake_strength)
		);
	offset = camera_offset;
	
	# camera position code
	if (Global.player_character != null):
		
		
		# the reference gets clamped the exact offset distance to detect if the camera needs to go back to normal
		camera_follow_reference.x = clamp(camera_follow_reference.x, 
		Global.player_character.get_global_position().x - camera_follow_offset.x,
		Global.player_character.get_global_position().x + camera_follow_offset.x);
		camera_follow_reference.y = clamp(camera_follow_reference.y, 
		Global.player_character.get_global_position().y - camera_follow_offset.y/2,
		Global.player_character.get_global_position().y + camera_follow_offset.y/2);
		
		var reference_dist = Global.player_character.get_global_position() - camera_follow_reference;
		#print(reference_dist)
		# good enough for jam time I think
		position.x = clamp(position.x, 
		Global.player_character.get_global_position().x - camera_follow_offset.x + reference_dist.x,
		Global.player_character.get_global_position().x + camera_follow_offset.x + reference_dist.x);
		
		position.y = clamp(position.y, 
		Global.player_character.get_global_position().y - camera_follow_offset.y + reference_dist.y,
		Global.player_character.get_global_position().y + camera_follow_offset.y + reference_dist.y);
	

## Positions global camera at the center of the viewport
func set_camera_center() -> void:
	set_position(Global.game_handler.viewport_center);

func set_camera_position(_pos : Vector2) -> void:
	set_position(_pos);

## Positions camera where the player is
func set_camera_on_player(_player : Entity) -> void:
	if (Global.player_character == _player):
		camera_follow_reference = Global.player_character.get_global_position();
		set_position(Global.player_character.get_global_position());

## Causes the camera to shake
func shake_camera(_strength : int, _duration : int) -> void:
	shake_strength = _strength;
	shake_duration = _duration;

## Returns -1 if the player passed the buffer to the left, 1 if to the right, and 0 if they haven't done either
#func player_passed_buffer_horizontal() -> int:
	#var cam_player_dist := Global.player_character.get_global_position() - camera_follow_reference;
	#if (abs(cam_player_dist.x) >= camera_follow_offset.x):
		#return sign(cam_player_dist.x);
	#return 0;
