extends Node2D

## This handles room selection/spawning during gameplay


## ROOM LOADS

## The current rooms that you need to take into account.
var cur_room : Room;
var prev_room : Room;
var next_room : Room;
var spawn_first_rooms := false;

var spawn_hallway := true;

## Amount of rooms spawned so far (not counting the first one)
var cur_room_count := 0;

## Number of the previously spawned room to prevent repeats
var prev_room_num := -1;

## How many types of arena rooms there are to be picked when spawning
var num_rooms_type := 6;
## How many types of hallways there are to be picked when spawning
#var num_hallway_types := 3;

func _ready() -> void:
	spawn_first_room();
	EventBus.connect("new_room_should_be_generated", spawn_new_room);

func _process(_delta: float) -> void:
	if (spawn_first_rooms):
		spawn_new_room();
		spawn_first_rooms = false;
	# oops! forgot to comment this out on the main build
	#if (Input.is_action_just_pressed("escape")):
		#spawn_new_room();

func set_current_room(_room : Room) -> void:
	if (prev_room != null):
		prev_room.queue_free();
	prev_room = cur_room;
	cur_room = _room;
	if (prev_room != null):
		prev_room.clear_enemies();
		prev_room.room_door.close_door();
	cur_room.spawn_enemies();
	
	
	#print("--");

## currently only works with test room
func spawn_first_room() -> void:
	var new_room : Room = load("res://Scenes/World/Rooms/first_room.tscn").instantiate();
	add_child(new_room);
	spawn_first_rooms = true;
	set_current_room(new_room);

## currently only works with test room
## Spawns a new room, alternating between the list of hallways and arenas
func spawn_new_room() -> void:
	var new_room : Room;
	var new_room_num := randi_range(0,num_rooms_type-1)+1;
	if (num_rooms_type > 1):
		while (new_room_num == prev_room_num):
			new_room_num = randi_range(0,num_rooms_type-1)+1;
	new_room = load("res://Scenes/World/Rooms/RoomList/room_"+str(new_room_num)+".tscn").instantiate();
	prev_room_num = new_room_num;
	
	if (next_room != null):
		set_current_room(next_room);
	next_room = new_room;
	new_room.set_position(cur_room.get_position() + cur_room.room_end.get_position());
	add_child.call_deferred(new_room);
	cur_room_count += 1;

func spawn_specific_room(_room : PackedScene) -> void:
	var new_room = _room.instantiate();
	
	if (next_room != null):
		set_current_room(next_room);
	next_room = new_room;
	new_room.set_position(cur_room.get_position() + cur_room.room_end.get_position());
	add_child.call_deferred(new_room);
	cur_room_count += 1;
