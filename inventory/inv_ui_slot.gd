extends Panel

@onready var item_visual: Sprite2D = $CenterContainer/Panel/Sprite2D

func update(item: InvItem):
	if !item:
		item_visual.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = item.texture
