extends Camera2D

onready var player = get_parent()

var target_zoom = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	target_zoom = zoom


func set_zoom(val):
	zoom = Vector2.ONE * val
	reset_target_zoom()
	player.place_panels()

func set_smooth_zoom(val):
	target_zoom = Vector2.ONE * val

func reset_target_zoom(): 
	target_zoom = zoom

func _process(delta):
	if zoom != target_zoom:
		var sgn = (int(zoom < target_zoom) - 0.5) * 2
		var zoom_speed = max(0.075, abs(zoom.x - target_zoom.x) / 2)
		zoom += Vector2.ONE * zoom_speed * sgn * delta
		player.place_panels()
