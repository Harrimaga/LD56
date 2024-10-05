class_name Tile extends Location

var walkable : bool
var path : bool
var hasWood : bool
var hasStone : bool
var hasBuilding : bool
var building : Location

var resources_needed_for_building : Array[int] = [0, 0]
var time_to_build : float
var is_being_built : bool

var task : TaskManager.Task

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func origin_action(ant : Ant):
	for i in range(ant.inventory_max):
		ant.add_to_inventory(CarryingResource.new(CarryingResource.ResourceType.WOOD if hasWood else CarryingResource.ResourceType.STONE))
	
func build(p_building : Location):
	building = p_building
	add_child(building)
	
func plan():
	walkable = false
	hasBuilding = true
	is_being_built = true
	
	if resources_needed_for_building[0] > 0:
		task = TaskManager.add_task(null, self, -1, resources_needed_for_building[0], true)
	if resources_needed_for_building[1] > 0:
		task = TaskManager.add_task(null, self, -1, resources_needed_for_building[1], false)
	
func plan_building():
	resources_needed_for_building = [0, 9]
	plan()
	
func plan_tower():
	resources_needed_for_building = [0, 9]
	plan()
	
func destination_action(ant : Ant):
	if is_being_built:
		if resources_needed_for_building[0] > stockpile[0] or resources_needed_for_building[1] > stockpile[1]:
			ant.remove_from_inventory()
		else:
			TaskManager.remove_task(task)

func setPos(p : Vector2):
	position = p

func setGroundTile() -> void:
	walkable = true
	hasWood = false
	hasStone = false
	hasBuilding = false
	path = false
	self.modulate = Color(0.6, 1, 0.3)
	pass

func setPathTile() -> void:
	walkable = false
	hasWood = false
	hasStone = false
	hasBuilding = false
	path = true
	self.modulate = Color(0.8, 0.6, 0.1)
	pass

func setWoodTile() -> void:
	walkable = false
	hasWood = true
	hasStone = false
	hasBuilding = false
	path = false
	self.modulate = Color(0.1, 0.8, 0.25)
	pass

func setStoneTile() -> void:
	walkable = false
	hasWood = false
	hasStone = true
	hasBuilding = false
	path = false
	self.modulate = Color(0.35, 0.35, 0.4)
	pass

func _on_button_pressed() -> void:
	if !hasBuilding and walkable:
		## Build!
		
		if GameflowManager.TD_screen_active and GameflowManager.selected_tower != null:
			plan_tower()
			
		if !GameflowManager.TD_screen_active and GameflowManager.selected_building != null:
			plan_building()
