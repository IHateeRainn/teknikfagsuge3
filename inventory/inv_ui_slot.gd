extends Panel
var item: InvItem

func is_mouse_over() -> bool:
	var local_mouse_pos = get_local_mouse_position()
	return Rect2(Vector2.ZERO, size).has_point(local_mouse_pos)

signal item_clicked(item)

@onready var item_visual: Sprite2D = $CenterContainer/Panel/Sprite2D

func update(new_item: InvItem):
	item = new_item
	
	if !item:
		item_visual.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = item.texture

var hovering: bool

func _process(_delta):
	if is_mouse_over():
		hovering = true
		scale = Vector2(1.2,1.2)
	else:
		hovering = false
		scale = Vector2(1,1)


func _input(event) -> void:
	#Detects if mouse is hovering and clicks
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and hovering:
				item_clicked.emit(item)
