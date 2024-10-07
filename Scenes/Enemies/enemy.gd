class_name Enemy extends Location

@export var pathIndex : int = 0
@export var progress : float = 0
@export var health : int = 2
@export var speed : float = 5
@export var flying : bool

var decay_time : float = 30
var decay_timer : float
var dead : bool

var task : TaskManager.Task

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dead = false
	setPos()

func setPos() -> void:
	if pathIndex >= GameflowManager.enemyPath.size()-1 and !dead:
		position = GameflowManager.enemyPath[GameflowManager.enemyPath.size()-1] * Vector2(32, 32)
		GameflowManager.health -= 1
		die()
		return
	
	var next_pos = GameflowManager.enemyPath[pathIndex] * Vector2(32, 32) * (1 - progress) + GameflowManager.enemyPath[pathIndex + 1] * Vector2(32, 32) * progress
	
	var d : Vector2 = (next_pos - position).normalized()
	
	if d.x == 1:
		rotation_degrees = 90
	elif d.x == -1:
		rotation_degrees = 270
	elif d.y == 1:
		rotation_degrees = 180
	elif d.y == -1:
		rotation_degrees = 0
	
	position = next_pos
	
func die() -> void:
	dead = true
	decay_timer = decay_time
	if GameflowManager.universities.size() > 0:
		task = TaskManager.add_task(self, null, 1)
		
func origin_action(ant : Ant, delta : float) -> bool:
	if ant.add_to_inventory(CarryingResource.new(CarryingResource.ResourceType.BODY)):
		queue_free()
		return true
	return false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if dead:
		decay_timer -= delta
		if decay_timer <= 0:
			TaskManager.remove_task(task)
			queue_free()
		return

	progress += delta*speed
	while progress > 1:
		pathIndex += 1
		progress -= 1
	setPos()
	
func further(e : Enemy) -> bool:
	return pathIndex > e.pathIndex or (pathIndex == e.pathIndex and progress > e.progress)
