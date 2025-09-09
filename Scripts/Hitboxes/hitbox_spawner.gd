@tool
extends Marker2D
class_name HitboxSpawner
## Used to spawn hitboxes, and visualize them in the editor

## The Spawner's Owner, if applicable
var spawner_owner : Entity;

@export var spawn_on_ready := false;

## If the spawner should flip horizontally with the owner's facing direction
@export var spawner_should_flip := true;
var init_pos_x : int;

enum HIT_SHAPE {
	SQUARE,
	CIRCLE
}

## Shape of the hitbox collision
@export var hitbox_shape : HIT_SHAPE;
## Height of the hitbox collision shape. [br]
## Circles will only take this into account as the radius.
@export_range(1, 20, 1, "or_greater") var hitbox_height := 10;
## Width of the hitbox collision shape. [br]
## Circles will NOT take this into account.
@export_range(1, 20, 1, "or_greater") var hitbox_width := 10;

# properties pulled from the hitbox scene, the spawner can set them up
## How many damage points the hitbox deals
@export var hit_damage := 1;

## How many hitstun frames the hitbox applies
@export var hit_stun := 6;

## How many invulnerability frames the hitbox applies
@export var hit_invul := 30;

## Strength of hit screenshake
@export var hit_shake_strength := 2;

## Duration of hit screenshake in frames
@export var hit_shake_duration := 5;

## If true, the hitbox is destroyed instead of deactivated
@export var fragile_hitbox := false;

## How many frames the hitbox exists for. [br]
## If the value is -1, it doesn't despawn naturally.
@export var hitbox_lifetime := -1;

@export var hit_effect : PackedScene;
@export var sound_effects : Array[String];

## The base hitbox's packedScene
var hitbox_load := preload("res://Scenes/Hitboxes/hitbox.tscn");

func _ready() -> void:
	if (!Engine.is_editor_hint()):
		if (get_parent() is Entity):
			spawner_owner = get_parent();
			init_pos_x = position.x;
		
		if (spawn_on_ready):
			spawn_hitbox();

func _process(delta: float) -> void:
	if (Engine.is_editor_hint()):
		queue_redraw();
	else:
		if (spawner_should_flip):
			position.x = init_pos_x * spawner_owner.facing_dir;

func _draw() -> void:
	if (Engine.is_editor_hint()):
		match(hitbox_shape):
			HIT_SHAPE.SQUARE:
				var points : PackedVector2Array = [Vector2(hitbox_width,hitbox_height)*0.5,
				Vector2(hitbox_width,-hitbox_height)*0.5,
				Vector2(-hitbox_width,-hitbox_height)*0.5,
				Vector2(-hitbox_width,hitbox_height)*0.5
				]
				draw_colored_polygon(points, Color.BROWN);
				
			HIT_SHAPE.CIRCLE:
				draw_circle(Vector2.ZERO,hitbox_height,Color.BROWN);
	


func spawn_hitbox() -> void:
	#print("hitbox spawned")
	var hitbox_instance : Hitbox = hitbox_load.instantiate();
	var collision_shape;
	match(hitbox_shape):
		HIT_SHAPE.SQUARE:
			collision_shape = RectangleShape2D.new();
			collision_shape.size.x = hitbox_width;
			collision_shape.size.y = hitbox_height;
			
		HIT_SHAPE.CIRCLE:
			collision_shape = CircleShape2D.new();
			collision_shape.radius = hitbox_width;
	hitbox_instance.get_node("Shape").shape = collision_shape;
	hitbox_instance.hit_damage = hit_damage;
	hitbox_instance.hit_stun = hit_stun;
	hitbox_instance.hit_invul = hit_invul;
	hitbox_instance.hit_shake_strength = hit_shake_strength;
	hitbox_instance.hit_shake_duration = hit_shake_duration;
	hitbox_instance.fragile_hitbox = fragile_hitbox;
	hitbox_instance.hitbox_lifetime = hitbox_lifetime;
	hitbox_instance.hit_effect = hit_effect;
	hitbox_instance.sound_effects = sound_effects;
	hitbox_instance.hitbox_owner = spawner_owner;
	
	if (Global.player_character != null && spawner_owner == Global.player_character):
		hitbox_instance.owned_by_player = true;
	
	add_child(hitbox_instance);
