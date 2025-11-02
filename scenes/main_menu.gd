extends Control

var hud : HUD

func _ready() -> void:
	hud = get_tree().get_first_node_in_group("hud")
	hud.hud_invisible()
	hud.textRect_hide()
	await new_timer(20)
	$sprites/AnimatedSprite2D.play("idle_cool")
	await new_timer(10)
	$sprites/AnimatedSprite2D.play("idle")

func _on_btn_exit_pressed() -> void:
	$buttonClickSound.play()
	get_tree().quit()


func _on_btn_start_pressed() -> void:
	$buttonClickSound.play()
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/casino.tscn")

func new_timer(sekonds: float):
	var timer = Timer.new()
	timer.wait_time = sekonds
	timer.one_shot = true
	add_child(timer)
	timer.start()
	await timer.timeout
