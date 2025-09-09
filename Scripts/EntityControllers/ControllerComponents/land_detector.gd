extends ControllerComponent

var was_on_ground := true;

func _physics_process(delta: float) -> void:
	if (controller.assigned_entity.is_on_floor()):
		if (!was_on_ground):
			EventBus.entity_landed.emit(controller.assigned_entity);
			was_on_ground = true;
			
	else:
		was_on_ground = false;
	
