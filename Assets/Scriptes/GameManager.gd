extends Node2D

var levelID : int;
@export var congratulations : PackedScene;

func LoadLevel(levelIndex):
	levelID = levelIndex;
	var path : String = "res://Assets/Scenes/level" + str(levelIndex) + ".tscn";
	if ResourceLoader.exists(path):
		get_tree().change_scene_to_file(path);
		return
	get_tree().change_scene_to_file("res://Assets/Scenes/LevelSelector.tscn")
	pass;

func LoadCongratulationsScene():
	var instance = congratulations.instantiate();
	instance.global_position = Vector2(576, 324);
	print(get_parent().get_child(1).position);
	get_parent().get_child(1).add_child(instance);
	pass;

func NextLevel():
	levelID += 1;
	LoadLevel(levelID);

func RestartLevel():
	LoadLevel(levelID);

func Manu():
	get_tree().change_scene_to_file("res://Assets/Scenes/LevelSelector.tscn");
