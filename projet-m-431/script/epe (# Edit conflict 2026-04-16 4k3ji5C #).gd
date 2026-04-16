extends Area2D

@export var id_epe = 0

@onready var sprite = $AnimatedSprite2D

signal ramasser_epe

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# lance l'animation de tourner sur soi meme
	sprite.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass

# quand un obget renre en colision avec lui
func _on_body_entered(body: Node2D) -> void:
	# si c'est un joueur
	if body.name == "player":
		# envoi un signal a main var la fonction _ramasser_epe
		emit_signal("ramasser_epe", id_epe)
		# ce supprime soi même
		queue_free()
