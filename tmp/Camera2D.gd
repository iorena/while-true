extends Camera2D

var target_zoom = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	target_zoom = zoom

func set_zoom(val):
	zoom = Vector2.ONE * val
	reset_target_zoom()

func set_smooth_zoom(val):
	target_zoom = Vector2.ONE * val

func reset_target_zoom(): 
	target_zoom = zoom

func zooming_in_process(): return zoom != target_zoom

func process_zoom(delta):
	var zoom_diff = zoom.x - target_zoom.x
	if abs(zoom_diff) < 0.05: target_zoom = zoom
	else: zoom += Vector2.ONE * -zoom_diff / 2 * delta
