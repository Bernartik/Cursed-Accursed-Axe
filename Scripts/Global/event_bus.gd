extends Node
## Handles signals globally

# scene handler signals
signal game_handler_requests_node(); # gets the current scene and menu nodes, and centers camera
signal cur_scene_node(emitter);
signal cur_menu_node(emitter);
signal scene_set_visible(visible);
signal disable_game_ui(should_disable);

# gameplay-related signals
signal game_is_over(over); # true if player won, false if player died, considering the jam scope you can only go as far
							# as you can

signal player_took_damage(emitter);

#signal room_entered(emitter);
signal new_room_should_be_generated();

# entity related signals for controllers, or other effects
signal entity_bumped_into_wall(emitter);
signal entity_landed(emitter);
signal entity_died(emitter);
signal entity_got_hurt(emitter);
signal entity_recovered(emitter);

# global and UI/Camera signals
signal game_handler_ready(emitter);
signal vfx_handler_ready(emitter);
signal global_game_camera_ready(emitter);
signal player_character_ready(emitter);
signal pixel_text_created(emitter);
signal pixel_text_destroyed(emitter);

# player control signals
signal player_mouse_controls_enabled;
signal player_mouse_controls_disabled;
