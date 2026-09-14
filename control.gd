extends Control
class_name Shop

@export var sell_card: PackedScene
@export var card_container: HBoxContainer

func _ready():
	for i in range(5):
		var sell_card_instance = sell_card.instantiate()
		card_container.add_child(sell_card_instance)
