extends Location

@onready var pro_scene = preload("res://Scenes/Projectile.tscn")

var cooldown : float = 1.5
var timer : float = 0
var range : float = 160

var pos : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer -= delta
	if timer <= 0:
		if shoot():
			timer = cooldown

func setPosition(p : Vector2) -> void:
	pos = p

func shoot() -> bool:
	var target : Enemy = null
	for e in GameflowManager.enemyList.get_children():
		if pos.distance_to(e.position) < range:
			if target == null or e.further(target):
				target = e;
	
	if target != null:
		var projectile = pro_scene.instantiate()
		projectile.start((target.position - pos).normalized(), 2000, range*1.5, pos)
		GameflowManager.projectiles.add_child(projectile)
		
	return target != null
