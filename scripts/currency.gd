extends Node

@export var currency = 500


var bettingAmount = 0
var choosenHorse = ""

func get_currency() ->  int:
	return currency
	
func set_currency(amount: int):
	currency = amount
	
func increase_currrency(amount: int) -> int:
	currency += amount
	return currency
	
func decrease_currency(amount: int) -> int:
	currency -= amount
	return currency
	
func set_bettingAmount(amount: int):
	bettingAmount = amount
	
func get_bettingAmount() -> int:
	return bettingAmount
	
func set_choosen_horse(horse: String):
	choosenHorse = horse
	
func get_choosen_horse():
	return choosenHorse
