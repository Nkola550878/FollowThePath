extends Button

func _on_button_down(extra_arg_0: int) -> void:
	GameManager.LoadLevel(extra_arg_0);
