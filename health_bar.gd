extends TextureProgressBar

@onready var player = $"../../player_skib"

func _ready():
	player.healthChanged.connect(update)
	update()

func update():
	max_value = player.max_health
	value = player.health
	
