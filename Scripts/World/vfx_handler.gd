extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.vfx_handler_ready.emit(self);
