extends Location

var time_per_ammo : float = 5
var timer : float
var capacity : int = 2

var wood_task : TaskManager.Task
var stone_task : TaskManager.Task

var active_tasks : Array[bool] = [false, false]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = time_per_ammo
	
	wood_task = TaskManager.add_task(null, self, capacity, -1, true)
	stone_task = TaskManager.add_task(null, self, capacity, -1, false)
	
	active_tasks = [true, true]
	
	GameflowManager.ammo_buildings.append(self)
	
func destination_action(ant : Ant, delta : float):
	ant.remove_from_inventory()
	
	if stockpile[0] >= 50:
		TaskManager.remove_task(wood_task)
		active_tasks[0] = false
	if stockpile[1] >= 50:
		TaskManager.remove_task(stone_task)
		active_tasks[1] = false
		
func origin_action(ant : Ant, delta : float):
	if ant.task.wood:
		while ant.add_to_inventory(CarryingResource.new(CarryingResource.ResourceType.WOODAMMO)) and stockpile[2] > 0:
			stockpile[2] -= 1
	else:
		while ant.add_to_inventory(CarryingResource.new(CarryingResource.ResourceType.STONEAMMO)) and stockpile[3] > 0:
			stockpile[3] -= 1
	
	if ant.inventory.size() < ant.inventory_max:
		return false
	return true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	$RichTextLabel.text = "Stock: %s/%s/%s/%s" % stockpile
	
	if stockpile[0] < 25 and !active_tasks[0]:
		TaskManager.re_add_task(wood_task)
		active_tasks[0] = true
	if stockpile[1] < 25 and !active_tasks[1]:
		TaskManager.re_add_task(stone_task)
		active_tasks[1] = true
	
	if stockpile[0] > 0 or stockpile[1] > 0:
		timer -= delta
		
		if timer <= 0:
			timer = time_per_ammo
			if stockpile[0] > 0 and stockpile[2] < 50:
				stockpile[0] -= 1
				stockpile[2] += 5
			if stockpile[1] > 0 and stockpile[3] < 50:
				stockpile[1] -= 1
				stockpile[3] += 5
