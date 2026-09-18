extends Button


@onready var b: Button = $"."


func _process(delta: float) -> void:
	if b.pressed:
		print("stop thouthksa")
	print("yay")
