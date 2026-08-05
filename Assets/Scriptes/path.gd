extends Node2D

@onready var line_2d: Line2D = $Line2D
var gridSize = 7;
var size = Vector2(490, 490);
var tileSize : Vector2;
var lastClick : Vector2i = Vector2i(100, 0);

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
	if (Input.is_action_just_pressed("Select")):
		var currentClick : Vector2i;
		currentClick = MouseGridPosition();
		if ((currentClick - lastClick).x - (currentClick - lastClick).y == 0 
		or (currentClick - lastClick).x + (currentClick - lastClick).y == 0):
			var k = (lastClick.y - currentClick.y) / (lastClick.x - currentClick.x);
			var n = (lastClick.x * currentClick.y - currentClick.x * lastClick.y) / (lastClick.x - currentClick.x);
			FoldPaper(k, n);
			DrawPath();
			pass
		lastClick = currentClick;

func FoldPaper(k, n) -> void:
	var i : int = 1;
	while (i < self.get_child_count() - 1):
		var child1GridPos = WorldToGrid(self.get_child(i).global_position);
		var child2GridPos = WorldToGrid(self.get_child(i + 1).global_position);
		var intersection : Vector2;
		if (child1GridPos == child2GridPos):
			i += 1;
			continue;
		if (child1GridPos.y == k * child1GridPos.x + n):
			i += 1;
			continue;
		if (child1GridPos.x == child2GridPos.x):
			intersection = Vector2(child1GridPos.x, k * child1GridPos.x + n);
			var instance = pathNode.instantiate();
			instance.position = GridToWorld(intersection);
			add_child(instance);
			move_child(instance, i + 1);
			if(child1GridPos.y - k * child1GridPos.x - n > child2GridPos.y - k * child2GridPos.x - n):
				self.get_child(i).position = GridToWorld(Mirror(child1GridPos, k, n));
				pass
		if (child1GridPos.y == child2GridPos.y):
			print("y");
		i += 1;

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
	pass;
