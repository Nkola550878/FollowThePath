extends Node2D

@onready var line_2d: Line2D = $Line2D
var gridSize = 7;
var size = Vector2(490, 490);
var lastClick : Vector2i;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
			print("cut");
			#insert cutting code
			pass
		lastClick = currentClick;

func MouseGridPosition() -> Vector2i:
	var mousePosition : Vector2 = get_viewport().get_mouse_position();
	mousePosition -= position;
	mousePosition += size / 2;
	mousePosition = mousePosition.round();
	var gridPosition : Vector2i;
	var tileSize = size / gridSize;
	gridPosition = (mousePosition / tileSize).round();
	return gridPosition
	pass;
