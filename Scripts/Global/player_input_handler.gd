extends Node
## Handles controls and inputs

# Handles controller inputs (mouse, keyboard, etc.)
var mouse_controls_enabled : bool = true;
var keyboard_controls_enabled : bool = true;

var input_mouse_buffer_time := 5;

# inputs enums
enum MOUSE_ENUMS {
	LEFT_CLICK_PRESSED,
	LEFT_CLICK_RELEASED,
	LEFT_CLICK_HELD,
	RIGHT_CLICK_PRESSED,
	RIGHT_CLICK_RELEASED,
	RIGHT_CLICK_HELD,
}

enum KEYBOARD_ENUMS {
	ESCAPE_PRESSED
}

# ## keybinds
# # mouse
var mouse_inputs : Array[bool];
var mouse_inputs_buffer : Array[int];

# # keyboard
var keyboard_inputs : Array[bool];


func _ready() -> void:
	EventBus.connect("player_mouse_controls_enabled", enable_mouse_controls);
	EventBus.connect("player_mouse_controls_disabled", disable_mouse_controls);
	
	for i in MOUSE_ENUMS:
		mouse_inputs.append(false);
		mouse_inputs_buffer.append(0);
	for i in KEYBOARD_ENUMS:
		keyboard_inputs.append(false);


func _process(_delta: float) -> void:
	if (mouse_controls_enabled):
		mouse_inputs[MOUSE_ENUMS.LEFT_CLICK_PRESSED] = Input.is_action_just_pressed("left_click");
		mouse_inputs[MOUSE_ENUMS.LEFT_CLICK_HELD] = Input.is_action_pressed("left_click");
		mouse_inputs[MOUSE_ENUMS.LEFT_CLICK_RELEASED] = Input.is_action_just_released("left_click");
		if (Input.is_action_just_pressed("left_click")):
			mouse_inputs_buffer[MOUSE_ENUMS.LEFT_CLICK_PRESSED] = input_mouse_buffer_time;
		
		
		mouse_inputs[MOUSE_ENUMS.RIGHT_CLICK_PRESSED] = Input.is_action_just_pressed("right_click");
		mouse_inputs[MOUSE_ENUMS.RIGHT_CLICK_HELD] = Input.is_action_pressed("right_click");
		mouse_inputs[MOUSE_ENUMS.RIGHT_CLICK_RELEASED] = Input.is_action_just_released("right_click");
		
		if (Input.is_action_just_pressed("right_click")):
			mouse_inputs_buffer[MOUSE_ENUMS.RIGHT_CLICK_PRESSED] = input_mouse_buffer_time;
		
		check_mouse_buffer();
		
	if (keyboard_controls_enabled):
		keyboard_inputs[KEYBOARD_ENUMS.ESCAPE_PRESSED] = Input.is_action_just_pressed("escape");
	
	
	reduce_mouse_buffer_count();

# enable/disable controls for various purposes (when player shouldn't have input)
func enable_mouse_controls() -> void:
	mouse_controls_enabled = true;

func disable_mouse_controls() -> void:
	mouse_controls_enabled = false;

func enable_keyboard_controls() -> void:
	keyboard_controls_enabled = true;

func disable_keyboard_controls() -> void:
	keyboard_controls_enabled = false;

func check_mouse_buffer() -> void:
	for i in range(mouse_inputs_buffer.size()):
		if (mouse_inputs_buffer[i] > 0):
			mouse_inputs[i] = true;

func reduce_mouse_buffer_count() -> void:
	for i in range(mouse_inputs_buffer.size()):
		if (mouse_inputs_buffer[i] > 0):
			mouse_inputs_buffer[i] -= 1;
