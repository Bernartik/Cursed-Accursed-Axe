extends EnemyController

func _ready() -> void:
	super();
	EventBus.connect("entity_bumped_into_wall",flip_entity);
	

func _process(delta: float) -> void:
	if (assigned_entity.state == "Idle" && assigned_entity.state_timer >= 75):
		assigned_entity.entity_input[assigned_entity.ENTITY_ACT.UP] = true;
	else:
		assigned_entity.entity_input[assigned_entity.ENTITY_ACT.UP] = false;
	
	if (assigned_entity.state == "Jump"):
		if (assigned_entity.facing_dir == 1):
			assigned_entity.entity_input[assigned_entity.ENTITY_ACT.RIGHT] = true;
			assigned_entity.entity_input[assigned_entity.ENTITY_ACT.LEFT] = false;
		elif (assigned_entity.facing_dir == -1):
			assigned_entity.entity_input[assigned_entity.ENTITY_ACT.RIGHT] = false;
			assigned_entity.entity_input[assigned_entity.ENTITY_ACT.LEFT] = true;
	else:
		assigned_entity.entity_input[assigned_entity.ENTITY_ACT.RIGHT] = false;
		assigned_entity.entity_input[assigned_entity.ENTITY_ACT.LEFT] = false;
	
	if (target_entity != null):
		if (assigned_entity.state == "Land" || assigned_entity.state == "Jumpstart"):
			if (target_entity.get_global_position().x > assigned_entity.get_global_position().x):
				assigned_entity.set_facing_dir(1);
			else:
				assigned_entity.set_facing_dir(-1);

func flip_entity(_entity : Entity) -> void:
	if (_entity == assigned_entity):
		assigned_entity.set_facing_dir(-assigned_entity.facing_dir);
