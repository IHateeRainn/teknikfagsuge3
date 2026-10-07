extends Area2D
const explosion_animation_scene = preload("res://Projectiles/animated_sprite_2d.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var animation = explosion_animation_scene.instantiate()
	animation.global_position = global_position
	animation.scale = Vector2(10,10)
	get_tree().current_scene.add_child(animation)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		print("gas_works")
		body.fire_stacks += 1
		await get_tree().create_timer(body.fire_duration).timeout
		if body == self:
			body.fire_stacks -= 1
