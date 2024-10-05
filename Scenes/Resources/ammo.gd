class_name CarryingAmmo extends Node

enum AmmoType { WOOD, STONE }

var type : AmmoType

func _init(p_type : AmmoType) -> void:
	type = p_type
