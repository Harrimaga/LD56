extends Control

@onready var cam : Camera2D = $Camera2D
@onready var ant_scenes = [preload("res://Scenes/Units/BasicAnt.tscn"), 
						   preload("res://Scenes/Units/FlyingAnt.tscn"), 
						   preload("res://Scenes/Units/RedAnt.tscn"), 
						   preload("res://Scenes/Units/RedFlyingAnt.tscn")]

var TD_screen_active = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cam.make_current()
	
	for i in range(30):
		var ant : Ant = ant_scenes.pick_random().instantiate()
		TaskManager.add_to_pool(ant)
		add_child(ant)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !TD_screen_active and cam.position != Vector2(3200 - 960, 540):
		cam.position = cam.position.move_toward(Vector2(3200 - 960, 540), 10000 * delta)
	elif TD_screen_active and cam.position != Vector2(960, 540):
		cam.position = cam.position.move_toward(Vector2(960, 540), 10000 * delta)

func _on_button_pressed() -> void:
	TD_screen_active = !TD_screen_active
	if $CanvasLayer/HBoxContainer/Panel/HBoxContainer/Button.text == ">":
		$CanvasLayer/HBoxContainer/Panel/HBoxContainer/Button.text = "<"
		$CanvasLayer/HBoxContainer/Panel/HBoxContainer/TowerButtons.visible = false
		$CanvasLayer/HBoxContainer/Panel/HBoxContainer/BuildingButtons.visible = true
	else:
		$CanvasLayer/HBoxContainer/Panel/HBoxContainer/Button.text = ">"
		$CanvasLayer/HBoxContainer/Panel/HBoxContainer/TowerButtons.visible = true
		$CanvasLayer/HBoxContainer/Panel/HBoxContainer/BuildingButtons.visible = false
