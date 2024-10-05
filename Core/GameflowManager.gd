extends Node

var enemyPath : Array
var enemyList : Node2D
var projectiles : Node2D

var health : int = 50
var score : int = 0

var selected_building : Location.BuildingType
var selected_tower : Location.TowerType

var towers : Dictionary = {
	Location.TowerType.BASIC : preload("res://Scenes/Locations/BasicTower.tscn")
}

var buildings : Dictionary = {
	
}

var TD_screen_active : bool = true

var stockpile_buildings : Array[Location] = []
