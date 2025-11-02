extends Control

var bettingAmount
var hud : HUD

func _ready() -> void:
	$lblError.text = ""
	hud = get_tree().get_first_node_in_group("hud")
	hud._play_bgMusic()
	hud.hud_visible()
	hud.update_currency_label()
	hud.hide_interact_label()

func _on_btn_bet_pressed() -> void:
	#hud._button_click_sound()
	bettingAmount = int($EditBet.text)
	if bettingAmount <= Currency.get_currency() and  Selected_horse() !="" and bettingAmount > 0:
		hud._coin_sound()
		Currency.decrease_currency(bettingAmount)
		$lblError.text = "Bet placed on "+ Selected_horse()
		Currency.set_bettingAmount(bettingAmount)
		Currency.set_choosen_horse(Selected_horse())
		var timer = Timer.new()
		timer.wait_time = 0.6
		timer.one_shot = true
		add_child(timer)
		timer.start()
		await timer.timeout
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished
		get_tree().change_scene_to_file("res://scenes/horse_racing.tscn")
		
	elif bettingAmount > Currency.get_currency():
		$lblError.text = "Can't bet more than you have"
	elif Selected_horse() == "":
		$lblError.text = "You have to pick a horse"
	else:
		$lblError.text = "You have to enter a betting amount"
	
	#$lblError.text = Selected_horse()
	
func Selected_horse() -> String:
	hud._button_click_sound()
	var choosenHorse
	if $ItemList.is_selected(0):
		choosenHorse = "Horse1"
	elif $ItemList.is_selected(1):
		choosenHorse = "Horse2"
	elif $ItemList.is_selected(2):
		choosenHorse = "Horse3"
	elif $ItemList.is_selected(3):
		choosenHorse = "Horse4"
	else:
		choosenHorse = ""
	return choosenHorse

func _on_btn_back_pressed() -> void:
	hud._button_click_sound()
	$lblError.text = "Switching to casino freeroam"
	var timer = Timer.new()
	timer.wait_time = 0.6
	timer.one_shot = true
	add_child(timer)
	timer.start()
	await timer.timeout
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/casino.tscn")
