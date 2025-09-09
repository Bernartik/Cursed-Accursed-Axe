extends ControllerComponent

var detection_cooldown := 0;

func _physics_process(_delta: float) -> void:
	if (detection_cooldown > 0):
		detection_cooldown -= 1;
	
	if (controller.assigned_entity.is_on_wall() && detection_cooldown == 0):
		EventBus.entity_bumped_into_wall.emit(controller.assigned_entity);
		detection_cooldown = 2;
	
