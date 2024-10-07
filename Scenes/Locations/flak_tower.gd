extends Location

@onready var sprite : AnimatedSprite2D = $Sprite

var cooldown : float = 1.2
var timer : float = 0
var range : float = 176
var damage : float = 50

var upgraded : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TaskManager.add_task(null, self, 2, -1, true)
	
func destination_action(ant : Ant, task : TaskManager.Task, delta : float):
	ant.remove_from_inventory()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer -= delta
	if timer <= 0 and stockpile[2] > 0:
		if shoot():
			stockpile[2] -= 1
			timer = cooldown

func shoot() -> bool:
	var target = null
	for e in GameflowManager.enemyList.get_children():
		if !e.dead and e.flying:
			if global_position.distance_to(e.position) < range:
				if target == null or e.further(target):
					target = e;
	
	if target != null:
		var projectile = GameflowManager.pro_scene.instantiate()
		projectile.start((target.position - global_position).normalized(), 2000, global_position.distance_to(target.position), global_position, target, damage, true)
		GameflowManager.projectiles.add_child(projectile)
		
	if target != null:
		sprite.play("Shooting")

	return target != null

func perform_upgrade() -> void:
	upgraded += 1
	damage += 10
	range += 16
	cooldown *= 0.85
	
	
