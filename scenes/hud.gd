extends Control
class_name  HUD

@export var lblamount : Label
@export var lblhint : Label
@export var lblintereact : Label
@export var textrec : TextureRect
var gamePaused = false

func update_currency_label():
	var amount = str(Currency.get_currency())
	lblamount.text = amount
	
func interact_label(activity: String):
	lblintereact.text = "Press  space  to interact with "+ activity
	
func hud_invisible():
	lblamount.visible = false
	lblhint.visible = false
	lblintereact.visible = false
	$CanvasLayer/Label2.visible = false
	$CanvasLayer/Sprite2D.visible = false
	
func hud_visible():
	lblamount.visible = true
	lblhint.visible = true
	lblintereact.visible = true
	$CanvasLayer/Label2.visible = true
	$CanvasLayer/Sprite2D.visible = true
	
func hide_interact_label():
	lblintereact.visible = false
	$CanvasLayer/Label2.visible = false
	$CanvasLayer/Sprite2D.visible = false
	
func show_interact_label():
	lblintereact.visible = true
	$CanvasLayer/Label2.visible = true
	$CanvasLayer/Sprite2D.visible = true
	
func starting_activity(activity: String):
	lblintereact.visible = true
	$CanvasLayer/Label2.visible = false
	$CanvasLayer/Sprite2D.visible = false
	lblintereact.text = "Starting " + activity
	
func textRect_hide():
	textrec.visible = false
	
func textrec_show():
	textrec.visible = true

func _on_pausebutton_pressed() -> void:
	print("paused")
	if gamePaused == false:
		gamePaused = false
	else:
		gamePaused = true
		
	get_tree().paused = gamePaused
	
func _button_click_sound():
	$buttonClickSound.play()
	
func _coin_sound():
	$coinSound.play()
	
func _play_bgMusic():
	$casinoAmbiance.play()
