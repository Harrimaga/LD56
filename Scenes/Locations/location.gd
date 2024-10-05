class_name Location extends Node2D

var stockpile : Array[int] = [0, 0]## Wood, Stone

func origin_action(ant : Ant):
	pass
	
func destination_action(ant : Ant):
	pass
	
func get_resource_tile(wood : bool) -> Tile:
	return get_node("/root/Main/Map").get_closest_resource(wood, position)

func move_resource(resource : CarryingResource):
	match resource.type:
		CarryingResource.ResourceType.WOOD:
			stockpile[0] += 1
		CarryingResource.ResourceType.STONE:
			stockpile[1] += 1

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
