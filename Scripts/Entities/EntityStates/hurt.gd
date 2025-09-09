extends EntityState

func state_start() -> void:
	assigned_entity.override_movement = true;
	assigned_entity.velocity.x = 90 * -assigned_entity.facing_dir;
	assigned_entity.velocity.y = -180;
	assigned_entity.move_and_slide();

func state_end() -> void:
	assigned_entity.override_movement = false;

func _physics_process_state() -> void:
	assigned_entity.velocity.x = 90 * -assigned_entity.facing_dir;
	assigned_entity.velocity.y += 20;
	if (assigned_entity.is_on_floor()):
		if (assigned_entity.health_cur <= 0):
			assigned_entity.set_state("Dead");
		else:
			EventBus.entity_recovered.emit(assigned_entity);
			assigned_entity.set_state(assigned_entity.default_state);
