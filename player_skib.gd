extends RigidBody2D

@export var player_inventory: Inv

signal healthChanged

var cannonball_scene = preload("res://Projectiles/cannonball.tscn")
var big_cannonball_scene = preload("res://Projectiles/big_cannonball.tscn")

var speed = 100
var rSpeed = 1.8
var drag = -0.4

var cannonball_speed = 350
var base_reload_speed = 0.6
var reload_speed = 0.6
var reloading = false

var health = 200
var max_health = 200
var base_health = 200

var sideshot_item = 0
var big_cannonball_item = 0
var gasoline_item = 0

var comparison_items = []

@onready var anim = $"../CanvasLayer/pain/AnimationPlayer"

func _ready() -> void:
	comparison_items = player_inventory.items.duplicate()
	contact_monitor = true
	max_contacts_reported = 10
	inventory_changed()

func fire_cannonball(direction):
	if big_cannonball_item > 0:
		var big_cannonball = big_cannonball_scene.instantiate()
		for i in player_inventory.items:
			big_cannonball.can_richochet += i.can_richochet
			big_cannonball.damage += i.damage_boost
			big_cannonball.crit_chance += i.crit_chance
		big_cannonball.damage += 40 * reload_speed
		big_cannonball.global_position = position
		big_cannonball.rotation = rotation+deg_to_rad(90)
		big_cannonball.linear_velocity = direction*Vector2.UP.rotated(big_cannonball.rotation)*cannonball_speed+linear_velocity
		get_tree().current_scene.add_child(big_cannonball)
	else:
		var cannonball = cannonball_scene.instantiate()
		for i in player_inventory.items:
			cannonball.can_richochet += i.can_richochet
			cannonball.damage += i.damage_boost
			cannonball.crit_chance += i.crit_chance
			cannonball.gasoline += gasoline_item
		cannonball.global_position = position
		cannonball.rotation = rotation+deg_to_rad(90)
		cannonball.linear_velocity = direction*Vector2.UP.rotated(cannonball.rotation)*cannonball_speed+linear_velocity
		get_tree().current_scene.add_child(cannonball)

func shoot():
	if !reloading:
		fire_cannonball(1)
		if sideshot_item >= 1:
			sideshot_item = 1
			fire_cannonball(-1)
		reloading = true
		await get_tree().create_timer(reload_speed).timeout
		reloading = false

func inventory_changed():
	max_health = base_health
	reload_speed = base_reload_speed
	big_cannonball_item = 0
	for i in player_inventory.items:
		max_health += i.health_boost
		reload_speed = reload_speed * i.attack_speed_boost
		big_cannonball_item += i.big_explosive_cannonball
		gasoline_item += i.gasoline
		sideshot_item += i.sideshot
	health = max_health

func _physics_process(delta: float) -> void:
	#drag
	apply_central_force(linear_velocity*drag)
	
	#steering force:
	apply_central_force(Vector2.UP.rotated(rotation)*linear_velocity.length()-linear_velocity)
	
	#steering
	if Input.is_key_pressed(KEY_W):
		apply_central_force(Vector2.UP.rotated(rotation)*speed)
	if Input.is_key_pressed(KEY_SPACE):
		shoot()
	if Input.is_key_pressed(KEY_A) and !Input.is_key_pressed(KEY_D):
		angular_velocity = -rSpeed
	elif Input.is_key_pressed(KEY_D) and !Input.is_key_pressed(KEY_A):
		angular_velocity = rSpeed
	for body in get_colliding_bodies():
		if body.is_in_group("enemy_cannonball"):
			health -= body.damage
			anim.play("pain")
			healthChanged.emit()
			if health <= 0:
				get_tree().paused = true
				$"../../../UI/DeathScreen".show()
				
	if comparison_items != player_inventory.items:
		inventory_changed()
		comparison_items = player_inventory.items.duplicate()


func _on_wave_spawner_shop_closed() -> void:
	health = max_health
	pass # Replace with function body.
#hej
