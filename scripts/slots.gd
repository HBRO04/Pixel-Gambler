extends Node2D

@export var lblerror : Label

var hud : HUD

func _ready() -> void:
	randomize()
	hud = get_tree().get_first_node_in_group("hud")
	hud._play_bgMusic()
	iconsets_hide()

func _on_btn_back_pressed() -> void:
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


func _on_btn_spin_pressed() -> void:
	$coinSound.play()
	lblerror.text = ""
	Currency.decrease_currency(5)
	hud.update_currency_label()
	iconsets_hide()
	spinbtn_invisible()
	iconspins_visible()
	$icons1/AnimationPlayer1.play("spin")
	$icons2/AnimationPlayer2.play("spin")
	$icons3/AnimationPlayer3.play("spin")
	$slotSound.play()
	await  new_timer(6)
	var num1 = randi_range(1,5)
	$icons1/AnimationPlayer1.stop()
	if num1 == 1:
		$icons1.visible = false
		$icons1_states/iconset1_side1.visible = true
	elif num1 == 2:
		$icons1.visible = false
		$icons1_states/iconset1_side2.visible = true
	elif num1 == 3:
		$icons1.visible = false
		$icons1_states/iconset1_side3.visible = true
	elif num1 == 4:
		$icons1.visible = false
		$icons1_states/iconset1_side4.visible = true
	elif num1 == 5:
		$icons1.visible = false
		$icons1_states/iconset1_side5.visible = true
	await  new_timer(1.5)
	var num2 = randi_range(1,5)
	$icons3/AnimationPlayer3.stop()
	if num2 == 1:
		$icons3.visible = false
		$icons2_states/iconset2_side1.visible = true
	elif num2 == 2:
		$icons3.visible = false
		$icons2_states/iconset2_side2.visible = true
	elif num2 == 3:
		$icons3.visible = false
		$icons2_states/iconset2_side3.visible = true
	elif num2 == 4:
		$icons3.visible = false
		$icons2_states/iconset2_side4.visible = true
	elif num2 == 5:
		$icons3.visible = false
		$icons2_states/iconset2_side5.visible = true
	await  new_timer(1.5)
	var num3 = randi_range(1,5)
	$icons2/AnimationPlayer2.stop()
	if num3 == 1:
		$icons2.visible = false
		$icons3_states/iconset3_side1.visible = true
	elif num3 == 2:
		$icons2.visible = false
		$icons3_states/iconset3_side2.visible = true
	elif num3 == 3:
		$icons2.visible = false
		$icons3_states/iconset3_side3.visible = true
	elif num3 == 4:
		$icons2.visible = false
		$icons3_states/iconset3_side4.visible = true
	elif num3 == 5:
		$icons2.visible = false
		$icons3_states/iconset3_side5.visible = true
	
	if num1 == num2 and num1 == num3 and num1 == 1:
		lblerror.text = "Jackpot"
		Currency.increase_currrency(1000)
	elif num1 == num2 and num1 == num3:
		lblerror.text = "You win"
		Currency.increase_currrency(500)
	else:
		lblerror.text = "You Lose"
		
	spinbtn_visible()
	hud.update_currency_label()
	
func spinbtn_invisible():
	$btnSpin.visible = false
	
func spinbtn_visible():
	$btnSpin.visible = true
	
func new_timer(sekonds: float):
	var timer = Timer.new()
	timer.wait_time = sekonds
	timer.one_shot = true
	add_child(timer)
	timer.start()
	await timer.timeout
	
func iconsets_hide():
	$icons1_states/iconset1_side1.visible = false
	$icons1_states/iconset1_side2.visible = false
	$icons1_states/iconset1_side3.visible = false
	$icons1_states/iconset1_side4.visible = false
	$icons1_states/iconset1_side5.visible = false
	$icons2_states/iconset2_side1.visible = false
	$icons2_states/iconset2_side2.visible = false
	$icons2_states/iconset2_side3.visible = false
	$icons2_states/iconset2_side4.visible = false
	$icons2_states/iconset2_side5.visible = false
	$icons3_states/iconset3_side1.visible = false
	$icons3_states/iconset3_side2.visible = false
	$icons3_states/iconset3_side3.visible = false
	$icons3_states/iconset3_side4.visible = false
	$icons3_states/iconset3_side5.visible = false
	
func iconspins_visible():
	$icons1.visible = true
	$icons2.visible = true
	$icons3.visible = true
