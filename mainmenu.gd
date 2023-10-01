extends Control


func _on_play_pressed():
	Loaderscript.call_loading_screen("res://round1.tscn")


func _on_quit_pressed():
	get_tree().quit()

