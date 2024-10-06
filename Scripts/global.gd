extends Node

var biomass: int
var lives: int

var beehive_cost : int
var anthill_cost : int

var level_parameters: LevelParameters

var highest_level_beat := 0

func reset():
	biomass = 20
	lives = 10
	beehive_cost = 10
	anthill_cost = 20
