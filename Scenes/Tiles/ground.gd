class_name Tile extends Location

var walkable : bool
var path : bool
var hasWood : bool
var hasStone : bool
var hasBuilding : bool
var building : Location
var planned_building : Location.BuildingType
var planned_tower : Location.TowerType
var building_tower : bool = false

var resources_needed_for_building : Array[int] = [0, 0]
var time_to_build : float
var is_being_built : bool
var build_stage : int
var upgraded : bool = false

var task : TaskManager.Task

var normal_color : Color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func origin_action(ant : Ant, delta : float) -> bool:
	for i in range(ant.inventory_max):
		ant.add_to_inventory(CarryingResource.new(CarryingResource.ResourceType.WOOD if hasWood else CarryingResource.ResourceType.STONE))
	return true
	
func build(p_building : Location):
	building = p_building
	add_child(building)
	
func plan():
	walkable = false
	hasBuilding = true
	is_being_built = true
	build_stage = 0
	
	self_modulate = Color(0.5, 0.3, 0.1)
	
	if resources_needed_for_building[0] > 0:
		task = TaskManager.add_task(null, self, -1, resources_needed_for_building[0], true)
	if resources_needed_for_building[1] > 0:
		task = TaskManager.add_task(null, self, -1, resources_needed_for_building[1], false)
	
func plan_building():
	resources_needed_for_building = [0, 9]
	planned_building = GameflowManager.selected_building
	time_to_build = 20
	plan()
	
func plan_tower():
	resources_needed_for_building = [0, 9]
	planned_tower = GameflowManager.selected_tower
	building_tower = true
	time_to_build = 10
	plan()
	
func plan_upgrade():
	var mod = 1 + building.upgraded/4
	planned_tower = GameflowManager.selected_tower
	building_tower = true
	time_to_build = 10*mod
	
	mod *= mod
	resources_needed_for_building = [10*mod, 10*mod]
	
	plan()
	
func destination_action(ant : Ant, delta : float):
	if is_being_built:
		if resources_needed_for_building[0] > stockpile[0] or resources_needed_for_building[1] > stockpile[1]:
			ant.remove_from_inventory()
		elif build_stage == 0:
			TaskManager.remove_task(task)
			
			build_stage += 1
			task = TaskManager.add_task(self, self, -1, resources_needed_for_building.reduce(func(a, n): return a+n, 0))
		
		elif build_stage == 1:
			time_to_build -= delta
			
			if time_to_build <= 0:
				TaskManager.remove_task(task)
				
				var b : Location
				
				if planned_tower == Location.TowerType.UPGRADE:
					if not upgraded:
						building.perform_upgrade()
						upgraded = true
					return
				
				elif building_tower:
					b = GameflowManager.towers[planned_tower].instantiate()
					b.is_tower = true
				else:
					b = GameflowManager.buildings[planned_building].instantiate()

				build(b)

func setPos(p : Vector2):
	position = p

func setGroundTile() -> void:
	walkable = true
	hasWood = false
	hasStone = false
	hasBuilding = false
	path = false
	self.self_modulate = Color(0.6, 1, 0.3)
	
	normal_color = self.self_modulate

func setPathTile() -> void:
	walkable = false
	hasWood = false
	hasStone = false
	hasBuilding = false
	path = true
	self.modulate = Color(0.8, 0.6, 0.1)
	
	normal_color = self.self_modulate

func setWoodTile() -> void:
	walkable = false
	hasWood = true
	hasStone = false
	hasBuilding = false
	path = false
	self.modulate = Color(0.1, 0.8, 0.25)
	
	normal_color = self.self_modulate

func setStoneTile() -> void:
	walkable = false
	hasWood = false
	hasStone = true
	hasBuilding = false
	path = false
	self.modulate = Color(0.35, 0.35, 0.4)
	
	normal_color = self.self_modulate

func _on_button_pressed() -> void:
	if !hasBuilding and walkable and GameflowManager.selected_tower != Location.TowerType.UPGRADE:
		## Build!
		
		if GameflowManager.TD_screen_active and GameflowManager.selected_tower != null:
			plan_tower()
			
		if !GameflowManager.TD_screen_active and GameflowManager.selected_building != null:
			plan_building()
	
	if hasBuilding and building != null and building.is_tower and GameflowManager.selected_tower == Location.TowerType.UPGRADE:
		if GameflowManager.TD_screen_active:
			plan_upgrade()
			upgraded = false
	
	
