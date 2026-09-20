extends Control


func _ready():
	get_tree().paused = true 

func _on_start_pressed():
	hide()
	get_tree().paused = false
	
	var spawner := get_tree().current_scene.find_child("WaveSpawner")
	
	if spawner == null:
		print("ERROR: WaveSpawner not found!")
		return
	
	spawner.current_level = 1
	spawner._start_wave()
	#Level_manager.load_level(Level_manager.level_number)
	
