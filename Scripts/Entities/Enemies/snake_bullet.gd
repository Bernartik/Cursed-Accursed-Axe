extends Entity

func _process(_delta: float) -> void:
	super(_delta);
	
	match(state):
		"Dead":
			Global.sound_play("strike1", -24);
			Global.spawn_vfx(load("res://Scenes/VFX/Hit Effects/basic_hit.tscn"), get_global_position(), facing_dir);
			queue_free();

func _physics_process(_delta: float) -> void:
	super(_delta);
	
	match(state):
		"FloatForward":
			if (is_on_wall()):
				set_state("Dead");

func hit_someone() -> void:
	set_state("Dead");
	entity_should_die();
	
