extends CharacterBody3D

var hp = 100

func _process(delta):
	if hp <= 0:
		queue_free()
