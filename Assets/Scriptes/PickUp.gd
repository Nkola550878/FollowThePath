extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if (body.get_script().get_path() == "res://Assets/Scriptes/Car.gd"):
		queue_free();
		print("car");
	pass # Replace with function body.
