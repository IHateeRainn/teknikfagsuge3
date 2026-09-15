extends RigidBody2D

var lifespan = 7
var explosion_scene = preload("res://Projectiles/animated_sprite_2d.tscn")
var damage = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	for body in get_colliding_bodies():
		if body.is_in_group("hitable") and !body.is_in_group("enemy"):
			var explosion = explosion_scene.instantiate()
			explosion.global_position = global_position
			explosion.scale = Vector2(0.3,0.3)
			get_tree().current_scene.add_child(explosion)
			queue_free()
	if lifespan < 0:
		queue_free()
	lifespan -= delta
