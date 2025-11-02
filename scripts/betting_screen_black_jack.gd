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
	if bettingAmount <= Currency.get_currency() and bettingAmount > 0:
		hud._coin_sound()
		Currency.decrease_currency(bettingAmount)
		$lblError.text = "Bet placed"
		Currency.set_bettingAmount(bettingAmount)
		var timer = Timer.new()
		timer.wait_time = 0.6
		timer.one_shot = true
		add_child(timer)
		timer.start()
		await timer.timeout
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished
		get_tree().change_scene_to_file("res://scenes/Main.tscn")
	elif bettingAmount > Currency.get_currency():
		$lblError.text = "Can't bet more than you have"
	else:
		$lblError.text = "Enter amount more than 0"
	
	

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
