extends Entity


func _process(_delta: float) -> void:
	super(_delta);
	
	match(state):
		"Dead":
			Global.sound_play("enemydeath", -20);
			Global.spawn_vfx(load("res://Scenes/VFX/Hit Effects/enemy_die.tscn"), get_global_position(), facing_dir);
			queue_free();

func _physics_process(_delta: float) -> void:
	super(_delta);
	
	match(state):
		"Idle":
			allow_jump();
	

func allow_jump() -> void:
	if (entity_input[ENTITY_ACT.UP]):
		if (is_on_floor()):
			Global.sound_play("spiderjump", -28);
			set_state("Jumpstart");
