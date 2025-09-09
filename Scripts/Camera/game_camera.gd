extends Camera2D

var orig_position : Vector2;
## Multiplier for the Game Camera positioning, 
## should be equal to the pixel upscaling for the visual.
@export var camera_mult : int = 1;

func _ready() -> void:
	EventBus.connect("game_handler_requests_node", set_camera_center);


func _process(_delta: float) -> void:
	# game cameras should have an equivalent position to the global camera
	if (Global.global_camera != null):
		set_global_position(Global.global_camera.get_global_position() * camera_mult);
		offset = Global.global_camera.offset;
		

## Positions global camera at the center of the viewport
func set_camera_center() -> void:
	set_position(Global.game_handler.viewport_center);
