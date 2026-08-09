extends Node2D

@onready var line_2d: Line2D = $Line2D
var gridSize = 7;
var size = Vector2(490, 490);
var tileSize : Vector2;
var lastClick : Vector2i = Vector2i(100, 0);
var shouldUpdate : bool;

@export var pathNode : PackedScene;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tileSize = size / gridSize;
	DrawPath()
	pass # Replace with function body.

func DrawPath() -> void:
	line_2d.clear_points();
	for i in range(1, self.get_child_count()):
		line_2d.add_point(self.get_child(i).position);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("Restart")):
		GameManager.RestartLevel();
	if (Input.is_action_just_pressed("Manu")):
		GameManager.Manu();
	if (Input.is_action_just_pressed("Select")):
		var currentClick : Vector2i;
		currentClick = MouseGridPosition();
		if ((currentClick - lastClick).x - (currentClick - lastClick).y == 0 
		or (currentClick - lastClick).x + (currentClick - lastClick).y == 0):
			var k = (lastClick.y - currentClick.y) / (lastClick.x - currentClick.x);
			var n = (lastClick.x * currentClick.y - currentClick.x * lastClick.y) / (lastClick.x - currentClick.x);
			FoldPaper(k, n);
			DrawPath();
			#TryConnect();
			call_deferred("TryConnect");
			call_deferred("RemoveExtraVertices");
			lastClick = Vector2i(100, 0);
			currentClick = Vector2i(100, 0);
		lastClick = currentClick;

func RemoveExtraVertices():
	var i = 2;
	while (i  < self.get_child_count() - 1):
		var child0 = self.get_child(i - 1);
		var child1 = self.get_child(i);
		var child2 = self.get_child(i + 1);
		var diff1 = child0.position - child1.position;
		var diff2 = child2.position - child1.position;
		print(child1.name);
		if(diff1.x * diff2.y - diff2.x * diff1.y == 0):
			self.remove_child(child1);
			print(child1.name);
			continue;
		i += 1;


func TryConnect() -> void:
	if (self != get_parent().get_child(0)):
		return;
	if (self.get_parent().get_child_count() == 1):
		return;
	if (get_child(-1).position == get_parent().get_child(1).get_child(-1).position && self != get_parent().get_child(1)):
		Connect(self, self.get_parent().get_child(1), -1, -1);
	DrawPath();

func Connect(object1, object2, index1, index2) -> void:
	if(index2 == -1 and index1 == -1):
		for i in range(object2.get_child_count() - 2, 0, -1):
			var temp = object2.get_child(i);
			object2.get_child(i).reparent(object1);
		object2.queue_free();

func FoldPaper(k, n) -> void:
	var i : int = 1;
	var intersection1 : Vector2 = Vector2(-100, -100);
	var intersection2 : Vector2 = Vector2(-100, -100);
	var intersectionIndex1 : int = -1;
	var intersectionIndex2 : int = -1;
	while (i < self.get_child_count() - 1):
		var child1GridPos = WorldToGrid(self.get_child(i).global_position);
		var child2GridPos = WorldToGrid(self.get_child(i + 1).global_position);
		if (intersection1 == Vector2(-100, -100)):
			intersection1 = FindIntersection(child1GridPos, child2GridPos, k, n);
			if (intersection1 != Vector2(-100, -100)):
				intersectionIndex1 = i;
			i += 1;
			continue;
		if (intersection2 == Vector2(-100, -100)):
			intersection2 = FindIntersection(child1GridPos, child2GridPos, k, n);
			if (intersection2 == Vector2(-100, -100)):
				i += 1;
				continue;
			intersectionIndex2 = i;
		if (intersectionIndex1 != -1 and intersectionIndex2 != -1):
			AddIntersectionPoint(intersection1, intersectionIndex1);
			AddIntersectionPoint(intersection2, intersectionIndex2 + 1);
			intersectionIndex1 += 1;
			intersectionIndex2 += 2;
			for i2 in range(intersectionIndex1, intersectionIndex2):
				var gridPosition = WorldToGrid(self.get_child(i2).global_position);
				gridPosition = Mirror(gridPosition, k, n);
				self.get_child(i2).position = GridToWorld(gridPosition);
			intersection1 = intersection2;
			intersection2 = Vector2(-100, -100);
			intersectionIndex1 = intersectionIndex2;
			intersectionIndex2 = -1;
		i += 1;
	if ((intersectionIndex1 != -1) and (get_child(-1).global_position != $"../../EndNode".global_position)):
		AddIntersectionPoint(intersection1, intersectionIndex1);
		intersectionIndex1 += 1;
		for i2 in range(intersectionIndex1, self.get_child_count()):
			var gridPosition = WorldToGrid(self.get_child(i2).global_position);
			gridPosition = Mirror(gridPosition, k, n);
			self.get_child(i2).position = GridToWorld(gridPosition);

func AddIntersectionPoint(intersection, intersectionIndex):
	var instance = pathNode.instantiate();
	instance.position = GridToWorld(intersection);
	add_child(instance);
	move_child(instance, intersectionIndex + 1);

func FindIntersection(child1GridPos, child2GridPos, k, n) -> Vector2:
	var intersection : Vector2;
	var k2 = 1 / k;
	var n2 = -n / k;
	if (child1GridPos.x == child2GridPos.x):
		intersection = Vector2(child1GridPos.x, k * child1GridPos.x + n);
		if ((intersection.y > child1GridPos.y or intersection.y < child2GridPos.y) and (intersection.y > child2GridPos.y or intersection.y < child1GridPos.y)):
			return Vector2(-100, -100);
	if (child1GridPos.y == child2GridPos.y):
		intersection = Vector2(child1GridPos.y * k2 + n2, child1GridPos.y);
		if ((intersection.x > child1GridPos.x or intersection.x < child2GridPos.x) and (intersection.x > child2GridPos.x or intersection.x < child1GridPos.x)):
			return Vector2(-100, -100);
	if ((intersection == child1GridPos) or (intersection == child2GridPos)):
		return Vector2(-100, -100);
	return intersection;

func Mirror(point, k, n) -> Vector2:
	var temp : Vector2;
	temp.x = k * point.y - k * n;
	temp.y = k * point.x + n;
	return temp;

func WorldToGrid(pos) -> Vector2:
	return (pos + (size / 2) - position) / tileSize;

func GridToWorld(pos) -> Vector2:
	return pos * tileSize - (size / 2);

func MouseGridPosition() -> Vector2i:
	var mousePosition : Vector2 = get_viewport().get_mouse_position();
	var gridPosition = WorldToGrid(mousePosition).round()
	return gridPosition
