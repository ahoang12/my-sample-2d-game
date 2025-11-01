extends Node2D

@export var interval_range := Vector2(8.0, 12.0)
@export var force_range := Vector2(-25.0, 25.0)

var active := true

@onready var wind_timer = $WindTimer

signal wind_gust(force: Vector2)

func _ready():
	randomize()
	start_wind()

func start_wind():
	wind_timer.wait_time = randf_range(interval_range.x, interval_range.y)
	wind_timer.start()
	wind_timer.timeout.connect(_on_wind_timer_timeout)

func _on_wind_timer_timeout():
	if not active:
		return

	var force = Vector2(randf_range(force_range.x, force_range.y), 0)
	emit_signal("wind_gust", force)

	# Restart for next gust
	start_wind()
