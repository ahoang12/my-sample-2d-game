extends Node2D

@export var BlockScene: PackedScene
@onready var spawn_point = $SpawnPoint
@onready var block_container = $Blocks
@onready var timer = $GameTimer
@onready var target_label = $TargetLabel
var block_scene = preload("res://block.tscn")
var target_value: int
var current_block: RigidBody2D
var time_left: float = 180.0
var game_over_flag := false

func _ready():
	randomize()
	target_value = randi_range(128, 512)  # 🎯 Random target for this round
	target_label.text = "Target: " + str(target_value)
	timer.wait_time = 1.0    
	timer.start()
	spawn_new_block()
	print("🎯 Target for this round:", target_value)

func spawn_new_block():
	var b = BlockScene.instantiate()
	b.position = spawn_point.position
	b.gravity_scale = 0
	b.freeze = true
	block_container.add_child(b)
	current_block = b

func choose_block_value() -> int:
	var values = [2, 4, 8, 16]
	return values[randi() % values.size()]

func _process(delta):
	time_left -= delta
	if time_left <= 0:
		game_over("⏰ Time’s up!")
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_down"):
		drop_block()
	check_win_condition()
	check_height_limit()

func drop_block():
	if current_block:
		current_block.freeze = false
		current_block.gravity_scale = 1
		current_block = null
		await get_tree().create_timer(0.5).timeout
		spawn_new_block()

func check_win_condition():
	for b in block_container.get_children():
		if b.value >= target_value:
			win_game()

func check_height_limit():
	for b in block_container.get_children():
		if b.position.y < 0:
			game_over("🏗 Tower too tall!")

func win_game():
	print("🎉 You win!")
	get_tree().paused = true

func game_over(reason: String):
	print("💀 Game over:", reason)
	get_tree().paused = true
