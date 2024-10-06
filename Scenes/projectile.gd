extends Sprite2D


var direction : Vector2
var speed : float
var maxDistance : float
var target : Enemy

func start(dir, s, dist, pos, e):
	direction = dir
	speed = s
	maxDistance = dist
	position = pos
	target = e

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction*speed*delta
	maxDistance -= speed*delta
	
	if maxDistance < 0:
		target.health -= 1
		if target.health <= 0:
			target.die()
			GameflowManager.score += 1
		queue_free();
