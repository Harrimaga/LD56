extends Sprite2D


var direction : Vector2
var speed : float
var maxDistance : float

func start(dir, s, dist, pos):
	direction = dir
	speed = s
	maxDistance = dist
	position = pos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction*speed*delta
	maxDistance -= speed*delta
	
	for e in GameflowManager.enemyList.get_children():
		if position.distance_to(e.position) < 24:
			e.health -= 1
			if e.health <= 0:
				e.queue_free();
			queue_free();
			return
	
	if maxDistance < 0:
		queue_free()
