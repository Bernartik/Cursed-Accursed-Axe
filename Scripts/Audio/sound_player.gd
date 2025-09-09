extends AudioStreamPlayer

var sound : AudioStreamWAV;
var is_looping := false;

func _ready() -> void:
	set_stream(sound);
	play();

func _on_finished() -> void:
	if (is_looping):
		play();
	else:
		queue_free();
