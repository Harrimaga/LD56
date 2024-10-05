extends Control

@onready var cam : Camera2D = $Camera2D
@onready var ant_scenes = [preload("res://Scenes/Units/BasicAnt.tscn"), 
						   preload("res://Scenes/Units/FlyingAnt.tscn"), 
						   preload("res://Scenes/Units/RedAnt.tscn"), 
						   preload("res://Scenes/Units/RedFlyingAnt.tscn")]

var ants : Array[Ant]

var TD_screen_active = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cam.make_current()
	
	ants = []

	var ant : Ant = ant_scenes[1].instantiate()
	ant.path = [Vector2(100, 100), Vector2(1820, 100), Vector2(1820, 980), Vector2(100, 980)]
	ants.append(ant)
	add_child(ant)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !TD_screen_active and cam.position != Vector2(3200 - 960, 540):
		cam.position = cam.position.move_toward(Vector2(3200 - 960, 540), 10000 * delta)
	elif TD_screen_active and cam.position != Vector2(960, 540):
		cam.position = cam.position.move_toward(Vector2(960, 540), 10000 * delta)

func _on_button_pressed() -> void:
	TD_screen_active = !TD_screen_active
	if $CanvasLayer/HBoxContainer/Button.text == ">":
		$CanvasLayer/HBoxContainer/Button.text = "<"
		$CanvasLayer/HBoxContainer/MarginContainer2.visible = true
		$CanvasLayer/HBoxContainer/MarginContainer.visible = false
	else:
		$CanvasLayer/HBoxContainer/Button.text = ">"
		$CanvasLayer/HBoxContainer/MarginContainer2.visible = false
		$CanvasLayer/HBoxContainer/MarginContainer.visible = true
