extends Node2D

var coeur_now = 10
# on recupere tous les coeur
@onready var coeurs = [$coeur1, $coeur2, $coeur3, $coeur4, $coeur5, $coeur6, $coeur7, $coeur8, $coeur9, $coeur10]
# on recupere le ver
@onready var ver = $ver
@onready var label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# on comance j'annimation du ver
	ver.play("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass
	
func update_potion(nombre_potion):
	label.text = "x" + str(nombre_potion)

func update_coeur(nombre):
	for place in range(len(coeurs)):
		if (place + 1) > coeur_now and (place + 1) <= nombre:
			coeurs[place].play("idle")
			coeurs[place].play("appear")
		elif (place + 1) <= coeur_now and (place + 1) > nombre:
			coeurs[place].play("empty")
			coeurs[place].play("disipar")
	coeur_now = nombre
