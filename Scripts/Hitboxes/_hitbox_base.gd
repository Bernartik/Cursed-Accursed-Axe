extends Area2D
class_name Hitbox

## How many damage points the hitbox deals.
@export var hit_damage := 1;
## How many hitstun frames the hitbox applies.
@export var hit_stun := 6;
## How many invulnerability frames the hitbox applies.
@export var hit_invul := 30;
## Strength of hit screenshake.
@export var hit_shake_strength := 2;
## Duration of hit screenshake in frames.
@export var hit_shake_duration := 5;
## If true, the hitbox is destroyed after hitting something
@export var fragile_hitbox := false;
## How many frames the hitbox exists for. [br]
## If the value is -1, it doesn't despawn naturally.
@export var hitbox_lifetime := -1;
var hitbox_timer := -1;

@export var hit_effect : PackedScene;
@export var sound_effects : Array[String];

var hitbox_owner : Entity;
var owned_by_player := false;

var hitbox_active := true;



func _ready() -> void:
	if (owned_by_player):
		collision_mask = 0x8;
	else:
		collision_mask = 0x4;
	
	
	hitbox_timer = hitbox_lifetime;
	
	EventBus.connect("entity_died", deactivate_hitbox);
	EventBus.connect("entity_got_hurt", deactivate_hitbox);
	EventBus.connect("entity_recovered", activate_hitbox);


func _physics_process(_delta: float) -> void:
	if (hitbox_timer != -1):
		if (hitbox_timer > 0):
			hitbox_timer -= 1;
		else:
			queue_free();

# on hit
func _on_area_entered(area: Area2D) -> void:
	#print("hit " + area.get_parent().name);
	if (hitbox_active):
		area.get_parent().got_hit(self);
		hitbox_owner.hit_someone();
		if (fragile_hitbox):
			queue_free();

func activate_hitbox(_entity : Entity) -> void:
	if (_entity == hitbox_owner):
		hitbox_active = true;

func deactivate_hitbox(_entity : Entity) -> void:
	if (_entity == hitbox_owner):
		hitbox_active = false;
		
