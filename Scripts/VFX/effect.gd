extends AnimatedSprite2D
class_name HitEffect

## Name of the effect, will be searched in the vfx folder.
@export var effect_name : String;
## How many frames the effect has.
@export var effect_frames : int;
## The speed scale of the animation.
@export var effect_speed := 4.0;
@export var effect_offset := Vector2.ZERO;

var new_spriteframe := SpriteFrames.new();

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("animation_finished", queue_free)
	
	speed_scale = effect_speed;
	
	new_spriteframe.add_animation("hit_effect");
	new_spriteframe.set_animation_loop("hit_effect", false);
	for n in range(effect_frames):
		new_spriteframe.add_frame("hit_effect",load("res://Sprites/VFX/"+effect_name+str(n+1)+".png"));
	
	set_sprite_frames(new_spriteframe);
	play("hit_effect");
