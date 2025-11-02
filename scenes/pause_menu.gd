extends Control

@onready var next_scene_path = preload("res://scenes/main_menu.tscn")
var hud : HUD

func _ready() -> void:
	$AnimationPlayer.play("RESET")
	hud = get_tree().get_first_node_in_group("hud")
	

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	$TextureButton.visible = true
	
func pause():
	get_tree().paused = true
	$AnimationPlayer.play("blur")
	
func  test_esc():
	if Input.is_action_just_pressed("escape") and !get_tree().paused :
		pause()
	elif Input.is_action_just_pressed("escape") and get_tree().paused:
		resume()


func _on_btn_resume_pressed() -> void:
	$buttonClickSound.play()
	resume()


func _on_btn_restart_pressed() -> void:
	$buttonClickSound.play()
	resume()
	Currency.set_currency(500)
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().reload_current_scene()


func _on_btn_quit_pressed() -> void:
	$buttonClickSound.play()
	resume()
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
func _process(_delta: float) -> void:
	test_esc()


func _on_texture_button_pressed() -> void:
	$buttonClickSound.play()
	pause()
	$TextureButton.visible = false
