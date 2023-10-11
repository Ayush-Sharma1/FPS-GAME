extends Node


# Called when the node enters the scene tree for the first time.
func call_loading_screen(target):
	var loading_screen = preload("res://loading_screen.tscn").instantiate()
	loading_screen.next_scene_path = target
	get_tree().current_scene.add_child(loading_screen)
	
