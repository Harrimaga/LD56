class_name Location extends Node2D

enum BuildingType { MINE, WOOD, STOCKPILE, UNI, AMMO }
enum TowerType { BASIC, FLAK, OBSTACLE, UPGRADE }

var stockpile : Array[int] = [0, 0, 0, 0] ## Wood, Stone, WoodAmmo, StoneAmmo

static var building_cost : Dictionary = {
	BuildingType.MINE : [6, 0, 0],
	BuildingType.WOOD : [0, 6, 0],
	BuildingType.STOCKPILE : [10, 10, 0],
	BuildingType.UNI : [20, 20, 0],
	BuildingType.AMMO : [8, 8, 0]
}

static var tower_cost : Dictionary = {
	TowerType.BASIC : [2, 9, 0],
	TowerType.FLAK : [15, 4, 0],
	TowerType.OBSTACLE : [20, 3, 0],
	TowerType.UPGRADE : [10, 10, 10]
}

var is_tower : bool
var on_tile : Tile

func origin_action(ant : Ant, delta : float):
	pass
	
func destination_action(ant : Ant, delta : float):
	pass

func get_resource_tile(wood : bool) -> Tile:
	return get_node("/root/Main/Map").get_closest_resource(wood, position)

func move_resource(resource : CarryingResource):
	match resource.type:
		CarryingResource.ResourceType.WOOD:
			stockpile[0] += 1
		CarryingResource.ResourceType.STONE:
			stockpile[1] += 1
		CarryingResource.ResourceType.WOODAMMO:
			stockpile[2] += 1
		CarryingResource.ResourceType.STONEAMMO:
			stockpile[3] += 1
		CarryingResource.ResourceType.BODY:
			stockpile[4] += 1

func remove_resource(type : CarryingResource.ResourceType) -> CarryingResource:
	match type:
		CarryingResource.ResourceType.WOOD:
			if (stockpile[0] > 0):
				stockpile[0] -= 1
				return CarryingResource.new(CarryingResource.ResourceType.WOOD)
			return null
		CarryingResource.ResourceType.STONE:
			if (stockpile[1] > 0):
				stockpile[1] -= 1
				return CarryingResource.new(CarryingResource.ResourceType.STONE)
			return null
	return null
