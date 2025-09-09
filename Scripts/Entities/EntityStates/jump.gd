extends EntityState


func state_start() -> void:
	assigned_entity.velocity.y = -assigned_entity.jump_speed;
	assigned_entity.move_and_slide();

func _physics_process_state() -> void:
	if (assigned_entity.state_timer > 2 && assigned_entity.is_on_floor()):
		Global.sound_play("land", -20);
		if (assigned_entity.find_state("Land") != null):
			assigned_entity.set_state("Land");
		else:
			assigned_entity.set_state("Idle");
