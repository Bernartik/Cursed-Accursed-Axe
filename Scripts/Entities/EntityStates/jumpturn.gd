extends EntityState


func state_start() -> void:
	assigned_entity.velocity.x = 0;
	assigned_entity.velocity.y = -assigned_entity.jump_speed*0.5;
	assigned_entity.move_and_slide();

func _physics_process_state() -> void:
	assigned_entity.velocity.x = 0;
	if (assigned_entity.state_timer > 2 && assigned_entity.is_on_floor()):
		assigned_entity.set_facing_dir(-assigned_entity.facing_dir);
		assigned_entity.set_state("Idle");
