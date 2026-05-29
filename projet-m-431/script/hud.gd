extends Node2D

# on recupere tous les coeur
@onready var hearts = [$heart0, $heart1, $heart2, $heart3, $heart4, $heart5, $heart6, $heart7, $heart8, $heart9]
# on recupere le ver
@onready var glass = $glass0
# on recupere le text
@onready var label = $Label0
@onready var background = $background0

# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	# repositionner l'hud en fonction de la tail de l'ecrant pour garder les coeur en haut a gauche
<<<<<<< HEAD
	background.scale.x = int(max(DisplayServer.screen_get_size().x / 1920, DisplayServer.screen_get_size().y / 1080))
	background.scale.y = int(max(DisplayServer.screen_get_size().x / 1920, DisplayServer.screen_get_size().y / 1080))
	
=======
	global_position.y -= int((DisplayServer.screen_get_size().y -1080) /4)
	global_position.x += int((DisplayServer.screen_get_size().x -1920) /4)
>>>>>>> f6d98a230a8c3786cbfbf0a69ce7a75fbd678db8
	# on comance j'annimation du ver
	glass.play("idle")
	glass.global_position.x -= int((DisplayServer.screen_get_size().x -1920) /4)
	glass.global_position.y -= int((DisplayServer.screen_get_size().y -1080) /4)
	label.global_position.x -= int((DisplayServer.screen_get_size().x -1920) /4)
	label.global_position.y -= int((DisplayServer.screen_get_size().y -1080) /4)
	# pour tous les coeur 
	for heart in hearts:
		# lance l'animation d'apparaitre
		heart.play("appear")
		heart.global_position.x -= int((DisplayServer.screen_get_size().x -1920) /4)
		heart.global_position.y -= int((DisplayServer.screen_get_size().y -1080) /4)

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass
	
func update_glass(glass_number):
	# met a jour le nombre de potions afficher
	label.text = "x" + str(glass_number)

func update_hearts(number):
	# pour toutes les emplacement des coeur (le numeros du coeur - 1)
	for place in range(len(hearts)):
		# si il dois apparaitre
		if (place + 1) <= number and hearts[place].animation != "appear":
			hearts[place].play("appear")
		# si il dois disparaitre
		elif (place + 1) > number and hearts[place].animation != "disipar":
			hearts[place].play("disipar")
