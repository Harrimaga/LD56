class_name Tile extends Location

var walkable : bool
var path : bool
var hasWood : bool
var hasStone : bool
var hasBuilding : bool
var building : Location

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func origin_action(ant : Ant):
	for i in range(ant.inventory_max):
		ant.add_to_inventory(CarryingResource.new(CarryingResource.ResourceType.WOOD if hasWood else CarryingResource.ResourceType.STONE))
	
func build(p_building):
	building = p_building
	add_child(building)

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
