extends CharacterBody2D

@export var speed: float = 200

var hud : HUD
var money = 0
var normal_idle = "idle"
var normale_walking = "walking"

func _ready() -> void:
	hud = get_tree().get_first_node_in_group("hud")
	money = Currency.get_currency()
	hud.update_currency_label()
	hud.textrec_show()
	hud.hud_visible()
	hud.hide_interact_label()
	if Currency.get_currency() > 1000:
		normal_idle = "idle_cool"
		normale_walking = "walking_cool"
	else:
		normal_idle = "idle"
		normale_walking = "walking"

func _physics_process(_delta: float) -> void:
	var input_vector= Vector2.ZERO
	
	#movement input
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	input_vector.normalized()
	
	velocity = input_vector * speed 
	move_and_slide()
	
	if velocity.length() > 0:
		$AnimatedSprite2D.play(normale_walking)
	else:
		$AnimatedSprite2D.play(normal_idle)


func _on_up_pressed() -> void:
	$"../buttonClickSound".play()
	Input.action_press("up")

func _on_left_pressed() -> void:
	$"../buttonClickSound".play()
	Input.action_press("left")

func _on_right_pressed() -> void:
	$"../buttonClickSound".play()
	Input.action_press("right")

func _on_down_pressed() -> void:
	$"../buttonClickSound".play()
	Input.action_press("down")

func _on_up_released() -> void:
	Input.action_release("up")

func _on_left_released() -> void:
	Input.action_release("left")

func _on_right_released() -> void:
	Input.action_release("right")
	

func _on_down_released() -> void:
	Input.action_release("down")


func _on_interactbtn_button_down() -> void:
	$"../buttonClickSound".play()
	Input.action_press("interact")


func _on_interactbtn_button_up() -> void:
	Input.action_release("interact")
