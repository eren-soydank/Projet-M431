extends Area2D

@export var is_pogo = false
var hase_pogo = false

signal pogo

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.name.begins_with("breakable"):
		body.domage(1)
		_pogo()


func _on_area_entered(area: Area2D) -> void:
	if area.name.begins_with("chest") and not area.is_oppened:
		_pogo()
		area.oppen()
	elif area.name.begins_with("spike"):
		_pogo()

func _pogo():
	if not hase_pogo and is_pogo:
		hase_pogo = true
		emit_signal("pogo")
