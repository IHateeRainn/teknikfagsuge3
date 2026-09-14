extends Node2D

signal wave_started(level: int, enemy_count: int)
signal wave_completede(level: int)
signal all_waves_completed

# Enemy
@export var enemy_scenes: Array[PackedScene] = []
@export var spawn_container_path: NodePath

# Størrelsen på waves
@export var base_enemy_count: int = 5
