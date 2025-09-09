extends EntityController

var stop_moving := false;

func _ready() -> void:
	super();
	EventBus.connect("entity_bumped_into_wall",flip_entity);
	set_player_character(assigned_entity);

func _process(_delta: float) -> void:
	# player automatically moves to the left or the right
	if (stop_moving):
		assigned_entity.entity_input[assigned_entity.ENTITY_ACT.RIGHT] = false;
		assigned_entity.entity_input[assigned_entity.ENTITY_ACT.LEFT] = false;
	else:
		if (assigned_entity.facing_dir == 1):
			assigned_entity.entity_input[assigned_entity.ENTITY_ACT.RIGHT] = true;
			assigned_entity.entity_input[assigned_entity.ENTITY_ACT.LEFT] = false;
		elif (assigned_entity.facing_dir == -1):
			assigned_entity.entity_input[assigned_entity.ENTITY_ACT.RIGHT] = false;
			assigned_entity.entity_input[assigned_entity.ENTITY_ACT.LEFT] = true;
		
		if (PlayerInputHandler.mouse_inputs[PlayerInputHandler.MOUSE_ENUMS.LEFT_CLICK_PRESSED]):
			assigned_entity.entity_input[assigned_entity.ENTITY_ACT.UP] = true;
		else:
			assigned_entity.entity_input[assigned_entity.ENTITY_ACT.UP] = false;
		
		if (PlayerInputHandler.mouse_inputs[PlayerInputHandler.MOUSE_ENUMS.RIGHT_CLICK_PRESSED]):
			assigned_entity.entity_input[assigned_entity.ENTITY_ACT.ACTION1] = true;
		else:
			assigned_entity.entity_input[assigned_entity.ENTITY_ACT.ACTION1] = false;
	
	

## Whoever gets the player controller is assigned as the player character globally
func set_player_character(_character : Entity) -> void:
	EventBus.player_character_ready.emit.call_deferred(assigned_entity);

func flip_entity(_entity : Entity) -> void:
	if (_entity == assigned_entity):
		assigned_entity.set_facing_dir(-assigned_entity.facing_dir);
