extends Control


func _on_inv_pressed() -> void:
	hide()
	$"../Inventory".show()


func _on_retry_pressed():
	hide()
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_quit_pressed() -> void:
	hide()
	get_tree().reload_current_scene()
	$"../StartMenu".show()
