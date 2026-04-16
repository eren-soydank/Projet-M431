extends Area2D

signal prendre_degat

# l'id dois etre le meme que dans son nom (ver1 etc) 
# et que la cle dans le dictioneaire dans du niveau
@export var id = 0
# le nombre de degat infliger (
@export var degat = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass

# quand un objet entre dans la porte
func _on_body_entered(body: Node2D) -> void:
	# si l'objet est le joueur
	if body.name == "player":
		# signal a main var la fonction _prendre_degat
		emit_signal("prendre_degat", degat)
