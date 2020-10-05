extends Node2D

var welding = true

# Called when the node enters the scene tree for the first time.
func _ready(): 
	unweld()

func weld(): 
	if welding: $AnimatedSprite.play("welded")

func unweld():
	$AnimatedSprite.play("unwelded")

func start_welding(): welding = true
func stop_welding(): welding = false
