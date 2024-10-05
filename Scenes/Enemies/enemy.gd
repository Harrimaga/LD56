class_name Enemy extends Sprite2D

var pathIndex : int = 0
var progress : float = 0
var health : int = 2
var speed : float = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setPos()

func setPos() -> void:
	if pathIndex >= GameflowManager.enemyPath.size()-1:
		position = GameflowManager.enemyPath[GameflowManager.enemyPath.size()-1] * Vector2(32, 32)
		GameflowManager.health -= 1
		print(GameflowManager.health)
		queue_free()
		return
	
	position = GameflowManager.enemyPath[pathIndex] * Vector2(32, 32) * (1 - progress) + GameflowManager.enemyPath[pathIndex + 1] * Vector2(32, 32) * progress
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress += delta*speed
	while progress > 1:
		pathIndex += 1
		progress -= 1
	setPos()
	
func further(e : Enemy) -> bool:
	return pathIndex > e.pathIndex or (pathIndex == e.pathIndex and progress > e.progress)
