extends Node2D

# le niveau actuel
var curent_level = 1
# recuper la scène actuel (changera a chaque niveau)
@onready var curent_scene_level = $StaticBody2D

# La fonction qui ce fait une foi au debut du jeu
func _ready() -> void:
	pass


# Fonction qui c'exécute a chaques frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass

#la fonction pour changer de niveau
func changeLevel(niveau):
	#suprimer la scene du niveau qu'on quitte
	remove_child(curent_scene_level)
	
	# actualiser le niveau actuel
	curent_level = niveau
	# chercher le niveau demander
	var scene = load("res://scènes/niveau" + str(curent_level) + ".tscn")
	# l'instansier
	var instance = scene.instantiate()
	# l'ajouter comme node enfant
	add_child(instance)
	# on met la scene actuel pour que au prochain changement de niveau on ne supprime pas la nle niveau 1
	curent_scene_level = instance
	# on tp le joueur au debut du niveau
	$CharacterBody2D.global_position = Vector2(70.0, -80.0)

# fonction qui c'exécute lorce que on pace dans la porte du niveaux 1
# il faudrait faire que les portes de tous les niveau envoi a cette fonction
func _on_static_body_2d_change_level() -> void:
	# passer au prochain niveau
	changeLevel(curent_level + 1)
