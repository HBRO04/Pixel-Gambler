extends Control


var deck: Array = []
var player_hand: Array = []
var dealer_hand: Array = []
var bettingAmount
var winnings
var hud : HUD


func _ready():
	# Connect buttons

	$playerBox/lblcurrency.text = str(Currency.get_currency())
	bettingAmount = Currency.get_bettingAmount()
	$DealerBox/lblbet.text = "Current bet: " + str(bettingAmount)
	winnings = bettingAmount * 2
	hud = get_tree().get_first_node_in_group("hud")
	hud._play_bgMusic()
	hud.hud_invisible()
	start_game()



func start_game():
	deck = create_deck()
	player_hand.clear()
	dealer_hand.clear()

	# Deal 2 cards each
	player_hand.append(draw_card())
	dealer_hand.append(draw_card())
	player_hand.append(draw_card())
	dealer_hand.append(draw_card())

	# Reset buttons and status
	$HBoxContainer3/btnHit.disabled = false
	$HBoxContainer3/btnStand.disabled = false
	$lblStatus.text = ""
	Currency.decrease_currency(bettingAmount)
	update_ui()


# Deck
func create_deck() -> Array:
	var suits = ["D","H","C","S"]
	var ranks = ["A","2","3","4","5","6","7","8","9","10","J","Q","K"]
	var new_deck = []
	for suit in suits:
		for rank in ranks:
			new_deck.append({"rank": rank, "suit": suit})
	new_deck.shuffle()
	return new_deck


func draw_card() -> Dictionary:
	return deck.pop_back()

# Hand value
func hand_value(hand: Array) -> int:
	var value = 0
	var aces = 0
	for card in hand:
		match card["rank"]:
			"J", "Q", "K":
				value += 10
			"A":
				value += 11
				aces += 1
			_:
				value += int(card["rank"])
	while value > 21 and aces > 0:
		value -= 10
		aces -= 1
	return value


# Update UI
func update_ui():
	var dealer_box = $DealerBox/dealerCardBox
	var player_box = $playerBox/PlayerCardBox
	# Clear old cards
	for child in dealer_box.get_children():
		child.queue_free()
	for child in player_box.get_children():
		child.queue_free()

	# Draw dealer cards
	for i in range(dealer_hand.size()):
		var card = dealer_hand[i]
		var tex_key = card["rank"] + card["suit"]
		var tr = TextureRect.new()
		tr.texture = CardManager.card_textures[tex_key]
		tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
		tr.custom_minimum_size = Vector2(128, 168)
		tr.position = Vector2(i, 0)
		dealer_box.add_child(tr)

	# Draw player cards
	for i in range(player_hand.size()):
		var card = player_hand[i]
		var tex_key = card["rank"] + card["suit"]
		var tr = TextureRect.new()
		tr.texture = CardManager.card_textures[tex_key]
		tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
		tr.custom_minimum_size = Vector2(128, 128)
		tr.position = Vector2(i , 0)
		player_box.add_child(tr)

	# Update labels with total hand values
	$DealerBox/lblDealerhand.text = "Dealer (" + str(hand_value(dealer_hand)) + ")"
	$playerBox/lblplayerhand.text = "Player (" + str(hand_value(player_hand)) + ")"
	$playerBox/lblcurrency.text = str(Currency.get_currency())
	hud.update_currency_label()
	

# Buttons functions
func _on_hit_pressed():
	#hud._button_click_sound()
	$drawCard.play()
	player_hand.append(draw_card())
	update_ui()
	if hand_value(player_hand) > 21:
		Currency.decrease_currency(50)
		update_ui()
		game_over("Player Busts! Dealer Wins")


func _on_stand_pressed():
	dealer_turn()


func _on_restart_pressed():
	start_game()


#dealer ai
func dealer_turn():
	while hand_value(dealer_hand) < 17:
		dealer_hand.append(draw_card())
		update_ui()
		await get_tree().create_timer(0.5).timeout

	var dealer_val = hand_value(dealer_hand)
	var player_val = hand_value(player_hand)

	if dealer_val > 21:
		Currency.increase_currrency(50)
		Currency.increase_currrency(winnings)
		update_ui()
		game_over("Dealer Busts! Player Wins")
		
	elif player_val > dealer_val:
		Currency.increase_currrency(50)
		Currency.increase_currrency(winnings)
		update_ui()
		game_over("Player Wins!")
		
	elif dealer_val > player_val:
		Currency.decrease_currency(50)
		update_ui()
		game_over("Dealer Wins")
		
	else:
		update_ui()
		game_over("Push (Tie)")
		

# End game
func game_over(msg: String):
	$lblStatus.text = msg
	$HBoxContainer3/btnHit.disabled = true
	$HBoxContainer3/btnStand.disabled = true


func _on_btn_change_bet_pressed() -> void:
	hud._button_click_sound()
	var timer = Timer.new()
	timer.wait_time = 0.6
	timer.one_shot = true
	add_child(timer)
	timer.start()
	await timer.timeout
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/betting_screen_black_jack.tscn")
