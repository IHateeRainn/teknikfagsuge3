extends RigidBody2D

@export var inv: Inv

signal healthChanged

var speed = 100
var rSpeed = 1
var drag = -0.4
var cannonball_speed = 200
var reload_speed = 0.1
var reloading = false
var health = 100
var cannonball_damage = 20
var cannonball_scene = preload("res://Projectiles/cannonball.tscn")

var maxHealth = 100
@onready var anim = $"../CanvasLayer/pain/AnimationPlayer"

func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 10

func shoot():
	if !reloading:
		var cannonball = cannonball_scene.instantiate()
		for i in Inv:
			cannonball.can_richochet += i.richochet
		
		cannonball.global_position = position
		
		get_tree().current_scene.add_child(cannonball)
		cannonball.rotation = rotation+deg_to_rad(90)
		cannonball.linear_velocity = Vector2.UP.rotated(cannonball.rotation)*cannonball_speed+linear_velocity
		reloading = true
		await get_tree().create_timer(reload_speed).timeout
		reloading = false

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
			print(health)
			if health <= 0:
				get_tree().reload_current_scene()
