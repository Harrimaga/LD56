extends Sprite2D

@onready var wood_texture = preload("res://Assets/Textures/Carryables/WoodAmmo.png")

var direction : Vector2
var speed : float
var maxDistance : float
var target : Enemy
var damage : int

func start(dir, s, dist, pos, e, dam, wood = false):
	direction = dir
	speed = s
	maxDistance = dist
	position = pos
	target = e
	damage = dam
	
	if wood:
		texture = wood_texture

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction*speed*delta
	maxDistance -= speed*delta
	
	if maxDistance < 0:
		if target != null:
			target.health -= damage
			if target.health <= 0:
				target.die()
				GameflowManager.score += 1
		queue_free();
