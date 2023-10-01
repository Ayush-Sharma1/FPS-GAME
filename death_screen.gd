extends Control
@onready var whoosh = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("defeat")
	whoosh.play()

func _on_play_again_pressed():
	get_tree().change_scene_to_file("res://loading_screen.tscn")


func _on_quit_pressed():
	get_tree().quit()


