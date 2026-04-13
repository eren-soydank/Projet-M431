extends Node2D

@onready var coeurs = [$coeur1, $coeur2, $coeur3, $coeur4, $coeur5, $coeur6, $coeur7, $coeur8, $coeur9, $coeur10]
@onready var ver = $ver/AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for coeur in range(10):
		coeurs[coeur].play("appear")
	ver.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass
