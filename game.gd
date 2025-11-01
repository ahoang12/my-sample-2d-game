extends Node2D

@export var BlockScene: PackedScene
@onready var player_spawn = $PlayerSpawnPoint
@onready var player_blocks = $Blocks/PlayerBlocks
@onready var timer = $GameTimer
@onready var camera = $Camera2D
@onready var wind_zone = $WindZone
@onready var message_label = $UILayer/MessageLabel

var current_block: RigidBody2D
var move_speed := 110.0
var move_direction := 1
var can_drop := false
var fall_timer := 0.0
var score := 0
var game_over := false
var has_landed := false

func _ready():
	spawn_block()
	timer.wait_time = 0.02
	timer.start()
	timer.timeout.connect(_on_Timer_timeout)
	wind_zone.wind_gust.connect(_on_wind_gust)

func get_highest_block_y() -> float:
	var min_y: float = player_spawn.position.y  # default if no blocks
	for block in player_blocks.get_children():
		if block.position.y < min_y:
			min_y = block.position.y
	return min_y

func spawn_block():
	var b = BlockScene.instantiate()
	
	# Determine where to spawn: above the tallest block
	var top_y := get_highest_block_y() - 30
	var spawn_y: float = minf(top_y - 110.0, player_spawn.position.y)

	b.position = Vector2(player_spawn.position.x, spawn_y)
	player_blocks.add_child(b)
	current_block = b
	can_drop = true


func _on_Timer_timeout():
	if current_block and can_drop:
		current_block.position.x += move_direction * move_speed * timer.wait_time
		
		# Reverse direction at horizontal bounds
		if current_block.position.x > player_spawn.position.x + 150:
			move_direction = -1
		elif current_block.position.x < player_spawn.position.x - 150:
			move_direction = 1

func _process(delta):
	if can_drop and Input.is_action_just_pressed("ui_accept"):  # Space or Enter
		drop_block() 
		update_camera()
	check_game_over()

func drop_block():
	if not is_instance_valid(current_block):
		return
	
	current_block.freeze = false
	current_block.gravity_scale = 1
	can_drop = false

	# Wait a bit for the block to land before spawning a new one
	await get_tree().create_timer(0.6).timeout

	# Double-check block still exists (avoid freed reference)
	if not is_instance_valid(current_block):
		return

	spawn_block()
		
func update_camera():
	# Get tower height and moving block position
	var top_y = get_highest_block_y()
	var target_y = top_y - 100.0
	var current_y = camera.position.y
	
	var target_x: float
	if current_block:
		target_x = current_block.position.x
	else:
		target_x = camera.position.x

	# Adaptive follow speed
	var speed: float = 0.4 + abs(target_y - current_y) / 500.0

	# Smoothly follow tower and block
	camera.position.y = lerp(current_y, target_y, clamp(speed, 0.1, 0.5))
	camera.position.x = lerp(camera.position.x, target_x, 0.08)

func _on_wind_gust(force: Vector2):
	if game_over:
		return

	for block in player_blocks.get_children():
		if block is RigidBody2D:
			block.apply_central_impulse(force)
	
	# Show on-screen wind message
	show_message("💨 Wind gust! Force: %.2f" % force.x, Color.YELLOW, 1.5)
			
func check_game_over():
	if game_over:
		return
	
	var unstable_blocks := 0
	
	for block in player_blocks.get_children():
		# 1. Detect if any block falls too low
		if block.global_position.y > player_spawn.global_position.y + 600:
			game_over_sequence()
			return
		
		# 2. Detect sudden horizontal movement or tilt (collapse)
		if abs(block.linear_velocity.x) > 300 or abs(block.angular_velocity) > 8:
			unstable_blocks += 1
	
	# If multiple blocks are moving wildly → tower collapse
	if unstable_blocks > 3:
		game_over_sequence()
			
func game_over_sequence():
	game_over = true
	timer.stop()
	can_drop = false
	
	# Freeze all blocks
	for block in player_blocks.get_children():
		if block is RigidBody2D:
			block.freeze = true
	
	var score = player_blocks.get_child_count()
	show_message("💀 Game Over! Final Score: %d" % score, Color.RED, 999)
	
func show_message(text: String, color: Color, duration: float):
	message_label.text = text
	message_label.modulate = color
	message_label.visible = true
	
	if duration < 999:
		await get_tree().create_timer(duration).timeout
		message_label.visible = false
