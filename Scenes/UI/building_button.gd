extends TextureButton

@export var building_type : Location.BuildingType

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Label.text = str(building_type)
	
func _on_pressed() -> void:
	GameflowManager.selected_building = building_type
