extends Control
class_name Shop

@export var sell_card: PackedScene
@export var card_container: HBoxContainer
@export var shop_inventory: Inv

func _ready():
	for i in range(3):
		var sell_card_instance = sell_card.instantiate()
		card_container.add_child(sell_card_instance)
