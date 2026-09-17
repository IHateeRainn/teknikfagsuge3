extends Control
class_name SellCard

@onready var item_visual: Sprite2D = $CenterContainer/Panel/Sprite2D
@export var card_frame: TextureRect
@export var all_items: Inv
@export var player_inventory: Inv
@export var placeholder_item: InvItem
@onready var player = $player_skib

var hovering: bool
var random_item

func _ready():
	random_item = all_items.items[randi() % all_items.items.size()]
	item_visual.texture = random_item.texture

func _process(_delta):
	if is_mouse_over_card():
		hovering = true
		scale = Vector2(1.2,1.2)
	else:
		hovering = false
		scale = Vector2(1,1)

func is_mouse_over_card():
	var mouse_pos: Vector2 = get_global_mouse_position()
	var sprite_rect = Rect2(card_frame.global_position, card_frame.get_size())
	return sprite_rect.has_point(mouse_pos)

func _input(event) -> void:
	#Detects if mouse is hovering and clicks
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and hovering:
			for i in player_inventory.items.size():
				if player_inventory.items[i] == placeholder_item:
					player_inventory.items[i] = random_item
					print(player_inventory.items)
					break
			self.queue_free()
