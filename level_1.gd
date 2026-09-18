extends Node2D

var shop_scene = preload("res://shop.tscn")

@onready var player_skib = $player_skib
var enemy_scene = preload("res://enemy.tscn")

var enemy_spawn_rate = 2
var enemy_max = 20
var enemy_amount = 0
var enemy_spawn_distance = 700
var rng = RandomNumberGenerator.new()
var time_till_spawn = enemy_spawn_rate
var shop_open = false
var shop

func spawn_enemy():
	if enemy_amount <= enemy_max:
		var enemy = enemy_scene.instantiate()
		get_tree().current_scene.add_child(enemy)
		enemy.global_position = player_skib.global_position + Vector2.UP.rotated(rng.randf_range(0,1)*2*PI)*enemy_spawn_distance
		enemy_amount += 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#spawn_enemy()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("o"):
		open_close_shop()
	#if time_till_spawn <= 0:
		#spawn_enemy()
		#time_till_spawn = enemy_spawn_rate
	#time_till_spawn -= delta

func open_close_shop():
	if !shop_open:
		shop = shop_scene.instantiate()
		shop.position = Vector2(400, 10)
		$CanvasLayer.add_child(shop)
		shop_open = true
	else:
		shop.queue_free()
		shop_open = false


func _on_retry_pressed() -> void:
	pass # Replace with function body.
