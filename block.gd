extends RigidBody2D

var falling := false

func drop():
	falling = true
	gravity_scale = 1
	freeze = true
