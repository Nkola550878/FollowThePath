extends Node2D

var levelID : int;
@export var congratulations : PackedScene;
@export var lost : PackedScene;

func LoadLevel(levelIndex):
	levelID = levelIndex;
	var path : String = "res://Assets/Scenes/Level" + str(levelIndex) + ".tscn";
	if ResourceLoader.exists(path):
		get_tree().change_scene_to_file(path);
		return
	get_tree().change_scene_to_file("res://Assets/Scenes/LevelSelector.tscn")
	pass;

func LoadCongratulationsScene(number):
	var instance = congratulations.instantiate();
	instance.size = Vector2(1152, 648);
	instance.get_child(0).get_child(1).text = str(number) + "/" + str(number);
	print(get_parent().get_child(1).position);
	get_parent().get_child(1).add_child(instance);

func LoadLostScene(pickedUp, number):
	var text : String;
	if (number == 0):
		text = "you have to make it to the end";
	else:
		text = str(pickedUp) + "/" + str(number);
	var instance = lost.instantiate();
	instance.size = Vector2(1152, 648);
	instance.get_child(0).get_child(1).text = text;
	print(get_parent().get_child(1).position);
	get_parent().get_child(1).add_child(instance);

func NextLevel():
	levelID += 1;
	LoadLevel(levelID);

func RestartLevel():
	LoadLevel(levelID);

func Manu():
	get_tree().change_scene_to_file("res://Assets/Scenes/LevelSelector.tscn");
