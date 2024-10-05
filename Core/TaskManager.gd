extends Node

var worker_pool : Array[Ant]
var task_pool : Array[Task]

func get_ant_count() -> int:
	var count = worker_pool.size()
	for t in task_pool:
		count += t.worker_pool.size()
	return count
	
func get_task_capacity() -> int:
	var count = 0
	for t in task_pool:
		count += t.capacity
	return count

func add_to_pool(ant : Ant):
	worker_pool.push_back(ant)
	
func remove_from_pool() -> Ant:
	return worker_pool.pop_back()
	
func kill_ant(ant : Ant):
	for i in range(worker_pool.size()):
		if worker_pool[i] == ant:
			worker_pool[i] = worker_pool.back()
			worker_pool.pop_back()
			return
	
	for task in task_pool:
		for i in range(task.worker_pool.size()):
			if task.worker_pool[i] == ant:
				task.worker_pool[i] = task.worker_pool.back()
				task.worker_pool.pop_back()
				return
	
func add_task(origin : Location, destination : Location, capacity : int, resources : int = -1, wood : bool = false) -> Task:
	
	if capacity == -1:
		capacity = resources / 2
	
	var task = Task.new(origin, destination, capacity, resources, wood)
	task_pool.push_back(task)
	
	return task
	
func re_add_task(task : Task):
	task_pool.push_back(task)

func remove_task(task : Task):
	var i = task_pool.size() - 1
	while i >= 0:
		if task_pool[i] == task:
			for ant in task.worker_pool:
				if ant == null: continue
				ant.task = null
				ant.temp_origin = null
				ant.path = []
				
			task.worker_pool = []
				
			worker_pool.append_array(task.worker_pool)
			
			task_pool.remove_at(i)
			break
		i -= 1

func _process(delta: float) -> void:
	for task in task_pool:
		if worker_pool.size() <= 0: break

		var resources_transported_in_request = 0
		while worker_pool.size() > 0 and task.worker_pool.size() < task.capacity:
			var ant : Ant = worker_pool.pop_back()
			if task.resources > 0:
				resources_transported_in_request += ant.inventory_max
			ant.task = task
			ant.age = ant.lifespan
			task.worker_pool.push_back(ant)
			
			if resources_transported_in_request >= task.resources:
				break

class Task:
	var origin : Location
	var destination : Location
	var capacity : int
	var resources : int
	var wood : bool
	
	var worker_pool : Array[Ant]
	
	func _init(p_origin : Location, p_destination : Location, p_capacity : int, p_resources : int, p_wood : bool):
		origin = p_origin
		destination = p_destination
		capacity = p_capacity
		resources = p_resources
		wood = p_wood
