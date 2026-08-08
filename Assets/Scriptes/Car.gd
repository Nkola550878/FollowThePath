extends CharacterBody2D

var move := false;
var startPosition : Vector2;
var nextNodeIndex : int = 1;

var numbersOfPickUps : int;
@export var PickUpParent : Node;
@onready var path: Node2D = $"../Path"
@onready var endNode: Node2D = $"../EndNode"
@export var speed : float;

func _ready() -> void:
	startPosition = position;
	numbersOfPickUps = PickUpParent.get_child_count();
	pass;

func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("Start")):
		move = true;
	if (move):
		if (global_position.distance_squared_to(path.get_child(nextNodeIndex).global_position) < 0.1):
			nextNodeIndex += 1;
			if (nextNodeIndex == path.get_child_count()):
				move = false;
				GameManager.LoadLostScene(numbersOfPickUps - PickUpParent.get_child_count(), 0);
				print("lose");
				#ADD LOSE SCREEN
				return; 
		global_position.x = move_toward(global_position.x, path.get_child(nextNodeIndex).global_position.x, speed);
		global_position.y = move_toward(global_position.y, path.get_child(nextNodeIndex).global_position.y, speed);
		if (global_position.distance_squared_to(endNode.global_position) < 0.1):
			move = false;
			if (PickUpParent.get_child_count() == 0):
				GameManager.LoadCongratulationsScene(numbersOfPickUps);
				#ADD WIN SCREEN
				print("win");
			else:
				GameManager.LoadLostScene(numbersOfPickUps - PickUpParent.get_child_count(), numbersOfPickUps);
				print("you need to to pick up pickups");
