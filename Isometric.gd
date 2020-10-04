extends Node

# Calculated manually, since Godot doesn't allow function calls here.
const LEFT = Vector2(-1, -0.5)
const RIGHT = Vector2(1, 0.5)
const UP = Vector2(1, -0.5)
const DOWN = Vector2(-1, 0.5)

func cartesian_to_isometric(vector):
	return Vector2(vector.x - vector.y, (vector.x + vector.y) / 2)

# Might be useful?
func isometric_to_cartesian(vector):
	var x = (vector.x + 2 * vector.y) / 2
	return Vector2(x, x - vector.x)

func isometric_distance(vector1, vector2):
	var val = 2 * (vector2.y - vector1.y)
	return sqrt(val * val + vector2.x - vector1.x)
