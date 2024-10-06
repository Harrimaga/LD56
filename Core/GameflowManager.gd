extends Node

var enemyPath : Array
var enemyList : Node2D
var projectiles : Node2D

var health : int = 50
var score : int = 0
var research : int = 0

var selected_building : Location.BuildingType
var selected_tower : Location.TowerType

var towers : Dictionary = {
	Location.TowerType.BASIC : preload("res://Scenes/Locations/BasicTower.tscn"),
	Location.TowerType.UPGRADE : null
}

var buildings : Dictionary = {
	Location.BuildingType.MINE : preload("res://Scenes/Locations/Mine.tscn"),
	Location.BuildingType.AMMO : preload("res://Scenes/Locations/AmmoBuilding.tscn"),
	Location.BuildingType.UNI : preload("res://Scenes/Locations/University.tscn")
}

var TD_screen_active : bool = true

var stockpile_buildings : Array[Location] = []
var ammo_buildings : Array[Location] = []
var universities : Array[Location] = []

var hive : Location
