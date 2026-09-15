extends Node

#Når et level er færdigt skriv: Game_Manager.level_number += 1

var level_number = 1:
	set(value):
		level_number = value
		_on_level_completed_change(value)
		 
func _on_level_completed_change(value):
		print(value)
