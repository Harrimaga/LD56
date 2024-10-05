extends TextureButton

@export var tower_type : Location.TowerType

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Label.text = str(tower_type)

func _on_pressed() -> void:
	GameflowManager.selected_tower = tower_type
