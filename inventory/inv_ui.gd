extends Control

@onready var inv: Inv = preload("res://inventory/player_inventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
@onready var placeholder: InvItem = preload("res://inventory/items/placeholder.tres")
@export var player_inventory: Inv

var comparison_inventory: Array[InvItem]
var is_open = false

func _ready() -> void:
	comparison_inventory = player_inventory.items.duplicate()
	for slot in slots:
		slot.item_clicked.connect(_on_item_clicked)
	
	update_slots()
	close()

func _process(delta):
	if comparison_inventory != player_inventory.items:
		print("item_bought")
		update_slots()
		comparison_inventory = player_inventory.items.duplicate()
	
	if Input.is_action_just_pressed("i"):
		update_slots()
		if is_open:
			close()
		else:
			open()

func update_slots():
	for i in range(min(inv.items.size(), slots.size())):
		slots[i].update(inv.items[i])

func open():
	visible = true
	is_open = true

func close():
	visible = false
	is_open = false

func _on_item_clicked(item: InvItem):
	var index := inv.items.find(item)
	if index != -1:
		player_inventory.gold += player_inventory.items[index].cost*0.5
		inv.items.remove_at(index)
		
		update_slots()


func _on_wave_spawner_level_over() -> void:
	print("level over signal")
	update_slots()
	open()



func _on_wave_spawner_shop_closed() -> void:
	print("shop closed signal")
	update_slots()
	close()
	$"../../player_skib".health = $"../../player_skib".max_health
