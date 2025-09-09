extends Entity

@export var timer_offset := 0;
@export var attack_timer := 60;

func _ready() -> void:
	super();
	state_timer += timer_offset % attack_timer;

func _physics_process(_delta: float) -> void:
	super(_delta);
	
	match(state):
		"Idle":
			if (state_timer >= attack_timer):
				Global.sound_play("buttonhover", -36);
				set_state("AttackStart");
		"AttackStart":
			if (!entity_sprite.is_playing()):
				Global.sound_play("swipe1", -32);
				get_node("HitboxSpawner").spawn_hitbox();
				set_state("Attack");
		"Attack":
			if (!entity_sprite.is_playing()):
				set_state("AttackEnd");
		"AttackEnd":
			if (!entity_sprite.is_playing()):
				set_state("Idle");
