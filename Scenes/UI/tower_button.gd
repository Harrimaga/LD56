extends TextureButton

@export var tower_type : Location.TowerType

var wood_label : Label
var stone_label : Label
var research_label : Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wood_label = get_parent().get_child(2)
	stone_label = get_parent().get_child(3)
	research_label = get_parent().get_child(4)
	
	wood_label.text = str(Location.tower_cost[tower_type][0])
	stone_label.text = str(Location.tower_cost[tower_type][1])
	research_label.text = str(Location.tower_cost[tower_type][2])
	
	GameflowManager.TowerSelected.connect(func() : get_parent().get_child(1).visible = false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	GameflowManager.selected_tower = tower_type
	GameflowManager.TowerSelected.emit()
	get_parent().get_child(1).visible = true
