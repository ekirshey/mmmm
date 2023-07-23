extends StaticBody3D

@export var frequency : float = 1
@export var amplitude : float = 0.25
@export var rotation_speed : float = 1
@export var collectable_type: Globals.COLLECTABLE_TYPE

var time = 0
var value = 1

func _physics_process(delta):
	time += delta
	var movement = cos(time * frequency) * amplitude
	position.y += movement * delta
	rotate_y(delta * rotation_speed)

func collect():
	queue_free()
	value = 0
