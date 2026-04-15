extends Node2D



# le niveau actuel
var curent_level = 1
# recuper la scène actuel (changera a chaque niveau)
@onready var curent_scene_level = $niveau1
@onready var hud = $player/HUD
@onready var player = $player

# La fonction qui ce fait une foi au debut du jeu
func _ready() -> void:
	player.connect("utilise_potion", _utilise_potion)
	player.connect("mort", _mort)
	connect_objet()

# Fonction qui c'exécute a chaques frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass


func connect_objet():
	for porte in curent_scene_level.contenu["portes_sortie"].values():
		porte.connect("player_entred", _changeLevel)
	for ver in curent_scene_level.contenu["potions"].values():
		ver.connect("ramasser_potion", _ramasser_potion)
	for pic in curent_scene_level.contenu["pic"].values():
		pic.connect("prendre_degat", _prendre_degat)


#la fonction pour changer de niveau
func _changeLevel(niveau_direction):
	#suprimer la scene du niveau qu'on quitte
	remove_child(curent_scene_level)
	
	# actualiser le niveau actuel
	curent_level = niveau_direction
	# chercher le niveau demander
	var scene = load("res://scènes/niveau" + str(curent_level) + ".tscn")
	# l'instansier
	var instance = scene.instantiate()
	# l'ajouter comme node enfant
	add_child(instance)
	# on met la scene actuel pour que au prochain changement de niveau on ne supprime pas la nle niveau 1
	curent_scene_level = instance
	connect_objet()
	# on tp le joueur au debut du niveau
	player.global_position = player.START_POSITION

func _ramasser_potion(id_potion, nombre):
	curent_scene_level.contenu["potions"].erase(id_potion)
	player.nombre_potion += nombre
	hud.update_potion(player.nombre_potion)

func _prendre_degat(nombre):
	player.prendre_dega(nombre)
	hud.update_coeur(player.vie)
	player.global_position = player.START_POSITION
	
func _utilise_potion():
	hud.update_coeur(player.vie)
	hud.update_potion(player.nombre_potion)

func _mort():
	hud.update_coeur(0)
	player.global_position = player.START_POSITION
	hud.update_coeur(player.vie)
	hud.update_potion(player.nombre_potion)
	call_deferred("_changeLevel", 1)
	
