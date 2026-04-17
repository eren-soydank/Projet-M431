extends Area2D

# l'id dois etre le meme que dans son nom (ver1 etc) 
# et que la cle dans le dictioneaire dans du niveau
@export var id = 0
# le nombre de ver ressu lor de la recuperation
@export var number = 1

@onready var sprite = $AnimatedSprite2D

signal pick_up_glass

# Called when the node eSnters the scene tree for the first time.
func _ready() -> void:
	sprite.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass

# quand un obget renre en colision avec lui
func _on_body_entered(body: Node2D) -> void:
	# si c'est un joueur
	if body.name == "player":
		# envoi un signal a main var la fonction _pick_up_glass
		emit_signal("pick_up_glass", id, number)
		# ce supprime soi même
		queue_free()
