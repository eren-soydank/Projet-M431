extends Node2D

# on recupere tous les coeur
@onready var hearts = [$heart0, $heart1, $heart2, $heart3, $heart4, $heart5, $heart6, $heart7, $heart8, $heart9]
# on recupere le ver
@onready var glass = $glass0
# on recupere le text
@onready var label = $Label0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# on comance j'annimation du ver
	glass.play("idle")
	# pour tous les coeur 
	for heart in hearts:
		# lance l'animation d'apparaitre
		heart.play("appear")

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
