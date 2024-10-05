extends Node2D

@onready var tile = preload("res://Scenes/Tiles/ground.tscn")
@onready var enemy = preload("res://Scenes/Enemies/Enemy.tscn")
@onready var mine_scene = preload("res://Scenes/Locations/Mine.tscn")
@onready var tower_scene = preload("res://Scenes/Locations/BasicTower.tscn")

var width : int
var height : int

var beginPoint : Vector2
var goal : Vector2
var route : Array

var timer = 0

var stone_tiles : Array[Tile]
var wood_tiles : Array[Tile]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	loadMap("res://Assets/Levels/lvl.txt")
	calcEnemyPath()
	GameflowManager.enemyPath = route
	GameflowManager.enemyList = $Enemies
	GameflowManager.projectiles = $Projectiles
	
	var tower : Location = tower_scene.instantiate()
	build(tower, 4, 22)
	tower.setPosition(Vector2(4, 22)*32)
	
	var mine : Location = mine_scene.instantiate()
	build(mine, 50, 20)
	GameflowManager.stockpile_buildings.append(mine)
	var mine2 : Location = mine_scene.instantiate()
	build(mine2, 70, 2)
	GameflowManager.stockpile_buildings.append(mine2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	wave_update(delta)
	
func calcEnemyPath() -> void:
	var prev := Vector2(-1, -1)
	var curr := beginPoint
	route.push_back(curr)
	
	while curr != goal:
		if (getTile(curr.x - 1, curr.y) != null and
			getTile(curr.x - 1, curr.y).path and 
			Vector2(curr.x - 1, curr.y) != prev):
			prev = curr;
			curr = Vector2(curr.x - 1, curr.y)
			route.push_back(curr)
			continue
		if (getTile(curr.x + 1, curr.y) != null and
			getTile(curr.x + 1, curr.y).path and 
			Vector2(curr.x + 1, curr.y) != prev):
			prev = curr;
			curr = Vector2(curr.x + 1, curr.y)
			route.push_back(curr)
			continue
		if (getTile(curr.x, curr.y + 1) != null and
			getTile(curr.x, curr.y + 1).path and 
			Vector2(curr.x, curr.y + 1) != prev):
			prev = curr;
			curr = Vector2(curr.x, curr.y + 1)
			route.push_back(curr)
			continue
		if (getTile(curr.x, curr.y - 1) != null and
			getTile(curr.x, curr.y - 1).path and 
			Vector2(curr.x, curr.y - 1) != prev):
			prev = curr;
			curr = Vector2(curr.x, curr.y - 1)
			route.push_back(curr)
			continue
		break
	
func getTile(x : int, y : int) -> Tile:
	if x < 0 or x >= width or y < 0 or y >= height: return null
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
				'w': 
					t.setWoodTile()
					wood_tiles.append(t)
				's': 
					t.setStoneTile()
					stone_tiles.append(t)
				'b': t.setPathTile();beginPoint = Vector2(x, y - 1)
				'e': t.setPathTile();goal = Vector2(x, y - 1)
			t.setPos(Vector2(x*32, (y - 1) * 32))
			$Grid.add_child(t)
	
func build(building : Location, x : int, y : int):
	getTile(x, y).build(building)
	
func get_closest_resource(wood : bool, p_position : Vector2) -> Tile:
	
	var closest : Tile = null
	var distance : float = INF
	
	if wood:
		for tile in wood_tiles:
			var d = (tile.position - p_position).length_squared()
			
			if d < distance:
				closest = tile
				distance = d
	else:
		for tile in stone_tiles:
			var d = (tile.position - p_position).length_squared()
			
			if d < distance:
				closest = tile
				distance = d

	return closest


var wave : int = 0
var timerToNextWave : float = 15
var spawnTimer : float = 0
var spawnNextTimer : float = 0
var interval : float = 0
var type : int = 0
var difficulty : float = 1

func wave_update(delta : float):
	timerToNextWave -= delta
	if timerToNextWave <= 0:
		spawnTimer = 5 + 0.2*wave
		timerToNextWave = spawnTimer + max(6 - 0.1*wave, 2)
		interval = max(0.99 - 0.01*wave, 0.1)
		difficulty = 1 + wave/20.0
		difficulty *= difficulty
		
		wave += 1
		
		
	spawnTimer -= delta
	if spawnTimer > 0:
		spawnNextTimer -= delta
		if spawnNextTimer < 0:
			spawnEnemy()
			spawnNextTimer = interval
	
	

func spawnEnemy() -> void:
	var e = enemy.instantiate()
	e.health = int(difficulty)
	$Enemies.add_child(e)
