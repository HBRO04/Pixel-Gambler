extends Node2D

@onready var finishline: Node2D = $FinishLine
@onready var horses: Array = [ $Horse1, $Horse2, $Horse3, $Horse4]
var bettingAmount = 0
var winnings = 0
var race_over := false
var choosenHorse = ""

func _ready() -> void:
	bettingAmount = Currency.get_bettingAmount()
	choosenHorse = Currency.get_choosen_horse()
	winnings = bettingAmount * 2

func _process(delta: float) -> void:
	if race_over:
		return
		
	for horse in horses:
		var speed = randf_range(0, 10)
		horse.position.x += speed
		
		if horse.position.x >= finishline.position.x:
			race_over = true
			print(horse.name + " wins!")
			if horse.name == choosenHorse:
				Currency.increase_currrency(winnings)
				print("You won the bet")
				print(str(Currency.get_currency()))
			_show_winner(horse)
			_end_race()
			break
			
func _show_winner(winner: Node2D) -> void:
	var label = Label.new()
	label.text = winner.name + " wins!"
	label.add_theme_font_size_override("font_size", 48)
	label.position = Vector2(400, 200)
	add_child(label)
	
func _end_race():
	var timer = Timer.new()
	timer.wait_time = 1.0
	timer.one_shot = true
	add_child(timer)
	timer.start()
	await timer.timeout
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/betting_screen_horse.tscn")
