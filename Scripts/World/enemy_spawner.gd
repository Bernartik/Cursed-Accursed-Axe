extends Marker2D

## What entity will get spawned.
@export var entity_scene : PackedScene;

## What direction the entity will be facing on spawn
@export_range(-1,1,2) var facing_dir := 1;

## Amount of time it should take, in frames, for the entity to spawn [br]
@export var spawn_time := 0;
var spawn_timer_cur := 0;

var allowed_to_spawn := false;

var assigned_room : Room;

func _physics_process(_delta: float) -> void:
	if (allowed_to_spawn):
		spawn_timer_cur += 1;
		if (spawn_timer_cur >= spawn_time):
			spawn_entity();
			spawn_timer_cur = 0;
			allowed_to_spawn = false;

func spawn_entity() -> void:
	var entity_instance : Entity = entity_scene.instantiate();
	entity_instance.position = position;
	entity_instance.facing_dir = facing_dir;
	assigned_room.enemy_holder.add_child(entity_instance);
