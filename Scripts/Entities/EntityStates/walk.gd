extends EntityState

func _process_state() -> void:
	if (assigned_entity.move_dir.x == 0):
		assigned_entity.set_state("Idle");
