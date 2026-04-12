extends StaticBody2D

# boolean qui regarde si le joueur et dans la porte
var is_player_in = false
# initialiser le signal qui envoi a la fonction dans main
signal change_level

# fonction qui c'exécute une fois au debut
func _ready() -> void:
	pass

# Fonction qui c'exécute a chaques frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	# si le joueur est dans la porte et qu'il appui sur w
	if is_player_in and Input.is_action_just_pressed("interact"):
		# envoi un signale a main pour changer de niveau
		emit_signal("change_level")

# quand un objet entre dans la porte
func _on_area_2d_body_entered(body: Node2D) -> void:
	# si l'objet est le joueur
	if body.name == "CharacterBody2D":
		print("presse W")
		is_player_in = true

# quand un objet sort de la porte
func _on_area_2d_body_exited(body: Node2D) -> void:
	# si l'objet est le joueur
	if body.name == "CharacterBody2D":
		is_player_in = false
