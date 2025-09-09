extends EntityState

func _physics_process_state() -> void:
	if (!assigned_entity.entity_sprite.is_playing()):
		Global.sound_play("jump1", -24);
		assigned_entity.set_state("Jump");
