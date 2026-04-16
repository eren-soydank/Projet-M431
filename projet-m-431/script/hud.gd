extends Node2D

# on recupere tous les coeur
@onready var coeurs = [$coeur1, $coeur2, $coeur3, $coeur4, $coeur5, $coeur6, $coeur7, $coeur8, $coeur9, $coeur10]
# on recupere le ver
@onready var ver = $ver
# on recupere le text
@onready var label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# on comance j'annimation du ver
	ver.play("idle")
	# pour tous les coeur 
	for coueur in coeurs:
		# lance l'animation d'apparaitre
		coueur.play("appear")

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass
	
func update_potion(nombre_potion):
	# met a jour le nombre de potions afficher
	label.text = "x" + str(nombre_potion)

func update_coeur(nombre):
	# pour toutes les emplacement des coeur (le numeros du coeur - 1)
	for place in range(len(coeurs)):
		# si il dois apparaitre
		if (place + 1) <= nombre and coeurs[place].animation != "appear":
			coeurs[place].play("appear")
		# si il dois disparaitre
		elif (place + 1) > nombre and coeurs[place].animation != "disipar":
			coeurs[place].play("disipar")
