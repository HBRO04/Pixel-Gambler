extends Area2D

var player_in_area: bool = false
var hud : HUD


func _ready() -> void:
	hud = get_tree().get_first_node_in_group("hud")
	hud.update_currency_label()
	
	#connect("body_entered", Callable(self, "_on_body_entered"))
	#connect("body_exited", Callable(self, "_on_body_exited"))
	
func on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_in_area = true
		hud.show_interact_label()
		hud.interact_label("BlackJack")
		
func _on_body_exited(body: Node) ->void:
	if body.is_in_group("player"):
		player_in_area = false
		hud.hide_interact_label()
		
func _process(_delta: float) -> void:
	if player_in_area == true and Input.is_action_just_pressed("interact"):
		hud._button_click_sound()
		hud.starting_activity("BlackJack")
		var timer = Timer.new()
		timer.wait_time = 0.6
		timer.one_shot = true
		add_child(timer)
		timer.start()
		await timer.timeout
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished
		get_tree().change_scene_to_file("res://scenes/betting_screen_black_jack.tscn")
