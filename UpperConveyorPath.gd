extends "res://ConveyorPath.gd"

func _ready():
	init(634, 122)
	follow = [$Follow1, $Follow2, $Follow3, $Follow4, $Follow5, $Follow6, $Follow7, $Follow8]
	set_process(true)
