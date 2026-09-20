extends Control

@export var player_inventory: Inv

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var gold = str(roundi(player_inventory.gold))
	$Gold_counter.text = gold
	pass
