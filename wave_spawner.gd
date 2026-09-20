extends Node2D
class_name WaveSpawner

signal level_over
signal shop_closed

var level_card_scene = preload("res://new_level_text.tscn")

@export var enemy_scene: PackedScene
@export var spawn_container: NodePath
@export var player_node: NodePath
@export var level_node: NodePath

#Wave sizing bliver så: base * growth ^(level - 1)
@export var base_enemy_count: int = 5
@export var enemy_count_growth: float = 1.2

#Tid
@export var spawn_interval: float = 3.0
@export var wave_pause_duration: float = 5.0

@export var health_growth: float = 1.10
@export var speed_growth: float = 1.05
@export var damage_growth: float = 1.10

@export var spawn_margin: float = 50.0

var current_level: int = 1
var enemies_alive: int = 1
var enemies_to_spawn: int = 0

var shop_open = false

@onready var _spawn_timer: Timer = $SpawnTimer
@onready var _pause_timer: Timer = $PauseTimer

@export var player_inventory: Inv

var shop_scene = preload("res://shop.tscn")

func _process(delta):
	if shop_open:
		shop_closed.emit()
		shop_open = false

func _ready() -> void:
	_spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	_pause_timer.one_shot = true
	_pause_timer.timeout.connect(_start_wave)
	
	_start_wave()

func _start_wave() -> void:
	#big level text
	var level_label = level_card_scene.instantiate()
	level_label.get_node("Label").text = "level " + str(current_level)
	
	$"../CanvasLayer".add_child(level_label)
	
	shop_closed.emit()
	print("DEBUG _start_wave called, current_level=", current_level)
	enemies_to_spawn = _get_enemy_count_for_level(current_level)
	enemies_alive = 0
	print(_get_enemy_count_for_level(current_level))
	
	_spawn_timer.wait_time = spawn_interval
	_spawn_timer.start()
	_on_spawn_timer_timeout()

func _get_enemy_count_for_level(level: int) -> int:
	return int(round(base_enemy_count * pow(enemy_count_growth, level - 1)))

func _on_spawn_timer_timeout() -> void:
	if enemies_to_spawn <= 0:
		_spawn_timer.stop()
		return
	_spawn_enemy()
	enemies_to_spawn -= 1
	if enemies_to_spawn <= 0:
		_spawn_timer.stop()
		
func _spawn_enemy() -> void:
	var level_mult = current_level -1
	var enemy:= enemy_scene.instantiate()

	var raw_pos = _get_random_edge_position()
	
	var map_rid = get_world_2d().navigation_map
	var safe_position = NavigationServer2D.map_get_closest_point(map_rid, raw_pos)
	
	enemy.global_position = safe_position
	enemy.health *= pow(health_growth, level_mult)
	enemy.speed *= pow(speed_growth, level_mult)
	enemy.damage *= pow(damage_growth, level_mult)
	get_tree().current_scene.add_child(enemy)
	
	if enemies_to_spawn != _get_enemy_count_for_level(current_level):
		enemies_alive += 1
	enemy.tree_exited.connect(_on_enemy_died, CONNECT_ONE_SHOT)
	print("DEBUG spawned enemy, enemies_alive=", enemies_alive, " enemies_to_spawn=", enemies_to_spawn)


func _on_enemy_died() -> void:
	player_inventory.gold += 10
	enemies_alive -= 1
	print("DEBUG enemy died, enemies_alive=", enemies_alive, " enemies_to_spawn=", enemies_to_spawn)
	if enemies_alive <= 0 and enemies_to_spawn <= 0:
		var shop = shop_scene.instantiate()
		$"../CanvasLayer".add_child(shop)
		shop_open = true
		level_over.emit()
		
		get_tree().paused = true
		
		$"../player_skib".health = $"../player_skib".max_health
		print("DEBUG wave cleared! starting pause timer, wait_time=", wave_pause_duration)
		current_level += 1
		_pause_timer.wait_time = wave_pause_duration
		_pause_timer.start()

func _get_random_edge_position() -> Vector2:
	var viewport := get_viewport()
	var rect := viewport.get_visible_rect()
	var inverse_transform := viewport.get_canvas_transform().affine_inverse()
	
	var world_top_left: Vector2 = inverse_transform * rect.position
	var world_bottom_right: Vector2 = inverse_transform * rect.end
	
	var pos := Vector2.ZERO
	match randi() % 4:
		0: # top
			pos.x = randf_range(world_top_left.x, world_bottom_right.x)
			pos.y = world_top_left.y - spawn_margin
		1: # bottom
			pos.x = randf_range(world_top_left.x, world_bottom_right.x)
			pos.y = world_bottom_right.y + spawn_margin
		2: # left
			pos.x = world_top_left.x - spawn_margin
			pos.y = randf_range(world_top_left.y, world_bottom_right.y)
		3: # right
			pos.x = world_bottom_right.x + spawn_margin
			pos.y = randf_range(world_top_left.y, world_bottom_right.y)
	return pos
