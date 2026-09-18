extends Node
class_name Level_Manager

#Når et level er færdigt skriv: LevelManager.level_number += 1

#level count
var level_number = 1:
	set(value):
		level_number = value
		_on_level_completed_change(value)
		 
func _on_level_completed_change(value):
		print(value)
