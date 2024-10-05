extends Node2D

@onready var tile = preload("res://Scenes/Tiles/ground.tscn")

var width : int
var height : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	loadMap("res://Assets/Levels/lvl.txt")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func getTile(x : int, y : int) -> Sprite2D:
	return $Grid.get_child(x + y * width)

func loadMap(path : String) -> void:
	var file := FileAccess.open(path, FileAccess.READ)
	var content := file.get_as_text()
	var lines := content.split('\n')
	
	var sizes := lines[0].split(' ')
	width = sizes[0].to_int()
	height = sizes[1].to_int()
	
	for y in range(1, lines.size()):
		for x in range(lines[y].length()):
			var t = tile.instantiate()
			if lines[y][x] == '\r': continue
			match lines[y][x]:
				'.': t.setGroundTile()
				'p': t.setPathTile()
				'w': t.setWoodTile()
				's': t.setStoneTile()
			t.setPos(Vector2(x*32, (y - 1) * 32))
			$Grid.add_child(t)
	
	
	
