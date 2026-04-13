extends StaticBody2D

@onready var porte = $Area2D/AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	porte.play("closed")
	porte.play("closing")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
