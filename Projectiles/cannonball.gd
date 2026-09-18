extends RigidBody2D
var explosion_scene = preload("res://projectiles/animated_sprite_2d.tscn")
var can_richochet = 0
var lifespan = 7
var damage = 20
var crit_chance = 1
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if 100 - crit_chance < rng.randf_range(0,1)*100:
		damage *= 2
	contact_monitor = true
	max_contacts_reported = 10


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	lifespan -= delta
	if lifespan < 0:
		queue_free()
	for body in get_colliding_bodies():
		if body.is_in_group("terrain") and can_richochet > 0:
			return
		if body.is_in_group("hitable") and !body.is_in_group("player"):
			var explosion = explosion_scene.instantiate()
			explosion.global_position = global_position
			explosion.scale = Vector2(0.3,0.3)
			get_tree().current_scene.add_child(explosion)
			queue_free()
