extends Control
class_name SellCard

@export var card_frame: TextureRect
@export var all_items: Inv
@export var player_inventory:Inv

var placeholder: InvItem = preload("res://inventory/items/placeholder.tres")

var hovering: bool
var random_item

func _ready():
	random_item = all_items.items[randi() % all_items.items.size()]

func _process(_delta):
	if is_mouse_over_card():
		hovering = true
		card_frame.scale = Vector2(1.2,1.2)
	else:
		hovering = false
		card_frame.scale = Vector2(1,1)

func is_mouse_over_card():
	var mouse_pos: Vector2 = get_global_mouse_position()
	var sprite_rect = Rect2(card_frame.global_position, card_frame.texture.get_size())
	return sprite_rect.has_point(mouse_pos)

func _input(event) -> void:
	#Detects if mouse is hovering and clicks
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and hovering:
			for i in player_inventory.items:
				if player_inventory.items[i] is placeholder:
					player_inventory.items[i] = random_item
			self.queue_free()
