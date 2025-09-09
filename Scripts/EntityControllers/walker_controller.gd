extends EnemyController

func _ready() -> void:
	super();
	EventBus.connect("entity_bumped_into_wall",flip_entity);

func _process(delta: float) -> void:
	if (assigned_entity.facing_dir == 1):
		assigned_entity.entity_input[assigned_entity.ENTITY_ACT.RIGHT] = true;
		assigned_entity.entity_input[assigned_entity.ENTITY_ACT.LEFT] = false;
	elif (assigned_entity.facing_dir == -1):
		assigned_entity.entity_input[assigned_entity.ENTITY_ACT.RIGHT] = false;
		assigned_entity.entity_input[assigned_entity.ENTITY_ACT.LEFT] = true;
	

func flip_entity(_entity : Entity) -> void:
	if (_entity == assigned_entity):
		assigned_entity.set_facing_dir(-assigned_entity.facing_dir);
