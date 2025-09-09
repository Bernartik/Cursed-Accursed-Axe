extends Node2D
class_name Room

## Rooms include both hallways and arenas, and lock the player in until all killable enemies within them are dead
## All Rooms should have a 'RoomEnd' Marker, where the next room will be placed at, the room's door should also be at
## it's end.
## For reference, the room's 'starting point' should be at position zero. That's where the previous room's door will
## lock itself when the player enters.

## RoomCamera is an area that detects the player and sets the camera boundaries based on it's size.


## The door is automatically opened.
@export var auto_open := false;

## Marks the end of the room
var room_end : Marker2D;
var room_door : Door;

var enemy_holder : Node;
var enemy_spawners : Node;

## Total number of enemies to be killed
var num_enemies_total := 0;
## Total number of enemies that have been killed
var num_enemies_dead := 0;
## If true, open the door to the next room
var are_all_enemies_killed := false;

func _ready() -> void:
	room_end = get_node("RoomEnd");
	room_door = get_node("RoomDoor");
	enemy_holder = get_node("Enemies");
	enemy_spawners = get_node("EnemySpawners");
	
	#spawn_enemies()
	for spawner in enemy_spawners.get_children():
		var quick_inst : Entity = spawner.entity_scene.instantiate();
		if (!quick_inst.is_invincible):
			num_enemies_total += 1;
		quick_inst.free();
		
	if (auto_open || num_enemies_total == 0):
		are_all_enemies_killed = true;
	else:
		EventBus.connect("entity_died", increase_dead_count);
	


func increase_dead_count(_entity : Entity) -> void:
	if (_entity in enemy_holder.get_children() && _entity.counts_for_clear):
		num_enemies_dead += 1;
		are_all_enemies_killed = check_open_door();

func check_open_door() -> bool:
	return num_enemies_dead >= num_enemies_total;

func spawn_enemies() -> void:
	for spawner in enemy_spawners.get_children():
		spawner.assigned_room = self;
		spawner.allowed_to_spawn = true;
	

func clear_enemies() -> void:
	for enemy in enemy_holder.get_children():
		enemy.queue_free();
