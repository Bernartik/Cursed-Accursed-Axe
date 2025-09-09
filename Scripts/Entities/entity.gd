extends CharacterBody2D
class_name Entity

## Maximum amount of health points that the entity has
@export var health_max := 1;
var health_cur : int;

## If the entity has floating movement, otherwise is grounded
@export var is_floating := false;

## Entity's controller node, that dictates how it's supposed to act
@export var entity_controller : PackedScene;
var entity_is_player_character := false;

## If the entity should be permanently invincible
@export var is_invincible := false;

## If the entity is temporarily invincible
var is_invulnerable := false;
var invul_timer := 0;

## Entity state for the state machine
@export var state : String;
var default_state : String;
var state_timer := 0;
var current_state : EntityState;

## Entity's maximum movement speed
@export var move_speed := 80;

## Entity's movement acceleration
@export var move_accel := 15;
@export var move_friction := 20;

## Entity's initial jump speed
@export var jump_speed := 250;


## Entity's gravity acceleration
@export var gravity_accel := 25;

## Entity's maximum fall speed
@export var gravity_speed := 400;

## In cases we need to store the velocity for later (like hitpause)
var prev_velocity : Vector2;

## If the entity's regular movement should be overriden for whatever reason
var override_movement := false;

## If the entity's movement should be stopped for whatever reason
var stop_all_movement := false;

## Hitpause in case it gets hit
var hitpause := false;
var hitpause_timer := 0;

@export var score_value := 2;
@export var counts_for_clear := true;


## Entity movement input array
var entity_input : Array[bool];

## Entity movement enums
enum ENTITY_ACT {
	LEFT,
	RIGHT,
	UP,
	DOWN,
	ACTION1,
	ACTION2
}

## Movement direction vector
var move_dir := Vector2.ZERO;

## What direction the entity is facing
var facing_dir := 1;
var prev_facing_dir := 1;

var entity_sprite : AnimatedSprite2D;

func _ready() -> void:
	health_cur = health_max;
	if (entity_controller != null):
		var instance_controller = entity_controller.instantiate();
		add_child(instance_controller);
	
	entity_sprite = get_node("EntitySprite");
	
	
	entity_input.resize(ENTITY_ACT.size());
	
	default_state = state
	set_state(default_state);
	
	EventBus.connect("player_character_ready", check_if_player);

func _process(_delta: float) -> void:
	current_state._process_state();
	
	get_node("EntitySprite").flip_sprite(facing_dir);


func _physics_process(_delta: float) -> void:
	state_timer += 1;
	
	# this happens in physics process so it is framerate-independant
	if (invul_timer > 0):
		invul_timer -= 1;
	else:
		is_invulnerable = false;
	
	if (hitpause):
		if (hitpause_timer > 0):
			hitpause_timer -= 1;
		else:
			end_hitpause();
	
	if !(override_movement):
		move_dir = Vector2.ZERO;
		move_dir.x = 1 if entity_input[ENTITY_ACT.RIGHT] else (-1 if entity_input[ENTITY_ACT.LEFT] else 0);
		move_dir.y = 1 if entity_input[ENTITY_ACT.DOWN] else (-1 if entity_input[ENTITY_ACT.UP] else 0);
		
		if (move_dir.x == 0 && abs(velocity.x) > 0):
			var friction_correction = (abs(velocity.x) - sign(abs(velocity.x)) * move_friction) < 0;
			if (friction_correction):
				velocity.x = 0;
			else:
				velocity.x -= sign(velocity.x) * move_friction;
		
		velocity.x += move_dir.x * move_accel;
		if (is_floating):
			velocity.y += move_dir.y * move_accel;
			velocity.y = clamp(velocity.y, -move_speed, move_speed);
		else:
			if (is_on_floor()):
				velocity.y = 0;
			velocity.y += gravity_accel;
			
			velocity.y = clamp(velocity.y, -jump_speed, gravity_speed);
		velocity.x = clamp(velocity.x, -move_speed, move_speed);
		
	
	# Note that, by default, state-specific physics will override the general entity ones
	if !(hitpause || stop_all_movement):
		current_state._physics_process_state();
		move_and_slide();
		

func set_state(_state : StringName) -> void:
	var found_state = find_state(_state);
	if (found_state == null):
		#print("ERROR -> state '"+_state+"' does not exist on entity '"+name+"'");
		return;
	#print(_state)
	state = _state;
	state_timer = 0;
	if (current_state != null):
		current_state.state_end();
	current_state = found_state;
	current_state.assigned_entity = self;
	current_state.state_start();
	if (entity_sprite != null):
		if (entity_sprite.get_sprite_frames().has_animation(_state)):
			entity_sprite.play(_state);

func find_state(_state : StringName) -> EntityState:
	for groupedstate in get_node("EntityStates").get_children():
		if (_state == groupedstate.get_name()):
			return groupedstate;
	return null;

## Causes the entity to take damage
func take_damage(_damage : int) -> void:
	health_cur -= _damage;
	EventBus.entity_got_hurt.emit(self);
	if (health_cur <= 0):
		entity_should_die();

func apply_hitpause(_hit_time : int) -> void:
	hitpause = true;
	hitpause_timer = _hit_time;
	prev_velocity = velocity;

func end_hitpause() -> void:
	hitpause = false;
	velocity = prev_velocity;

## Function that takes in a hitbox's properties and applies it to this unit that 
## got hit (damage, hitstop, camera shake, etc)
func got_hit(_hitbox : Hitbox) -> void:
	if !(is_invincible || is_invulnerable):
		if (_hitbox.hitbox_owner != null):
			_hitbox.hitbox_owner.apply_hitpause(_hitbox.hit_stun);
			set_facing_dir((1 if _hitbox.hitbox_owner.get_global_position().x > get_global_position().x else -1));
		set_state("Hurt");
		take_damage(_hitbox.hit_damage);
		is_invulnerable = true;
		invul_timer = _hitbox.hit_invul;
		apply_hitpause(_hitbox.hit_stun);
		Global.spawn_vfx(_hitbox.hit_effect, (get_global_position() + _hitbox.get_global_position())/2, facing_dir);
		Global.global_camera.shake_camera(_hitbox.hit_shake_strength, _hitbox.hit_shake_duration);
		
		for sound in _hitbox.sound_effects:
			Global.sound_play(sound, -28);
		

## If the entity should do something if it hits someone, usually only does it on specific ones
func hit_someone() -> void:
	pass

## Happens if an entity should die, most will just die [br]
## But allows entities to have death-unique behaviour, or to die at will, if they want to
func entity_should_die() -> void:
	get_node("Hurtbox/CollisionShape2D").set_deferred("disabled", true);
	EventBus.entity_died.emit(self);


func check_if_player(_entity : Entity) -> void:
	if (_entity == self):
		entity_is_player_character = true;
	else:
		entity_is_player_character = false;

## Sets the facing direction, if it's non-zero
func set_facing_dir(_dir : int) -> void:
	if (_dir == 0):
		#print("ERROR -> direction is not valid");
		return;
	_dir = clamp(_dir, -1, 1);
	prev_facing_dir = facing_dir;
	facing_dir = _dir;
