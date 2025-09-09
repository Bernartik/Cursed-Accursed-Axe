extends EntityState

func _physics_process_state() -> void:
	if (!assigned_entity.entity_sprite.is_playing()):
		Global.sound_play("snakespit1", -26);
		Global.sound_play("snakespit2", -22);
		assigned_entity.spawn_bullet();
		Global.spawn_vfx(load("res://Scenes/VFX/Hit Effects/snake_shoot.tscn"), Vector2(assigned_entity.get_global_position().x + 24 * assigned_entity.facing_dir, assigned_entity.get_global_position().y - 12) , assigned_entity.facing_dir);
		assigned_entity.set_state("SnakeshootEnd");
		
