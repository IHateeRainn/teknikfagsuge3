extends Area2D
const explosion_animation_scene = preload("res://Projectiles/animated_sprite_2d.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var animation = explosion_animation_scene.instantiate()
	animation.global_position = global_position
	animation.scale = Vector2(5,5)
	get_tree().current_scene.add_child(animation)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.add_fire_stack()


func _on_timer_timeout() -> void:
	self.queue_free()
	pass # Replace with function body.
