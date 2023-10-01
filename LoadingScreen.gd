extends CanvasLayer
@export var next_scene_path: String = "res://round1.tscn"
var progress = []
var scene_load_status

# Called when the node enters the scene tree for the first time.
func _ready():
	ResourceLoader.load_threaded_request(next_scene_path)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scene_load_status = ResourceLoader.load_threaded_get_status(next_scene_path, progress)
	await get_tree().create_timer(0.9).timeout
	$ProgressBar.value = progress[0] * 100
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(next_scene_path))
		get_tree().current_scene.queue_free()
