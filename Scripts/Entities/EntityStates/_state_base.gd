extends Node
class_name EntityState

var assigned_entity : Entity;

## Runs when the state is set into
func state_start() -> void:
	pass

## Runs when the state is set out of
func state_end() -> void:
	pass

## For running process for the state when it's called
func _process_state() -> void:
	pass

## For running physics process for the state when it's called
func _physics_process_state() -> void:
	pass
