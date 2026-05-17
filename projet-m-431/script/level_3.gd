extends StaticBody2D

@onready var contenu = {"exit_door" : {1:$door1}, "glass" : {0 : $glass0}, "spike" : {}, "chest" : {0 : $chest0}, "sword" : {}}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# initialise tous les spike dans contenu mettre le nombre du dernier spike plus 1 et bien nommer les spike : 
	# spike0, spike2, etc
	var place = 0
	for child in get_children():
		if child.name.begins_with("spike"):
			contenu["spike"][place] = child
			place += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass
	
