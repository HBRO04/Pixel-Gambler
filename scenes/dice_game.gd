extends Node2D

@export var dice: Sprite2D  
@export var lblerror : Label
@export var listbx : ItemList
var oldvalue
var newvalue
var hud : HUD

func _ready():
	hide_button()
	hud = get_tree().get_first_node_in_group("hud")
	hud._play_bgMusic()
	randomize() 
	dice_invisible()
	
	oldvalue = await roll_dice()
	show_button()
	

func _on_button_pressed() -> void:
	hud._button_click_sound()
	if choice() != "":
		newvalue = await roll_dice()
		if choice() == "higher" and oldvalue < newvalue:
			lblerror.text = "you win!"
			Currency.increase_currrency(50)
			hud.update_currency_label()
		elif choice() == "higher" and oldvalue > newvalue:
			lblerror.text = "You lost"
			Currency.decrease_currency(50)
			hud.update_currency_label()
		elif choice() == "lower" and oldvalue > newvalue:
			lblerror.text = "you win!"
			Currency.increase_currrency(50)
			hud.update_currency_label()
		elif choice() == "lower" and oldvalue < newvalue:
			lblerror.text = "You lost"
			Currency.decrease_currency(50)
			hud.update_currency_label()
		elif choice() == "lower" and oldvalue == newvalue:
			lblerror.text = "Wow"
			Currency.increase_currrency(100)
			hud.update_currency_label()
		elif choice() == "higher" and oldvalue == newvalue:
			lblerror.text = "Wow"
			Currency.increase_currrency(100)
			hud.update_currency_label()
			
		oldvalue = newvalue
	else:
		lblerror.text = "Choose an option!"
		
func dice_invisible():
	$Diceside1.visible = false
	$Diceside2.visible = false
	$Diceside3.visible = false
	$Diceside4.visible = false
	$Diceside5.visible = false
	$Diceside6.visible = false
	
func choice() -> String:
	var answer = ""
	if listbx.is_selected(0):
		answer = "higher"
	elif listbx.is_selected(1):
		answer = "lower"
	else:
		answer = ""
		
	return answer

func roll_dice() -> int:
	$DiceSound.play()
	hide_button()
	lblerror.text = ""
	dice_invisible()
	$Dice.visible = true
	$Dice/AnimationPlayer.play("idle")
	var timer = Timer.new()
	timer.wait_time = 1.5
	timer.one_shot = true
	add_child(timer)
	timer.start()
	await timer.timeout
	$Dice/AnimationPlayer.stop()
	var num= randi_range(1,6)
	print(str(num))
	if num == 1:
		$Diceside1.visible = true
		$Dice.visible = false
	elif num == 2:
		$Diceside2.visible = true
		$Dice.visible = false
	elif num == 3:
		$Diceside3.visible = true
		$Dice.visible = false
	elif num == 4:
		$Diceside4.visible = true
		$Dice.visible = false
	elif num == 5:
		$Diceside5.visible = true
		$Dice.visible = false
	elif num == 6:
		$Diceside6.visible = true
		$Dice.visible = false
	show_button()
	return num

func hide_button():
	$Button.visible = false
	
func show_button():
	$Button.visible = true


func _on_back_button_pressed() -> void:
	hud._button_click_sound()
	lblerror.text = "Going back to casino"
	var timer = Timer.new()
	timer.wait_time = 0.6
	timer.one_shot = true
	add_child(timer)
	timer.start()
	await timer.timeout
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/casino.tscn")
