extends ParallaxBackground

var speed: float = 100.0 # Adjust the speed as needed

func _process(delta):
	scroll_offset.x += speed * delta # Scrolls horizontally
	# or scroll_offset.y += speed * delta for vertical scrolling
