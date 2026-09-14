extends TextureProgressBar

@onready var player = $"../../player_skib"

func _ready():
	player.healthChanged.connect(update)
	update()

func update():
	value = player.health * 100 / player.maxHealth
	
