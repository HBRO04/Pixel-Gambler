extends Node

var card_textures: Dictionary = {}

func _ready():
	# Your order: Diamonds, Hearts, Clubs, Spades
	var suits = ["D", "H", "C", "S"] 
	var ranks = ["A","2","3","4","5","6","7","8","9","10","J","Q","K"]

	var tex = preload("res://assets/cards/pixel_Card_packV2.png")

	var card_width = tex.get_width() / 13
	var card_height = tex.get_height() / 4

	for s in range(4): # 4 suits (rows)
		for r in range(13): # 13 ranks (columns)
			var atlas := AtlasTexture.new()
			atlas.atlas = tex
			atlas.region = Rect2(r * card_width, s * card_height, card_width, card_height)

			var key = ranks[r] + suits[s]  # e.g. "10H", "AS"
			card_textures[key] = atlas
