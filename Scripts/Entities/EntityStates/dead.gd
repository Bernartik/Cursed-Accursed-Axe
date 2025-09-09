extends EntityState


func _physics_process_state() -> void:
	assigned_entity.velocity.x = 0;
	assigned_entity.velocity.y = 0;
