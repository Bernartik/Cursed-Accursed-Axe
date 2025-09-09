extends EntityState

func _physics_process_state() -> void:
	assigned_entity.velocity.x = assigned_entity.move_speed * assigned_entity.facing_dir;
	assigned_entity.velocity.y = 0;
	
