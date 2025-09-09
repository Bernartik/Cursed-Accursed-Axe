extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if (body == Global.player_character):
		EventBus.new_room_should_be_generated.emit();
		get_node("CollisionShape2D").set_deferred("disabled",true);
