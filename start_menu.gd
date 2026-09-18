extends Control

func _ready():
	get_tree().paused = true 

func _on_start_pressed():
	hide()
	get_tree().paused = false
	#Level_manager.load_level(Level_manager.level_number)
	
