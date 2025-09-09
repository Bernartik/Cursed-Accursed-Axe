extends Entity

func _process(_delta: float) -> void:
	super(_delta);
	
	match(state):
		"Dead":
			Global.sound_play("enemydeath", -20);
			Global.spawn_vfx(load("res://Scenes/VFX/Hit Effects/enemy_die.tscn"), get_global_position(), facing_dir);
			queue_free();
