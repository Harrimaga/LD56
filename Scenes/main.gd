extends Control

@onready var cam : Camera2D = $Camera2D
@onready var hover_info_box : HBoxContainer = $CanvasLayer/HBoxContainer/Panel/VBoxContainer/HoverInfo
@onready var hover_info_resource_label : Array[Label] = [
	$CanvasLayer/HBoxContainer/Panel/VBoxContainer/HoverInfo/VBoxContainer/HBoxContainer/Wood,
	$CanvasLayer/HBoxContainer/Panel/VBoxContainer/HoverInfo/VBoxContainer/HBoxContainer2/Stone,
	$CanvasLayer/HBoxContainer/Panel/VBoxContainer/HoverInfo/VBoxContainer/HBoxContainer3/WoodAmmo,
	$CanvasLayer/HBoxContainer/Panel/VBoxContainer/HoverInfo/VBoxContainer/HBoxContainer4/StoneAmmo
]
@onready var hovered_upgrade_cost_label : Label = $CanvasLayer/HBoxContainer/Panel/VBoxContainer/HoverInfo/VBoxContainer/Label
@onready var hovered_upgrade_cost_labels : Array[Label] = [$CanvasLayer/HBoxContainer/Panel/VBoxContainer/HoverInfo/VBoxContainer/UpgradeCost/Label, $CanvasLayer/HBoxContainer/Panel/VBoxContainer/HoverInfo/VBoxContainer/UpgradeCost/Label2, $CanvasLayer/HBoxContainer/Panel/VBoxContainer/HoverInfo/VBoxContainer/UpgradeCost/Label3]

@onready var ant_scenes = [preload("res://Scenes/Units/BasicAnt.tscn"), 
						   preload("res://Scenes/Units/FlyingAnt.tscn"), 
						   preload("res://Scenes/Units/RedAnt.tscn"), 
						   preload("res://Scenes/Units/RedFlyingAnt.tscn")]
var gameOver : bool = false	
var hovered_location : Location

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cam.make_current()
	GameflowManager.LocationHovered.connect(show_hover_info)
	GameflowManager.LocationUnhovered.connect(hide_hover_info)

func show_hover_info(location : Location):
	hovered_location = location
	hover_info_box.visible = true
	
func hide_hover_info(location : Location):
	if hovered_location != null and hovered_location == location:
		hover_info_box.visible = false
		hovered_location = null
		hovered_upgrade_cost_label.visible = false
		$CanvasLayer/HBoxContainer/Panel/VBoxContainer/HoverInfo/VBoxContainer/UpgradeCost.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !GameflowManager.TD_screen_active and cam.position != Vector2(3200 - 960, 540):
		cam.position = cam.position.move_toward(Vector2(3200 - 960, 540), 10000 * delta)
	elif GameflowManager.TD_screen_active and cam.position != Vector2(960, 540):
		cam.position = cam.position.move_toward(Vector2(960, 540), 10000 * delta)
		
	if hovered_location != null:
		hover_info_resource_label[1].text = str(hovered_location.stockpile[1])
		hover_info_resource_label[2].text = str(hovered_location.stockpile[2])
		hover_info_resource_label[3].text = str(hovered_location.stockpile[3])
		hover_info_resource_label[0].text = str(hovered_location.stockpile[0])
		
		if hovered_location.is_tower:
			var mod = 1 + hovered_location.upgraded/4.0
			
			mod *= mod
			var resources_needed_for_building = [int(10*mod), int(10*mod), int(10 * mod * mod)]
			
			hovered_upgrade_cost_labels[0].text = str(resources_needed_for_building[0])
			hovered_upgrade_cost_labels[1].text = str(resources_needed_for_building[1])
			hovered_upgrade_cost_labels[2].text = str(resources_needed_for_building[2])
			
			hovered_upgrade_cost_label.text = "Level %s. Upgrade Cost:" % str(hovered_location.upgraded)
			hovered_upgrade_cost_label.visible = true
			$CanvasLayer/HBoxContainer/Panel/VBoxContainer/HoverInfo/VBoxContainer/UpgradeCost.visible = true
		

	if GameflowManager.health <= 0 and not gameOver:
		gameOver = true
		$AudioStreamPlayer.stop()
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
	$AudioStreamPlayer.play()
	$CanvasLayer/MainMenu.visible = false
	$Map.visible = true
	$Map.started = true
	$CanvasLayer/GameOver.visible = false
	
	GameflowManager.score = 0
	GameflowManager.research = 0
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
	
	for i in range(40):
		var ant : Ant = ant_scenes[0].instantiate()
		TaskManager.add_to_pool(ant)
		add_child(ant)
	
