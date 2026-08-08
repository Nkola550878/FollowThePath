extends Node2D

var levelID : int;

func LoadLevel(levelIndex):
	levelID = levelIndex;
	var path : String = "res://Assets/Scenes/level" + str(levelIndex) + ".tscn";
	if ResourceLoader.exists(path):
		get_tree().change_scene_to_file(path);
		return
	get_tree().change_scene_to_file("res://Assets/Scenes/Congratulations.tscn")
	pass;

func NextLevel():
	levelID += 1;
	LoadLevel(levelID);

func RestartLevel():
	LoadLevel(levelID);

func Manu():
	get_tree().change_scene_to_file("res://Assets/Scenes/LevelSelector.tscn");
