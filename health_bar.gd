extends TextureProgressBar

@onready var player = $"../../player_skib"

func _ready():
	player.healthChanged.connect(update)
	update()

func update():
	value = player.health * 100 / player.max_health
	max_value = player.max_health
