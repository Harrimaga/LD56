extends Control

@onready var cam : Camera2D = $Camera2D
@onready var ant_scenes = [preload("res://Scenes/Units/BasicAnt.tscn"), 
						   preload("res://Scenes/Units/FlyingAnt.tscn"), 
						   preload("res://Scenes/Units/RedAnt.tscn"), 
						   preload("res://Scenes/Units/RedFlyingAnt.tscn")]
var gameOver : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cam.make_current()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !GameflowManager.TD_screen_active and cam.position != Vector2(3200 - 960, 540):
		cam.position = cam.position.move_toward(Vector2(3200 - 960, 540), 10000 * delta)
	elif GameflowManager.TD_screen_active and cam.position != Vector2(960, 540):
		cam.position = cam.position.move_toward(Vector2(960, 540), 10000 * delta)

	if GameflowManager.health <= 0 and not gameOver:
		gameOver = true
		$CanvasLayer/GameOver/Score.text = "Your final score:\n" + str(GameflowManager.score)
		$CanvasLayer/GameOver.visible = true
		$Map.visible = false
		$Map.started = false

func _on_button_pressed() -> void:
	GameflowManager.TD_screen_active = !GameflowManager.TD_screen_active
	if $CanvasLayer/HBoxContainer/Panel/HBoxContainer/Button.text == ">":
		$CanvasLayer/HBoxContainer/Panel/HBoxContainer/Button.text = "<"
		$CanvasLayer/HBoxContainer/Panel/HBoxContainer/TowerButtons.visible = false
		$CanvasLayer/HBoxContainer/Panel/HBoxContainer/BuildingButtons.visible = true
	else:
		$CanvasLayer/HBoxContainer/Panel/HBoxContainer/Button.text = ">"
		$CanvasLayer/HBoxContainer/Panel/HBoxContainer/TowerButtons.visible = true
		$CanvasLayer/HBoxContainer/Panel/HBoxContainer/BuildingButtons.visible = false


func _on_start_pressed() -> void:
	$CanvasLayer/MainMenu.visible = false
	$Map.visible = true
	$Map.started = true
	$CanvasLayer/GameOver.visible = false
	
	GameflowManager.score = 0
	GameflowManager.health = 50
	GameflowManager.ammo_buildings = []
	GameflowManager.stockpile_buildings = []
	GameflowManager.hive._ready()
	
	for p in $Map/Projectiles.get_children():
		p.queue_free()
	
	$Map.removeBuildings()
	TaskManager.reset()
	
	$Map.set_wave_params()
	for e in $Map/Enemies.get_children():
		e.queue_free()
	
	for i in range(30):
		var ant : Ant = ant_scenes.pick_random().instantiate()
		TaskManager.add_to_pool(ant)
		add_child(ant)
	
