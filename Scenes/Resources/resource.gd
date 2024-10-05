class_name CarryingResource extends Node

enum ResourceType {WOOD, STONE, WOODAMMO, STONEAMMO}

var type : ResourceType

func _init(p_type : ResourceType) -> void:
	type = p_type
