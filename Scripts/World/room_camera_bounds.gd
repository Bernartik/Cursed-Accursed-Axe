@tool
extends Area2D

## Width of the bounding box.
@export_range(1, 160, 1, "or_greater") var boundary_width := 128;

## Height of the bounding box.
@export_range(1, 160, 1, "or_greater") var boundary_height := 64;


func _ready() -> void:
	ready_bounding_area();

func _process(_delta: float) -> void:
	if (Engine.is_editor_hint()):
		get_node("CollisionShape2D").shape.size = Vector2.ZERO;
		queue_redraw();
	

func _draw() -> void:
	if (Engine.is_editor_hint()):
		var points : PackedVector2Array = [Vector2(boundary_width,boundary_height)*0.5,
				Vector2(boundary_width,-boundary_height)*0.5,
				Vector2(-boundary_width,-boundary_height)*0.5,
				Vector2(-boundary_width,boundary_height)*0.5
				]
		draw_colored_polygon(points, Color.GAINSBORO);
		

func ready_bounding_area() -> void:
	get_node("CollisionShape2D").shape.size = Vector2(boundary_width,boundary_height);


func _on_area_entered(area: Area2D) -> void:
	if (area.get_parent() == Global.player_character):
		# set camera boundaries
		Global.global_camera.limit_left = -boundary_width;
		Global.global_camera.limit_right = boundary_width;
		Global.global_camera.limit_top = -boundary_height;
		Global.global_camera.limit_bottom = boundary_height;
		
