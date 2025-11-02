extends Node2D

@export var lblerror : Label
var power : String
var hud : HUD

func _ready() -> void:
	hud = get_tree().get_first_node_in_group("hud")
	hud._play_bgMusic()
	randomize()
	$CanvasLayer2/power_btn.visible = false
	$CanvasLayer2/lblPower.visible = false
	$CanvasLayer2/Button.visible = false
	

func _on_btn_back_pressed() -> void:
	hud._button_click_sound()
	lblerror.text = "Going back to casino"
	await set_timer(0.6)
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/casino.tscn")

func _process(_delta: float) -> void:
	if $CanvasLayer2/power_btn.changed:
		var powernum = int($CanvasLayer2/power_btn.value)
		power = str(powernum)
		$CanvasLayer2/lblPower.text = power
	
func _on_btn_spin_pressed() -> void:
	hud._button_click_sound()
	Currency.decrease_currency(10)
	hud.update_currency_label()
	$CanvasLayer2/power_btn.value = 0
	$CanvasLayer2/power_btn.visible = true
	lblerror.text = "Choose how much power to use to spin the wheel"
	$CanvasLayer2/lblPower.visible = true
	$btnSpin.visible = false
	$CanvasLayer2/Button.visible = true
	#$AnimationPlayer.play("Spin")
	#await  set_timer(2.5)
	#$AnimationPlayer.stop()

func set_timer(time: float):
	var timer = Timer.new()
	timer.wait_time = time
	timer.one_shot = true
	add_child(timer)
	timer.start()
	await timer.timeout
	
func spin(power_used: int):
	$WheelSpinning.play()
	var spin_time
	var num = 0
	if power_used > 75:
		spin_time = 6.2
		num = randi_range(18,24)
	elif power_used > 50:
		spin_time = 4.2
		num = randi_range(12,18)
	elif power_used > 25:
		spin_time = 2.2
		num = randi_range(6,12)
	else :
		spin_time = 1.5
		num = randi_range(0,6)
		
	$AnimationPlayer.play("Spin")
	await set_timer(spin_time)
	$AnimationPlayer.stop()
	$WheelSpinning.stop()
	$lblError.text = check_result(num)
	
	await set_timer(1)
	$Wheel.rotation = 0
	

	
func check_result(num: int) -> String:
	var wheel := $Wheel
	var winnings=0
	var color = ""
	var degrees = 0
	# Handle jackpot
	if num == 1:
		wheel.rotation = 0
		degrees = 0
		color = "Jackpot"
		winnings = 1000
	elif num in range(2, 24):
		wheel.rotation = deg_to_rad(-15 * num)
		degrees = -15 * num
		
		
	if degrees == 0 or degrees == -360:
		winnings = 1000
		color = "Jackpot"
	elif degrees == -15 or degrees == -75 or degrees == -90 or degrees == -150 or degrees == -210 or degrees == -225 or degrees == -270 or degrees == -285:
		winnings = 5
		color = "Brown"
	elif degrees == -45 or degrees == -105 or degrees == -165 or degrees == -240 or degrees == -300:
		winnings = 35
		color = "Blue"
	elif degrees == -60 or degrees == -120 or degrees == -135 or degrees == -195 or degrees == -255 or degrees == -330:
		winnings = 10
		color = "Green"
	else:
		return "Nothing, You lose"
		
	var message = color + ", you get "+ str(winnings) + " bucks"
	Currency.increase_currrency(winnings)
	hud.update_currency_label()
	return message


func _on_button_pressed() -> void:
	lblerror.text = ""
	$CanvasLayer2/power_btn.visible = false
	$CanvasLayer2/lblPower.visible = false
	spin(int(power))
	$CanvasLayer2/Button.visible = false
	$btnSpin.visible = true
