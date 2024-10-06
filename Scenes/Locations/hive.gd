extends Location

@onready var ant_scenes = [preload("res://Scenes/Units/BasicAnt.tscn"), 
						   preload("res://Scenes/Units/FlyingAnt.tscn"), 
						   preload("res://Scenes/Units/RedAnt.tscn"), 
						   preload("res://Scenes/Units/RedFlyingAnt.tscn")]

var timer : float = 3
var spawn_interval = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	## Starting resources:
	stockpile = [40, 40, 0, 25]
	GameflowManager.hive = self
	GameflowManager.stockpile_buildings.append(self)
	GameflowManager.ammo_buildings.append(self)
	
	
	
func origin_action(ant : Ant, delta : float):
	if ant.task.destination.is_tower:
		if ant.task.wood and stockpile[2] > 0:
			ant.add_to_inventory(CarryingResource.new(CarryingResource.ResourceType.WOODAMMO))
			stockpile[2] -= 1
		elif !ant.task.wood and stockpile[3] > 0:
			ant.add_to_inventory(CarryingResource.new(CarryingResource.ResourceType.STONEAMMO))
			stockpile[3] -= 1
	else:
		if ant.task.wood and stockpile[0] > 0:
			ant.add_to_inventory(CarryingResource.new(CarryingResource.ResourceType.WOOD))
			stockpile[0] -= 1
		elif !ant.task.wood and stockpile[1] > 0:
			ant.add_to_inventory(CarryingResource.new(CarryingResource.ResourceType.STONE))
			stockpile[1] -= 1
			
	return true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer -= delta
	#if timer <= 0:
		#var ant : Ant = ant_scenes.pick_random().instantiate()
		#TaskManager.add_to_pool(ant)
		#get_parent().get_parent().get_parent().add_child(ant)
		#timer = spawn_interval
