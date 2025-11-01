extends Node2D

@export var BlockScene: PackedScene
@onready var player_spawn = $PlayerSpawnPoint
@onready var player_blocks = $Blocks/PlayerBlocks
@onready var timer = $GameTimer
@onready var camera = $Camera2D
@onready var game_over_label = $GameOverLabel
@onready var wind_zone = $WindZone

var current_block: RigidBody2D
var move_speed := 110.0
var move_direction := 1
var can_drop := false
var fall_timer := 0.0
var score := 0
var game_over := false
var has_landed := false

func _ready():
	game_over_label.visible = false
	spawn_block()
	timer.wait_time = 0.02
	timer.start()
	timer.timeout.connect(_on_Timer_timeout)
	wind_zone.wind_gust.connect(_on_wind_gust)
	game_over_label.visible = false
	game_over_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	game_over_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	game_over_label.add_theme_color_override("font_color", Color.RED)
	game_over_label.add_theme_font_size_override("font_size", 48)

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

	print("💨 Wind gust! Force:", force.x)
	for block in player_blocks.get_children():
		if block is RigidBody2D:
			block.apply_central_impulse(force * 0.8)
			
func check_game_over():
	if game_over:
		return
	
	# Check if any block has fallen too far below the tower
	for block in player_blocks.get_children():
		if block.global_position.y > player_spawn.global_position.y + 600:
			game_over_sequence()
			return
			
func game_over_sequence():
	if game_over:
		return
	
	game_over = true
	timer.stop()
	can_drop = false
	
	# Calculate score = total blocks successfully stacked
	score = player_blocks.get_child_count() - 1  # minus current falling one
	game_over_label.text = "GAME OVER!\nScore: " + str(score)
	game_over_label.visible = true
	
	print("💀 Game Over! Final Score:", score)
