extends StaticBody2D

@onready var contenu = {"portes_sortie" : {0 : $porte0}, "potions" : {}, "pic" : {}, "chest" : {}, "epe" : {}}

# fonction qui c'exécute une fois au debut
func _ready() -> void:
	pass

# Fonction qui c'exécute a chaques frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass
	
