extends EntityState

func _physics_process_state() -> void:
	if (!assigned_entity.entity_sprite.is_playing()):
		assigned_entity.set_state(assigned_entity.default_state);
