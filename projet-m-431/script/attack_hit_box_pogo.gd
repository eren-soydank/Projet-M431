extends Node2D
signal pogo

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _pogo():
	emit_signal("pogo")


func _on_area_entered(area: Area2D) -> void:
	if area.name.begins_with("spike"):
		print(area.name)
		_pogo()
