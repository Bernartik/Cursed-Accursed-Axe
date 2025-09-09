@tool
extends Node2D
class_name TextPixel

@export var is_static_text := false;
@export var text_displayed : String = "";
@export_range(0,1) var font_type : int = 0;
@export_enum("Left","Right","Center") var text_alignment : int = 0;
@export var text_scale : float = 2;
@export var text_color : Color = Color.WHITE;
@export var placeholder_world_upscale : float = 2.0;
var font_alagard : FontFile = preload("res://Fonts/alagard.ttf");
var font_dos : FontFile = preload("res://Fonts/Perfect DOS VGA 437 Win.ttf");
var placeholder_label : Label;
var placeholder_center : CenterContainer;
var real_label : Node2D;
var real_label_is_ready : bool = false;

func _ready():
	if (!Engine.is_editor_hint() && !is_static_text):
		EventBus.pixel_text_created.emit(self);
		EventBus.connect("scene_set_visible", set_text_visible);
	placeholder_center = get_node("Center");
	placeholder_label = get_node("Center/LabelPlaceholder");

func _process(delta):
	if (Engine.is_editor_hint()):
		if (placeholder_center == null):
			placeholder_center = get_node("Center");
		
		if (placeholder_label == null):
			placeholder_label = get_node("Center/LabelPlaceholder");
	
	
	if (!Engine.is_editor_hint() && !real_label_is_ready && !is_static_text):
		EventBus.pixel_text_created.emit(self);
	
	if (Engine.is_editor_hint() || (!Engine.is_editor_hint() && !real_label_is_ready)):
		scale = Vector2(text_scale,text_scale) / placeholder_world_upscale;
		placeholder_label.text = text_displayed;
		placeholder_label.modulate = text_color;
		match(font_type):
			0:
				placeholder_label.set("theme_override_fonts/font", font_alagard);
			1:
				placeholder_label.set("theme_override_fonts/font", font_dos);
		match(text_alignment):
			0:
				placeholder_center.position.x = placeholder_label.size.x / 2;
			1:
				placeholder_center.position.x = -placeholder_label.size.x / 2;
			2:
				placeholder_center.position.x = 0;
			
	elif (real_label_is_ready):
		scale = Vector2(1.0,1.0);
		var letter_size_x := 8;
		placeholder_label.visible = false;
		real_label.visible = visible;
		real_label.text_displayed = text_displayed;
		real_label.font_type = font_type;
		real_label.text_alignment = text_alignment;
		real_label.scale = Vector2(text_scale,text_scale);
		real_label.rotation = rotation;
		real_label.modulate = text_color;
		real_label.set_global_position((get_global_position()) * Global.upscale_ratio);
		

func set_text_visible(_vis : bool) -> void:
	visible = _vis;

func set_label(_label : Node2D) -> void:
	real_label = _label;
	real_label_is_ready = true;

# since text has no control over when it's destroyed, emit a signal before it is
# so ui stuff knows to delete upscaled text
func _notification(what: int) -> void:
	if (what == NOTIFICATION_PREDELETE):
		if (!Engine.is_editor_hint() && !is_static_text):
			EventBus.pixel_text_destroyed.emit(self);
