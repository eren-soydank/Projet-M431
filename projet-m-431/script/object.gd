extends Area2D

@onready var sprite = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# lance l'animation de tourner sur soi meme
	sprite.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass

# quand un objet renre en colision avec lui
func _on_body_entered(body: Node2D) -> void:
	# si c'est un joueur
	if body.name == "player":
		body.upgrade_level += 1
		# ce supprime soi même
		queue_free()
