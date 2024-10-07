extends TextureButton

@export var building_type : Location.BuildingType

var wood_label : Label
var stone_label : Label
var research_label : Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wood_label = get_parent().get_child(2)
	stone_label = get_parent().get_child(3)
	research_label = get_parent().get_child(4)
	
	wood_label.text = str(Location.building_cost[building_type][0])
	stone_label.text = str(Location.building_cost[building_type][1])
	research_label.text = str(Location.building_cost[building_type][2])
	
	GameflowManager.BuildingSelected.connect(func() : get_parent().get_child(1).visible = false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_pressed() -> void:
	GameflowManager.selected_building = building_type
	GameflowManager.BuildingSelected.emit()
	get_parent().get_child(1).visible = true
