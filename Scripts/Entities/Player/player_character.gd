extends Entity

@export var attack_timer_max := 50;
@export var attack_timer_buffer := 20;
var attack_timer_cur := 0;
var detection_init_x : int;
var finished_dying := false;

var attack_effect := preload("res://Scenes/VFX/Hit Effects/player_attack.tscn");
var has_played_attack_ready_sound := false;

func _ready() -> void:
	super();
	detection_init_x = get_node("EnemyDetection").position.x;

func _process(_delta: float) -> void:
	super(_delta);
	
	match(state):
		"Dead":
			if (state_timer == 1):
				Global.sound_play("playerdeath", -24);
				Global.sound_play("playerdeathvoice", -26);
			if (!entity_sprite.is_playing() && !finished_dying):
				EventBus.game_is_over.emit(false);
				finished_dying = true;
		"Walk":
			if (entity_sprite.get_animation() != "WalkAttack" && attack_timer_cur >= (attack_timer_max - attack_timer_buffer)):
				var prev_frame := entity_sprite.get_frame()
				var prev_frame_progress := entity_sprite.get_frame_progress()
				entity_sprite.play("WalkAttack");
				entity_sprite.set_frame_and_progress(prev_frame, prev_frame_progress);
				
	
	get_node("EnemyDetection").position.x = detection_init_x * facing_dir;

func _physics_process(_delta: float) -> void:
	super(_delta);
	attack_timer_cur += 1;
	
	# if idle or walking, player can jump, and turn
	# player can also turn midair
	match(state):
		"Idle": # idle
			allow_jump();
			allow_turn();
			allow_attack();
		"Walk": # walking
			allow_jump();
			allow_turn();
			allow_attack();
		"Jump": # walking
			if (state_timer == 1):
				Global.sound_play("sweep1", -28);
			allow_turn();
			allow_attack();
		"Attack": # attack
			# if state timer is 2 then spawn hitbox
			get_node("EnemyDetection/CollisionShape2D").set_deferred("disabled", true);
			attack_timer_cur = 0;
			if (state_timer == 1):
				Global.sound_play("swipe1", -28);
			if (state_timer == 2 && !hitpause):
				Global.spawn_vfx(attack_effect, get_global_position(), facing_dir)
				get_node("HitboxSpawner").spawn_hitbox();
			if (state_timer >= 8):
				allow_jump();
				allow_turn();
				if (!entity_sprite.is_playing()):
					set_state("Walk");
			allow_turn();
			allow_attack();
			
	

func allow_jump() -> void:
	if (entity_input[ENTITY_ACT.UP]):
		if (is_on_floor()):
			Global.sound_play("jump1", -28);
			set_state("Jump");

func allow_turn() -> void:
	if (entity_input[ENTITY_ACT.ACTION1]):
		Global.sound_play("turn", -28);
		set_state("Jumpturn");

func allow_attack() -> void:
	if (attack_timer_cur >= attack_timer_max):
		attack_timer_cur = 0;
		has_played_attack_ready_sound = false;
		set_state("Attack");
	elif (attack_timer_cur >= (attack_timer_max - attack_timer_buffer)):
		if (!has_played_attack_ready_sound):
			Global.sound_play("pwew", -36);
			has_played_attack_ready_sound = true;
		get_node("EnemyDetection/CollisionShape2D").set_deferred("disabled", false);
	else:
		get_node("EnemyDetection/CollisionShape2D").set_deferred("disabled", true);

func _on_enemy_detection_area_entered(area: Area2D) -> void:
	if (!(state == "Hurt" || state == "Dead") && !(area.get_parent().is_invincible || area.get_parent().is_invulnerable)):
		attack_timer_cur = 0;
		get_node("EnemyDetection/CollisionShape2D").set_deferred("disabled", true);
		set_state("Attack");
