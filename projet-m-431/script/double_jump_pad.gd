extends AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# lance l'animation d'aparition et de disparition
	play("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass

# quand sont anomtion d'aparition et de disparition ce fini il s'otodetruit
func _on_animation_finished() -> void:
	# ce supprime lui même
	queue_free()
