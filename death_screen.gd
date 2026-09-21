extends Control

func _on_inv_pressed() -> void:
	hide()
	$"../Inventory".show()


func _on_retry_pressed():
	hide()
	get_tree().paused = false
	
	var scene := get_tree().current_scene
	for child in scene.get_children():
		if child.is_in_group("enemy"):
			child.queue_free()

	
	var player := get_tree().current_scene.find_child("player_skib")
	if player:
		player.health = player.max_health
	
	for ball in get_tree().get_nodes_in_group("cannonball"):
		ball.queue_free()
		
	for e in get_tree().get_nodes_in_group("explosion"):
			e.call_deferred("free")
	
	var spawner := get_tree().current_scene.find_child("WaveSpawner")
	
	var shop := get_tree().current_scene.find_child("Shop")
	if shop:
		shop.hide()
	
	if spawner == null:
		print("ERROR: WaveSpawner not found!")
		return
	
	spawner.shop_open = false
	spawner._start_wave()


func _on_quit_pressed() -> void:
	hide()
	get_tree().reload_current_scene()
	$"../StartMenu".show()
