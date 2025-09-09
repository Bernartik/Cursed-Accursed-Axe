extends Entity

var snake_bullet := preload("res://Scenes/Entities/Enemies/snake_bullet.tscn");

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
			if (state_timer >= 90):
				Global.sound_play("snakeload", -24);
				set_state("SnakeshootStart");
	



func spawn_bullet() -> void:
	var bullet_instance : Entity = snake_bullet.instantiate();
	bullet_instance.facing_dir = facing_dir;
	bullet_instance.position.x = position.x + 28 * facing_dir;
	bullet_instance.position.y = position.y - 10;
	get_parent().add_child(bullet_instance);
