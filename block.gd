extends RigidBody2D

@export var value: int = 2  # block's numerical value, default 2
@onready var label = $Label  # Label node to display the number

func _ready():
	label.text = str(value)

# Helper method to get the block's value
func get_value() -> int:
	return value

# This function is called when another body enters the MergeDetector Area2D
func _on_MergeDetector_body_entered(body):
	# Check if the other body is a RigidBody2D (another block)
	if body is RigidBody2D and body.has_method("get_value"):
		# Only merge if values match
		if body.get_value() == value:
			merge_with(body)

func merge_with(other_block):
	# Create a new block instance with doubled value
	var new_block = preload("res://block.tscn").instantiate()
	new_block.value = value * 2

	# Position new block at the midpoint of the two merged blocks
	new_block.position = (position + other_block.position) / 2

	# Add the new block to the same parent (e.g., the game scene)
	get_parent().add_child(new_block)

	# Remove the two original blocks
	queue_free()
	other_block.queue_free()
