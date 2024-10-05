class_name Ant extends AnimatedSprite2D

enum AntType { BASIC, FLYING, RED, REDFLYING }
enum WorkType { MINE, WOOD, BUILD, TRANSPORT }

var task : TaskManager.Task
var path : Array[Vector2]
var path_pointer : int
var work_type : WorkType
var temp_origin : Location

var inventory : Array[CarryingResource]
var inventory_max : int

var speed : float
var is_flying : bool

var lifespan : float
var age : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inventory = []
	age = lifespan
	
	position = Vector2(randf_range(0, 1920), randf_range(0, 1080))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	## Lifespan update
	if task != null:
		age -= delta
	## TODO: Death
	
	if path.size() == 0:
		if task == null:
			return
		if task.origin != null:
			path = [task.origin.global_position]
			flip_h = path[0].x > position.x
	
	## Find path, do work
	
	if path_pointer >= path.size():
		do_work()
		
		if task == null: return
		
		if inventory.size() == 0 and age <= 0:
			TaskManager.kill_ant(self)
			queue_free()
	
	position = position.move_toward(path[path_pointer], speed*delta * (1.2 if is_flying else 1.0))

	if (position - path[path_pointer]).length() <= 0.1:
		position = path[path_pointer]
		path_pointer += 1

func do_work():
	if task == null: return
	
	if task.origin == null:
		var closest : Location
		var distance : float = INF
		
		for t in GameflowManager.stockpile_buildings:
			if t.stockpile[0 if task.wood else 1] > 0 and (t.global_position - global_position).length_squared() < distance:
				closest = t
				distance = (t.global_position - global_position).length_squared()
				
		if closest != null:
			temp_origin = closest
		else:
			return
				
	if (position - task.destination.global_position).length() <= 0.1:
		task.destination.destination_action(self)
		
		if task == null: return
		
		path = [task.origin.global_position if task.origin != null else temp_origin.global_position]
	else:
		if task.origin == null:
			temp_origin.origin_action(self)
		else:
			task.origin.origin_action(self)
			
		if task == null: return
		
		path = [task.destination.global_position]
		
	path_pointer = 0
	flip_h = path[path_pointer].x > position.x

func add_to_inventory(resource : CarryingResource) -> bool:
	if inventory.size() < inventory_max:
		inventory.append(resource)
		return true
	return false

func remove_from_inventory():
	for resource in inventory:
		task.destination.move_resource(resource)
		
	inventory = []
