extends Location

@onready var pro_scene = preload("res://Scenes/Projectile.tscn")

var cooldown : float = 1.5
var timer : float = 0
var range : float = 160

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TaskManager.add_task(null, self, 5, -1, false)
	
func destination_action(ant : Ant, delta : float):
	ant.remove_from_inventory()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer -= delta
	if timer <= 0:
		if shoot():
			timer = cooldown

func shoot() -> bool:
	var target = null
	for e in GameflowManager.enemyList.get_children():
		if global_position.distance_to(e.position) < range:
			if target == null or e.further(target):
				target = e;
	
	if target != null:
		var projectile = pro_scene.instantiate()
		projectile.start((target.position - global_position).normalized(), 2000, range*1.5, global_position)
		GameflowManager.projectiles.add_child(projectile)
		
	return target != null
