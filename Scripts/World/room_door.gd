extends StaticBody2D
class_name Door

var assigned_room : Room;
var door_has_opened := false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assigned_room = get_parent();
	get_node("AnimatedSprite2D").play("idle");

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (assigned_room.are_all_enemies_killed && !door_has_opened):
		open_door();

func open_door() -> void:
	get_node("AnimatedSprite2D").play("open");
	door_has_opened = true;
	get_node("CollisionShape2D").set_deferred("disabled", true);

func close_door() -> void:
	get_node("AnimatedSprite2D").play("close");
	get_node("CollisionShape2D").set_deferred("disabled", false);
