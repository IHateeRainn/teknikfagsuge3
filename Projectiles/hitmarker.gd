extends Control

@onready var label: Label = $Label
@onready var start_timer: Timer = $StartTimer
var time = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_timer.start()
	pass # Replace with function body.

func _process(delta: float) -> void:
	label.modulate.a = time
	time -= delta

func _on_start_timer_timeout() -> void:
	self.queue_free()
