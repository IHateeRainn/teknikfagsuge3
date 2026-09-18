extends Control


func _on_return_to_death_pressed() -> void:
	hide()
	$"../DeathScreen".show()
